

package examples {
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.system.FlameImageSetManager;
    import Flame2D.core.system.FlameMouseCursor;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.UVector2;
    import Flame2D.elements.button.FlameCheckbox;
    import Flame2D.elements.button.FlamePushButton;
    import Flame2D.elements.window.FlameGUISheet;
    
    import flash.events.KeyboardEvent;
    import examples.base.BaseApplication;
    
    
    [SWF(width="800", height="600", frameRate="60")]
    public class DemoCheckbox extends BaseApplication
    {
        private var rootWindow:FlameGUISheet;
        private var checkbox:FlameCheckbox;
        
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
                FlameImageSetManager.getSingleton().getImageSet("TaharezLook").getImage("MouseArrow"));
            
   

   
            // here we will use a StaticImage as the root, then we can use it to place a background image
            var background:FlameWindow = winMgr.createWindow("TaharezLook/StaticImage", "root_wnd");
            
            // set position and size
            background.setPosition(new UVector2(Misc.cegui_reldim(0), Misc.cegui_reldim( 0)));
            background.setSize(new UVector2(Misc.cegui_reldim(1), Misc.cegui_reldim( 1)));
            
            // disable frame and standard background
            background.setProperty("FrameEnabled", "false");
            background.setProperty("BackgroundEnabled", "false");
            
            // set the background image
            background.setProperty("Image", "set:BackgroundImage image:full_image");
            
            
            // install this as the root GUI sheet
            FlameSystem.getSingleton().setGUISheet(background);
            
            
            createApp();
            
        }
        
        private function createApp():void
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            var root:FlameWindow = winMgr.getWindow("root_wnd");
            
            
            //fixed position
            checkbox = winMgr.createWindow("TaharezLook/Checkbox", "Demo/Checkbox") as FlameCheckbox;
            checkbox.setPosition(new UVector2(Misc.cegui_absdim(200), Misc.cegui_absdim(200)));
            checkbox.setSize(new UVector2(Misc.cegui_absdim(240), Misc.cegui_absdim(30)));
            checkbox.setText("ABCDEF");
            checkbox.setSelected(true);
            var valueCheckbox:Boolean = checkbox.isSelected(); // Retrieve whether it is checked
            //trace("checkbox status is:" + valueCheckbox);

            checkbox.subscribeEvent(FlameCheckbox.EventCheckStateChanged,
                new Subscriber(onStateChanged, this), FlameCheckbox.EventNamespace);
            
            root.addChildWindow(checkbox);
        }
        
        private function onStateChanged(args:WindowEventArgs):void
        {
            var checkbox:FlameCheckbox = args.window as FlameCheckbox;
            
            trace("checkbox status is:" + checkbox.isSelected());
        }

    }
}
