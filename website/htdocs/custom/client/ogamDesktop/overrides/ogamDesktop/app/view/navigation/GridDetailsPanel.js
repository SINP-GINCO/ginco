Ext.define('Ginco.view.navigation.GridDetailsPanel', {
    override: 'OgamDesktop.view.navigation.GridDetailsPanel',

    panelTitle: 'Results from layer: ',

    /**
     * Configures the detail grid.
     * Overwrite: change the panel title according to the layer where results are returned from
     * @param {Object} initConf The initial configuration
     */
    configureDetailGrid : function(initConf) {
        this.setTitle(this.panelTitle + initConf.layerLabel);
        this.callParent(arguments);
    }

});