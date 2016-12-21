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
//                '<div class="o-navigation-map-table">',
//                    '<div class="o-navigation-map-left-col">',
//                        '<div class="o-navigation-map-img">',
//                            '<tpl for="maps1.urls">',
//                                '<img src="{url}">',
//                            '</tpl>',
//                        '</div>',
//                    '</div>',
//                '</div>',
				'<tpl for="formats">',
					'<div class="o-navigation-fieldset">',
						'<div class="o-navigation-fieldset-title">',
                            '<tpl if="xindex &lt; xcount">',
                                '<div class="o-navigation-fieldset-title-link" onclick="Ext.ComponentQuery.query(\'navigation-mainwin\')[0].openDetails(\'{editURL}\');"></div>',
                            '</tpl>',
                            '<span>{title}</span>',
                        '</div>',
							'<tpl for="fields">',
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
    //							'<tpl if="type == \'IMAGE\'">',
    //								'{[(Ext.isEmpty(values.value) || (Ext.isString(values.value) && Ext.isEmpty(values.value.trim()))) ? \'\' : \'<img title=\"\' + values.label + \'\" src=\"' + window.location.origin + '/img/photos/\' + values.value + \'\">\']}',
    //							'</tpl>',
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
                var data = Ext.decode(response.responseText);
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