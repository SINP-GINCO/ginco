/**
 * This class is the main view for the application. It is specified in app.js as the
 * "autoCreateViewport" property. That setting automatically applies the "viewport"
 * plugin to promote that instance of this class to the body element.
 */
Ext.define('Ginco.view.main.Main', {
	override: 'OgamDesktop.view.main.Main',

	/**
	 * Initializes the component.
	 */
	initComponent : function() {
		// Customize the title of the html page, defined in client/ogamDesktop/index.html
		// for the other pages it's made in translations files.
		document.title = 'GINCO';
		this.callParent(arguments);
	}
});
