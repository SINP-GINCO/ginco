Ext.define('Ginco.view.navigation.GridDetailsPanel', {
    override: 'OgamDesktop.view.navigation.GridDetailsPanel',

    panelTitle: 'Results from layer: ',

    /**
     * Configures the detail grid.
     * Overwrite: change the panel title according to the layer where results are returned from
     * Overwrite: change columns width to make them even
     * @param {Object} initConf The initial configuration
     */
    configureDetailGrid : function(initConf) {
        this.setTitle(this.panelTitle + initConf.layerLabel);
        for(i = 0; i<initConf.columns.length; i++){
            initConf.columns[i].flex = 1;
        }
        this.callParent(arguments);
    }

});