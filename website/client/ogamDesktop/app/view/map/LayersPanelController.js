/**
 * This class manages the legends panel view.
 */
Ext.define('OgamDesktop.view.map.LayersPanelController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.layerspanel',

    /**
     * Toggle the node checkbox.
     * @param {Integer} node The node
     * @param {Boolean} toggleCheck True to check, false to uncheck the box. If no value was passed, toggles the checkbox
     */
    toggleNodeCheckbox: function(node, toggleCheck) {
        // Change check status
        this.getView().getView().fireEvent('checkchange', node, toggleCheck);
        node.set('checked', toggleCheck);
    },

    /**
     * Return the layer node.
     * @param {OpenLayers.Layer} layer The layer
     * @return {GeoExt.data.model.LayerTreeNode/Ext.data.NodeInterface} The layer node
     */
    getLayerNode : function(layer) {
        var foundLayerNode = null;
        // Get the tree store of the layers tree panel and scan it.
        var layerStore = this.getView().getStore();
        layerStore.each(function(layerNode){
            if (!layerNode.get('isLayerGroup') && layerNode.getOlLayer().get('name') === layer.get('name')) {
                foundLayerNode = layerNode;
            }
        });
        return foundLayerNode;
    },

    /**
     * Enable/Disable the passed layer node.
     * @param {GeoExt.data.model.LayerTreeNode/Ext.data.NodeInterface} node
     * @param {Boolean} enable True to enable the node
     */
    updateLayerNode: function(node, enable) {
        // check if the node has the 'disabled' class
        var classes = node.get("cls");
        var disabledClass = 'dvp-tree-node-disabled';
        var regex = new RegExp('\\b' + disabledClass + '\\b');
        var hasClass = classes.match(regex);

        if (enable) {
            node.getOlLayer().set('disabled', false);
            if (hasClass)
                classes = classes.replace(regex, '');
        } else {
            node.getOlLayer().set('disabled', true);
            if (!hasClass)
                classes += ' ' + disabledClass + ' ';
        }
        node.set("cls", classes);
    },

    /**
     * Catches the "beforecheckchange" event (when clicking on checkboxes and radio buttons) in layers tree.
     * - If the layer is disabled, cancel the check
     * - If the layer is shown with a radio button, uncheck every other layer in the radio group
     *
     * @param {GeoExt.data.model.LayerTreeNode/Ext.data.NodeInterface} node
     * @param checkedState: the state of the "checkbox" (true or false) before the change
     * @param e: Event
     */
    onBeforeCheckChange: function(node, checkedState, e) {
        // console.log('OnBeforeCheckChange', node, checkedState, e);

        // If layer is disabled, prevent change
        if (node.getOlLayer().get('disabled')) {
            return false; // stop the process
        }

        // If the layer is a base layer
        if (node.childNodes.length == 0) {
            // Radio groups
            var radioGroup = node.getOlLayer().get("checkedGroup");
            if (radioGroup) {
                // If checkbox was selected, prevent it to be unchecked by clicking on it
                if (checkedState) {
                    return false; // Stop the process
                }
                // If checkbox was not selected before, let it be selected (do noting on it),
                // But uncheck every other of its group
                else {
                    var layerStore = this.getView().getStore();
                    layerStore.each(function (layerNode) {
                        if (layerNode.getOlLayer().get("checkedGroup") == radioGroup) {
                            // console.log("Layer unchecked", layerNode.getOlLayer().get("name"))
                            layerNode.set("checked", false);
                        }
                    });
                }
            }
        }
    },

    /**
     * Catches the "checkchange" event (when clicking on checkboxes and radio buttons, AFTER the change) in layers tree.
     * If the layer is a container, checks for radio buttons as childs: uncheck all radios
     * which are not initially checked (db config).
     *
     * @param {GeoExt.data.model.LayerTreeNode/Ext.data.NodeInterface} node
     * @param checkedState: the state of the "checkbox" (true or false) before the change
     * @param e: Event
     */
    onCheckChange: function (node, checkedState, e) {
        // console.log('OnCheckChange', node, checkedState, e);

        // If the layer is a container
        if (node.childNodes.length > 0) {
            // If checkbox has been selected:
            // Browse childNodes, and if they are in a radio group,
            // disable them if their "checked" is 0 (ie initially unchecked).
            if (checkedState) {
                 var childNodes = node.childNodes;
                 childNodes.forEach(function (layerNode) {
                     if (layerNode.getOlLayer().get("checkedGroup").length) {
                         // console.log("Child layer " + layerNode.getOlLayer().get("name") +
                         // " in group " + layerNode.getOlLayer().get("checkedGroup") +
                         // ", Initially checked: " + layerNode.getOlLayer().get("checked") +
                         // ", currently checked: " + layerNode.get("checked"));

                         // the layer is in a group, so we uncheck it if is initially unchecked
                         if (!layerNode.getOlLayer().get("checked")) {
                             layerNode.set("checked", false);
                         }
                     }
                 });
            }
        }
    }
});