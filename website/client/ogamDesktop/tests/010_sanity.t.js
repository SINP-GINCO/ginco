// Sanity Test
StartTest(function(t) {
	t.diag("Sanity");

	// Test that ExtJS is loaded
	t.ok(Ext, 'ExtJS is here');
	t.ok(Ext.Window, 'ExtJS.window is here');

	// Test that OgamDesktop is loaded
	t.ok(OgamDesktop, 'OgamDesktop is here');
	t.ok(OgamDesktop.Application, 'OgamDesktop.Application is here');
	

	t.done(); // Optional, marks the correct exit point from the test
})