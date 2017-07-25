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
            // console.log(item);
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
        console.log("build field form custom");
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
        var modeItem = {
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
           

            // Redo the layout
            this.unmask();
            this.dataEditForm.updateLayout();
            
    },
	
	/**
         * Construct a FieldForm from the record
         * @private
         * @param {Ext.data.Record} record The criteria combobox record to add
         * @return a Form Field
         */
        getFieldConfig : function(record) {
                var cls = this.self || OgamDesktop.view.edition.Panel;
                var field = {};
                field.name = record.name;
                field.listeners = {};

                // Set the CSS for the field
                field.itemCls = 'trigger-field o-columnLabelColor';

                // Creates the ext field config
                switch (record.inputType) {
                case 'SELECT':
                case 'PAGINED_SELECT':
                        // The input type SELECT correspond to a data type CODE or ARRAY

                        if (record.type === 'ARRAY') {
                                field.xtype = 'tagfield';
                                field.stacked = true;
                                field.hiddenName = field.name = field.name + '[]';// OGAM-582 - FIXME : needed name with [] to extjs5.0.1  (hiddenName not used in submit ?)?                   
                                field.forceSelection = false;
                                field.filterPickList = false; // pb de perf avec les communes
                                field.triggerOnClick =false;
                        } else {
                                field.xtype = 'combo';
                                field.hiddenName = field.name;
                        }

                        field.triggerAction = 'all';
                        field.typeAhead = true;
                        field.displayField = 'label';
                        field.valueField = 'code';
                        field.emptyText = OgamDesktop.ux.request.RequestFieldSet.prototype.criteriaComboEmptyText;
                        field.queryMode = 'remote';

                        // Fill the list of codes / labels for default values
                        var codes = [];
                        if (record.type === 'ARRAY') {
                                if (record.valueLabel) { // to avoid null pointer
                                        for ( var i = 0; i < record.valueLabel.length; i++) {
                                                codes.push({
                                                        code : record.value[i],
                                                        label : record.valueLabel[i]
                                                });
                                        }
                                }
                        } else {
                                // case of CODE (single value)
                                codes.push({
                                        code : record.value,
                                        label : record.valueLabel
                                });
                        }

                        var storeActionUrl;
                        if (record.subtype === 'DYNAMIC') {
                                storeActionUrl = 'ajaxgetdynamiccodes';
                        } else {
                                storeActionUrl = 'ajaxgetcodes';
                        }
                        var storeConfig = {
                                autoDestroy : true,
                                model:'OgamDesktop.model.request.object.field.Code',
                                remoteFilter: true,
                                proxy:{
                                        type: 'ajax',
                                        url : Ext.manifest.OgamDesktop.requestServiceUrl + storeActionUrl,
                                        extraParams : {
                                                'unit' : record.unit
                                        },
                                        reader: {
                                            type : 'json',
                                            rootProperty : 'data',
                                            totalProperty  : 'total',
                                            successProperty: 'success',
                                            messageProperty: 'errorMessage'
                                        }
                                },
                                data : codes
                        };
                        if (record.inputType === 'PAGINED_SELECT') {
                                field.pageSize = cls.prototype.comboPageSize;
                                storeConfig.pageSize = cls.prototype.comboPageSize;
                        } else {
                                field.pageSize = 0;
                                storeConfig.pageSize = 0;
                        }
                        field.store = new Ext.data.JsonStore(storeConfig);
                        break;
                case 'DATE': // The input type DATE correspond generally to a
                        // data
                        // type DATE
                        field.xtype = 'datefield';
                        field.format = OgamDesktop.ux.request.RequestFieldSet.dateFormat;
                        break;
                case 'TIME': // The input type DATE correspond generally to a
                        // data
                        // type DATE
                        field.xtype = 'timefield';
                        field.format = OgamDesktop.ux.request.RequestFieldSet.timeFormat;
                        break;
                case 'NUMERIC': // The input type NUMERIC correspond generally to a
                        // data
                        // type NUMERIC or RANGE
                        field.xtype = 'numberfield';
                        // If RANGE we set the min and max values
                        if (record.subtype === 'RANGE') {
                                if(Ext.isNumeric(record.params.min)){
                                        field.minValue = record.params.min;
                                }
                                if(Ext.isNumeric(record.params.max)){
                                        field.maxValue = record.params.max;
                                }
                                field.decimalPrecision = (record.params.decimals == null) ? 20 : record.get('params').decimals;
                        }
                        // IF INTEGER we remove the decimals
                        if (record.subtype === 'INTEGER') {
                                field.allowDecimals = false;
                                field.decimalPrecision = 0;
                        }
                        break;
                case 'CHECKBOX':
                        Ext.applyIf(field, OgamDesktop.ux.form.field.Factory.buildCheckboxFieldConfig(record));
                        break;
                case 'RADIO':
                        Ext.applyIf(field, OgamDesktop.ux.form.field.Factory.buildRadioFieldConfig(record));
                        break;
                case 'TEXT':
                        switch (record.subtype) {
                        // OGAM-602 - TODO : BOOLEAN, COORDINATE
                        case 'INTEGER':
                                field.xtype = 'numberfield';
                                field.allowDecimals = false;
                                break;
                        case 'NUMERIC':
                                field.xtype = 'numberfield';
                                break;
                        default: // STRING
                                field.xtype = 'textfield';
                                break;
                        }
                        break;
                case 'GEOM':
                        field.xtype = 'geometryfield';
                        field.hideValidateAndCancelButtons = false;
                        field.listeners['featureEditionValidated'] = 'onFeatureEditionEnded';
                        field.listeners['featureEditionCancelled'] = 'onFeatureEditionEnded';
                        field.zoomToFeatureOnInit = true;
                        field.mapWindowTitle = this.geoMapWindowTitle;
                        field.forceSingleFeature = true;
                        switch (record.subtype) {
                                case 'POINT':
                                        field.hideDrawPointButton = false;
                                        field.hideDrawLineButton = true;
                                        field.hideDrawPolygonButton = true;
                                        field.defaultActivatedDrawingButton = 'point';
                                        break;
                                case 'LINESTRING':
                                        field.hideDrawPointButton = true;
                                        field.hideDrawLineButton = false;
                                        field.hideDrawPolygonButton = true;
                                        field.defaultActivatedDrawingButton = 'line';
                                        break;
                                case 'POLYGON':
                                        field.hideDrawPointButton = true;
                                        field.hideDrawLineButton = true;
                                        field.hideDrawPolygonButton = false;
                                        field.defaultActivatedDrawingButton = 'polygon';
                                        break;
                                default:
                                        field.hideDrawPointButton = false;
                                        field.hideDrawLineButton = false;
                                        field.hideDrawPolygonButton = false;
                                        field.defaultActivatedDrawingButton = 'point';
                                        break;
                        }
                        break;
                case 'TREE':
                        field.xtype = 'treefield';
                        var codes=[];
                        if (record.type === 'ARRAY') {
                                field.multiSelect= field.multiple = true;
                                field.name = field.name + '[]';
                                if (record.valueLabel) { // to avoid null pointer
                                        for ( var i = 0; i < record.valueLabel.length; i++) {
                                                codes.push({
                                                        code : record.value[i],
                                                        label : record.valueLabel[i]
                                                });
                                        }
                                }
                        } else {
                                // case of CODE (single value)
                                codes.push({
                                        code : record.value,
                                        label : record.valueLabel
                                });
                        }
                        
                        field.store = {
                                xtype : 'jsonstore',
                                autoDestroy : true,
                                //autoLoad : true,
                                remoteSort : true,
                                model:'OgamDesktop.model.request.object.field.Code',
                                proxy:{
                                        type:'ajax',
                                        url : Ext.manifest.OgamDesktop.requestServiceUrl + 'ajaxgettreecodes',
                                        extraParams:{unit:record.unit},
                                        reader:{
                                                idProperty : 'code',
                                                totalProperty : 'results',
                                                rootProperty : 'rows'
                                        }
                                },
                                data :  codes
                        };
                        field.treePickerStore = Ext.create('OgamDesktop.store.Tree',{
                                autoLoad : true,
                                root :{
                                        allowDrag : false,
                                        id : '*'
                                },
                                proxy:{
                                        extraParams:{unit:record.unit}
                                }});
                        break;
                case 'TAXREF':
                        field.xtype = 'treefield';
                        var codes=[];
                        if (record.type === 'ARRAY') {
                                field.multiSelect= field.multiple = true;
                                field.name = field.name + '[]';
                                if (record.valueLabel) { // to avoid null pointer
                                        for ( var i = 0; i < record.valueLabel.length; i++) {
                                                codes.push({
                                                        code : record.value[i],
                                                        label : record.valueLabel[i]
                                                });
                                        }
                                }
                        } else {
                                // case of CODE (single value)
                                codes.push({
                                        code : record.value,
                                        label : record.valueLabel
                                });
                        }
                        
                        field.treePickerColumns = {
                                items: [{
                                        xtype: 'treecolumn',
                                        text: OgamDesktop.ux.request.RequestFieldSet.prototype.taxrefLatinNameColumnTitle,
                                        dataIndex: "label"
                                },{
                                        text: OgamDesktop.ux.request.RequestFieldSet.prototype.taxrefVernacularNameColumnTitle,
                                        dataIndex: "vernacularName"
                                },Ext.applyIf({
                                                text: OgamDesktop.ux.request.RequestFieldSet.prototype.taxrefReferentColumnTitle,
                                                dataIndex: "isReference",
                                                flex:0,
                                                witdh:15
                                        }, OgamDesktop.ux.grid.column.Factory.buildBooleanColumnConfig())],
                                defaults : {
                                        flex : 1
                                }
                        };
                        field.listConfig={
                                itemTpl:  [
                                        '<tpl for=".">',
                                        '<div>',
                                                '<tpl if="!Ext.isEmpty(values.isReference) && values.isReference == 0"><i>{label}</i></tpl>',
                                                '<tpl if="!Ext.isEmpty(values.isReference) && values.isReference == 1"><b>{label}</b></tpl>',
                                                '<br/>',
                                                '<tpl if="!Ext.isEmpty(values.vernacularName) && values.vernacularName != null">({vernacularName})</tpl>',
                                        '</div></tpl>'
                                        ]};
                        field.store = {
                                xtype : 'jsonstore',
                                autoDestroy : true,
                                remoteSort : true,
                                model:'OgamDesktop.model.NodeRef',
                                proxy:{
                                        type:'ajax',
                                        url : Ext.manifest.OgamDesktop.requestServiceUrl + 'ajaxgettaxrefcodes',
                                        extraParams:{unit:record.unit},
                                        reader:{
                                                idProperty : 'code',
                                                totalProperty : 'results',
                                                rootProperty : 'rows'
                                        }
                                },
                                data:codes
                        };
                        field.treePickerStore = Ext.create('OgamDesktop.store.Tree',{
                                model:'OgamDesktop.model.NodeRef',
                                root :{
                                        allowDrag : false,
                                        id : '*'
                                },
                                proxy:{
                                        type:'ajax',
                                        url:Ext.manifest.OgamDesktop.requestServiceUrl + 'ajaxgettaxrefnodes',
                                        extraParams:{unit:record.unit}
                                }});
                        break;
                case 'IMAGE':
                        field.xtype = 'imagefield';
                        field.uploadId = this.dataId;
                        field.hiddenName = field.name;
                        break;
                default:
                        field.xtype = 'field';
                        break;
                }

                // Set the default value
                if (!Ext.isEmpty(record.value)) {
                        field.value = record.value;
                }

                // Check if the field is mandatory
                field.allowBlank = !(record.required == true);

                // Add a tooltip
                if (!Ext.isEmpty(record.definition)) {
                        field.listeners['afterrender'] = {
                                fn: function(cmp) {
                                        if (cmp.inputType != 'hidden') {
                                                Ext.QuickTips.register({
                                                        target : cmp.labelEl,
                                                        title : record.label,
                                                        text : record.definition,
                                                        width : 200
                                                });
                                        }
                                },
                                scope : this, 
                                single: true
                        };
                }

                // Set the label
                field.fieldLabel = record.label;
                if (record.required == true) {
                        field.fieldLabel += '<span style="color: rgb(255, 0, 0); padding-left: 2px;">*</span> ';
                        field.cls = ' required';
                }
                else {
                        field.cls = ' not-required';
                }
                
                // Set the width
                field.width = this.fieldWidth;

                if ((this.mode === this.editMode && !Ext.isEmpty(record.editable) && record.editable !== "1")
                                || (this.mode === this.editMode && !Ext.isEmpty(record.isPK) && record.isPK === "1")
                                || (this.mode === this.addMode && !Ext.isEmpty(record.insertable) && record.insertable !== "1")) {
                        // Note: Disabled Fields will not be submitted.
                        field.readOnly = true;
                        //field.editable = false;
                        if (Ext.Array.contains(['combo','tag','treefield'], field.xtype)){
                                field.selectOnFocus = false; //If selectOnFocus is enabled the combo must be editable: true
                                field.typeAhead= false;
                        }
                        field.cls += ' x-item-disabled';
                }
                field.formLabel = record.formLabel;

                if ((this.mode === this.editMode && !Ext.isEmpty(record.editable) && record.editable !== "1")
                      || (this.mode === this.addMode && !Ext.isEmpty(record.insertable) && record.insertable !== "1")) {
                    field.xtype = 'hidden';
                    field.cls = '';
                }
                return field;
        }

     /**
     * Overwrite: Add formLabel to display form groups
     */
//    getFieldConfig : function(record) {
//        console.log("truc");
//        var field = this.callParent(arguments);
//        field.formLabel = record.formLabel;
//        
//        if ((this.mode === this.editMode && !Ext.isEmpty(record.editable) && record.editable !== "1")
//                || (this.mode === this.addMode && !Ext.isEmpty(record.insertable) && record.insertable !== "1")) {
//                field.xtype = 'hidden';
//                field.cls = '';
//    }
//        return field;
//    }

});
