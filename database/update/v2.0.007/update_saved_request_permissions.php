<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

try {
	/* Check that role with public request permission have private request permission */
	$config = loadPropertiesFromArgs();
	$config['sprintDir'] = $sprintDir;
	$conn_string = "host={$config['db.host']} port={$config['db.port']} user={$config['db.adminuser']} password={$config['db.adminuser.pw']} dbname={$config['db.name']}";
	$dbconn = pg_connect($conn_string) or die('Connection failed');
	
	echo "executing " . dirname(__FILE__) . "/" . basename(__FILE__) . " ...\n";
	
	// Get role with MANAGE_PUBLIC_REQUEST permission
	$roleWithPublicPermissionRequest = "SELECT role_code FROM website.permission_per_role 
		WHERE permission_code = 'MANAGE_PUBLIC_REQUEST'";
	$roleWithPublicPermission = pg_query($roleWithPublicPermissionRequest);
	
	if (!$roleWithPublicPermission) {
		echo "An sql error occurred.\n";
		pg_close($dbconn);
		exit(1);
	}
	
	// Check if selected roles have private request permission
	while ($result = pg_fetch_assoc($roleWithPublicPermission)) {
		echo "role with public permission " . $result['role_code'] . " ...\n";
		
		$roleWithPublicAndNotPrivateRequest = "SELECT 1 as private_permission FROM website.permission_per_role 
			WHERE role_code = '" . $result['role_code'] . "' AND permission_code = 'MANAGE_OWNED_PRIVATE_REQUEST'";
		$roleWithPublicAndNotPrivate = pg_query($roleWithPublicAndNotPrivateRequest);
		
		if (!$roleWithPublicAndNotPrivate) {
			echo "An sql error occurred.\n";
			pg_close($dbconn);
			exit(1);
		}
		
		if ($correctRole = pg_fetch_assoc($roleWithPublicAndNotPrivate)) {
			echo "role has correct permissions \n";
		} else {
			echo "correcting role " . $correctRole['role_code'] . " ...\n";
			
			$fixRoleRequest = "INSERT INTO website.permission_per_role(role_code, permission_code) 
					VALUES ('" . $result['role_code'] . "', 'MANAGE_OWNED_PRIVATE_REQUEST');";
			$fixRole = pg_query($fixRoleRequest);
			
			if (!$fixRole) {
				echo "An sql error occurred.\n";
				pg_close($dbconn);
				exit(1);
			}
		}
	}
	
	pg_close($dbconn);
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}
