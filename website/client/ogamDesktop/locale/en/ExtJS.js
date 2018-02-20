/**
 * missing fr locale, present into de @version extjs6.0.1
 */
Ext.define("Ext.locale.en.panel.Panel", {
	override:'Ext.panel.Panel',
	collapseToolText : 'Reduce',
	expandToolText:'Extend'
});
Ext.Date.patterns = {
    ShortTime: "g:i A",
    LongTime: "g:i:s A"
};
Ext.define("Ext.locale.en.form.field.Time", {
	override:'Ext.form.field.Time'
}, function () {
	Ext.form.field.Time.prototype.altFormats +="|H:i:s|"+Ext.Date.patterns.LongTime;
});