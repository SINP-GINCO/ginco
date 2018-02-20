/**
 * This class defines the OgamDesktop User model.
 */
Ext.define('OgamDesktop.model.user.User', {
	extend: 'OgamDesktop.model.base',
	requires:[
	    'OgamDesktop.model.user.Provider',
	    'OgamDesktop.model.user.Role'
	],
	idProperty: 'login',
    fields: [
        { name: 'login', type: 'string'},
        { name: 'name', type: 'string'},
        { name: 'provider', reference:'user.Provider'},
        { name: 'email', type: 'string'}
    ],
    hasMany: [{// See Ext.data.reader.Reader documentation for example
        model: 'OgamDesktop.model.user.Role',
        name:'roles',
        associationKey: 'roles',
        reference:'user.Role'
    }],
    
    /**
     * Check if the user is allowed for the provided permission.
     * @param {OgamDesktop.model.user.Permission} permission The permission
     */
    isAllowed: function(permission){
    	var isAllowed = false;
    	this.roles().each(
    		function(role){
    			role.permissions().each(
    				function(perm){
						if(perm.get('code') === permission){
							isAllowed = true;
							return false; // Returning false aborts and exits the iteration.
						}
			    	}
		    	);
    			if (isAllowed) {
    				return false; // Returning false aborts and exits the iteration.
    			}
	    	}
    	);
    	return isAllowed;
    }
});