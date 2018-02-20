/**
 * This class manages the predefined request view.
 */
Ext.define('OgamDesktop.view.request.PredefinedRequestController', {
	extend : 'Ext.app.ViewController',
	alias : 'controller.predefinedrequest',

    /**
	 * Fonction handling the click event on the reset request button.
	 * @param {Ext.button.Button} b the button
     * @param {Event} e The click event
	 */
    onResetRequest:function(b, e) {
		this.getView().getForm().reset();
	}
});
