/**
 * This class defines the OgamDesktop Provider model.
 */
Ext.define('OgamDesktop.model.user.Provider', {
	extend: 'OgamDesktop.model.base',
	idProperty: 'id',
    fields: [
        { name: 'id', type: 'string'},
        { name: 'label', type: 'string'},
        { name: 'definition', type: 'string'}
    ]
});