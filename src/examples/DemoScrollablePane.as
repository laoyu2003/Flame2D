

package examples {
    import Flame2D.core.data.Consts;
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.events.KeyEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.imagesets.FlameImageSet;
    import Flame2D.core.system.FlameEvent;
    import Flame2D.core.system.FlameFont;
    import Flame2D.core.system.FlameFontManager;
    import Flame2D.core.system.FlameImageSetManager;
    import Flame2D.core.system.FlameMouseCursor;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.CoordConverter;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.UDim;
    import Flame2D.core.utils.URect;
    import Flame2D.core.utils.UVector2;
    import Flame2D.core.utils.Vector2;
    import Flame2D.elements.button.FlamePushButton;
    import Flame2D.elements.containers.FlameScrollablePane;
    import Flame2D.elements.menu.FlameMenuItem;
    import Flame2D.elements.window.FlameGUISheet;
    
    import flash.events.KeyboardEvent;
    import examples.base.BaseApplication;
    
    
    [SWF(width="800", height="600", frameRate="60")]
    public class DemoScrollablePane extends BaseApplication
    {
        // member data
        private var d_wm:FlameWindowManager; // we will use the window manager alot
        private var d_system:FlameSystem;    // the gui system
        private var d_root:FlameWindow;      // the gui sheet
        private var d_font:FlameFont;        // the font we use
        private var d_pane:FlameScrollablePane; // the scrollable pane. center piece of the demo
        
        
        override protected function initApp():void
        {
            // Now the system is initialised, we can actually create some UI elements, for
            // this first example, a full-screen 'root' window is set as the active GUI
            // sheet, and then a simple frame window will be created and attached to it.
            
            // All windows and widgets are created via the WindowManager singleton.
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            
            FlameMouseCursor.getSingleton().initialize();
            
            // load the default font
            d_font = FlameSystem.getSingleton().getDefaultFont();
            
            // to look more like a real application, we override the autoscale setting
            // for both skin and font
            var wndlook:FlameImageSet = FlameImageSetManager.getSingleton().getImageSet("WindowsLook");
            wndlook.setAutoScalingEnabled(false);
            d_font.setProperty("AutoScaled", "false");
            
            // set the mouse cursor
            d_system = FlameSystem.getSingleton();
            d_system.setDefaultMouseCursor(wndlook.getImage("MouseArrow"));
            
            // set the default tooltip type
            //d_system.setDefaultTooltip("WindowsLook/Tooltip");
            
            // We need the window manager to set up the test interface :)
            d_wm = FlameWindowManager.getSingleton();
            
            // create a root window
            // this will be a static, to give a nice app'ish background
            d_root = d_wm.createWindow("WindowsLook/Static");
            d_root.setProperty("FrameEnabled", "false");
            // root window will take care of hotkeys
            d_root.subscribeEvent(FlameWindow.EventKeyDown, new Subscriber(hotkeysHandler, this), FlameWindow.EventNamespace);
            d_system.setGUISheet(d_root);

            // create a menubar.
            // this will fit in the top of the screen and have options for the demo
            var bar_bottom:UDim = new UDim(0,16);
            
            var bar:FlameWindow = d_wm.createWindow("WindowsLook/Menubar", "Demo/Menubar");
            
            bar.setAreaByUDims(new UDim(0,0),new UDim(0,0),new UDim(1,0),bar_bottom);
            bar.setAlwaysOnTop(true); // we want the menu on top
            d_root.addChildWindow(bar);
            
            // fill out the menubar
            createMenu(bar);
            
            // create a scrollable pane for our demo content
            d_pane = FlameScrollablePane(d_wm.createWindow("WindowsLook/ScrollablePane"));
            d_pane.setAreaByUDims(new UDim(0,0),bar_bottom,new UDim(1,0),new UDim(1,0));
            // this scrollable pane will be a kind of virtual desktop in the sense that it's bigger than
            // the screen. 3000 x 3000 pixels
            d_pane.setContentPaneAutoSized(false);
            d_pane.setContentPaneArea(new Rect(0,0,3000,3000));
            d_root.addChildWindow(d_pane);
            
            // add a dialog to this pane so we have something to drag around :)
            var dlg:FlameWindow = d_wm.createWindow("WindowsLook/FrameWindow");
            dlg.setMinSize(new UVector2(new UDim(0,250),new UDim(0,100)));
            dlg.setSize(new UVector2(new UDim(0,250),new UDim(0,100)));
            dlg.setText("Drag me around");
            d_pane.addChildWindow(dlg);
        }
        
        /*************************************************************************
         Creates the menu bar and fills it up :)
         *************************************************************************/
        private function createMenu(bar:FlameWindow):void
        {
            // file menu item
            var file:FlameWindow = d_wm.createWindow("WindowsLook/MenuItem");
            file.setText("File");
            bar.addChildWindow(file);
            
            // file popup
            var popup:FlameWindow = d_wm.createWindow("WindowsLook/PopupMenu");
            file.addChildWindow(popup);
            
            // quit item in file menu
            var item:FlameWindow = d_wm.createWindow("WindowsLook/MenuItem");
            item.setText("Quit");
            //item.subscribeEvent("Clicked", new Subscriber(fileQuit, this), FlameWindow.EventNamespace);
            popup.addChildWindow(item);
            
            // demo menu item
            var demo:FlameWindow = d_wm.createWindow("WindowsLook/MenuItem");
            demo.setText("Demo");
            bar.addChildWindow(demo);
            
            // demo popup
            popup = d_wm.createWindow("WindowsLook/PopupMenu");
            demo.addChildWindow(popup);
            
            // demo -> new window
            item = d_wm.createWindow("WindowsLook/MenuItem");
            item.setText("New dialog");
            item.setTooltipText("Hotkey: Space");
            item.subscribeEvent(FlameMenuItem.EventClicked, new Subscriber(demoNewDialog, this), FlameMenuItem.EventNamespace);
            popup.addChildWindow(item);
        }
        
        /*************************************************************************
         Handler for the 'Demo -> New dialog' menu item
         *************************************************************************/
        private function demoNewDialog(e:EventArgs):Boolean
        {
            // add a dialog to this pane so we have some more stuff to drag around :)
            var dlg:FlameWindow = d_wm.createWindow("WindowsLook/FrameWindow");
            dlg.setMinSize(new UVector2(new UDim(0,200),new UDim(0,100)));
            dlg.setSize(new UVector2(new UDim(0,200),new UDim(0,100)));
            dlg.setText("Drag me around too!");
            
            // we put this in the center of the viewport into the scrollable pane
            var uni_center:UVector2 = new UVector2(new UDim(0.5,0), new UDim(0.5,0));
            var center:Vector2 = CoordConverter.windowToScreenForUVector2(d_root, uni_center);
            var target:Vector2 = CoordConverter.screenToWindowForVector2(d_pane.getContentPane(), center);
            dlg.setPosition(new UVector2(new UDim(0,target.d_x-100), new UDim(0,target.d_y-50)));
            
            d_pane.addChildWindow(dlg);
            
            return true;
        }
            
        /*************************************************************************
         Handler for global hotkeys
         *************************************************************************/
        private function hotkeysHandler(e:EventArgs):Boolean
        {
            const k:KeyEventArgs = KeyEventArgs(e);
            
            switch (k.scancode)
            {
                // space is a hotkey for demo -> new dialog
                case Consts.Key_Space:
                    // this handler does not use the event args at all so this is fine :)
                    // though maybe a bit hackish...
                    demoNewDialog(e);
                    break;
                
                // no hotkey found? event not used...
                default:
                    return false;
            }
            
            return true;
        }

    }
}
