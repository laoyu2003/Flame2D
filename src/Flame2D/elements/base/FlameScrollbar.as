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

package Flame2D.elements.base
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.system.FlameEventManager;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Vector2;
    import Flame2D.elements.button.FlameButtonBase;
    import Flame2D.elements.button.FlamePushButton;
    import Flame2D.elements.thumb.FlameThumb;
        
    public class FlameScrollbar extends FlameWindow
    {
        public static const EventNamespace:String = "Scrollbar";
        public static const WidgetTypeName:String = "CEGUI/Scrollbar";
        
        /*************************************************************************
         Event name constants
         *************************************************************************/
        /** Event fired when the scroll bar position value changes.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Scrollbar whose position value had
         * changed.
         */
        public static const EventScrollPositionChanged:String = "ScrollPosChanged";
        /** Event fired when the user begins dragging the scrollbar thumb.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Scrollbar whose thumb is being
         * dragged.
         */
        public static const EventThumbTrackStarted:String = "ThumbTrackStarted";
        /** Event fired when the user releases the scrollbar thumb.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Scrollbar whose thumb has been
         * released.
         */
        public static const EventThumbTrackEnded:String = "ThumbTrackEnded";
        /** Event fired when the scroll bar configuration data is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Scrollbar whose configuration
         * has been changed.
         */
        public static const EventScrollConfigChanged:String = "ScrollConfigChanged";
        
        /*************************************************************************
         Child Widget name suffix constants
         *************************************************************************/
        //! Widget name suffix for the thumb component.
        public static const ThumbNameSuffix:String = "__auto_thumb__";
        //! Widget name suffix for the increase button component.
        public static const IncreaseButtonNameSuffix:String = "__auto_incbtn__";
        //! Widget name suffix for the decrease button component.
        public static const DecreaseButtonNameSuffix:String = "__auto_decbtn__";
        
        
        // Static Properties for this class
        private static var d_documentSizeProperty:ScrollbarPropertyDocumentSize = new ScrollbarPropertyDocumentSize();
        private static var d_pageSizeProperty:ScrollbarPropertyPageSize = new ScrollbarPropertyPageSize();
        private static var d_stepSizeProperty:ScrollbarPropertyStepSize = new ScrollbarPropertyStepSize();
        private static var d_overlapSizeProperty:ScrollbarPropertyOverlapSize = new ScrollbarPropertyOverlapSize();
        private static var d_scrollPositionProperty:ScrollbarPropertyScrollPosition = new ScrollbarPropertyScrollPosition();
        private static var d_endLockEnabledProperty:ScrollbarPropertyEndLockEnabled = new ScrollbarPropertyEndLockEnabled();
        
        
        // Implementation Data
        //! The size of the document / data being scrolled thorugh.
        protected var d_documentSize:Number = 1.0;
        //! The size of a single 'page' of data.
        protected var d_pageSize:Number = 0.0;
        //! Step size used for increase / decrease button clicks.
        protected var d_stepSize:Number = 1.0;
        //! Amount of overlap when jumping by a page.
        protected var d_overlapSize:Number = 0.0;
        //! Current scroll position.
        protected var d_position:Number = 0.0;
        //! whether 'end lock' mode is enabled.
        protected var d_endLockPosition:Boolean = false;
        
        
        
        public function FlameScrollbar(type:String, name:String)
        {
            super(type, name);
            
            addScrollbarProperties();
        }
        
        

        
        /*************************************************************************
         Accessor functions
         *************************************************************************/
        /*!
        \brief
        Return the size of the document or data.
        
        The document size should be thought of as the total size of the data
        that is being scrolled through (the number of lines in a text file for
        example).
        
        \note
        The returned value has no meaning within the Gui system, it is left up
        to the application to assign appropriate values for the application
        specific use of the scroll bar.
        
        \return
        float value specifying the currently set document size.
        */
        public function getDocumentSize():Number
        {
            return d_documentSize;
        }
        
        /*!
        \brief
        Return the page size for this scroll bar.
        
        The page size is typically the amount of data that can be displayed at
        one time.  This value is also used when calculating the amount the
        position will change when you click either side of the scroll bar
        thumb, the amount the position changes will is (pageSize - overlapSize).
        
        \note
        The returned value has no meaning within the Gui system, it is left up
        to the application to assign appropriate values for the application
        specific use of the scroll bar.
        
        \return
        float value specifying the currently set page size.
        */
        public function getPageSize():Number
        {
            return d_pageSize;
        }
        
        /*!
        \brief
        Return the step size for this scroll bar.
        
        The step size is typically a single unit of data that can be displayed,
        this is the amount the position will change when you click either of
        the arrow buttons on the scroll bar.  (this could be 1 for a single
        line of text, for example).
        
        \note
        The returned value has no meaning within the Gui system, it is left up
        to the application to assign appropriate values for the application
        specific use of the scroll bar.
        
        \return
        float value specifying the currently set step size.
        */
        public function getStepSize():Number
        {
            return d_stepSize;
        }
        
        /*!
        \brief
        Return the overlap size for this scroll bar.
        
        The overlap size is the amount of data from the end of a 'page' that
        will remain visible when the position is moved by a page.  This is
        usually used so that the user keeps some context of where they were
        within the document's data when jumping a page at a time.
        
        \note
        The returned value has no meaning within the Gui system, it is left up
        to the application to assign appropriate values for the application
        specific use of the scroll bar.
        
        \return
        float value specifying the currently set overlap size.
        */
        public function getOverlapSize():Number
        {
            return d_overlapSize;
        }
        
        /*!
        \brief
        Return the current position of scroll bar within the document.
        
        The range of the scroll bar is from 0 to the size of the document minus
        the size of a page (0 <= position <= (documentSize - pageSize)).
        
        \note
        The returned value has no meaning within the Gui system, it is left up
        to the application to assign appropriate values for the application
        specific use of the scroll bar.
        
        \return
        float value specifying the current position of the scroll bar within its
        document.
        */
        public function getScrollPosition():Number
        {
            return d_position;
        }
        
        /*!
        \brief
        Return a pointer to the 'increase' PushButtoncomponent widget for this
        Scrollbar.
        
        \return
        Pointer to a PushButton object.
        
        \exception UnknownObjectException
        Thrown if the increase PushButton component does not exist.
        */
        public function getIncreaseButton():FlamePushButton
        {
            return FlameWindowManager.getSingleton().getWindow(
                getName() + IncreaseButtonNameSuffix) as FlamePushButton;
        }
        
        /*!
        \brief
        Return a pointer to the 'decrease' PushButton component widget for this
        Scrollbar.
        
        \return
        Pointer to a PushButton object.
        
        \exception UnknownObjectException
        Thrown if the 'decrease' PushButton component does not exist.
        */
        public function getDecreaseButton():FlamePushButton
        {
            return FlameWindowManager.getSingleton().getWindow(
                getName() + DecreaseButtonNameSuffix) as FlamePushButton;
        }
        
        /*!
        \brief
        Return a pointer to the Thumb component widget for this Scrollbar.
        
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
         Manipulator Commands
         *************************************************************************/
        /*!
        \brief
        Initialises the Scrollbar object ready for use.
        
        \note
        This must be called for every window created.  Normally this is handled
        automatically by the WindowFactory for each Window type.
        
        \return
        Nothing
        */
        override public function initialiseComponents():void
        {
            // Set up thumb
            const t:FlameThumb = getThumb();
            t.subscribeEvent(FlameThumb.EventThumbPositionChanged, new Subscriber(handleThumbMoved, this), FlameThumb.EventNamespace);
            t.subscribeEvent(FlameThumb.EventThumbTrackStarted, new Subscriber(handleThumbTrackStarted, this), FlameThumb.EventNamespace);
            t.subscribeEvent(FlameThumb.EventThumbTrackEnded, new Subscriber(handleThumbTrackEnded, this), FlameThumb.EventNamespace);
            
            // set up Increase button
            getIncreaseButton().subscribeEvent(FlameWindow.EventMouseButtonDown, new Subscriber(handleIncreaseClicked, this), FlameWindow.EventNamespace);
            // set up Decrease button
            getDecreaseButton().subscribeEvent(FlameWindow.EventMouseButtonDown, new Subscriber(handleDecreaseClicked, this), FlameWindow.EventNamespace);

            // do initial layout
            performChildWindowLayout();
            
        }
        
        /*!
        \brief
        Set the size of the document or data.
        
        The document size should be thought of as the total size of the data
        that is being scrolled through (the number of lines in a text file for
        example).
        
        \note
        The value set has no meaning within the Gui system, it is left up to
        the application to assign appropriate values for the application
        specific use of the scroll bar.
        
        \param document_size
        float value specifying the document size.
        
        \return
        Nothing.
        */
        public function setDocumentSize(document_size:Number):void
        {
            if (d_documentSize != document_size)
            {
                const reset_max_position:Boolean = d_endLockPosition && isAtEnd();
                
                d_documentSize = document_size;
                
                if (reset_max_position)
                    setScrollPosition(getMaxScrollPosition());
                else
                    updateThumb();
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onScrollConfigChanged(args);
            }
        }
        
        /*!
        \brief
        Set the page size for this scroll bar.
        
        The page size is typically the amount of data that can be displayed at
        one time.  This value is also used when calculating the amount the
        position will change when you click either side of the scroll bar
        thumb, the amount the position changes will is (pageSize - overlapSize).
        
        \note
        The value set has no meaning within the Gui system, it is left up to the
        application to assign appropriate values for the application specific
        use of the scroll bar.
        
        \param page_size
        float value specifying the page size.
        
        \return
        Nothing.
        */
        public function setPageSize(page_size:Number):void
        {
            if (d_pageSize != page_size)
            {
                const reset_max_position:Boolean = d_endLockPosition && isAtEnd();
                
                d_pageSize = page_size;
                
                if (reset_max_position)
                    setScrollPosition(getMaxScrollPosition());
                else
                    updateThumb();
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onScrollConfigChanged(args);
            }
        }
        
        /*!
        \brief
        Set the step size for this scroll bar.
        
        The step size is typically a single unit of data that can be displayed,
        this is the amount the position will change when you click either of the
        arrow buttons on the scroll bar.  (this could be 1 for a single line of
        text, for example).
        
        \note
        The value set has no meaning within the Gui system, it is left up to the
        application to assign appropriate values for the application specific
        use of the scroll bar.
        
        \param step_size
        float value specifying the step size.
        
        \return
        Nothing.
        */
        public function setStepSize(step_size:Number):void
        {
            if (d_stepSize != step_size)
            {
                d_stepSize = step_size;
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onScrollConfigChanged(args);
            }
        }
        
        /*!
        \brief
        Set the overlap size for this scroll bar.
        
        The overlap size is the amount of data from the end of a 'page' that
        will remain visible when the position is moved by a page.  This is
        usually used so that the user keeps some context of where they were
        within the document's data when jumping a page at a time.
        
        \note
        The value set has no meaning within the Gui system, it is left up to the
        application to assign appropriate values for the application specific
        use of the scroll bar.
        
        \param overlap_size
        float value specifying the overlap size.
        
        \return
        Nothing.
        */
        public function setOverlapSize(overlap_size:Number):void
        {
            if (d_overlapSize != overlap_size)
            {
                d_overlapSize = overlap_size;
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onScrollConfigChanged(args);
            }
        }
        
        /*!
        \brief
        Set the current position of scroll bar within the document.
        
        The range of the scroll bar is from 0 to the size of the document minus
        the size of a page (0 <= position <= (documentSize - pageSize)), any
        attempt to set the position outside this range will be adjusted so that
        it falls within the legal range.
        
        \note
        The returned value has no meaning within the Gui system, it is left up
        to the application to assign appropriate values for the application
        specific use of the scroll bar.
        
        \param position
        float value specifying the position of the scroll bar within its
        document.
        
        \return
        Nothing.
        */
        public function setScrollPosition(position:Number):void
        {
            const modified:Boolean = setScrollPosition_impl(position);
            updateThumb();
            
            // notification if required
            if (modified)
            {
                var args:WindowEventArgs = new WindowEventArgs(this);
                onScrollPositionChanged(args);
            }
        }
        
        /*!
        \brief
        Sets multiple scrollbar configuration parameters simultaneously.
        
        This function is provided in order to be able to minimise the number
        of internal state updates that occur when modifying the scrollbar
        parameters.
        
        \param document_size
        Pointer to a float value holding the new value to be used for the
        scroll bar document size.  If this is 0 the document size is left
        unchanged.
        
        \param page_size
        Pointer to a float value holding the new value to be used for the scroll
        bar page size.  If this is 0 the page size is left unchanged.
        
        \param step_size
        Pointer to a float value holding the new value to be used for the scroll
        bar step size.  If this is 0 the step size is left unchanged.
        
        \param overlap_size
        Pointer to a float value holding the new value to be used for the scroll
        bar overlap size.  If this is 0 then overlap size is left unchanged.
        
        \param position
        Pointer to a float value holding the new value to be used for the scroll
        bar current scroll position.  If this is 0 then the current position is
        left unchanged.
        
        \note
        Even if \a position is 0, the scrollbar position may still change
        depending on how the other changes affect the scrollbar.
        */
        public function setConfig(document_size:Number, page_size:Number,
            step_size:Number, overlap_size:Number, position:Number):void
        {
            const reset_max_position:Boolean = d_endLockPosition && isAtEnd();
            var config_changed:Boolean = false;
            var position_changed:Boolean = false;
            
            if (document_size && (d_documentSize != document_size))
            {
                d_documentSize = document_size;
                config_changed = true;
            }
            
            if (page_size && (d_pageSize != page_size))
            {
                d_pageSize = page_size;
                config_changed = true;
            }
            
            if (step_size && (d_stepSize != step_size))
            {
                d_stepSize = step_size;
                config_changed = true;
            }
            
            if (overlap_size && (d_overlapSize != overlap_size))
            {
                d_overlapSize = overlap_size;
                config_changed = true;
            }
            
            if (position)
                position_changed = setScrollPosition_impl(position);
            else if (reset_max_position)
                position_changed = setScrollPosition_impl(getMaxScrollPosition());
            
            // _always_ update the thumb to keep things in sync.  (though this
            // can cause a double-trigger of EventScrollPositionChanged, which
            // also happens with setScrollPosition anyway).
            updateThumb();
            
            //
            // Fire appropriate events based on actions we took.
            //
            if (config_changed)
            {
                var cargs:WindowEventArgs = new WindowEventArgs(this);
                onScrollConfigChanged(cargs);
            }
            
            if (position_changed)
            {
                var pargs:WindowEventArgs = new WindowEventArgs(this);
                onScrollPositionChanged(pargs);
            }
        }
        
        /*!
        \brief
        Enable or disable the 'end lock' mode for the scrollbar.
        
        When enabled and the current position of the scrollbar is at the end of
        it's travel, the end lock mode of the scrollbar will automatically
        update the position when the document and/or page size change in order
        that the scroll position will remain at the end of it's travel.  This
        can be used to implement auto-scrolling in certain other widget types.
        
        \param enabled
        - true to indicate that end lock mode should be enabled.
        - false to indicate that end lock mode should be disabled.
        */
        public function setEndLockEnabled(enabled:Boolean):void
        {
            d_endLockPosition = enabled;
        }
        
        /*!
        \brief
        Returns whether the 'end lock'mode for the scrollbar is enabled.
        
        When enabled, and the current position of the scrollbar is at the end of
        it's travel, the end lock mode of the scrollbar will automatically
        update the scrollbar position when the document and/or page size change
        in order that the scroll position will remain at the end of it's travel.
        This can be used to implement auto-scrolling in certain other widget
        types.
        
        \return
        - true to indicate that the end lock mode is enabled.
        - false to indicate that the end lock mode is disabled.
        */
        public function isEndLockEnabled():Boolean
        {
            return d_endLockPosition;
        }
        
        /*!
        \brief
        update the size and location of the thumb to properly represent the
        current state of the scroll bar
        */
        protected function updateThumb():void
        {
            if (!d_windowRenderer)
                throw new Error("Scrollbar::updateThumb: This " +
                    "function must be implemented by the window renderer object (no " +
                    "window renderer is assigned.)");
            
            (d_windowRenderer as ScrollbarWindowRenderer).updateThumb();
        }
        
        /*!
        \brief
        return value that best represents current scroll bar position given the
        current location of the thumb.
        
        \return
        float value that, given the thumb widget position, best represents the
        current position for the scroll bar.
        */
        protected function getValueFromThumb():Number
        {
            if (!d_windowRenderer)
                throw new Error("Scrollbar::getValueFromThumb: This " +
                    "function must be implemented by the window renderer object (no " +
                    "window renderer is assigned.)");
            
            return (d_windowRenderer as ScrollbarWindowRenderer).getValueFromThumb();
        }
        
        /*!
        \brief
        Given window location \a pt, return a value indicating what change
        should be made to the scroll bar.
        
        \param pt
        Point object describing a pixel position in window space.
        
        \return
        - -1 to indicate scroll bar position should be moved to a lower value.
        -  0 to indicate scroll bar position should not be changed.
        - +1 to indicate scroll bar position should be moved to a higher value.
        */
        protected function getAdjustDirectionFromPoint(pt:Vector2):Number
        {
            if (!d_windowRenderer)
                throw new Error(
                    "Scrollbar::getAdjustDirectionFromPoint: " +
                    "This function must be implemented by the window renderer object " +
                    "(no window renderer is assigned.)");
            
            return (d_windowRenderer as ScrollbarWindowRenderer).getAdjustDirectionFromPoint(pt);
        }
        
        /** implementation func that updates scroll position value, returns true if
         * value was changed.  NB: Fires no events and does no other updates.
         */
        protected function setScrollPosition_impl(position:Number):Boolean
        {
            const old_pos:Number = d_position;
            const max_pos:Number = getMaxScrollPosition();
            
            // limit position to valid range:  0 <= position <= max_pos
            d_position = (position >= 0) ?
                ((position <= max_pos) ?
                    position :
                    max_pos) :
                0.0;
            
            return d_position != old_pos;
        }
        
        //! return whether the current scroll position is at the end of the range.
        protected function isAtEnd():Boolean
        {
            return d_position >= getMaxScrollPosition(); 
        }
        
        //! return the max allowable scroll position value
        protected function getMaxScrollPosition():Number
        {
            // max position is (docSize - pageSize)
            // but must be at least 0 (in case doc size is very small)
            return Math.max((d_documentSize - d_pageSize), 0.0);
        }
        
        //! handler function for when thumb moves.
        protected function handleThumbMoved(e:EventArgs):Boolean
        {
            // adjust scroll bar position as required.
            setScrollPosition(getValueFromThumb());
            
            return true;
        }
        
        //! handler function for when the increase button is clicked.
        protected function handleIncreaseClicked(e:EventArgs):Boolean
        {
            if ((e as MouseEventArgs).button == Consts.MouseButton_LeftButton)
            {
                // adjust scroll bar position as required.
                setScrollPosition(d_position + d_stepSize);
                
                return true;
            }
            return false;
        }
        
        //! handler function for when the decrease button is clicked.
        protected function handleDecreaseClicked(e:EventArgs):Boolean
        {
            if ((e as MouseEventArgs).button == Consts.MouseButton_LeftButton)
            {
                // adjust scroll bar position as required.
                setScrollPosition(d_position - d_stepSize);
                
                return true;
            }
            
            return false;
        }
        
        //! handler function for when thumb tracking begins
        protected function handleThumbTrackStarted(e:EventArgs):Boolean
        {
            // simply trigger our own version of this event
            var args:WindowEventArgs = new WindowEventArgs(this);
            onThumbTrackStarted(args);
            
            return true;
        }
        
        //! handler function for when thumb tracking begins
        protected function handleThumbTrackEnded(e:EventArgs):Boolean
        {
            // simply trigger our own version of this event
            var args:WindowEventArgs = new WindowEventArgs(this);
            onThumbTrackEnded(args);
            
            return true;
        }
        
        /*!
        \brief
        Return whether this window was inherited from the given class name at
        some point in the inheritance hierarchy.
        
        \param class_name
        The class name that is to be checked.
        
        \return
        true if this window was inherited from \a class_name. false if not.
        */
        override protected function testClassName_impl(class_name:String):Boolean
        {
            if (class_name == "Scrollbar")    return true;
            
            return super.testClassName_impl(class_name);
        }
        
        //! validate window renderer
        protected function validateWindowRenderer(name:String):Boolean
        {
            return (name == "Scrollbar");
        }
        
        // New event handlers for slider widget
        //! Handler triggered when the scroll position changes
        protected function onScrollPositionChanged(e:WindowEventArgs):void
        {
            fireEvent(EventScrollPositionChanged, e, EventNamespace);
        }
        
        //! Handler triggered when the user begins to drag the scroll bar thumb.
        protected function onThumbTrackStarted(e:WindowEventArgs):void
        {
            fireEvent(EventThumbTrackStarted, e, EventNamespace);
        }
        
        //! Handler triggered when the scroll bar thumb is released
        protected function onThumbTrackEnded(e:WindowEventArgs):void
        {
            fireEvent(EventThumbTrackEnded, e, EventNamespace);
        }
        
        //! Handler triggered when the scroll bar data configuration changes
        protected function onScrollConfigChanged(e:WindowEventArgs):void
        {
            performChildWindowLayout();
            fireEvent(EventScrollConfigChanged, e, EventNamespace);
        }
        
        // Overridden event handlers
        override public function onMouseButtonDown(e:MouseEventArgs):void
        {
            // base class processing
            super.onMouseButtonDown(e);
            
            if (e.button == Consts.MouseButton_LeftButton)
            {
                const adj:Number = getAdjustDirectionFromPoint(e.position);
                
                // adjust scroll bar position in whichever direction as required.
                if (adj != 0)
                    setScrollPosition(
                        d_position + ((d_pageSize - d_overlapSize) * adj));
                
                ++e.handled;
            }
        }
        
        override public function onMouseWheel(e:MouseEventArgs):void
        {
            // base class processing
            super.onMouseWheel(e);
            
            // scroll by e.wheelChange * stepSize
            setScrollPosition(d_position + d_stepSize * -e.wheelChange);
            
            // ensure the message does not go to our parent.
            ++e.handled;
        }
        


        //! Adds scrollbar specific properties.
        private function addScrollbarProperties():void
        {
            addProperty(d_documentSizeProperty);
            addProperty(d_pageSizeProperty);
            addProperty(d_stepSizeProperty);
            addProperty(d_overlapSizeProperty);
            addProperty(d_scrollPositionProperty);
            addProperty(d_endLockEnabledProperty);

            /*
            // we ban all these properties from xml for auto windows
            if (isAutoWindow())
            {
                banPropertyFromXML(&d_documentSizeProperty);
                banPropertyFromXML(&d_pageSizeProperty);
                banPropertyFromXML(&d_stepSizeProperty);
                banPropertyFromXML(&d_overlapSizeProperty);
                banPropertyFromXML(&d_scrollPositionProperty);
                
                // scrollbars tend to have their visibility toggled alot, so we ban
                // that as well
                banPropertyFromXML(&d_visibleProperty);
            }
            */
        }
    }
}