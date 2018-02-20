describe('ogam field Form Factory Test', function(t){
	
	t.ok(OgamDesktop.ux.form.field.Factory, 'factory class exist');
	
	var record;
	function buildCheckboxFieldConfig(record) {
		return OgamDesktop.ux.form.field.Factory.buildCheckboxFieldConfig(record);
	}
	var buildRadioFieldConfig= OgamDesktop.ux.form.field.Factory.buildRadioFieldConfig;
	t.beforeEach(function (t){
		record = {};
	});
	
	
//	t.it('the factory is a singleton',function (t){
//		var fInst = OgamDesktop.ux.form.field.Factory;
//		t.expect(fInst).toEqual(OgamDesktop.ux.form.field.Factory);
//	});
	
	t.it('build a Checkbox Field', function (t){
		t.afterEach(function (t){
			 delete record.default_value;
		});
		t.expect(buildCheckboxFieldConfig(record).xtype).toBe('checkbox');

		t.it('default Checkbox Field', function (t){
			t.expect(buildCheckboxFieldConfig(record).inputValue).toBeTruthy();
			record.default_value=t.any(Boolean);
			t.expect(buildCheckboxFieldConfig(record).checked).toBeTruthy();
		});
		
		t.it('BOOLEAN Checkbox Field', function (t){
			record.type = 'BOOLEAN';
			buildCheckboxFieldConfig(record);
			t.expect(buildCheckboxFieldConfig(record).inputValue).toBe(true);
			t.expect(buildCheckboxFieldConfig(record).uncheckedValue).toBe(false);
			record.default_value=true;
			t.expect(buildCheckboxFieldConfig(record).checked).toBeTruthy();
			record.default_value=false;
			t.expect(buildCheckboxFieldConfig(record).checked).not.toBeTruthy();

		});
		t.it('string Checkbox Field', function (t){
			record.type = 'STRING';
			t.expect(buildCheckboxFieldConfig(record).inputValue).toBe('1');
			t.expect(buildCheckboxFieldConfig(record).uncheckedValue).toBe('0');
			record.default_value = '1';
			t.expect(buildCheckboxFieldConfig(record).checked).toBe(true);
			record.default_value = 'f';
			t.expect(buildCheckboxFieldConfig(record).checked).not.toBeTruthy();
		});
		t.it('CODE Checkbox Field', function (t){
			t.beforeEach(function (t){
				record.type='CODE';
			});
			t.afterEach(function (t){
				delete record.inputValue;
				delete record.uncheckedValue;
				delete record.default_value;
			});
			t.it('default uncheckedValue checkedValue should be 0 1 ',function(t){
				t.expect(buildCheckboxFieldConfig(record).inputValue).toBe('1');
				t.expect(buildCheckboxFieldConfig(record).uncheckedValue).toBe('0');
				
				t.describe('checked property', function(t){
					record.default_value = 'f';
					t.expect(buildCheckboxFieldConfig(record).checked).not.toBeTruthy();
				
					record.default_value = '1';
					t.expect(buildCheckboxFieldConfig(record).checked).toBe(true);
		
					record.default_value = '0';
					t.expect(buildCheckboxFieldConfig(record).checked).toBe(false);
				});
				
			});
			t.it('code setting only one,use uncheckedValue checkedValue default', function(t){
				record.uncheckedValue = 'F';
				t.expect(buildCheckboxFieldConfig(record).uncheckedValue).not.toBe(record.uncheckedValue);
				t.expect(buildCheckboxFieldConfig(record).uncheckedValue).toBe('0');
				record.uncheckedValue=null;
				record.checkedValue = 'V';
				t.expect(buildCheckboxFieldConfig(record).inputValue).not.toBe(record.checkedValue);
				t.expect(buildCheckboxFieldConfig(record).inputValue).toBe('1');
			});
			t.it('code setting uncheckedValue checkedValue', function(t){
				record.checkedValue = 'O';
				record.uncheckedValue = 'F';
				t.expect(buildCheckboxFieldConfig(record).uncheckedValue).toBe('F');
				t.expect(buildCheckboxFieldConfig(record).inputValue).toBe('O');
				
				t.describe('checked property', function(t){
					record.default_value = '1';
					t.expect(buildCheckboxFieldConfig(record).checked).not.toBeTruthy();
				
					record.default_value = record.checkedValue;
					t.expect(buildCheckboxFieldConfig(record).checked).toBe(true);
				
					record.default_value = record.uncheckedValue;
					t.expect(buildCheckboxFieldConfig(record).checked).toBe(false);
				});
			});
			
		});

	});
	
	t.it('build a radio Field',function (t){
		t.beforeEach(function (t){
			record.type = 'CODE';
			record.options = {'f':'female','m':'male'};
		});
		t.expect(buildRadioFieldConfig(record).xtype).toBe('radiobuttonfield');
		t.it('CODE radio Field', function (t){
			t.isArray(buildRadioFieldConfig(record).items);
			t.describe('items  must be radio buld with these options (and checked)', function(t){
				
				 var a = buildRadioFieldConfig(record).items;
				 t.expect(a).toEqual([{xtype:'radio', inputValue:'f', boxLabel:'female', checked:false},
				                      {xtype:'radio', inputValue:'m', boxLabel:'male', checked:false}]);
				                      
				//f must be checked
				record.value = 'f'
				 a = buildRadioFieldConfig(record).items;
				 t.expect(a).toEqual([{xtype:'radio', inputValue:'f', boxLabel:'female', checked:true},
				                      {xtype:'radio', inputValue:'m', boxLabel:'male', checked:false}])
			});
		});

		
	});
});