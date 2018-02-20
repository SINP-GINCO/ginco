/**
 * This class defines the OgamDesktop Role model.
 */
Ext.define('OgamDesktop.model.user.Role', {
	extend: 'OgamDesktop.model.base',
	requires:[
	    'OgamDesktop.model.user.Permission'
	],
	idProperty: 'code',
    fields: [
        { name: 'code', type: 'string'},
        { name: 'label', type: 'string'},
        { name: 'definition', type: 'string'}
    ],
    hasMany: [{// See Ext.data.reader.Reader documentation for example
        model: 'OgamDesktop.model.user.Permission',
        name:'permissions',
        associationKey: 'permissions',
        reference:'user.Permission'
    }]
});