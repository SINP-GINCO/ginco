/**
 * The main application class. An instance of this class is created by app.js when it calls
 * Ext.application(). This is the ideal place to handle application launch and initialization
 * details.
 */
Ext.define('OgamDesktop.Application', {
	extend: 'Ext.app.Application',
	name: 'OgamDesktop',
	requires: [
		'OgamDesktop.ux.window.Toast'
	],
	models: [
		'map.LayerTreeNode',
		'map.Layer',
		'map.LayerService',
		'request.fieldset.Criterion',
		'request.fieldset.Column',
		'request.object.field.Code'
	],
	stores: [
		'map.LayerTreeNode',
		'result.Grid',
		'CurrentUser'
	],
	controllers: [
		'map.Drawing',
		'map.Layer',
		'map.Main',
		'result.Grid',
		'result.Main',
		'navigation.Main',
		'request.PredefinedRequest'
	],
	views: [
		'main.Main',
		'map.LayersPanel',
		'map.LegendsPanel',
		'map.MainWin',
		'map.MapComponent',
		'request.AdvancedRequest',
		'request.AdvancedRequestController',
		'request.AdvancedRequestModel',
		'request.SaveRequestWindow',
		'request.MainWin',
		'result.MainWin',
		'result.GridTab',
		'navigation.GridDetailsPanel',
		'navigation.MainWin',
		'navigation.Tab'
	],
	session: true,

	//<locale>
    /**
     * @cfg {String} toastTitle_401
     * The toast title used for the 401 status code error (defaults to <tt>'Error 401 : unauthenticated user.'</tt>)
     */
	toastTitle_401: 'Error 401 : unauthenticated user.',

	/**
     * @cfg {String} toastHtml_401
     * The toast html used for the 401 status code error (defaults to <tt>'Please log in again <a href="/user" target="_blank">here</a>.'</tt>)
     */
	toastHtml_401: 'Please log in again <a href="/user" target="_blank">here</a>.',

	/**
     * @cfg {String} toastTitle_404
     * The toast title used for the 404 status code error (defaults to <tt>'Error 404 : page not found.'</tt>)
     */
	toastTitle_404: 'Error 404 : page not found.',

	/**
     * @cfg {String} toastHtml_404
     * The toast html used for the 404 status code error (defaults to <tt>'The resource was not found.'</tt>)
     */
	toastHtml_404: 'The resource was not found.',

	/**
     * @cfg {String} toastTitle_500
     * The toast title used for the 500 status code error (defaults to <tt>'Error 500 : server error.'</tt>)
     */
	toastTitle_500: 'Error 500 : server error.',

	/**
     * @cfg {String} toastHtml_500
     * The toast html used for the 500 status code error (defaults to <tt>'An internal server error does not allow to  meet the demand.'</tt>)
     */
	toastHtml_500: 'An internal server error does not allow to  meet the demand.',

	/**
     * @cfg {String} toastTitle_default
     * The toast title used for the status codes errors differents of the codes 401, 404 and 500 (defaults to <tt>'Error'</tt>)
     */
	toastTitle_default: 'Error',


	/**
     * @cfg {String} toastHtml_default
     * The toast html used for the status codes errors differents of the codes 401, 404 and 500 (defaults to <tt>'See the <a href="http://www.w3schools.com/tags/ref_httpmessages.asp" target="_blank">status codes list</a> for more information.'</tt>)
     */
	toastHtml_default: 'See the <a href="http://www.w3schools.com/tags/ref_httpmessages.asp" target="_blank">status codes list</a> for more information.',
    //</locale>

    /**
     * @method
     *
     * A template method that is called when your application boots. It is called before the
     * {@link Ext.app.Application Application}'s launch function is executed so gives a hook point
     * to run any code before your Viewport is created.
     *
     * @param {Ext.app.Application} application
     *
     * @template
     */
	init: function (application) {

		// Manages the ajax request exceptions
		Ext.Ajax.on('requestexception', function(conn, response, options, e) {
			var statusCode = response.status,
			toastHtml = null,
			toastTitle = null;

			// Sets the default message
			switch (statusCode) {
				case 401 :
					toastTitle = application.toastTitle_401;
					toastHtml = application.toastHtml_401;
					break;
				case 404 :
					toastTitle = application.toastTitle_404;
					toastHtml = application.toastHtml_404;
					break;
				case 500 :
					toastTitle = application.toastTitle_500;
					toastHtml = application.toastHtml_500;
					break;
				default:
					if (response.aborted) {//may be a userchoice don't alert him
						Ext.log({'level':"info"}, 'an connection is aborted');
						return;
					}
					toastTitle = application.toastTitle_default + ' ' + statusCode + ' : ' + response.statusText + '.';
					toastHtml = application.toastHtml_default;
					break;
			}

			// Looks for a error message to add
			if (response.responseText !== undefined) {
				var r = Ext.decode(response.responseText, true);
				if (r != null && r.errorMessage !== undefined) {
					toastHtml += '<br/>' + r.errorMessage;
				}
			}

			// Displays the error message
			OgamDesktop.toast(toastHtml, toastTitle);
		});
	},

	/**
	 * Fonction handling the application launch
	 */
	launch: function () {
		// Loads the grid parameters
		Ext.Loader.loadScript(Ext.manifest.OgamDesktop.requestServiceUrl +'getgridparameters');
	},
	
    /**
     * Return the current user
     */
	getCurrentUser: function(){
		return Ext.getStore('CurrentUser').getAt(0);
	}
});
