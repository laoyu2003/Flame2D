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
package Flame2D.elements.slider
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.system.FlameEventManager;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.Vector2;
    import Flame2D.elements.thumb.FlameThumb;

    /*!
    \brief
    Base class for Slider widgets.
    
    The slider widget has a default range of 0.0f - 1.0f.  This enables use of the slider value to scale
    any value needed by way of a simple multiplication.
    */
    public class FlameSlider extends FlameWindow
    {
        public static const EventNamespace:String = "Slider";
        public static const WidgetTypeName:String = "CEGUI/Slider";
        
        /*************************************************************************
         Event name constants
         *************************************************************************/
        /** Event fired when the slider value changes.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Slider whose value has changed.
         */
        public static const EventValueChanged:String = "ValueChanged";
        /** Event fired when the user begins dragging the thumb.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Slider whose thumb has started to
         * be dragged.
         */
        public static const EventThumbTrackStarted:String = "ThumbTrackStarted";
        /** Event fired when the user releases the thumb.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Slider whose thumb has been released.
         */
        public static const EventThumbTrackEnded:String = "ThumbTrackEnded";
        
        /*************************************************************************
         Child Widget name suffix constants
         *************************************************************************/
        public static const ThumbNameSuffix:String = "__auto_thumb__";            //!< Widget name suffix for the thumb component.
        
        /*************************************************************************
         Static Properties for this class
         *************************************************************************/
        private static var d_currentValueProperty:SliderPropertyCurrentValue = new SliderPropertyCurrentValue();
        private static var d_maximumValueProperty:SliderPropertyMaximumValue = new SliderPropertyMaximumValue();
        private static var d_clickStepSizeProperty:SliderPropertyClickStepSize = new SliderPropertyClickStepSize();

        /*************************************************************************
         Implementation Data
         *************************************************************************/
        protected var d_value:Number = 0.0;		//!< current slider value
        protected var d_maxValue:Number = 1.0;		//!< slider maximum value (minimum is fixed at 0)
        protected var d_step:Number = 0.01;			//!< amount to adjust slider by when clicked (and not dragged).

        
        public function FlameSlider(type:String, name:String)
        {
            super(type, name);
            
            addSliderProperties();
        }
        
        
        
        
        
        /*************************************************************************
         Accessors
         *************************************************************************/
        /*!
        \brief
        return the current slider value.
        
        \return
        float value equal to the sliders current value.
        */
        public function getCurrentValue():Number
        {
            return d_value;
        }
        
        
        /*!
        \brief
        return the maximum value set for this widget
        
        \return
        float value equal to the currently set maximum value for this slider.
        */
        public function getMaxValue():Number
        {
            return d_maxValue;
        }
        
        
        /*!
        \brief
        return the current click step setting for the slider.
        
        The click step size is the amount the slider value will be adjusted when the widget
        is clicked wither side of the slider thumb.
        
        \return
        float value representing the current click step setting.
        */
        public function getClickStep():Number
        {
            return d_step;
        }
        
        
        /*!
        \brief
        Return a pointer to the Thumb component widget for this Slider.
        
        \return
        Pointer to a Thumb object.
        
        \exception UnknownObjectException
        Thrown if the Thumb component does not exist.
        */
        public function getThumb():FlameThumb
        {
            return FlameWindowManager.getSingleton().getWindow(
                getName() + ThumbNameSuffix) as FlameThumb;
        }
        
        
        /*************************************************************************
         Manipulators
         *************************************************************************/
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
            // get thumb
            var thumb:FlameThumb = getThumb();
            
            // bind handler to thumb events
            thumb.subscribeEvent(FlameThumb.EventThumbPositionChanged, new Subscriber(handleThumbMoved, this), FlameThumb.EventNamespace);
            thumb.subscribeEvent(FlameThumb.EventThumbTrackStarted, new Subscriber(handleThumbTrackStarted, this), FlameThumb.EventNamespace);
            thumb.subscribeEvent(FlameThumb.EventThumbTrackEnded, new Subscriber(handleThumbTrackEnded, this), FlameThumb.EventNamespace);
            
            performChildWindowLayout();
        }
        
        
        /*!
        \brief
        set the maximum value for the slider.  Note that the minimum value is fixed at 0.
        
        \param maxVal
        float value specifying the maximum value for this slider widget.
        
        \return
        Nothing.
        */
        public function setMaxValue(maxVal:Number):void
        {
            d_maxValue = maxVal;
            
            var oldval:Number = d_value;
            
            // limit current value to be within new max
            if (d_value > d_maxValue) {
                d_value = d_maxValue;
            }
            
            updateThumb();
            
            // send notification if slider value changed.
            if (d_value != oldval)
            {
                var args:WindowEventArgs = new WindowEventArgs(this);
                onValueChanged(args);
            }
        }
        
        
        /*!
        \brief
        set the current slider value.
        
        \param value
        float value specifying the new value for this slider widget.
        
        \return
        Nothing.
        */
        public function setCurrentValue(value:Number):void
        {
            var oldval:Number = d_value;
            
            // range for value: 0 <= value <= maxValue
            d_value = (value >= 0.0) ? ((value <= d_maxValue) ? value : d_maxValue) : 0.0;
            
            updateThumb();
            
            // send notification if slider value changed.
            if (d_value != oldval)
            {
                var args:WindowEventArgs = new WindowEventArgs(this);
                onValueChanged(args);
            }
        }
        
        
        /*!
        \brief
        set the current click step setting for the slider.
        
        The click step size is the amount the slider value will be adjusted when the widget
        is clicked wither side of the slider thumb.
        
        \param step
        float value representing the click step setting to use.
        
        \return
        Nothing.
        */
        public function setClickStep(step:Number):void
        {
            d_step = step;
        }
        
        /*************************************************************************
         Implementation Functions
         *************************************************************************/
        /*!
        \brief
        update the size and location of the thumb to properly represent the current state of the slider
        */
        protected function updateThumb():void
        {
            if (d_windowRenderer != null)
            {
                var wr:SliderWindowRenderer =  d_windowRenderer as SliderWindowRenderer;
                wr.updateThumb();
            }
            else
            {
                //updateThumb_impl();
                throw new Error("Slider::updateThumb - This function must be implemented by the window renderer module");
            }
        }
        
        
        /*!
        \brief
        return value that best represents current slider value given the current location of the thumb.
        
        \return
        float value that, given the thumb widget position, best represents the current value for the slider.
        */
        protected function getValueFromThumb():Number
        {
            if (d_windowRenderer != null)
            {
                var wr:SliderWindowRenderer = d_windowRenderer as SliderWindowRenderer;
                return wr.getValueFromThumb();
            }
            else
            {
                //return getValueFromThumb_impl();
                throw new Error("Slider::getValueFromThumb - This function must be implemented by the window renderer module");
            }
        }
        
        
        /*!
        \brief
        Given window location \a pt, return a value indicating what change should be 
        made to the slider.
        
        \param pt
        Point object describing a pixel position in window space.
        
        \return
        - -1 to indicate slider should be moved to a lower setting.
        -  0 to indicate slider should not be moved.
        - +1 to indicate slider should be moved to a higher setting.
        */
        protected function getAdjustDirectionFromPoint(pt:Vector2):Number
        {
            if (d_windowRenderer != null)
            {
                var wr:SliderWindowRenderer  = d_windowRenderer as SliderWindowRenderer;
                return wr.getAdjustDirectionFromPoint(pt);
            }
            else
            {
                //return getAdjustDirectionFromPoint_impl(pt);
                throw new Error("Slider::getAdjustDirectionFromPoint - This function must be implemented by the window renderer module");
            }
        }
        
        
        /*!
        \brief
        update the size and location of the thumb to properly represent the current state of the slider
        */
        //virtual void    updateThumb_impl(void)   = 0;
        
        
        /*!
        \brief
        return value that best represents current slider value given the current location of the thumb.
        
        \return
        float value that, given the thumb widget position, best represents the current value for the slider.
        */
        //virtual float   getValueFromThumb_impl(void) const   = 0;
        
        
        /*!
        \brief
        Given window location \a pt, return a value indicating what change should be 
        made to the slider.
        
        \param pt
        Point object describing a pixel position in window space.
        
        \return
        - -1 to indicate slider should be moved to a lower setting.
        -  0 to indicate slider should not be moved.
        - +1 to indicate slider should be moved to a higher setting.
        */
        //virtual float   getAdjustDirectionFromPoint_impl(const Point& pt) const  = 0;
        
        /*!
        \brief
        handler function for when thumb moves.
        */
        protected function handleThumbMoved(e:EventArgs):Boolean
        {
            setCurrentValue(getValueFromThumb());
            
            return true;
        }
        
        
        /*!
        \brief
        handler function for when thumb tracking begins
        */
        protected function handleThumbTrackStarted(e:EventArgs):Boolean
        {
            // simply trigger our own version of this event
            var args:WindowEventArgs = new WindowEventArgs(this);
            onThumbTrackStarted(args);
            
            return true;
        }
        
        
        /*!
        \brief
        handler function for when thumb tracking begins
        */
        protected function handleThumbTrackEnded(e:EventArgs):Boolean
        {
            // simply trigger our own version of this event
            var args:WindowEventArgs = new WindowEventArgs(this);
            onThumbTrackEnded(args);
            
            return true;
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
            if (class_name=="Slider")	return true;
            return super.testClassName_impl(class_name);
        }
        
        
        // validate window renderer
        protected function validateWindowRenderer(name:String):Boolean
        {
            return (name == "Slider");
        }
        
        
        /*************************************************************************
         New event handlers for slider widget
         *************************************************************************/
        /*!
        \brief
        Handler triggered when the slider value changes
        */
        protected function onValueChanged(e:WindowEventArgs):void
        {
            fireEvent(EventValueChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler triggered when the user begins to drag the slider thumb. 
        */
        protected function onThumbTrackStarted(e:WindowEventArgs):void
        {
            fireEvent(EventThumbTrackStarted, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler triggered when the slider thumb is released
        */
        protected function onThumbTrackEnded(e:WindowEventArgs):void
        {
            fireEvent(EventThumbTrackEnded, e, EventNamespace);
        }
        
        
        /*************************************************************************
         Overridden event handlers
         *************************************************************************/
        override public function onMouseButtonDown(e:MouseEventArgs):void
        {
            // base class processing
            super.onMouseButtonDown(e);
            
            if (e.button == Consts.MouseButton_LeftButton)
            {
                var adj:Number = getAdjustDirectionFromPoint(e.position);
                
                // adjust slider position in whichever direction as required.
                if (adj != 0)
                {
                    setCurrentValue(d_value + (adj * d_step));
                }
                
                ++e.handled;
            }
        }
        
        
        override public function onMouseWheel(e:MouseEventArgs):void
        {
            // base class processing
            super.onMouseWheel(e);
            
            // scroll by e.wheelChange * stepSize
            setCurrentValue(d_value + d_step * e.wheelChange);
            
            // ensure the message does not go to our parent.
            ++e.handled;
        }
        

        
        /*************************************************************************
         Private methods
         *************************************************************************/
        private function addSliderProperties():void
        {
            addProperty(d_currentValueProperty);
            addProperty(d_clickStepSizeProperty);
            addProperty(d_maximumValueProperty);
        }
        
        
    }
}