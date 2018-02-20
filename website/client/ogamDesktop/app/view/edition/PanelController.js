/**
 * This class manages the edition panel view.
 */
Ext.define('OgamDesktop.view.edition.PanelController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.editionpage',

    /**
     * Fonction handling the featureEditionValidated and the featureEditionCancelled events
     * @private
     */
    onFeatureEditionEnded : function () {
        var editionPanel = this.getView().ownerCt;
        editionPanel.ownerCt.setActiveTab(editionPanel);
    }
});
