Ext.define('Ginco.view.edition.Panel', {
    override: 'OgamDesktop.view.edition.Panel',

    // Change width of fields - widths of labels is in sass/src/view/edition/Panel.js
    fieldSetWidth : 700,
    fieldWidth : 650,

    toggleVisibleButton : null,
	/**
	 * @cfg {Ext.form.FieldSet} a group of items.
	 */
	dataGroupFS : null,

    /**
     * Overwrite : add the "toggle visibility for optionel fields" button
     */
    initComponent: function () {

		// Call ogam parent initComponent
		this.callParent(arguments);
        
        // Hide/Show not-required fields button
        this.toggleVisibleButton = new Ext.Button({
            text: this.toggleVisibilityLabel,
            tooltip: this.toggleVisibilityLabel,
            handler: this.toggleOptionnalFieldsVisibility,
            scope: this,
            style: {
                'max-width': '200px',
                marginBottom: '10px',
                marginRight: '15px',
                float: 'right'
            }
        });
        // Insert the button in the already existing panel
        this.dataEditFS.insert(0,this.toggleVisibleButton);

    },

    /**
     * Handler for the toggle visibility button
      */
    toggleOptionnalFieldsVisibility: function () {
        Ext.each(Ext.select('.not-required'), function (item) {
            item.toggle();
        });
        // Redo the layout to adjust height
        this.dataEditForm.updateLayout();
    },

    /**
     * Overwrite: Add form groups
	 * Add the form items to the field form.
	 * @private
	 * @param {Ext.data.Record} records The records
	 */
	buildFieldForm : function(store, records) {
		var dataProvider = '';
		
		// Sorts store fields according to form_format.position
		store.sort('position');
		// Easier to take records from the store : it is sorted
		records = store.data.items;
		
		// Splits items in sub-forms according to the position of metadata.form_format they belongs to
		var formItems = [];
		
		for ( var i = 0; i < records.length; i++) {
          	var formItem = formItems[records[i].data.formPosition];
        	if (!formItem) {
        		// There is not already a form with this position : we create it
        		formItems[records[i].data.formPosition] = [];
        		formItem = formItems[records[i].data.formPosition];
        	}
			var item = this.getFieldConfig(records[i].data, true);
			formItem.push(item);

			if (item.name.indexOf('PROVIDER_ID') !== -1) { // detect the provider id
				dataProvider = item.value;
			}
		}

		for (var i = 1; i < formItems.length; i++) {
			// Do not display an empty form
			if (formItems[i]) {
				if (formItems[i][0].formLabel != "Autres" || formItems[i].length > 3) {
					// Add the form to the form of the form Panel
					this.dataGroupFS = new Ext.form.FieldSet({
						title : "Catégorie : " + formItems[i][0].formLabel,
						items : formItems[i],
						width: '100%'
					});
					this.dataEditForm.insert(this.dataGroupFS);
				}
			}

		}
		
		// Add a hidden field for the mode (ADD or EDIT)
		modeItem = {
			xtype : 'hidden',
			name : 'MODE',
			hiddenName : 'MODE',
			value : this.mode
		};
		this.dataEditForm.add(modeItem);

		// Check the rights on the data for the validate button
		if (this.checkEditionRights) {

			// Look for the provider of the data
			if (OgamDesktop.userProviderId !== dataProvider) {
				this.validateButton.disable();
				this.validateButton.setTooltip(this.dataEditFSValidateButtonDisabledTooltip);
			}
		}

		this.unmask();

		// Redo the layout
		this.dataEditForm.updateLayout();
	},    

    /**
     * Overwrite: Add formLabel to display form groups
     */
    getFieldConfig : function(record) {
        var field = this.callParent(arguments);
        field.formLabel = record.formLabel;
        return field;
    }

});
