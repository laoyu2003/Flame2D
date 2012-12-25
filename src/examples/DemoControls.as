

package examples {
    import Flame2D.core.data.Consts;
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
    import Flame2D.elements.list.FlameMultiColumnList;
    import Flame2D.elements.listbox.FlameListboxItem;
    import Flame2D.elements.listbox.FlameListboxTextItem;
    import Flame2D.elements.window.FlameFrameWindow;
    import Flame2D.elements.window.FlameGUISheet;
    
    import flash.events.KeyboardEvent;
    import examples.base.BaseApplication;
    
    
    [SWF(width="800", height="600", frameRate="60")]
    public class DemoControls extends BaseApplication
    {
        //private var rootWindow:FlameGUISheet;
        
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
            
            
            createDemoWindows();
            initDemoEventWiring();
            
        }
        
        private function createDemoWindows():void
        {
            var itm:FlameListboxTextItem;
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            var root:FlameWindow = winMgr.getWindow("root_wnd");
            
            // create the main list.
            var mcl:FlameMultiColumnList = winMgr.createWindow("TaharezLook/MultiColumnList", "Demo6/MainList") as FlameMultiColumnList;
            mcl.setPosition(new UVector2(Misc.cegui_reldim(0.01), Misc.cegui_reldim( 0.1)));
            mcl.setSize(new UVector2(Misc.cegui_reldim(0.5), Misc.cegui_reldim( 0.8)));
            root.addChildWindow(mcl);
            
            // create frame window for control panel
            var fwnd:FlameFrameWindow = winMgr.createWindow("TaharezLook/FrameWindow", "Demo6/ControlPanel") as FlameFrameWindow;
            fwnd.setPosition(new UVector2(Misc.cegui_reldim(0.53), Misc.cegui_reldim( 0.03)));
            fwnd.setMaxSize(new UVector2(Misc.cegui_reldim(1.0), Misc.cegui_reldim( 1.0)));
            fwnd.setSize(new UVector2(Misc.cegui_reldim(0.44), Misc.cegui_reldim( 0.94)));
            fwnd.setText("Demo 6 - Control Panel");
            root.addChildWindow(fwnd);
            
            // create combo-box.
            var cbbo:FlameCombobox = winMgr.createWindow("TaharezLook/Combobox", "Demo6/ControlPanel/SelModeBox") as FlameCombobox;
            cbbo.setPosition(new UVector2(Misc.cegui_reldim(0.04), Misc.cegui_reldim( 0.06)));
            cbbo.setSize(new UVector2(Misc.cegui_reldim(0.66), Misc.cegui_reldim( 0.33)));
            fwnd.addChildWindow(cbbo);
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
            
            // column control section
            var st:FlameWindow = winMgr.createWindow("TaharezLook/StaticText", "Demo6/ControlPanel/ColumnPanel");
            fwnd.addChildWindow(st);
            st.setPosition(new UVector2(Misc.cegui_reldim(0.02), Misc.cegui_reldim( 0.12)));
            st.setSize(new UVector2(Misc.cegui_reldim(0.96), Misc.cegui_reldim( 0.25)));
            st.setText("Column Control");
            st.setProperty("VertFormatting", "TopAligned");
            
            var label:FlameWindow = winMgr.createWindow("TaharezLook/StaticText", "Demo6/ControlPanel/Label1");
            st.addChildWindow(label);
            label.setProperty("FrameEnabled", "false");
            label.setProperty("BackgroundEnabled", "false");
            label.setPosition(new UVector2(Misc.cegui_reldim(0.02), Misc.cegui_reldim( 0.2)));
            label.setSize(new UVector2(Misc.cegui_reldim(0.2), Misc.cegui_reldim( 0.12)));
            label.setText("ID Code:");
            
            label = winMgr.createWindow("TaharezLook/StaticText", "Demo6/ControlPanel/Label2");
            st.addChildWindow(label);
            label.setProperty("FrameEnabled", "false");
            label.setProperty("BackgroundEnabled", "false");
            label.setPosition(new UVector2(Misc.cegui_reldim(0.23), Misc.cegui_reldim( 0.2)));
            label.setSize(new UVector2(Misc.cegui_reldim(0.2), Misc.cegui_reldim( 0.12)));
            label.setText("Width:");
            
            label = winMgr.createWindow("TaharezLook/StaticText", "Demo6/ControlPanel/Label3");
            st.addChildWindow(label);
            label.setProperty("FrameEnabled", "false");
            label.setProperty("BackgroundEnabled", "false");
            label.setPosition(new UVector2(Misc.cegui_reldim(0.44), Misc.cegui_reldim( 0.2)));
            label.setSize(new UVector2(Misc.cegui_reldim(0.2), Misc.cegui_reldim( 0.12)));
            label.setText("Caption:");
            
            var btn:FlamePushButton = winMgr.createWindow("TaharezLook/Button", "Demo6/ControlPanel/ColumnPanel/AddColButton") as FlamePushButton;
            st.addChildWindow(btn);
            btn.setPosition(new UVector2(Misc.cegui_reldim(0.81), Misc.cegui_reldim( 0.32)));
            btn.setSize(new UVector2(Misc.cegui_reldim(0.15), Misc.cegui_reldim( 0.2)));
            btn.setText("Add");
            
            var ebox:FlameEditbox = winMgr.createWindow("TaharezLook/Editbox", "Demo6/ControlPanel/ColumnPanel/NewColIDBox") as FlameEditbox;
            st.addChildWindow(ebox);
            ebox.setPosition(new UVector2(Misc.cegui_reldim(0.02), Misc.cegui_reldim( 0.32)));
            ebox.setSize(new UVector2(Misc.cegui_reldim(0.2), Misc.cegui_reldim( 0.2)));
            ebox.setValidationString("\\d*");
            ebox.setText("Test -- ");
            
            ebox = winMgr.createWindow("TaharezLook/Editbox", "Demo6/ControlPanel/ColumnPanel/NewColWidthBox") as FlameEditbox;
            st.addChildWindow(ebox);
            ebox.setPosition(new UVector2(Misc.cegui_reldim(0.23), Misc.cegui_reldim( 0.32)));
            ebox.setSize(new UVector2(Misc.cegui_reldim(0.2), Misc.cegui_reldim( 0.2)));
            ebox.setValidationString("\\d*");
            
            ebox = winMgr.createWindow("TaharezLook/Editbox", "Demo6/ControlPanel/ColumnPanel/NewColTextBox") as FlameEditbox;
            st.addChildWindow(ebox);
            ebox.setPosition(new UVector2(Misc.cegui_reldim(0.44), Misc.cegui_reldim( 0.32)));
            ebox.setSize(new UVector2(Misc.cegui_reldim(0.36), Misc.cegui_reldim( 0.2)));
            ebox.setValidationString(".*");
            
            label = winMgr.createWindow("TaharezLook/StaticText", "Demo6/ControlPanel/Label4");
            st.addChildWindow(label);
            label.setProperty("FrameEnabled", "false");
            label.setProperty("BackgroundEnabled", "false");
            label.setPosition(new UVector2(Misc.cegui_reldim(0.02), Misc.cegui_reldim( 0.55)));
            label.setSize(new UVector2(Misc.cegui_reldim(0.2), Misc.cegui_reldim( 0.12)));
            label.setText("ID Code:");
            
            ebox = winMgr.createWindow("TaharezLook/Editbox", "Demo6/ControlPanel/ColumnPanel/DelColIDBox") as FlameEditbox;
            st.addChildWindow(ebox);
            ebox.setPosition(new UVector2(Misc.cegui_reldim(0.02), Misc.cegui_reldim( 0.67)));
            ebox.setSize(new UVector2(Misc.cegui_reldim(0.2), Misc.cegui_reldim( 0.2)));
            ebox.setValidationString("\\d*");
            
            btn = winMgr.createWindow("TaharezLook/Button", "Demo6/ControlPanel/ColumnPanel/DelColButton") as FlamePushButton;
            st.addChildWindow(btn);
            btn.setPosition(new UVector2(Misc.cegui_reldim(0.25), Misc.cegui_reldim( 0.67)));
            btn.setSize(new UVector2(Misc.cegui_reldim(0.4), Misc.cegui_reldim( 0.2)));
            btn.setText("Delete Column");
            
            // Row control box
            st = winMgr.createWindow("TaharezLook/StaticText", "Demo6/ControlPanel/RowControl");
            fwnd.addChildWindow(st);
            st.setPosition(new UVector2(Misc.cegui_reldim(0.02), Misc.cegui_reldim( 0.38)));
            st.setSize(new UVector2(Misc.cegui_reldim(0.96), Misc.cegui_reldim( 0.25)));
            st.setText("Row Control");
            st.setProperty("VertFormatting", "TopAligned");
            
            label = winMgr.createWindow("TaharezLook/StaticText", "Demo6/ControlPanel/Label5");
            st.addChildWindow(label);
            label.setProperty("FrameEnabled", "false");
            label.setProperty("BackgroundEnabled", "false");
            label.setPosition(new UVector2(Misc.cegui_reldim(0.02), Misc.cegui_reldim( 0.2)));
            label.setSize(new UVector2(Misc.cegui_reldim(0.2), Misc.cegui_reldim( 0.12)));
            label.setText("Col ID:");
            
            label = winMgr.createWindow("TaharezLook/StaticText", "Demo6/ControlPanel/Label6");
            st.addChildWindow(label);
            label.setProperty("FrameEnabled", "false");
            label.setProperty("BackgroundEnabled", "false");
            label.setPosition(new UVector2(Misc.cegui_reldim(0.23), Misc.cegui_reldim( 0.2)));
            label.setSize(new UVector2(Misc.cegui_reldim(0.55), Misc.cegui_reldim( 0.12)));
            label.setText("Item Text:");
            
            ebox = winMgr.createWindow("TaharezLook/Editbox", "Demo6/ControlPanel/ColumnPanel/RowColIDBox") as FlameEditbox;
            st.addChildWindow(ebox);
            ebox.setPosition(new UVector2(Misc.cegui_reldim(0.02), Misc.cegui_reldim( 0.32)));
            ebox.setSize(new UVector2(Misc.cegui_reldim(0.2), Misc.cegui_reldim( 0.2)));
            ebox.setValidationString("\\d*");
            
            ebox = winMgr.createWindow("TaharezLook/Editbox", "Demo6/ControlPanel/ColumnPanel/RowTextBox") as FlameEditbox;
            st.addChildWindow(ebox);
            ebox.setPosition(new UVector2(Misc.cegui_reldim(0.23), Misc.cegui_reldim( 0.32)));
            ebox.setSize(new UVector2(Misc.cegui_reldim(0.55), Misc.cegui_reldim( 0.2)));
            ebox.setValidationString(".*");
            
            btn = winMgr.createWindow("TaharezLook/Button", "Demo6/ControlPanel/ColumnPanel/AddRowButton") as FlamePushButton;
            st.addChildWindow(btn);
            btn.setPosition(new UVector2(Misc.cegui_reldim(0.81), Misc.cegui_reldim( 0.32)));
            btn.setSize(new UVector2(Misc.cegui_reldim(0.15), Misc.cegui_reldim( 0.2)));
            btn.setText("Add");
            
            label = winMgr.createWindow("TaharezLook/StaticText", "Demo6/ControlPanel/Label7");
            st.addChildWindow(label);
            label.setProperty("FrameEnabled", "false");
            label.setProperty("BackgroundEnabled", "false");
            label.setPosition(new UVector2(Misc.cegui_reldim(0.02), Misc.cegui_reldim( 0.55)));
            label.setSize(new UVector2(Misc.cegui_reldim(0.2), Misc.cegui_reldim( 0.12)));
            label.setText("Row Idx:");
            
            ebox = winMgr.createWindow("TaharezLook/Editbox", "Demo6/ControlPanel/ColumnPanel/DelRowIdxBox") as FlameEditbox;
            st.addChildWindow(ebox);
            ebox.setPosition(new UVector2(Misc.cegui_reldim(0.02), Misc.cegui_reldim( 0.67)));
            ebox.setSize(new UVector2(Misc.cegui_reldim(0.2), Misc.cegui_reldim( 0.2)));
            ebox.setValidationString("\\d*");
            
            btn = winMgr.createWindow("TaharezLook/Button", "Demo6/ControlPanel/ColumnPanel/DelRowButton") as FlamePushButton;
            st.addChildWindow(btn);
            btn.setPosition(new UVector2(Misc.cegui_reldim(0.25), Misc.cegui_reldim( 0.67)));
            btn.setSize(new UVector2(Misc.cegui_reldim(0.4), Misc.cegui_reldim( 0.2)));
            btn.setText("Delete Row");
            
            // set item box
            st = winMgr.createWindow("TaharezLook/StaticText", "Demo6/ControlPanel/SetItemPanel");
            fwnd.addChildWindow(st);
            st.setPosition(new UVector2(Misc.cegui_reldim(0.02), Misc.cegui_reldim( 0.65)));
            st.setSize(new UVector2(Misc.cegui_reldim(0.96), Misc.cegui_reldim( 0.25)));
            st.setText("Item Modification");
            st.setProperty("VertFormatting", "TopAligned");
            
            label = winMgr.createWindow("TaharezLook/StaticText", "Demo6/ControlPanel/Label8");
            st.addChildWindow(label);
            label.setProperty("FrameEnabled", "false");
            label.setProperty("BackgroundEnabled", "false");
            label.setPosition(new UVector2(Misc.cegui_reldim(0.02), Misc.cegui_reldim( 0.2)));
            label.setSize(new UVector2(Misc.cegui_reldim(0.2), Misc.cegui_reldim( 0.12)));
            label.setText("Row Idx:");
            
            label = winMgr.createWindow("TaharezLook/StaticText", "Demo6/ControlPanel/Label9");
            st.addChildWindow(label);
            label.setProperty("FrameEnabled", "false");
            label.setProperty("BackgroundEnabled", "false");
            label.setPosition(new UVector2(Misc.cegui_reldim(0.23), Misc.cegui_reldim( 0.2)));
            label.setSize(new UVector2(Misc.cegui_reldim(0.2), Misc.cegui_reldim( 0.12)));
            label.setText("Col ID:");
            
            label = winMgr.createWindow("TaharezLook/StaticText", "Demo6/ControlPanel/Label10");
            st.addChildWindow(label);
            label.setProperty("FrameEnabled", "false");
            label.setProperty("BackgroundEnabled", "false");
            label.setPosition(new UVector2(Misc.cegui_reldim(0.44), Misc.cegui_reldim( 0.2)));
            label.setSize(new UVector2(Misc.cegui_reldim(0.2), Misc.cegui_reldim( 0.12)));
            label.setText("Item Text:");
            
            ebox = winMgr.createWindow("TaharezLook/Editbox", "Demo6/ControlPanel/ColumnPanel/SetItemRowBox") as FlameEditbox;
            st.addChildWindow(ebox);
            ebox.setPosition(new UVector2(Misc.cegui_reldim(0.02), Misc.cegui_reldim( 0.32)));
            ebox.setSize(new UVector2(Misc.cegui_reldim(0.2), Misc.cegui_reldim( 0.2)));
            ebox.setValidationString("\\d*");
            
            ebox = winMgr.createWindow("TaharezLook/Editbox", "Demo6/ControlPanel/ColumnPanel/SetItemIDBox") as FlameEditbox;
            st.addChildWindow(ebox);
            ebox.setPosition(new UVector2(Misc.cegui_reldim(0.23), Misc.cegui_reldim( 0.32)));
            ebox.setSize(new UVector2(Misc.cegui_reldim(0.2), Misc.cegui_reldim( 0.2)));
            ebox.setValidationString("\\d*");
            
            ebox = winMgr.createWindow("TaharezLook/Editbox", "Demo6/ControlPanel/ColumnPanel/SetItemTextBox") as FlameEditbox;
            st.addChildWindow(ebox);
            ebox.setPosition(new UVector2(Misc.cegui_reldim(0.44), Misc.cegui_reldim( 0.32)));
            ebox.setSize(new UVector2(Misc.cegui_reldim(0.36), Misc.cegui_reldim( 0.2)));
            ebox.setValidationString(".*");
            
            btn = winMgr.createWindow("TaharezLook/Button", "Demo6/ControlPanel/ColumnPanel/SetItemButton") as FlamePushButton;
            st.addChildWindow(btn);
            btn.setPosition(new UVector2(Misc.cegui_reldim(0.81), Misc.cegui_reldim( 0.32)));
            btn.setSize(new UVector2(Misc.cegui_reldim(0.15), Misc.cegui_reldim( 0.2)));
            btn.setText("Set");
            
            label = winMgr.createWindow("TaharezLook/StaticText", "Demo6/ControlPanel/RowCount");
            st.addChildWindow(label);
            label.setProperty("FrameEnabled", "false");
            label.setProperty("BackgroundEnabled", "false");
            label.setPosition(new UVector2(Misc.cegui_reldim(0.02), Misc.cegui_reldim( 0.55)));
            label.setSize(new UVector2(Misc.cegui_reldim(1.0), Misc.cegui_reldim( 0.12)));
            label.setText("Current Row Count:");
            
            label = winMgr.createWindow("TaharezLook/StaticText", "Demo6/ControlPanel/ColCount");
            st.addChildWindow(label);
            label.setProperty("FrameEnabled", "false");
            label.setProperty("BackgroundEnabled", "false");
            label.setPosition(new UVector2(Misc.cegui_reldim(0.02), Misc.cegui_reldim( 0.67)));
            label.setSize(new UVector2(Misc.cegui_reldim(1.0), Misc.cegui_reldim( 0.12)));
            label.setText("Current Column Count:");
            
            label = winMgr.createWindow("TaharezLook/StaticText", "Demo6/ControlPanel/SelCount");
            st.addChildWindow(label);
            label.setProperty("FrameEnabled", "false");
            label.setProperty("BackgroundEnabled", "false");
            label.setPosition(new UVector2(Misc.cegui_reldim(0.02), Misc.cegui_reldim( 0.79)));
            label.setSize(new UVector2(Misc.cegui_reldim(1.0), Misc.cegui_reldim( 0.12)));
            label.setText("Current Selected Count:");
            
            btn = winMgr.createWindow("TaharezLook/Button", "Demo6/QuitButton") as FlamePushButton;
            fwnd.addChildWindow(btn);
            btn.setPosition(new UVector2(Misc.cegui_reldim(0.25), Misc.cegui_reldim( 0.93)));
            btn.setSize(new UVector2(Misc.cegui_reldim(0.50), Misc.cegui_reldim( 0.05)));
            btn.setText("Quit This Demo!");
        }
        
        private function initDemoEventWiring():void
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            
            // subscribe handler that adds a new column
            winMgr.getWindow("Demo6/ControlPanel/ColumnPanel/AddColButton").
                subscribeEvent(FlamePushButton.EventClicked, new Subscriber(handleAddColumn, this), FlamePushButton.EventNamespace);
            
            // subscribe handler that deletes a column
            winMgr.getWindow("Demo6/ControlPanel/ColumnPanel/DelColButton").
                subscribeEvent(FlamePushButton.EventClicked, new Subscriber(handleDeleteColumn, this), FlamePushButton.EventNamespace);
            
            // subscribe handler that adds a new row
            winMgr.getWindow("Demo6/ControlPanel/ColumnPanel/AddRowButton").
                subscribeEvent(FlamePushButton.EventClicked, new Subscriber(handleAddRow, this), FlamePushButton.EventNamespace);
            
            // subscribe handler that deletes a row
            winMgr.getWindow("Demo6/ControlPanel/ColumnPanel/DelRowButton").
                subscribeEvent(FlamePushButton.EventClicked, new Subscriber(handleDeleteRow, this), FlamePushButton.EventNamespace);
            
            // subscribe handler that sets the text for an existing item
            winMgr.getWindow("Demo6/ControlPanel/ColumnPanel/SetItemButton").
                subscribeEvent(FlamePushButton.EventClicked, new Subscriber(handleSetItem, this), FlamePushButton.EventNamespace);
            
            // subscribe handler that quits the application
            winMgr.getWindow("Demo6/QuitButton").
                subscribeEvent(FlamePushButton.EventClicked, new Subscriber(handleQuit, this), FlamePushButton.EventNamespace);
            
            // subscribe handler that processes a change in the 'selection mode' combobox
            winMgr.getWindow("Demo6/ControlPanel/SelModeBox").
                subscribeEvent(FlameCombobox.EventListSelectionAccepted, new Subscriber(handleSelectModeChanged, this), FlameCombobox.EventNamespace);
            
            // subscribe handler that processes a change in the item(s) selected in the list
            winMgr.getWindow("Demo6/MainList").
                subscribeEvent(FlameMultiColumnList.EventSelectionChanged, new Subscriber(handleSelectChanged, this), FlameMultiColumnList.EventNamespace);
            
            // subscribe handler that processes a change in the list content.
            winMgr.getWindow("Demo6/MainList").
                subscribeEvent(FlameMultiColumnList.EventListContentsChanged, new Subscriber(handleContentsChanged, this), FlameMultiColumnList.EventNamespace);
        }
            
        private function handleQuit(e:EventArgs):Boolean
        {
            // signal quit
            //d_sampleApp->setQuitting();
            
            // event was handled
            return true;
        }
                
        private function handleAddColumn(e:EventArgs):Boolean
        {
            // get access to the widgets that contain details about the column to add
            var mcl:FlameMultiColumnList = FlameMultiColumnList(FlameWindowManager.getSingleton().getWindow("Demo6/MainList"));
            var idbox:FlameEditbox = FlameEditbox(FlameWindowManager.getSingleton().getWindow("Demo6/ControlPanel/ColumnPanel/NewColIDBox"));
            var widthbox:FlameEditbox = FlameEditbox(FlameWindowManager.getSingleton().getWindow("Demo6/ControlPanel/ColumnPanel/NewColWidthBox"));
            var textbox:FlameEditbox = FlameEditbox(FlameWindowManager.getSingleton().getWindow("Demo6/ControlPanel/ColumnPanel/NewColTextBox"));
            
            // get ID for new column
            var id:uint = uint(idbox.getText());
            // get width to use for new column (in pixels)
            var width:Number = Number(widthbox.getText());
            // get column label text
            var text:String = textbox.getText();
            
            // re-set the widget contents
            idbox.setText("");
            widthbox.setText("");
            textbox.setText("");
            
            // ensure a minimum width of 10 pixels
            if (width < 10.0)
                width = 10.0;
            
            // finally, add the new column to the list.
            mcl.addColumn(text, id, Misc.cegui_absdim(width));
            
            // event was handled.
            return true;
        }
                    
        private function handleDeleteColumn(e:EventArgs):Boolean
        {
            // get access to the widgets that contain details about the column to delete
            var mcl:FlameMultiColumnList = FlameMultiColumnList(FlameWindowManager.getSingleton().getWindow("Demo6/MainList"));
            var idbox:FlameEditbox = FlameEditbox(FlameWindowManager.getSingleton().getWindow("Demo6/ControlPanel/ColumnPanel/DelColIDBox"));
            
            // obtain the id of the column to be deleted
            var id:uint = uint(idbox.getText());
            
            // attempt to delete the column, ignoring any errors.
            try
            {
                mcl.removeColumnWithID(id);
            }
            catch (error:Error)
            {}
            
            // reset the delete column ID box.
            idbox.setText("");
            
            // event was handled.
            return true;
        }
                        
        private function handleAddRow(e:EventArgs):Boolean
        {
            // get access to the widgets that contain details about the row to add
            var mcl:FlameMultiColumnList = FlameMultiColumnList(FlameWindowManager.getSingleton().getWindow("Demo6/MainList"));
            var idbox:FlameEditbox = FlameEditbox(FlameWindowManager.getSingleton().getWindow("Demo6/ControlPanel/ColumnPanel/RowColIDBox"));
            var textbox:FlameEditbox = FlameEditbox(FlameWindowManager.getSingleton().getWindow("Demo6/ControlPanel/ColumnPanel/RowTextBox"));
            
            // get the ID of the initial column item to set
            var id:uint = uint(idbox.getText());
            // get the text that is to be set initially into the specified column of the new row
            var text:String = textbox.getText();
            
            // reset input boxes
            idbox.setText("");
            textbox.setText("");
            
            // construct a new ListboxTextItem with the required string
            var item:FlameListboxTextItem = new FlameListboxTextItem(text);
            // set the selection brush to use for this item.
            item.setSelectionBrushImage(FlameImageSetManager.getSingleton().getImageSet("TaharezLook").getImage("MultiListSelectionBrush"));
            
            // attempt to add a new row, using the new ListboxTextItem as the initial content for one of the columns
            try
            {
                mcl.addRow(item, id);
            }
            // something went wrong, so cleanup the ListboxTextItem
            catch (error:Error)
            {
                item = null;
            }
            
            // event was handled.
            return true;
        }
                            
        private function handleDeleteRow(e:EventArgs):Boolean
        {
            // get access to the widgets that contain details about the row to delete.
            var mcl:FlameMultiColumnList = FlameMultiColumnList(FlameWindowManager.getSingleton().getWindow("Demo6/MainList"));
            var idxbox:FlameEditbox = FlameEditbox(FlameWindowManager.getSingleton().getWindow("Demo6/ControlPanel/ColumnPanel/DelRowIdxBox"));
            
            // get index of row to delete.
            var idx:uint = uint(idxbox.getText());
            
            // attempt to delete the row, ignoring any errors.
            try
            {
                mcl.removeRow(idx);
            }
            catch (error:Error)
            {}
            
            // clear the row index box
            idxbox.setText("");
            
            // event was handled.
            return true;
        }
                                
        private function handleSetItem(e:EventArgs):Boolean
        {
            // get access to the widgets that contain details about the item to be modified
            var mcl:FlameMultiColumnList = FlameMultiColumnList(FlameWindowManager.getSingleton().getWindow("Demo6/MainList"));
            var idbox:FlameEditbox = FlameEditbox(FlameWindowManager.getSingleton().getWindow("Demo6/ControlPanel/ColumnPanel/SetItemIDBox"));
            var rowbox:FlameEditbox = FlameEditbox(FlameWindowManager.getSingleton().getWindow("Demo6/ControlPanel/ColumnPanel/SetItemRowBox"));
            var textbox:FlameEditbox = FlameEditbox(FlameWindowManager.getSingleton().getWindow("Demo6/ControlPanel/ColumnPanel/SetItemTextBox"));
            
            // get ID of column to be affected
            var id:uint = uint(idbox.getText());
            // get index of row to be affected
            var row:uint = uint(rowbox.getText());
            // get new text for item
            var text:String = textbox.getText();
            
            // reset input boxes
            idbox.setText("");
            rowbox.setText("");
            textbox.setText("");
            
            // create a new ListboxTextItem using the new text string
            var item:FlameListboxTextItem = new FlameListboxTextItem(text);
            // set the selection brush to be used for this item.
            item.setSelectionBrushImage(FlameImageSetManager.getSingleton().getImageSet("TaharezLook").getImage("MultiListSelectionBrush"));
            
            // attempt to set the new item in place
            try
            {
                mcl.setItem(item, id, row);
            }
            // something went wrong, so cleanup the ListboxTextItem.
            catch (error:Error)
            {
                item = null;
            }
            
            // event was handled.
            return true;
        }
                                    
        private function handleSelectChanged(e:EventArgs):Boolean
        {
            // Get access to the list
            var mcl:FlameMultiColumnList = FlameMultiColumnList(FlameWindowManager.getSingleton().getWindow("Demo6/MainList"));
            
            // update the selected count
            var tmp:String = "Current Selected Count: " + mcl.getSelectedCount();
            
            FlameWindowManager.getSingleton().getWindow("Demo6/ControlPanel/SelCount").setText(tmp);
            
            // event was handled.
            return true;
        }
        
        private function handleSelectModeChanged(e:EventArgs):Boolean
        {
            // get access to list
            var mcl:FlameMultiColumnList = FlameMultiColumnList(FlameWindowManager.getSingleton().getWindow("Demo6/MainList"));
            // get access to the combobox
            var combo:FlameCombobox = FlameCombobox(FlameWindowManager.getSingleton().getWindow("Demo6/ControlPanel/SelModeBox"));
            
            // find the selected item in the combobox
            var item:FlameListboxItem = combo.findItemWithText(combo.getText(), null);
            
            // set new selection mode according to ID of selected ListboxItem
            if (item)
            {
                switch (item.getID())
                {
                    case 0:
                        mcl.setSelectionMode(Consts.SelectionMode_RowSingle);
                        break;
                    
                    case 1:
                        mcl.setSelectionMode(Consts.SelectionMode_RowMultiple);
                        break;
                    
                    case 2:
                        mcl.setSelectionMode(Consts.SelectionMode_ColumnSingle);
                        break;
                    
                    case 3:
                        mcl.setSelectionMode(Consts.SelectionMode_ColumnMultiple);
                        break;
                    
                    case 4:
                        mcl.setSelectionMode(Consts.SelectionMode_CellSingle);
                        break;
                    
                    case 5:
                        mcl.setSelectionMode(Consts.SelectionMode_CellMultiple);
                        break;
                    
                    case 6:
                        mcl.setSelectionMode(Consts.SelectionMode_NominatedColumnSingle);
                        break;
                    
                    case 7:
                        mcl.setSelectionMode(Consts.SelectionMode_NominatedColumnMultiple);
                        break;
                    
                    case 8:
                        mcl.setSelectionMode(Consts.SelectionMode_NominatedRowSingle);
                        break;
                    
                    case 9:
                        mcl.setSelectionMode(Consts.SelectionMode_NominatedRowMultiple);
                        break;
                    
                    default:
                        mcl.setSelectionMode(Consts.SelectionMode_RowSingle);
                        break;
                    
                }
            }
            
            // event was handled.
            return true;
        }
            
        private function handleContentsChanged(e:EventArgs):Boolean
        {
            // get access to required widgets
            var mcl:FlameMultiColumnList = FlameMultiColumnList(FlameWindowManager.getSingleton().getWindow("Demo6/MainList"));
            var colText:FlameWindow = FlameWindowManager.getSingleton().getWindow("Demo6/ControlPanel/ColCount");
            var rowText:FlameWindow = FlameWindowManager.getSingleton().getWindow("Demo6/ControlPanel/RowCount");
            
            // update the column count
            var tmp:String = "Current Column Count: " + mcl.getColumnCount();
            colText.setText(tmp);
            
            // update the row count
            tmp = "Current Row Count: " + mcl.getRowCount();
            rowText.setText(tmp);
            
            // event was handled.
            return true;
        }
    }
}
