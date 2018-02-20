/**
 * This class manages the save request window view.
 */
Ext.define('OgamDesktop.view.request.SaveRequestWindowController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.saverequestwindow',
    config: {
        listen: {
            component:{
            	'#createRadioField': {
            		change: 'onCreateRadioFieldChange' // The check event doesn't work...
            	},
            	'#editRadioField': {
            		change: 'onEditRadioFieldChange' // The check event doesn't work...
            	},
            	'#requestCombo': {
            		change: 'onRequestComboChange'
            	},
                '#CancelButton': {
                    click:'onCancel'
                },
                '#SaveButton': {
                    click:'onSave'
                },
                '#SaveAndDisplayButton': {
                    click:'onSaveAndDisplay'
                }
            },
            store:{
            	'#SaveRequestWindowRequestComboStore': {
            		beforeload: 'onRequestComboStoreBeforeload',
            		load: 'onRequestComboStoreLoad'
            	}
            }
        }
    },

//<locale>
    /**
     * @cfg {String} loadingText
     * The loading text used when the submit button is pressed(defaults to <tt>'Loading...'</tt>)
     */
    loadingText: 'Loading...',
        /**
     * @cfg {String} toastTitle_invalidForm
     * The toast title used for the invalid form (defaults to <tt>'Form submission:'</tt>)
     */
    toastTitle_invalidForm: 'Form submission:',
    /**
     * @cfg {String} toastHtml_invalidForm
     * The toast html used for the invalid form (defaults to <tt>'The form is not valid. Please correct the error(s).'</tt>)
     */
    toastHtml_invalidForm: 'The form is not valid. Please correct the error(s).',
    /**
     * @cfg {String} invalidValueSubmittedErrorTitle
     * The invalid value submitted error title (defaults to <tt>'Form submission:'</tt>)
     */
    invalidValueSubmittedErrorTitle: 'Form submission:',
    /**
     * @cfg {String} invalidValueSubmittedErrorMessage
     * The invalid value submitted error message (defaults to <tt>'A field appears to contain an error. Please check your filter criteria.'</tt>)
     */
    invalidValueSubmittedErrorMessage: 'A field appears to contain an error. Please check your filter criteria.',
        /**
     * @cfg {String} toastTitle_formSaved
     * The toast form saved title (defaults to <tt>'Form submission:'</tt>)
     */
    toastTitle_formSaved: 'Form submission:',
    /**
     * @cfg {String} toastHtml_formSaved
     * The toast form saved message (defaults to <tt>'Your request has been saved.'</tt>)
     */
    toastHtml_formSaved: 'Your request has been saved.',
//</locale>

    /**
     * Manage the change event on the create radio field.
     * @private
     * @param {Ext.form.field.Field} this
     * @param {Object} newValue The new value
     * @param {Object} oldValue The original value
     * @param {Object} eOpts The options object passed to Ext.util.Observable.addListener.
     */
    onCreateRadioFieldChange: function(radioField , newValue , oldValue , eOpts){
    	if(newValue){ // Checked
    		this.getView().queryById('requestCombo').reset();
        	this.getView().queryById('requestCombo').disable();
        	this.getView().queryById('groupCombo').reset();
    		this.getView().queryById('labelTextField').reset();
    		this.getView().queryById('definitionTextField').reset();
    		this.getView().queryById('privateRadioField').setValue(true); // Private
    		this.getView().fireEvent('requestIdChange', null);
    	}
    },
    
    /**
     * Manage the change event on the edit radio field.
     * @private
     * @param {Ext.form.field.Field} this
     * @param {Object} newValue The new value
     * @param {Object} oldValue The original value
     * @param {Object} eOpts The options object passed to Ext.util.Observable.addListener.
     */
    onEditRadioFieldChange: function(radioField , newValue , oldValue , eOpts){
    	if(newValue){ // Checked
        	this.getView().queryById('requestCombo').enable();
    	}
    },
    
    /**
     * Manage the change event on the request combo field.
     * @private
     * @param {Ext.form.field.Field} this
     * @param {Object} newValue The new value
     * @param {Object} oldValue The original value
     * @param {Object} eOpts The options object passed to Ext.util.Observable.addListener.
     */
    onRequestComboChange: function(combo , newValue , oldValue , eOpts){
		var record = combo.getSelectedRecord();
		if (record !== null) {
        	this.getView().queryById('groupCombo').setValue(record.get('group_id'));
        	this.getView().queryById('labelTextField').setValue(record.get('label'));
        	this.getView().queryById('definitionTextField').setValue(record.get('definition'));
        	if (record.get('is_public')) { 
        		this.getView().queryById('publicRadioField').setValue(true);
	        } else {
	        	this.getView().queryById('privateRadioField').setValue(true);
	        }
	        this.getView().fireEvent('requestIdChange', record.get('request_id'));
	    }
    },
    
    /**
     * Manage the beforeload event on the request combo field store.
     * @private
     * @param {Ext.data.Store} store This Store
     * @param {Ext.data.operation.Operation} operation The Ext.data.operation.Operation object that will be passed to the Proxy to load the Store
     * @param {Object} eOpts The options object passed to Ext.util.Observable.addListener.
     */
	onRequestComboStoreBeforeload: function(store , operation , eOpts){
		if(this.getView().requestId !== null){
			this.mask = new Ext.LoadMask({
                target : this.getView(),
                msg: this.loadingText
            });
            this.mask.show();
        }
	},
	
    /**
     * Manage the load event on the request combo field store.
     * @private
     * @param {Ext.data.Store} this
     * @param {Ext.data.Model[]} records An array of records
     * @param {Boolean} successful True if the operation was successful.
     * @param {Ext.data.operation.Read} operation The 
     * {@link Ext.data.operation.Read Operation} object that was used in the data load call
     * @param {Object} eOpts The options object passed to Ext.util.Observable.addListener.
     */
	onRequestComboStoreLoad: function(store , records , successful , operation , eOpts){
		if(this.getView().requestId !== null){
			this.getView().queryById('editRadioField').setValue(true);
			this.getView().queryById('requestCombo').setValue(this.getView().requestId);
			this.mask.hide();
		}
    },
    
    /**
     * Cancel the current save request if exist and hide the current window.
     * @private
     */
    onCancel: function() {
        if (this.requestConn && this.requestConn !== null) {
            this.requestConn.abort();
        }
        this.getView().close();
    },

    /**
     * Save the current request
     * @private
     */
    onSave: function(){
        this.saveRequest(false);
    },

    /**
     * Save the current request and display it
     * @private
     */
    onSaveAndDisplay: function() {
        this.saveRequest(true);
    },

    /**
     * Save the current request and display it (if asked).
     * @private
     * @param boolean display True to display the predefined request after the saving.
     */
    saveRequest: function(display) {
        var formComponent = this.getView().queryById('SaveForm');
        var form = formComponent.getForm();

        // Checks the validity of the form
        if (form.isValid()) {
            var saveBouton = this.getView().queryById('SaveButton');
            var saveAndDisplayButton = this.getView().queryById('SaveAndDisplayButton');
            var mask = new Ext.LoadMask({
                target : formComponent,
                msg: this.loadingText
            });
            mask.show();
            saveBouton.disable();
            saveAndDisplayButton.disable();

            Ext.Ajax.on(
                'beforerequest', 
                function(conn, options) { this.requestConn = conn; },
                this, 
                { single : true }
            );

            var requestId = form.findField('requestId').getValue();
            var url = Ext.manifest.OgamDesktop.requestServiceUrl + 'predefinedrequest';
            form.submit({
                clientValidation: true,
                submitEmptyText: false,
                //waitMsg: Ext.view.AbstractView.prototype.loadingText,
                autoAbort: true,
                method: requestId === null ? 'POST' : 'PUT',
                url: requestId === null ? url : url + '/' + requestId,
                params: this.getView().requestFieldsValues,
                success: function(form, action) {
                    this.requestConn = null;
                    var requestId = Ext.decode(action.response.responseText).requestId;
                    this.getView().fireEvent('requestIdChange', requestId);
                    mask.hide();
                    saveBouton.enable();
                    saveAndDisplayButton.enable();
                    this.getView().close();
                    OgamDesktop.toast(this.toastHtml_formSaved, this.toastTitle_formSaved);
                    if (display) {
                        var pr = Ext.getCmp('predefined_request');
                        pr.ownerCt.setActiveTab(pr);
                    }
                    Ext.getStore('PredefinedRequestTabRequestStore').reload({
                	    callback: function(records, operation, success) {
                	        if(success && display){
                	        	records.forEach(function(element, index, array) {
                	        	    if(element.get('request_id') === requestId){
                                        pr.queryById('predefinedRequestGridPanel').setSelection(element);
                                        return;
                	        	    }
                	        	});
                	        }
                	    },
                	    scope: this
                    });
                },
                failure: function(form, action) {
                    switch (action.failureType) {
                        case Ext.form.action.Action.CLIENT_INVALID:
                            OgamDesktop.toast(this.invalidValueSubmittedErrorMessage, this.invalidValueSubmittedErrorTitle);
                            break;
                        case Ext.form.action.Action.SERVER_INVALID:
                            OgamDesktop.toast(action.result.errorMessage, this.invalidValueSubmittedErrorTitle);
                            break;
                    }
                    mask.hide();
                    saveBouton.enable();
                    saveAndDisplayButton.enable();
                },
                scope: this
            });
        } else {
            OgamDesktop.toast(this.toastHtml_invalidForm, this.toastTitle_invalidForm);
        }
    }
});