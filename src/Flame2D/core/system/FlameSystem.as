/***************************************************************************
 *   Copyright (C) 2004 - 2010 Paul D Turner & The CEGUI Development Team
 *
 *   Porting to Flash Stage3D
 *   Copyright (C) 2012 Mingjian Yu(laoyu20032003@hotmail.com)
 *
 *   Permission is hereby granted, free of charge, to any person obtaining
 *   a copy of this software and associated documentation files (the
 *   "Software"), to deal in the Software without restriction, including
 *   without limitation the rights to use, copy, modify, merge, publish,
 *   distribute, sublicense, and/or sell copies of the Software, and to
 *   permit persons to whom the Software is furnished to do so, subject to
 *   the following conditions:
 *
 *   The above copyright notice and this permission notice shall be
 *   included in all copies or substantial portions of the Software.
 *
 *   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 *   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 *   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 *   IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 *   OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 *   ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 *   OTHER DEALINGS IN THE SOFTWARE.
 ***************************************************************************/
package Flame2D.core.system
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.events.DisplayEventArgs;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.events.KeyEventArgs;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.fonts.FlameSystemFont;
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.text.FlameRenderedStringParser;
    import Flame2D.core.utils.Colour;
    import Flame2D.core.utils.MouseClickTracker;
    import Flame2D.core.utils.MouseClickTrackerImpl;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.Vector2;
    import Flame2D.elements.base.FlameGroupBox;
    import Flame2D.elements.base.FlameItemEntry;
    import Flame2D.elements.base.FlameItemListbox;
    import Flame2D.elements.base.FlameScrollbar;
    import Flame2D.elements.button.FlameCheckbox;
    import Flame2D.elements.button.FlamePushButton;
    import Flame2D.elements.button.FlameRadioButton;
    import Flame2D.elements.combobox.FlameComboDropList;
    import Flame2D.elements.combobox.FlameCombobox;
    import Flame2D.elements.containers.FlameClippedContainer;
    import Flame2D.elements.containers.FlameGridLayoutContainer;
    import Flame2D.elements.containers.FlameHorizontalLayoutContainer;
    import Flame2D.elements.containers.FlameScrollablePane;
    import Flame2D.elements.containers.FlameScrolledContainer;
    import Flame2D.elements.containers.FlameVerticalLayoutContainer;
    import Flame2D.elements.dnd.FlameDragContainer;
    import Flame2D.elements.editbox.FlameEditbox;
    import Flame2D.elements.editbox.FlameMultiLineEditbox;
    import Flame2D.elements.list.FlameListHeader;
    import Flame2D.elements.list.FlameListHeaderSegment;
    import Flame2D.elements.list.FlameMultiColumnList;
    import Flame2D.elements.listbox.FlameListbox;
    import Flame2D.elements.menu.FlameMenuItem;
    import Flame2D.elements.menu.FlameMenubar;
    import Flame2D.elements.menu.FlamePopupMenu;
    import Flame2D.elements.progressbar.FlameProgressBar;
    import Flame2D.elements.slider.FlameSlider;
    import Flame2D.elements.spinner.FlameSpinner;
    import Flame2D.elements.tab.FlameTabButton;
    import Flame2D.elements.tab.FlameTabControl;
    import Flame2D.elements.thumb.FlameThumb;
    import Flame2D.elements.tooltip.FlameTooltip;
    import Flame2D.elements.tree.FlameTree;
    import Flame2D.elements.window.FlameFrameWindow;
    import Flame2D.elements.window.FlameGUISheet;
    import Flame2D.elements.window.FlameTitlebar;
    import Flame2D.renderer.FlameRenderer;
        
    
    /*!
    \brief
    The System class is the CEGUI class that provides access to all other elements in this system.
    
    This object must be created by the client application.  The System object requires that you pass it
    an initialised Renderer object which it can use to interface to whatever rendering system will be
    used to display the GUI imagery.
    */
    public class FlameSystem extends FlameEventSet
    {
        public static const VERSION:String          = "0.1";
        
        public static const EventNamespace:String = "System";				//!< Namespace for global events
        
        /*************************************************************************
         Constants
         *************************************************************************/
        public static const DefaultSingleClickTimeout:Number = 0.0;		//!< Default timeout for generation of single click events.
        public static const DefaultMultiClickTimeout:Number = 0.33;		//!< Default timeout for generation of multi-click events.
        public static const DefaultMultiClickAreaSize:Size = new Size(12, 12);		//!< Default allowable mouse movement for multi-click event generation.

        /** Event fired whenever the GUI sheet is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the @e old GUI sheet (the new one is
         * obtained by querying System).
         */
        public static const EventGUISheetChanged:String = "GUISheetChanged";
        /** Event fired when the single-click timeout is changed.
         * Handlers are passed a const reference to a generic EventArgs struct.
         */
        public static const EventSingleClickTimeoutChanged:String = "SingleClickTimeoutChanged";
        /** Event fired when the multi-click timeout is changed.
         * Handlers are passed a const reference to a generic EventArgs struct.
         */
        public static const EventMultiClickTimeoutChanged:String = "MultiClickTimeoutChanged";
        /** Event fired when the size of the multi-click tolerance area is changed.
         * Handlers are passed a const reference to a generic EventArgs struct.
         */
        public static const EventMultiClickAreaSizeChanged:String = "MultiClickAreaSizeChanged";
        /** Event fired when the default font changes.
         * Handlers are passed a const reference to a generic EventArgs struct.
         */
        public static const EventDefaultFontChanged:String = "DefaultFontChanged";
        /** Event fired when the default mouse cursor changes.
         * Handlers are passed a const reference to a generic EventArgs struct.
         */
        public static const EventDefaultMouseCursorChanged:String = "DefaultMouseCursorChanged";
        /** Event fired when the mouse move scaling factor changes.
         * Handlers are passed a const reference to a generic EventArgs struct.
         */
        public static const EventMouseMoveScalingChanged:String = "MouseMoveScalingChanged";
        /** Event fired for display size changes (as notified by client code).
         * Handlers are passed a const DisplayEventArgs reference with
         * DisplayEventArgs::size set to the pixel size that was notifiied to the
         * system.
         */
        public static const EventDisplaySizeChanged:String = "DisplaySizeChanged";
        /** Event fired when global custom RenderedStringParser is set.
         * Handlers are passed a const reference to a generic EventArgs struct.
         */
        public static const EventRenderedStringParserChanged:String = "RenderedStringParserChanged";
        
       
        
        /*************************************************************************
         Implementation Data
         *************************************************************************/
        private var d_renderer:FlameRenderer = null;			//!< Holds the pointer to the Renderer object given to us in the constructor
        private var d_resourceProvider:FlameResourceProvider = null;      //!< Holds the pointer to the ResourceProvider object given to us by the renderer or the System constructor.
        private var d_ourResourceProvider:Boolean = false;
        private var d_defaultFont:FlameFont = null;		//!< Holds a pointer to the default GUI font.
        private var d_gui_redraw:Boolean = false;		//!< True if GUI should be re-drawn, false if render should re-use last times queue.
        
        private var d_wndWithMouse:FlameWindow = null;		//!< Pointer to the window that currently contains the mouse.
        private var d_activeSheet:FlameWindow = null;		//!< The active GUI sheet (root window)
        private var d_modalTarget:FlameWindow = null;		//!< Pointer to the window that is the current modal target. NULL is there is no modal target.
        
        //private var d_strVersion:String;    //!< CEGUI version
        
        private var d_sysKeys:uint = 0;			//!< Current set of system keys pressed (in mk1 these were passed in, here we track these ourself).
        private var d_lshift:Boolean = false;			//!< Tracks state of left shift.
        private var d_rshift:Boolean = false;			//!< Tracks state of right shift.
        private var d_lctrl:Boolean = false;			//!< Tracks state of left control.
        private var d_rctrl:Boolean = false;			//!< Tracks state of right control.
        private var d_lalt:Boolean = false;				//!< Tracks state of left alt.
        private var d_ralt:Boolean = false;				//!< Tracks state of right alt.
        
        //tracking dragging
        private var d_dragging:Boolean = false;
        
        
        private var d_click_timeout:Number = DefaultSingleClickTimeout;	//!< Timeout value, in seconds, used to generate a single-click (button down then up)
        private var d_dblclick_timeout:Number = DefaultMultiClickTimeout;	//!< Timeout value, in seconds, used to generate multi-click events (botton down, then up, then down, and so on).
        private var d_dblclick_size:Size = DefaultMultiClickAreaSize;	//!< Size of area the mouse can move and still make multi-clicks.
        
        private var d_clickTrackerPimpl:MouseClickTrackerImpl = new MouseClickTrackerImpl();		//!< Tracks mouse button click generation.
        
        // mouse cursor related
        //private var d_defaultMouseCursor:FlameMouseCursor = null;
        private var d_defaultMouseCursorImage:FlameImage = null;		//!< Image to be used as the default mouse cursor.
        
        // scripting
        //ScriptModule*	d_scriptModule;			//!< Points to the scripting support module.
        //String			d_termScriptName;		//!< Name of the script to run upon system shutdown.
        
        private var d_mouseScalingFactor:Number = 2.0;			//!< Scaling applied to mouse movement inputs.
        
        //! System default tooltip object.
        private var d_defaultTooltip:FlameTooltip = null;
        //! true if System created d_defaultTooltip.
        private var d_weOwnTooltip:Boolean = false;
        //! type of window to create as d_defaultTooltip
        private var d_defaultTooltipType:String = "";
        
        //! currently set global RenderedStringParser.
        private var d_customRenderedStringParser:FlameRenderedStringParser = null;
        //! true if mouse click events will be automatically generated.
        private var d_generateMouseClickEvents:Boolean = true;
 
        

        
        //singleton
        private static var _singleton:FlameSystem = new FlameSystem();
        // construction
        public function FlameSystem()
        {
            if(_singleton){
                throw new Error("FlameSystem: only one instance!");
            }
            
            initialize();
        }
        
        public static function getSingleton():FlameSystem
        {
            return _singleton;
        }
        
        

        
        
        
        public function initialize():void
        {

            d_renderer = FlameRenderer.getSingleton();
            //init managers
            //FlameResourceProvider.getSingleton().initialize();
            //FlameRenderer.getSingleton().initialize();
            //FlameSchemeManager.getSingleton().initialize();
            //initialize(stage);
            //FlameWindowManager.getSingleton().initialize();
            
            // create the core system singleton objects
            createSingletons();
            
            // add the window factories for the core window types
            addStandardWindowFactories();
            
            // GUISheet's name was changed, register an alias so both can be used
            FlameWindowFactoryManager.getSingleton().addWindowTypeAlias("DefaultGUISheet", FlameGUISheet.WidgetTypeName);

            
            
//            char addr_buff[32];
//            sprintf(addr_buff, "(%p)", static_cast<void*>(this));
//            logger.logEvent("CEGUI::System singleton created. " + String(addr_buff));
//            logger.logEvent("---- CEGUI System initialisation completed ----");
//            logger.logEvent("");
//            
//            // autoload resources specified in config
//            config.loadAutoResources();
//            
//            // set up defaults
//            config.initialiseDefaultFont();
            //d_defaultFont = new FlameFont("Arial", "", "", "", false, 12, 12);
//            config.initialiseDefaultMouseCursor();
//            config.initialiseDefaulTooltip();
//            config.initialiseDefaultGUISheet();
//            
//            // scripting available?
//            if (d_scriptModule)
//            {
//                d_scriptModule->createBindings();
//                config.executeInitScript();
//                d_termScriptName = config.getTerminateScriptName();
//            }
        
        }
        
        
        private function createSingletons():void
        {
            // cause creation of other singleton objects
//            new ImagesetManager();
//            new FontManager();
//            new WindowFactoryManager();
//            new WindowManager();
//            new SchemeManager();
//            new MouseCursor();
//            new GlobalEventSet();
//            new AnimationManager();
//            new WidgetLookManager();
//            new WindowRendererManager();
//            new RenderEffectManager();
        }
        
   
        /*!
        \brief
        Return a pointer to the Renderer object being used by the system
        
        \return
        Pointer to the Renderer object used by the system.
        */
        public function getRenderer():FlameRenderer
        {
            return d_renderer;
        }
        
        
        /*!
        \brief
        Set the default font to be used by the system
        
        \param name
        String object containing the name of the font to be used as the system default.
        
        \return
        Nothing.
        */
        public function setDefaultFontByName(name:String):void
        {
            if (name.length == 0)
            {
                setDefaultFont(null);
            }
            else
            {
                setDefaultFont(FlameFontManager.getSingleton().getFont(name));
            }
        }
        
        
        /*!
        \brief
        Set the default font to be used by the system
        
        \param font
        Pointer to the font to be used as the system default.
        
        \return
        Nothing.
        */
        public function setDefaultFont(font:FlameFont):void
        {
            d_defaultFont = font;
            
            // fire event
            var args:EventArgs = new EventArgs();
            onDefaultFontChanged(args);
        }
        
        
        /*!
        \brief
        Return a pointer to the default Font for the GUI system
        
        \return
        Pointer to a Font object that is the default font in the system.
        */
        public function getDefaultFont():FlameFont
        {
            return d_defaultFont;
        }
        
        /*!
        \brief
        Causes a full re-draw next time renderGUI() is called
        
        \return
        Nothing
        */
        public function signalRedraw():void
        {
            d_gui_redraw = true;
        }
        
        /*!
        \brief
        Return a boolean value to indicate whether a full re-draw is requested next time renderGUI() is called.
        
        \return
        true if a re-draw has been requested
        */
        public function isRedrawRequested():Boolean
        {
            return d_gui_redraw;
        }
        

        
        /*!
        \brief
        Render the GUI
        
        Depending upon the internal state, this may either re-use rendering from last time, or trigger a full re-draw from all elements.
        
        \return
        Nothing
        */
        public function renderGUI():void
        {
            d_renderer.beginRendering();
            
            if (d_gui_redraw)
            {
                if (d_activeSheet)
                {
                    var rs:FlameRenderingSurface = d_activeSheet.getTargetRenderingSurface();
                    rs.clearAllGeometry();
                    
                    if (rs.isRenderingWindow())
                        (rs as FlameRenderingWindow).getOwner().clearAllGeometry();
                    
                    d_activeSheet.render();
                }
                // no sheet, so ensure default surface geometry is cleared
                else
                    d_renderer.getDefaultRenderingRoot().clearAllGeometry();
                
                d_gui_redraw = false;
            }
            
            d_renderer.getDefaultRenderingRoot().drawAll();
            FlameMouseCursor.getSingleton().draw();
            d_renderer.endRendering();
            
            // do final destruction on dead-pool windows
            FlameWindowManager.getSingleton().cleanDeadPool();
        }
        
        
        /*!
        \brief
        Set the active GUI sheet (root) window.
        
        \param sheet
        Pointer to a Window object that will become the new GUI 'root'
        
        \return
        Pointer to the window that was previously set as the GUI root.
        */
        public function setGUISheet(sheet:FlameWindow):FlameWindow
        {
            var old:FlameWindow = d_activeSheet;
            d_activeSheet = sheet;
            
            // Force and update for the area Rects for 'sheet' so they're correct according
            // to the screen size.
            if (sheet)
            {
                var sheetargs:WindowEventArgs = new WindowEventArgs(null);
                sheet.onParentSized(sheetargs);
            }
            
            // fire event
            var args:WindowEventArgs = new WindowEventArgs(old);
            onGUISheetChanged(args);
            
            return old;
        }
        
        
        /*!
        \brief
        Return a pointer to the active GUI sheet (root) window.
        
        \return
        Pointer to the window object that has been set as the GUI root element.
        */
        public function getGUISheet():FlameWindow
        {
            return d_activeSheet;
        }
        
        
        /*!
        \brief
        Return the current timeout for generation of single-click events.
        
        A single-click is defined here as a button being pressed and then released.
        
        \return
        double value equal to the current single-click timeout value.
        */
        public function getSingleClickTimeout():Number
        {
            return d_click_timeout;
        }
        
        
        /*!
        \brief
        Return the current timeout for generation of multi-click events.
        
        A multi-click event is a double-click, or a triple-click.  The value returned
        here is the maximum allowable time between mouse button down events for which
        a multi-click event will be generated.
        
        \return
        double value equal to the current multi-click timeout value.
        */
        public function getMultiClickTimeout():Number
        {
            return d_dblclick_timeout;
        }
        
        
        /*!
        \brief
        Return the size of the allowable mouse movement tolerance used when generating multi-click events.
        
        This size defines an area with the mouse at the centre.  The mouse must stay within the tolerance defined
        for a multi-click (double click, or triple click) event to be generated.
        
        \return
        Size object describing the current multi-click tolerance area size.
        */
        public function getMultiClickToleranceAreaSize():Size
        {
            return d_dblclick_size;
        }
        
        
        /*!
        \brief
        Set the timeout used for generation of single-click events.
        
        A single-click is defined here as a button being pressed and then
        released.
        
        \param timeout
        double value equal to the single-click timeout value to be used from now
        onwards.
        
        \note
        A timeout value of 0 indicates infinity and so no timeout occurrs; as
        long as the mouse is in the prescribed area, a mouse button 'clicked'
        event will therefore always be raised.
        
        \return
        Nothing.
        */
        public function setSingleClickTimeout(timeout:Number):void
        {
            d_click_timeout = timeout;
            
            // fire off event.
            var args:EventArgs = new EventArgs();
            onSingleClickTimeoutChanged(args);
        }
        
        
        /*!
        \brief
        Set the timeout to be used for the generation of multi-click events.
        
        A multi-click event is a double-click, or a triple-click.  The value
        returned here is the maximum allowable time between mouse button down
        events for which a multi-click event will be generated.
        
        \param timeout
        double value equal to the multi-click timeout value to be used from now
        onwards.
        
        \note
        A timeout value of 0 indicates infinity and so no timeout occurrs; as
        long as the mouse is in the prescribed area, an appropriate mouse button
        event will therefore always be raised.
        
        \return
        Nothing.
        */
        public function setMultiClickTimeout(timeout:Number):void
        {
            d_dblclick_timeout = timeout;
            
            // fire off event.
            var args:EventArgs = new EventArgs();
            onMultiClickTimeoutChanged(args);
        }
        
        
        /*!
        \brief
        Set the size of the allowable mouse movement tolerance used when generating multi-click events.
        
        This size defines an area with the mouse at the centre.  The mouse must stay within the tolerance defined
        for a multi-click (double click, or triple click) event to be generated.
        
        \param sz
        Size object describing the multi-click tolerance area size to be used.
        
        \return
        Nothing.
        */
        public function setMultiClickToleranceAreaSize(sz:Size):void
        {
            d_dblclick_size = sz;
            
            // fire off event.
            var args:EventArgs = new EventArgs;
            onMultiClickAreaSizeChanged(args);
        }
        
        /*!
        \brief
        Return whether automatic mouse button click and multi-click (i.e.
        double-click and treble-click) event generation is enabled.
        
        \return
        - true if mouse button click and multi-click events will be
        automatically generated by the system from the basic button up and down
        event injections.
        - false if no automatic generation of events will occur.  In this
        instance the user may wish to use the additional event injectors to
        manually inform the system of such events.
        */
        public function isMouseClickEventGenerationEnabled():Boolean
        {
            return d_generateMouseClickEvents;
        }
        
        /*!
        \brief
        Set whether automatic mouse button click and multi-click (i.e.
        double-click and treble-click) event generation will occur.
        
        \param enable
        - true to have mouse button click and multi-click events automatically
        generated by the system from the basic button up and down event
        injections.
        - false if no automatic generation of events should occur.  In this
        instance the user may wish to use the additional event injectors to
        manually inform the system of such events.
        */
        public function setMouseClickEventGenerationEnabled(enable:Boolean):void
        {
            d_generateMouseClickEvents = enable;
        }
        
        /*!
        \brief
        Return the currently set default mouse cursor image
        
        \return
        Pointer to the current default image used for the mouse cursor.  May return NULL if default cursor has not been set,
        or has intentionally been set to NULL - which results in a blank default cursor.
        */
        public function getDefaultMouseCursor():FlameImage
        {
            return d_defaultMouseCursorImage;
        }
        
        /*!
        \brief
        Set the image to be used as the default mouse cursor.
        
        \param image
        Pointer to an image object that is to be used as the default mouse cursor.  To have no cursor rendered by default, you
        can specify NULL here.
        
        \return
        Nothing.
        */
        public function setDefaultMouseCursor(image:FlameImage):void
        {
            // the default, default, is for nothing!
            if (image == d_defaultMouseCursorImage){
                return;
            }
            
            // if mouse cursor is set to the current default we *may* need to
            // update its Image immediately (first, we will investigate further!)
            //
            // NB: The reason we do this check, is to allow code to modify the cursor
            // image directly without a call to this member changing the image back
            // again.  However, 'normal' updates to the cursor when the mouse enters
            // a window will, of course, update the mouse image as expected.
            if (FlameMouseCursor.getSingleton().getImage() == d_defaultMouseCursorImage)
            {
                // does the window containing the mouse use the default cursor?
//                if ((d_wndWithMouse) &&
//                    (default_cursor == d_wndWithMouse.getMouseCursor(false)))
                if(d_wndWithMouse)
                {
                    // default cursor is active, update the image immediately
                    FlameMouseCursor.getSingleton().setImage(image);
                }
            }
            
            // update our pointer for the default mouse cursor image.
            d_defaultMouseCursorImage = image;
            
            // fire off event.
            var args:EventArgs = new EventArgs();
            onDefaultMouseCursorChanged(args);
            
        }
        
        
        /*!
        \brief
        Set the image to be used as the default mouse cursor.
        
        \param imageset
        String object that contains the name of the Imageset  that contains the image to be used.
        
        \param image_name
        String object that contains the name of the Image on \a imageset that is to be used.
        
        \return
        Nothing.
        
        \exception UnknownObjectException	thrown if \a imageset is not known, or if \a imageset contains no Image named \a image_name.
        */
        public function setDefaultMouseCursorFromImageSet(imageset:String, image_name:String):void
        {
            setDefaultMouseCursor(FlameImageSetManager.getSingleton().getImageSet(imageset).getImage(image_name));
        }
        
        
        /*!
        \brief
        Return the Window object that the mouse is presently within
        
        \return
        Pointer to the Window object that currently contains the mouse cursor, or NULL if none.
        */
        public function getWindowContainingMouse():FlameWindow
        {
            return d_wndWithMouse;
        }
        
        /*!
        \brief
        return the current mouse movement scaling factor.
        
        \return
        float value that is equal to the currently set mouse movement scaling factor.  Defaults to 1.0f.
        */
        public function getMouseMoveScaling():Number
        {
            return d_mouseScalingFactor;
        }
        
        
        /*!
        \brief
        Set the current mouse movement scaling factor
        
        \param scaling
        float value specifying the scaling to be applied to mouse movement inputs.
        
        \return
        nothing.
        */
        public function setMouseMoveScaling(scaling:Number):void
        {
            d_mouseScalingFactor = scaling;
            
            // fire off event.
            var args:EventArgs = new EventArgs();
            onMouseMoveScalingChanged(args);
        }
        
        
        /*!
        \brief
        Internal method used to inform the System object whenever a window is destroyed, so that System can perform any required
        housekeeping.
        
        \note
        This method is not intended for client code usage.  If you use this method anything can, and probably will, go wrong!
        */
        public function notifyWindowDestroyed(window:FlameWindow):void
        {
            if (d_wndWithMouse == window)
            {
                d_wndWithMouse = null;
            }
            
            if (d_activeSheet == window)
            {
                d_activeSheet = null;
            }
            
            if (d_modalTarget == window)
            {
                d_modalTarget = null;
            }
            
            if ((d_defaultTooltip as FlameWindow) == window)
            {
                d_defaultTooltip = null;
                d_weOwnTooltip = false;
            }

        }
        
        
        /*!
        \brief
        Return the current system keys value.
        
        \return
        uint value representing a combination of the SystemKey bits.
        */
        public function getSystemKeys():uint
        {
            return d_sysKeys;
        }

        
        /*!
        \brief
        Set the system default Tooltip object.  This value may be NULL to indicate that no default Tooltip will be
        available.
        
        \param tooltip
        Pointer to a valid Tooltip based object which should be used as the default tooltip for the system, or NULL to
        indicate that no system default tooltip is required.  Note that when passing a pointer to a Tooltip object,
        ownership of the Tooltip does not pass to System.
        
        \return
        Nothing.
        */
        public function setDefaultTooltip(tooltip:FlameTooltip):void
        {
            destroySystemOwnedDefaultTooltipWindow();
            
            d_defaultTooltip = tooltip;
            
//            if (d_defaultTooltip)
//                d_defaultTooltip->setWritingXMLAllowed(false);
        }
        
        /*!
        \brief
        Set the system default Tooltip to be used by specifying a Window type.
        
        System will internally attempt to create an instance of the specified window type (which must be
        derived from the base Tooltip class).  If the Tooltip creation fails, the error is logged and no
        system default Tooltip will be available.
        
        \param tooltipType
        String object holding the name of the Tooltip based Window type which should be used as the Tooltip for
        the system default.
        
        \return
        Nothing.
        */
        public function setDefaultTooltipForType(tooltipType:String):void
        {
            destroySystemOwnedDefaultTooltipWindow();
            
            d_defaultTooltipType = tooltipType;
        }
        
        /*!
        \brief
        return a poiter to the system default tooltip.  May return 0.
        
        \return
        Pointer to the current system default tooltip.  May return 0 if
        no system default tooltip is available.
        */
        public function getDefaultTooltip():FlameTooltip
        {
            if (!d_defaultTooltip && d_defaultTooltipType.length != 0)
                createSystemOwnedDefaultTooltipWindow();
            
            return d_defaultTooltip;
        }
        
        /*!
        \brief
        Internal method to directly set the current modal target.
        
        \note
        This method is called internally by Window, and must be used by client code.
        Doing so will most likely not have the expected results.
        */
        public function setModalTarget(target:FlameWindow):void
        {
            d_modalTarget = target;
        }
        
        /*!
        \brief
        Return a pointer to the Window that is currently the modal target.
        
        \return
        Pointer to the current modal target. NULL if there is no modal target.
        */
        public function getModalTarget():FlameWindow
        {
            return d_modalTarget;
        }
        
        /*!
        \brief
        Perform updates with regards to the window that contains the mouse
        cursor, firing any required MouseEnters / MouseLeaves events.
        
        \note
        The CEGUI system components call this member as a matter of course,
        in most cases there will be no need for user / client code to call this
        member directly.
        
        \return
        - true if the window containing the mouse had changed.
        - false if the window containing the mouse had not changed.
        */
        public function updateWindowContainingMouse():Boolean
        {
            var ma:MouseEventArgs = new MouseEventArgs(null);
            const mouse_pos:Vector2 = FlameMouseCursor.getSingleton().getPosition();
            
            const curr_wnd_with_mouse:FlameWindow = getTargetWindow(mouse_pos, true);
            
            // exit if window containing mouse has not changed.
            if (curr_wnd_with_mouse == d_wndWithMouse)
                return false;
            
            ma.sysKeys = d_sysKeys;
            ma.wheelChange = 0;
            ma.clickCount = 0;
            ma.button = Consts.MouseButton_NoButton;
            
            var oldWindow:FlameWindow = d_wndWithMouse;
            d_wndWithMouse = curr_wnd_with_mouse;
            
            // inform previous window the mouse has left it
            if (oldWindow)
            {
                ma.window = oldWindow;
                ma.position = oldWindow.getUnprojectedPosition(mouse_pos);
                oldWindow.onMouseLeaves(ma);
            }
            
            // inform window containing mouse that mouse has entered it
            if (d_wndWithMouse)
            {
                ma.handled = 0;
                ma.window = d_wndWithMouse;
                ma.position = d_wndWithMouse.getUnprojectedPosition(mouse_pos);
                d_wndWithMouse.onMouseEnters(ma);
            }
            
            // do the 'area' version of the events
            var root:FlameWindow = getCommonAncestor(oldWindow, d_wndWithMouse);
            
            if (oldWindow)
                notifyMouseTransition(root, oldWindow, "onMouseLeavesArea", ma);
            
            if (d_wndWithMouse)
                notifyMouseTransition(root, d_wndWithMouse, "onMouseEntersArea", ma);
            
            return true;
        }

        /*!
        \brief
        Notification function to be called when the main display changes size.
        Client code should call this function when the host window changes size,
        or if the display resolution is changed in full-screen mode.
        
        Calling this function ensures that any other parts of the system that
        need to know about display size changes are notified.  This affects
        things such as the MouseCursor default constraint area, and also the
        auto-scale functioning of Imagesets and Fonts.
        
        \note
        This function will also fire the System::EventDisplaySizeChanged event.
        
        \param new_size
        Size object describing the new display size in pixels.
        */
        public function notifyDisplaySizeChanged(new_size:Size):void
        {
            // notify other components of the display size change
            d_renderer.setDisplaySize(new_size);
            FlameImageSetManager.getSingleton().notifyDisplaySizeChanged(new_size);
            FlameFontManager.getSingleton().notifyDisplaySizeChanged(new_size);
            FlameMouseCursor.getSingleton().notifyDisplaySizeChanged(new_size);
            
            // notify gui sheet / root if size change, event propagation will ensure everything else
            // gets updated as required.
            //
            // FIXME: This is no longer correct, the RenderTarget the sheet is using as
            // FIXME: it's parent element may not be the main screen.
            if (d_activeSheet)
            {
                var args1:WindowEventArgs = new WindowEventArgs(null);
                d_activeSheet.onParentSized(args1);
            }
            
            FlameWindowManager.getSingleton().invalidateAllWindows();
            
            // Fire event
            var args:DisplayEventArgs = new DisplayEventArgs(new_size);
            fireEvent(EventDisplaySizeChanged, args, EventNamespace);
            
            trace(
                "Display resize:" +
                " w=" + FlamePropertyHelper.floatToString(new_size.d_width) +
                " h=" + FlamePropertyHelper.floatToString(new_size.d_height));
        }
        

        /*!
        \brief
        Return pointer to the currently set global default custom
        RenderedStringParser object.
        
        The returned RenderedStringParser is used for all windows that have
        parsing enabled and no custom RenderedStringParser set on the window
        itself.
        
        If this global custom RenderedStringParser is set to 0, then all windows
        with parsing enabled and no custom RenderedStringParser set on the
        window itself will use the systems BasicRenderedStringParser. 
        */
        public function getDefaultCustomRenderedStringParser():FlameRenderedStringParser
        {
            return d_customRenderedStringParser;
        }
        
        /*!
        \brief
        Set the global default custom RenderedStringParser object.  This change
        is reflected the next time an affected window reparses it's text.  This
        may be set to 0 for no system wide custom parser (which is the default).
        
        The set RenderedStringParser is used for all windows that have
        parsing enabled and no custom RenderedStringParser set on the window
        itself.
        
        If this global custom RenderedStringParser is set to 0, then all windows
        with parsing enabled and no custom RenderedStringParser set on the
        window itself will use the systems BasicRenderedStringParser. 
        */
        public function setDefaultCustomRenderedStringParser(parser:FlameRenderedStringParser):void
        {
            if (parser != d_customRenderedStringParser)
            {
                d_customRenderedStringParser = parser;
                
                // fire event
                var args:EventArgs = new EventArgs();
                fireEvent(EventRenderedStringParserChanged, args, EventNamespace);
            }
        }

        /*!
        \brief
        Invalidate all imagery and geometry caches for CEGUI managed elements.
        
        This function will invalidate the caches used for both imagery and
        geometry for all content that is managed by the core CEGUI manager
        objects, causing a full and total redraw of that content.  This
        includes Window object's cached geometry, rendering surfaces and
        rendering windows and the mouse pointer geometry.
        */
        //void invalidateAllCachedRendering();


        /*************************************************************************
         Input injection interface
         *************************************************************************/
        /*!
        \brief
        Method that injects a mouse movement event into the system
        
        \param delta_x
        amount the mouse moved on the x axis.
        
        \param delta_y
        amount the mouse moved on the y axis.
        
        \return
        - true if the input was processed by the gui system.
        - false if the input was not processed by the gui system.
        */
        public function injectMouseMove(delta_x:Number, delta_y:Number):Boolean
        {
            var ma:MouseEventArgs = new MouseEventArgs(null);
            ma.moveDelta.d_x = delta_x * d_mouseScalingFactor;
            ma.moveDelta.d_y = delta_y * d_mouseScalingFactor;
            
            // no movement means no event
            if ((ma.moveDelta.d_x == 0) && (ma.moveDelta.d_y == 0))
                return false;
            
            ma.sysKeys = d_sysKeys;
            ma.wheelChange = 0;
            ma.clickCount = 0;
            ma.button = Consts.MouseButton_NoButton;
            
            
            // move the mouse cursor & update position in args.
            var mouse:FlameMouseCursor = FlameMouseCursor.getSingleton();
            mouse.offsetPosition(ma.moveDelta);
            ma.position = mouse.getPosition();
            
            return mouseMoveInjection_impl(ma);
        }
        
        
        /*!
        \brief
        Method that injects that the mouse has left the application window
        
        \return
        - true if the generated mouse move event was handled.
        - false if the generated mouse move event was not handled.
        */
        public function injectMouseLeaves():Boolean
        {
            var ma:MouseEventArgs = new MouseEventArgs(null);
            
            // if there is no window that currently contains the mouse, then
            // there is nowhere to send input
            if (d_wndWithMouse)
            {
                ma.position = d_wndWithMouse.
                    getUnprojectedPosition(FlameMouseCursor.getSingleton().getPosition());
                ma.moveDelta = new Vector2(0.0, 0.0);
                ma.button = Consts.MouseButton_NoButton;
                ma.sysKeys = d_sysKeys;
                ma.wheelChange = 0;
                ma.window = d_wndWithMouse;
                ma.clickCount = 0;
                
                d_wndWithMouse.onMouseLeaves(ma);
                d_wndWithMouse = null;
            }
            
            return ma.handled != 0;
        }
        
        
        /*!
        \brief
        Method that injects a mouse button down event into the system.
        
        \param button
        One of the MouseButton values indicating which button was pressed.
        
        \return
        - true if the input was processed by the gui system.
        - false if the input was not processed by the gui system.
        */
        public function injectMouseButtonDown(button:uint):Boolean
        {
            // update system keys
            d_sysKeys |= mouseButtonToSyskey(button);
            
            var ma:MouseEventArgs = new MouseEventArgs(null);
            ma.position = FlameMouseCursor.getSingleton().getPosition();
            ma.moveDelta = new Vector2(0.0, 0.0);
            ma.button = button;
            ma.sysKeys = d_sysKeys;
            ma.wheelChange = 0;
            ma.window = getTargetWindow(ma.position, false);
            // make mouse position sane for this target window
            if (ma.window)
                ma.position = ma.window.getUnprojectedPosition(ma.position);
            
            //
            // Handling for multi-click generation
            //
            var tkr:MouseClickTracker = d_clickTrackerPimpl.click_trackers[button];
            
            tkr.d_click_count++;
            
            // if multi-click requirements are not met
            if (((d_dblclick_timeout > 0) && (tkr.d_timer.elapsed() > d_dblclick_timeout)) ||
                (!tkr.d_click_area.isPointInRect(ma.position)) ||
                (tkr.d_target_window != ma.window) ||
                (tkr.d_click_count > 3))
            {
                // reset to single down event.
                tkr.d_click_count = 1;
                
                // build new allowable area for multi-clicks
                tkr.d_click_area.setPosition(ma.position);
                tkr.d_click_area.setSize(d_dblclick_size);
                tkr.d_click_area.offset2(new Vector2(-(d_dblclick_size.d_width / 2), -(d_dblclick_size.d_height / 2)));
                
                // set target window for click events on this tracker
                tkr.d_target_window = ma.window;
            }
            
            // set click count in the event args
            ma.clickCount = tkr.d_click_count;
            
            if (ma.window)
            {
                if (d_generateMouseClickEvents && ma.window.wantsMultiClickEvents())
                {
                    switch (tkr.d_click_count)
                    {
                        case 1:
                            ma.window.onMouseButtonDown(ma);
                            break;
                        
                        case 2:
                            ma.window.onMouseDoubleClicked(ma);
                            break;
                        
                        case 3:
                            ma.window.onMouseTripleClicked(ma);
                            break;
                    }
                }
                    // click generation disabled, or current target window does not want
                    // multi-clicks, so just send a mouse down event instead.
                else
                {
                    ma.window.onMouseButtonDown(ma);
                }
            }
            
            // reset timer for this tracker.
            tkr.d_timer.restart();
            
            return ma.handled != 0;
        }
        
        
        /*!
        \brief
        Method that injects a mouse button up event into the system.
        
        \param button
        One of the MouseButton values indicating which button was released.
        
        \return
        - true if the input was processed by the gui system.
        - false if the input was not processed by the gui system.
        */
        public function injectMouseButtonUp(button:uint):Boolean
        {
            // update system keys
            d_sysKeys &= ~mouseButtonToSyskey(button);
            
            var ma:MouseEventArgs = new MouseEventArgs(null);
            ma.position = FlameMouseCursor.getSingleton().getPosition();
            ma.moveDelta = new Vector2(0.0, 0.0);
            ma.button = button;
            ma.sysKeys = d_sysKeys;
            ma.wheelChange = 0;
            ma.window = getTargetWindow(ma.position, false);
            // make mouse position sane for this target window
            if (ma.window)
                ma.position = ma.window.getUnprojectedPosition(ma.position);
            
            // get the tracker that holds the number of down events seen so far for this button
            var tkr:MouseClickTracker = d_clickTrackerPimpl.click_trackers[button];
            // set click count in the event args
            ma.clickCount = tkr.d_click_count;
            
            // if there is no window, inputs can not be handled.
            if (!ma.window)
                return false;
            
            // store original window becase we re-use the event args.
            var tgt_wnd:FlameWindow = ma.window;
            
            // send 'up' input to the window
            ma.window.onMouseButtonUp(ma);
            // store whether the 'up' part was handled so we may reuse the EventArgs
            var upHandled:uint = ma.handled;
            
            // restore target window (because Window::on* may have propagated input)
            ma.window = tgt_wnd;
            
            // send MouseClicked event if the requirements for that were met
            if (d_generateMouseClickEvents &&
                ((d_click_timeout == 0) || (tkr.d_timer.elapsed() <= d_click_timeout)) &&
                (tkr.d_click_area.isPointInRect(ma.position)) &&
                (tkr.d_target_window == ma.window))
            {
                ma.handled = 0;
                ma.window.onMouseClicked(ma);
            }
            
            return (ma.handled + upHandled) != 0;
        }
        
        
        /*!
        \brief
        Method that injects a key down event into the system.
        
        \param key_code
        uint value indicating which key was pressed.
        
        \return
        - true if the input was processed by the gui system.
        - false if the input was not processed by the gui system.
        */
        public function injectKeyDown(key_code:uint):Boolean
        {
            // update system keys
            
            d_sysKeys |= keyCodeToSyskey(key_code, true);
            
            trace(" --- in injectKeyDown, key_code from system:" + key_code + ", syskeys:" + d_sysKeys);
            var args:KeyEventArgs = new KeyEventArgs(getKeyboardTargetWindow());
            
            // if there's no destination window, input can't be handled.
            if (!args.window)
                return false;
            
            args.scancode = key_code;
            args.sysKeys = d_sysKeys;
            
            args.window.onKeyDown(args);
            return args.handled != 0;
        }
        
        
        /*!
        \brief
        Method that injects a key up event into the system.
        
        \param key_code
        uint value indicating which key was released.
        
        \return
        - true if the input was processed by the gui system.
        - false if the input was not processed by the gui system.
        */
        public function injectKeyUp(key_code:uint):Boolean
        {
            // update system keys
            d_sysKeys &= ~keyCodeToSyskey(key_code, false);
            
            var args:KeyEventArgs = new KeyEventArgs(getKeyboardTargetWindow());
            
            // if there's no destination window, input can't be handled.
            if (!args.window)
                return false;
            
            args.scancode = key_code;
            args.sysKeys = d_sysKeys;
            
            args.window.onKeyUp(args);
            return args.handled != 0;
        }
        
        
        /*!
        \brief
        Method that injects a typed character event into the system.
        
        \param code_point
        Unicode code point of the character that was typed.
        
        \return
        - true if the input was processed by the gui system.
        - false if the input was not processed by the gui system.
        */
        public function injectChar(code_point:uint):Boolean
        {
            var args:KeyEventArgs = new KeyEventArgs(getKeyboardTargetWindow());
            
            // if there's no destination window, input can't be handled.
            if (!args.window)
                return false;
            
            args.codepoint = code_point;
            args.sysKeys = d_sysKeys;
            
            args.window.onCharacter(args);
            return args.handled != 0;
        }
        
        
        /*!
        \brief
        Method that injects a mouse-wheel / scroll-wheel event into the system.
        
        \param delta
        float value representing the amount the wheel moved.
        
        \return
        - true if the input was processed by the gui system.
        - false if the input was not processed by the gui system.
        */
       public function injectMouseWheelChange(delta:Number):Boolean
       {
           var ma:MouseEventArgs = new MouseEventArgs(null);
           ma.position = FlameMouseCursor.getSingleton().getPosition();
           ma.moveDelta = new Vector2(0.0, 0.0);
           ma.button = Consts.MouseButton_NoButton;
           ma.sysKeys = d_sysKeys;
           ma.wheelChange = delta;
           ma.clickCount = 0;
           ma.window = getTargetWindow(ma.position, false);
           // make mouse position sane for this target window
           if (ma.window)
               ma.position = ma.window.getUnprojectedPosition(ma.position);
           
           // if there is no target window, input can not be handled.
           if (!ma.window)
               return false;
           
           ma.window.onMouseWheel(ma);
           return ma.handled != 0;
       }
        
        
        /*!
        \brief
        Method that injects a new position for the mouse cursor.
        
        \param x_pos
        New absolute pixel position of the mouse cursor on the x axis.
        
        \param y_pos
        New absolute pixel position of the mouse cursor in the y axis.
        
        \return
        - true if the generated mouse move event was handled.
        - false if the generated mouse move event was not handled.
        */
        public function injectMousePosition(x_pos:Number, y_pos:Number):Boolean
        {
            const new_position:Vector2 = new Vector2(x_pos, y_pos);
            var mouse:FlameMouseCursor = FlameMouseCursor.getSingleton();
            
            // setup mouse movement event args object.
            var ma:MouseEventArgs = new MouseEventArgs(null);
            ma.moveDelta = new_position.subtract(mouse.getPosition());
            
            // no movement means no event
            if ((ma.moveDelta.d_x == 0) && (ma.moveDelta.d_y == 0))
                return false;
            
            ma.sysKeys = d_sysKeys;
            ma.wheelChange = 0;
            ma.clickCount = 0;
            ma.button = Consts.MouseButton_NoButton;
            
            // move mouse cursor to new position
            mouse.setPosition(new_position);
            // update position in args (since actual position may be constrained)
            ma.position = mouse.getPosition();
            
            return mouseMoveInjection_impl(ma);
        }
        
        
        /*!
        \brief
        Method to inject time pulses into the system.
        
        \param timeElapsed
        float value indicating the amount of time passed, in seconds, since the last time this method was called.
        
        \return
        Currently, this method always returns true.
        */
        public function injectTimePulse(timeElapsed:Number):Boolean
        {
            FlameAnimationManager.getSingleton().stepInstances(timeElapsed);
            
            // if no visible active sheet, input can't be handled
            if (!d_activeSheet || !d_activeSheet.isVisible())
                return false;
            
            // else pass to sheet for distribution.
            d_activeSheet.update(timeElapsed);
            // this input is then /always/ considered handled.
            return true;
        }
        
        /*!
        \brief
        Function to directly inject a mouse button click event.
        
        Here 'click' means a mouse button down event followed by a mouse
        button up event.
        
        \note
        Under normal, default settings, this event is automatically generated by
        the system from the regular up and down events you inject.  You may use
        this function directly, though you'll probably want to disable the
        automatic click event generation first by using the
        setMouseClickEventGenerationEnabled function - this setting controls the
        auto-generation of events and also determines the default 'handled'
        state of the injected click events according to the rules used for
        mouse up/down events.
        
        \param button
        One of the MouseButton enumerated values.
        
        \return
        - true if some window or handler reported that it handled the event.
        - false if nobody handled the event.
        */
        public function injectMouseButtonClick(button:uint):Boolean
        {
            var ma:MouseEventArgs = new MouseEventArgs(null);
            ma.position = FlameMouseCursor.getSingleton().getPosition();
            ma.window = getTargetWindow(ma.position, false);
            
            if (ma.window)
            {
                // initialise remainder of args struct.
                ma.moveDelta = new Vector2(0.0, 0.0);
                ma.button = button;
                ma.sysKeys = d_sysKeys;
                ma.wheelChange = 0;
                // make mouse position sane for this target window
                ma.position = ma.window.getUnprojectedPosition(ma.position);
                // tell the window about the event.
                ma.window.onMouseClicked(ma);
            }
            
            return ma.handled != 0;
        }
        
        /*!
        \brief
        Function to directly inject a mouse button double-click event.
        
        Here 'double-click' means a single mouse button had the sequence down,
        up, down within a predefined period of time.
        
        \note
        Under normal, default settings, this event is automatically generated by
        the system from the regular up and down events you inject.  You may use
        this function directly, though you'll probably want to disable the
        automatic click event generation first by using the
        setMouseClickEventGenerationEnabled function - this setting controls the
        auto-generation of events and also determines the default 'handled'
        state of the injected click events according to the rules used for
        mouse up/down events.
        
        \param button
        One of the MouseButton enumerated values.
        
        \return
        - true if some window or handler reported that it handled the event.
        - false if nobody handled the event.
        */
        public function injectMouseButtonDoubleClick(button:uint):Boolean
        {
            var ma:MouseEventArgs = new MouseEventArgs(null);
            ma.position = FlameMouseCursor.getSingleton().getPosition();
            ma.window = getTargetWindow(ma.position, false);
            
            if (ma.window && ma.window.wantsMultiClickEvents())
            {
                // initialise remainder of args struct.
                ma.moveDelta = new Vector2(0.0, 0.0);
                ma.button = button;
                ma.sysKeys = d_sysKeys;
                ma.wheelChange = 0;
                // make mouse position sane for this target window
                ma.position = ma.window.getUnprojectedPosition(ma.position);
                // tell the window about the event.
                ma.window.onMouseDoubleClicked(ma);
            }
            
            return ma.handled != 0;
        }
        
        /*!
        \brief
        Function to directly inject a mouse button triple-click event.
        
        Here 'triple-click' means a single mouse button had the sequence down,
        up, down, up, down within a predefined period of time.
        
        \note
        Under normal, default settings, this event is automatically generated by
        the system from the regular up and down events you inject.  You may use
        this function directly, though you'll probably want to disable the
        automatic click event generation first by using the
        setMouseClickEventGenerationEnabled function - this setting controls the
        auto-generation of events and also determines the default 'handled'
        state of the injected click events according to the rules used for
        mouse up/down events.
        
        \param button
        One of the MouseButton enumerated values.
        
        \return
        - true if some window or handler reported that it handled the event.
        - false if nobody handled the event.
        */
        public function injectMouseButtonTripleClick(button:uint):Boolean
        {
            var ma:MouseEventArgs = new MouseEventArgs(null);
            ma.position = FlameMouseCursor.getSingleton().getPosition();
            ma.window = getTargetWindow(ma.position, false);
            
            if (ma.window && ma.window.wantsMultiClickEvents())
            {
                // initialise remainder of args struct.
                ma.moveDelta = new Vector2(0.0, 0.0);
                ma.button = button;
                ma.sysKeys = d_sysKeys;
                ma.wheelChange = 0;
                // make mouse position sane for this target window
                ma.position = ma.window.getUnprojectedPosition(ma.position);
                // tell the window about the event.
                ma.window.onMouseTripleClicked(ma);
            }
            
            return ma.handled != 0;
        }


 
        /*!
        \brief
        Given Point \a pt, return a pointer to the Window that should receive a mouse input if \a pt is the mouse location.
        
        \param pt
        Point object describing a screen location in pixels.
        
        \param allow_disabled
        Specifies whether a disabled window may be returned.
        
        \return
        Pointer to a Window object that should receive mouse input with the system in its current state and the mouse at location \a pt.
        */
        public function getTargetWindow(pt:Vector2, allow_disabled:Boolean):FlameWindow
        {
            // if there is no GUI sheet visible, then there is nowhere to send input
            if (!d_activeSheet || !d_activeSheet.isVisible())
                return null;
            
            var dest_window:FlameWindow = FlameWindow.getCaptureWindow();
            
            if (!dest_window)
            {
                dest_window = d_activeSheet.
                    getTargetChildAtPosition(pt, allow_disabled);
                
                if (!dest_window)
                    dest_window = d_activeSheet;
            }
            else
            {
                if (dest_window.distributesCapturedInputs())
                {
                    var child_window:FlameWindow = dest_window.
                        getTargetChildAtPosition(pt, allow_disabled);
                    
                    if (child_window)
                        dest_window = child_window;
                }
            }
            
            // modal target overrules
            if (d_modalTarget && dest_window != d_modalTarget)
                if (!dest_window.isAncestorForWindow(d_modalTarget))
                    dest_window = d_modalTarget;
            
            return dest_window;
        }
        
        
        /*!
        \brief
        Return a pointer to the Window that should receive keyboard input considering the current modal target.
        
        \return
        Pointer to a Window object that should receive the keyboard input.
        */
        private function getKeyboardTargetWindow():FlameWindow
        {
            // if no active sheet, there is no target widow.
            if (!d_activeSheet || !d_activeSheet.isVisible())
                return null;
            
            // handle normal non-modal situations
            if (!d_modalTarget)
                return d_activeSheet.getActiveChild();
            
            // handle possible modal window.
            var target:FlameWindow = d_modalTarget.getActiveChild();
            return target ? target : d_modalTarget;
        }
        
        
        /*!
        \brief
        Return a pointer to the next window that is to receive the input if the given Window did not use it.
        
        \param w
        Pointer to the Window that just received the input.
        
        \return
        Pointer to the next window to receive the input.
        */
        private function getNextTargetWindow(w:FlameWindow):FlameWindow
        {
            // if we have not reached the modal target, return the parent
            if (w != d_modalTarget)
            {
                return w.getParent();
            }
            
            // otherwise stop now
            return null;
        }
        
        
        /*!
        \brief
        Translate a MouseButton value into the corresponding SystemKey value
        
        \param btn
        MouseButton value describing the value to be converted
        
        \return
        SystemKey value that corresponds to the same button as \a btn
        */
        private function mouseButtonToSyskey(btn:uint):uint
        {
            switch (btn)
            {
                case Consts.MouseButton_LeftButton:
                    return Consts.SystemKey_LeftMouse;
                    
                case Consts.MouseButton_RightButton:
                    return Consts.SystemKey_RightMouse;
                    
                case Consts.MouseButton_MiddleButton:
                    return Consts.SystemKey_MiddleMouse;
                    
                case Consts.MouseButton_X1Button:
                    return Consts.SystemKey_X1Mouse;
                    
                case Consts.MouseButton_X2Button:
                    return Consts.SystemKey_X2Mouse;
                    
                default:
                    throw new Error("System::mouseButtonToSyskey - the parameter 'btn' is not a valid MouseButton value.");
            }
        }
        
        
        /*!
        \brief
        Translate a Key::Scan value into the corresponding SystemKey value.
        
        This takes key direction into account, since we map two keys onto one value.
        
        \param key
        Key::Scan value describing the value to be converted
        
        \param direction
        true if the key is being pressed, false if the key is being released.
        
        \return
        SystemKey value that corresponds to the same key as \a key, or 0 if key was not a system key.
        */
        private function keyCodeToSyskey(key:uint, direction:Boolean):uint
        {
            switch (key)
            {
                case Consts.Key_LeftShift:
                    d_lshift = direction;
                    
                    if (!d_rshift)
                    {
                        return Consts.SystemKey_Shift;
                    }
                    break;
                
                case Consts.Key_RightShift:
                    d_rshift = direction;
                    
                    if (!d_lshift)
                    {
                        return Consts.SystemKey_Shift;
                    }
                    break;
                
                
                case Consts.Key_LeftControl:
                    d_lctrl = direction;
                    
                    if (!d_rctrl)
                    {
                        return Consts.SystemKey_Control;
                    }
                    break;
                
                case Consts.Key_RightControl:
                    d_rctrl = direction;
                    
                    if (!d_lctrl)
                    {
                        return Consts.SystemKey_Control;
                    }
                    break;
                
//                case Consts.Key_LeftAlt:
//                    d_lalt = direction;
//                    
//                    if (!d_ralt)
//                    {
//                        return Consts.SystemKey_Alt;
//                    }
//                    break;
//                
//                case Consts.Key_RightAlt:
//                    d_ralt = direction;
//                    
//                    if (!d_lalt)
//                    {
//                        return Consts.SystemKey_Alt;
//                    }
//                    break;
                
                default:
                    break;
            }
            
            // if not a system key or overall state unchanged, return 0.
            return 0;
        }
        
        
        
        
        
        //! adds factories for all the basic window types
        private function addStandardWindowFactories():void
        {
            // Add factories for types all base elements
           
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameGUISheet));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameDragContainer));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameScrolledContainer));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameClippedContainer));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameCheckbox));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlamePushButton));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameRadioButton));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameCombobox));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameComboDropList));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameEditbox));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameFrameWindow));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameItemEntry));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameListbox));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameListHeader));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameListHeaderSegment));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameMenubar));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlamePopupMenu));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameMenuItem));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameMultiColumnList));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameMultiLineEditbox));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameProgressBar));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameScrollablePane));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameScrollbar));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameSlider));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameSpinner));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameTabButton));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameTabControl));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameThumb));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameTitlebar));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameTooltip));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameItemListbox));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameGroupBox));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameTree));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameHorizontalLayoutContainer));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameVerticalLayoutContainer));
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameGridLayoutContainer));
            

        }
        
        
        //! common function used for injection of mouse positions and movements
        private function mouseMoveInjection_impl(ma:MouseEventArgs):Boolean
        {
            updateWindowContainingMouse();
            
            // input can't be handled if there is no window to handle it.
            if (!d_wndWithMouse)
                return false;
            
            // make mouse position sane for this target window
            ma.position = d_wndWithMouse.getUnprojectedPosition(ma.position);
            
            //trace("mouse position:" + ma.position.toString());
            
            // inform window about the input.
            ma.window = d_wndWithMouse;
            ma.handled = 0;
            ma.window.onMouseMove(ma);
            //trace("window:" + ma.window + " mouse moving");
            
            // return whether window handled the input.
            return ma.handled != 0;
        }
        
        //! Set the CEGUI version string that gets output to the log.
        //void initialiseVersionString();
        
        //! invalidate all windows and any rendering surfaces they may be using.
//        private function invalidateAllWindows():void
//        {
//           FlameWindowManager.getSingleton().invalidateAllWindows();
//        }
        
        //! return common ancestor of two windows.
        private function getCommonAncestor(w1:FlameWindow, w2:FlameWindow):FlameWindow
        {
            if (!w2)
                return w2;
            
            if (w1 == w2)
                return w1;
            
            // make sure w1 is always further up
            if (w1 && w1.isAncestorForWindow(w2))
                return w2;
            
            while (w1)
            {
                if (w2.isAncestorForWindow(w1))
                    break;
                
                w1 = w1.getParent();
            }
            
            return w1;
        }
        
        //! call some function for a chain of windows: (top, bottom]
        private function notifyMouseTransition(top:FlameWindow, bottom:FlameWindow,
                                               func:String, args:MouseEventArgs):void
        {
            if (top == bottom)
                return;
            
            var parent:FlameWindow = bottom.getParent();
            
            if (parent && parent != top)
                notifyMouseTransition(top, parent, func, args);
            
            args.handled = 0;
            args.window = bottom;
            
            bottom[func](args);
        }
        
        
        //! create a window of type d_defaultTooltipType for use as the Tooltip
        private function createSystemOwnedDefaultTooltipWindow():void
        {
            var winmgr:FlameWindowManager = FlameWindowManager.getSingleton();
            
            if (!winmgr.isLocked())
            {
                d_defaultTooltip = 
                    winmgr.createWindow(d_defaultTooltipType,
                        "CEGUI::System::default__auto_tooltip__") as FlameTooltip;
                //d_defaultTooltip->setWritingXMLAllowed(false);
                d_weOwnTooltip = true;
            }
        }
        //! destroy the default tooltip window if the system owns it.
        private function destroySystemOwnedDefaultTooltipWindow():void
        {
            if (d_defaultTooltip && d_weOwnTooltip)
            {
                FlameWindowManager.getSingleton().destroyWindow(d_defaultTooltip);
                d_defaultTooltip = null;
            }
            
            d_weOwnTooltip = false;
        }
        
        
        
        
        
        
        
        
        /*************************************************************************
         Handlers for System events
         *************************************************************************/
        /*!
        \brief
        Handler called when the main system GUI Sheet (or root window) is changed.
        
        \a e is a WindowEventArgs with 'window' set to the old root window.
        */
        private function	onGUISheetChanged(e:WindowEventArgs):void
        {
            fireEvent(EventGUISheetChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the single-click timeout value is changed.
        */
        private function	onSingleClickTimeoutChanged(e:EventArgs):void
        {
            fireEvent(EventSingleClickTimeoutChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the multi-click timeout value is changed.
        */
        private function	onMultiClickTimeoutChanged(e:EventArgs):void
        {
            fireEvent(EventMultiClickTimeoutChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the size of the multi-click tolerance area is changed.
        */
        private function	onMultiClickAreaSizeChanged(e:EventArgs):void
        {
            fireEvent(EventMultiClickAreaSizeChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the default system font is changed.
        */
        private function	onDefaultFontChanged(e:EventArgs):void
        {
//            // here we need to inform every window using the default font that
//            // it's font has been changed.
//            WindowManager::WindowIterator iter =
//                WindowManager::getSingleton().getIterator();
//            
//            // Args structure we will re-use for all windows.
//            WindowEventArgs args(0);
//            
//            while (!iter.isAtEnd())
//            {
//                Window* wnd = iter.getCurrentValue();
//                
//                if (wnd->getFont(false) == 0)
//                {
//                    args.window = wnd;
//                    wnd->onFontChanged(args);
//                    // ensure 'handled' state is reset.
//                    args.handled = 0;
//                }
//                
//                ++iter;
//            }
            
            fireEvent(EventDefaultFontChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the default system mouse cursor image is changed.
        */
        private function	onDefaultMouseCursorChanged(e:EventArgs):void
        {
            fireEvent(EventDefaultMouseCursorChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the mouse movement scaling factor is changed.
        */
        private function	onMouseMoveScalingChanged(e:EventArgs):void
        {
            fireEvent(EventMouseMoveScalingChanged, e, EventNamespace);
        }

        
        
        
        

    }
}