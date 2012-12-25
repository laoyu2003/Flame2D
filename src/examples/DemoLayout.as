
package examples {
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameImageSetManager;
    import Flame2D.core.system.FlameMouseCursor;
    import Flame2D.core.system.FlameResourceProvider;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.Colour;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.UDim;
    import Flame2D.core.utils.UVector2;
    import Flame2D.elements.base.FlameScrollbar;
    import Flame2D.elements.button.FlamePushButton;
    import Flame2D.elements.containers.FlameHorizontalLayoutContainer;
    import Flame2D.elements.listbox.FlameListbox;
    import Flame2D.elements.listbox.FlameListboxTextItem;
    import Flame2D.elements.slider.FlameSlider;
    import Flame2D.elements.window.FlameGUISheet;
    import Flame2D.loaders.TextFileLoader;
    
    import flash.events.KeyboardEvent;
    import examples.base.BaseApplication;

    
    [SWF(width="800", height="600", frameRate="60")]
    public class DemoLayout extends BaseApplication
    {
        //flame3d gui
        private var rootWindow:FlameGUISheet;
        
        
        override protected function initApp():void
        {
            // Now the system is initialised, we can actually create some UI elements, for
            // this first example, a full-screen 'root' window is set as the active GUI
            // sheet, and then a simple frame window will be created and attached to it.
            
            // All windows and widgets are created via the WindowManager singleton.
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            
            FlameMouseCursor.getSingleton().initialize();
            FlameSystem.getSingleton().setDefaultMouseCursor(
                FlameImageSetManager.getSingleton().getImageSet("TaharezLook").getImage("MouseArrow"));
            // Here we create a "DeafultWindow".  This is a native type, that is, it does
            // not have to be loaded via a scheme, it is always available.  One common use
            // for the DefaultWindow is as a generic container for other windows.  Its
            // size defaults to 1.0f x 1.0f using the Relative metrics mode, which means
            // when it is set as the root GUI sheet window, it will cover the entire display.
            // The DefaultWindow does not perform any rendering of its own, so is invisible.
            //
                        
            var name:String = "Demo8";//Demo8 Demo7Windows
            var url:String = FlameResourceProvider.getSingleton().getResourceDir() + 
                FlameResourceProvider.getSingleton().getLayoutDir() + 
                name + ".layout";
            
            new TextFileLoader({}, url, onFileLoaded);
            
        }
        
        private function onFileLoaded(tag:*, str:String):void
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            rootWindow = winMgr.loadWindowLayoutFromString(str) as FlameGUISheet;
            
            FlameSystem.getSingleton().setGUISheet(rootWindow);
            
            winMgr.getWindow("Demo8/ViewScroll").subscribeEvent("ScrollPosChanged", new Subscriber(panelSlideHandler, this), FlameScrollbar.EventNamespace);
            winMgr.getWindow("Demo8/Window1/Controls/Blue").subscribeEvent("ScrollPosChanged", new Subscriber(colourChangeHandler, this), FlameScrollbar.EventNamespace)
            winMgr.getWindow("Demo8/Window1/Controls/Red").subscribeEvent("ScrollPosChanged", new Subscriber(colourChangeHandler, this), FlameScrollbar.EventNamespace)
            winMgr.getWindow("Demo8/Window1/Controls/Green").subscribeEvent("ScrollPosChanged", new Subscriber(colourChangeHandler, this), FlameScrollbar.EventNamespace)
            winMgr.getWindow("Demo8/Window1/Controls/Add").subscribeEvent("Clicked", new Subscriber(addItemHandler, this), FlamePushButton.EventNamespace);
        }
        
        //-- and re-position the scrollbar
//            -----------------------------------------
//        function panelSlideHandler(args)
//        local scroller = CEGUI.toScrollbar(CEGUI.toWindowEventArgs(args).window)
//        local demoWnd = CEGUI.WindowManager:getSingleton():getWindow("Demo8")
//        
//        local relHeight = demoWnd:getHeight():asRelative(demoWnd:getParentPixelHeight())
//        
//        scroller:setPosition(CEGUI.UVector2(CEGUI.UDim(0,0), CEGUI.UDim(scroller:getScrollPosition() / relHeight,0)))
//        demoWnd:setPosition(CEGUI.UVector2(CEGUI.UDim(0,0), CEGUI.UDim(-scroller:getScrollPosition(),0)))
//        end

        private function panelSlideHandler(args:WindowEventArgs):void
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();

            var scroller:FlameScrollbar = args.window as FlameScrollbar;
            var demoWnd:FlameWindow = winMgr.getWindow("Demo8");

            var relHeight:Number = demoWnd.getHeight().asRelative(demoWnd.getParentPixelSize().d_height);
            
            scroller.setPosition(new UVector2(new UDim(0,0), new UDim(scroller.getScrollPosition()/relHeight, 0)));
            demoWnd.setPosition(new UVector2(new UDim(0,0), new UDim(-scroller.getScrollPosition(), 0)));
        }
        
//        -----------------------------------------
//            -- Handler to set preview colour when
//        -- colour selector scrollers change
//        -----------------------------------------
//        function colourChangeHandler(args)
//        local winMgr = CEGUI.WindowManager:getSingleton()
//        
//        local r = CEGUI.toScrollbar(winMgr:getWindow("Demo8/Window1/Controls/Red")):getScrollPosition()
//        local g = CEGUI.toScrollbar(winMgr:getWindow("Demo8/Window1/Controls/Green")):getScrollPosition()
//        local b = CEGUI.toScrollbar(winMgr:getWindow("Demo8/Window1/Controls/Blue")):getScrollPosition()
//        local col = CEGUI.colour:new_local(r, g, b, 1)
//        local crect = CEGUI.ColourRect(col)
//        
//        winMgr:getWindow("Demo8/Window1/Controls/ColourSample"):setProperty("ImageColours", CEGUI.PropertyHelper:colourRectToString(crect))
//        end
        
        private function colourChangeHandler(args:WindowEventArgs):void
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();

            var r:Number = FlameScrollbar(winMgr.getWindow("Demo8/Window1/Controls/Red")).getScrollPosition();
            var g:Number = FlameScrollbar(winMgr.getWindow("Demo8/Window1/Controls/Green")).getScrollPosition();
            var b:Number = FlameScrollbar(winMgr.getWindow("Demo8/Window1/Controls/Blue")).getScrollPosition();
            var col:Colour = new Colour(r, g, b, 1);
            trace("color:" + col.toString());
            var crect:ColourRect = new ColourRect(col, col, col, col);
            
            (winMgr.getWindow("Demo8/Window1/Controls/ColourSample") as FlameWindow).setProperty("ImageColours", FlamePropertyHelper.colourRectToString(crect));
            
        }
            
        
//        -----------------------------------------
//            -- Handler to add an item to the box
//        -----------------------------------------
//        function addItemHandler(args)
//        local winMgr = CEGUI.WindowManager:getSingleton()
//        
//        local text = winMgr:getWindow("Demo8/Window1/Controls/Editbox"):getText()
//        local cols = CEGUI.PropertyHelper:stringToColourRect(winMgr:getWindow("Demo8/Window1/Controls/ColourSample"):getProperty("ImageColours"))
//        
//        local newItem = CEGUI.createListboxTextItem(text, 0, nil, false, true)
//        newItem:setSelectionBrushImage("TaharezLook", "MultiListSelectionBrush")
//        newItem:setSelectionColours(cols)
//        
//        CEGUI.toListbox(winMgr:getWindow("Demo8/Window1/Listbox")):addItem(newItem)
//        end
        private function addItemHandler(args:WindowEventArgs):void
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            
            var text:String = winMgr.getWindow("Demo8/Window1/Controls/Editbox").getText();
            var cols:ColourRect = FlamePropertyHelper.stringToColourRect(winMgr.getWindow("Demo8/Window1/Controls/ColourSample").getProperty("ImageColours"));
            
            trace("add item, cols:" + cols.toString());
            
            var newItem:FlameListboxTextItem = new FlameListboxTextItem(text, 0, null, false, true);
            newItem.setSelectionBrushImageFromImageSet("TaharezLook", "MultiListSelectionBrush");
            newItem.setSelectionColours(cols);
            
            FlameListbox(winMgr.getWindow("Demo8/Window1/Listbox")).addItem(newItem);
        }
        
    }
}
