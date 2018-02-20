/**
 * This class defines the OgamDesktop NodeRef model.
 */
Ext.define('OgamDesktop.model.NodeRef', {
    extend : 'OgamDesktop.model.Node',
    // childType:'request.object.field.Code',
    fields:[
            {name:'isReference' ,type:'boolean'},
            'vernacularName']
});