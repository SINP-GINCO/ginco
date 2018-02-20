/**
 * This class defines the model for the layer tree node.
 */
Ext.define('OgamDesktop.model.map.LayerTreeNode',{
    extend: 'OgamDesktop.model.base',
    requires:['OgamDesktop.model.map.Layer'],
    fields: [
        {name: 'id', type: 'integer'},
        {name: 'nodeId', type: 'integer'},
        {name: 'parentNodeId', type: 'string'},
        {name: 'label', type: 'string'},
        {name: 'definition', type: 'string'},
        {name: 'isLayer', type: 'boolean'},
        {name: 'isChecked', type: 'boolean'},
        {name: 'isHidden', type: 'boolean'},
        {name: 'isDisabled', type: 'boolean'},
        {name: 'isExpanded', type: 'boolean'},
        {name: 'layer', reference: 'map.Layer'},
        {name: 'position', type: 'integer'},
        {name: 'checkedGroup', type: 'string'}
    ],
     hasMany: [{// See Ext.data.reader.Reader documentation for example
        model: 'OgamDesktop.model.map.LayerTreeNode',
        name:'children',
        associationKey: 'children'
    }]
});