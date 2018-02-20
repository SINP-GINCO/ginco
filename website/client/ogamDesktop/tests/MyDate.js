Class('Ogam.Test.BDD.Expectation', {
    isa:'Siesta.Test.BDD.Expectation',
    methods : {
        
        /**
         * This assertion passes when the 2 provided dates are equal and fails otherwise.
         * 
         * It has a synonym: `isDateEq`
         * 
         * @param {Date} got The 1st date to compare
         * @param {Date} expectedDate The 2nd date to compare
         * @param {String} [description] The description of the assertion
         */

    	toEqualTime : function(hour, minute, second, ms) {
            var actual = this.value;
            var R = Siesta.Resource('Siesta.Test.BDD.Expectation');
            
            var isTime  = actual instanceof this.t.global.Date &&
                   actual.getHours() === hour &&
                   actual.getMinutes() === (minute || 0) &&
                   actual.getSeconds() === (second || 0) &&
                   actual.getMilliseconds() === (ms || 0);
            

            this.process(isTime, {
                descTpl             : R.get('expectText') +' {got} {!not}' + R.get('toBeEqualToText') + ' {need}',
                assertionName       : 'expect(got).toEqual(need)',
                need                : (new Date(hour, minute ||0, second||0, ms||0)).toTimeString(),
                got                : actual instanceof this.t.global.Date ?actual.toTimeString(): actual,
                needDesc            : this.isNot ? R.get('needNotText') : R.get('needText')
            });
        }
    }
});

Class('Ogam.Test',{
	isa:'Siesta.Test.ExtJS',
	has:{
		expectationClass:Ogam.Test.BDD.Expectation
	},
	methods:{
		compareTime:function(a, b){
			return (a instanceof this.global.Date) &&
			(b instanceof this.global.Date) &&
			a.getHours() === b.getHours() &&
			a.getMinutes() === b.getMinutes() &&
			a.getSeconds() === b.getSeconds() &&
			a.getMilliseconds() === b.getMilliseconds();
		},

		isTimeEqual:function(a,b,description){
			var me = this;
            var R = Siesta.Resource('Siesta.Test.Date');
            var iok =me.compareTime(a,b);

            if (iok) {
                this.pass(description, {
                    descTpl         : '{got} ' + R.get('isEqualTo') + ' {expectedDate}',
                    got             : a,
                    expectedDate    : b
                });
            } else {
                this.fail(description, {
                    assertionName   : 'isTimeEqual',
                    got             : a ? a.toTimeString() + a.getMilliseconds() : '',
                    gotDesc         : R.get('Got'),
                    
                    need            : b.toTimeString() +b.getMilliseconds()
                });
            }
		},
		isRangeTimeEqual:function(a,b,description){
			var me = this;
			var R = Siesta.Resource('Siesta.Test.Date');
			
            if (me.compareTime(a.startTime, b.startTime) && me.compareTime(a.endTime, b.endTime)) {
                this.pass(description, {
                    descTpl         : '{got} ' + R.get('isEqualTo') + ' {expectedDate}',
                    got             : a,
                    expectedDate    : b
                });
            } else {
                this.fail(description, {
                    assertionName   : 'isRangeTimeEqual',
                    
                    got             : a ? a.startTime.toTimeString() + a.endTime.toTimeString(): '',
                    need            : b.startTime.toTimeString() + b.endTime.toTimeString()
                });
            }
		}
	}
});

