/**
 * This class manages the legends panel view.
 */
Ext.define('OgamDesktop.view.map.LegendsPanelController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.legendspanel',
    control: {
        'legends-panel': {
            readyToBuildLegend: 'buildLegend'
        }
    },

    /**
     * Build a Legend Object from a 'Layer' store record.
     * @param {Object} curRes The map current resolution
     * @param {OgamDesktop.model.map.Layer} layer The 'Layer' store record
     */
    buildLegend : function(node, curRes) {
        var layer = node.getLayer();
        var service = layer.getLegendService();
    	// Get legends from Geoportail depot
    	if ( service.data.name == 'EN_WMS_Legend'){
    		 var legend = this.getView()
             .add(new Ext.Component({
                 // Extjs 5 doesn't accept '.' into ids
                 id : this.getView().id + layer.get('name').replace(/\./g,'-'),
                 autoEl : {
                     tag : 'div',
                     children : [{
                         tag : 'span',
                         html : layer.get('Label'),
                         cls : 'x-form-item x-form-item-label'
                     },{
                         tag : 'img',
                         src : service.get('config').urls.toString()
                         + layer.get('name')
                         + '/legendes/'
                         + layer.get('name')
                         + '-legend.png'
                     }]
                 }
             }));
    	} else {
          var legend = this.getView()
            .add(new Ext.Component({
                // Extjs 5 doesn't accept '.' into ids
                id : this.getView().id + layer.get('name').replace(/\./g,'-'),
                autoEl : {
                    tag : 'div',
                    children : [{
                        tag : 'span',
                        html : layer.get('Label'),
                        cls : 'x-form-item x-form-item-label'
                    },{
                        tag : 'img',
                        src : service.get('config').urls.toString()
                        + 'LAYER='+ layer.get('serviceLayerName')
                        + '&SERVICE=' + service.get('config').params.SERVICE+ '&VERSION=' + service.get('config').params.VERSION + '&REQUEST=' + service.get('config').params.REQUEST
                        + '&Format=image/png&WIDTH=160'//TODO &HASSLD=' + (layer.get('params').hasSLD ? 'true' : 'false')
                    }]
                }
            }));
    	}

        if (node.get('isDisabled') || node.get('isHidden') || !node.get('isChecked') || layer.isOutOfResolution(curRes)) {
            legend.on('render', function(cmp) {
                cmp.hide();
            });
        }
    },

    /**
     * Convenience function to hide or show a legend by boolean.
     * @param {Array} layers The layers
     * @param {Boolean} visible True to show, false to hide
     */
    setLegendsVisible : function(layers, visible) {

        // The tabPanels must be activated before to show a child component
        var mapAddonsPanel = this.getView().up('tabpanel');
        var activatedCard = mapAddonsPanel.getActiveTab();
        mapAddonsPanel.setActiveItem(this.getView());

        for (var i in layers) {
            var layerName = layers[i].get('name').replace(/\./g,'-');
            var legendCmp = this.getView().getComponent(this.getView().id + layerName);
            if (!Ext.isEmpty(legendCmp)) {
                if (visible === true) {
                    if (layers[i] && !layers[i].isLayerGroup) {
                        if (layers[i].getVisible()){
                            legendCmp.show();
                        } else {
                            legendCmp.hide();
                        }
                    }
                } else {
                    legendCmp.hide();
                }
            }
        }
        // Keep the current activated panel activated
        mapAddonsPanel.setActiveTab(activatedCard);
    }
});