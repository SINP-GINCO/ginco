// Application Test - Predefined Query
StartTest(function(t) {
	
	t.ok(Ext, 'ExtJS is here');
    
	// Initialiser la fenêtre "predefined request"
	
	t.chain(
			{ action : 'click', target : '>> [name=predefined-request]' },
			{ action : 'click', target : '>> [Distribution par espèce]' }
			//{ action : 'click', target : '>> [name=datasetId]' }
			
	);
	
	t.ok(OgamDesktop.PredefinedRequestPanel, 'OK');
	
	t.done(); // Optional, marks the correct exit point from the test
})