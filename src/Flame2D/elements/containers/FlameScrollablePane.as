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
package Flame2D.elements.containers
{
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.UVector2;
    import Flame2D.elements.base.FlameScrollbar;

    /*!
    \brief
    Base class for the ScrollablePane widget.
    
    The ScrollablePane widget allows child windows to be attached which cover an
    area larger than the ScrollablePane itself and these child windows can be
    scrolled into view using the scrollbars of the scrollable pane.
    */
    public class FlameScrollablePane extends FlameWindow
    {
        public static const EventNamespace:String = "ScrollablePane";
        public static const WidgetTypeName:String = "CEGUI/ScrollablePane";
        
        /** Event fired when an area on the content pane has been updated.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ScrollablePane whose content pane
         * has been updated.
         */
        public static const EventContentPaneChanged:String = "ContentPaneChanged";
        /** Event fired when the vertical scroll bar 'force' setting is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ScrollablePane whose vertical scroll
         * bar mode has been changed.
         */
        public static const EventVertScrollbarModeChanged:String = "VertScrollbarModeChanged";
        /** Event fired when the horizontal scroll bar 'force' setting is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ScrollablePane whose horizontal scroll
         * bar mode has been changed.
         */
        public static const EventHorzScrollbarModeChanged:String = "HorzScrollbarModeChanged";
        /** Event fired when the auto size setting for the pane is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ScrollablePane whose auto size
         * setting has been changed.
         */
        public static const EventAutoSizeSettingChanged:String = "AutoSizeSettingChanged";
        /** Event fired when the pane gets scrolled.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ScrollablePane that has been scrolled.
         */
        public static const EventContentPaneScrolled:String = "ContentPaneScrolled";
        //! Widget name suffix for the vertical scrollbar component.
        public static const VertScrollbarNameSuffix:String = "__auto_vscrollbar__";
        //! Widget name suffix for the horizontal scrollbar component.
        public static const HorzScrollbarNameSuffix:String = "__auto_hscrollbar__";
        //! Widget name suffix for the scrolled container component.
        public static const ScrolledContainerNameSuffix:String = "__auto_container__";
        
        
        private static var d_horzScrollbarProperty:ScrollablePanePropertyForceHorzScrollbar = new ScrollablePanePropertyForceHorzScrollbar();
        private static var d_vertScrollbarProperty:ScrollablePanePropertyForceVertScrollbar = new ScrollablePanePropertyForceVertScrollbar();
        private static var d_autoSizedProperty:ScrollablePanePropertyContentPaneAutoSized = new ScrollablePanePropertyContentPaneAutoSized();
        private static var d_contentAreaProperty:ScrollablePanePropertyContentArea = new ScrollablePanePropertyContentArea();
        private static var d_horzStepProperty:ScrollablePanePropertyHorzStepSize = new ScrollablePanePropertyHorzStepSize();
        private static var d_horzOverlapProperty:ScrollablePanePropertyHorzOverlapSize = new ScrollablePanePropertyHorzOverlapSize();
        private static var d_horzScrollPositionProperty:ScrollablePanePropertyHorzScrollPosition = new ScrollablePanePropertyHorzScrollPosition();
        private static var d_vertStepProperty:ScrollablePanePropertyVertStepSize = new ScrollablePanePropertyVertStepSize();
        private static var d_vertOverlapProperty:ScrollablePanePropertyVertOverlapSize = new ScrollablePanePropertyVertOverlapSize();
        private static var d_vertScrollPositionProperty:ScrollablePanePropertyVertScrollPosition = new ScrollablePanePropertyVertScrollPosition();

        //! true if vertical scrollbar should always be displayed
        protected var d_forceVertScroll:Boolean = false;
        //! true if horizontal scrollbar should always be displayed
        protected var d_forceHorzScroll:Boolean = false;
        //! holds content area so we can track changes.
        protected var d_contentRect:Rect = new Rect(0,0,0,0);
        //! vertical scroll step fraction.
        protected var d_vertStep:Number = 0.1;
        //! vertical scroll overlap fraction.
        protected var d_vertOverlap:Number = 0.01;
        //! horizontal scroll step fraction.
        protected var d_horzStep:Number = 0.1;
        //! horizontal scroll overlap fraction.
        protected var d_horzOverlap:Number = 0.01;
        //! Event connection to content pane
        //Event::Connection d_contentChangedConn;
        //! Event connection to content pane
        //Event::Connection d_autoSizeChangedConn;
        

        
        public function FlameScrollablePane(type:String, name:String)
        {
            super(type, name);
            
            addScrollablePaneProperties();
            
            // create scrolled container widget
            var container:FlameScrolledContainer = FlameWindowManager.getSingleton().createWindow(
                    FlameScrolledContainer.WidgetTypeName,
                    d_name + ScrolledContainerNameSuffix) as FlameScrolledContainer;
            
            // add scrolled container widget as child
            addChildWindow(container);
        }
        
        /*!
        \brief
        Returns a pointer to the window holding the pane contents.
        
        The purpose of this is so that attached windows may be inspected,
        client code may not modify the returned window in any way.
        
        \return
        Pointer to the ScrolledContainer that is acting as the container for the
        scrollable pane content.  The returned window is const, client code
        should not modify the ScrolledContainer settings directly.
        */
        public function getContentPane():FlameScrolledContainer
        {
            return getScrolledContainer();
        }
        
        /*!
        \brief
        Return whether the vertical scroll bar is always shown.
        
        \return
        - true if the scroll bar will be shown even if it is not required.
        - false if the scroll bar will only be shown when it is required.
        */
        public function isVertScrollbarAlwaysShown():Boolean
        {
            return d_forceVertScroll;
        }
        
        /*!
        \brief
        Set whether the vertical scroll bar should always be shown.
        
        \param setting
        - true if the vertical scroll bar should be shown even when it is not
        required.
        - false if the vertical scroll bar should only be shown when it is
        required.
        
        \return
        Nothing.
        */
        public function setShowVertScrollbar(setting:Boolean):void
        {
            if (d_forceVertScroll != setting)
            {
                d_forceVertScroll = setting;
                
                configureScrollbars();
                var args:WindowEventArgs = new WindowEventArgs(this);
                onVertScrollbarModeChanged(args);
            }
        }
        
        /*!
        \brief
        Return whether the horizontal scroll bar is always shown.
        
        \return
        - true if the scroll bar will be shown even if it is not required.
        - false if the scroll bar will only be shown when it is required.
        */
        public function isHorzScrollbarAlwaysShown():Boolean
        {
            return d_forceHorzScroll;
        }
        
        /*!
        \brief
        Set whether the horizontal scroll bar should always be shown.
        
        \param setting
        - true if the horizontal scroll bar should be shown even when it is not
        required.
        - false if the horizontal scroll bar should only be shown when it is
        required.
        
        \return
        Nothing.
        */
        public function setShowHorzScrollbar(setting:Boolean):void
        {
            if (d_forceHorzScroll != setting)
            {
                d_forceHorzScroll = setting;
                
                configureScrollbars();
                var args:WindowEventArgs = new WindowEventArgs(this);
                onHorzScrollbarModeChanged(args);
            }
        }
        
        /*!
        \brief
        Return whether the content pane is auto sized.
        
        \return
        - true to indicate the content pane will automatically resize itself.
        - false to indicate the content pane will not automatically resize
        itself.
        */
        public function isContentPaneAutoSized():Boolean
        {
            return getScrolledContainer().isContentPaneAutoSized();
        }
        
        /*!
        \brief
        Set whether the content pane should be auto-sized.
        
        \param setting
        - true to indicate the content pane should automatically resize itself.
        - false to indicate the content pane should not automatically resize
        itself.
        
        \return 
        Nothing.
        */
        public function setContentPaneAutoSized(setting:Boolean):void
        {
            getScrolledContainer().setContentPaneAutoSized(setting);
        }
        
        /*!
        \brief
        Return the current content pane area for the ScrollablePane.
        
        \return
        Rect object that details the current pixel extents of the content
        pane attached to this ScrollablePane.
        */
        public function getContentPaneArea():Rect
        {
            return getScrolledContainer().getContentArea();
        }
        
        /*!
        \brief
        Set the current content pane area for the ScrollablePane.
        
        \note
        If the ScrollablePane is configured to auto-size the content pane
        this call will have no effect.
        
        \param area
        Rect object that details the pixel extents to use for the content
        pane attached to this ScrollablePane.
        
        \return
        Nothing.
        */
        public function setContentPaneArea(area:Rect):void
        {
            getScrolledContainer().setContentArea(area);
        }
        
        /*!
        \brief
        Returns the horizontal scrollbar step size as a fraction of one
        complete view page.
        
        \return
        float value specifying the step size where 1.0f would be the width of
        the viewing area.
        */
        public function getHorizontalStepSize():Number
        {
            return d_horzStep;
        }
        
        /*!
        \brief
        Sets the horizontal scrollbar step size as a fraction of one
        complete view page.
        
        \param step
        float value specifying the step size, where 1.0f would be the width of
        the viewing area.
        
        \return
        Nothing.
        */
        public function setHorizontalStepSize(step:Number):void
        {
            d_horzStep = step;
            configureScrollbars();
        }
        
        /*!
        \brief
        Returns the horizontal scrollbar overlap size as a fraction of one
        complete view page.
        
        \return
        float value specifying the overlap size where 1.0f would be the width of
        the viewing area.
        */
        public function getHorizontalOverlapSize():Number
        {
            return d_horzOverlap;
        }
        
        /*!
        \brief
        Sets the horizontal scrollbar overlap size as a fraction of one
        complete view page.
        
        \param overlap
        float value specifying the overlap size, where 1.0f would be the width
        of the viewing area.
        
        \return
        Nothing.
        */
        public function setHorizontalOverlapSize(overlap:Number):void
        {
            d_horzOverlap = overlap;
            configureScrollbars();
        }
        
        /*!
        \brief
        Returns the horizontal scroll position as a fraction of the
        complete scrollable width.
        
        \return
        float value specifying the scroll position.
        */
        public function getHorizontalScrollPosition():Number
        {
            var horzScrollbar:FlameScrollbar = getHorzScrollbar();
            var docSz:Number = horzScrollbar.getDocumentSize();
            return (docSz != 0) ? horzScrollbar.getScrollPosition() / docSz : 0.0;
        }
        
        /*!
        \brief
        Sets the horizontal scroll position as a fraction of the
        complete scrollable width.
        
        \param position
        float value specifying the new scroll position.
        
        \return
        Nothing.
        */
        public function setHorizontalScrollPosition(position:Number):void
        {
            var horzScrollbar:FlameScrollbar = getHorzScrollbar();
            horzScrollbar.setScrollPosition(
                horzScrollbar.getDocumentSize() * position);
        }
        
        /*!
        \brief
        Returns the vertical scrollbar step size as a fraction of one
        complete view page.
        
        \return
        float value specifying the step size where 1.0f would be the height of
        the viewing area.
        */
        public function getVerticalStepSize():Number
        {
            return d_vertStep;
        }
        
        /*!
        \brief
        Sets the vertical scrollbar step size as a fraction of one
        complete view page.
        
        \param step
        float value specifying the step size, where 1.0f would be the height of
        the viewing area.
        
        \return
        Nothing.
        */
        public function setVerticalStepSize(step:Number):void
        {
            d_vertStep = step;
            configureScrollbars();
        }
        
        /*!
        \brief
        Returns the vertical scrollbar overlap size as a fraction of one
        complete view page.
        
        \return
        float value specifying the overlap size where 1.0f would be the height
        of the viewing area.
        */
        public function getVerticalOverlapSize():Number
        {
            return d_vertOverlap;
        }
        
        /*!
        \brief
        Sets the vertical scrollbar overlap size as a fraction of one
        complete view page.
        
        \param overlap
        float value specifying the overlap size, where 1.0f would be the height
        of the viewing area.
        
        \return
        Nothing.
        */
        public function setVerticalOverlapSize(overlap:Number):void
        {
            d_vertOverlap = overlap;
            configureScrollbars();
        }
        
        /*!
        \brief
        Returns the vertical scroll position as a fraction of the
        complete scrollable height.
        
        \return
        float value specifying the scroll position.
        */
        public function getVerticalScrollPosition():Number
        {
            var vertScrollbar:FlameScrollbar = getVertScrollbar();
            var docSz:Number = vertScrollbar.getDocumentSize();
            return (docSz != 0) ? vertScrollbar.getScrollPosition() / docSz : 0.0;
        }
        
        /*!
        \brief
        Sets the vertical scroll position as a fraction of the
        complete scrollable height.
        
        \param position
        float value specifying the new scroll position.
        
        \return
        Nothing.
        */
        public function setVerticalScrollPosition(position:Number):void
        {
            var vertScrollbar:FlameScrollbar = getVertScrollbar();
            vertScrollbar.setScrollPosition(
                vertScrollbar.getDocumentSize() * position);
        }
        
        /*!
        \brief
        Return a Rect that described the pane's viewable area, relative
        to this Window, in pixels.
        
        \return
        Rect object describing the ScrollablePane's viewable area.
        */
        public function getViewableArea():Rect
        {
            if (!d_windowRenderer)
                throw new Error("ScrollablePane::getViewableArea: " +
                    "This function must be implemented by the window renderer module");
            
            var wr:ScrollablePaneWindowRenderer = d_windowRenderer as ScrollablePaneWindowRenderer;
            return wr.getViewableArea();
        }
        
        /*!
        \brief
        Return a pointer to the vertical scrollbar component widget for this
        ScrollablePane.
        
        \return
        Pointer to a Scrollbar object.
        
        \exception UnknownObjectException
        Thrown if the vertical Scrollbar component does not exist.
        */
        public function getVertScrollbar():FlameScrollbar
        {
            return FlameWindowManager.getSingleton().getWindow(
                    getName() + VertScrollbarNameSuffix) as FlameScrollbar;
        }
        
        /*!
        \brief
        Return a pointer to the horizontal scrollbar component widget for
        this ScrollablePane.
        
        \return
        Pointer to a Scrollbar object.
        
        \exception UnknownObjectException
        Thrown if the horizontal Scrollbar component does not exist.
        */
        public function getHorzScrollbar():FlameScrollbar
        {
            return FlameWindowManager.getSingleton().getWindow(
                    getName() + HorzScrollbarNameSuffix) as FlameScrollbar;
        }
        
        // Overridden from Window
        override public function initialiseComponents():void
        {
            // get horizontal scrollbar
            var horzScrollbar:FlameScrollbar = getHorzScrollbar();
            
            // get vertical scrollbar
            var vertScrollbar:FlameScrollbar = getVertScrollbar();
            
            // get scrolled container widget
            var container:FlameScrolledContainer = getScrolledContainer();
            
            // do a bit of initialisation
            horzScrollbar.setAlwaysOnTop(true);
            vertScrollbar.setAlwaysOnTop(true);
            // container pane is always same size as this parent pane,
            // scrolling is actually implemented via positioning and clipping tricks.
            container.setSize(new UVector2(Misc.cegui_reldim(1.0), Misc.cegui_reldim(1.0)));
            
            // subscribe to events we need to hear about
            vertScrollbar.subscribeEvent(FlameScrollbar.EventScrollPositionChanged, new Subscriber(handleScrollChange, this), FlameScrollbar.EventNamespace);
            
            horzScrollbar.subscribeEvent(FlameScrollbar.EventScrollPositionChanged, new Subscriber(handleScrollChange, this), FlameScrollbar.EventNamespace);
            
//            d_contentChangedConn = container->subscribeEvent(
//                ScrolledContainer::EventContentChanged,
//                Event::Subscriber(&ScrollablePane::handleContentAreaChange, this));
//            
//            d_autoSizeChangedConn = container->subscribeEvent(
//                ScrolledContainer::EventAutoSizeSettingChanged,
//                Event::Subscriber(&ScrollablePane::handleAutoSizePaneChanged, this));

            container.subscribeEvent(FlameScrolledContainer.EventContentChanged, new Subscriber(handleContentAreaChange, this), FlameScrolledContainer.EventNamespace);
            container.subscribeEvent(FlameScrolledContainer.EventAutoSizeSettingChanged, new Subscriber(handleAutoSizePaneChanged, this), FlameScrolledContainer.EventNamespace);
            // finalise setup
            configureScrollbars();
        }
        
        
        override public function destroy():void
        {
            // detach from events on content pane
//            d_contentChangedConn->disconnect();
//            d_autoSizeChangedConn->disconnect();
            
            // now do the cleanup
            super.destroy();
        }
        
        /*!
        \brief
        display required integrated scroll bars according to current size of
        the ScrollablePane view area and the size of the attached
        ScrolledContainer.
        */
        protected function configureScrollbars():void
        {
            // controls should all be valid by this stage
            var vertScrollbar:FlameScrollbar = getVertScrollbar();
            var horzScrollbar:FlameScrollbar = getHorzScrollbar();
            
            // enable required scrollbars
            vertScrollbar.setVisible(isVertScrollbarNeeded());
            horzScrollbar.setVisible(isHorzScrollbarNeeded());
            
            // Check if the addition of the horizontal scrollbar means we
            // now also need the vertical bar.
            if (horzScrollbar.isVisible())
            {
                vertScrollbar.setVisible(isVertScrollbarNeeded());
            }
            
            performChildWindowLayout();
            
            // get viewable area
            var viewableArea:Rect = getViewableArea();
            
            // set up vertical scroll bar values
            vertScrollbar.setDocumentSize(Math.abs(d_contentRect.getHeight()));
            vertScrollbar.setPageSize(viewableArea.getHeight());
            vertScrollbar.setStepSize(Math.max(1.0, viewableArea.getHeight() * d_vertStep));
            vertScrollbar.setOverlapSize(Math.max(1.0, viewableArea.getHeight() * d_vertOverlap));
            vertScrollbar.setScrollPosition(vertScrollbar.getScrollPosition());
            
            // set up horizontal scroll bar values
            horzScrollbar.setDocumentSize(Math.abs(d_contentRect.getWidth()));
            horzScrollbar.setPageSize(viewableArea.getWidth());
            horzScrollbar.setStepSize(Math.max(1.0, viewableArea.getWidth() * d_horzStep));
            horzScrollbar.setOverlapSize(Math.max(1.0, viewableArea.getWidth() * d_horzOverlap));
            horzScrollbar.setScrollPosition(horzScrollbar.getScrollPosition());
        }
        
        /*!
        \brief
        Return whether the vertical scrollbar is needed.
        
        \return
        - true if the scrollbar is either needed or forced via setting.
        - false if the scrollbar should not be shown.
        */
        protected function isVertScrollbarNeeded():Boolean
        {
            return ((Math.abs(d_contentRect.getWidth()) > getViewableArea().getWidth()) ||
                d_forceHorzScroll);
        }
        
        /*!
        \brief
        Return whether the horizontal scrollbar is needed.
        
        \return
        - true if the scrollbar is either needed or forced via setting.
        - false if the scrollbar should not be shown.
        */
        protected function isHorzScrollbarNeeded():Boolean
        {
            return ((Math.abs(d_contentRect.getHeight()) > getViewableArea().getHeight()) ||
                d_forceVertScroll);
        }
        
        /*!
        \brief
        Update the content container position according to the current 
        state of the widget (like scrollbar positions, etc).
        */
        protected function updateContainerPosition():void
        {
            // basePos is the position represented by the scrollbars
            // (these are negated so pane is scrolled in the correct directions)
            var basePos:UVector2 = new UVector2(Misc.cegui_absdim(-getHorzScrollbar().getScrollPosition()),
                Misc.cegui_absdim(-getVertScrollbar().getScrollPosition()));
            
            // this bias is the absolute position that 0 on the scrollbars represent.
            // Allows the pane to function correctly with negatively positioned content.
            var bias:UVector2 = new UVector2(Misc.cegui_absdim(d_contentRect.d_left),
                Misc.cegui_absdim(d_contentRect.d_top));
            
            // set the new container pane position to be what the scrollbars request
            // minus any bias generated by the location of the content.
            getScrolledContainer().setPosition(basePos.substract(bias));
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
            if (class_name=="ScrollablePane")
                return true;
            
            return super.testClassName_impl(class_name);
        }
        
        /*!
        \brief
        Return a pointer to the ScrolledContainer component widget for this
        ScrollablePane.
        
        \return
        Pointer to a ScrolledContainer object.
        
        \exception UnknownObjectException
        Thrown if the scrolled container component does not exist.
        */
        protected function getScrolledContainer():FlameScrolledContainer
        {
            return FlameWindowManager.getSingleton().getWindow(
                    getName() + ScrolledContainerNameSuffix) as FlameScrolledContainer;
        }
        
        // validate window renderer
        protected function validateWindowRenderer(name:String):Boolean
        {
            return (name == "ScrollablePane");
        }
        
        /*************************************************************************
         Event triggers
         *************************************************************************/
        /*!
        \brief
        Event trigger method called when some pane content has changed size
        or location.
        
        \param e
        WindowEventArgs object.
        
        \return
        Nothing.
        */
        protected function onContentPaneChanged(e:WindowEventArgs):void
        {
            fireEvent(EventContentPaneChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Event trigger method called when the setting that controls whether the 
        vertical scrollbar is always shown or not, is changed.
        
        \param e
        WindowEventArgs object.
        
        \return
        Nothing.
        */
        protected function onVertScrollbarModeChanged(e:WindowEventArgs):void
        {
            fireEvent(EventVertScrollbarModeChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Event trigger method called when the setting that controls whether the 
        horizontal scrollbar is always shown or not, is changed.
        
        \param e
        WindowEventArgs object.
        
        \return
        Nothing.
        */
        protected function onHorzScrollbarModeChanged(e:WindowEventArgs):void
        {
            fireEvent(EventHorzScrollbarModeChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Notification method called whenever the setting that controls whether
        the content pane is automatically sized is changed.
        
        \param e
        WindowEventArgs object.
        
        \return
        Nothing.
        */
        protected function onAutoSizeSettingChanged(e:WindowEventArgs):void
        {
            fireEvent(EventAutoSizeSettingChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Notification method called whenever the content pane is scrolled via
        changes in the scrollbar positions.
        
        \param e
        WindowEventArgs object.
        
        \return
        Nothing.
        */
        protected function onContentPaneScrolled(e:WindowEventArgs):void
        {
            updateContainerPosition();
            fireEvent(EventContentPaneScrolled, e, EventNamespace);
        }
        
        /*************************************************************************
         Event handler methods
         *************************************************************************/
        /*!
        \brief
        Handler method which gets subscribed to the scrollbar position change
        events.
        */
        protected function handleScrollChange(e:EventArgs):Boolean
        {
            var args:WindowEventArgs = new WindowEventArgs(this);
            onContentPaneScrolled(args);
            return true;
        }
        
        /*!
        \brief
        Handler method which gets subscribed to the ScrolledContainer content
        change events.
        */
        protected function handleContentAreaChange(e:EventArgs):Boolean
        {
            var vertScrollbar:FlameScrollbar = getVertScrollbar();
            var horzScrollbar:FlameScrollbar = getHorzScrollbar();
            
            // get updated extents of the content
            var contentArea:Rect = getScrolledContainer().getContentArea();
            
            // calculate any change on the top and left edges.
            var xChange:Number = contentArea.d_left - d_contentRect.d_left;
            var yChange:Number = contentArea.d_top - d_contentRect.d_top;
            
            // store new content extents information
            d_contentRect = contentArea;
            
            configureScrollbars();
            
            // update scrollbar positions (which causes container pane to be moved as needed).
            horzScrollbar.setScrollPosition(horzScrollbar.getScrollPosition() - xChange);
            vertScrollbar.setScrollPosition(vertScrollbar.getScrollPosition() - yChange);
            
            // this call may already have been made if the scroll positions changed.  The call
            // is required here for cases where the top/left 'bias' has changed; in which
            // case the scroll position notification may or may not have been fired.
            if (xChange || yChange)
                updateContainerPosition();
            
            // fire event
            var args:WindowEventArgs = new WindowEventArgs(this);
            onContentPaneChanged(args);
            
            return true;
        }
        
        /*!
        \brief
        Handler method which gets subscribed to the ScrolledContainer auto-size
        setting changes.
        */
        protected function handleAutoSizePaneChanged(e:EventArgs):Boolean
        {
            // just forward event to client.
            var args:WindowEventArgs = new WindowEventArgs(this);
            fireEvent(EventAutoSizeSettingChanged, args, EventNamespace);
            return args.handled > 0;
        }
        
        // Overridden from Window
        override protected function addChild_impl(wnd:FlameWindow):void
        {
            // null is not a valid window pointer!
            //assert(wnd != 0);
            
            // See if this is an internally generated window
            // (will have AutoWidgetNameSuffix in the name)
            if (wnd.getName().indexOf(AutoWidgetNameSuffix) != -1)
            {
                // This is an internal widget, so should be added normally.
                super.addChild_impl(wnd);
            }
                // this is a client window/widget, so should be added to the pane container.
            else
            {
                // container should always be valid by the time we're adding client
                // controls
                getScrolledContainer().addChildWindow(wnd);
            }
        }
        
        override protected function removeChild_impl(wnd:FlameWindow):void
        {
            // null is not a valid window pointer!
            //assert(wnd != 0);
            
            // See if this is an internally generated window
            // (will have AutoWidgetNameSuffix in the name)
            if (wnd.getName().indexOf(AutoWidgetNameSuffix) != -1)
            {
                // This is an internal widget, so should be removed normally.
                super.removeChild_impl(wnd);
            }
                // this is a client window/widget, so should be removed from the pane
                // container.
            else
            {
                // container should always be valid by the time we're handling client
                // controls
                getScrolledContainer().removeChildWindow(wnd);
            }
        }
        
        override protected function onSized(e:WindowEventArgs):void
        {
            super.onSized(e);
            configureScrollbars();
            updateContainerPosition();
            
            ++e.handled;
        }
        
        override public function onMouseWheel(e:MouseEventArgs):void
        {
            // base class processing.
            super.onMouseWheel(e);
            
            var vertScrollbar:FlameScrollbar = getVertScrollbar();
            var horzScrollbar:FlameScrollbar = getHorzScrollbar();
            
            if (vertScrollbar.isVisible() &&
                (vertScrollbar.getDocumentSize() > vertScrollbar.getPageSize()))
            {
                vertScrollbar.setScrollPosition(vertScrollbar.getScrollPosition() +
                    vertScrollbar.getStepSize() * -e.wheelChange);
            }
            else if (horzScrollbar.isVisible() &&
                (horzScrollbar.getDocumentSize() > horzScrollbar.getPageSize()))
            {
                horzScrollbar.setScrollPosition(horzScrollbar.getScrollPosition() +
                    horzScrollbar.getStepSize() * -e.wheelChange);
            }
            
            ++e.handled;
        }
        
        
        
        private function addScrollablePaneProperties():void
        {
            addProperty(d_horzScrollbarProperty);
            addProperty(d_vertScrollbarProperty);
            addProperty(d_autoSizedProperty);
            addProperty(d_contentAreaProperty);
            addProperty(d_horzStepProperty);
            addProperty(d_horzOverlapProperty);
            addProperty(d_horzScrollPositionProperty);
            addProperty(d_vertStepProperty);
            addProperty(d_vertOverlapProperty);
            addProperty(d_vertScrollPositionProperty);
        }
    }
}