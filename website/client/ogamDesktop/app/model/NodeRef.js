/**
 * This class defines the OgamDesktop NodeRef model.
 */
Ext.define('OgamDesktop.model.NodeRef', {
	extend : 'OgamDesktop.model.Node',
	// childType:'request.object.field.Code',
	fields : [ {
		name : 'isReference',
		type : 'boolean'
	}, {
		name : 'scientificName',
		type : 'string'
	}, {
		name : 'vernacularName',
		type : 'string'
	}, {
		name : 'completeName',
		type : 'string'
	} ]
});