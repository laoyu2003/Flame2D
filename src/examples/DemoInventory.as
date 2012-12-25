

package examples  {
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.falagard.FalagardWidgetLookManager;
    import Flame2D.core.system.FlameEvent;
    import Flame2D.core.system.FlameImageSetManager;
    import Flame2D.core.system.FlameMouseCursor;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowFactory;
    import Flame2D.core.system.FlameWindowFactoryManager;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.system.FlameWindowRendererFactory;
    import Flame2D.core.system.FlameWindowRendererManager;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.UDim;
    import Flame2D.core.utils.UVector2;
    import Flame2D.elements.button.FlamePushButton;
    import Flame2D.elements.window.FlameGUISheet;
    
    import examples.Inventory.InventoryItem;
    import examples.Inventory.InventoryItemRenderer;
    import examples.Inventory.InventoryReceiver;
    import examples.base.BaseApplication;
    
    
    [SWF(width="800", height="600", frameRate="60")]
    public class DemoInventory extends BaseApplication
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
            
            background.setMousePassThroughEnabled(true);
            background.moveToFront();
            background.setDistributesCapturedInputs(true);
            
            
            // install this as the root GUI sheet
            FlameSystem.getSingleton().setGUISheet(background);
            
            
            createApp();
            
        }
        
        private function createApp():void
        {
            // register custom objects with CEGUI.
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(InventoryReceiver));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(InventoryItem));
            FlameWindowRendererManager.getSingleton().addFactory(new FlameWindowRendererFactory(InventoryItemRenderer));
            
            // load looknfeel for custom inventory components (needs TaharezLook images)
            FalagardWidgetLookManager.getSingleton().parseLookNFeelSpecification("InventoryComponents.looknfeel", "", onComplete);
        }
        
        private function onComplete():void
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            var background:FlameWindow = winMgr.getWindow("root_wnd");
            
            // create mapping for the item type
            // This is the equivalent to the following entry in a scheme xml file:
            // <FalagardMapping WindowType="TaharezLook/InventoryItem" TargetType="InventoryItem" LookNFeel="TaharezLook/InventoryItem" Renderer="InventoryItemRenderer" />
            FlameWindowFactoryManager.getSingleton().addFalagardWindowMapping(
                "TaharezLook/InventoryItem",    // type to create
                "InventoryItem",                // 'base' widget type
                "TaharezLook/InventoryItem",    // WidgetLook to use.
                "InventoryItemRenderer");       // WindowRenderer to use.
            
            // Create Backpack window
            var wnd:FlameWindow = winMgr.createWindow("TaharezLook/FrameWindow");
            background.addChildWindow(wnd);
            wnd.setPosition(new UVector2(new UDim(0.1, 0), new UDim(0.1, 0)));
            wnd.setSize(new UVector2(new UDim(0.2, 0), new UDim(0.4, 0)));
            wnd.setText("Backpack");
            
            var receiver1:InventoryReceiver = InventoryReceiver(winMgr.createWindow("InventoryReceiver"));
            wnd.addChildWindow(receiver1);
            receiver1.setPosition(new UVector2(Misc.cegui_reldim(0.0), Misc.cegui_reldim( 0.0)));
            receiver1.setSize(new UVector2(Misc.cegui_reldim(1.0), Misc.cegui_reldim( 1.0)));
            receiver1.setContentSize(3, 6);
            receiver1.setUserString("BlockImage", "set:TaharezLook image:GenericBrush");
            
            // Create vault window
            var wnd2:FlameWindow = winMgr.createWindow("TaharezLook/FrameWindow");
            background.addChildWindow(wnd2);
            wnd2.setPosition(new UVector2(new UDim(0.48, 0), new UDim(0.2, 0)));
            wnd2.setSize(new UVector2(new UDim(0.5, 0), new UDim(0.5, 0)));
            wnd2.setText("Bank Vault");
            
            var receiver2:InventoryReceiver = InventoryReceiver(winMgr.createWindow("InventoryReceiver"));
            wnd2.addChildWindow(receiver2);
            receiver2.setPosition(new UVector2(Misc.cegui_reldim(0.0), Misc.cegui_reldim( 0.0)));
            receiver2.setSize(new UVector2(Misc.cegui_reldim(1.0), Misc.cegui_reldim( 1.0)));
            receiver2.setContentSize(10, 10);
            receiver2.setUserString("BlockImage", "set:TaharezLook image:GenericBrush");
            
            // create some items and add them to the vault.
            var item1:InventoryItem = InventoryItem(winMgr.createWindow("TaharezLook/InventoryItem"));
            item1.setContentSize(2, 2);
            receiver2.addItemAtLocation(item1, 0, 0);
            item1.setProperty("Image", "set:TaharezLook image:MouseArrow");
            
            var item2:InventoryItem = InventoryItem(winMgr.createWindow("InventoryItem"));
            item2.setUserString("BlockImage", "set:TaharezLook image:GenericBrush");
            item2.setContentSize(3, 1);
            receiver2.addItemAtLocation(item2, 1, 3);
            
            var item3:InventoryItem = InventoryItem(winMgr.createWindow("InventoryItem"));
            item3.setUserString("BlockImage", "set:TaharezLook image:GenericBrush");
            item3.setContentSize(1, 4);
            receiver2.addItemAtLocation(item3, 5, 2);
            
            var item4:InventoryItem = InventoryItem(winMgr.createWindow("InventoryItem"));
            item4.setUserString("BlockImage", "set:TaharezLook image:GenericBrush");
            item4.setContentSize(1, 1);
            receiver2.addItemAtLocation(item4, 8, 6);
            
            var item5:InventoryItem = InventoryItem(winMgr.createWindow("InventoryItem"));
            item5.setUserString("BlockImage", "set:TaharezLook image:GenericBrush");
            item5.setContentSize(2, 3);
            
            var data:Vector.<Boolean> = new Vector.<Boolean>(6);
            data[0] = true;
            data[1] = false;
            data[2] = true;
            data[3] = true;
            data[4] = true;
            data[5] = false;
            
            item5.setItemLayout(data);
            
            receiver2.addItemAtLocation(item5, 2, 5);
        }
        
    }
}
