/*
 * This class is a derived work from:
 *
 *	Notification extension for Ext JS 4.0.2+
 *	Version: 2.1.3
 *
 *	Copyright (c) 2011 Eirik Lorentsen (http://www.eirik.net/)
 *
 *	Follow project on GitHub: https://github.com/EirikLorentsen/Ext.ux.window.Notification
 *
 *	Dual licensed under the MIT (http://www.opensource.org/licenses/mit-license.php)
 *	and GPL (http://opensource.org/licenses/GPL-3.0) licenses.
 */
 
/**
 * This class provides for lightweight, auto-dismissing pop-up notifications called "toasts".
 * At the base level, you can display a toast message by calling `OgamDesktop.toast` like so:
 *
 *      OgamDesktop.toast('Data saved');
 *
 * This will result in a toast message, which displays in the default location of bottom right in your viewport.
 *
 * You may expand upon this simple example with the following parameters: 
 *
 *      OgamDesktop.toast(message, title, align, iconCls);
 *
 * For example, the following toast will appear top-middle in your viewport.  It will display 
 * the 'Data Saved' message with a title of 'Title'  
 *
 *      OgamDesktop.toast('Data Saved', 'Title', 't')
 *
 * It should be noted that the toast's width is determined by the message's width. 
 * If you need to set a specific width, or any of the other available configurations for your toast, 
 * you can create the toast object as seen below:
 *
 *      OgamDesktop.toast({
 *          html: 'Data Saved',
 *          title: 'My Title',
 *          width: 200,
 *          align: 't'
 *      });
 *
 * This component is derived from the excellent work of a Sencha community member, Eirik
 * Lorentsen.
 */
Ext.define('OgamDesktop.ux.window.Toast', {
    extend: 'Ext.window.Toast'
},
function (Toast) {
    OgamDesktop.toast = function (message, title, align, iconCls) {
        var toast, config = {
            closable: true,
            width: 300,
            align: 't',
            autoCloseDelay: 8000
        };
 
        if (Ext.isString(message)) {
            config.title = title;
            config.html = message;
            config.iconCls = iconCls;
            if (align) {
                config.align = align;
            }
        } else {
            Ext.apply(config,message);
        }
 
        toast = new Toast(config);
        toast.show();
        return toast;
    };
});