/**
 * The results grid view. 
 */
Ext.define('OgamDesktop.view.result.GridTab', {
	extend : 'Ext.grid.Panel',
	requires: [
		'OgamDesktop.store.result.Grid',
		'Ext.tip.QuickTipManager'
	],
	xtype: 'results-grid',
	itemId: 'results-grid',
	frame : true,
	closable: false,
	header : false,
	layout : 'fit',
	autoScroll : true,

	/**
	 * @cfg {String} gridViewEmptyText The grid View Empty Text
	 *      (defaults to <tt>'No result...'</tt>)
	 */
	emptyText : 'No result...',
	/**
	 * @cfg {Boolean} hideDetails if true hide the details
	 *      button in the result panel (defaults to false).
	 */
	hideNavigationButton : false,
	/**
	 * @cfg {String} openNavigationButtonTitle The open Grid
	 *      Details Button Title (defaults to
	 *      <tt>'See the details'</tt>)
	 */
	openNavigationButtonTitle : "See the details",
	/**
	 * @cfg {String} openNavigationButtonTip The open Grid
	 *      Details Button Tip (defaults to
	 *      <tt>'Display the row details into the details panel.'</tt>)
	 */
	openNavigationButtonTip : "Display the row details into the details panel.",
	/**
	 * @cfg {String} seeOnMapButtonTitle The see On Map Button
	 *      Title (defaults to <tt>'See on the map'</tt>)
	 */
	seeOnMapButtonTitle : "See on the map",
	/**
	 * @cfg {String} seeOnMapButtonTitle The see On Map Button
	 *      Title (defaults to <tt>'See on the map'</tt>)
	 */
	seeOnMapButtonTip : "Zoom and centre on the location on the map.",
	/**
	 * @cfg {Boolean} hideGridDataEditButton if true hide the
	 *      grid data edit button (defaults to true).
	 */
	hideGridDataEditButton : true,
	/**
	 * @cfg {String} editDataButtonTitle The edit Data Button
	 *      Title (defaults to <tt>'Edit the data'</tt>)
	 */
	editDataButtonTitle : "Edit the data",
	/**
	 * @cfg {String} editDataButtonTitle The edit Data Button
	 *      Title (defaults to <tt>'Edit the data'</tt>)
	 */
	editDataButtonTip : "Go to the edition page to edit the data.",
	/**
	 * @cfg {String} dateFormat The date format for the date
	 *      fields (defaults to <tt>'Y/m/d'</tt>)
	 */
	dateFormat : 'Y/m/d',
	/**
	 * @cfg {Number} gridPageSize The grid page size (defaults
	 *      to <tt>20</tt>)
	 */
	gridPageSize : 20,
	/**
	 * @cfg {Number} tipImageDefaultWidth The tip Image Default Width.
	 *      (Default to 200)
	 */
	tipImageDefaultWidth : 200,

	store: 'result.Grid',
	
	// Columns are added by Grid controller.
	columns: [],
	
	// The paging tools.
	dockedItems: [{
		xtype: 'pagingtoolbar',
		store:  'result.Grid',
		dock: 'bottom',
		displayInfo: true
	}]
});