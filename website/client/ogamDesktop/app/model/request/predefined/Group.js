/**
 * This class defines the OgamDesktop request predefined group model.
 */
Ext.define('OgamDesktop.model.request.predefined.Group',{
    extend: 'OgamDesktop.model.base',
    requires:[],
    idProperty:'group_id',
    fields:[
        {name: 'group_id', type: 'string', mapping: 0},
        {name: 'label', type: 'string', mapping: 1},
        {name: 'definition', type: 'string', mapping: 2},
        {name: 'position', type: 'int', mapping: 3}
    ],
    proxy:{
        type:'ajax',
        url:Ext.manifest.OgamDesktop.requestServiceUrl +'ajaxgetpredefinedgrouplist',
        reader:{type:'array', rootProperty:'data'}
    }
});