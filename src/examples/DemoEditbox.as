

package examples {
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.system.FlameImageSetManager;
    import Flame2D.core.system.FlameMouseCursor;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.UVector2;
    import Flame2D.elements.button.FlameCheckbox;
    import Flame2D.elements.button.FlamePushButton;
    import Flame2D.elements.combobox.FlameCombobox;
    import Flame2D.elements.editbox.FlameEditbox;
    import Flame2D.elements.editbox.FlameMultiLineEditbox;
    import Flame2D.elements.list.FlameMultiColumnList;
    import Flame2D.elements.listbox.FlameListboxTextItem;
    import Flame2D.elements.window.FlameFrameWindow;
    import Flame2D.elements.window.FlameGUISheet;
    import Flame2D.falagard.FalagardEditbox;
    import Flame2D.falagard.FalagardMultiLineEditbox;
    
    import flash.events.KeyboardEvent;
    import examples.base.BaseApplication;
    
    
    [SWF(width="800", height="600", frameRate="60")]
    public class DemoEditbox extends BaseApplication
    {
        private var rootWindow:FlameGUISheet;
        
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
            var background:FlameWindow = winMgr.getWindow("root_wnd");
            
            var text:FlameWindow = winMgr.createWindow("TaharezLook/StaticText", "Demo/Text");
            text.setPosition(new UVector2(Misc.cegui_absdim(100), Misc.cegui_absdim(100)));
            text.setSize(new UVector2(Misc.cegui_absdim(240), Misc.cegui_absdim(90)));
            text.setTextParsingEnabled(true);
            text.setProperty("HorzFormatting", "WordWrapLeftAligned");
            text.setText("[image='set:TaharezLook image:MouseArrow'] nicely [colour='FFFF0000']CEGUI can format strings.[colour='FF00FF00'] and this is just colour [colour='FF0000FF'] formatting!");
            background.addChildWindow(text);
            
            var ebox:FlameEditbox = winMgr.createWindow("TaharezLook/Editbox", "Demo/Editbox") as FlameEditbox;
            ebox.setPosition(new UVector2(Misc.cegui_absdim(200), Misc.cegui_absdim(200)));
            ebox.setSize(new UVector2(Misc.cegui_absdim(240), Misc.cegui_absdim(30)));
            ebox.setValidationString("^\\d*$");
            ebox.setText("");
            ebox.setTooltipText("Please input digits");
            
            background.addChildWindow(ebox);

            var mlebox:FlameMultiLineEditbox = winMgr.createWindow("TaharezLook/MultiLineEditbox", "Demo/MultiLineEditBox") as FlameMultiLineEditbox;
            mlebox.setPosition(new UVector2(Misc.cegui_absdim(200), Misc.cegui_absdim(260)));
            mlebox.setSize(new UVector2(Misc.cegui_absdim(240), Misc.cegui_absdim(80)));
            mlebox.setText("The above editbox only accept digitals\nThe second line");
            
            background.addChildWindow(mlebox);

            //test blink caret by setting falagard property
            //note:should be called after addChildWindow
            (mlebox.getWindowRenderer() as FalagardMultiLineEditbox).setCaretBlinkEnabled(true);
        }

    }
}
