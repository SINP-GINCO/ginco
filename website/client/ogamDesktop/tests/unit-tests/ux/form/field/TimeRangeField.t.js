/**
 * Test timerangefield field
 * based on Ext.form.field.time test file +/- some specifics cases
 */
describe("OgamDesktop.ux.form.field.TimeRangeField", function(t) {

	var component, makeComponent;
    /**
     * build a date/time
     * @param hour itn hour
     * @param min int minnutes
     * @return Date
     */
    
    function time(hour, min, sec, mi){
    	return new Date(2016,1,1, hour||0, min||0, sec||0, mi||0);
    }
    /**
     * make a Rangetime
     * @return object {startTime: Date, endTime: Date} 
     */
    function timerange (atime){
    	return  makeObjRange(
    		atime[0] instanceof Date ? atime[0]:time(atime[0]),
    		atime[1] instanceof Date ? atime[1] : time(atime[1])
    		);
    }
    
    function makeObjRange(a,b){
    	return {
    		startTime:a,
    		endTime:b
    	};
    }

    t.beforeEach(function(t) {
        makeComponent = function(config) {
            config = config || {};
            Ext.applyIf(config, {
                name: 'test',
                width: 100
            });
            component = new OgamDesktop.ux.form.field.TimeRangeField(config);
        };
    });
    
    t.afterEach(function(t) {
        if (component) {
            component.destroy();
        }
        component = makeComponent = null;
    });

    t.it("should be registered with xtype 'timerangefield'", function(t) {
        component = Ext.create("OgamDesktop.ux.form.field.TimeRangeField", {name: 'test'});
        t.expect(component instanceof OgamDesktop.ux.form.field.TimeRangeField).toBe(true);
        t.expect(Ext.getClass(component).xtype).toBe("timerangefield");
    });

    t.describe("defaults", function(t) {
    	t.beforeEach(function(t) {
            makeComponent();
        });
//        t.it("should have triggerCls = 'x-form-time-trigger'", function(t) {
//            t.expect(componentriggerCls).toEqual('x-form-time-trigger');
//        });
    	t.it("should have multiSelect = false", function(t) {
            t.expect(component.multiSelect).toBe(false);
        });
    	t.it("should have usePrefix = true", function(t) {
    		t.expect(component.usePrefix).toBe(true);
        });
    	t.it("should have authorizeEqualValues = true", function(t) {
        	t.expect(component.authorizeEqualValues).toBe(true);
        });
    	t.it("should have mergeEqualValues = true", function(t) {
    		t.expect(component.mergeEqualValues).toBe(true);
        });
    	t.it("should have autoReverse = true", function(t) {
    		t.expect(component.autoReverse).toBe(true);
        });
    	t.it("should contains format  'H:i'", function(t) {
    		t.expect(component.format).toEqual('H:i');
        });
    	t.it("should have dateSeparator = ' - '", function(t) {
    		t.expect(component.dateSeparator).toEqual(' - ');
        });
    	t.it("should have maxFieldPrefix = '<= '", function(t) {
    		t.expect(component.maxFieldPrefix).toEqual('<= ');
        });
    	t.it("should have minFieldPrefix = '>= '", function(t) {
    		t.expect(component.minFieldPrefix).toEqual('>= ');
        });
    	t.it("should have format = 'H:i'", function(t) {
    		t.expect(component.format).toEqual('H:i');
        });
    	t.it("should have minValue = 00:00", function(t) {
    		t.isDate(component.minValue);
    		t.expect(component.minValue.toLocaleTimeString()).toContain('00:00');
    		//t.expect(component.minValue.toDateString()).not.toEqual((new Date(component.minValue.setMilliseconds(-1))).toDateString());
    		//(getTime() return stimestamp (gmt base) and te date may be not gmt)
        });
    	t.it("should have maxValue = 29:59 ", function(t) {
    		t.isDate(component.maxValue);
    		t.expect(component.maxValue.toLocaleTimeString()).toContain('23:59');
        });
    	t.it("should have minText = 'The times in this field must be equal to or after {0}'", function(t) {
    		t.expect(component.minText).toEqual('The times in this field must be equal to or after {0}');
        });
    	t.it("should have maxText = 'The times in this field must be equal to or before {0}'", function(t) {
    		t.expect(component.maxText).toEqual('The times in this field must be equal to or before {0}');
        });
    	t.it("should have invalidText = 'The value in this field is invalid'", function(t) {
    		t.expect(component.invalidText).toEqual('The value in this field is invalid');
        });
    	t.it("should have reverseText = 'The end time must be posterior to the start time'", function(t) {
    		t.expect(component.reverseText).toEqual("The end time must be posterior to the start time");
        });
    	t.it("should have notEqualText = 'The end time can't be equal to the start time'", function(t) {
    		t.expect(component.notEqualText).toEqual("The end time can't be equal to the start time");
        });
    	t.it("should have altFormats at least 'H:i g:i g:i a h:i a'", function(t) {
    		var list = component.altFormats.split('|');
    		t.expect(list).toContain('H:i');
    		t.expect(list).toContain('g:i');
    		t.expect(list).toContain('g:i a');
    		t.expect(list).toContain('g:i A');
        });
    });


    t.describe("trigger", function(t) {
        t.beforeEach(function(t) {
            makeComponent({
                renderTo: Ext.getBody()
            });
            t.click(component.getTrigger('picker').getEl());
        });
        t.it("should open a OgamDesktop.ux.picker.TimeRange", function(t) {
            t.expect(component.picker instanceof OgamDesktop.ux.picker.TimeRange).toBe(true);
            t.expect(component.picker.hidden).toBe(false);
            t.componentQueryExists('timerangepicker');
        });
        t.it("should have 2 timeField in the picker and 1 bouton", function(t) {
            t.expect(t.cq('timerangepicker timefield').length).toBe(2);
            t.expect(t.cq('timerangepicker button').length).toBe(1);
        });
        
    });

    t.describe("setting values", function(t) {
        t.describe("parsing", function(t){
            t.it("should parse a string value using the format config", function(t) {
                makeComponent({
                    format: 'g:iA',
                    value: '8:32PM'
                });
                t.isTimeEqual(component.getValue().startTime, time(20,32));
                t.expect(component.getValue().startTime).toEqualTime(20,32);//bdd form
                
                t.isTimeEqual(component.getValue().endTime, time(20,32));
                
                t.isRangeTimeEqual(component.getValue(), timerange([time(20,32), time(20,32)]));
            });
            t.it("should parse a string value(range) using the format config", function(t) {
                makeComponent({
                    format: 'g:iA',
                    value: '8:32PM - 9:45PM'
                });
                t.expect(component.getValue().startTime).toEqualTime(20,32);
                t.expect(component.getValue().endTime).toEqualTime(21,45);
               
                // == t.isRangeTimeEqual(component.getValue(), timerange([time(20,32), time(21,45)]));
            });
            
            t.it("should parse a string value(range) using the format config", function(t) {
                makeComponent({
                    format: 'g:iA',
                    value: '8:32PM - 9:45PM'
                });
                t.expect(component.getValue().startTime).toEqualTime(20,32);
                t.expect(component.getValue().endTime).toEqualTime(21,45);
               
                // == t.isRangeTimeEqual(component.getValue(), timerange([time(20,32), time(21,45)]));
            });
            t.it("should parse a string value(range, missing min value) must be null", function(t) {
                makeComponent({
                    format: 'g:iA',
                    value: ' - 9:45PM'
                });
                t.expect(component.getValue()).toBeNull();
               
                // == t.isRangeTimeEqual(component.getValue(), timerange([time(0), time(21,45)]));
            });
            t.it("should parse a string value(range, maxpart) using the format config", function(t) {
                makeComponent({
                    format: 'g:iA',
                    value: '<= 9:45PM'
                });
                t.expect(component.getValue().startTime).toBeNull();
                t.expect(component.getValue().endTime).toEqualTime(21,45);
               
                // == t.isRangeTimeEqual(component.getValue(), timerange([time(0), time(21,45)]));
            });
            t.it("should parse a string value(range, minpart) using the format config", function(t) {
                makeComponent({
                    format: 'g:iA',
                    value: '>= 8:32PM'
                });
                t.expect(component.getValue().startTime).toEqualTime(20,32);
                t.expect(component.getValue().endTime).toBeNull();
               
                // == t.isRangeTimeEqual(component.getValue(), timerange([time20,32), time(23,59)]));
            });
            t.it("should parse a string value using the altFormats config", function(t) {
                makeComponent({
                    format: 'g:i.A',
                    altFormats: 'g.i a',
                    value: '8.32 pm'
                });
                t.isRangeTimeEqual(component.getValue(), timerange([time(20,32), time(20,32)]));
            });

            t.it("should parse a string value using the format config and snap to increment", function(t) {
                makeComponent({
                    snapToIncrement: true,
                    format: 'g:iA',
                    value: '8:32PM'
                });
                t.isRangeTimeEqual(component.getValue(), timerange([time(20,30), time(20,30)]));
            });

            t.it("should parse a string value using the altFormats config and snap to increment", function(t) {
                makeComponent({
                    snapToIncrement: true,
                    format: 'g:i.A',
                    altFormats: 'g.i a',
                    value: '8.32 pm'
                });
                t.isRangeTimeEqual(component.getValue(), timerange([time(20,30), time(20,30)]));
            });
            
            t.describe("with authorizeEqualValues property", function (t) {
	            t.it("should not validate a string value (simple) if authorizeEqualValues is false (and mergeEqualValues:false)", function(t) {
	                makeComponent({
	                	authorizeEqualValues: false,
	                	mergeEqualValues:false,
	                    value: '20:32'
	                });
	                t.expect(component.getErrors().length).toBe(1);
	            });
	            t.it("should not validate a range value (same) if authorizeEqualValues is false (mergeEqualValues:false)", function(t) {
	                makeComponent({
	                	authorizeEqualValues: false,
	                	mergeEqualValues:false,
	                    value: '20:32 - 20:32'
	                });
	                t.expect(component.getErrors().length).toBe(1);
	                t.expect(component.getErrors()[0]).toBe(component.notEqualText);
	            });
            });

            t.it("should sort bound if autoReverse is true", function(t) {
                makeComponent({
                    value: '21:32 - 20:32',
                    autoReverse:true
                });
                t.expect(component.getErrors().length).toBe(0);
                t.expect(component.getValue().startTime).toEqualTime(20,32);
                t.expect(component.getValue().endTime).toEqualTime(21,32);
                // t.isRangeTimeEqual(component.getValue(), timerange([time(20,32), time(21,32)]));
            });
            
            t.it("should not valisate an illegal range (autoReverse:false)", function(t) {
                makeComponent({
                    value: '21:32 - 20:32',
                    autoReverse:false
                });
                t.expect(component.getErrors().length).toBe(1);
                t.expect(component.getErrors()[0]).toBe(component.reverseText);
            });
        });

        t.describe("setValue", function(t){
            t.it("should accept a date object", function(t){
                makeComponent();
                component.setValue(new Date(2010, 10, 5, 9, 46));
                t.isRangeTimeEqual(component.getValue(), timerange([time(9,46), time(9,46)]));
            });
            t.it("should accept a rangetime object", function(t){
                makeComponent();
                component.setValue(makeObjRange(new Date(2010, 10, 5, 9, 46), new Date(2010, 10, 5, 10, 45)));
                t.isRangeTimeEqual(component.getValue(), timerange([time(9,46), time(10,45)]));
            });

            t.it("should accept a string value", function(t){
                makeComponent();
                component.setValue('9:46 AM');
                t.expect(component.getValue().startTime).toEqualTime(9, 46);
                t.expect(component.getValue().startTime).toEqual(component.getValue().endTime);
            });
            t.it("should accept a string (range) value", function(t){
                makeComponent();
                component.setValue('9:46 - 10:45');
                t.expect(component.getValue().startTime).toEqualTime(9, 46);
                t.expect(component.getValue().endTime).toEqualTime(10, 45);
            });
            t.it("should accept a string (range, maxbound) value", function(t){
                makeComponent();
                component.setValue('<= 10:45');
                t.expect(component.getValue().startTime).toBeNull();
                t.expect(component.getValue().endTime).toEqualTime(10, 45);
            });

            t.it("should accept a date object and snap to increment", function(t){
                makeComponent({
                    snapToIncrement: true
                });
                component.setValue(new Date(2010, 10, 5, 9, 46));
                t.expect(component.getValue().startTime).toEqualTime(9, 45);
                t.expect(component.getValue().startTime).toEqual(component.getValue().endTime);
            });

            t.it("should accept a string value and snap to increment", function(t){
                makeComponent({
                    snapToIncrement: true
                });
                component.setValue('9:46 AM');
                t.expect(component.getValue().startTime).toEqualTime(9, 45);
                t.expect(component.getValue().startTime).toEqual(component.getValue().endTime);
            });

            t.it("should accept a null value", function(t){
                makeComponent();
                component.setValue(null);
                t.expect(component.getValue()).toBeNull();
            });

            t.it("should set null if an invalid time string is passed", function(t){
                makeComponent();
                component.setValue('6:::37');
                t.expect(component.getValue()).toBeNull();
            });
            
            t.it("should ignore the date part when setting the value", function(t) {
                makeComponent({
                    minValue: '9:00 AM',
                    maxValue: '5:00 PM'
                });
                // The date year/month/day will be equal to whenever the spec is run
                // But the time field defaults all dates to 2008/01/01.
                var d = new Date();
                d.setHours(12, 0);
                component.setValue(d);
                t.expect(component.isValid()).toBe(true);
            });

            t.describe("inputEl", function (t) {
                t.it("should parse a string value to lookup a record in the store", function(t){
                    makeComponent({
                        minValue: '6:00 AM',
                        maxValue: '8:00 PM',
                        renderTo: document.body
                    });
                    component.setValue('15');//one altFormat is H
                    t.expect(component.inputEl.getValue()).toBe('15:00');
                });
            });

            t.describe("change event", function (t) {
                t.todo("should not fire the change event when the value stays the same - single value", function(t) {
                    var spy = t.createSpy();
                    makeComponent({
                        renderTo: Ext.getBody(),
                        value: '10:00AM',
                        listeners: {
                            change: spy
                        }
                    });
                    component.setValue('10:00AM');
                    t.expect(spy).not.toHaveBeenCalled();
                });

                t.todo("should a day fire the change event when the value changes - single value", function(t) {
                    var spy = t.createSpy();
                    makeComponent({
                        value: '10:00AM',
                        renderTo: Ext.getBody(),
                        listeners: {
                            change: spy
                        }
                    });
                    component.setValue('11:15PM');
                    t.expect(spy).toHaveBeenCalled();
                    t.expect(spy.calls.mostRecent().args[0]).toBe(component);
                    t.expect(spy.calls.mostRecent().args[1]).toEqualTime(23, 15);
                });
            });

            t.describe("setValue and picker content", function(t){
            	t.it("Should have the value in the 2 fields of picker", function(t){
            		makeComponent({
                        renderTo: Ext.getBody()
                    });
            		component.setValue('12:50 - 13:50');
	                component.expand();

	                //t.fieldHasValue('>> timerangepicker timefield:first', '12:50');
	                t.expect(t.cq1('timerangepicker timefield:first').getValue()).toEqualTime(12,50);
	                //t.fieldHasValue('timerangepicker timefield:last', '13:50');
	                t.expect(t.cq1('timerangepicker timefield:last').getValue()).toEqualTime(13,50);
            	});

            	t.it("should call setValue if the ok button of trigger is click", function(t){
            		makeComponent({
            			value:'',
                        renderTo: Ext.getBody()
                    });
	                component.expand();

	                var spy = t.spyOn(component, 'setValue').and.callThrough();

	                t.chain([{
                               // NOTE: "type" contains text to type, not the action target as in other actions
                               type        : '10:50',
                               clearExisting: true,
                               target      : '>> timerangepicker timefield:first',
                               //'>>' use Ext.componentQuery selector @see Siesta.Test.ActionTarget
                               desc        : "Typed in the first field timefield"
                        },{
                            // NOTE: "type" contains text to type, not the action target as in other actions
                            type        : '11:50',
                            clearExisting :true,
                            target      : '>> timerangepicker timefield:last',
                            desc        : "Typed in the second field timefield"
                    },{
                        click        : '>> timerangepicker button'
	                 },function(nex){
	 	                t.expect(spy).toHaveBeenCalled();
	                 }
                    ]);
	                
            	});

            	t.it("Should setValue with range if the 2 field and ok click", function(t){
            		makeComponent({
            			value:'',
                        renderTo: Ext.getBody()
                    });
	                component.expand();
	                t.chain({
                               // NOTE: "type" contains text to type, not the action target as in other actions
                               type        : '10:50',
                               clearExisting: true,
                               target      : '>> timerangepicker timefield:first',
                               desc        : "Typed in the first field timefield"
                        },{
                            // NOTE: "type" contains text to type, not the action target as in other actions
                            type        : '11:50',
                            clearExisting: true,
                            target      : '>> timerangepicker timefield:last',
                            desc        : "Typed in the second field timefield"
	                     },{
	                         click        : '>> timerangepicker button'
	                  },
	                   function (next){
	  	                t.expect(component.getValue().startTime).toEqualTime(10, 50);
		                t.expect(component.getValue().endTime).toEqualTime(11, 50);
	                  }
	                );

            	});
            	t.it("Should set the value to current time if non value is set but field is none set", function(t){
            		makeComponent({
                        renderTo: Ext.getBody()
                    });
	                component.expand();
	                t.expect(component.picker.minField.getValue()).toBe(t.any(Date));
	                t.expect(component.picker.maxField.getValue()).toEqual(component.picker.minField.getValue());
	                t.expect(component.getValue()).toBeNull();
            	});
            	t.it("Should not setValue if the 2 fields is type and picker close/collapse (no ok click)", function(t){
            		makeComponent({
                        renderTo: Ext.getBody()
                    });
	                component.expand();
	                t.chain({
                        // NOTE: "type" contains text to type, not the action target as in other actions
                        type        : '10:50',
                        clearExisting: true,
                        target      : '>> timerangepicker timefield:first',
                        desc        : "Typed in the first field timefield"
		                 },{
		                     // NOTE: "type" contains text to type, not the action target as in other actions
		                     type        : '11:50',
		                     clearExisting: true,
		                     target      : '>> timerangepicker timefield:last',
		                     desc        : "Typed in the second field timefield"
		                  },function(next){
	                		component.collapse();
		            	   t.expect(component.getValue()).toBeNull();
		               }
		             );
	                
            	});
            });
        });
    });
    
    t.describe("submit value", function(t){
        t.it("should use the format as the default", function (t) {
            makeComponent({
                value:new Date(2010, 0, 15, 15, 30),
                format:'g:i a'
            });
            t.expect(component.getSubmitValue()).toBe('3:30 pm');
        });
        
        t.it("should give precedence to submitFormat", function(t){
            makeComponent({
                value: new Date(2010, 0, 15, 15, 45),
                submitFormat: 'H:i:s'
            });
            t.expect(component.getSubmitValue()).toBe('15:45:00');
        });
        
        t.it("should still return null if the value isn't a valid date", function(t){
            makeComponent({
                value: 'wontparse',
                submitFormat: 'H:i'
            });
            t.expect(component.getSubmitValue()).toBeNull();
        });
        
        t.it("should use the format as the default for 2 bound of range", function (t) {
            makeComponent({
                value:makeObjRange(new Date(2010, 0, 15, 15, 45), new Date(2010, 0, 15, 16, 45)),
                format:'H:i:s'
            });
            t.expect(component.getSubmitValue()).toBe('15:45:00 - 16:45:00');
        });
        
        t.it("should use the format as the default for lower bound ", function (t) {
            makeComponent({
                value:makeObjRange(new Date(2010, 0, 15, 15, 45), null),
                format:'H:i:s'
            });
            t.expect(component.getSubmitValue()).toBe('>= 15:45:00');
        });
        
        t.it("should use the format as the default for upper bound ", function (t) {
            makeComponent({
                value:makeObjRange(null, new Date(2010, 0, 15, 15, 45)),
                format:'H:i:s'
            });
            t.expect(component.getSubmitValue()).toBe('<= 15:45:00');
        });
        
        t.it("should use the maxFieldPrefix for submit fomat ", function (t) {
            makeComponent({
                value:makeObjRange(null, new Date(2010, 0, 15, 15, 45)),
                format:'H:i:s',
                maxFieldPrefix:'max '
            });
            t.expect(component.getSubmitValue()).toBe('max 15:45:00');
        });
        
        t.it("should use the minFieldPrefix for submit fomat ", function (t) {
            makeComponent({
                value:makeObjRange( new Date(2010, 0, 15, 15, 45),null),
                format:'H:i:s',
                minFieldPrefix:'min '
            });
            t.expect(component.getSubmitValue()).toBe('min 15:45:00');
        });
        t.it("should give a range submit format if you set a single value and mergeEqualValues is false", function(t){
            makeComponent({
                value: new Date(2010, 0, 15, 15, 45),
                mergeEqualValues:false,
                format:'H:i'
            });
            t.expect(component.getSubmitValue()).toBe('15:45 - 15:45');
        });
        
    });

    t.describe("getModelData", function(t){
        t.it("should use the format as the default", function(t){
            makeComponent({
                name: 'myname',
                value: new Date(2010, 0, 15, 15, 45)
            });
            var modelData = component.getModelData();
            t.expect(modelData.myname.startTime).toEqualTime(15, 45);
            t.expect(modelData.myname.startTime).toEqual(modelData.myname.endTime)
        });

        t.it("should return null if the value isn't a valid date", function(t){
            makeComponent({
                name: 'myname',
                value: 'wontparse',
                submitFormat: 'H:i'
            });
            t.expect(component.getModelData()).toEqual({myname: null});
        });
    });


    t.describe("minValue", function(t) {
        t.describe("minValue config", function(t) {
            t.it("should allow a string, parsed according to the format config", function(t) {
                makeComponent({
                    format: 'g:i.A',
                    minValue: '8:30.AM'
                });
                t.expect(component.minValue).toEqualTime(8,30);
            });

            t.it("should allow times after it to pass validation", function(t) {
                makeComponent({
                    minValue: '8:45 AM',
                    value: '9:15 AM'
                });
                t.expect(component.getErrors().length).toEqual(0);
            });

            t.it("should cause times before it to fail validation", function(t) {
                makeComponent({
                    minValue: '10:45',
                    value: '9:15'
                });
                t.expect(component.getErrors().length).toEqual(1);
                t.expect(component.getErrors()[0]).toEqual(Ext.String.format(component.minText, '10:45'));
            });

            t.it("should fall back to 12AM if the string cannot be parsed", function(t) {
                makeComponent({
                    minValue: 'foopy',
                    value: '12:00 AM'
                });
                t.expect(component.getErrors().length).toEqual(0);
            });

            t.it("should allow a Date object", function(t) {
                makeComponent({
                    minValue: new Date(2010, 1, 1, 8, 30)
                });
                t.expect(component.minValue).toEqualTime(8,30);
            });

            t.it("should be passed to the time picker object", function(t) {
                makeComponent({
                    minValue: '8:45 AM'
                });
                component.expand();
                t.expect(component.getPicker().minField.minValue).toEqualTime(8, 45);
                t.expect(component.getPicker().maxField.minValue).toEqualTime(8, 45);
            });
        });

        t.describe("setMinValue method", function(t) {
            t.it("should allow a string, parsed according to the format config", function(t) {
                makeComponent({
                    format: 'g:i A'
                });
                component.setMinValue('1:15 PM');
                t.expect(component.minValue).toEqualTime(13, 15);
            });

            t.it("should allow times after it to pass validation", function(t) {
                makeComponent({
                    value: '9:15 AM'
                });
                component.setMinValue('7:45 AM');
                t.expect(component.getErrors().length).toEqual(0);
            });

            t.it("should cause times before it to fail validation", function(t) {
                makeComponent({
                    value: '9:15'
                });
                component.setMinValue('10:45');
                t.expect(component.getErrors().length).toEqual(1);
                t.expect(component.getErrors()[0]).toEqual(Ext.String.format(component.minText, '10:45'));
            });

            t.it("should fall back to 12AM if the string cannot be parsed", function(t) {
                makeComponent({
                    value: '12:00 AM'
                });
                component.setMinValue('foopy');
                t.expect(component.getErrors().length).toEqual(0);
            });

            t.it("should allow a Date object", function(t) {
                makeComponent();
                component.setMinValue(new Date(2010, 1, 1, 8, 30));
                t.expect(component.minValue).toEqualTime(8,30);
            });

            t.it("should call the time picker's setMinValue method", function(t) {
                makeComponent();
                component.expand();
                var spyMin = t.spyOn(component.getPicker().minField, 'setMinValue');
                var spyMax = t.spyOn(component.getPicker().maxField, 'setMinValue');
                component.setMinValue('11:15 AM');
                t.expect(spyMin).toHaveBeenCalled();
                t.expect(spyMin.calls.mostRecent().args[0]).toEqualTime(11, 15);
                t.expect(spyMax).toHaveBeenCalled();
                t.expect(spyMax.calls.mostRecent().args[0]).toEqualTime(11, 15);
            });
        });
    });

    t.describe("maxValue", function(t) {
        t.describe("maxValue config", function(t) {
            t.it("should allow a string, parsed according to the format config", function(t) {
                makeComponent({
                    format: 'g:i.A',
                    maxValue: '8:30.PM'
                });
                t.expect(component.maxValue).toEqualTime(20,30);
            });

            t.it("should allow times before it to pass validation", function(t) {
                makeComponent({
                    maxValue: '20:45',
                    value: '19:15'
                });
                t.expect(component.getErrors().length).toEqual(0);
            });

            t.it("should cause times after it to fail validation", function(t) {
                makeComponent({
                    maxValue: '20:45',
                    value: '21:15'
                });
                t.expect(component.getErrors().length).toEqual(1);
                t.expect(component.getErrors()[0]).toEqual(Ext.String.format(component.maxText, '20:45'));
            });

            t.it("should fall back to the end of the day if the string cannot be parsed", function(t) {
                makeComponent({
                    maxValue: 'foopy',
                    value: '23:59'
                });
                t.expect(component.getErrors().length).toEqual(0);
            });

            t.it("should allow a Date object", function(t) {
                makeComponent({
                    maxValue: new Date(2010, 1, 1, 20, 30)
                });
                t.expect(component.maxValue).toEqualTime(20, 30);
            });

            t.it("should be passed to the time picker object", function(t) {
                makeComponent({
                    maxValue: '20:45'
                });
                component.expand();
                t.expect(component.getPicker().minField.maxValue).toEqualTime(20, 45);
                t.expect(component.getPicker().maxField.maxValue).toEqualTime(20, 45);
            });
        });

        t.describe("setMaxValue method", function(t) {
            t.it("should allow a string, parsed according to the format config", function(t) {
                makeComponent({
                    format: 'g:i A'
                });
                component.setMaxValue('1:15 PM');
                t.expect(component.maxValue).toEqualTime(13, 15);
            });

            t.it("should allow times before it to pass validation", function(t) {
                makeComponent({
                    value: '5:15 PM'
                });
                component.setMaxValue('7:45 PM');
                t.expect(component.getErrors().length).toEqual(0);
            });

            t.it("should cause times after it to fail validation", function(t) {
                makeComponent({
                    value: '21:15'
                });
                component.setMaxValue('19:45');
                t.expect(component.getErrors().length).toEqual(1);
                t.expect(component.getErrors()[0]).toEqual(Ext.String.format(component.maxText, '19:45'));
            });

            t.it("should fall back to the end of the day if the string cannot be parsed", function(t) {
                makeComponent({
                    value: '11:59 PM'
                });
                component.setMaxValue('foopy');
                t.expect(component.getErrors().length).toEqual(0);
            });

            t.it("should allow a Date object", function(t) {
                makeComponent();
                component.setMaxValue(new Date(2010, 1, 1, 20, 30));
                t.expect(component.maxValue).toEqualTime(20, 30);
            });

            t.it("should call the time picker's setMaxValue method", function(t) {
                makeComponent();
                component.expand();
                var spyMin = t.spyOn(component.getPicker().minField, 'setMaxValue');
                var spyMax = t.spyOn(component.getPicker().maxField, 'setMaxValue');
                component.setMaxValue('11:15 PM');
                t.expect(spyMin).toHaveBeenCalled();
                t.expect(spyMin.calls.mostRecent().args[0]).toEqualTime(23, 15);
                t.expect(spyMax).toHaveBeenCalled();
                t.expect(spyMax.calls.mostRecent().args[0]).toEqualTime(23, 15);
            });
        });
    });

    t.describe("validation", function(t) {
        t.it("should return the invalidText if an invalid time string is entered via text", function (t) {
            makeComponent();
            component.setRawValue('01:000 AM');
            t.expect(component.getErrors()[0]).toBe(Ext.String.format(component.invalidText, '01:000 AM'));
        });
    });

});