/**
 * This class defines the OgamDesktop predefined request model.
 */
Ext.define('OgamDesktop.model.request.predefined.PredefinedRequest',{
    extend: 'OgamDesktop.model.base',
    requires:['OgamDesktop.model.Process',
              'OgamDesktop.model.request.predefined.Criterion'],
    idProperty:'request_id',
    fields:[
        {name: 'request_id', type: 'int', mapping: 0},
        {name: 'label', type: 'string', mapping: 1},
        {name: 'definition', type: 'string', mapping: 2},
        {name: 'date', type: 'date', dateFormat: 'Y-m-d', mapping: 3},
        {name: 'is_public', type: 'boolean', mapping: 4},
        {name: 'position', type: 'int', mapping: 5},
        {name: 'group_id', type: 'int', mapping: 6},
        {name: 'group_label', type: 'string', mapping: 7},
        {name: 'group_position', type: 'int', mapping: 8},
        {name: 'dataset_id', reference: {type:'Process', role:'processus', unique:true}, mapping: 9},
        {name: 'dataset_label', type: 'string', mapping: 10},
        {name: 'is_read_only', type: 'boolean', mapping: 11}
        // See 'OgamDesktop.model.request.FieldSet' for the associationKey 'reqfieldsets'
    ],
    proxy:{
        type:'ajax',
        url:Ext.manifest.OgamDesktop.requestServiceUrl +'ajaxgetpredefinedrequestlist',
        reader:{type:'array', rootProperty:'data'}
    }
});