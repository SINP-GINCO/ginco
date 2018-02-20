/**
 * This class defines the model for the layers services.
 */
Ext.define('OgamDesktop.model.map.LayerService',{
    extend: 'OgamDesktop.model.base',
    fields: [
        {name: 'id', type: 'string'},
        {name: 'name', type: 'string'},
        {name: 'config'} // type: object
    ],

    /**
     * Return the urls with the associated parameters
     * @return {Array}
     */
    getFullUrls: function() {
        var params = this.get('config').params;
        var paramsToString = '';
        for(var index in params) { 
           if (params.hasOwnProperty(index)) {
               paramsToString !== '' && (paramsToString += '&');
               paramsToString += index + '=' + params[index];
           }
        }
        var urls = this.get('config').urls;
        var fullUrls = [];
        for(var index in urls) {
            var url = urls[index];
            if (url.indexOf("?") === -1) {//no query ?
                url += '?';
            } else if (url.lastIndexOf("?") < url.length-1) {//has already param
                url += '&';
            }
            url += paramsToString;
            fullUrls.push(url);
        }
        return fullUrls;
    }
});