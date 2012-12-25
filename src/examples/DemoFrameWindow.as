

package examples {
    import Flame2D.core.system.FlameImageSetManager;
    import Flame2D.core.system.FlameMouseCursor;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.UVector2;
    import Flame2D.elements.window.FlameFrameWindow;
    import Flame2D.elements.window.FlameGUISheet;
    
    import flash.events.KeyboardEvent;
    import examples.base.BaseApplication;

    
    [SWF(width="800", height="600", frameRate="60")]
    public class DemoFrameWindow extends BaseApplication
    {
        private var rootWindow:FlameGUISheet;
        private var frameWindow:FlameFrameWindow;


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
            // Here we create a "DeafultWindow".  This is a native type, that is, it does
            // not have to be loaded via a scheme, it is always available.  One common use
            // for the DefaultWindow is as a generic container for other windows.  Its
            // size defaults to 1.0f x 1.0f using the Relative metrics mode, which means
            // when it is set as the root GUI sheet window, it will cover the entire display.
            // The DefaultWindow does not perform any rendering of its own, so is invisible.
            //
            // Create a DefaultWindow called 'Root'.
            rootWindow = winMgr.createWindow("DefaultWindow", "Root") as FlameGUISheet;
            
            // set the GUI root window (also known as the GUI "sheet"), so the gui we set up
            // will be visible.
            FlameSystem.getSingleton().setGUISheet(rootWindow);
            
            // A FrameWindow is a window with a frame and a titlebar which may be moved around
            // and resized.
            //
            // Create a FrameWindow in the TaharezLook style, and name it 'Demo Window'
            frameWindow = winMgr.createWindow("TaharezLook/FrameWindow", "Demo Window") as FlameFrameWindow;
            
            // Here we attach the newly created FrameWindow to the previously created
            // DefaultWindow which we will be using as the root of the displayed gui.
            rootWindow.addChildWindow(frameWindow);
            
            // Windows are in Relative metrics mode by default.  This means that we can
            // specify sizes and positions without having to know the exact pixel size
            // of the elements in advance.  The relative metrics mode co-ordinates are
            // relative to the parent of the window where the co-ordinates are being set.
            // This means that if 0.5f is specified as the width for a window, that window
            // will be half as its parent window.
            //
            // Here we set the FrameWindow so that it is half the size of the display,
            // and centered within the display.
            frameWindow.setPosition(new UVector2(Misc.cegui_reldim(0.25), Misc.cegui_reldim( 0.25)));
            frameWindow.setSize(new UVector2(Misc.cegui_reldim(0.5), Misc.cegui_reldim( 0.5)));
            
            // now we set the maximum and minum sizes for the new window.  These are
            // specified using relative co-ordinates, but the important thing to note
            // is that these settings are aways relative to the display rather than the
            // parent window.
            //
            // here we set a maximum size for the FrameWindow which is equal to the size
            // of the display, and a minimum size of one tenth of the display.
            frameWindow.setMaxSize(new UVector2(Misc.cegui_reldim(1.0), Misc.cegui_reldim( 1.0)));
            frameWindow.setMinSize(new UVector2(Misc.cegui_reldim(0.1), Misc.cegui_reldim( 0.1)));
            
            // As a final step in the initialisation of our sample window, we set the window's
            // text to "Hello World!", so that this text will appear as the caption in the
            // FrameWindow's titlebar.
            frameWindow.setText("Hello World!");
            
            //set sizing cursor
            frameWindow.setNSSizingCursorImageFromImageSet("TaharezLook", "MouseNoSoCursor");
            frameWindow.setEWSizingCursorImageFromImageSet("TaharezLook", "MouseEsWeCursor");
            frameWindow.setNESWSizingCursorImageFromImageSet("TaharezLook", "MouseNeSwCursor");
            frameWindow.setNWSESizingCursorImageFromImageSet("TaharezLook", "MouseNwSeCursor");
            
        }
    }
}
