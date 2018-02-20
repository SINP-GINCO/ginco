/** 
 * Fixes return values of Ext.form.field.Tag.findRecord
 * 
 * In 5.0.1 findRecord returns an empty array or an array containing `undefined` when it
 * is expected to return an Ext.data.Model instance or a falsey value.
 * @source https://github.com/JarvusInnovations/sencha-hotfixes/blob/ext/5/0/1/1255/overrides/form/field/Tag/FindRecord.js
 * 
 * Discussion: http://www.sencha.com/forum/showthread.php?290400-tagfield-bind-value
 */
Ext.define('Jarvus.hotfixes.ext.form.field.Tag.FindRecord', {
    override: 'Ext.form.field.Tag',
    compatibility: '5.0.1.1255',

    findRecord: function(field, value) {
        return this.getStore().findRecord(field, value);
    }
});
/**
 * Supresses JS exception thrown from Ext.form.field.Tag
 * 
 * The setLastFocused method was removed in 5.0.1 but tagfield still makes
 * lots of calls to it. It is safe to replace it with an empty function since
 * it doesn't really need to be called anymore.
 * 
 * Discussion: http://www.sencha.com/forum/showthread.php?290400-tagfield-bind-value
 */
/**
 * @source https://github.com/JarvusInnovations/sencha-hotfixes/blob/ext/5/0/1/1255/overrides/selection/Model/DeprecateSetLastFocused.js
 */
Ext.define('Jarvus.hotfixes.ext.selection.Model.DeprecateSetLastFocused', {
    override: 'Ext.selection.Model',
    compatibility: '5.0.1.1255',
    setLastFocused: Ext.emptyFn
});


/***
 * TagField TypeError with multiSelect: false
 *
 * When using the multiSelect: false config in a TagField, Ext 6.0.1. throws an error
 * cf bug EXTJS-19271
 *  dicussion https://www.sencha.com/forum/showthread.php?305344-TagField-TypeError-with-multiSelect-false
 */
Ext.define('Override.form.field.Tag', {    
	override: 'Ext.form.field.Tag',
	compatibility:  '6.0.1.250',
	setValue: function(value, /* private */ add, skipLoad) {
		var me = this,
		    valueStore = me.valueStore,
		    valueField = me.valueField,
		    unknownValues = [],
		    store = me.store,
		    autoLoadOnValue = me.autoLoadOnValue,
		    isLoaded = store.getCount() > 0 || store.isLoaded(),
		    pendingLoad = store.hasPendingLoad(),
		    unloaded = autoLoadOnValue && !isLoaded && !pendingLoad,
		    record, len, i, valueRecord, cls, params;


		if (Ext.isEmpty(value)) {
		    value = Ext.Array.from(value, true); // NEW
		}
		else if (Ext.isString(value) && me.multiSelect) {
		    value = value.split(me.delimiter);
		}
		else {
		    value = Ext.Array.from(value, true);
		}


		if (value && me.queryMode === 'remote' && !store.isEmptyStore && skipLoad !== true && unloaded) {
		    for (i = 0, len = value.length; i < len; i++) {
			record = value[i];
			if (!record || !record.isModel) {
			    valueRecord = valueStore.findExact(valueField, record);
			    if (valueRecord > -1) {
				value[i] = valueStore.getAt(valueRecord);
			    } else {
				valueRecord = me.findRecord(valueField, record);
				if (!valueRecord) {
				    if (me.forceSelection) {
					unknownValues.push(record);
				    } else {
					valueRecord = {};
					valueRecord[me.valueField] = record;
					valueRecord[me.displayField] = record;


					cls = me.valueStore.getModel();
					valueRecord = new cls(valueRecord);
				    }
				}
				if (valueRecord) {
				    value[i] = valueRecord;
				}
			    }
			}
		    }


		    if (unknownValues.length) {
			params = {};
			params[me.valueParam || me.valueField] = unknownValues.join(me.delimiter);
			store.load({
			    params: params,
			    callback: function() {
				me.setValue(value, add, true);
				me.autoSize();
				me.lastQuery = false;
			    }
			});
			return false;
		    }
		}


		// For single-select boxes, use the last good (formal record) value if possible
		if (!me.multiSelect && value.length > 0) {
		    for (i = value.length - 1; i >= 0; i--) {
			if (value[i].isModel) {
			    value = value[i];
			    break;
			}
		    }
		    if (Ext.isArray(value)) {
			value = value[value.length - 1];
		    }
		}


		return me.callSuper([value, add]); // NEW
	}


});