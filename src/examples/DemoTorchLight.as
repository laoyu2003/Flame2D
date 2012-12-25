
package examples {
    import Flame2D.core.data.Consts;
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameImageSetManager;
    import Flame2D.core.system.FlameMouseCursor;
    import Flame2D.core.system.FlameResourceProvider;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.Colour;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.UDim;
    import Flame2D.core.utils.UVector2;
    import Flame2D.elements.base.FlameScrollbar;
    import Flame2D.elements.button.FlamePushButton;
    import Flame2D.elements.combobox.FlameCombobox;
    import Flame2D.elements.containers.FlameHorizontalLayoutContainer;
    import Flame2D.elements.listbox.FlameListbox;
    import Flame2D.elements.listbox.FlameListboxTextItem;
    import Flame2D.elements.slider.FlameSlider;
    import Flame2D.elements.window.FlameGUISheet;
    import Flame2D.loaders.TextFileLoader;
    
    import examples.base.TorchBaseApplication;
    
    import flash.events.KeyboardEvent;
    import flash.text.TextField;
    
    
    [SWF(width="1200", height="680", frameRate="60")]
    public class DemoTorchLight extends TorchBaseApplication
    {
        //flame3d gui
        private var rootWindow:FlameGUISheet;
        private var currentWindow:FlameWindow = null;
        private var currentLayout:uint = 0;
        
        private var tf:TextField = new TextField();

        
        private var layouts:Array = [
            "bottomhud.layout",
            "charactercreate.layout",
            "characterload.layout",
            "cinematicmenu.layout",
            "combinemenu.layout",
            "console.layout",
            "dialogmenu.layout",
            "diemenu.layout",
            "difficulty.layout",
            "difficultymenu.layout",
            "enchantmenu.layout",
            "fishingmenu.layout",
            "interactivemenu.layout",
            "inventorymenu.layout",
            "journalmenu.layout",
            "loading.layout",
            "mainmenuframe.layout",
            "merchantmenu.layout",
            "modalmenu.layout",
            "optionsmenu.layout",
            "perkmenu.layout",
            "petmenu.layout",
            "questdialogmenu.layout",
            "questmenu.layout",
            "settingsmenu.layout",
            "skillfoldout.layout",
            "skillmenu.layout",
            "skilltooltip.layout",
            "stashmenu.layout",
            "tipmenu.layout",
            "tooltip.layout",
            "tooltipcompare.layout",
            "waypointmenu.layout"
            ];
        
        
        override protected function initApp():void
        {
            // Now the system is initialised, we can actually create some UI elements, for
            // this first example, a full-screen 'root' window is set as the active GUI
            // sheet, and then a simple frame window will be created and attached to it.
            
            // All windows and widgets are created via the WindowManager singleton.
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            
            FlameMouseCursor.getSingleton().initialize();
            
            FlameSystem.getSingleton().setDefaultMouseCursor(
                FlameImageSetManager.getSingleton().getImageSet("WindowsLook").getImage("MouseArrow"));

            // set tooltip styles (by default there is none)
            //FlameSystem.getSingleton().setDefaultTooltipForType("GuiLook/ItemTooltip");

            rootWindow = winMgr.createWindow("DefaultWindow", "RootWindow") as FlameGUISheet;
            FlameSystem.getSingleton().setGUISheet(rootWindow);

            
            FlameSystem.getSingleton().getRenderer().getStage().addChild(tf);
            tf.textColor = 0x00FF00;
            tf.width = 500;
            tf.height = 30;
            tf.y = 20;

            
            loadLayout("bottomhud.layout");
            
            
        }
        
        private function loadLayout(layout:String):void
        {
            var url:String = FlameResourceProvider.getSingleton().getResourceDir() + 
                FlameResourceProvider.getSingleton().getLayoutDir() + 
                layout;
            
            tf.htmlText = "<font size='18'>[" + layout + "] Press <font color='#FFFF00'>TAB</font> to show next layout...</font>";

            new TextFileLoader({}, url, onFileLoaded);
            
        }
        
        private function onFileLoaded(tag:*, str:String):void
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            if(currentWindow)
            {
                rootWindow.removeChildWindow(currentWindow);
                winMgr.destroyWindow(currentWindow);
                currentWindow = null;
            }
            currentWindow = winMgr.loadWindowLayoutFromString(str);
            rootWindow.addChildWindow(currentWindow);
        }
        
        override protected function onKeyDown(e:KeyboardEvent):void
        {
            if(e.keyCode == Consts.Key_Tab)
            {
                currentLayout ++;
                if(currentLayout == layouts.length)
                {
                    currentLayout = 0;
                }
                loadLayout(layouts[currentLayout]);
                
            }            
        }
    }
}
