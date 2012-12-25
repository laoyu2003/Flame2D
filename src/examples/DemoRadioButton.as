

package examples {
    import Flame2D.core.system.FlameImageSetManager;
    import Flame2D.core.system.FlameMouseCursor;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.UVector2;
    import Flame2D.elements.button.FlamePushButton;
    import Flame2D.elements.button.FlameRadioButton;
    import Flame2D.elements.window.FlameGUISheet;
    
    import flash.events.KeyboardEvent;
    import examples.base.BaseApplication;
    
    
    [SWF(width="800", height="600", frameRate="60")]
    public class DemoRadioButton extends BaseApplication
    {
        private var rootWindow:FlameGUISheet;
        private var radioButtonA:FlameRadioButton;
        private var radioButtonB:FlameRadioButton;
        private var radioButtonC:FlameRadioButton;
        
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
            
            
            //the following has been moved to baseapplication part for async loading
            
            // load an image to use as a background
            //FlameImageSetManager.getSingleton().createFromImageFile("BackgroundImage", "GPN-2000-001437.png");
            
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
            radioButtonA = winMgr.createWindow("TaharezLook/RadioButton", "Demo/RadioButton_A") as FlameRadioButton;
            radioButtonA.setPosition(new UVector2(Misc.cegui_absdim(200), Misc.cegui_absdim(200)));
            radioButtonA.setSize(new UVector2(Misc.cegui_absdim(240), Misc.cegui_absdim(30)));
            radioButtonA.setText("Radio Button A");
            radioButtonA.setGroupID(1);
            radioButtonA.setID(101);
            radioButtonA.setSelected(true);
            radioButtonB = winMgr.createWindow("TaharezLook/RadioButton", "Demo/RadioButton_B") as FlameRadioButton;
            radioButtonB.setPosition(new UVector2(Misc.cegui_absdim(200), Misc.cegui_absdim(240)));
            radioButtonB.setSize(new UVector2(Misc.cegui_absdim(240), Misc.cegui_absdim(30)));
            radioButtonB.setText("Radio Button B");
            radioButtonB.setGroupID(1);
            radioButtonB.setID(102);
            radioButtonC = winMgr.createWindow("TaharezLook/RadioButton", "Demo/RadioButton_C") as FlameRadioButton;
            radioButtonC.setPosition(new UVector2(Misc.cegui_absdim(200), Misc.cegui_absdim(280)));
            radioButtonC.setSize(new UVector2(Misc.cegui_absdim(240), Misc.cegui_absdim(30)));
            radioButtonC.setText("Radio Button C");
            radioButtonC.setGroupID(1);
            radioButtonC.setID(103);
            

            
            root.addChildWindow(radioButtonA);
            root.addChildWindow(radioButtonB);
            root.addChildWindow(radioButtonC);

            var radioButton:FlameRadioButton;
            radioButton = winMgr.getWindow("Demo/RadioButton_A") as FlameRadioButton; // Get handle of one radio button from the group
            var valueRadioButtonLetters:uint = radioButton.getSelectedButtonInGroup().getID(); // Get selected ID
            
            trace("RadioButton A ID:" + valueRadioButtonLetters);
            
            radioButton = winMgr.getWindow("Demo/RadioButton_C") as FlameRadioButton;
            radioButton.setSelected(true); // Specify which button should appear selected by default
            
            trace("Radio Button Selected:" + radioButton.getSelectedButtonInGroup().getID());

        }
        
    }
}
