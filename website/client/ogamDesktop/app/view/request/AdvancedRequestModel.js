/**
 * This class is the ViewModel for the advanced request view.
 */
Ext.define('OgamDesktop.view.request.AdvancedRequestModel', {
    extend: 'Ext.app.ViewModel',
    requires: ['OgamDesktop.model.Process',
               'OgamDesktop.model.request.FieldSet'],//needed to fieldsets association !

    // This enables "viewModel: { type: 'advancedrequest' }" in the view:
    alias: 'viewmodel.advancedrequest',
    data: {
        /**
         * @property {OgamDesktop.model.Process} currentProcess The current selected process
         */
        currentProcess:null,
        fieldsets:null,
        userchoices:[],
        requestId:null
    },
    stores: {
        /**
         * @property {Ext.data.JsonStore} processStore The process store
         */
        processStore: {
            storeId:'processStore', // Required by the ViewController for listening
            extend: 'Ext.data.JsonStore',
            autoLoad : true,
            model: 'OgamDesktop.model.Process'
        }
    }
});
