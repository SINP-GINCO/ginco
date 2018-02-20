/**
 * This class defines the view that contains 
 * the layers panel and the legends panel.
 */
Ext.define('OgamDesktop.view.map.MapAddonsPanel', {
	extend: 'Ext.tab.Panel',
	xtype: 'map-addons-panel',
	controller: 'mapaddonspanel',
	title: 'Layers & Legends',
	collapsible: true,
	collapsed: false,
	collapseDirection: 'right',
	border: true,
	width: 170,
	maxWidth: 600,
	layout: 'card',
	deferredRender: false,
	defaults: {
		closable: false
	},
	items: [{
		xtype: 'layers-panel'
	},{
		xtype: 'legends-panel'
	}]
});