/**
 * Snapping Button class associated to the map toolbar
 *
 * @constructor
 * Creates a new Snapping Button
 */
Ext.define('OgamDesktop.view.map.toolbar.SnappingButton', {
    extend: 'Ext.button.Split',
    controller: 'snappingbutton',
    requires: [
        'OgamDesktop.view.map.toolbar.SnappingButtonController'
    ],
    alias: 'widget.snappingbutton',
    xtype:'snappingbutton',
    reference: 'snappingButton',
    iconCls: 'o-map-tools-map-snapping',
    tooltip: this.snappingButtonTooltip,
    enableToggle: true,
    listeners: {
        toggle: 'onSnappingButtonToggle'
    },
    menu : {
        xtype: 'menu',
        defaults: {
            xtype: 'menucheckitem',
            listeners:{
                checkchange : 'onSnappingButtonMenuItemCheckChange'
            }
        }
    }
});