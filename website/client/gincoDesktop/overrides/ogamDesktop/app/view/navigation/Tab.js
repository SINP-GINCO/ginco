Ext.define('Ginco.view.navigation.Tab', {
    override: 'OgamDesktop.view.navigation.Tab',

    /**
     * Initializes the component.
     * @private
     */
    initComponent : function() {
        // Call ogam parent initComponent
        this.callParent();

        // #802 : desactivate card details map
        this.tpl = new Ext.XTemplate(
            '<div>', // Required by the print function
                '<h2 class="o-navigation-title">{title}</h2>',
				'<tpl for="formats">',
					'<div class="o-navigation-fieldset">',
						'<div class="o-navigation-fieldset-title">',
                            '<tpl if="xindex &lt; xcount">',
                                '<div class="o-navigation-fieldset-title-link" onclick="Ext.ComponentQuery.query(\'navigation-mainwin\')[0].openDetails(\'{editURL}\');"></div>',
                            '</tpl>',
                            '<span>Table : {title}</span>',
                        '</div>',
							'<tpl for="fields">',
								'<div class="o-navigation-fieldset-title-form">',
									'<span>Catégorie : {formulaire}</span>',
								'</div>',
								'<tpl for="champs">',
						        	'<tpl switch="inputType">',
						            	'<tpl case="CHECKBOX">',
						            		'<span><b>{label} :</b> {[this.convertBoolean(values)]}</span>',
						            	'<tpl case="IMAGE">',
						            		'{[(Ext.isEmpty(values.value) || (Ext.isString(values.value) && Ext.isEmpty(values.value.trim()))) ? \'\' : \'<img title=\"\' + values.label + \'\" src=\"' + window.location.origin + '/img/photos/\' + values.value + \'\">\']}',
						            	'<tpl default>',
						            		'<tpl if="type ==\'STRING\' && subtype==\'LINK\' && value.length &gt; 0">',
						            			'<span><b>{label} :</b> <a class="external" href="{value}" target="_blank"><span>' + this.linkFieldDefaultText + '</span></a></span>',
						            		'<tpl else>',
						            			'<span><b>{label} :</b> {[(Ext.isEmpty(values.value) || (Ext.isEmpty(values.value.toString().trim()))) ? "-" : values.value.toString()]}</span>',
						            		'</tpl>',
						            	'</tpl>',
						        '</tpl>',
							'</tpl>',
					'</div>',
				'</tpl>',
				'<tpl if="this.hasChildren(values)">',
    				'<tpl for="children">',
                        '<div class="o-navigation-fieldset">',
                        '<div  class="o-navigation-fieldset-title">{title}</div>',
    					'<div>',
    						'<tpl for="data">',
    							'<div class="o-navigation-childfieldset-row">',
    								'<div class="o-navigation-childfieldset-leftcolumn" data-qtip="{1}" onclick="Ext.ComponentQuery.query(\'navigation-mainwin\')[0].openDetails(\'{0}\');"></div>',// OGAM-614 - TODO: Throw an event
    								'<div class="o-navigation-childfieldset-rightcolumn">{1}</div>',
    							'</div>',
    						'</tpl>',
    					'</div>',
    				'</div>',
    				'</tpl>',
				'</tpl>',
            '</div>',
            {
                compiled: true, // compile immediately
                disableFormats: true, // reduce apply time since no formatting
                convertBoolean: function(values){
                	switch(OgamDesktop.ux.data.field.Factory.buildCheckboxFieldConfig(values).convert(values.value)){
						case false: return OgamDesktop.ux.grid.column.Factory.gridColumnFalseText;
						case true: return OgamDesktop.ux.grid.column.Factory.gridColumnTrueText;
						default: return OgamDesktop.ux.grid.column.Factory.gridColumnUndefinedText;
                	}
                },
                hasChildren: function(values){
                    return !Ext.isEmpty(values.children) && values.children.length != 0;
                }
            }
        );
    },


    /**
     * Updates the Details panel body.
     */
    updateDetails : function() {
        Ext.Ajax.request({
            url: Ext.manifest.OgamDesktop.requestServiceUrl +'ajaxgetdetails',
            actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'},
            success :function(response, options){
                var data = Ext.decode(response.responseText).data;
                                
                // Sorts Objects according to property
                function dynamicSort(property) {
                    return function (a,b) {
                        var result = (a[property] < b[property]) ? -1 : (a[property] > b[property]) ? 1 : 0;
                        return result;
                    }
                }
                
                // Sorts objects according to multiple properties
                function dynamicSortMultiple() {
                    /*
                     * save the arguments object as it will be overwritten
                     * note that arguments object is an array-like object
                     * consisting of the names of the properties to sort by
                     */
                    var props = arguments;
                    return function (obj1, obj2) {
                        var i = 0, result = 0, numberOfProperties = props.length;
                        /* try getting a different result from 0 (equal)
                         * as long as we have extra properties to compare
                         */
                        while(result === 0 && i < numberOfProperties) {
                            result = dynamicSort(props[i])(obj1, obj2);
                            i++;
                        }
                        return result;
                    }
                }

                // TODO : add foreach on data.format[i] ?
                data.formats[0].fields.sort(dynamicSortMultiple("formPosition", "label"));   
                
                var formArrays = Object.create(null);

            	// Loop the fields array
                data.formats[0].fields.forEach(function(field) {
                	// Get the form array for this field'formLabel, if any
                	var formArray = formArrays[field.formLabel];
                	if (!formArray) {
                		// There wasn't one, create it
                		formArray = formArrays[field.formLabel] = [];
                	}
                	// Add this entry
                	formArray.push(field);
            	});

                var tab = [];
                for (var key in formArrays) {                    
                    tab.push(Object.create({'formulaire': key, 'champs' :formArrays[key]}));
                    
                }
                
                data.formats[0].fields = tab;
                
                var title = data.title;
                if(data.title.length > this.titleCharsMaxLength){
                    title = data.title.substring(0,this.titleCharsMaxLength) + '...';
                }
                this.setTitle('<div style="width:'+ this.headerWidth + 'px;"'
                    +' ext:qtip="' + data.title + '"'
                    +'>'+title+'</div>');
                this.tpl.overwrite(this.body, data);
            },
            method: 'POST',
            params : {
                id : this.rowId,
                bbox: this.bbox
            },
            scope :this
        });
    }
});