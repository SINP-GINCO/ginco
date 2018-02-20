var harness = new Siesta.Harness.Browser.ExtJS();

harness.configure({
	title : 'OGAM Tests',

	preload : [

	]
});


harness.start(
		
	// Login is needed
	{    	
		// Test de la page de login du site
		group       : 'Login',
	    pageUrl     : '../../../user',
	    items       : [
	        'application-tests/login/login.js'
	    ]
	},
		
		
	//
	// Sanity tests
	// 
	{
		// Test d'initialisation correcte de ExtJS et OgamDeskTop
		group : 'Sanity Tests',
		pageUrl : '../odp/index.html?unittest',
		sandbox : false, // Il faut être loggué pour que ces pages fonctionnent
		items : [ '010_sanity.t.js' ]
	},
	
	
	//
	// Unit test.
	// Test single components
	//
	{    	
		// Test de la page de login du site
		group       : 'Unit Tests - Layers',
		pageUrl : '../odp/index.html?unittest',  // le paramètre unittest demande à ExtJS de ne pas initialiser les vues 
		sandbox : false, // Il faut être loggué pour que ces pages fonctionnent
	    items       : [
	        'unit-tests/model/map/layers.t.js'
	    ]
	},
	{
		group       : 'Unit Tests - form field',
		pageUrl : '../odp/index.html?unittest&locale=en',  // le paramètre unittest demande à ExtJS de ne pas initialiser les vues 
		testClass:'Ogam.Test',
		items       : [
	           'unit-tests/ux/form/field/Factory.t.js',
	           'unit-tests/ux/form/field/RadioButton.t.js',
	           'unit-tests/ux/form/field/TimeRangeField.t.js'
	   ]
	},
	
	
	//
	// Application tests.
	// Test directly on the web site that some actions produce the expacted results.
	//
	
	
	
	{    	
    	group       : 'Application Tests - Query',
    	pageUrl : '../odp/index.html',
    	sandbox : false, // Il faut être loggué pour que ces pages fonctionnent
    	items       : [
            'application-tests/query/query.js'
        ]
    }


);