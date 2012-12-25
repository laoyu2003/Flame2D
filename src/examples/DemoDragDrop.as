

package examples {
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.DragDropEventArgs;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameImageSetManager;
    import Flame2D.core.system.FlameMouseCursor;
    import Flame2D.core.system.FlameResourceProvider;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.UDim;
    import Flame2D.core.utils.UVector2;
    import Flame2D.elements.button.FlamePushButton;
    import Flame2D.elements.button.FlameRadioButton;
    import Flame2D.elements.window.FlameFrameWindow;
    import Flame2D.elements.window.FlameGUISheet;
    import Flame2D.loaders.TextFileLoader;
    
    import flash.events.KeyboardEvent;
    import examples.base.BaseApplication;
    
    
    [SWF(width="800", height="600", frameRate="60")]
    public class DemoDragDrop extends BaseApplication
    {        
        override protected function initApp():void
        {
            // Now the system is initialised, we can actually create some UI elements, for
            // this first example, a full-screen 'root' window is set as the active GUI
            // sheet, and then a simple frame window will be created and attached to it.
            
            // All windows and widgets are created via the WindowManager singleton.
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            
            FlameMouseCursor.getSingleton().initialize();
            //FlameMouseCursor.getSingleton().setImageByImageSet("TaharezLook", "MouseMoveCursor");
            FlameSystem.getSingleton().setDefaultMouseCursor(
                FlameImageSetManager.getSingleton().getImageSet("WindowsLook").getImage("MouseArrow"));
            
            
            var name:String = "DragDropDemo";
            var url:String = FlameResourceProvider.getSingleton().getResourceDir() + 
                FlameResourceProvider.getSingleton().getLayoutDir() + 
                name + ".layout";
            
            new TextFileLoader({}, url, onFileLoaded);
        }
        
        private function onFileLoaded(tag:*, str:String):void
        {
            var rootWindow:FlameGUISheet = FlameWindowManager.getSingleton().loadWindowLayoutFromString(str) as FlameGUISheet;
            
            FlameSystem.getSingleton().setGUISheet(rootWindow);

            // setup events
            subscribeEvents();
        }
        
        private function subscribeEvents():void
        {
            var wmgr:FlameWindowManager = FlameWindowManager.getSingleton();
            
            /*
            * Subscribe handler to deal with user closing the frame window
            */
            try
            {
                var main_wnd:FlameWindow = wmgr.getWindow("Root/MainWindow");
                main_wnd.subscribeEvent(
                    FlameFrameWindow.EventCloseClicked,
                    new Subscriber(handle_CloseButton, this), FlameWindow.EventNamespace);
            }
            // if something goes wrong, log the issue but do not bomb!
            catch(error:Error)
            {
            }
            
            /*
            * Subscribe the same handler to each of the twelve slots
            */
            var base_name:String = "Root/MainWindow/Slot";
            
            for (var i:int = 1; i <= 12; ++i)
            {
                try
                {
                    // get the window pointer for this slot
                    var wnd:FlameWindow =
                        wmgr.getWindow(base_name + FlamePropertyHelper.intToString(i));
                    
                    // subscribe the handler.
                    wnd.subscribeEvent(
                        FlameWindow.EventDragDropItemDropped,
                        new Subscriber(handle_ItemDropped, this), FlameWindow.EventNamespace);
                }
                // if something goes wrong, log the issue but do not bomb!
                catch(error:Error)
                {
                }
            }
        }
        
        //----------------------------------------------------------------------------//
        private function handle_ItemDropped(args:EventArgs):Boolean
        {
            // cast the args to the 'real' type so we can get access to extra fields
            const dd_args:DragDropEventArgs = DragDropEventArgs(args);
            
            if (!dd_args.window.getChildCount())
            {
                // add dragdrop item as child of target if target has no item already
                dd_args.window.addChildWindow(dd_args.dragDropItem);
                // Now we must reset the item position from it's 'dropped' location,
                // since we're now a child of an entirely different window
                dd_args.dragDropItem.setPosition(
                    new UVector2(new UDim(0.05, 0), new UDim(0.05, 0)));
            }
            
            return true;
        }
        
        //----------------------------------------------------------------------------//
        private function handle_CloseButton(args:EventArgs):Boolean
        {
            //d_sampleApp->setQuitting();
            return true;
        }
    }
}
