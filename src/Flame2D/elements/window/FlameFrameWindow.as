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
package Flame2D.elements.window
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.ActivationEventArgs;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.system.FlameEventManager;
    import Flame2D.core.system.FlameImageSetManager;
    import Flame2D.core.system.FlameMouseCursor;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.CoordConverter;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.URect;
    import Flame2D.core.utils.UVector2;
    import Flame2D.core.utils.Vector2;
    import Flame2D.elements.button.FlamePushButton;
    import Flame2D.elements.window.FlameTitlebar;
    import Flame2D.elements.window.FrameWindowPropertyCloseButtonEnabled;
    import Flame2D.elements.window.FrameWindowPropertyDragMovingEnabled;
    import Flame2D.elements.window.FrameWindowPropertyEWSizingCursorImage;
    import Flame2D.elements.window.FrameWindowPropertyFrameEnabled;
    import Flame2D.elements.window.FrameWindowPropertyNESWSizingCursorImage;
    import Flame2D.elements.window.FrameWindowPropertyNSSizingCursorImage;
    import Flame2D.elements.window.FrameWindowPropertyNWSESizingCursorImage;
    import Flame2D.elements.window.FrameWindowPropertyRollUpEnabled;
    import Flame2D.elements.window.FrameWindowPropertyRollUpState;
    import Flame2D.elements.window.FrameWindowPropertySizingBorderThickness;
    import Flame2D.elements.window.FrameWindowPropertySizingEnabled;
    import Flame2D.elements.window.FrameWindowPropertyTitlebarEnabled;
    import Flame2D.renderer.FlameRenderer;
    
    /*!
    \brief
    Abstract base class for a movable, sizable, window with a title-bar and a frame.
    */
    public class FlameFrameWindow extends FlameWindow
    {
        public static const EventNamespace:String = "FrameWindow";
        public static const WidgetTypeName:String = "CEGUI/FrameWindow";

        /*************************************************************************
         Constants	
         *************************************************************************/
        // additional event names for this window
        /** Event fired when the rollup (shade) state of the window is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the FrameWindow whose rolled up state
         * has been changed.
         */
        public static const EventRollupToggled:String = "RollupToggled";
        /** Event fired when the close button for the window is clicked.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the FrameWindow whose close button was
         * clicked.
         */
        public static const EventCloseClicked:String = "CloseClicked";
        /** Event fired when drag-sizing of the window starts.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the FrameWindow that has started to be
         * drag sized.
         */
        public static const EventDragSizingStarted:String = "DragSizingStarted";
        /** Event fired when drag-sizing of the window ends.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the FrameWindow for which drag sizing has
         * ended.
         */
        public static const EventDragSizingEnded:String = "DragSizingEnded";
        
        // other bits
        public static const DefaultSizingBorderSize:Number = 8.0;	//!< Default size for the sizing border (in pixels)
        
        /*************************************************************************
         Child Widget name suffix constants
         *************************************************************************/
        public static const TitlebarNameSuffix:String = "__auto_titlebar__";      //!< Widget name suffix for the titlebar component.
        public static const CloseButtonNameSuffix:String = "__auto_closebutton__";   //!< Widget name suffix for the close button component.
        

        
        /*************************************************************************
         Static Properties for this class
         *************************************************************************/
        private static var d_sizingEnabledProperty:FrameWindowPropertySizingEnabled = new FrameWindowPropertySizingEnabled();
        private static var d_frameEnabledProperty:FrameWindowPropertyFrameEnabled = new FrameWindowPropertyFrameEnabled();
        private static var d_titlebarEnabledProperty:FrameWindowPropertyTitlebarEnabled = new FrameWindowPropertyTitlebarEnabled();
        private static var d_closeButtonEnabledProperty:FrameWindowPropertyCloseButtonEnabled = new FrameWindowPropertyCloseButtonEnabled();
        private static var d_rollUpStateProperty:FrameWindowPropertyRollUpEnabled = new FrameWindowPropertyRollUpEnabled();
        private static var d_rollUpEnabledProperty:FrameWindowPropertyRollUpState = new FrameWindowPropertyRollUpState();
        private static var d_dragMovingEnabledProperty:FrameWindowPropertyDragMovingEnabled = new FrameWindowPropertyDragMovingEnabled();
        private static var d_sizingBorderThicknessProperty:FrameWindowPropertySizingBorderThickness = new FrameWindowPropertySizingBorderThickness();
        private static var d_nsSizingCursorProperty:FrameWindowPropertyNSSizingCursorImage = new FrameWindowPropertyNSSizingCursorImage();
        private static var d_ewSizingCursorProperty:FrameWindowPropertyEWSizingCursorImage = new FrameWindowPropertyEWSizingCursorImage();
        private static var d_nwseSizingCursorProperty:FrameWindowPropertyNWSESizingCursorImage = new FrameWindowPropertyNWSESizingCursorImage();
        private static var d_neswSizingCursorProperty:FrameWindowPropertyNESWSizingCursorImage = new FrameWindowPropertyNESWSizingCursorImage();
        
        /*************************************************************************
         Implementation Data
         *************************************************************************/
        // frame data
        protected var d_frameEnabled:Boolean = true;		//!< true if window frame should be drawn.
        
        // window roll-up data
        protected var d_rollupEnabled:Boolean = true;	//!< true if roll-up of window is allowed.
        protected var d_rolledup:Boolean = false;			//!< true if window is rolled up.
        
        // drag-sizing data
        protected var d_sizingEnabled:Boolean = true;	//!< true if sizing is enabled for this window.
        protected var d_beingSized:Boolean = false;		//!< true if window is being sized.
        protected var d_borderSize:Number = DefaultSizingBorderSize;		//!< thickness of the sizing border around this window
        protected var d_dragPoint:Vector2 = new Vector2();		//!< point window is being dragged at.
        
        // images for cursor when on sizing border
        protected var d_nsSizingCursor:FlameImage = null;		//!< North/South sizing cursor image.
        protected var d_ewSizingCursor:FlameImage = null;		//!< East/West sizing cursor image.
        protected var d_nwseSizingCursor:FlameImage = null;		//!< North-West/South-East cursor image.
        protected var d_neswSizingCursor:FlameImage = null;		//!< North-East/South-West cursor image.
        
        protected var d_dragMovable:Boolean = true;		//!< true if the window will move when dragged by the title bar.

        
        
        
        public function FlameFrameWindow(type:String,  name:String)
        {
            super(type, name);
            
            addFrameWindowProperties();
        }
        
        
        
        /*!
        \brief
        Initialises the Window based object ready for use.
        
        \note
        This must be called for every window created.  Normally this is handled automatically by the WindowFactory for each Window type.
        
        \return
        Nothing
        */
        override public function initialiseComponents():void
        {
            // get component windows
            var titlebar:FlameTitlebar = getTitlebar();
            var closeButton:FlamePushButton = getCloseButton();
            
            // configure titlebar
            titlebar.setDraggingEnabled(d_dragMovable);
            titlebar.setText(getText());
            
            // bind handler to close button 'Click' event
            closeButton.subscribeEvent(FlamePushButton.EventClicked, new Subscriber(closeClickHandler, this), FlamePushButton.EventNamespace);
            
            performChildWindowLayout();
        }
        
        
        /*!
        \brief
        Return whether this window is sizable.  Note that this requires that the window have an enabled frame and that sizing itself is enabled
        
        \return
        true if the window can be sized, false if the window can not be sized
        */
        public function isSizingEnabled():Boolean
        {
            return d_sizingEnabled && isFrameEnabled();
        }
        
        
        /*!
        \brief
        Return whether the frame for this window is enabled.
        
        \return
        true if the frame for this window is enabled, false if the frame for this window is disabled.
        */
        public function isFrameEnabled():Boolean
        {
            return d_frameEnabled;
        }
        
        
        /*!
        \brief
        Return whether the title bar for this window is enabled.
        
        \return
        true if the window has a title bar and it is enabled, false if the window has no title bar or if the title bar is disabled.
        */	
        public function isTitleBarEnabled():Boolean
        {
            return ! getTitlebar().isDisabled(true);
        }
        
        
        /*!
        \brief
        Return whether this close button for this window is enabled.
        
        \return
        true if the window has a close button and it is enabled, false if the window either has no close button or if the close button is disabled.
        */
        public function isCloseButtonEnabled():Boolean
        {
            return ! getCloseButton().isDisabled(true);
        }
        
        /*!
        \brief
        Return whether roll up (a.k.a shading) is enabled for this window.
        
        \return
        true if roll up is enabled, false if roll up is disabled.
        */
        public function isRollupEnabled():Boolean
        {
            return d_rollupEnabled;
        }
        
        
        /*!
        \brief
        Return whether the window is currently rolled up (a.k.a shaded).
        
        \return
        true if the window is rolled up, false if the window is not rolled up.
        */
        public function isRolledup():Boolean
        {
            return d_rolledup;
        }
        
        
        /*!
        \brief
        Return the thickness of the sizing border.
        
        \return
        float value describing the thickness of the sizing border in screen pixels.
        */
        public function getSizingBorderThickness():Number
        {
            return d_borderSize;
        }
        
        
        /*!
        \brief
        Enables or disables sizing for this window.
        
        \param setting
        set to true to enable sizing (also requires frame to be enabled), or false to disable sizing.
        
        \return
        nothing
        */
        public function setSizingEnabled(setting:Boolean):void
        {
            d_sizingEnabled = setting;
        }
        
        
        /*!
        \brief
        Enables or disables the frame for this window.
        
        \param setting
        set to true to enable the frame for this window, or false to disable the frame for this window.
        
        \return
        Nothing.
        */
        public function setFrameEnabled(setting:Boolean):void
        {
            d_frameEnabled = setting;
            invalidate();
        }
        
        
        /*!
        \brief
        Enables or disables the title bar for the frame window.
        
        \param setting
        set to true to enable the title bar (if one is attached), or false to disable the title bar.
        
        \return
        Nothing.
        */
        public function setTitleBarEnabled(setting:Boolean):void
        {
            var titlebar:FlameWindow = getTitlebar();
            titlebar.setEnabled(setting);
            titlebar.setVisible(setting);
        }
        
        
        /*!
        \brief
        Enables or disables the close button for the frame window.
        
        \param setting
        Set to true to enable the close button (if one is attached), or false to disable the close button.
        
        \return
        Nothing.
        */
        public function setCloseButtonEnabled(setting:Boolean):void
        {
            var closebtn:FlameWindow = getCloseButton();
            closebtn.setEnabled(setting);
            closebtn.setVisible(setting);
        }
        
        
        /*!
        \brief
        Enables or disables roll-up (shading) for this window.
        
        \param setting
        Set to true to enable roll-up for the frame window, or false to disable roll-up.
        
        \return
        Nothing.
        */
        public function setRollupEnabled(setting:Boolean):void
        {
            if ((setting == false) && isRolledup())
            {
                toggleRollup();
            }
            
            d_rollupEnabled = setting;
        }
        
        
        /*!
        \brief
        Toggles the state of the window between rolled-up (shaded) and normal sizes.  This requires roll-up to be enabled.
        
        \return
        Nothing
        */
        public function toggleRollup():void
        {
            if (isRollupEnabled())
            {
                d_rolledup = !d_rolledup;
                
                // event notification.
                var args:WindowEventArgs = new WindowEventArgs(this);
                onRollupToggled(args);
                
                FlameSystem.getSingleton().updateWindowContainingMouse();
            }
        }
        
        
        /*!
        \brief
        Set the size of the sizing border for this window.
        
        \param pixels
        float value specifying the thickness for the sizing border in screen pixels.
        
        \return
        Nothing.
        */
        public function setSizingBorderThickness(pixels:Number):void
        {
            d_borderSize = pixels;
        }
        
        
        /*!
        \brief
        Move the window by the pixel offsets specified in \a offset.
        
        This is intended for internal system use - it is the method by which the title bar moves the frame window.
        
        \param offset
        Vector2 object containing the offsets to apply (offsets are in screen pixels).
        
        \return
        Nothing.
        */
        public function offsetPixelPosition(offset:Vector2):void
        {
            var uOffset:UVector2 = new UVector2(
                Misc.cegui_absdim(Misc.PixelAligned(offset.d_x)),
                Misc.cegui_absdim(Misc.PixelAligned(offset.d_y)));
            
            setPosition(d_area.getPosition().add(uOffset));
        }
        
        
        /*!
        \brief
        Return whether this FrameWindow can be moved by dragging the title bar.
        
        \return
        true if the Window will move when the user drags the title bar, false if the window will not move.
        */
        public function isDragMovingEnabled():Boolean
        {
            return d_dragMovable;
        }
        
        
        /*!
        \brief
        Set whether this FrameWindow can be moved by dragging the title bar.
        
        \param setting
        true if the Window should move when the user drags the title bar, false if the window should not move.
        
        \return
        Nothing.
        */
        public function setDragMovingEnabled(setting:Boolean):void
        {
            if (d_dragMovable != setting)
            {
                d_dragMovable = setting;
                
                getTitlebar().setDraggingEnabled(setting);
            }
        }
        
        
        /*!
        \brief
        Return a pointer to the currently set Image to be used for the north-south
        sizing mouse cursor.
        
        \return
        Pointer to an Image object, or 0 for none.
        */
        public function getNSSizingCursorImage():FlameImage
        {
            return d_nsSizingCursor;
        }
        
        /*!
        \brief
        Return a pointer to the currently set Image to be used for the east-west
        sizing mouse cursor.
        
        \return
        Pointer to an Image object, or 0 for none.
        */
        public function getEWSizingCursorImage():FlameImage
        {
            return d_ewSizingCursor;
        }
        
        /*!
        \brief
        Return a pointer to the currently set Image to be used for the northwest-southeast
        sizing mouse cursor.
        
        \return
        Pointer to an Image object, or 0 for none.
        */
        public function getNWSESizingCursorImage():FlameImage
        {
            return d_nwseSizingCursor;
        }
        
        /*!
        \brief
        Return a pointer to the currently set Image to be used for the northeast-southwest
        sizing mouse cursor.
        
        \return
        Pointer to an Image object, or 0 for none.
        */
        public function getNESWSizingCursorImage():FlameImage
        {
            return d_neswSizingCursor;
        }
        
        /*!
        \brief
        Set the Image to be used for the north-south sizing mouse cursor.
        
        \param image
        Pointer to an Image object, or 0 for none.
        
        \return
        Nothing.
        */
        public function setNSSizingCursorImage(image:FlameImage):void
        {
            d_nsSizingCursor = image;
        }
        
        /*!
        \brief
        Set the Image to be used for the east-west sizing mouse cursor.
        
        \param image
        Pointer to an Image object, or 0 for none.
        
        \return
        Nothing.
        */
        public function setEWSizingCursorImage(image:FlameImage):void
        {
            d_ewSizingCursor = image;
        }
        
        /*!
        \brief
        Set the Image to be used for the northwest-southeast sizing mouse cursor.
        
        \param image
        Pointer to an Image object, or 0 for none.
        
        \return
        Nothing.
        */
        public function setNWSESizingCursorImage(image:FlameImage):void
        {
            d_nwseSizingCursor = image;
        }
        
        /*!
        \brief
        Set the Image to be used for the northeast-southwest sizing mouse cursor.
        
        \param image
        Pointer to an Image object, or 0 for none.
        
        \return
        Nothing.
        */
        public function setNESWSizingCursorImage(image:FlameImage):void
        {
            d_neswSizingCursor = image;
        }
        
        /*!
        \brief
        Set the image to be used for the north-south sizing mouse cursor.
        
        \param imageset
        String holding the name of the Imageset containing the Image to be used.
        
        \param image
        String holding the name of the Image to be used.
        
        \return
        Nothing.
        
        \exception UnknownObjectException thrown if either \a imageset or \a image refer to non-existant entities.
        */
        public function setNSSizingCursorImageFromImageSet(imageset:String, image:String):void
        {
            d_nsSizingCursor = FlameImageSetManager.getSingleton().getImageSet(imageset).getImage(image);
        }
        
        /*!
        \brief
        Set the image to be used for the east-west sizing mouse cursor.
        
        \param imageset
        String holding the name of the Imageset containing the Image to be used.
        
        \param image
        String holding the name of the Image to be used.
        
        \return
        Nothing.
        
        \exception UnknownObjectException thrown if either \a imageset or \a image refer to non-existant entities.
        */
        public function setEWSizingCursorImageFromImageSet(imageset:String, image:String):void
        {
            d_ewSizingCursor = FlameImageSetManager.getSingleton().getImageSet(imageset).getImage(image);
        }
        
        /*!
        \brief
        Set the image to be used for the northwest-southeast sizing mouse cursor.
        
        \param imageset
        String holding the name of the Imageset containing the Image to be used.
        
        \param image
        String holding the name of the Image to be used.
        
        \return
        Nothing.
        
        \exception UnknownObjectException thrown if either \a imageset or \a image refer to non-existant entities.
        */
        public function setNWSESizingCursorImageFromImageSet(imageset:String, image:String):void
        {
            d_nwseSizingCursor = FlameImageSetManager.getSingleton().getImageSet(imageset).getImage(image);
        }
        
        /*!
        \brief
        Set the image to be used for the northeast-southwest sizing mouse cursor.
        
        \param imageset
        String holding the name of the Imageset containing the Image to be used.
        
        \param image
        String holding the name of the Image to be used.
        
        \return
        Nothing.
        
        \exception UnknownObjectException thrown if either \a imageset or \a image refer to non-existant entities.
        */
        public function setNESWSizingCursorImageFromImageSet(imageset:String, image:String):void
        {
            
        }
        
        // overridden from Window class
        override protected function isHit(position:Vector2, allow_disabled:Boolean=false):Boolean
        { 
            return super.isHit(position) && !allow_disabled;
        }
        
        /*!
        \brief
        Return a pointer to the Titlebar component widget for this FrameWindow.
        
        \return
        Pointer to a Titlebar object.
        
        \exception UnknownObjectException
        Thrown if the Titlebar component does not exist.
        */
        public function getTitlebar():FlameTitlebar
        {
            return FlameWindowManager.getSingleton().getWindow(
                getName() + TitlebarNameSuffix) as FlameTitlebar;
        }
        
        /*!
        \brief
        Return a pointer to the close button component widget for this
        FrameWindow.
        
        \return
        Pointer to a PushButton object.
        
        \exception UnknownObjectException
        Thrown if the close button component does not exist.
        */
        public function getCloseButton():FlamePushButton
        {
            return FlameWindowManager.getSingleton().getWindow(
                getName() + CloseButtonNameSuffix) as FlamePushButton;
        }
        

        
        
        /*************************************************************************
         Implementation Functions
         *************************************************************************/
        /*!
        \brief
        move the window's left edge by 'delta'.  The rest of the window does not move, thus this changes the size of the Window.
        
        \param delta
        float value that specifies the amount to move the window edge, and in which direction.  Positive values make window smaller.
        */
        protected function moveLeftEdge(delta:Number, out_area:URect):Boolean
        {
            var orgWidth:Number = d_pixelSize.d_width;
            
            // ensure that we only size to the set constraints.
            //
            // NB: We are required to do this here due to our virtually unique sizing nature; the
            // normal system for limiting the window size is unable to supply the information we
            // require for updating our internal state used to manage the dragging, etc.
            var maxWidth:Number = (d_maxSize.d_x.asAbsolute(FlameSystem.getSingleton().getRenderer().getDisplaySize().d_width));
            var minWidth:Number = (d_minSize.d_x.asAbsolute(FlameSystem.getSingleton().getRenderer().getDisplaySize().d_width));
            var newWidth:Number = orgWidth - delta;
            
            if (newWidth > maxWidth)
                delta = orgWidth - maxWidth;
            else if (newWidth < minWidth)
                delta = orgWidth - minWidth;
            
            // ensure adjustment will be whole pixel
            var adjustment:Number = Misc.PixelAligned(delta);
            
            if (d_horzAlign == Consts.HorizontalAlignment_HA_RIGHT)
            {
                out_area.d_max.d_x.d_offset -= adjustment;
            }
            else if (d_horzAlign == Consts.HorizontalAlignment_HA_CENTRE)
            {
                out_area.d_max.d_x.d_offset -= adjustment * 0.5;
                out_area.d_min.d_x.d_offset += adjustment * 0.5;
            }
            else
            {
                out_area.d_min.d_x.d_offset += adjustment;
            }
            
            return d_horzAlign == Consts.HorizontalAlignment_HA_LEFT;
        }
        
        
        /*!
        \brief
        move the window's right edge by 'delta'.  The rest of the window does not move, thus this changes the size of the Window.
        
        \param delta
        float value that specifies the amount to move the window edge, and in which direction.  Positive values make window larger.
        */
        protected function moveRightEdge(delta:Number, out_area:URect):Boolean
        {
            // store this so we can work out how much size actually changed
            var orgWidth:Number = d_pixelSize.d_width;
            
            // ensure that we only size to the set constraints.
            //
            // NB: We are required to do this here due to our virtually unique sizing nature; the
            // normal system for limiting the window size is unable to supply the information we
            // require for updating our internal state used to manage the dragging, etc.
            var maxWidth:Number = (d_maxSize.d_x.asAbsolute(FlameSystem.getSingleton().getRenderer().getDisplaySize().d_width));
            var minWidth:Number = (d_minSize.d_x.asAbsolute(FlameSystem.getSingleton().getRenderer().getDisplaySize().d_width));
            var newWidth:Number = orgWidth + delta;
            
            if (newWidth > maxWidth)
                delta = maxWidth - orgWidth;
            else if (newWidth < minWidth)
                delta = minWidth - orgWidth;
            
            // ensure adjustment will be whole pixel
            var adjustment:Number = Misc.PixelAligned(delta);
            
            out_area.d_max.d_x.d_offset += adjustment;
            
            if (d_horzAlign == Consts.HorizontalAlignment_HA_RIGHT)
            {
                out_area.d_max.d_x.d_offset += adjustment;
                out_area.d_min.d_x.d_offset += adjustment;
            }
            else if (d_horzAlign == Consts.HorizontalAlignment_HA_CENTRE)
            {
                out_area.d_max.d_x.d_offset += adjustment * 0.5;
                out_area.d_min.d_x.d_offset += adjustment * 0.5;
            }
            
            // move the dragging point so mouse remains 'attached' to edge of window
            d_dragPoint.d_x += adjustment;
            
            return d_horzAlign == Consts.HorizontalAlignment_HA_RIGHT;
        }
        
        
        /*!
        \brief
        move the window's top edge by 'delta'.  The rest of the window does not move, thus this changes the size of the Window.
        
        \param delta
        float value that specifies the amount to move the window edge, and in which direction.  Positive values make window smaller.
        */
        protected function moveTopEdge(delta:Number, out_area:URect):Boolean
        {
            var orgHeight:Number = d_pixelSize.d_height;
            
            // ensure that we only size to the set constraints.
            //
            // NB: We are required to do this here due to our virtually unique sizing nature; the
            // normal system for limiting the window size is unable to supply the information we
            // require for updating our internal state used to manage the dragging, etc.
            var maxHeight:Number = (d_maxSize.d_y.asAbsolute(FlameSystem.getSingleton().getRenderer().getDisplaySize().d_height));
            var minHeight:Number = (d_minSize.d_y.asAbsolute(FlameSystem.getSingleton().getRenderer().getDisplaySize().d_height));
            var newHeight:Number = orgHeight - delta;
            
            if (newHeight > maxHeight)
                delta = orgHeight - maxHeight;
            else if (newHeight < minHeight)
                delta = orgHeight - minHeight;
            
            // ensure adjustment will be whole pixel
            var adjustment:Number = Misc.PixelAligned(delta);
            
            if (d_vertAlign == Consts.VerticalAlignment_VA_BOTTOM)
            {
                out_area.d_max.d_y.d_offset -= adjustment;
            }
            else if (d_vertAlign == Consts.VerticalAlignment_VA_CENTRE)
            {
                out_area.d_max.d_y.d_offset -= adjustment * 0.5;
                out_area.d_min.d_y.d_offset += adjustment * 0.5;
            }
            else
            {
                out_area.d_min.d_y.d_offset += adjustment;
            }
            
            return d_vertAlign == Consts.VerticalAlignment_VA_TOP;
        }
        
        
        /*!
        \brief
        move the window's bottom edge by 'delta'.  The rest of the window does not move, thus this changes the size of the Window.
        
        \param delta
        float value that specifies the amount to move the window edge, and in which direction.  Positive values make window larger.
        */
        protected function moveBottomEdge(delta:Number, out_area:URect):Boolean
        {
            // store this so we can work out how much size actually changed
            var orgHeight:Number = d_pixelSize.d_height;
            
            // ensure that we only size to the set constraints.
            //
            // NB: We are required to do this here due to our virtually unique sizing nature; the
            // normal system for limiting the window size is unable to supply the information we
            // require for updating our internal state used to manage the dragging, etc.
            var maxHeight:Number = (d_maxSize.d_y.asAbsolute(FlameSystem.getSingleton().getRenderer().getDisplaySize().d_height));
            var minHeight:Number = (d_minSize.d_y.asAbsolute(FlameSystem.getSingleton().getRenderer().getDisplaySize().d_height));
            var newHeight:Number = orgHeight + delta;
            
            if (newHeight > maxHeight)
                delta = maxHeight - orgHeight;
            else if (newHeight < minHeight)
                delta = minHeight - orgHeight;
            
            // ensure adjustment will be whole pixel
            var adjustment:Number = Misc.PixelAligned(delta);
            
            out_area.d_max.d_y.d_offset += adjustment;
            
            if (d_vertAlign == Consts.VerticalAlignment_VA_BOTTOM)
            {
                out_area.d_max.d_y.d_offset += adjustment;
                out_area.d_min.d_y.d_offset += adjustment;
            }
            else if (d_vertAlign == Consts.VerticalAlignment_VA_CENTRE)
            {
                out_area.d_max.d_y.d_offset += adjustment * 0.5;
                out_area.d_min.d_y.d_offset += adjustment * 0.5;
            }
            
            // move the dragging point so mouse remains 'attached' to edge of window
            d_dragPoint.d_y += adjustment;
            
            return d_vertAlign == Consts.VerticalAlignment_VA_BOTTOM;
        }
        
        
        /*!
        \brief
        check local pixel co-ordinate point 'pt' and return one of the
        SizingLocation enumerated values depending where the point falls on
        the sizing border.
        
        \param pt
        Point object describing, in pixels, the window relative offset to check.
        
        \return
        One of the SizingLocation enumerated values that describe which part of
        the sizing border that \a pt corresponded to, if any.
        */
        protected function getSizingBorderAtPoint(pt:Vector2):uint
        {
            var frame:Rect = getSizingRect();
            
            // we can only size if the frame is enabled and sizing is on
            if (isSizingEnabled() && isFrameEnabled())
            {
                // point must be inside the outer edge
                if (frame.isPointInRect(pt))
                {
                    // adjust rect to get inner edge
                    frame.d_left	+= d_borderSize;
                    frame.d_top		+= d_borderSize;
                    frame.d_right	-= d_borderSize;
                    frame.d_bottom	-= d_borderSize;
                    
                    // detect which edges we are on
                    var top:Boolean	= (pt.d_y < frame.d_top);
                    var bottom:Boolean = (pt.d_y >= frame.d_bottom);
                    var left:Boolean	= (pt.d_x < frame.d_left);
                    var right:Boolean	= (pt.d_x >= frame.d_right);
                    
                    // return appropriate 'SizingLocation' value
                    if (top && left)
                    {
                        return Consts.SizingLocation_SizingTopLeft;
                    }
                    else if (top && right)
                    {
                        return Consts.SizingLocation_SizingTopRight;
                    }
                    else if (bottom && left)
                    {
                        return Consts.SizingLocation_SizingBottomLeft;
                    }
                    else if (bottom && right)
                    {
                        return Consts.SizingLocation_SizingBottomRight;
                    }
                    else if (top)
                    {
                        return Consts.SizingLocation_SizingTop;
                    }
                    else if (bottom)
                    {
                        return Consts.SizingLocation_SizingBottom;
                    }
                    else if (left)
                    {
                        return Consts.SizingLocation_SizingLeft;
                    }
                    else if (right)
                    {
                        return Consts.SizingLocation_SizingRight;
                    }
                    
                }
                
            }
            
            // deafult: None.
            return Consts.SizingLocation_SizingNone;
        }
        
        
        /*!
        \brief
        return true if given SizingLocation is on left edge.
        
        \param loc
        SizingLocation value to be checked.
        
        \return
        true if \a loc is on the left edge.  false if \a loc is not on the left edge.
        */
        protected function isLeftSizingLocation(loc:uint):Boolean
        {
            return ((loc == Consts.SizingLocation_SizingLeft) || 
                (loc == Consts.SizingLocation_SizingTopLeft) || 
                (loc == Consts.SizingLocation_SizingBottomLeft));
        }
        
        
        /*!
        \brief
        return true if given SizingLocation is on right edge.
        
        \param loc
        SizingLocation value to be checked.
        
        \return
        true if \a loc is on the right edge.  false if \a loc is not on the right edge.
        */
        protected function isRightSizingLocation(loc:uint):Boolean
        {
            return ((loc == Consts.SizingLocation_SizingRight) || 
                (loc == Consts.SizingLocation_SizingTopRight) || 
                (loc == Consts.SizingLocation_SizingBottomRight));
        }
        
        
        /*!
        \brief
        return true if given SizingLocation is on top edge.
        
        \param loc
        SizingLocation value to be checked.
        
        \return
        true if \a loc is on the top edge.  false if \a loc is not on the top edge.
        */
        protected function isTopSizingLocation(loc:uint):Boolean
        {
            return ((loc == Consts.SizingLocation_SizingTop) || 
                (loc == Consts.SizingLocation_SizingTopLeft) || 
                (loc == Consts.SizingLocation_SizingTopRight));
        }
        
        
        /*!
        \brief
        return true if given SizingLocation is on bottom edge.
        
        \param loc
        SizingLocation value to be checked.
        
        \return
        true if \a loc is on the bottom edge.  false if \a loc is not on the bottom edge.
        */
        protected function isBottomSizingLocation(loc:uint):Boolean
        {
            return ((loc == Consts.SizingLocation_SizingBottom) || 
                (loc == Consts.SizingLocation_SizingBottomLeft) || 
                (loc == Consts.SizingLocation_SizingBottomRight));
        }
        
        
        /*!
        \brief
        Method to respond to close button click events and fire our close event
        */
        protected function closeClickHandler(e:EventArgs):Boolean
        {
            var args:WindowEventArgs = new WindowEventArgs(this);
            onCloseClicked(args);
            
            return true;
        }
        
        
        /*!
        \brief
        Set the appropriate mouse cursor for the given window-relative pixel point.
        */
        protected function setCursorForPoint(pt:Vector2):void
        {
            switch(getSizingBorderAtPoint(pt))
            {
                case Consts.SizingLocation_SizingTop:
                case Consts.SizingLocation_SizingBottom:
                    FlameMouseCursor.getSingleton().setImage(d_nsSizingCursor);
                    break;
                
                case Consts.SizingLocation_SizingLeft:
                case Consts.SizingLocation_SizingRight:
                    FlameMouseCursor.getSingleton().setImage(d_ewSizingCursor);
                    break;
                
                case Consts.SizingLocation_SizingTopLeft:
                case Consts.SizingLocation_SizingBottomRight:
                    FlameMouseCursor.getSingleton().setImage(d_nwseSizingCursor);
                    break;
                
                case Consts.SizingLocation_SizingTopRight:
                case Consts.SizingLocation_SizingBottomLeft:
                    FlameMouseCursor.getSingleton().setImage(d_neswSizingCursor);
                    break;
                
                default:
                    FlameMouseCursor.getSingleton().setImage(getMouseCursor());
                    break;
            }
        }
        
        
        /*!
        \brief
        Return a Rect that describes, in window relative pixel co-ordinates, the outer edge of the sizing area for this window.
        */
        protected function getSizingRect():Rect
        {
            return new Rect(0, 0, d_pixelSize.d_width, d_pixelSize.d_height);
        }
        
        
        /*!
        \brief
        Return whether this window was inherited from the given class name at some point in the inheritance hierarchy.
        
        \param class_name
        The class name that is to be checked.
        
        \return
        true if this window was inherited from \a class_name. false if not.
        */
        override protected function testClassName_impl(class_name:String):Boolean
        {
            if (class_name=="FrameWindow")	return true;
            return super.testClassName_impl(class_name);
        }
        
        
        /*************************************************************************
         New events for Frame Windows
         *************************************************************************/
        /*!
        \brief
        Event generated internally whenever the roll-up / shade state of the window
        changes.
        */
        protected function onRollupToggled(e:WindowEventArgs):void
        {
            invalidateRecursive(true);
            notifyClippingChanged();
            var size_args:WindowEventArgs = e.clone();
            onSized(size_args);
            
            fireEvent(EventRollupToggled, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Event generated internally whenever the close button is clicked.
        */
        protected function onCloseClicked(e:WindowEventArgs):void
        {
            fireEvent(EventCloseClicked, e, EventNamespace);
        }
        
        //! Handler called when drag-sizing of the FrameWindow starts.
        protected function onDragSizingStarted(e:WindowEventArgs):void
        {
            fireEvent(EventDragSizingStarted, e, EventNamespace);
        }
        
        //! Handler called when drag-sizing of the FrameWindow ends.
        protected function onDragSizingEnded(e:WindowEventArgs):void
        {
            fireEvent(EventDragSizingEnded, e, EventNamespace);
        }
        
        /*************************************************************************
         Overridden event handlers
         *************************************************************************/
        override public function onMouseMove(e:MouseEventArgs):void
        {
            // default processing (this is now essential as it controls event firing).
            super.onMouseMove(e);
            
            // if we are not the window containing the mouse, do NOT change the cursor
            if (FlameSystem.getSingleton().getWindowContainingMouse() != this)
            {
                return;
            }
            
            if (isSizingEnabled())
            {
                var localMousePos:Vector2 = CoordConverter.screenToWindowForVector2(this, e.position);
                setCursorForPoint(localMousePos);

                if (d_beingSized)
                {
                    var dragEdge:uint = getSizingBorderAtPoint(d_dragPoint);
                    
                    // calculate sizing deltas...
                    var	deltaX:Number = localMousePos.d_x - d_dragPoint.d_x;
                    var	deltaY:Number = localMousePos.d_y - d_dragPoint.d_y;
                    
                    var new_area:URect = d_area;
                    var top_left_sizing:uint = 0;
                    // size left or right edges
                    if (isLeftSizingLocation(dragEdge))
                    {
                        top_left_sizing |= moveLeftEdge(deltaX, new_area) as uint;
                    }
                    else if (isRightSizingLocation(dragEdge))
                    {
                        top_left_sizing |= moveRightEdge(deltaX, new_area) as uint;
                    }
                    
                    // size top or bottom edges
                    if (isTopSizingLocation(dragEdge))
                    {
                        top_left_sizing |= moveTopEdge(deltaY, new_area) as uint;
                    }
                    else if (isBottomSizingLocation(dragEdge))
                    {
                        top_left_sizing |= moveBottomEdge(deltaY, new_area) as uint;
                    }
                    
                    setArea_impl(new_area.d_min, new_area.getSize(), top_left_sizing as Boolean);
                }
                else
                {
                    setCursorForPoint(localMousePos);
                }
                
            }
            
            // mark event as handled
            ++e.handled;
        }
        
        
        override public function onMouseButtonDown(e:MouseEventArgs):void
        {
            // default processing (this is now essential as it controls event firing).
            super.onMouseButtonDown(e);
            
            if (e.button == Consts.MouseButton_LeftButton)
            {
                if (isSizingEnabled())
                {
                    // get position of mouse as co-ordinates local to this window.
                    var localPos:Vector2 = CoordConverter.screenToWindowForVector2(this, e.position);
                    
                    // if the mouse is on the sizing border
                    if (getSizingBorderAtPoint(localPos) != Consts.SizingLocation_SizingNone)
                    {
                        // ensure all inputs come to us for now
                        if (captureInput())
                        {
                            // setup the 'dragging' state variables
                            d_beingSized = true;
                            d_dragPoint = localPos;
                            
                            // do drag-sizing started notification
                            var args:WindowEventArgs = new WindowEventArgs(this);
                            onDragSizingStarted(args);
                            
                            ++e.handled;
                        }
                        
                    }
                    
                }
                
            }
        }
        
        override public function onMouseButtonUp(e:MouseEventArgs):void
        {
            // default processing (this is now essential as it controls event firing).
            super.onMouseButtonUp(e);
            
            if (e.button == Consts.MouseButton_LeftButton && isCapturedByThis())
            {
                // release our capture on the input data
                releaseInput();
                ++e.handled;
            }
        }
        
        override protected function onCaptureLost(e:WindowEventArgs):void
        {
            // default processing (this is now essential as it controls event firing).
            super.onCaptureLost(e);
            
            // reset sizing state
            d_beingSized = false;
            
            // do drag-sizing ended notification
            var args:WindowEventArgs = new WindowEventArgs(this);
            onDragSizingEnded(args);
            
            ++e.handled;
        }
        
        override protected function onTextChanged(e:WindowEventArgs):void
        {
            super.onTextChanged(e);
            // pass this onto titlebar component.
            getTitlebar().setText(getText());
            // maybe the user is using a fontdim for titlebar dimensions ;)
            performChildWindowLayout();
        }
        
        override protected function onActivated(e:ActivationEventArgs):void
        {
            super.onActivated(e);
            getTitlebar().invalidate();
        }
        
        override protected function onDeactivated(e:ActivationEventArgs):void
        {
            super.onDeactivated(e);
            getTitlebar().invalidate();
        }
        
        
        /*************************************************************************
         Private methods
         *************************************************************************/
        private function addFrameWindowProperties():void
        {
            addProperty(d_sizingEnabledProperty);
            addProperty(d_frameEnabledProperty);
            addProperty(d_titlebarEnabledProperty);
            addProperty(d_closeButtonEnabledProperty);
            addProperty(d_rollUpEnabledProperty);
            addProperty(d_rollUpStateProperty);
            addProperty(d_dragMovingEnabledProperty);
            addProperty(d_sizingBorderThicknessProperty);
            addProperty(d_nsSizingCursorProperty);
            addProperty(d_ewSizingCursorProperty);
            addProperty(d_nwseSizingCursorProperty);
            addProperty(d_neswSizingCursorProperty);
        }
    }
}