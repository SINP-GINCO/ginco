Ext.define('Ginco.view.navigation.GridDetailsPanel', {
    override: 'OgamDesktop.view.navigation.GridDetailsPanel',

    /**
     * Configures the detail grid.
     * Overwrite: change the panel title according to the layer where results are returned from
     * Overwrite: change columns width to make them even
     * @param {Object} initConf The initial configuration
     */
    configureDetailGrid : function(initConf) {
        var layerLabel = initConf.layerLabel;
        if (layerLabel) {
            this.setTitle(this.panelTitle + layerLabel);
            for (i = 0; i<initConf.columns.length; i++) {
                initConf.columns[i].flex = 1;
            }
        } else {
            this.setTitle(this.panelTitleNoResults);
        }
        this.callParent(arguments);
    },
    
    /**
     * Clear the detail grid
     */
	reinitializeDetailGrid : function() {
		this.setTitle("Tableau(x) détaillé(s)");
        var store = new Ext.data.ArrayStore({
            // store configs
            autoDestroy: true,
            // reader configs
            idIndex: 0,
            fields: null,
            data: null
        });
        var columns = [];
		this.reconfigure(store, columns);
		this.collapse();
	}
});