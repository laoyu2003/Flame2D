

package examples {
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
    import Flame2D.elements.list.FlameMultiColumnList;
    import Flame2D.elements.listbox.FlameListboxTextItem;
    import Flame2D.elements.window.FlameFrameWindow;
    import Flame2D.elements.window.FlameGUISheet;
    import examples.base.BaseApplication;
    
    [SWF(width="800", height="600", frameRate="60")]
    public class DemoCombobox extends BaseApplication
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
            var itm:FlameListboxTextItem;
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            var background:FlameWindow = winMgr.getWindow("root_wnd");
            

            // create combo-box.
            var cbbo:FlameCombobox = winMgr.createWindow("TaharezLook/Combobox", "Demo6/ControlPanel/SelModeBox") as FlameCombobox;
            cbbo.setPosition(new UVector2(Misc.cegui_absdim(200), Misc.cegui_absdim(200)));
            cbbo.setSize(new UVector2(Misc.cegui_absdim(200), Misc.cegui_absdim(150)));
            //cbbo.setSortingEnabled(true);

            
            // populate combobox with possible selection modes
            const sel_img:FlameImage = FlameImageSetManager.getSingleton().getImageSet("TaharezLook").getImage("MultiListSelectionBrush");
            itm = new FlameListboxTextItem("Full Row (Single)", 0);
            itm.setSelectionBrushImage(sel_img);
            cbbo.addItem(itm);
            itm = new FlameListboxTextItem("Full Row (Multiple)", 1);
            itm.setSelectionBrushImage(sel_img);
            cbbo.addItem(itm);
            itm = new FlameListboxTextItem("Full Column (Single)", 2);
            itm.setSelectionBrushImage(sel_img);
            cbbo.addItem(itm);
            itm = new FlameListboxTextItem("Full Column (Multiple)", 3);
            itm.setSelectionBrushImage(sel_img);
            cbbo.addItem(itm);
            itm = new FlameListboxTextItem("Single Cell (Single)", 4);
            itm.setSelectionBrushImage(sel_img);
            cbbo.addItem(itm);
            itm = new FlameListboxTextItem("Single Cell (Multiple)", 5);
            itm.setSelectionBrushImage(sel_img);
            cbbo.addItem(itm);
            itm = new FlameListboxTextItem("Nominated Column (Single)", 6);
            itm.setSelectionBrushImage(sel_img);
            cbbo.addItem(itm);
            itm = new FlameListboxTextItem("Nominated Column (Multiple)", 7);
            itm.setSelectionBrushImage(sel_img);
            cbbo.addItem(itm);
            var pStore:FlameListboxTextItem = itm;
            itm = new FlameListboxTextItem("Nominated Row (Single)", 8);
            itm.setSelectionBrushImage(sel_img);
            cbbo.addItem(itm);
            itm = new FlameListboxTextItem("Nominated Row (Multiple)", 9);
            itm.setSelectionBrushImage(sel_img);
            cbbo.addItem(itm);
            cbbo.setReadOnly(true);
            // Now change the text to test the sorting
            pStore.setText("Abracadabra");
            //cbbo.setSortingEnabled(false);
            cbbo.setSortingEnabled(true);
            //cbbo.handleUpdatedListItemData();


            background.addChildWindow(cbbo);

        }

    }
}
