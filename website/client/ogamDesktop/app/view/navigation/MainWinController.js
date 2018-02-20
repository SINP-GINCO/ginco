/**
 * This class manages the navigation main view.
 */
Ext.define('OgamDesktop.view.navigation.MainWinController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.navigationmainwin',

    /**
     * Fonction handling the click event on the navigation print button.
     * @private
     * @param {Ext.button.Button} button The button
     * @param {Event} e The click event
     */
    onPrintButtonPress : function(button, e) {

        // Gets the active tab
        var tab = this.getView().getActiveTab();

        // Builds the print preview
        Ext.getBody().createChild({
            tag: 'div',
            id: 'o-navigation-print-main-div'
        },Ext.getBody().first());

        // Adds the current tab body content to the print preview div
        document.getElementById('o-navigation-print-main-div').appendChild(tab.body.dom.firstElementChild);

        var afterPrint = function () {
            var navBody = document.getElementById('o-navigation-print-main-div').firstElementChild;
            tab.body.dom.appendChild(navBody);
            Ext.get('o-navigation-print-main-div').destroy();
        };

        // Adds a event to close properly the print window
        // https://www.tjvantoll.com/2012/06/15/detecting-print-requests-with-javascript/
        if (Ext.isGecko || Ext.isEdge || Ext.isIE) { // IE et Firefox, html5 standart

            window.onafterprint = function(){ // After print
                afterPrint();
                window.onafterprint = null;
            };
        } else/* if (Ext.isWebKit)*/ { // Chrome, Safari...
            if ('matchMedia' in window) {
                window.matchMedia('print').addListener(function (mediaQueryListEvent) {
                    // Note: mediaQueryListEvent.matches will be true before printing, and false afterwards.
                    if (!mediaQueryListEvent.matches) { // After print
                        afterPrint();
                        mediaQueryListEvent.target.removeListener(arguments.callee);
                    }
                });
            }
       }/* else  { // Opera...
            // TODO: Add a close button like in the map print function
        }
*/
        // Launches the print
        window.print();
    }
});