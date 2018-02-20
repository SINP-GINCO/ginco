/**
 * This class defines the save request window view.
 */
Ext.define('OgamDesktop.view.request.SaveRequestWindow',{
	extend: 'Ext.window.Window',
	xtype: 'save-request-window',
	requires: [
        'OgamDesktop.store.request.predefined.Group',
        'OgamDesktop.view.request.SaveRequestWindowController',
        'Ext.form.Panel'
    ],
	controller: 'saverequestwindow',
	resizable: true,
	title: 'Save the request',
	requestId : null,

//<locale>
    /**
     * @cfg {String} selectionFieldsetTitle
     * The selection fieldset title (defaults to <tt>'Select the request'</tt>)
     */
    selectionFieldsetTitle: "Select the request",
    /**
     * @cfg {String} createRadioFieldLabel
     * The create radio field label (defaults to <tt>'Create a new request'</tt>)
     */
    createRadioFieldLabel:'Create a new request',
    /**
     * @cfg {String} editRadioFieldLabel
     * The edit radio field label (defaults to <tt>'Edit an existing request'</tt>)
     */
    editRadioFieldLabel:'Edit an existing request',
    /**
     * @cfg {String} resquestComboLabel
     * The resquest combo label (defaults to <tt>'Request'</tt>)
     */
    resquestComboLabel:'Request',
    /**
     * @cfg {String} comboEmptyText
     * The combo empty text (defaults to <tt>'Select...'</tt>)
     */
    comboEmptyText:'Select...',
    /**
     * @cfg {String} formFieldsetTitle
     * The form fieldset title (defaults to <tt>'Request information'</tt>)
     */
    formFieldsetTitle:'Request information',
    /**
     * @cfg {String} groupComboLabel
     * The group combo label (defaults to <tt>'Group *'</tt>)
     */
    groupComboLabel:'Group *',
    /**
     * @cfg {String} labelTextFieldLabel
     * The label text field label (defaults to <tt>'Label *'</tt>)
     */
    labelTextFieldLabel:'Label *',
    /**
     * @cfg {String} definitionTextFieldLabel
     * The definition text field label (defaults to <tt>'Description'</tt>)
     */
    definitionTextFieldLabel:'Description',
    /**
     * @cfg {String} radioFieldContainerLabel
     * The radio field container label (defaults to <tt>'Privacy'</tt>)
     */
    radioFieldContainerLabel:'Privacy',
    /**
     * @cfg {String} privateRadioFieldLabel
     * The private radio field label (defaults to <tt>'Private'</tt>)
     */
    privateRadioFieldLabel:'Private',
    /**
     * @cfg {String} publicRadioFieldLabel
     * The public radio field label (defaults to <tt>'Public'</tt>)
     */
    publicRadioFieldLabel:'Public',
    /**
     * @cfg {String} cancelButtonText
     * The cancel button text (defaults to <tt>'Cancel'</tt>)
     */
	cancelButtonText:'Cancel',
    /**
     * @cfg {String} cancelButtonTooltip
     * The cancel button tooltip (defaults to <tt>'Cancel the request'</tt>)
     */
	cancelButtonTooltip:'Cancel the request',
    /**
     * @cfg {String} saveButtonText
     * The save button text (defaults to <tt>'Save'</tt>)
     */
	saveButtonText:'Save',
    /**
     * @cfg {String} saveButtonTooltip
     * The save button tooltip (defaults to <tt>'Save the request'</tt>)
     */
	saveButtonTooltip:'Save the request',
    /**
     * @cfg {String} saveAndDisplayButtonText
     * The save and display button text (defaults to <tt>'Save and Display'</tt>)
     */
	saveAndDisplayButtonText:'Save and Display',
    /**
     * @cfg {String} saveAndDisplayButtonTooltip
     * The save and display button tooltip (defaults to <tt>'Save and open the predefined requests page'</tt>)
     */
	saveAndDisplayButtonTooltip:'Save and open the predefined requests page',
//</locale>
    
	/**
	 * Initializes the items.
	 */
	initItems: function(){
		
		// Rights management
		var radioFieldContainerHidden = true;
		var privateRadioFieldChecked = false;
		var publicRadioFieldChecked = false;
		var user = OgamDesktop.getApplication().getCurrentUser();
		var isAllowedPublic = user.isAllowed('MANAGE_PUBLIC_REQUEST');
		var isAllowedPrivate = user.isAllowed('MANAGE_OWNED_PRIVATE_REQUEST');
		if(!isAllowedPublic && isAllowedPrivate){
			var privateRadioFieldChecked = true;
		}
		if(isAllowedPublic && !isAllowedPrivate){
			var publicRadioFieldChecked = true;
		}
		if(isAllowedPublic && isAllowedPrivate){
			var radioFieldContainerHidden = false;
			var privateRadioFieldChecked = true;
		}
		
		this.items = new Ext.form.Panel({ // Can't be created with xtype='formpanel'...
			xtype: 'formpanel',
			itemId:'SaveForm',
			defaults: {
				margin: '10 10 10 10',
				padding: '10 10 10 10'
			},
			items: [{
				xtype: 'fieldset',
				title: this.selectionFieldsetTitle,
				items: [{
		            xtype      : 'fieldcontainer',
		            defaultType: 'radiofield',
		            defaults: {
		                flex: 1
		            },
		            layout: 'vbox',
		            items: [{
		            	itemId    : 'createRadioField',
	                    boxLabel  : this.createRadioFieldLabel,
	                    name      : 'savingType',
	                    inputValue: 'CREATION',
	                    margin: '0 20px 0 0',
	                    checked   : true
	                },{
	                    itemId    : 'editRadioField',
	                    boxLabel  : this.editRadioFieldLabel,
	                    name      : 'savingType',
	                    inputValue: 'EDITION'
	                },{
	                	itemId: 'requestCombo',
	                	disabled: true,
						xtype: 'combo',
						name: 'requestId',
						fieldLabel: this.resquestComboLabel,
						allowBlank: false,
						editable:false,
						width: 500,
			    		store: new OgamDesktop.store.request.predefined.PredefinedRequest({
			    			storeId: 'SaveRequestWindowRequestComboStore',
			    			proxy:{
			    				type:'ajax',
			    				url:Ext.manifest.OgamDesktop.requestServiceUrl +'ajaxgeteditablepredefinedrequestlist',
			    				reader:{type:'array', rootProperty:'data'}
			    			}
    					}),
			    		emptyText: this.comboEmptyText,
			    		queryMode: 'local',
			    		displayField: 'label',
			    		valueField: 'request_id'
			    	}]
		        }]
		    },{
				xtype: 'fieldset',
				title: this.formFieldsetTitle,
				defaults: {
	                width: 500
	            },
				items: [{
					itemId: 'groupCombo',
					xtype: 'combo',
					name      : 'groupId',
					fieldLabel: this.groupComboLabel,
					allowBlank: false,
					emptyText: this.comboEmptyText,
					editable:false,
		    		store: new OgamDesktop.store.request.predefined.Group(),
		    		queryMode: 'local',
		    		displayField: 'label',
		    		valueField: 'group_id'
		    	},{
		    		itemId: 'labelTextField',
					xtype: 'textfield',
					name      : 'label',
					maxLength : 50,
					fieldLabel: this.labelTextFieldLabel,
					allowBlank: false
				},{
					itemId: 'definitionTextField',
			        xtype     : 'textareafield',
			        name      : 'definition',
					maxLength : 500,
			        fieldLabel: this.definitionTextFieldLabel
			    },{
		            xtype      : 'fieldcontainer',
		            fieldLabel : this.radioFieldContainerLabel,
		            defaultType: 'radiofield',
		            hidden: radioFieldContainerHidden,
		            width: 300,
		            defaults: {
		                flex: 1
		            },
		            layout: 'hbox',
		            items: [
		                {
		                    itemId: 'privateRadioField',
		                    boxLabel  : this.privateRadioFieldLabel,
		                    name      : 'isPublic',
		                    inputValue: false,
		                    checked   : privateRadioFieldChecked
		                },{
		                	itemId: 'publicRadioField',
		                    boxLabel  : this.publicRadioFieldLabel,
		                    name      : 'isPublic',
		                    inputValue: true,
		                    checked   : publicRadioFieldChecked
		                }
		            ]
		        }]
			}]
		});
		
		this.dockedItems = [{
		    xtype: 'toolbar',
		    dock: 'bottom',
		    items: [{
				itemId: 'CancelButton',
				xtype: 'button',
				text: this.cancelButtonText,
				tooltip : this.cancelButtonTooltip
			},'->',{
				itemId: 'SaveButton',
				xtype: 'button',
				text: this.saveButtonText,
				tooltip : this.saveButtonTooltip
			},{
				itemId: 'SaveAndDisplayButton',
				xtype: 'button',
				text: this.saveAndDisplayButtonText,
				tooltip : this.saveAndDisplayButtonTooltip
			}]
		}],
		
		this.callParent(arguments);
	}
});