/**
 * This class defines the controller with actions related to 
 * tree layers, map layers, map controls.
 */
Ext.define('OgamDesktop.controller.map.Layer',{
    extend: 'Ext.app.Controller',
    requires: [
        'OgamDesktop.view.map.LayersPanel',
        'OgamDesktop.store.map.LayerTreeNode',
        'Ext.window.MessageBox'
    ],

    /**
     * The map panel view.
     * @private
     * @property
     * @type OgamDesktop.view.map.MapPanel
     */
    mapPanel: null,

    /**
     * The current edition field linked to the drawing toolbar
     * @private
     * @property
     * @type OgamDesktop.ux.form.field.GeometryField
     */
    currentEditionField: null,

    /**
     * The previous edition field id linked to the drawing toolbar
     * @private
     * @property
     * @type String
     */
    previousEditionFieldId: null,

    /**
     * A count of events to synchronize
     * @private
     * @property
     * @type Number
     */
    eventCounter : 0,
    
    /**
     * The layer tree nodes store
     * @private
     * @property
     * @type {object}
     */
    layerTreeNodesStore : null,

    /**
     * The refs to get the views concerned
     * and the control to define the handlers of the
     * MapPanel, toolbar and LayersPanel events
     */
    config: {
        refs: {
                layerspanel: 'layers-panel',
                legendspanel: 'legends-panel',
                mappanel: '#map-panel'
        },
        control: {
            'map-mainwin': {
                afterrender: 'afterMapMainWinRendered'
            },
            'layerspanel': {
                storeLoaded: 'afterLayersPanelStoreLoaded'
            }
        }
    },

    /**
     * Manages the afterMapMainWinRendered event :
     *
     *  - Increments the event counter,
     *  - Calls the setupMapAndTreeLayers function if the counter is equal at two.
     * @private
     */
    afterMapMainWinRendered : function() {
        this.eventCounter += 1;
        if (this.eventCounter === 2) {
            this.setupMapAndTreeLayers();
        }
    },

    /**
     * Manages the afterLayersPanelStoreLoaded event :
     *
     *  - Sets the treeStore,
     *  - Increments the event counter,
     *  - Calls the setupMapAndTreeLayers function if the counter is equal at two.
     * @private
     * @param {Object} store The layer tree nodes store
     * @param {Array} records The layer tree nodes records
     */
    afterLayersPanelStoreLoaded : function(store, records) {
        this.layerTreeNodesStore = store;
        this.eventCounter += 1;
        if (this.eventCounter === 2) {
            this.setupMapAndTreeLayers();
        }
    },

   /**
     * Sets up the map and the tree layers
     * @private
     */
    setupMapAndTreeLayers : function() {
        var mapCmp = this.getMappanel().child('mapcomponent');
        var mapTb = this.getMappanel().child('maptoolbar');

        // Creation of the layers collection
        var layersCollection = this.buildLayersCollection();

        // Identifies the request layers
        mapCmp.getController().requestLayers = this.getRequestLayers(layersCollection);

        // Identifies the vector layers
        mapTb.getController().setupButtonsMenus(this.buildVectorLayersCollection());

        // Adds the layers to the map
        var mapLayersCollection = mapCmp.getMap().getLayers(); // ol.Collection
        layersCollection.each(function(item, index, len){
            mapLayersCollection.insertAt(index,item); // keep the static layers (drawingLayer, snappingLayer) to the end
        }, this);

        // Adds the store to the layers tree
        this.getLayerspanel().setConfig('store', this.buildGeoExtStore());
    },

   /**
     * Return an array containing the request layers
     * @private
     * @param {Ext.util.Collection} layersCollection The full map layers collection
     * @return {Array} The request layers
     */
    getRequestLayers: function(layersCollection) {
        var requestLayers = [];
        var addRequestLayerFn = function(item, index, len){
            if(item instanceof ol.layer.Group){
                item.getLayers().forEach(function(el, index, layers){
                    addRequestLayerFn(el, index, layers.length);
                });
            } else {
                if (item.get('activateType') === 'request') {
                    requestLayers.push(item);
                }
            }
        };
        layersCollection.each(addRequestLayerFn);
        return requestLayers;
    },

   /**
     * Adds the children to their parent
     * @param {Array} parentChildrenArray The current node parent children array
     * @param {OgamDesktop.model.map.LayerTreeNode} node The current node
     * @private
     */
    addChild: function (parentChildrenArray, node) {
    	var newNode;
		if (!node.get('isLayer')) { // Create a group
			newNode = new ol.layer.Group({
                text: node.get('label'),
                grpId: node.get('nodeId'),
                visible: !node.get('isHidden'),
                displayInLayerSwitcher: !node.get('isHidden'),
                expanded: node.get('isExpanded'),
                checked: node.get('isChecked'),
                disabled: node.get('isDisabled')
            });
			// Add the child to its parent
			var groupChildren = [];
        	node.getChildren().each(
    			function(child){
    				this.addChild(groupChildren, child);
    			},
    			this
        	);
        	newNode.setLayers(new ol.Collection(groupChildren));
        	parentChildrenArray.push(newNode);
		} else { // Create a layer
	        var mapCmp = this.getMappanel().child('mapcomponent');
	        var curRes = mapCmp.getMap().getView().getResolution();
			var layer = node.getLayer();
            if (!Ext.isEmpty(layer.getLegendService())) {
                this.getLegendspanel().fireEvent('readyToBuildLegend', node, curRes);
            };
            if (!Ext.isEmpty(layer.getViewService())) {
                newNode = this.buildOlLayer(node, curRes);
                // Add the child to its parent
                parentChildrenArray.push(newNode);
            }
		}
	},

   /**
     * Build a layers collection
     * @private
     * @return {Ext.util.MixedCollection} The layers collection
     */
    buildLayersCollection: function() {
        var layersList = [];
        this.layerTreeNodesStore.each(
    		function(node){
    			this.addChild(layersList,node);
    		},
    		this
        );

        var layersCollection = new Ext.util.MixedCollection();
        layersCollection.addAll(layersList);

        return layersCollection;
    },

    /**
     * Adds the vector layers to the provided list
     * @param {Array} vectorLayersArray The list
     * @param {OgamDesktop.model.map.LayerTreeNode} node The current node
     * @private
     */
    addVectorLayer: function (vectorLayersArray, node) {
    	var newNode;
		if (!node.get('isLayer')) { // Node is a group
			// Loop on the group children nodes
        	node.getChildren().each(
    			function(child){
    				this.addVectorLayer(vectorLayersArray, child);
    			},
    			this
        	);
		} else { // Node is a layer
			var layer = node.getLayer();
            if (!Ext.isEmpty(layer.getFeatureService())) {
                // Add the layer to the list
                vectorLayersArray.push(layer);
                // Sort by label
                vectorLayersArray.sort(function(a, b) {
                    return a.data.label.localeCompare(b.data.label);
                });
            }
		}
	},

    /**
     * Build a vector layers collection
     * @private
     * @return {Ext.util.MixedCollection} The vector layers collection
     */
    buildVectorLayersCollection: function() {
        var layersList = [];
        this.layerTreeNodesStore.each(
            function(node){
    			this.addVectorLayer(layersList,node);
    		},
    		this
        );

        var layersCollection = new Ext.util.MixedCollection();
        layersCollection.addAll(layersList);

        return layersCollection;
    },

   /**
     * Build a OpenLayers source
     * @private
     * @param {OgamDesktop.model.map.Layer} layer The layer
     * @param {OgamDesktop.model.map.LayerService} service The service used per the layer
     * @return {ol.source} The OpenLayers source
     */
    buildOlSource: function(layer, service) {
        var serviceType = service.get('config').params.SERVICE;

        var isSameOrigin = function(url1,url2) {
         // will must be url.origine but ie not implement yet :/
            var origin1 = url1.protocol + url1.hostname,
            origin2 = url2.protocol + url2.hostname;
            return (origin1 === origin2);
        };
        var currentPage = window.location || window.document.location;
        var parseUrl = function(link){
            var a = document.createElement('a');
            a.href = link;
            return a;
        };

        switch (serviceType) {
        case 'WMS':
            // Sets the WMS layer source
            var sourceWMSOpts = {};
            sourceWMSOpts['params'] = Ext.apply({
                'layers': layer.get('serviceLayerName')
            }, service.get('config').params);
            sourceWMSOpts['urls'] = service.get('config').urls;

            sourceWMSOpts['crossOrigin'] = 'anonymous';
            //IE 11 et edge "bug", apply restriction (credential not send with anonymous even if sameorigin)
            if ((Ext.isIE11 || Ext.isEdge) && isSameOrigin(parseUrl(sourceWMSOpts['urls'][0]), currentPage )){
                delete sourceWMSOpts.crossOrigin;
            }
            sourceWMSOpts['projection'] = OgamDesktop.map.projection;
            sourceWMSOpts['tileGrid'] = new ol.tilegrid.TileGrid({
                extent : [
                    OgamDesktop.map.x_min,
                    OgamDesktop.map.y_min,
                    OgamDesktop.map.x_max,
                    OgamDesktop.map.y_max
                ],
                resolutions: OgamDesktop.map.resolutions,
                tileSize: [256, 256],
                origin:[OgamDesktop.map.x_min, OgamDesktop.map.y_min]
            });
            return new ol.source.TileWMS(sourceWMSOpts);
        case 'WMTS':
            // Sets the WMTS layer source
            var origin = service.get('config').params.tileOrigin; //coordinates of top left corner of the matrixSet
            var resolutions = service.get('config').params.serverResolutions;
            var matrixIds = [];
            for (var i in resolutions){
                matrixIds[i] = i;
            };
            var tileGrid = new ol.tilegrid.WMTS({
                origin: origin,
                resolutions: resolutions,
                matrixIds: matrixIds
            });
            var sourceWMTSOpts = {};
            sourceWMTSOpts['urls'] = service.get('config').urls;
            sourceWMTSOpts['layer'] = layer.get('serviceLayerName');
            sourceWMTSOpts['tileGrid'] = tileGrid;
            sourceWMTSOpts['matrixSet'] = service.get('config').params.matrixSet;
            sourceWMTSOpts['style'] = service.get('config').params.style;
            sourceWMTSOpts['crossOrigin'] = 'anonymous';
            sourceWMTSOpts['format'] = service.get('config').params.format;
            //IE 11 et edge "bug", apply restriction (credential not send with anonymous even if sameorigin)
            if ((Ext.isIE11 || Ext.isEdge) && isSameOrigin(parseUrl(sourceWMTSOpts['urls'][0]), currentPage )){
                delete sourceWMTSOpts.crossOrigin;
            }
            return new ol.source.WMTS(sourceWMTSOpts);
        default:
            console.error('buildSource: The "' + serviceType + '" service type is not supported.');
        }
    },

   /**
     * Build a OpenLayers layer
     * @private
     * @param {OgamDesktop.model.map.LayerTreeNode} node The node of the layer
     * @param {number} curRes The map current resolution
     * @return {ol.layer.Tile} The OpenLayers layer
     */
    buildOlLayer: function(node, curRes) {
        var olLayerOpts = {};
        var layer = node.getLayer();
        olLayerOpts['source'] = this.buildOlSource(layer, layer.getViewService());
        olLayerOpts['name'] = layer.get('name');
        olLayerOpts['text'] = Ext.isEmpty(node.get('label')) ? layer.get('label') : node.get('label');
        olLayerOpts['opacity'] = layer.get('defaultOpacity');
        olLayerOpts['printable'] = true;
        olLayerOpts['visible'] = !node.get('isHidden');
        olLayerOpts['displayInLayerSwitcher'] = !node.get('isHidden');
        olLayerOpts['checked'] = node.get('isChecked');
        olLayerOpts['checkedGroup'] = node.get('checkedGroup');
        if(!Ext.isEmpty(layer.getMinZoomLevel())){
            olLayerOpts['minResolution'] = layer.getMinZoomLevel().get('resolution');
        }
        if(!Ext.isEmpty(layer.getMaxZoomLevel())){
            olLayerOpts['maxResolution'] = layer.getMaxZoomLevel().get('resolution');
        }
        olLayerOpts['disabled'] = node.get('isDisabled');
        if (layer.isOutOfResolution(curRes)) {
            olLayerOpts['disabled'] = true;
        }
        olLayerOpts['activateType'] = layer.get('activateType').toLowerCase();
        return new ol.layer.Tile(olLayerOpts);
    },

   /**
     * Build a GeoExt tree store
     * @private
     * @return {GeoExt.data.store.LayersTree} The GeoExt tree store
     */
    buildGeoExtStore: function() {
        var mapCmp = this.getMappanel().child('mapcomponent');

        // Create the GeoExt tree store
        var treeLayerStore = Ext.create('GeoExt.data.store.LayersTree', {
            layerGroup: mapCmp.getMap().getLayerGroup(),
            textProperty: 'text',
            folderToggleMode: 'classic',
            inverseLayerOrder: true
        });

        // Filters the layers in function of their 'displayInLayerSwitcher' property
        treeLayerStore.filterBy(function(record) {
            return record.getOlLayer().get('displayInLayerSwitcher') === true;
        }, this);

        // Sets up the store records 
        // See GeoExt.data.model.LayerTreeNode and Ext.data.NodeInterface for the item properties
        // The each fonction doesn't work as expected in extjs v6.0.1.250
        // The getRoot().cascaseBy() function doesn't use the filtered store
        treeLayerStore.getRoot().cascadeBy({
            'after' : function(node) {
                var layer = node.getOlLayer();
                if(layer && layer.get('displayInLayerSwitcher') === true){
                    if (node.childNodes.length > 0){ // Node group
                        if (layer.get('expanded')) {
                            node.expand();
                        };
                    } else { // Node
                        var cls = layer.get('disabled') ? 'dvp-tree-node-disabled' : '';
                        // Radio button transformation
                        if (layer.get("checkedGroup")) {
                            cls += ' checkbox-to-radio';
                        }
                        node.set("cls", cls);
                        node.set("checked", layer.get('checked'));
                    }
                }
            }
        });

        return treeLayerStore;
    }
});