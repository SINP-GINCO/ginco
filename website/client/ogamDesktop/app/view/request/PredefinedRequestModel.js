/**
 * This class is the ViewModel for the advanced request view.
 */
Ext.define('OgamDesktop.view.request.PredefinedRequestModel', {
    extend: 'Ext.app.ViewModel',
    requires: [
        'OgamDesktop.model.request.fieldset.Criterion'
    ],//needed to fieldsets association !
    alias: 'viewmodel.predefinedrequest',
    data:{
        requete:undefined
    }
});
