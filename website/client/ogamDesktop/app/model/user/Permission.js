/**
 * This class defines the OgamDesktop Permission model.
 */
Ext.define('OgamDesktop.model.user.Permission', {
	extend: 'OgamDesktop.model.base',
	idProperty: 'code',
    fields: [
        { name: 'code', type: 'string'},
        { name: 'label', type: 'string'}
    ]
});