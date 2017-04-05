/**
 * This class manages the legends panel view.
 */
Ext.define('Ginco.view.map.LegendsPanelController', {
	override: 'OgamDesktop.view.map.LegendsPanelController',

    /**
     * Build a Legend Object from a 'Layer' store record.
     * @param {Object} curRes The map current resolution
     * @param {OgamDesktop.model.map.Layer} layer The 'Layer' store record
     * @param {Object} service The 'LayerService' store record for the legend corresponding to the layer
     */
    buildLegend : function(curRes, layer, service) {
    	// Get legends from Geoportail depot
    	if ( service.data.name == 'EN_WMS_Legend'){
    		 var legend = this.getView()
             .add(new Ext.Component({
                 // Extjs 5 doesn't accept '.' into ids
                 id : this.getView().id + layer.get('name').replace(/\./g,'-'),
                 autoEl : {
                     tag : 'div',
                     children : [{
                         tag : 'span',
                         html : layer.get('options').label,
                         cls : 'x-form-item x-form-item-label'
                     },{
                         tag : 'img',
                         src : service.get('config').urls.toString()
                         + layer.get('name')
                         + '/legendes/'
                         + layer.get('params').layers[0]
                         + '-legend.png'
                     }]
                 }
             }));
    	} else {
          var legend = this.getView()
            .add(new Ext.Component({
                // Extjs 5 doesn't accept '.' into ids
                id : this.getView().id + layer.get('name').replace(/\./g,'-'),
                autoEl : {
                    tag : 'div',
                    children : [{
                        tag : 'span',
                        html : layer.get('options').label,
                        cls : 'x-form-item x-form-item-label'
                    },{
                        tag : 'img',
                        src : service.get('config').urls.toString()
                        + 'LAYER='+ layer.get('params').layers
                        + '&SERVICE=' + service.get('config').params.SERVICE+ '&VERSION=' + service.get('config').params.VERSION + '&REQUEST=' + service.get('config').params.REQUEST
                        + '&Format=image/png&WIDTH=160&HASSLD=' + (layer.get('params').hasSLD ? 'true' : 'false')
                    }]
                }
            }));
    	}
        var outOfRange;
        var resolutions = layer.get('options').resolutions;
        if (resolutions) {
            var minResolution = resolutions[resolutions.length - 1]; maxResolution = resolutions[0];
            if (curRes < minResolution || curRes >= maxResolution) { 
                outOfRange = true;
            }
        }
        if (layer.get('params').isDisabled || layer.get('params').isHidden || !layer.get('params').isChecked || outOfRange) {
            legend.on('render', function(cmp) {
                cmp.hide();
            });
        }
    }
});