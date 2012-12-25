

package examples {
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.events.WindowEventArgs;
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
    import Flame2D.elements.base.FlameScrollbar;
    import Flame2D.elements.button.FlameCheckbox;
    import Flame2D.elements.button.FlamePushButton;
    import Flame2D.elements.editbox.FlameMultiLineEditbox;
    import Flame2D.elements.listbox.FlameListbox;
    import Flame2D.elements.listbox.FlameListboxItem;
    import Flame2D.elements.window.FlameGUISheet;
    import Flame2D.loaders.TextFileLoader;
    
    import flash.events.KeyboardEvent;
    import flash.utils.Dictionary;
    import examples.base.BaseApplication;
    
    
    [SWF(width="800", height="600", frameRate="60")]
    public class DemoFont extends BaseApplication
    {
        private static const MIN_POINT_SIZE:Number = 6.0;
        private static const langList:Array = new Array();

        override protected function initApp():void
        {
            langList[0] = new LangList(
                "English",
                "DejaVuSans-10",
                "THIS IS SOME TEXT IN UPPERCASE\nand this is lowercase...\n" +
                "Try Catching The Brown Fox While It's Jumping Over The Lazy Dog"
            );
            langList[1] = new LangList(
                "Русский",
                "DejaVuSans-10",
                "Всё ускоряющаяся эволюция компьютерных технологий предъявила жёсткие требования к производителям как собственно вычислительной техники, так и периферийных устройств.\n" +
                    "\nЗавершён ежегодный съезд эрудированных школьников, мечтающих глубоко проникнуть в тайны физических явлений и химических реакций.\n" +
                    "\nавтор панграмм -- Андрей Николаев\n" 
                );
        
            langList[2] = new LangList(
                "Română",
                "DejaVuSans-10",
                "CEI PATRU APOSTOLI\nau fost trei:\nLuca şi Matfei\n"
            );
            langList[3] = new LangList(
                "Dansk",
                "DejaVuSans-10",
                "FARLIGE STORE BOGSTAVER\n" +
                "og flere men små...\n" +
               "Quizdeltagerne spiste jordbær med fløde, mens cirkusklovnen Walther spillede på xylofon\n"
                );
        
            langList[4] = new LangList(
                "Chinese",
                "kaiti",
                "CEGUI现在支持中文显示和输入"
                );
            
            langList[5] = new LangList(
                "Japanese",
                "kaiti",//"Sword-26",
                "日本語を選択\nトリガー検知\n鉱石備蓄不足\n"
            );
        
            langList[6] = new LangList(
                "Korean",
                "kaiti", //"Batang-26",
                "한국어를 선택\n트리거 검지\n광석 비축부족\n"
            );
            langList[7] = new LangList(
                "Việt",
                "DejaVuSans-10",
                "Chào CrazyEddie !\nMình rất hạnh phúc khi nghe bạn nói điều đó\n" +
                "Hy vọng sớm được thấy CEGUI hỗ trợ đầy đủ tiếng Việt\nCám ơn bạn rất nhiều\n" +
                 "Chúc bạn sức khoẻ\nTạm biệt !\n"
                );
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
            
            FlameFontManager.getSingleton().createSystemFont("DejaVuSans-10", 12);
            FlameFontManager.getSingleton().createSystemFont("kaiti", 18);
            FlameFontManager.getSingleton().createSystemFont("song", 32);
            
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
            
            var name:String = "FontDemo";//
            var url:String = FlameResourceProvider.getSingleton().getResourceDir() + 
                FlameResourceProvider.getSingleton().getLayoutDir() + 
                name + ".layout";
            
            new TextFileLoader({}, url, onFileLoaded);
            
        }
        
        private function onFileLoaded(tag:*, str:String):void
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            var background:FlameWindow = winMgr.getWindow("root_wnd");

            var sheet:FlameWindow = winMgr.loadWindowLayoutFromString(str) as FlameWindow;
            
            // load some demo windows and attach to the background 'root'
            background.addChildWindow (sheet);
            
            // Add the font names to the listbox
            var lbox:FlameListbox = FlameListbox(winMgr.getWindow ("FontDemo/FontList"));
            lbox.setFontName("DefaultFont");
            
            var fonts:Dictionary = FlameFontManager.getSingleton().getFonts();
            for(var key:String in fonts)
            {
                if(key != "DefaultFont")
                    lbox.addItem(new MyListItem(key));
            }
                
            
            // set up the font listbox callback
            lbox.subscribeEvent (FlameListbox.EventSelectionChanged,
                new Subscriber (handleFontSelection, this), FlameListbox.EventNamespace);
            // select the first font
            lbox.setItemSelectStateByIndex(0, true);
            
            // Add language list to the listbox
            lbox = FlameListbox(winMgr.getWindow ("FontDemo/LangList"));
            lbox.setFontName("DefaultFont");
            for (var i:uint = 0; i < langList.length; i++)
            {
                // only add a language if 'preferred' font is available
                if (FlameFontManager.getSingleton().isDefined(langList[i].Font))
                    lbox.addItem (new MyListItem (langList[i].Language, i));
            }
            // set up the language listbox callback
            lbox.subscribeEvent (FlameListbox.EventSelectionChanged,
                new Subscriber (handleLangSelection, this), FlameListbox.EventNamespace);
            // select the first language
            lbox.setItemSelectStateByIndex(0, true);
            
            winMgr.getWindow("FontDemo/AutoScaled").subscribeEvent (
                FlameCheckbox.EventCheckStateChanged,
                new Subscriber (handleAutoScaled, this), FlameCheckbox.EventNamespace);
            winMgr.getWindow("FontDemo/Antialiased").subscribeEvent (
                FlameCheckbox.EventCheckStateChanged,
                new Subscriber (handleAntialiased, this), FlameCheckbox.EventNamespace);
            winMgr.getWindow("FontDemo/PointSize").subscribeEvent (
                FlameScrollbar.EventScrollPositionChanged,
                new Subscriber (handlePointSize, this), FlameScrollbar.EventNamespace);
        }
        
        
        
        /** When a fonts get selected from the list, we update the name field. Of course,
         this can be done easier (by passing the selected font), but this demonstrates how 
         to query a widget's font. */
        private function setFontDesc ():void
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton ();
            
            var mle:FlameMultiLineEditbox = FlameMultiLineEditbox(winMgr.getWindow("FontDemo/FontSample"));
            
            // Query the font from the textbox
            var f:FlameFont = mle.getFont ();
            
            // Build up the font name...
            var s:String = f.getProperty ("Name");
            if (f.isPropertyPresent ("PointSize"))
                s += "." + f.getProperty ("PointSize");
            
            // ...and set it
            winMgr.getWindow("FontDemo/FontDesc").setText (s);
        }
        
        /** Called when the used selects a different font from the font list.*/
        private function handleFontSelection (e:EventArgs):Boolean
        {
            // Access the listbox which sent the event
            var lbox:FlameListbox = FlameListbox(WindowEventArgs(e).window);
            
            if (lbox.getFirstSelectedItem ())
            {	// Read the fontname and get the font by that name
                var font:FlameFont = FlameFontManager.getSingleton ().getFont(
                    lbox.getFirstSelectedItem ().getText ());
                
                // Tell the textbox to use the newly selected font
                var winMgr:FlameWindowManager = FlameWindowManager.getSingleton ();
                winMgr.getWindow("FontDemo/FontSample").setFont (font);
                
                var b:Boolean = font.isPropertyPresent ("AutoScaled");
                var cb:FlameCheckbox = FlameCheckbox(winMgr.getWindow("FontDemo/AutoScaled"));
                cb.setEnabled (b);
                if (b)
                    cb.setSelected (FlamePropertyHelper.stringToBool (font.getProperty ("AutoScaled")));
                
                b = font.isPropertyPresent ("Antialiased");
                cb = FlameCheckbox(winMgr.getWindow("FontDemo/Antialiased"));
                cb.setEnabled (b);
                if (b)
                    cb.setSelected (FlamePropertyHelper.stringToBool (font.getProperty ("Antialiased")));
                
                b = font.isPropertyPresent ("PointSize");
                var sb:FlameScrollbar = FlameScrollbar(winMgr.getWindow("FontDemo/PointSize"));
                sb.setEnabled (b);
                
                // Set the textbox' font to have the current scale
                if (font.isPropertyPresent("PointSize"))
                    font.setProperty ("PointSize",
                        FlamePropertyHelper.intToString (
                            int (MIN_POINT_SIZE + sb.getScrollPosition ())));
                
                setFontDesc ();
            }
            
            return true;
        }
        
        private function handleAutoScaled (e:EventArgs):Boolean
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton ();
            
            var cb:FlameCheckbox = FlameCheckbox(WindowEventArgs(e).window);
            
            var mle:FlameMultiLineEditbox = FlameMultiLineEditbox(winMgr.getWindow("FontDemo/FontSample"));
            
            var f:FlameFont = mle.getFont ();
            f.setProperty ("AutoScaled",
                FlamePropertyHelper.boolToString (cb.isSelected ()));
            
            updateTextWindows();
            return true;
        }
        
        private function handleAntialiased (e:EventArgs):Boolean
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton ();
            
            var cb:FlameCheckbox = FlameCheckbox(WindowEventArgs(e).window);
            
            var mle:FlameMultiLineEditbox = FlameMultiLineEditbox(winMgr.getWindow("FontDemo/FontSample"));
            
            var f:FlameFont = mle.getFont ();
            f.setProperty ("Antialiased",
                FlamePropertyHelper.boolToString (cb.isSelected ()));
            
            updateTextWindows();
            return true;
        }
        
        private function handlePointSize (e:EventArgs):Boolean
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton ();
            
            var sb:FlameScrollbar = FlameScrollbar(WindowEventArgs(e).window);
            
            var f:FlameFont = winMgr.getWindow ("FontDemo/FontSample").getFont ();
            
            f.setProperty ("PointSize",
                FlamePropertyHelper.intToString (
                    int (MIN_POINT_SIZE + sb.getScrollPosition ())));
            
            setFontDesc ();
            
            updateTextWindows();
            return true;
        }
        
        /** User selects a new language. Change the textbox content, and start with
         the recommended font. */
        private function handleLangSelection (e:EventArgs):Boolean
        {
            // Access the listbox which sent the event
            var lbox:FlameListbox = FlameListbox(WindowEventArgs(e).window);
            
            if (lbox.getFirstSelectedItem ())
            {
                var sel_item:FlameListboxItem = lbox.getFirstSelectedItem();
                var idx:uint = sel_item ? sel_item.getID() : 0;
                var fontName:String = langList[idx].Font;
                
                var winMgr:FlameWindowManager = FlameWindowManager.getSingleton ();
                // Access the font list
                var fontList:FlameListbox = FlameListbox(winMgr.getWindow ("FontDemo/FontList"));
                var lbi:FlameListboxItem = fontList.findItemWithText(fontName, null);
                // Select correct font when not set already
                if (lbi && !lbi.isSelected())
                {	// This will cause 'handleFontSelection' to get called(!)
                    fontList.setItemSelectState(lbi, true);
                }
                
                // Finally, set the sample text for the selected language
                winMgr.getWindow ("FontDemo/FontSample").setText (langList [idx].Text);
            }
            
            return true;
        }
        
        //! Ensure window content and layout is updated.
        private function updateTextWindows():void
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton ();
            var eb:FlameMultiLineEditbox = FlameMultiLineEditbox(winMgr.getWindow("FontDemo/FontSample"));
            // this is a hack to force the editbox to update it's state, and is
            // needed because no facility currently exists for a font to notify that
            // it's internal size or state has changed (ideally all affected windows
            // should receive EventFontChanged - this should be a TODO item!)
            eb.setWordWrapping(false);
            eb.setWordWrapping(true);
            // inform lists of updated data too
            var lb:FlameListbox = FlameListbox(winMgr.getWindow("FontDemo/LangList"));
            lb.handleUpdatedItemData();
            lb = FlameListbox(winMgr.getWindow("FontDemo/FontList"));
            lb.handleUpdatedItemData();
        }
    }
}


import Flame2D.elements.listbox.FlameListboxTextItem;

class LangList
{
    public var Language:String;
    public var Font:String;
    public var Text:String;
    
    public function LangList(lang:String, font:String, text:String)
    {
        Language = lang;
        Font = font;
        Text = text;
    }
}

// Sample sub-class for ListboxTextItem that auto-sets the selection brush
// image.  This saves doing it manually every time in the code.
class MyListItem extends FlameListboxTextItem
{
    public function MyListItem (text:String, item_id:uint = 0)
    {
        super(text, item_id);
        setSelectionBrushImageFromImageSet("TaharezLook", "MultiListSelectionBrush");
    }
}
