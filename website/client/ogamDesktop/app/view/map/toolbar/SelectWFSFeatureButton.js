/**
 * SelectWFSFeature Button class associated to the map toolbar
 *
 * @constructor
 * Creates a new SelectWFSFeature Button
 */
Ext.define('OgamDesktop.view.map.toolbar.SelectWFSFeatureButton', {
    extend: 'Ext.button.Split',
    controller: 'selectwfsfeaturebutton',
    requires: [
        'OgamDesktop.view.map.toolbar.SelectWFSFeatureButtonController'
    ],
    alias: 'widget.selectwfsfeaturebutton',
    xtype:'selectwfsfeaturebutton',
    reference: 'selectWFSFeatureButton',
    itemId: 'selectWFSFeatureButton',
    iconCls: 'o-map-tools-map-selectWFSFeature',
    tooltip: 'Import a feature from the selected layer',
    toggleGroup : "editing",
    listeners: {
        toggle: 'onSelectWFSFeatureButtonToggle'
    },
    menu : {
        xtype: 'menu',
        defaults: {
            xtype: 'menucheckitem',
            listeners:{
                checkchange : 'onSelectWFSFeatureButtonMenuItemCheckChange'
            }
        }
    }
});