/**
 * This class defines the global view that contains the map panel
 * and the map addons panel (= layers panel + legends panel).
 */
Ext.define('OgamDesktop.view.map.MainWin', {
    extend: 'Ext.panel.Panel',
    xtype: 'map-mainwin',
    controller: 'mapmainwin',
    requires:[
        'OgamDesktop.view.map.MainWinController'
    ],
    layout: 'border',
    title: 'Map',
    items: [{
        xtype: 'panel',
        id: 'map-panel',
        region: 'center',
        layout: 'fit',
        dockedItems: [{
            xtype:'maptoolbar',
            dock: 'top'
        }],
        items: [{
            xtype: 'mapcomponent',
            reference: 'mapCmp'
        }]
    },{
        xtype: 'map-addons-panel',
        region: 'east',
        split:{
            tracker:{
                //with tolerance less than splitter width
                tolerance:1
            }
        }
    }]
});