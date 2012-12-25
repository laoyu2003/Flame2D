

package examples {
    import Flame2D.core.data.Consts;
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.system.FlameEvent;
    import Flame2D.core.system.FlameImageSetManager;
    import Flame2D.core.system.FlameMouseCursor;
    import Flame2D.core.system.FlameResourceProvider;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.UDim;
    import Flame2D.core.utils.UVector2;
    import Flame2D.elements.base.FlameScrollbar;
    import Flame2D.elements.button.FlamePushButton;
    import Flame2D.elements.button.FlameRadioButton;
    import Flame2D.elements.listbox.FlameListbox;
    import Flame2D.elements.listbox.FlameListboxItem;
    import Flame2D.elements.listbox.FlameListboxTextItem;
    import Flame2D.elements.tab.FlameTabControl;
    import Flame2D.elements.window.FlameGUISheet;
    import Flame2D.loaders.TextFileLoader;
    
    import flash.events.KeyboardEvent;
    import examples.base.BaseApplication;
    
    
    [SWF(width="800", height="600", frameRate="60")]
    public class DemoTabControl extends BaseApplication
    {
        private const prefix:String = "TabControlDemo/";
        private var totalLayouts:uint = 3;
        private var layoutLoaded:uint = 0;
        
        private var tabWindow:FlameWindow;
        private var page1Window:FlameWindow;
        private var page2Widnow:FlameWindow;
        
        private var tabStr:String = "";
        
        private const PageText:Array = new Array
            (
                "This is page three",
                "And this is page four, it's not too different from page three, isn't it?",
                "Yep, you guessed, this is page five",
                "And this is page six",
                "Seven",
                "Eight",
                "Nine. Quite boring, isn't it?",
                "Ten",
                "Eleven",
                "Twelve",
                "Thirteen",
                "Fourteen",
                "Fifteen",
                "And, finally, sixteen. Congrats, you found the last page!"
            );
        
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
            
            loadLayout("TabControlDemo");
            loadLayout("TabPage1");
            loadLayout("TabPage2");
            
            var url:String = FlameResourceProvider.getSingleton().getResourceDir() + 
                FlameResourceProvider.getSingleton().getLayoutDir() + 
                "TabPage.layout";
            new TextFileLoader({}, url, onPageLoaded);
            
        }
        
        private function onPageLoaded(tag:Object, str:String):void
        {
            tabStr = str;
        }
        
        private function loadLayout(layout:String):void
        {
            var url:String = FlameResourceProvider.getSingleton().getResourceDir() + 
                FlameResourceProvider.getSingleton().getLayoutDir() + 
                layout + ".layout";
            
            new TextFileLoader({name:layout}, url, onFileLoaded);
        }
        
        private function onFileLoaded(tag:*, str:String):void
        {
            var name:String = tag.name;
            if(name == "TabControlDemo")
            {
                tabWindow = FlameWindowManager.getSingleton().loadWindowLayoutFromString(str, prefix);
            } else if(name == "TabPage1")
            {
                page1Window = FlameWindowManager.getSingleton().loadWindowLayoutFromString(str, prefix);
            } else if(name == "TabPage2")
            {
                page2Widnow = FlameWindowManager.getSingleton().loadWindowLayoutFromString(str, prefix);
            }
            
            layoutLoaded ++;
            if(layoutLoaded == totalLayouts)
            {
                createApp();
            }
                
        }
        
        private function createApp():void
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            var background:FlameWindow = winMgr.getWindow("root_wnd");
            
            background.addChildWindow(tabWindow);
            
            var tc:FlameTabControl = FlameTabControl(winMgr.getWindow ("TabControlDemo/Frame/TabControl"));
            tc.addTab(page1Window);
            tc.addTab(page2Widnow);

            
            // What did it load?
//            WindowManager::WindowIterator it =  CEGUI::WindowManager::getSingleton().getIterator();
//            for(; !it.isAtEnd() ; ++it) {
//                const char* windowName = it.getCurrentValue()->getName().c_str();
//                printf("Name: %s\n", windowName);
//            }
            
            FlamePushButton(winMgr.getWindow("TabControlDemo/Page1/AddTab")).subscribeEvent (
                    FlamePushButton.EventClicked,
                    new Subscriber (handleAddTab, this), FlamePushButton.EventNamespace);
            
            // Click to visit this tab
            FlamePushButton(winMgr.getWindow("TabControlDemo/Page1/Go")).subscribeEvent (
                    FlamePushButton.EventClicked,
                    new Subscriber (handleGoto, this), FlamePushButton.EventNamespace);
            
            // Click to make this tab button visible (when scrolling is required)
            FlamePushButton(winMgr.getWindow("TabControlDemo/Page1/Show")).subscribeEvent (
                    FlamePushButton.EventClicked,
                    new Subscriber (handleShow, this), FlamePushButton.EventNamespace);
            
            FlamePushButton(winMgr.getWindow("TabControlDemo/Page1/Del")).subscribeEvent (
                    FlamePushButton.EventClicked,
                    new Subscriber (handleDel, this), FlamePushButton.EventNamespace);
            
            var rb:FlameRadioButton = FlameRadioButton(winMgr.getWindow("TabControlDemo/Page1/TabPaneTop"));
            rb.setSelected (tc.getTabPanePosition () == Consts.TabPanePosition_Top);
            rb.subscribeEvent (
                FlameRadioButton.EventSelectStateChanged,
                new Subscriber (handleTabPanePos, this), FlameRadioButton.EventNamespace);
            
            rb = FlameRadioButton(winMgr.getWindow("TabControlDemo/Page1/TabPaneBottom"));
            rb.setSelected (tc.getTabPanePosition () == Consts.TabPanePosition_Bottom);
            rb.subscribeEvent (
                FlameRadioButton.EventSelectStateChanged,
                new Subscriber (handleTabPanePos, this), FlameRadioButton.EventNamespace);
            
            var sb:FlameScrollbar = FlameScrollbar(winMgr.getWindow("TabControlDemo/Page1/TabHeight"));
            sb.setScrollPosition (tc.getTabHeight ().d_offset);
            sb.subscribeEvent (
                FlameScrollbar.EventScrollPositionChanged,
                new Subscriber (handleTabHeight, this), FlameScrollbar.EventNamespace);
            
            sb = FlameScrollbar(winMgr.getWindow("TabControlDemo/Page1/TabPadding"));
            sb.setScrollPosition (tc.getTabTextPadding ().d_offset);
            sb.subscribeEvent (
                FlameScrollbar.EventScrollPositionChanged,
                new Subscriber (handleTabPadding, this), FlameScrollbar.EventNamespace);
            
            refreshPageList ();
        }
        
        private function refreshPageList ():void
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton ();
            // Check if the windows exists
            var lbox:FlameListbox = null;
            var tc:FlameTabControl = null;
            if (winMgr.isWindowPresent("TabControlDemo/Page1/PageList"))
            {
                lbox = FlameListbox(winMgr.getWindow("TabControlDemo/Page1/PageList"));
            }
            if (winMgr.isWindowPresent("TabControlDemo/Frame/TabControl"))
            {
                tc = FlameTabControl(winMgr.getWindow ("TabControlDemo/Frame/TabControl"));
            }
            if (lbox && tc)
            {
                lbox.resetList ();
                for (var i:uint = 0; i < tc.getTabCount (); i++)
                {
                    lbox.addItem (new MyListItem (
                        tc.getTabContentsAtIndex (i).getName ()));
                }
            }
        }
        
        private function handleTabPanePos (e:EventArgs):Boolean
        {
            //tab pane position
            var tpp:uint;
            switch (WindowEventArgs(e).window.getID ())
            {
                case 0:
                    tpp = Consts.TabPanePosition_Top;
                    break;
                case 1:
                    tpp = Consts.TabPanePosition_Bottom;
                    break;
                default:
                    return false;
            }
            
            // Check if the window exists
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton ();
            if (winMgr.isWindowPresent("TabControlDemo/Frame/TabControl"))
            {
                FlameTabControl(winMgr.getWindow ("TabControlDemo/Frame/TabControl")).setTabPanePosition (tpp);
            }
            
            return true;
        }
        
        private function handleTabHeight (e:EventArgs):Boolean
        {
            var sb:FlameScrollbar = FlameScrollbar(WindowEventArgs(e).window);
            
            // Check if the window exists
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton ();
            if (winMgr.isWindowPresent("TabControlDemo/Frame/TabControl"))
            {
                FlameTabControl(winMgr.getWindow ("TabControlDemo/Frame/TabControl")).setTabHeight (
                        new UDim (0, sb.getScrollPosition ()));
            }
            
            // The return value mainly sais that we handled it, not if something failed.
            return true;
        }
        
        private function handleTabPadding (e:EventArgs):Boolean
        {
            var sb:FlameScrollbar = FlameScrollbar(WindowEventArgs(e).window);
            
            // Check if the window exists
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton ();
            if (winMgr.isWindowPresent("TabControlDemo/Frame/TabControl"))
            {
                FlameTabControl(winMgr.getWindow ("TabControlDemo/Frame/TabControl")).setTabTextPadding (
                        new UDim (0, sb.getScrollPosition ()));
            }
            
            return true;
        }
        
        private function handleAddTab (e:EventArgs):Boolean
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton ();
            // Check if the window exists
            if (winMgr.isWindowPresent("TabControlDemo/Frame/TabControl"))
            {
                var tc:FlameTabControl = FlameTabControl(winMgr.getWindow ("TabControlDemo/Frame/TabControl"));
                
                // Add some tab buttons once
                for (var num:int = 3; num <= 16; num++)
                {
                    var _prefix:String = "TabControlDemo/Page" + num;
                    if (winMgr.isWindowPresent (_prefix))
                        // Next
                        continue;
                    
                    var pg:FlameWindow = null;
                    try
                    {
                        pg = winMgr.loadWindowLayoutFromString(tabStr, _prefix);
                    }
                    catch (error:Error)
                    {
                        trace("Some error occured while adding a tabpage. Please see the logfile." );
                        break;
                    }
                    
                    _prefix += "Text";
                    // This window has just been created while loading the layout
                    if (winMgr.isWindowPresent (_prefix))
                    {
                        var txt:FlameWindow = winMgr.getWindow (_prefix);
                        txt.setText (PageText [num - 3]);
                        
                        var pgname:String = "Page " + num;
                        pg.setText (pgname);
                        tc.addTab (pg);
                        
                        refreshPageList ();
                        break;
                    }
                }
            }
            
            return true;
        }
        
        private function handleGoto (e:EventArgs):Boolean
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton ();
            // Check if the windows exists
            var lbox:FlameListbox = null;
            var tc:FlameTabControl = null;
            if (winMgr.isWindowPresent("TabControlDemo/Page1/PageList"))
            {
                lbox = FlameListbox(winMgr.getWindow("TabControlDemo/Page1/PageList"));
            }
            if (winMgr.isWindowPresent("TabControlDemo/Frame/TabControl"))
            {
                tc = FlameTabControl(winMgr.getWindow ("TabControlDemo/Frame/TabControl"));
            }
            if (lbox && tc)
            {
                var lbi:FlameListboxItem = lbox.getFirstSelectedItem ();
                if (lbi)
                {
                    tc.setSelectedTab (lbi.getText ());
                }
            }
            
            return true;
        }
        
        private function handleShow (e:EventArgs):Boolean
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton ();
            // Check if the windows exists
            var lbox:FlameListbox = null;
            var tc:FlameTabControl = null;
            if (winMgr.isWindowPresent("TabControlDemo/Page1/PageList"))
            {
                lbox = FlameListbox(winMgr.getWindow("TabControlDemo/Page1/PageList"));
            }
            if (winMgr.isWindowPresent("TabControlDemo/Frame/TabControl"))
            {
                tc = FlameTabControl(winMgr.getWindow ("TabControlDemo/Frame/TabControl"));
            }
            if (lbox && tc)
            {
                var lbi:FlameListboxItem = lbox.getFirstSelectedItem ();
                if (lbi)
                {
                    tc.makeTabVisible (lbi.getText ());
                }
            }
            
            return true;
        }
        
        private function handleDel (e:EventArgs):Boolean
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton ();
            // Check if the windows exists
            var lbox:FlameListbox = null;
            var tc:FlameTabControl = null;
            if (winMgr.isWindowPresent("TabControlDemo/Page1/PageList"))
            {
                lbox = FlameListbox(winMgr.getWindow("TabControlDemo/Page1/PageList"));
            }
            if (winMgr.isWindowPresent("TabControlDemo/Frame/TabControl"))
            {
                tc = FlameTabControl(winMgr.getWindow ("TabControlDemo/Frame/TabControl"));
            }
            if (lbox && tc)
            {
                var lbi:FlameListboxItem = lbox.getFirstSelectedItem ();
                if (lbi)
                {
                    tc.removeTab (lbi.getText ());
                    // Remove the actual window from Cegui
                    winMgr.destroyWindowByName (lbi.getText ());
                    
                    refreshPageList ();
                }
            }
            
            return true;
        }
    }
    

}
import Flame2D.elements.listbox.FlameListboxTextItem;

// Sample sub-class for ListboxTextItem that auto-sets the selection brush
// image.  This saves doing it manually every time in the code.
class MyListItem extends FlameListboxTextItem
{
    public function MyListItem (text:String)
    {
        super(text);
        setSelectionBrushImageFromImageSet("TaharezLook", "MultiListSelectionBrush");
    }
}
