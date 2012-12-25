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
package Flame2D.elements.dnd
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.data.RenderingContext;
    import Flame2D.core.events.DragDropEventArgs;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.system.FlameEventManager;
    import Flame2D.core.system.FlameImageSetManager;
    import Flame2D.core.system.FlameMouseCursor;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.utils.CoordConverter;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.UDim;
    import Flame2D.core.utils.UVector2;
    import Flame2D.core.utils.Vector2;

    /*!
    \brief
    Generic drag & drop enabled window class
    */
    public class FlameDragContainer extends FlameWindow
    {
        public static const EventNamespace:String = "DragContainer";
        public static const WidgetTypeName:String = "DragContainer";
        
        /*************************************************************************
         Constants
         *************************************************************************/
        /** Event fired when the user begins dragging the DragContainer.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the DragContainer that the user
         * has started to drag.
         */
        public static const EventDragStarted:String = "DragStarted";
        /** Event fired when the user releases the DragContainer.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the DragContainer that the user has
         * released.
         */
        public static const EventDragEnded:String = "DragEnded";
        /** Event fired when the drag position has changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the DragContainer whose position has
         * changed due to the user dragging it.
         */
        public static const EventDragPositionChanged:String = "DragPositionChanged";
        /** Event fired when dragging is enabled or disabled.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the DragContainer whose setting has
         * been changed.
         */
        public static const EventDragEnabledChanged:String = "DragEnabledChanged";
        /** Event fired when the alpha value used when dragging is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the DragContainer whose drag alpha
         * value has been changed.
         */
        public static const EventDragAlphaChanged:String = "DragAlphaChanged";
        /** Event fired when the mouse cursor to used when dragging is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the DragContainer whose dragging
         * mouse cursor image has been changed.
         */
        public static const EventDragMouseCursorChanged:String = "DragMouseCursorChanged";
        /** Event fired when the drag pixel threshold is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the DragContainer whose dragging pixel
         * threshold has been changed.
         */
        public static const EventDragThresholdChanged:String = "DragThresholdChanged";
        /** Event fired when the drop target changes.
         * Handlers are passed a const DragDropEventArgs reference with
         * WindowEventArgs::window set to the Window that is now the target
         * window  and DragDropEventArgs::dragDropItem set to the DragContainer
         * whose target has changed.
         */
        public static const EventDragDropTargetChanged:String = "DragDropTargetChanged";
        
        
        /*************************************************************************
         Static properties for the Spinner widget
         *************************************************************************/
        private static var d_dragAlphaProperty:DragContainerPropertyDragAlpha = new DragContainerPropertyDragAlpha();
        private static var d_dragCursorImageProperty:DragContainerPropertyDragCursorImage = new DragContainerPropertyDragCursorImage();
        private static var d_dragEnabledProperty:DragContainerPropertyDraggingEnabled = new DragContainerPropertyDraggingEnabled();
        private static var d_dragThresholdProperty:DragContainerPropertyDragThreshold = new DragContainerPropertyDragThreshold();
        private static var d_stickyModeProperty:DragContainerPropertyStickyMode = new DragContainerPropertyStickyMode();
        private static var d_fixedDragOffsetProperty:DragContainerPropertyFixedDragOffset = new DragContainerPropertyFixedDragOffset();
        private static var d_useFixedDragOffsetProperty:DragContainerPropertyUseFixedDragOffset = new DragContainerPropertyUseFixedDragOffset();

        /*************************************************************************
         Data
         *************************************************************************/
        protected var d_draggingEnabled:Boolean = true;  //!< True when dragging is enabled.
        protected var d_leftMouseDown:Boolean = false;    //!< True when left mouse button is down.
        protected var d_dragging:Boolean = false;         //!< true when being dragged.
        protected var d_dragPoint:UVector2 = new UVector2();       //!< point we are being dragged at.
        protected var d_startPosition:UVector2 = new UVector2();   //!< position prior to dragging.
        protected var d_dragThreshold:Number = 8.0;    //!< Pixels mouse must move before dragging commences.
        protected var d_dragAlpha:Number = 0.5;        //!< Alpha value to set when dragging.
        protected var d_storedAlpha:Number;      //!< Alpha value to re-set when dragging ends.
        protected var d_storedClipState:Boolean;  //!< Parent clip state to re-set.
        protected var d_dropTarget:FlameWindow = null;       //!< Target window for possible drop operation.
        protected var d_dragCursorImage:FlameImage = null; //!< Image to use for mouse cursor when dragging.
        protected var d_dropflag:Boolean = false;            //!< True when we're being dropped
        //! true when we're in 'sticky' mode.
        protected var d_stickyMode:Boolean = false;
        //! true after been picked-up / dragged via sticky mode
        protected var d_pickedUp:Boolean = false;
        //! true if fixed mouse offset is used for dragging position.
        protected var d_usingFixedDragOffset:Boolean = false;
        //! current fixed mouse offset value.
        protected var d_fixedDragOffset:UVector2 = new UVector2();
        
        
        
        public function FlameDragContainer(type:String, name:String)
        {
            super(type, name);
            
            addDragContainerProperties();
        }
        
        
        /*************************************************************************
         Public Interface to DragContainer
         *************************************************************************/
        /*!
        \brief
        Return whether dragging is currently enabled for this DragContainer.
        
        \return
        - true if dragging is enabled and the DragContainer may be dragged.
        - false if dragging is disabled and the DragContainer may not be dragged.
        */
        public function isDraggingEnabled():Boolean
        {
            return d_draggingEnabled;
        }
        
        /*!
        \brief
        Set whether dragging is currently enabled for this DragContainer.
        
        \param setting
        - true to enable dragging so that the DragContainer may be dragged.
        - false to disabled dragging so that the DragContainer may not be dragged.
        
        \return
        Nothing.
        */
        public function setDraggingEnabled(setting:Boolean):void
        {
            if (d_draggingEnabled != setting)
            {
                d_draggingEnabled = setting;
                var args:WindowEventArgs = new WindowEventArgs(this);
                onDragEnabledChanged(args);
            }
        }
        
        /*!
        \brief
        Return whether the DragContainer is currently being dragged.
        
        \return
        - true if the DragContainer is being dragged.
        - false if te DragContainer is not being dragged.
        */
        public function isBeingDragged():Boolean
        {
            return d_dragging;
        }
        
        /*!
        \brief
        Return the current drag threshold in pixels.
        
        The drag threshold is the number of pixels that the mouse must be
        moved with the left button held down in order to commence a drag
        operation.
        
        \return
        float value indicating the current drag threshold value.
        */
        public function getPixelDragThreshold():Number
        {
            return d_dragThreshold;
        }
        
        /*!
        \brief
        Set the current drag threshold in pixels.
        
        The drag threshold is the number of pixels that the mouse must be
        moved with the left button held down in order to commence a drag
        operation.
        
        \param pixels
        float value indicating the new drag threshold value.
        
        \return
        Nothing.
        */
        public function setPixelDragThreshold(pixels:Number):void
        {
            if (d_dragThreshold != pixels)
            {
                d_dragThreshold = pixels;
                var args:WindowEventArgs = new WindowEventArgs(this);
                onDragThresholdChanged(args);
            }
        }
        
        /*!
        \brief
        Return the alpha value that will be set on the DragContainer while a drag operation is
        in progress.
        
        \return
        Current alpha value to use whilst dragging.
        */
        public function getDragAlpha():Number
        {
            return d_dragAlpha;
        }
        
        /*!
        \brief
        Set the alpha value to be set on the DragContainer when a drag operation is
        in progress.
        
        This method can be used while a drag is in progress to update the alpha.  Note that
        the normal setAlpha method does not affect alpha while a drag is in progress, but
        once the drag operation has ended, any value set via setAlpha will be restored.
        
        \param alpha
        Alpha value to use whilst dragging.
        
        \return
        Nothing.
        */
        public function setDragAlpha(alpha:Number):void
        {
            if (d_dragAlpha != alpha)
            {
                d_dragAlpha = alpha;
                var args:WindowEventArgs = new WindowEventArgs(this);
                onDragAlphaChanged(args);
            }
        }
        
        /*!
        \brief
        Return the Image currently set to be used for the mouse cursor when a
        drag operation is in progress.
        
        \return
        Image object currently set to be used as the mouse cursor when dragging.
        */
        public function getDragCursorImage():FlameImage
        {
            if (d_dragCursorImage == null)
            {
                return FlameSystem.getSingleton().getDefaultMouseCursor();
            }
            else
            {
                return d_dragCursorImage;
            }
        }
        
        /*!
        \brief
        Set the Image to be used for the mouse cursor when a drag operation is
        in progress.
        
        This method may be used during a drag operation to update the current mouse
        cursor image.
        
        \param image
        Image object to be used as the mouse cursor while dragging.
        
        \return
        Nothing.
        */
        public function setDragCursorImage(image:FlameImage):void
        {
            if (d_dragCursorImage != image)
            {
                d_dragCursorImage = image;
                var args:WindowEventArgs = new WindowEventArgs(this);
                onDragMouseCursorChanged(args);
            }
        }
        
        /*!
        \brief
        Set the Image to be used for the mouse cursor when a drag operation is
        in progress.
        
        This method may be used during a drag operation to update the current mouse
        cursor image.
        
        \param image
        One of the MouseCursorImage enumerated values.
        
        \return
        Nothing.
        */
//        public function setDragCursorImage(image:uint):void
//        {
//            if (d_dragCursorImage != image)
//            {
//                d_dragCursorImage = image;
//                var args:WindowEventArgs = new WindowEventArgs(this);
//                onDragMouseCursorChanged(args);
//            }
//        }
        
        /*!
        \brief
        Set the Image to be used for the mouse cursor when a drag operation is
        in progress.
        
        This method may be used during a drag operation to update the current mouse
        cursor image.
        
        \param imageset
        String holding the name of the Imageset that contains the Image to be used.
        
        \param image
        Image defined for the Imageset \a imageset to be used as the mouse cursor
        when dragging.
        
        \return
        Nothing.
        
        \exception UnknownObjectException   thrown if either \a imageset or \a image are unknown.
        */
        public function setDragCursorImageFromImageSet(imageset:String, image:String):void
        {
            setDragCursorImage(FlameImageSetManager.getSingleton().getImageSet(imageset).getImage(image));
        }
        
        /*!
        \brief
        Return the Window object that is the current drop target for the DragContainer.
        
        The drop target for a DragContainer is basically the Window that the DragContainer
        is within while being dragged.  The drop target may be 0 to indicate no target.
        
        \return
        Pointer to a Window object that contains the DragContainer whilst being dragged, or
        0 to indicate no current target.
        */
        public function getCurrentDropTarget():FlameWindow
        {
            return d_dropTarget;
        }
        
        /*!
        \brief
        Return whether sticky mode is enable or disabled.
        
        \return
        - true if sticky mode is enabled.
        - false if sticky mode is disabled.
        */
        public function isStickyModeEnabled():Boolean
        {
            return d_stickyMode;
        }
        
        /*!
        \brief
        Enable or disable sticky mode.
        
        \param setting
        - true to enable sticky mode.
        - false to disable sticky mode.
        */
        public function setStickyModeEnabled(setting:Boolean):void
        {
            d_stickyMode = setting;
        }
        
        /*!
        \brief
        Immediately pick up the DragContainer and optionally set the sticky
        mode in order to allow this to happen.  Any current interaction
        (i.e. mouse capture) will be interrupted.
        
        \param force_sticky
        - true to automatically enable the sticky mode in order to
        facilitate picking up the DragContainer.
        - false to ignore the pick up request if the sticky mode is not
        alraedy enabled (default).
        
        \return
        - true if the DragContainer was successfully picked up.
        - false if the DragContainer was not picked up.
        */
        public function pickUp(force_sticky:Boolean = false):Boolean
        {
            // check if we're already picked up or if dragging is disabled.
            if (d_pickedUp || !d_draggingEnabled)
                return true;
            
            // see if we need to force sticky mode switch
            if (!d_stickyMode && force_sticky)
                setStickyModeEnabled(true);
            
            // can only pick up if sticky
            if (d_stickyMode)
            {
                // force immediate release of any current input capture (unless it's us)
                if (d_captureWindow && d_captureWindow != this)
                    d_captureWindow.releaseInput();
                // activate ourselves and try to capture input
                activate();
                if (captureInput())
                {
                    // set the dragging point to the centre of the container.
                    d_dragPoint.d_x = Misc.cegui_absdim(d_pixelSize.d_width / 2);
                    d_dragPoint.d_y = Misc.cegui_absdim(d_pixelSize.d_height / 2);
                    
                    // initialise the dragging state
                    initialiseDragging();
                    
                    // get position of mouse as co-ordinates local to this window.
                    const localMousePos:Vector2 = CoordConverter.screenToWindowForVector2(this,
                        FlameMouseCursor.getSingleton().getPosition());
                    doDragging(localMousePos);
                    
                    d_pickedUp = true;
                }
            }
            
            return d_pickedUp;
        }
        
        /*!
        \brief
        Set the fixed mouse cursor dragging offset to be used for this
        DragContainer.
        
        \param offset
        UVector2 describing the fixed offset to be used when dragging this
        DragContainer.
        
        \note
        This offset is only used if it's use is enabled via the
        setUsingFixedDragOffset function.
        */
        public function setFixedDragOffset(offset:UVector2):void
        {
            d_fixedDragOffset = offset;
        }
        
        /*!
        \brief
        Return the fixed mouse cursor dragging offset to be used for this
        DragContainer.
        
        \return
        UVector2 describing the fixed offset used when dragging this
        DragContainer.
        
        \note
        This offset is only used if it's use is enabled via the
        setUsingFixedDragOffset function.
        */
        public function getFixedDragOffset():UVector2
        {
            return d_fixedDragOffset;
        }
        
        /*!
        \brief
        Set whether the fixed dragging offset - as set with the
        setFixedDragOffset - function will be used, or whether the built-in
        positioning will be used.
        
        \param enable
        - true to enabled the use of the fixed offset.
        - false to use the regular logic.
        */
        public function setUsingFixedDragOffset(enable:Boolean):void
        {
            d_usingFixedDragOffset = enable;
        }
        
        /*!
        \brief
        Return whether the fixed dragging offset - as set with the
        setFixedDragOffset function - will be used, or whether the built-in
        positioning will be used.
        
        \param enable
        - true to enabled the use of the fixed offset.
        - false to use the regular logic.
        */
        public function isUsingFixedDragOffset():Boolean
        {
            return d_usingFixedDragOffset;
        }
        
        // Window class overrides.
        override public function getRenderingContext_impl():RenderingContext
        {
            // if not dragging, do the default thing.
            if (!d_dragging)
                return super.getRenderingContext_impl();
            
            // otherwise, switch rendering onto root rendering surface
            const root:FlameWindow = getRootWindow();
            
            var ctx:RenderingContext = new RenderingContext();
            
            ctx.surface = root.getTargetRenderingSurface();
            // ensure root window is only used as owner if it really is.
            ctx.owner = root.getRenderingSurface() == ctx.surface ? root : null;
            // ensure use of correct offset for the surface we're targetting
            ctx.offset = ctx.owner ? ctx.owner.getOuterRectClipper().getPosition() :
                new Vector2(0, 0);
            // draw to overlay queue
            ctx.queue = Consts.RenderQueueID_RQ_OVERLAY;
            
            return ctx;
        }
        
        /*************************************************************************
         Protected Implementation Methods
         *************************************************************************/
        /*!
        \brief
        Return whether the required minimum movement threshold before initiating dragging
        has been exceeded.
        
        \param local_mouse
        Mouse position as a pixel offset from the top-left corner of this window.
        
        \return
        - true if the threshold has been exceeded and dragging should be initiated.
        - false if the threshold has not been exceeded.
        */		
        protected function isDraggingThresholdExceeded(local_mouse:Vector2):Boolean
        {
            // calculate amount mouse has moved.
            var	deltaX:Number = Math.abs(local_mouse.d_x - d_dragPoint.d_x.asAbsolute(d_pixelSize.d_width));
            var	deltaY:Number = Math.abs(local_mouse.d_y - d_dragPoint.d_y.asAbsolute(d_pixelSize.d_height));
            
            // see if mouse has moved far enough to start dragging operation
            return (deltaX > d_dragThreshold || deltaY > d_dragThreshold) ? true : false;
        }
        
        /*!
        \brief
        Initialise the required states to put the window into dragging mode.
        
        \return
        Nothing.
        */
        protected function initialiseDragging():void
        {
            // only proceed if dragging is actually enabled
            if (d_draggingEnabled)
            {
                // initialise drag moving state
                d_storedClipState = d_clippedByParent;
                setClippedByParent(false);
                d_storedAlpha = d_alpha;
                setAlpha(d_dragAlpha);
                
                //the position should be cloned!!!
                d_startPosition = getPosition().clone();
                
                d_dragging = true;
                
                notifyScreenAreaChanged();
                
                // Now drag mode is set, change cursor as required
                updateActiveMouseCursor();
            }
        }
        /*!
        \brief
        Update state for window dragging.
        
        \param local_mouse
        Mouse position as a pixel offset from the top-left corner of this window.
        
        \return
        Nothing.
        */
        protected function doDragging(local_mouse:Vector2):void
        {
            // calculate amount to move
            var offset:UVector2 = new UVector2(Misc.cegui_absdim(local_mouse.d_x), Misc.cegui_absdim(local_mouse.d_y));
            offset.substractTo((d_usingFixedDragOffset) ? d_fixedDragOffset : d_dragPoint);
            var pos:UVector2 = getPosition().add(offset);
            // set new position
            setPosition(pos);
            
            // Perform event notification
            var args:WindowEventArgs = new WindowEventArgs(this);
            onDragPositionChanged(args);
        }
        
        /*!
        \brief
        Method to update mouse cursor image
        */
        protected function updateActiveMouseCursor():void
        {
            FlameMouseCursor.getSingleton().setImage(d_dragging ? getDragCursorImage() : getMouseCursor());
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
            if (class_name=="DragContainer")	return true;
            return super.testClassName_impl(class_name);
        }
        
        
        /*************************************************************************
         Overrides of methods in Window
         *************************************************************************/
        
        /*************************************************************************
         Overrides for Event handler methods
         *************************************************************************/
        override public function onMouseButtonDown(e:MouseEventArgs):void
        {
            super.onMouseButtonDown(e);
            
            if (e.button == Consts.MouseButton_LeftButton)
            {
                // ensure all inputs come to us for now
                if (captureInput())
                {
                    // get position of mouse as co-ordinates local to this window.
                    var localPos:Vector2 = CoordConverter.screenToWindowForVector2(this, e.position);
                    
                    // store drag point for possible sizing or moving operation.
                    d_dragPoint.d_x = Misc.cegui_absdim(localPos.d_x);
                    d_dragPoint.d_y = Misc.cegui_absdim(localPos.d_y);
                    d_leftMouseDown = true;
                }
                
                ++e.handled;
            }
        }
        
        override public function onMouseButtonUp(e:MouseEventArgs):void
        {
            super.onMouseButtonUp(e);
            
            if (e.button == Consts.MouseButton_LeftButton)
            {
                if (d_dragging)
                {
                    // release picked up state
                    if (d_pickedUp)
                        d_pickedUp = false;
                    
                    // fire off event
                    var args:WindowEventArgs = new WindowEventArgs(this);
                    onDragEnded(args);
                }
                    // check for sticky pick up
                else if (d_stickyMode && !d_pickedUp)
                {
                    initialiseDragging();
                    d_pickedUp = true;
                    // in this case, do not proceed to release inputs.
                    return;
                }
                
                // release our capture on the input data
                releaseInput();
                ++e.handled;
            }
        }
        
        
        override public function onMouseMove(e:MouseEventArgs):void
        {
            super.onMouseMove(e);
            
            // get position of mouse as co-ordinates local to this window.
            var localMousePos:Vector2 = CoordConverter.screenToWindowForVector2(this, e.position);
            
            // handle dragging
            if (d_dragging)
            {
                doDragging(localMousePos);
            }
                // not dragging
            else
            {
                // if mouse button is down (but we're not yet being dragged)
                if (d_leftMouseDown)
                {
                    if (isDraggingThresholdExceeded(localMousePos))
                    {
                        // Trigger the event
                        var args:WindowEventArgs = new WindowEventArgs(this);
                        onDragStarted(args);
                    }
                }
            }
        }
    
        override protected function onCaptureLost(e:WindowEventArgs):void
        {
            super.onCaptureLost(e);
            
            // reset state
            if (d_dragging)
            {
                // restore windows 'normal' state.
                d_dragging = false;
                setPosition(d_startPosition);
                setClippedByParent(d_storedClipState);
                setAlpha(d_storedAlpha);
                
                notifyScreenAreaChanged();
                
                // restore normal mouse cursor
                updateActiveMouseCursor();
            }
            
            d_leftMouseDown = false;
            d_dropTarget = null;
            
            ++e.handled;
        }
        
        override protected function onAlphaChanged(e:WindowEventArgs):void
        {
            // store new value and re-set dragging alpha as required.
            if (d_dragging)
            {
                d_storedAlpha = d_alpha;
                d_alpha = d_dragAlpha;
            }
            
            super.onAlphaChanged(e);
        }
        
        
        override protected function onClippingChanged(e:WindowEventArgs):void/*Window::drawSelf(z);*/
        {
            // store new value and re-set clipping for drag as required.
            if (d_dragging)
            {
                d_storedClipState = d_clippedByParent;
                d_clippedByParent = false;
            }
            
            super.onClippingChanged(e);
        }
        
        
        override protected function onMoved(e:WindowEventArgs):void
        {
            super.onMoved(e);
            if (d_dropflag)
            {
                d_startPosition = getPosition();
            }
        }
        
        /*************************************************************************
         New Event handler methods
         *************************************************************************/
        /*!
        \brief
        Method called when dragging commences
        
        \param e
        WindowEventArgs object containing any relevant data.
        
        \return
        Nothing.
        */
        protected function onDragStarted(e:WindowEventArgs):void
        {
            initialiseDragging();
            
            fireEvent(EventDragStarted, e, EventNamespace);
        }
        
        /*!
        \brief
        Method called when dragging ends.
        
        \param e
        WindowEventArgs object containing any relevant data.
        
        \return
        Nothing.
        */
        protected function onDragEnded(e:WindowEventArgs):void
        {
            fireEvent(EventDragEnded, e, EventNamespace);
            
            // did we drop over a window?
            if (d_dropTarget)
            {
                // set flag - we need to detect if the position changed in a DragDropItemDropped
                d_dropflag = true;
                // Notify that item was dropped in the target window
                d_dropTarget.notifyDragDropItemDropped(this);
                // reset flag
                d_dropflag = false;
            }
        }
        
        /*!
        \brief
        Method called when the dragged object position is changed.
        
        \param e
        WindowEventArgs object containing any relevant data.
        
        \return
        Nothing.
        */
        protected function onDragPositionChanged(e:WindowEventArgs):void
        {
            fireEvent(EventDragPositionChanged, e, EventNamespace);
            
            var root:FlameWindow;
            
            if (null != (root = FlameSystem.getSingleton().getGUISheet()))
            {
                // this hack with the 'enabled' state is so that getChildAtPosition
                // returns something useful instead of a pointer back to 'this'.
                // This hack is only acceptable because I am CrazyEddie!
                var wasEnabled:Boolean = d_enabled;
                d_enabled = false;
                // find out which child of root window has the mouse in it
                var eventWindow:FlameWindow = root.getTargetChildAtPosition(FlameMouseCursor.getSingleton().getPosition());
                d_enabled = wasEnabled;
                
                // use root itself if no child was hit
                if (!eventWindow)
                {
                    eventWindow = root;
                }
                
                // if the window with the mouse is different to current drop target
                if (eventWindow != d_dropTarget)
                {
                    var args:DragDropEventArgs = new DragDropEventArgs(eventWindow);
                    args.dragDropItem = this;
                    onDragDropTargetChanged(args);
                }
            }
        }
            
        
        /*!
        \brief
        Method called when the dragging state is enabled or disabled
        \param e
        WindowEventArgs object.
        \return
        Nothing.
        */
        protected function onDragEnabledChanged(e:WindowEventArgs):void
        {
            fireEvent(EventDragEnabledChanged, e, EventNamespace);
            
            // abort current drag operation if dragging gets disabled part way through
            if (!d_draggingEnabled && d_dragging)
            {
                releaseInput();
            }
        }
        
        /*!
        \brief
        Method called when the alpha value to use when dragging is changed.
        \param e
        WindowEventArgs object.
        \return
        Nothing.
        */
        protected function onDragAlphaChanged(e:WindowEventArgs):void
        {
            fireEvent(EventDragAlphaChanged, e, EventNamespace);
            
            if (d_dragging)
            {
                d_alpha = d_storedAlpha;
                onAlphaChanged(e);
            }
        }
            
        
        /*!
        \brief
        Method called when the mouse cursor to use when dragging is changed.
        \param e
        WindowEventArgs object.
        \return
        Nothing.
        */
        protected function onDragMouseCursorChanged(e:WindowEventArgs):void
        {
            fireEvent(EventDragMouseCursorChanged, e, EventNamespace);
            
            updateActiveMouseCursor();
        }
        
        /*!
        \brief
        Method called when the movement threshold required to trigger dragging is changed.
        \param e
        WindowEventArgs object.
        \return
        Nothing.
        */
        protected function onDragThresholdChanged(e:WindowEventArgs):void
        {
            fireEvent(EventDragThresholdChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Method called when the current drop target of this DragContainer changes.
        \note
        This event fires just prior to the target field being changed.  The default implementation
        changes the drop target, you can examine the old and new targets before calling the default
        implementation to make the actual change (and fire appropriate events for the Window objects
        involved).
        \param e
        DragDropEventArgs object initialised as follows:
        - dragDropItem is initialised to the DragContainer triggering the event (typically 'this').
        - window is initialised to point to the Window which will be the new drop target.
        \return
        Nothing.
        */
        protected function onDragDropTargetChanged(e:DragDropEventArgs):void
        {
            fireEvent(EventDragDropTargetChanged, e, EventNamespace);
            
            // Notify old target that drop item has left
            if (d_dropTarget)
            {
                d_dropTarget.notifyDragDropItemLeaves(this);
            }
            
            // update to new target
            d_dropTarget = e.window;
            
            while ((d_dropTarget != null) && !d_dropTarget.isDragDropTarget())
                d_dropTarget = d_dropTarget.getParent();
            
            // Notify new target window that someone has dragged a DragContainer over it
            if (d_dropTarget)
                d_dropTarget.notifyDragDropItemEnters(this);
        }
        
        
        /*************************************************************************
         Implementation methods
         *************************************************************************/
        /*!
        \brief
        Adds properties specific to the DragContainer base class.
        
        \return
        Nothing.
        */
        private function addDragContainerProperties():void
        {
            addProperty(d_dragEnabledProperty);
            addProperty(d_dragAlphaProperty);
            addProperty(d_dragThresholdProperty);
            addProperty(d_dragCursorImageProperty);
            addProperty(d_stickyModeProperty);
            addProperty(d_fixedDragOffsetProperty);
            addProperty(d_useFixedDragOffsetProperty);
        }

    }
}