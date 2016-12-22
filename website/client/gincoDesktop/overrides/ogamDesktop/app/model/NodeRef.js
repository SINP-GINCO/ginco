/**
 * This class defines the OgamDesktop NodeRef model.
 */
Ext.define('Ginco.model.NodeRef', {
	override : 'OgamDesktop.model.NodeRef',
	extend : 'OgamDesktop.model.Node',
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