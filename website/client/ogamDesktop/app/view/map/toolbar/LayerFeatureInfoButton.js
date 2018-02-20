/**
 * LayerFeatureInfo Button class associated to the map toolbar
 *
 * @constructor
 * Creates a new LayerFeatureInfo Button
 */
Ext.define('OgamDesktop.view.map.toolbar.LayerFeatureInfoButton', {
    extend: 'Ext.button.Split',
    controller: 'layerfeatureinfobutton',
    requires: [
        'OgamDesktop.view.map.toolbar.LayerFeatureInfoButtonController'
    ],
    alias: 'widget.layerfeatureinfobutton',
    xtype:'layerfeatureinfobutton',
    reference: 'layerFeatureInfoButton',
    iconCls: 'o-map-tools-map-layerfeatureinfo',
    tooltip: this.layerFeatureInfoButtonTooltip,
    toggleGroup : "consultation",
    listeners: {
        toggle: 'onLayerFeatureInfoButtonToggle'
    },
    menu : {
        xtype: 'menu',
        defaults: {
            xtype: 'menucheckitem',
            listeners:{
                checkchange : 'onLayerFeatureInfoButtonMenuItemCheckChange'
            }
        }
    }
});