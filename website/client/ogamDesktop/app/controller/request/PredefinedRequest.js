/**
 * This class defines a controller with actions related to predefined request
 */
Ext.define('OgamDesktop.controller.request.PredefinedRequest', {
    extend: 'Ext.app.Controller',
    session:{},

    config: {
        refs: {
            mainView:'app-main',
            predefReqView: 'predefined-request',
            advReqView: 'advanced-request',
            predefinedRequestGridPanel: '#predefinedRequestGridPanel',
            advancedRequestSelector: '#advancedRequestSelector'
        },
        control: {
            'predefined-request button#launchRequest': {//#launchRequest
                click: 'onLaunchRequest'
            },
            'predefined-request': {
                predefinedRequestEdition: 'onPredefinedRequestEdition',
                predefinedRequestDeletion: 'onPredefinedRequestDeletion'
            }
        },
        listen: {
            store: {
                '#CurrentUser': {
                    load: 'onCurrentUserStoreLoad'
                }
            }
        }
    },
    
    routes:{
        'predefined_request':'onPredefinedRequest'
    },

    /**
      * @cfg {String} loadingMsg
      * The loading message (defaults to <tt>'Loading...'</tt>)
      */
    loadingMsg: 'Loading...',
    
    /**
     * @cfg {String} deletionConfirmTitle
     * The deletion confirm title (defaults to <tt>'Deletion of the request :'</tt>)
     */
    deletionConfirmTitle: 'Deletion of the request :',
    
    /**
     * @cfg {String} deletionConfirmMessage
     * The deletion confirm message (defaults to <tt>'Are you sure you want to delete the request?'</tt>)
     */
    deletionConfirmMessage: 'Are you sure you want to delete the request?',
    
    /**
     * @cfg {String} predefinedRequestDeletionErrorTitle
     * The error title when the predefined request deletion fails (defaults to <tt>'Request deletion failed:'</tt>)
     */
    predefinedRequestDeletionErrorTitle: 'Request deletion failed:',

    /**
     * Show the save button into the advanced request view if the user has the rights.
     * @private
     */
    onCurrentUserStoreLoad:function(){
        var user = OgamDesktop.getApplication().getCurrentUser();
        if(user.isAllowed('MANAGE_PUBLIC_REQUEST') || user.isAllowed('MANAGE_OWNED_PRIVATE_REQUEST')){
            this.getAdvReqView().queryById('SaveButtonSeparator').show();
            this.getAdvReqView().queryById('SaveButton').show();
        }
    },
    
    /**
     * Open the predefined request tab
     * @private
     */
    onPredefinedRequest:function(){
        this.getMainView().setActiveItem(this.getPredefReqView());
    },

    /**
     * Manages the predefined request launch button click event:
     *
     * - Set the process,
     * - Reload the form,
     * - Launch the request.
     * @param {button} button The predefined request launch button
     * @param {e} e The click event
     * @param {eopt} eopt The event options
     * @private
     */
    onLaunchRequest:function(button,e, eopt){
        
        var prModel= this.getPredefReqView().lookupReference('requete');
       
        adModel = this.getAdvReqView().getViewModel();
        this.getAdvReqView().lookupReference('processComboBox').setValue(prModel.selection.get('dataset_id'));
        //prModel.selection.getProcessus({success:function(record){adModel.set('currentProcess',record);},scope:adModel});
        
        prModel.selection.reqfieldsets({
            success:function(records){
                var selectedCodes = {};
                this.getPredefReqView().queryById('criteriaFieldset').items.each(function(item){
                    if (item instanceof Ext.form.field.Tag) {
                        selectedCodes[item.getName()] = item.getValueRecords();
                    } else if (item instanceof Ext.form.field.ComboBox) {
                    	if (item.getValue() != null) {
                    		selectedCodes[item.getName()] = new OgamDesktop.model.request.object.field.Code({
                    	        code: item.getValue(),
                    	        label: item.getRawValue()
                    	    });
                    	} else {
                    	    selectedCodes[item.getName()] = null;
                    	}
                    } else if (item instanceof Ext.form.field.Checkbox) {
                        selectedCodes[item.getName()] = item.getSubmitValue();
                    } else {
                        selectedCodes[item.getName()] = item.getValue();
                    }
                });
                this.getAdvReqView().getViewModel().set({
                    'userchoices' : selectedCodes,
                    'fieldsets':records
                });
                this.getAdvReqView().getViewModel().notify();
                this.getAdvancedRequestSelector().reloadForm();
                this.getAdvReqView().down('#SubmitButton').click(e); // submitButton.click(); doesn't work because the event is required (Bug Ext 6.0.1).
            },
            scope:this
        });
        
        this.getMainView().getLayout().setActiveItem('consultationTab');
        this.getAdvReqView().collapse();
    },

    /**
     * Manages the predefined request edit button click event:
     * @param Object record The record corresponding to the button's row
     * @private
     */
    onPredefinedRequestEdition:function(record){
        this.getAdvReqView().expand();
        this.getAdvReqView().mask(this.loadingMsg);
        this.getAdvReqView().lookupReference('processComboBox').setValue(record.get('dataset_id'));
        record.reqfieldsets({
            success:function(records){
                this.getAdvReqView().getViewModel().set({
                    'userchoices' : [],
                    'fieldsets': records,
                    'requestId': record.get('request_id')
                });
                this.getAdvReqView().getViewModel().notify();
                this.getAdvancedRequestSelector().reloadForm();
                this.getAdvReqView().unmask();
            },
            scope:this
        });
        
        this.getMainView().getLayout().setActiveItem('consultationTab');
    },

    /**
     * Manages the predefined request delete button click event
     * @param Object record The record corresponding to the button's row
     * @private
     */
    onPredefinedRequestDeletion:function(record){
        Ext.Msg.confirm(
            this.deletionConfirmTitle,
            this.deletionConfirmMessage,
            function(buttonId, value, opt){
                if(buttonId === 'yes'){
                    // Asks the request deletion to the server
                    this.getPredefinedRequestGridPanel().mask(this.loadingMsg);
                    Ext.Ajax.request({
                        url: Ext.manifest.OgamDesktop.requestServiceUrl + 'predefinedrequest/' + record.get('request_id'),
                        method: 'DELETE',
                        success: function(response, opts) {
                            var result = Ext.decode(response.responseText);
                            if (result.success) {
                                // Remove the request from the predefined request model if necessary
                                var prModelRequest = this.getPredefReqView().getViewModel().get('requete').selection;
                                if (prModelRequest !== null && record.get('request_id') === prModelRequest.get('request_id')) {
                                    this.getPredefReqView().getViewModel().set('requete', null);
                                }
                                // Remove the request from the advanced request model if necessary
                                var modelRequestId = this.getAdvReqView().getViewModel().get('requestId');
                                if (record.get('request_id') === modelRequestId) {
                                    this.getAdvReqView().getViewModel().set('requestId', null);
                                }
                                Ext.getStore('PredefinedRequestTabRequestStore').remove(record);
                            } else {
                                OgamDesktop.toast(result.errorMessage, this.predefinedRequestDeletionErrorTitle);
                            }
                            this.getPredefinedRequestGridPanel().unmask();
                        },
                        failure: function(response, opts) {
                            console.log('server-side failure with status code ' + response.status);
                            this.getPredefinedRequestGridPanel().unmask();
                        },
                        scope :this
                    });
                }
            }, 
            this
        );
    }
});