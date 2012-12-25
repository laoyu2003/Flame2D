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
package Flame2D.elements.list
{
    import Flame2D.core.system.FlameEventManager;
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.system.FlameImageSetManager;
    import Flame2D.core.system.FlameMouseCursor;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.data.Consts;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.renderer.FlameRenderer;
    import Flame2D.core.utils.CoordConverter;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.UDim;
    import Flame2D.core.utils.URect;
    import Flame2D.core.utils.UVector2;
    import Flame2D.core.utils.Vector2;
    
    public class FlameListHeaderSegment extends FlameWindow
    {
        public static const EventNamespace:String = "ListHeaderSegment";
        public static const WidgetTypeName:String = "CEGUI/ListHeaderSegment";
        
        
        /*************************************************************************
         Constants
         *************************************************************************/
        // Event names
        /** Event fired when the segment is clicked.
         * Hanlders are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ListHeaderSegment that was clicked.
         */
        public static const EventSegmentClicked:String = "SegmentClicked";
        /** Event fired when the sizer/splitter is double-clicked.
         * Hanlders are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ListHeaderSegment whose
         * sizer / splitter area was double-clicked.
         */
        public static const EventSplitterDoubleClicked:String = "SplitterDoubleClicked";
        /** Event fired when the user drag-sizable setting is changed.
         * Hanlders are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ListHeaderSegment whose user sizable
         * setting has been changed.
         */
        public static const EventSizingSettingChanged:String = "SizingSettingChanged";
        /** Event fired when the sort direction value is changed.
         * Hanlders are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ListHeaderSegment whose sort direction
         * has been changed.
         */
        public static const EventSortDirectionChanged:String = "SortDirectionChanged";
        /** Event fired when the user drag-movable setting is changed.
         * Hanlders are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ListHeaderSegment whose user
         * drag-movable setting has been changed.
         */
        public static const EventMovableSettingChanged:String = "MovableSettingChanged";
        /** Event fired when the segment has started to be dragged.
         * Hanlders are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ListHeaderSegment that has started to
         * be dragged.
         */
        public static const EventSegmentDragStart:String = "SegmentDragStart";
        /** Event fired when segment dragging has stopped (via mouse release).
         * Hanlders are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ListHeaderSegment that is no longer
         * being dragged.
         */
        public static const EventSegmentDragStop:String = "SegmentDragStop";
        /** Event fired when the segment drag position has changed.
         * Hanlders are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ListHeaderSegment whose position has
         * changed due to being dragged.
         */
        public static const EventSegmentDragPositionChanged:String = "SegmentDragPositionChanged";
        /** Event fired when the segment is sized by the user.
         * Hanlders are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ListHeaderSegment that has been
         * resized by the user dragging.
         */
        public static const EventSegmentSized:String = "SegmentSized";
        /** Event fired when the clickable setting for the segment is changed.
         * Hanlders are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ListHeaderSegment whose setting that
         * controls whether the segment is clickable has been changed.
         */
        public static const EventClickableSettingChanged:String = "ClickableSettingChanged";
        
        // Defaults
        public static const DefaultSizingArea:Number = 8.0;		//!< Default size of the sizing area.
        public static const SegmentMoveThreshold:Number = 12.0;	//!< Amount the mouse must be dragged before drag-moving is initiated.

        
        /*************************************************************************
         Static Properties for this class
         *************************************************************************/
        private static var d_clickableProperty:ListHeaderSegmentPropertyClickable = new ListHeaderSegmentPropertyClickable();
        private static var d_dragableProperty:ListHeaderSegmentPropertyDragable = new ListHeaderSegmentPropertyDragable();
        private static var d_sizableProperty:ListHeaderSegmentPropertySizable = new ListHeaderSegmentPropertySizable();
        private static var d_sortDirectionProperty:ListHeaderSegmentPropertySortDirection = new ListHeaderSegmentPropertySortDirection();
        private static var d_sizingCursorProperty:ListHeaderSegmentPropertySizingCursorImage = new ListHeaderSegmentPropertySizingCursorImage();
        private static var d_movingCursorProperty:ListHeaderSegmentPropertyMovingCursorImage = new ListHeaderSegmentPropertyMovingCursorImage();
        

        
        /*************************************************************************
         Implementation Data
         *************************************************************************/
        protected var d_sizingMouseCursor:FlameImage = null;	//!< Image to use for mouse when sizing (typically set by derived class).
        protected var d_movingMouseCursor:FlameImage = null;	//!< Image to use for mouse when moving (typically set by derived class).
        
        protected var d_splitterSize:Number = DefaultSizingArea;		//!< pixel width of the sizing area.
        protected var d_splitterHover:Boolean = false;	//!< True if the mouse is over the splitter
        
        protected var d_dragSizing:Boolean = false;		//!< true when we are being sized.
        protected var d_dragPoint:Vector2 = new Vector2();		//!< point we are being dragged at when sizing or moving.
        
        protected var d_sortDir:uint = Consts.SortDirection_None;	//!< Direction for sorting (used for deciding what icon to display).
        
        protected var d_segmentHover:Boolean = false;		//!< true when the mouse is within the segment area (and not in sizing area).
        protected var d_segmentPushed:Boolean = false;	//!< true when the left mouse button has been pressed within the confines of the segment.
        protected var d_sizingEnabled:Boolean = true;	//!< true when sizing is enabled for this segment.
        protected var d_movingEnabled:Boolean = true;	//!< True when drag-moving is enabled for this segment;
        protected var d_dragMoving:Boolean = false;		//!< true when segment is being drag moved.
        protected var d_dragPosition:Vector2 = new Vector2();		//!< position of dragged segment.
        protected var d_allowClicks:Boolean = true;		//!< true if the segment can be clicked.

        
        public function FlameListHeaderSegment(type:String, name:String)
        {
            super(type, name);
            
            addHeaderSegmentProperties();
        }
        
        
        
        
        /*************************************************************************
         Accessor Methods
         *************************************************************************/
        /*!
        \brief
        Return whether this segment can be sized.
        
        \return
        true if the segment can be horizontally sized, false if the segment can not be horizontally sized.
        */
        public function isSizingEnabled():Boolean
        {
            return d_sizingEnabled;
        }
        
        
        /*!
        \brief
        Return the current sort direction set for this segment.
        
        Note that this has no impact on the way the segment functions (aside from the possibility
        of varied rendering).  This is intended as a 'helper setting' to classes that make use of
        the ListHeaderSegment objects.
        
        \return
        One of the SortDirection enumerated values indicating the current sort direction set for this
        segment.
        */
        public function getSortDirection():uint
        {
            return d_sortDir;
        }
        
        
        /*!
        \brief
        Return whether drag moving is enabled for this segment.
        
        \return
        true if the segment can be drag moved, false if the segment can not be drag moved.
        */
        public function isDragMovingEnabled():Boolean
        {
            return d_movingEnabled;
        }
        
        
        /*!
        \brief
        Return the current drag move position offset (in pixels relative to the top-left corner of the segment).
        
        \return
        Point object describing the drag move offset position.
        */
        public function getDragMoveOffset():Vector2
        {
            return d_dragPosition;
        }
        
        
        /*!
        \brief
        Return whether the segment is clickable.
        
        \return
        true if the segment can be clicked, false of the segment can not be clicked (so no highlighting or events will happen).
        */
        public function isClickable():Boolean
        {
            return d_allowClicks;
        }
        
        
        /*!
        \brief
        Return whether the segment is currently in its hovering state.
        */
        public function isSegmentHovering():Boolean
        {
            return d_segmentHover;
        }
        
        
        /*!
        \brief
        Return whether the segment is currently in its pushed state.
        */
        public function isSegmentPushed():Boolean
        {
            return d_segmentPushed;
        }
        
        
        /*!
        \brief
        Return whether the splitter is currently in its hovering state.
        */
        public function isSplitterHovering():Boolean
        {
            return d_splitterHover;
        }
        
        
        /*!
        \brief
        Return whether the segment is currently being drag-moved.
        */
        public function isBeingDragMoved():Boolean
        {
            return d_dragMoving;
        }
        
        
        /*!
        \brief
        Return whether the segment is currently being drag-moved.
        */
        public function isBeingDragSized():Boolean
        {
            return d_dragSizing;
        }
        
        
        public function getSizingCursorImage():FlameImage
        {
            return d_sizingMouseCursor;
        }
        
        public function getMovingCursorImage():FlameImage
        {
            return d_movingMouseCursor;
        }
        
        
        /*************************************************************************
         Manipulator Methods
         *************************************************************************/
        /*!
        \brief
        Set whether this segment can be sized.
        
        \param setting
        true if the segment may be horizontally sized, false if the segment may not be horizontally sized.
        
        \return
        Nothing.
        */
        public function setSizingEnabled(setting:Boolean):void
        {
            if (d_sizingEnabled != setting)
            {
                d_sizingEnabled = setting;
                
                // if sizing is now disabled, ensure sizing operation is cancelled
                if (!d_sizingEnabled && d_dragSizing)
                {
                    releaseInput();
                }
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onSizingSettingChanged(args);
            }
        }
        
        
        /*!
        \brief
        Set the current sort direction set for this segment.
        
        Note that this has no impact on the way the segment functions (aside from the possibility
        of varied rendering).  This is intended as a 'helper setting' to classes that make use of
        the ListHeaderSegment objects.
        
        \param sort_dir
        One of the SortDirection enumerated values indicating the current sort direction set for this
        segment.
        
        \return
        Nothing
        */
        public function setSortDirection(sort_dir:uint):void
        {
            if (d_sortDir != sort_dir)
            {
                d_sortDir = sort_dir;
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onSortDirectionChanged(args);
                
                invalidate();
            }
        }
        
        
        /*!
        \brief
        Set whether drag moving is allowed for this segment.
        
        \param setting
        true if the segment may be drag moved, false if the segment may not be drag moved.
        
        \return
        Nothing.
        */
        public function setDragMovingEnabled(setting:Boolean):void
        {
            if (d_movingEnabled != setting)
            {
                d_movingEnabled = setting;
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onMovableSettingChanged(args);
            }
        }
        
        
        /*!
        \brief
        Set whether the segment is clickable.
        
        \param setting
        true if the segment may be clicked, false of the segment may not be clicked (so no highlighting or events will happen).
        
        \return
        Nothing.
        */
        public function setClickable(setting:Boolean):void
        {
            if (d_allowClicks != setting)
            {
                d_allowClicks = setting;
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onClickableSettingChanged(args);
            }
        }
        
        
        public function setSizingCursorImage(image:FlameImage):void
        {
            d_sizingMouseCursor = image;
        }
        
        public function setSizingCursorImageFromImageSet(imageset:String, image:String):void
        {
            d_sizingMouseCursor = FlameImageSetManager.getSingleton().getImageSet(imageset).getImage(image);
        }
        
        public function setMovingCursorImage(image:FlameImage):void
        {
            d_movingMouseCursor = image;
        }
        
        public function setMovingCursorImageFromImageSet(imageset:String, image:String):void
        {
            d_movingMouseCursor = FlameImageSetManager.getSingleton().getImageSet(imageset).getImage(image);
        }
        
        
        
        /*************************************************************************
         Implementation Methods
         *************************************************************************/
        /*!
        \brief
        Update state for drag sizing.
        
        \param local_mouse
        Mouse position as a pixel offset from the top-left corner of this window.
        
        \return
        Nothing.
        */
        protected function doDragSizing(local_mouse:Vector2):void
        {
            var delta:Number = local_mouse.d_x - d_dragPoint.d_x;
            
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
            
            // update segment area rect
            var uvmin:UVector2 = new UVector2(d_area.d_min.d_x, d_area.d_min.d_y);
            var uvmax:UVector2 = new UVector2(d_area.d_max.d_x.add(new UDim(0, Misc.PixelAligned(delta))),  d_area.d_max.d_y);
            var area:URect = new URect(uvmin, uvmax);
            setArea_impl(area.d_min, area.getSize());
            
            // move the dragging point so mouse remains 'attached' to edge of segment
            d_dragPoint.d_x += d_pixelSize.d_width - orgWidth;
            
            var args:WindowEventArgs = new WindowEventArgs(this);
            onSegmentSized(args);
        }
        
        
        /*!
        \brief
        Update state for drag moving.
        
        \param local_mouse
        Mouse position as a pixel offset from the top-left corner of this window.
        
        \return
        Nothing.
        */
        protected function doDragMoving(local_mouse:Vector2):void
        {
            // calculate movement deltas.
            var deltaX:Number = local_mouse.d_x - d_dragPoint.d_x;
            var deltaY:Number = local_mouse.d_y - d_dragPoint.d_y;
            
            // update 'ghost' position
            d_dragPosition.d_x += deltaX;
            d_dragPosition.d_y += deltaY;
            
            // update drag point.
            d_dragPoint.d_x += deltaX;
            d_dragPoint.d_y += deltaY;
            
            var args:WindowEventArgs = new WindowEventArgs(this);
            onSegmentDragPositionChanged(args);
        }
        
        
        /*!
        \brief
        Initialise the required states to put the widget into drag-moving mode.
        */
        protected function initDragMoving():void
        {
            if (d_movingEnabled)
            {
                // initialise drag moving state
                d_dragMoving = true;
                d_segmentPushed = false;
                d_segmentHover = false;
                d_dragPosition.d_x = 0.0;
                d_dragPosition.d_y = 0.0;
                
                // setup new cursor
                FlameMouseCursor.getSingleton().setImage(d_movingMouseCursor);
                
                // Trigger the event
                var args:WindowEventArgs = new WindowEventArgs(this);
                onSegmentDragStart(args);
            }
        }
        
        
        /*!
        \brief
        Initialise the required states when we are hovering over the sizing area.
        */
        protected function initSizingHoverState():void
        {
            // only react if settings are changing.
            if (!d_splitterHover  && !d_segmentPushed)
            {
                d_splitterHover = true;
                
                // change the mouse cursor.
                FlameMouseCursor.getSingleton().setImage(d_sizingMouseCursor);
                
                // trigger redraw so 'sizing' area can be highlighted if needed.
                invalidate();
            }
            
            // reset segment hover as needed.
            if (d_segmentHover)
            {	
                d_segmentHover = false;
                invalidate();
            }
        }
        
        
        /*!
        \brief
        Initialise the required states when we are hovering over the main segment area.
        */
        protected function initSegmentHoverState():void
        {
            // reset sizing area hover state if needed.
            if (d_splitterHover)
            {
                d_splitterHover = false;
                FlameMouseCursor.getSingleton().setImage(getMouseCursor());
                invalidate();
            }
            
            // set segment hover state if not already set.
            if ((!d_segmentHover) && isClickable())
            {
                d_segmentHover = true;
                invalidate();
            }
        }
        
        
        /*!
        \brief
        Return whether the required minimum movement threshold before initiating drag-moving
        has been exceeded.
        
        \param local_mouse
        Mouse position as a pixel offset from the top-left corner of this window.
        
        \return
        true if the threshold has been exceeded and drag-moving should be initiated, or false
        if the threshold has not been exceeded.
        */		
        protected function isDragMoveThresholdExceeded(local_mouse:Vector2):Boolean
        {
            // see if mouse has moved far enough to start move operation
            // calculate movement deltas.
            var deltaX:Number = local_mouse.d_x - d_dragPoint.d_x;
            var deltaY:Number = local_mouse.d_y - d_dragPoint.d_y;
            
            if ((deltaX > SegmentMoveThreshold) || (deltaX < -SegmentMoveThreshold) ||
                (deltaY > SegmentMoveThreshold) || (deltaY < -SegmentMoveThreshold))
            {
                return true;
            }
            else
            {
                return false;
            }
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
            if (class_name=="ListHeaderSegment")	return true;
            return super.testClassName_impl(class_name);
        }
        
        
        /*************************************************************************
         New Event Handlers
         *************************************************************************/
        /*!
        \brief
        Handler called when segment is clicked.
        */
        protected function onSegmentClicked(e:WindowEventArgs):void
        {
            fireEvent(EventSegmentClicked, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the sizer/splitter is double-clicked.
        */
        protected function onSplitterDoubleClicked(e:WindowEventArgs):void
        {
            fireEvent(EventSplitterDoubleClicked, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when sizing setting changes.
        */
        protected function onSizingSettingChanged(e:WindowEventArgs):void
        {
            fireEvent(EventSizingSettingChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the sort direction value changes.
        */
        protected function onSortDirectionChanged(e:WindowEventArgs):void
        {
            invalidate();
            fireEvent(EventSortDirectionChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the drag-movable setting is changed.
        */
        protected function onMovableSettingChanged(e:WindowEventArgs):void
        {
            fireEvent(EventMovableSettingChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the user starts dragging the segment.
        */
        protected function onSegmentDragStart(e:WindowEventArgs):void
        {
            fireEvent(EventSegmentDragStart, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the user stops dragging the segment (releases mouse button)
        */
        protected function onSegmentDragStop(e:WindowEventArgs):void
        {
            fireEvent(EventSegmentDragStop, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the drag position changes.
        */
        protected function onSegmentDragPositionChanged(e:WindowEventArgs):void
        {
            invalidate();
            fireEvent(EventSegmentDragPositionChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the segment is sized.
        */
        protected function onSegmentSized(e:WindowEventArgs):void
        {
            invalidate();
            fireEvent(EventSegmentSized, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the clickable setting for the segment changes
        */
        protected function onClickableSettingChanged(e:WindowEventArgs):void
        {
            fireEvent(EventClickableSettingChanged, e, EventNamespace);
        }
        
        
        /*************************************************************************
         Overridden Event Handlers
         *************************************************************************/
        override public function onMouseMove(e:MouseEventArgs):void
        {
            // base class processing
            super.onMouseMove(e);
            
            //
            // convert mouse position to something local
            //
            var localMousePos:Vector2 = CoordConverter.screenToWindowForVector2(this, e.position);
            
            // handle drag sizing
            if (d_dragSizing)
            {
                doDragSizing(localMousePos);
            }
                // handle drag moving
            else if (d_dragMoving)
            {
                doDragMoving(localMousePos);
            }
                // not sizing, is mouse in the widget area?
            else if (isHit(e.position))
            {
                // mouse in sizing area & sizing is enabled
                if ((localMousePos.d_x > (d_pixelSize.d_width - d_splitterSize)) && d_sizingEnabled)
                {
                    initSizingHoverState();
                }
                    // mouse not in sizing area and/or sizing not enabled
                else
                {
                    initSegmentHoverState();
                    
                    // if we are pushed but not yet drag moving
                    if (d_segmentPushed && !d_dragMoving)
                    {
                        if (isDragMoveThresholdExceeded(localMousePos))
                        {
                            initDragMoving();
                        }
                    }
                }
            }
                // mouse is no longer within the widget area...
            else
            {
                // only change settings if change is required
                if (d_splitterHover)
                {
                    d_splitterHover = false;
                    FlameMouseCursor.getSingleton().setImage(getMouseCursor());
                    invalidate();
                }
                
                // reset segment hover state if not already done.
                if (d_segmentHover)
                {	
                    d_segmentHover = false;
                    invalidate();
                }
                
            }
            
            ++e.handled;
        }
        
        
        override public function onMouseButtonDown(e:MouseEventArgs):void
        {
            // base class processing
            super.onMouseButtonDown(e);
            
            if (e.button == Consts.MouseButton_LeftButton)
            {
                // ensure all inputs come to us for now
                if (captureInput())
                {
                    // get position of mouse as co-ordinates local to this window.
                    var localPos:Vector2 = CoordConverter.screenToWindowForVector2(this, e.position);
                    
                    // store drag point for possible sizing or moving operation.
                    d_dragPoint = localPos;
                    
                    // if the mouse is in the sizing area
                    if (d_splitterHover)
                    {
                        if (isSizingEnabled())
                        {
                            // setup the 'dragging' state variables
                            d_dragSizing = true;
                        }
                        
                    }
                    else
                    {
                        d_segmentPushed = true;
                    }
                    
                }
                ++e.handled;
            }
        }
        
        override public function onMouseButtonUp(e:MouseEventArgs):void
        {
            // base class processing
            super.onMouseButtonUp(e);
            
            if (e.button == Consts.MouseButton_LeftButton)
            {
                // if we were pushed and mouse was released within our segment area
                if (d_segmentPushed && d_segmentHover)
                {
                    var pargs:WindowEventArgs = new WindowEventArgs(this);
                    onSegmentClicked(pargs);
                }
                else if (d_dragMoving)
                {
                    FlameMouseCursor.getSingleton().setImage(getMouseCursor());
                    
                    var margs:WindowEventArgs = new WindowEventArgs(this);
                    onSegmentDragStop(margs);
                }
                
                // release our capture on the input data
                releaseInput();
                ++e.handled;
            }
        }
        
        override public function onMouseDoubleClicked(e:MouseEventArgs):void
        {
            // base class processing
            super.onMouseDoubleClicked(e);
            
            // if double-clicked on splitter / sizing area
            if ((e.button == Consts.MouseButton_LeftButton) && d_splitterHover)
            {
                var args:WindowEventArgs = new WindowEventArgs(this);
                onSplitterDoubleClicked(args);
                
                ++e.handled;
            }
        }
        
        override public function onMouseLeaves(e:MouseEventArgs):void
        {
            // base class processing
            super.onMouseLeaves(e);
            
            d_splitterHover = false;
            d_dragSizing = false;
            d_segmentHover = false;
            invalidate();
        }
        
        override protected function onCaptureLost(e:WindowEventArgs):void
        {
            // base class processing
            super.onCaptureLost(e);
            
            // reset segment state
            d_dragSizing = false;
            d_segmentPushed = false;
            d_dragMoving = false;
            
            ++e.handled;
        }
        
        
        
        /*************************************************************************
         Private methods
         *************************************************************************/
        private function addHeaderSegmentProperties():void
        {
            addProperty(d_clickableProperty);
            addProperty(d_sizableProperty);
            addProperty(d_dragableProperty);
            addProperty(d_sortDirectionProperty);
            addProperty(d_sizingCursorProperty);
            addProperty(d_movingCursorProperty);
        }

    }
}