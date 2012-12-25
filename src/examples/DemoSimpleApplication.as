

package examples {
    import Flame2D.core.data.Consts;
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.system.FlameFontManager;
    import Flame2D.core.system.FlameImageSetManager;
    import Flame2D.core.system.FlameMouseCursor;
    import Flame2D.core.system.FlameResourceProvider;
    import Flame2D.core.system.FlameSchemeManager;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowFactoryManager;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.UVector2;
    import Flame2D.elements.base.FlameScrollbar;
    import Flame2D.elements.button.FlameCheckbox;
    import Flame2D.elements.button.FlamePushButton;
    import Flame2D.elements.button.FlameRadioButton;
    import Flame2D.elements.combobox.FlameCombobox;
    import Flame2D.elements.editbox.FlameEditbox;
    import Flame2D.elements.list.FlameMultiColumnList;
    import Flame2D.elements.listbox.FlameListboxTextItem;
    import Flame2D.elements.progressbar.FlameProgressBar;
    import Flame2D.elements.slider.FlameSlider;
    import Flame2D.elements.window.FlameFrameWindow;
    import Flame2D.elements.window.FlameGUISheet;
    import Flame2D.loaders.TextFileLoader;
    
    import flash.events.KeyboardEvent;
    import examples.base.BaseApplication;
    
    
    [SWF(width="800", height="600", frameRate="60")]
    public class DemoSimpleApplication extends BaseApplication
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
            
            
            //init
            // method to initialse the samples windows and events.
            initialiseSample();
        }
        
        
        private function initialiseSample():void
        {
            // Register our effect with the system
            //RenderEffectManager::getSingleton().addEffect<MyEffect>("WobblyWindow");
            
            // Now we make a Falagard mapping for a frame window that uses this effect.
            // We create a type "TaharezLook/WobblyFrameWindow", which is subsequently
            // referenced in the layout file loaded below.  Note that it wold be more
            // usual for this mapping to be specified in the scheme xml file, though
            // here we are doing in manually to save from needing either multiple
            // versions of the schemes or from having demo specific definitions in
            // the schemes.
            FlameWindowFactoryManager.getSingleton().addFalagardWindowMapping(
                "TaharezLook/WobblyFrameWindow",    // type to create
                "CEGUI/FrameWindow",                // 'base' widget type
                "TaharezLook/FrameWindow",          // WidgetLook to use.
                "Falagard/FrameWindow",             // WindowRenderer to use.
                "WobblyWindow");                    // effect to use.
            
            var name:String = "Demo7Windows";
            var url:String = FlameResourceProvider.getSingleton().getResourceDir() + 
                FlameResourceProvider.getSingleton().getLayoutDir() + 
                name + ".layout";
            
            new TextFileLoader({}, url, onFileLoaded);
            
        }
        
        private function onFileLoaded(tag:*, str:String):void
        {
            
            // we will use of the WindowManager.
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            var background:FlameWindow = winMgr.getWindow("root_wnd");
            
            // load the windows for Demo7 from the layout file.
            var sheet:FlameWindow = FlameWindowManager.getSingleton().loadWindowLayoutFromString(str) as FlameGUISheet;
            // attach this to the 'real' root
            background.addChildWindow(sheet);
            // set-up the contents of the list boxes.
            createListContent();
            // initialise the event handling.
            initDemoEventWiring();
        }
            
        
        private function createListContent():void
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            
            //
            // Combobox setup
            //
            var cbobox:FlameCombobox = winMgr.getWindow("Demo7/Window2/Combobox") as FlameCombobox;
            // add items to the combobox list
            cbobox.addItem(new MyListItem("Combobox Item 1"));
            cbobox.addItem(new MyListItem("Combobox Item 2"));
            cbobox.addItem(new MyListItem("Combobox Item 3"));
            cbobox.addItem(new MyListItem("Combobox Item 4"));
            cbobox.addItem(new MyListItem("Combobox Item 5"));
            cbobox.addItem(new MyListItem("Combobox Item 6"));
            cbobox.addItem(new MyListItem("Combobox Item 7"));
            cbobox.addItem(new MyListItem("Combobox Item 8"));
            cbobox.addItem(new MyListItem("Combobox Item 9"));
            cbobox.addItem(new MyListItem("Combobox Item 10"));
            
            //
            // Multi-Column List setup
            //
            var mclbox:FlameMultiColumnList = winMgr.getWindow("Demo7/Window2/MultiColumnList") as FlameMultiColumnList;
            mclbox.setSelectionMode(Consts.SelectionMode_RowSingle);
            // Add some empty rows to the MCL
            mclbox.addEmptyRow();
            mclbox.addEmptyRow();
            mclbox.addEmptyRow();
            mclbox.addEmptyRow();
            mclbox.addEmptyRow();
            
            // Set first row item texts for the MCL
            mclbox.setItem(new MyListItem("Laggers World"), 0, 0);
            mclbox.setItem(new MyListItem("yourgame.some-server.com"), 1, 0);
            mclbox.setItem(new MyListItem("[colour='FFFF0000']1000ms"), 2, 0);
            
            // Set second row item texts for the MCL
            mclbox.setItem(new MyListItem("Super-Server"), 0, 1);
            mclbox.setItem(new MyListItem("whizzy.fakenames.net"), 1, 1);
            mclbox.setItem(new MyListItem("[colour='FF00FF00']8ms"), 2, 1);
            
            // Set third row item texts for the MCL
            mclbox.setItem(new MyListItem("Cray-Z-Eds"), 0, 2);
            mclbox.setItem(new MyListItem("crayzeds.notarealserver.co.uk"), 1, 2);
            mclbox.setItem(new MyListItem("[colour='FF00FF00']43ms"), 2, 2);
            
            // Set fourth row item texts for the MCL
            mclbox.setItem(new MyListItem("Fake IPs"), 0, 3);
            mclbox.setItem(new MyListItem("123.320.42.242"), 1, 3);
            mclbox.setItem(new MyListItem("[colour='FFFFFF00']63ms"), 2, 3);
            
            // Set fifth row item texts for the MCL
            mclbox.setItem(new MyListItem("Yet Another Game Server"), 0, 4);
            mclbox.setItem(new MyListItem("abc.abcdefghijklmn.org"), 1, 4);
            mclbox.setItem(new MyListItem("[colour='FFFF6600']284ms"), 2, 4);
            
            //a hack to update scrollbar, by yumj
            var sb:FlameScrollbar = winMgr.getWindow("Demo7/Window1/Scrollbar1") as FlameScrollbar;
            sb.setScrollPosition(0);
        }
        
        private function initDemoEventWiring():void
        {
            // Subscribe handler that quits the application
            FlameWindowManager.getSingleton().getWindow("Demo7/Window1/Quit").
                subscribeEvent(FlamePushButton.EventClicked, new Subscriber(handleQuit, this), FlamePushButton.EventNamespace);
            
            // Subscribe handler that processes changes to the slider position.
            FlameWindowManager.getSingleton().getWindow("Demo7/Window1/Slider1").
                subscribeEvent(FlameSlider.EventValueChanged, new Subscriber(handleSlider, this), FlameSlider.EventNamespace);
            
            // Subscribe handler that processes changes to the checkbox selection state.
            FlameWindowManager.getSingleton().getWindow("Demo7/Window1/Checkbox").
                subscribeEvent(FlameCheckbox.EventCheckStateChanged, new Subscriber(handleCheck, this), FlameCheckbox.EventNamespace);
            
            // Subscribe handler that processes changes to the radio button selection state.
            FlameWindowManager.getSingleton().getWindow("Demo7/Window1/Radio1").
                subscribeEvent(FlameRadioButton.EventSelectStateChanged, new Subscriber(handleRadio, this), FlameRadioButton.EventNamespace);
            
            // Subscribe handler that processes changes to the radio button selection state.
            FlameWindowManager.getSingleton().getWindow("Demo7/Window1/Radio2").
                subscribeEvent(FlameRadioButton.EventSelectStateChanged, new Subscriber(handleRadio, this), FlameRadioButton.EventNamespace);
            
            // Subscribe handler that processes changes to the radio button selection state.
            FlameWindowManager.getSingleton().getWindow("Demo7/Window1/Radio3").
                subscribeEvent(FlameRadioButton.EventSelectStateChanged, new Subscriber(handleRadio, this), FlameRadioButton.EventNamespace);
        }
        
        
        private function handleQuit(args:EventArgs):Boolean
        {
            // signal quit
            //d_sampleApp->setQuitting();
            
            // event was handled
            return true;
        }
            
        private function handleSlider(e:EventArgs):Boolean
        {
            // get the current slider value
            var val:Number = FlameSlider((WindowEventArgs(e).window)).getCurrentValue();
            
            // set the progress for the first bar according to the slider value
            FlameProgressBar(FlameWindowManager.getSingleton().getWindow("Demo7/Window2/Progbar1")).setProgress(val);
            // set second bar's progress - this time the reverse of the first one
            FlameProgressBar(FlameWindowManager.getSingleton().getWindow("Demo7/Window2/Progbar2")).setProgress(1.0 - val);
            // set the alpha on the window containing all the controls.
            FlameWindowManager.getSingleton().getWindow("root").setAlpha(val);
            
            // event was handled.
            return true;
        }
                
        private function handleRadio(e:EventArgs):Boolean
        {
            // get the ID of the selected radio button
            var id:uint = FlameRadioButton(WindowEventArgs(e).window).getSelectedButtonInGroup().getID();
            // get the StaticImage window
            var img:FlameWindow = FlameWindowManager.getSingleton().getWindow("Demo7/Window2/Image1");
            
            // set an image into the StaticImage according to the ID of the selected radio button.
            switch (id)
            {
                case 0:
                    img.setProperty("Image", "set:BackgroundImage image:full_image");
                    break;
                
                case 1:
                    img.setProperty("Image", "set:TaharezLook image:MouseArrow");
                    break;
                
                default:
                    img.setProperty("Image", "");
                    break;
            }
            
            // event was handled
            return true;
        }
                    
        private function handleCheck(e:EventArgs):Boolean
        {
            // show or hide the FrameWindow containing the multi-line editbox according to the state of the
            // checkbox widget
            FlameWindowManager.getSingleton().getWindow("Demo7/Window3").
                setVisible(FlameCheckbox(WindowEventArgs(e).window).isSelected());
            
            // event was handled.
            return true;
        }
    }
}

import Flame2D.elements.listbox.FlameListboxTextItem;
// Sample sub-class for ListboxTextItem that auto-sets the selection brush
// image.  This saves doing it manually every time in the code.
class MyListItem extends FlameListboxTextItem
{
    public function MyListItem(text:String)
    {
        super(text);
        setSelectionBrushImageFromImageSet("TaharezLook", "MultiListSelectionBrush");
    }
}

