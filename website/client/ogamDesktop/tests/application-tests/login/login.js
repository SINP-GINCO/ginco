// Login Test
StartTest(function(t) {

	// Cette page ne contient pas ExtJS, on teste uniquement le login en PHP.
	
	document.getElementById('username').value = 'admin';
	document.getElementById('password').value = 'admin';
	
	document.getElementById('submit').click();
	
	// TODO : Tester qu'on arrive bien sur la page suivante
	
	t.wait(500);
	
	var connecte = document.getElementById('logoutLink');
	
	t.ok(connecte, 'On est bien connecté');
		
	t.done(); 
})