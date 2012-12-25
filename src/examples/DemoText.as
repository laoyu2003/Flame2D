

package examples {
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
    import Flame2D.core.utils.UVector2;
    import Flame2D.elements.button.FlameCheckbox;
    import Flame2D.elements.button.FlamePushButton;
    import Flame2D.elements.button.FlameRadioButton;
    import Flame2D.elements.editbox.FlameEditbox;
    import Flame2D.elements.editbox.FlameMultiLineEditbox;
    import Flame2D.elements.window.FlameGUISheet;
    import Flame2D.loaders.TextFileLoader;
    
    import flash.events.KeyboardEvent;
    import examples.base.BaseApplication;
    
    
    [SWF(width="800", height="600", frameRate="60")]
    public class DemoText extends BaseApplication
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
            
            var name:String = "TextDemo";
            var url:String = FlameResourceProvider.getSingleton().getResourceDir() + 
                FlameResourceProvider.getSingleton().getLayoutDir() + 
                name + ".layout";
            
            new TextFileLoader({}, url, onFileLoaded);
            
        }
        
        private function onFileLoaded(tag:*, str:String):void
        {
            var rootWindow:FlameGUISheet = FlameWindowManager.getSingleton().loadWindowLayoutFromString(str) as FlameGUISheet;
            var background:FlameWindow = FlameWindowManager.getSingleton().getWindow("root_wnd");
            background.addChildWindow(rootWindow);
            
            
            // Init the seperate blocks which make up this sample
            initStaticText();
            initSingleLineEdit();
            initMultiLineEdit();
            
            // Quit button
            subscribeEvent("TextDemo/Quit", FlamePushButton.EventClicked, new Subscriber(quit, this), FlamePushButton.EventNamespace);

        }
        
        
        private function initStaticText():void
        {
            // Name, Group, Selected
            initRadio("TextDemo/HorzLeft", 0, true);
            initRadio("TextDemo/HorzRight", 0, false);
            initRadio("TextDemo/HorzCentered", 0, false);
            // New group!
            initRadio("TextDemo/VertTop", 1, true);
            initRadio("TextDemo/VertBottom", 1, false);
            initRadio("TextDemo/VertCentered", 1, false);
            //
            // Events
            //
            // Word-wrap checkbox (we can't re-use a handler struct for the last argument!!)
            subscribeEvent("TextDemo/Wrap", FlameCheckbox.EventCheckStateChanged, new Subscriber(formatChangedHandler, this), FlameCheckbox.EventNamespace);
            subscribeEvent("TextDemo/HorzLeft", FlameRadioButton.EventSelectStateChanged, new Subscriber(formatChangedHandler, this), FlameRadioButton.EventNamespace);
            subscribeEvent("TextDemo/HorzRight", FlameRadioButton.EventSelectStateChanged, new Subscriber(formatChangedHandler, this), FlameRadioButton.EventNamespace);
            subscribeEvent("TextDemo/HorzCentered", FlameRadioButton.EventSelectStateChanged, new Subscriber(formatChangedHandler, this), FlameRadioButton.EventNamespace);
            subscribeEvent("TextDemo/VertTop", FlameRadioButton.EventSelectStateChanged, new Subscriber(formatChangedHandler, this), FlameRadioButton.EventNamespace);
            subscribeEvent("TextDemo/VertBottom", FlameRadioButton.EventSelectStateChanged, new Subscriber(formatChangedHandler, this), FlameRadioButton.EventNamespace);
            subscribeEvent("TextDemo/VertCentered", FlameRadioButton.EventSelectStateChanged, new Subscriber(formatChangedHandler, this), FlameRadioButton.EventNamespace);
        }
        
        private function initSingleLineEdit():void
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            // Only accepts digits for the age field
            if (winMgr.isWindowPresent("TextDemo/editAge"))
            {
                FlameEditbox(winMgr.getWindow("TextDemo/editAge")).setValidationString("^[0-9]*$");
            }
            // Set password restrictions
            if (winMgr.isWindowPresent("TextDemo/editAge"))
            {
                var passwd:FlameEditbox = FlameEditbox(winMgr.getWindow("TextDemo/editPasswd"));
                passwd.setValidationString("^[A-Za-z0-9]*$");
                // Render masked
                passwd.setTextMasked(true);
            }
        }
        
        private function initMultiLineEdit():void
        {
            // Scrollbar checkbox
            subscribeEvent("TextDemo/forceScroll", FlameCheckbox.EventCheckStateChanged, new Subscriber(vertScrollChangedHandler, this), FlameCheckbox.EventNamespace);
        }
        
        private function initRadio(radio:String, group:int, selected:Boolean):void
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            if (winMgr.isWindowPresent(radio))
            {
                var button:FlameRadioButton = FlameRadioButton(winMgr.getWindow(radio));
                button.setGroupID(group);
                button.setSelected(selected);
            }
        }
        
        private function subscribeEvent(widget:String, event:String, method:Subscriber, namespace:String):void
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            if (winMgr.isWindowPresent(widget))
            {
                var window:FlameWindow = winMgr.getWindow(widget);
                window.subscribeEvent(event, method, namespace);
            }
        }
            
        private function isRadioSelected(radio:String):Boolean
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            // Check
            if (winMgr.isWindowPresent(radio))
            {
                var button:FlameRadioButton = FlameRadioButton(winMgr.getWindow(radio));
                return button.isSelected();
            }
            return false;
        }
                
        private function isCheckboxSelected(checkbox:String):Boolean
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            // Check
            if (winMgr.isWindowPresent(checkbox))
            {
                var button:FlameCheckbox = FlameCheckbox(winMgr.getWindow(checkbox));
                return button.isSelected();
            }
            return false;
        }
                    
        private function formatChangedHandler(args:EventArgs):Boolean
        {
            // we will use the WindowManager to get access to the widgets
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            
            if (winMgr.isWindowPresent("TextDemo/StaticText"))
            {
                // and also the static text for which we will set the formatting options
                var st:FlameWindow = winMgr.getWindow("TextDemo/StaticText");
                
                // handle vertical formatting settings
                if (isRadioSelected("TextDemo/VertTop"))
                    st.setProperty("VertFormatting", "TopAligned");
                else if (isRadioSelected("TextDemo/VertBottom"))
                    st.setProperty("VertFormatting", "BottomAligned");
                else if (isRadioSelected("TextDemo/VertCentered"))
                    st.setProperty("VertFormatting", "VertCentred");
                
                // handle horizontal formatting settings
                var wrap:Boolean = isCheckboxSelected("TextDemo/Wrap");
                
                if (isRadioSelected("TextDemo/HorzLeft"))
                    st.setProperty("HorzFormatting", wrap ? "WordWrapLeftAligned" : "LeftAligned");
                else if (isRadioSelected("TextDemo/HorzRight"))
                    st.setProperty("HorzFormatting", wrap ? "WordWrapRightAligned" : "RightAligned");
                else if (isRadioSelected("TextDemo/HorzCentered"))
                    st.setProperty("HorzFormatting", wrap ? "WordWrapCentred" : "HorzCentred");
            }
            
            // event was handled
            return true;
        }
                        
        private function vertScrollChangedHandler(args:EventArgs):Boolean
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            
            if (winMgr.isWindowPresent("TextDemo/editMulti"))
            {
                var multiEdit:FlameMultiLineEditbox = FlameMultiLineEditbox(winMgr.getWindow("TextDemo/editMulti"));
                // Use setter for a change
                multiEdit.setShowVertScrollbar(isCheckboxSelected("TextDemo/forceScroll"));
            }
            
            // event was handled
            return true;
        }

        private function quit(args:EventArgs):Boolean
        {
            // signal quit
            //d_sampleApp->setQuitting();
            
            // event was handled
            return true;
        }
    }
}
