

package examples {
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.events.KeyEventArgs;
    import Flame2D.core.events.TreeEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.imagesets.FlameImageSet;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameEvent;
    import Flame2D.core.system.FlameFont;
    import Flame2D.core.system.FlameFontManager;
    import Flame2D.core.system.FlameImageSetManager;
    import Flame2D.core.system.FlameMouseCursor;
    import Flame2D.core.system.FlameResourceProvider;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.UVector2;
    import Flame2D.elements.button.FlamePushButton;
    import Flame2D.elements.editbox.FlameEditbox;
    import Flame2D.elements.tree.FlameTree;
    import Flame2D.elements.tree.FlameTreeItem;
    import Flame2D.elements.window.FlameGUISheet;
    import Flame2D.loaders.TextFileLoader;
    
    import flash.events.KeyboardEvent;
    import examples.base.BaseApplication;
    
    
    [SWF(width="800", height="600", frameRate="60")]
    public class DemoTree extends BaseApplication
    {
        private static const  SCHEME_FILE_NAME:String =   "TaharezLook.scheme";
        private static const  IMAGES_FILE_NAME:String =   "TaharezLook";
        private static const  STATICIMAGE_NAME:String =   "TaharezLook/StaticImage";
        private static const  TOOLTIP_NAME    :String =   "TaharezLook/Tooltip";
        private static const  LAYOUT_FILE_NAME:String =   "TreeDemoTaharez.layout";
        private static const  BRUSH_NAME      :String =   "TextSelectionBrush";
        
        private var TreeDemoWindow:FlameWindow;
        private static const TreeID:uint = 1;
        private static const EditBoxID:uint = 2;
        
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
//            var font:FlameFont = FlameFontManager.getSingleton().createSystemFont("kaiti", 18);
//            FlameSystem.getSingleton().setDefaultFont(font);
            
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
            
            var url:String = FlameResourceProvider.getSingleton().getResourceDir() + 
                FlameResourceProvider.getSingleton().getLayoutDir() + 
                LAYOUT_FILE_NAME;
            
            new TextFileLoader({}, url, onFileLoaded);
            
        }
        
        private function onFileLoaded(tag:*, str:String):void
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            var background:FlameWindow = winMgr.getWindow("root_wnd");

            var theTree:FlameTree;
            var newTreeCtrlEntryLvl1:FlameTreeItem;  // Level 1 TreeCtrlEntry (branch)
            var newTreeCtrlEntryLvl2:FlameTreeItem;  // Level 2 TreeCtrlEntry (branch)
            var newTreeCtrlEntryLvl3:FlameTreeItem;  // Level 3 TreeCtrlEntry (branch)
            var newTreeCtrlEntryParent:FlameTreeItem;
            var iconArray:Array = new Array(9);     //Flame Image

            TreeDemoWindow = winMgr.loadWindowLayoutFromString(str);
            
            // listen for key presses on the root window.
            background.subscribeEvent(FlameWindow.EventKeyDown, new Subscriber(handleRootKeyDown, this), FlameWindow.EventNamespace);
            
            theTree = TreeDemoWindow.getChildByID(TreeID) as FlameTree;
            //theTree.setFont(FlameSystem.getSingleton().getDefaultFont());
            theTree.initialise();
            theTree.subscribeEvent(FlameTree.EventSelectionChanged, new Subscriber(handleEventSelectionChanged, this), FlameTree.EventNamespace);
            theTree.subscribeEvent(FlameTree.EventBranchOpened, new Subscriber(handleEventBranchOpened, this), FlameTree.EventNamespace);
            theTree.subscribeEvent(FlameTree.EventBranchClosed, new Subscriber(handleEventBranchClosed, this), FlameTree.EventNamespace);
            
            // activate the background window
            background.activate();
            
            var drives:FlameImageSet = FlameImageSetManager.getSingleton().getImageSet("DriveIcons");
            iconArray[0] = drives.getImage("Artic") as FlameImage;
            iconArray[1] = drives.getImage("Black") as FlameImage;
            iconArray[2] = drives.getImage("Sunset") as FlameImage;
            iconArray[3] = drives.getImage("DriveStack") as FlameImage;
            iconArray[4] = drives.getImage("GlobalDrive") as FlameImage;
            iconArray[5] = drives.getImage("Blue") as FlameImage;
            iconArray[6] = drives.getImage("Lime") as FlameImage;
            iconArray[7] = drives.getImage("Silver") as FlameImage;
            iconArray[8] = drives.getImage("GreenCandy") as FlameImage;
            
            // Create a top-most TreeCtrlEntry
            newTreeCtrlEntryLvl1 = new FlameTreeItem("Tree Item Level 1a");
            newTreeCtrlEntryLvl1.setIcon(drives.getImage("Black"));
            newTreeCtrlEntryLvl1.setSelectionBrushImageFromImageSet(IMAGES_FILE_NAME, BRUSH_NAME);
            //   newTreeCtrlEntryLvl1->setUserData((void *)someData);
            theTree.addItem(newTreeCtrlEntryLvl1);
            // Create a second-level TreeCtrlEntry and attach it to the top-most TreeCtrlEntry
            newTreeCtrlEntryLvl2 = new FlameTreeItem("Tree Item Level 2a (1a)");
            newTreeCtrlEntryLvl2.setIcon(drives.getImage("Artic"));
            newTreeCtrlEntryLvl2.setSelectionBrushImageFromImageSet(IMAGES_FILE_NAME, BRUSH_NAME);
            newTreeCtrlEntryLvl1.addItem(newTreeCtrlEntryLvl2);
            // Create a third-level TreeCtrlEntry and attach it to the above TreeCtrlEntry
            newTreeCtrlEntryLvl3 = new FlameTreeItem("Tree Item Level 3a (2a)");
            newTreeCtrlEntryLvl3.setIcon(drives.getImage("Blue"));
            newTreeCtrlEntryLvl3.setSelectionBrushImageFromImageSet(IMAGES_FILE_NAME, BRUSH_NAME);
            newTreeCtrlEntryLvl2.addItem(newTreeCtrlEntryLvl3);
            // Create another third-level TreeCtrlEntry and attach it to the above TreeCtrlEntry
            newTreeCtrlEntryLvl3 = new FlameTreeItem("Tree Item Level 3b (2a)");
            newTreeCtrlEntryLvl3.setIcon(drives.getImage("Lime"));
            newTreeCtrlEntryLvl3.setSelectionBrushImageFromImageSet(IMAGES_FILE_NAME, BRUSH_NAME);
            newTreeCtrlEntryLvl2.addItem(newTreeCtrlEntryLvl3);
            // Create another second-level TreeCtrlEntry and attach it to the top-most TreeCtrlEntry
            newTreeCtrlEntryLvl2 = new FlameTreeItem("Tree Item Level 2b (1a)");
            newTreeCtrlEntryLvl2.setIcon(drives.getImage("Sunset"));
            newTreeCtrlEntryLvl2.setSelectionBrushImageFromImageSet(IMAGES_FILE_NAME, BRUSH_NAME);
            newTreeCtrlEntryLvl1.addItem(newTreeCtrlEntryLvl2);
            // Create another second-level TreeCtrlEntry and attach it to the top-most TreeCtrlEntry
            newTreeCtrlEntryLvl2 = new FlameTreeItem("Tree Item Level 2c (1a)");
            newTreeCtrlEntryLvl2.setIcon(drives.getImage("Silver"));
            newTreeCtrlEntryLvl2.setSelectionBrushImageFromImageSet(IMAGES_FILE_NAME, BRUSH_NAME);
            newTreeCtrlEntryLvl1.addItem(newTreeCtrlEntryLvl2);
            
            // Create another top-most TreeCtrlEntry
            newTreeCtrlEntryLvl1 = new FlameTreeItem("Tree Item Level 1b");
            newTreeCtrlEntryLvl1.setSelectionBrushImageFromImageSet(IMAGES_FILE_NAME, BRUSH_NAME);
            newTreeCtrlEntryLvl1.setIcon(drives.getImage("DriveStack"));
            newTreeCtrlEntryLvl1.setDisabled(true); // Let's disable this one just to be sure it works
            theTree.addItem(newTreeCtrlEntryLvl1);
            // Create a second-level TreeCtrlEntry and attach it to the top-most TreeCtrlEntry
            newTreeCtrlEntryLvl2 = new FlameTreeItem("Tree Item Level 2a (1b)");
            newTreeCtrlEntryLvl2.setSelectionBrushImageFromImageSet(IMAGES_FILE_NAME, BRUSH_NAME);
            newTreeCtrlEntryLvl1.addItem(newTreeCtrlEntryLvl2);
            // Create another second-level TreeCtrlEntry and attach it to the top-most TreeCtrlEntry
            newTreeCtrlEntryLvl2 = new FlameTreeItem("Tree Item Level 2b (1b)");
            newTreeCtrlEntryLvl2.setSelectionBrushImageFromImageSet(IMAGES_FILE_NAME, BRUSH_NAME);
            newTreeCtrlEntryLvl1.addItem(newTreeCtrlEntryLvl2);
            
            newTreeCtrlEntryLvl1 = new FlameTreeItem("Tree Item Level 1c");
            newTreeCtrlEntryLvl1.setSelectionBrushImageFromImageSet(IMAGES_FILE_NAME, BRUSH_NAME);
            theTree.addItem(newTreeCtrlEntryLvl1);
            
            // Now let's create a whole bunch of items automatically
            var levelIndex:int = 3;
            var idepthIndex:int;
            var childIndex:int;
            var childCount:int;
            var iconIndex:uint;
            var itemText:String;
            while (levelIndex < 10)
            {
                idepthIndex = 0;
                itemText = "Tree Item Level " + FlamePropertyHelper.intToString(levelIndex) + " Depth " + FlamePropertyHelper.intToString(idepthIndex);
                newTreeCtrlEntryLvl1 = new FlameTreeItem(itemText);
                // Set a random icon for the item.  Sometimes blank (on purpose).
                iconIndex = Misc.random(11);//randInt(0, (sizeof(iconArray) / sizeof(iconArray[0])) + 2);
//                if (iconIndex < sizeof(iconArray) / sizeof(iconArray[0]))
//                    newTreeCtrlEntryLvl1->setIcon(*iconArray[iconIndex]);
                if(iconIndex < 9)
                    newTreeCtrlEntryLvl1.setIcon(iconArray[iconIndex]);
                newTreeCtrlEntryLvl1.setSelectionBrushImageFromImageSet(IMAGES_FILE_NAME, BRUSH_NAME);
                theTree.addItem(newTreeCtrlEntryLvl1);
                newTreeCtrlEntryParent = newTreeCtrlEntryLvl1;
                
                childIndex = 0;
                childCount = Misc.random(3);
                while (childIndex < childCount)
                {
                    itemText = "Tree Item Level " + FlamePropertyHelper.intToString(levelIndex) + " Depth " + FlamePropertyHelper.intToString(idepthIndex + 1) + " Child " + FlamePropertyHelper.intToString(childIndex + 1);
                    newTreeCtrlEntryLvl2 = new FlameTreeItem(itemText);
                    // Set a random icon for the item.  Sometimes blank (on purpose).
                    iconIndex = Misc.random(11);// randInt(0, (sizeof(iconArray) / sizeof(iconArray[0]) + 2));
                    //if (iconIndex < sizeof(iconArray) / sizeof(iconArray[0]))
                    if(iconIndex < 9)
                        newTreeCtrlEntryLvl2.setIcon(iconArray[iconIndex]);
                    newTreeCtrlEntryLvl2.setSelectionBrushImageFromImageSet(IMAGES_FILE_NAME, BRUSH_NAME);
                    newTreeCtrlEntryParent.addItem(newTreeCtrlEntryLvl2);
                    ++childIndex;
                }
                
                while (idepthIndex < 15)
                {
                    itemText = "Tree Item Level " + FlamePropertyHelper.intToString(levelIndex) + " Depth " + FlamePropertyHelper.intToString(idepthIndex + 1);
                    newTreeCtrlEntryLvl2 = new FlameTreeItem(itemText);
                    // Set a random icon for the item.  Sometimes blank (on purpose).
                    iconIndex = Misc.random(11);//randInt(0, (sizeof(iconArray) / sizeof(iconArray[0]) + 2));
                    //if (iconIndex < sizeof(iconArray) / sizeof(iconArray[0]))
                    if(iconIndex < 9)
                        newTreeCtrlEntryLvl2.setIcon(iconArray[iconIndex]);
                    newTreeCtrlEntryLvl2.setSelectionBrushImageFromImageSet(IMAGES_FILE_NAME, BRUSH_NAME);
                    newTreeCtrlEntryParent.addItem(newTreeCtrlEntryLvl2);
                    newTreeCtrlEntryParent = newTreeCtrlEntryLvl2;
                    
                    childIndex = 0;
                    childCount = Misc.random(3);//randInt(0, 3);
                    while (childIndex < childCount)
                    {
                        itemText = "Tree Item Level " + FlamePropertyHelper.intToString(levelIndex) + " Depth " + FlamePropertyHelper.intToString(idepthIndex + 1) + " Child " + FlamePropertyHelper.intToString(childIndex + 1);
                        newTreeCtrlEntryLvl2 = new FlameTreeItem(itemText);
                        // Set a random icon for the item.  Sometimes blank (on purpose).
                        iconIndex = Misc.random(11);//randInt(0, (sizeof(iconArray) / sizeof(iconArray[0]) + 2));
                        //if (iconIndex < sizeof(iconArray) / sizeof(iconArray[0]))
                        if(iconIndex < 9)
                            newTreeCtrlEntryLvl2.setIcon(iconArray[iconIndex]);
                        newTreeCtrlEntryLvl2.setSelectionBrushImageFromImageSet(IMAGES_FILE_NAME, BRUSH_NAME);
                        newTreeCtrlEntryParent.addItem(newTreeCtrlEntryLvl2);
                        ++childIndex;
                    }
                    ++idepthIndex;
                }
                ++levelIndex;
            }
            
            //add finally, to have correct layout...to be checked
            background.addChildWindow(TreeDemoWindow);

        }
        
        private function handleEventSelectionChanged(args:EventArgs):Boolean
        {
            const treeArgs:TreeEventArgs = TreeEventArgs(args);
            var editBox:FlameEditbox = TreeDemoWindow.getChildByID(EditBoxID) as FlameEditbox;
            
            // Three different ways to get the item selected.
            //   TreeCtrlEntry *selectedItem = theTree->getFirstSelectedItem();      // the first selection in the list (may be more)
            //   TreeCtrlEntry *selectedItem = theTree->getLastSelectedItem();       // the last (time-wise) selected by the user
            var selectedItem:FlameTreeItem = treeArgs.treeItem;                    // the actual item that caused this event
            
            if (selectedItem)
            {
                // The simple way to do it.
                editBox.setText("Selected: " + selectedItem.getText());
            }
            else
                editBox.setText("None Selected");
            
            return true;
        }
            
            
            
        private function handleRootKeyDown(args:EventArgs):Boolean
        {
//            const keyArgs:KeyEventArgs = KeyEventArgs(args);
//            
//            switch (keyArgs.scancode)
//            {
//                case Key_F12:
//                    break;
//                
//                default:
//                    return false;
//            }
            
            return true;
        }
                
                
        private function handleEventBranchOpened(args:EventArgs):Boolean
        {
            const treeArgs:TreeEventArgs = TreeEventArgs(args);
            var editBox:FlameEditbox = TreeDemoWindow.getChildByID(EditBoxID) as FlameEditbox;
            editBox.setText("Opened: " + treeArgs.treeItem.getText());
            return true;
        }
                    
                    
        private function handleEventBranchClosed(args:EventArgs):Boolean
        {
            const treeArgs:TreeEventArgs = TreeEventArgs(args);
            var editBox:FlameEditbox = TreeDemoWindow.getChildByID(EditBoxID) as FlameEditbox;
            editBox.setText("Closed: " + treeArgs.treeItem.getText());
            return true;
        }
    }
}
