/**
 * This class manages the legends panel view.
 */
Ext.define('Ginco.view.map.MapAddonsPanelController', {
    override: 'OgamDesktop.view.map.MapAddonsPanelController',

    /**
     * Enable and show the request layer(s) and legend(s).
     * Override: Choose if you TOGGLE OR NOT CHECKBOXES (last param true|false)
     * @private
     * @param {OgamDesktop.view.map.MapComponentController} mapCmpCtrl The map component controller
     */
    enableRequestLayersAndLegends: function(mapCmpCtrl) {
        this.toggleLayersAndLegends(true, mapCmpCtrl.requestLayers, false);
    }
});