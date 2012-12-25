
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
    import examples.base.GlossySerpentApplication;
    
    
    [SWF(width="800", height="600", frameRate="60")]
    public class DemoGlossySerpent extends GlossySerpentApplication
    {
        override protected function initApp():void
        {
            // Now the system is initialised, we can actually create some UI elements, for
            // this first example, a full-screen 'root' window is set as the active GUI
            // sheet, and then a simple frame window will be created and attached to it.
            
            // All windows and widgets are created via the WindowManager singleton.
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            
            FlameMouseCursor.getSingleton().initialize();
            // Here we create a "DeafultWindow".  This is a native type, that is, it does
            // not have to be loaded via a scheme, it is always available.  One common use
            // for the DefaultWindow is as a generic container for other windows.  Its
            // size defaults to 1.0f x 1.0f using the Relative metrics mode, which means
            // when it is set as the root GUI sheet window, it will cover the entire display.
            // The DefaultWindow does not perform any rendering of its own, so is invisible.
            //
            var url:String = FlameResourceProvider.getSingleton().getResourceDir() + 
                FlameResourceProvider.getSingleton().getLayoutDir() + 
                "Workbench.layout";
            
            new TextFileLoader({}, url, onFileLoaded);
            
        }
        
        private function onFileLoaded(tag:*, str:String):void
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            var wnd:FlameWindow = winMgr.loadWindowLayoutFromString(str);
            FlameSystem.getSingleton().setGUISheet(wnd);
        }
        
    }
}
