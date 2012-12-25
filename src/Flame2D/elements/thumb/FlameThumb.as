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
package Flame2D.elements.thumb
{
    import Flame2D.core.system.FlameEventManager;
    import Flame2D.core.data.Consts;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.utils.CoordConverter;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.UVector2;
    import Flame2D.core.utils.Vector2;
    import Flame2D.elements.button.FlamePushButton;

    /*!
    \brief
    Base class for Thumb widget.
    
    The thumb widget is used to compose other widgets (like sliders and scroll bars).  You would
    not normally need to use this widget directly unless you are making a new widget of some type.
    */
    public class FlameThumb extends FlamePushButton
    {
        public static const EventNamespace:String = "Thumb";
        public static const WidgetTypeName:String = "CEGUI/Thumb";
        
        
        /*************************************************************************
         Event name constants
         *************************************************************************/
        // generated internally by Window
        /** Event fired when the position of the thumb widget has changed (this
         * event is only fired when hot tracking is enabled).
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Thumb whose position has changed.
         */
        public static const EventThumbPositionChanged:String = "ThumbPosChanged";
        /** Event fired when the user begins dragging the thumb.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Thumb that has started to be dragged
         * by the user.
         */
        public static const EventThumbTrackStarted:String = "ThumbTrackStarted";
        /** Event fired when the user releases the thumb.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Thumb that has been released.
         */
        public static const EventThumbTrackEnded:String = "ThumbTrackEnded";
        
        
        /*************************************************************************
         Static Properties for this class
         *************************************************************************/
        private static var d_hotTrackedProperty:ThumbPropertyHotTracked = new ThumbPropertyHotTracked();
        private static var d_vertFreeProperty:ThumbPropertyVertFree = new ThumbPropertyVertFree();
        private static var d_horzFreeProperty:ThumbPropertyHorzFree = new ThumbPropertyHorzFree();
        private static var d_vertRangeProperty:ThumbPropertyVertRange = new ThumbPropertyVertRange();
        private static var d_horzRangeProperty:ThumbPropertyHorzRange = new ThumbPropertyHorzRange();
        
        
        /*************************************************************************
         Implementation Data
         *************************************************************************/
        // general settings
        protected var d_hotTrack:Boolean = true;					//!< true if events are to be sent real-time, else just when thumb is released
        protected var d_vertFree:Boolean = false;					//!< true if thumb is movable vertically
        protected var d_horzFree:Boolean = false;					//!< true if thumb is movable horizontally
        
        // operational limits
        protected var d_vertMin:Number = 0.0;
        protected var d_vertMax:Number = 1.0;		//!< vertical range
        protected var d_horzMin:Number = 0.0;
        protected var d_horzMax:Number = 1.0;		//!< horizontal range
        
        // internal state
        protected var d_beingDragged:Boolean = false;				//!< true if thumb is being dragged
        protected var d_dragPoint:Vector2 = new Vector2();				//!< point where we are being dragged at.
        
        
        

        public function FlameThumb(type:String, name:String)
        {
            super(type, name);
            
            addThumbProperties();
        }

        
        /*************************************************************************
         Accessor Functions
         *************************************************************************/ 
        /*!
        \brief
        return whether hot-tracking is enabled or not.
        
        \return
        true if hot-tracking is enabled.  false if hot-tracking is disabled.
        */
        public function isHotTracked():Boolean
        {
            return d_hotTrack;
        }
        
        /*!
        \brief
        return whether the thumb is movable on the vertical axis.
        
        \return
        true if the thumb is movable along the vertical axis.
        false if the thumb is fixed on the vertical axis.
        */
        public function isVertFree():Boolean
        {
            return d_vertFree;
        }
        
        /*!
        \brief
        return whether the thumb is movable on the horizontal axis.
        
        \return
        true if the thumb is movable along the horizontal axis.
        false if the thumb is fixed on the horizontal axis.
        */
        public function isHorzFree():Boolean
        {
            return d_horzFree;
        }
        
        
        /*!
        \brief
        Return a std::pair that describes the current range set for the vertical movement.
        
        \return
        a std::pair describing the current vertical range.  The first element is the minimum value,
        the second element is the maximum value.
        */
        public function getVertRange():Vector2
        {
            return new Vector2(d_vertMin, d_vertMax);
        }
        
        
        /*!
        \brief
        Return a std::pair that describes the current range set for the horizontal movement.
        
        \return
        a std::pair describing the current horizontal range.  The first element is the minimum value,
        the second element is the maximum value.
        */
        public function getHorzRange():Vector2
        {
            return new Vector2(d_horzMin, d_horzMax);
        }
        
        
        /*************************************************************************
         Manipulator Functions
         *************************************************************************/
        /*!
        \brief
        set whether the thumb uses hot-tracking.
        
        \param setting
        true to enable hot-tracking.  false to disable hot-tracking.
        
        \return
        Nothing.
        */
        public function setHotTracked(setting:Boolean):void
        {
            d_hotTrack = setting;
        }
        
        
        /*!
        \brief
        set whether thumb is movable on the vertical axis.
        
        \param setting
        true to allow movement of thumb along the vertical axis.  false to fix thumb on the vertical axis.
        
        \return
        nothing.
        */
        public function setVertFree(setting:Boolean):void
        {
            d_vertFree = setting;
        }
        
        
        /*!
        \brief
        set whether thumb is movable on the horizontal axis.
        
        \param setting
        true to allow movement of thumb along the horizontal axis.  false to fix thumb on the horizontal axis.
        
        \return
        nothing.
        */
        public function setHorzFree(setting:Boolean):void
        {
            d_horzFree = setting;
        }
        
        
        /*!
        \brief
        set the movement range of the thumb for the vertical axis.
        
        The values specified here are relative to the parent window for the thumb, and are specified in whichever
        metrics mode is active for the widget.
        
        \param min
        the minimum setting for the thumb on the vertical axis.
        
        \param max
        the maximum setting for the thumb on the vertical axis.
        
        \return
        Nothing.
        */
        public function setVertRange(min:Number, max:Number):void
        {
            // ensure min <= max, swap if not.
            if (min > max)
            {
                var tmp:Number = min;
                max = min;
                min = tmp;
            }
            
            d_vertMax = max;
            d_vertMin = min;
            
            // validate current position.
            var cp:Number = getYPosition().asRelative(getParentPixelHeight());
            
            if (cp < min)
            {
                setYPosition(Misc.cegui_reldim(min));
            }
            else if (cp > max)
            {
                setYPosition(Misc.cegui_reldim(max));
            }
        }
        
        
        /*!
        \brief
        set the movement range of the thumb for the horizontal axis.
        
        The values specified here are relative to the parent window for the thumb, and are specified in whichever
        metrics mode is active for the widget.
        
        \param min
        the minimum setting for the thumb on the horizontal axis.
        
        \param max
        the maximum setting for the thumb on the horizontal axis.
        
        \return
        Nothing.
        */
        public function setHorzRange(min:Number, max:Number):void
        {
            var parentSize:Size = getParentPixelSize();
            
            // ensure min <= max, swap if not.
            if (min > max)
            {
                var tmp:Number = min;
                max = min;
                min = tmp;
            }
            
            d_horzMax = max;
            d_horzMin = min;
            
            // validate current position.
            var cp:Number = getXPosition().asAbsolute(parentSize.d_width);
            
            if (cp < min)
            {
                setXPosition(Misc.cegui_absdim(min));
            }
            else if (cp > max)
            {
                setXPosition(Misc.cegui_absdim(max));
            }
        }
        

         
        /*************************************************************************
         Implementation Functions
         *************************************************************************/
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
            if (class_name=="Thumb")	return true;
            return super.testClassName_impl(class_name);
        }
        
        
        /*************************************************************************
         New Thumb Events
         *************************************************************************/
        /*!
        \brief
        event triggered internally when the position of the thumb
        */
        protected function onThumbPositionChanged(e:WindowEventArgs):void
        {
            fireEvent(EventThumbPositionChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler triggered when the user begins to drag the thumb. 
        */
        protected function onThumbTrackStarted(e:WindowEventArgs):void
        {
            fireEvent(EventThumbTrackStarted, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler triggered when the thumb is released
        */
        protected function onThumbTrackEnded(e:WindowEventArgs):void
        {
            fireEvent(EventThumbTrackEnded, e, EventNamespace);
        }
        
        
        
        /*************************************************************************
         Overridden event handling routines
         *************************************************************************/
        override public function onMouseMove(e:MouseEventArgs):void
        {
            // default processing
            super.onMouseMove(e);
            
            // only react if we are being dragged
            if (d_beingDragged)
            {
                var parentSize:Size = getParentPixelSize();
                
                var delta:Vector2;
                var hmin:Number, hmax:Number, vmin:Number, vmax:Number;
                
                delta = CoordConverter.screenToWindowForVector2(this, e.position);
                
                hmin = d_horzMin;
                hmax = d_horzMax;
                vmin = d_vertMin;
                vmax = d_vertMax;
                
                // calculate amount of movement      
                delta = delta.subtract(d_dragPoint);
                delta.d_x /= parentSize.d_width;
                delta.d_y /= parentSize.d_height;
                
                //
                // Calculate new (pixel) position for thumb
                //
                var newPos:UVector2 = getPosition().clone();
                
                if (d_horzFree)
                {
                    newPos.d_x.d_scale += delta.d_x;
                    
                    // limit value to within currently set range
                    newPos.d_x.d_scale = (newPos.d_x.d_scale < hmin) ? hmin : (newPos.d_x.d_scale > hmax) ? hmax : newPos.d_x.d_scale;
                }
                
                if (d_vertFree)
                {
                    newPos.d_y.d_scale += delta.d_y;
                    
                    // limit new position to within currently set range
                    newPos.d_y.d_scale = (newPos.d_y.d_scale < vmin) ? vmin : (newPos.d_y.d_scale > vmax) ? vmax : newPos.d_y.d_scale;
                }
                
                // update thumb position if needed
                if (! newPos.isEqual(getPosition()))
                {
                    setPosition(newPos);
                    
                    // send notification as required
                    if (d_hotTrack)
                    {
                        var args:WindowEventArgs = new WindowEventArgs(this);
                        onThumbPositionChanged(args);
                    }
                    
                }
                
            }
            
            ++e.handled;
        }
        
        override public function onMouseButtonDown(e:MouseEventArgs):void
        {
            // default processing
            super.onMouseButtonDown(e);
            
            if (e.button == Consts.MouseButton_LeftButton)
            {
                // initialise the dragging state
                d_beingDragged = true;
                d_dragPoint = CoordConverter.screenToWindowForVector2(this, e.position);
                
                // trigger tracking started event
                var args:WindowEventArgs = new WindowEventArgs(this);
                onThumbTrackStarted(args);
                
                ++e.handled;
            }

        }
        
        override protected function onCaptureLost(e:WindowEventArgs):void
        {
            // default handling
            super.onCaptureLost(e);
            
            d_beingDragged = false;
            
            // trigger tracking ended event
            var args:WindowEventArgs = new WindowEventArgs(this);
            onThumbTrackEnded(args);
            
            // send notification whenever thumb is released
            onThumbPositionChanged(args);
        }
        
        
        
        /*************************************************************************
         Add thumb specifiec properties
         *************************************************************************/
        private function addThumbProperties():void
        {
            addProperty(d_hotTrackedProperty);
            addProperty(d_vertFreeProperty);
            addProperty(d_horzFreeProperty);
            addProperty(d_vertRangeProperty);
            addProperty(d_horzRangeProperty);
            
            // if we're an autowindow we ban some properties from XML
            /*
            if (isAutoWindow())
            {
                banPropertyFromXML(&d_vertRangeProperty);
                banPropertyFromXML(&d_horzRangeProperty);
                banPropertyFromXML(&d_vertFreeProperty);
                banPropertyFromXML(&d_horzFreeProperty);
            }
            */
        }


    }
}