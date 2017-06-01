/**
 * This class manages the legends panel view.
 */
Ext.define('Ginco.view.map.LegendsPanelController', {
	override: 'OgamDesktop.view.map.LegendsPanelController',

    /**
     * Build a Legend Object from a 'Layer' store record.
     * @param {Object} curRes The map current resolution
     * @param {OgamDesktop.model.map.Layer} layer The 'Layer' store record
     */
    buildLegend : function(node, curRes) {
        var layer = node.getLayer();
        var service = layer.getLegendService();
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
                         html : layer.get('Label'),
                         cls : 'x-form-item x-form-item-label'
                     },{
                         tag : 'img',
                         src : service.get('config').urls.toString()
                         + layer.get('name')
                         + '/legendes/'
                         + layer.get('name')
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
                        html : layer.get('Label'),
                        cls : 'x-form-item x-form-item-label'
                    },{
                        tag : 'img',
                        src : service.get('config').urls.toString()
                        + 'LAYER='+ layer.get('serviceLayerName')
                        + '&SERVICE=' + service.get('config').params.SERVICE+ '&VERSION=' + service.get('config').params.VERSION + '&REQUEST=' + service.get('config').params.REQUEST
                        + '&Format=image/png&WIDTH=160'//TODO &HASSLD=' + (layer.get('params').hasSLD ? 'true' : 'false')
                    }]
                }
            }));
    	}

        if (node.get('isDisabled') || node.get('isHidden') || !node.get('isChecked') || layer.isOutOfResolution(curRes)) {
            legend.on('render', function(cmp) {
                cmp.hide();
            });
        }
    }
});