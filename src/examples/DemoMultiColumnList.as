

package examples {
    import Flame2D.core.data.Consts;
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.system.FlameEvent;
    import Flame2D.core.system.FlameImageSetManager;
    import Flame2D.core.system.FlameMouseCursor;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.UDim;
    import Flame2D.core.utils.UVector2;
    import Flame2D.elements.button.FlamePushButton;
    import Flame2D.elements.list.FlameMultiColumnList;
    import Flame2D.elements.list.MCLGridRef;
    import Flame2D.elements.listbox.FlameListboxItem;
    import Flame2D.elements.listbox.FlameListboxTextItem;
    import Flame2D.elements.window.FlameGUISheet;
    
    import flash.events.KeyboardEvent;
    import examples.base.BaseApplication;
    
    
    [SWF(width="800", height="600", frameRate="60")]
    public class DemoMultiColumnList extends BaseApplication
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
            
            var multiColumnList:FlameMultiColumnList = winMgr.createWindow("TaharezLook/MultiColumnList") as FlameMultiColumnList;
            multiColumnList.setPosition(new UVector2(Misc.cegui_absdim(200), Misc.cegui_absdim(100)));
            multiColumnList.setSize(new UVector2(Misc.cegui_absdim(360), Misc.cegui_absdim(300)));
            multiColumnList.addColumn("Col A", 0, new UDim(0.32, 0));
            multiColumnList.addColumn("Col B", 1, new UDim(0.32, 0));
            multiColumnList.addColumn("Col C", 2, new UDim(0.32, 0));
            multiColumnList.setSelectionMode(Consts.SelectionMode_RowSingle); // MultiColumnList::RowMultiple
            
            var itemMultiColumnList:FlameListboxTextItem;
            multiColumnList.addEmptyRow();
            itemMultiColumnList = new FlameListboxTextItem("A1", 101);
            itemMultiColumnList.setSelectionBrushImageFromImageSet("TaharezLook", "MultiListSelectionBrush");
            multiColumnList.setItem(itemMultiColumnList, 0, 0); // ColumnID, RowID
            itemMultiColumnList = new FlameListboxTextItem("B1", 102);
            itemMultiColumnList.setSelectionBrushImageFromImageSet("TaharezLook", "MultiListSelectionBrush");
            // By commenting the line above a cell does not specify a selection indicator
            //  selecting that line will show a "gap" in the selection.
            multiColumnList.setItem(itemMultiColumnList, 1, 0); // ColumnID, RowID
            itemMultiColumnList = new FlameListboxTextItem("C1", 103);
            itemMultiColumnList.setSelectionBrushImageFromImageSet("TaharezLook", "MultiListSelectionBrush");
            multiColumnList.setItem(itemMultiColumnList, 2, 0); // ColumnID, RowID
            multiColumnList.addEmptyRow();
            itemMultiColumnList = new FlameListboxTextItem("A2", 201);
            itemMultiColumnList.setSelectionBrushImageFromImageSet("TaharezLook", "MultiListSelectionBrush");
            multiColumnList.setItem(itemMultiColumnList, 0, 1); // ColumnID, RowID
            itemMultiColumnList = new FlameListboxTextItem("B2", 202);
            itemMultiColumnList.setSelectionBrushImageFromImageSet("TaharezLook", "MultiListSelectionBrush");
            multiColumnList.setItem(itemMultiColumnList, 1, 1); // ColumnID, RowID
            itemMultiColumnList = new FlameListboxTextItem("C2", 203);
            itemMultiColumnList.setSelectionBrushImageFromImageSet("TaharezLook", "MultiListSelectionBrush");
            multiColumnList.setItem(itemMultiColumnList, 2, 1); // ColumnID, RowID
            var grid_ref:MCLGridRef = new MCLGridRef(1, 0); // Select according to a grid reference; second row
            multiColumnList.setItemSelectStateByGridRef(grid_ref, true);
            var listboxItem:FlameListboxItem = multiColumnList.getFirstSelectedItem();
            var valueColumnA:uint = listboxItem.getID(); // Retrieve the value of the selected item from column A
            listboxItem = multiColumnList.getNextSelected(listboxItem);
            var valueColumnB:uint = listboxItem.getID(); // Retrieve the value of the selected item from column B
            listboxItem = multiColumnList.getNextSelected(listboxItem);
            var valueColumnC:uint = listboxItem.getID(); // Retrieve the value of the selected item from column C

            
            background.addChildWindow(multiColumnList);
        }
    }
}
