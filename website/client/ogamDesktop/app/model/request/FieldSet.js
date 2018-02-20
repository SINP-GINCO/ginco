/**
 * This class defines the OgamDesktop request fieldset model.
 * @deprecated
 */
Ext.define('OgamDesktop.model.request.FieldSet', {
    extend: 'OgamDesktop.model.base',
    requires:['OgamDesktop.model.request.fieldset.Criterion',
              'OgamDesktop.model.request.fieldset.Column'],
    uses:['OgamDesktop.model.request.predefined.PredefinedRequest'],
    idProperty: 'id',
    fields: [
        { name: 'id', type: 'auto' },
        { name: 'label', type: 'string' },
        // See Ext.data.field.Field at config reference documentation for example
        { name: 'processId', reference: {type:'Process', inverse:'fieldsets'}},
        { name: 'request_id', reference: {type:'request.predefined.PredefinedRequest', inverse:'reqfieldsets'}}
        
    ],
    hasMany: [{// See Ext.data.reader.Reader documentation for example
        model: 'OgamDesktop.model.request.fieldset.Criterion',
        name:'criteria',
        associationKey: 'criteria'
    },{
        model: 'OgamDesktop.model.request.fieldset.Column',
        name:'columns',
        associationKey: 'columns'
    }],

    proxy: {
        type: 'ajax',
        url: Ext.manifest.OgamDesktop.requestServiceUrl +'ajaxgetqueryform',
        reader:{
            type:'json',
            rootProperty: 'data'
        },
    noCache:true
    }
});