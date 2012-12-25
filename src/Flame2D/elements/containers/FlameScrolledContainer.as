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
    import Flame2D.core.data.RenderingContext;
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.Vector2;

    /*!
    \brief
    Helper container window class which is used in the implementation of the
    ScrollablePane widget class.
    */
    public class FlameScrolledContainer extends FlameWindow
    {
        public static const WidgetTypeName:String = "ScrolledContainer";
        public static const EventNamespace:String = "ScrolledContainer";
        
        
        
        /** Event fired whenever some child changes.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ScrolledContainer for which a child
         * window has changed.
         */
        public static const EventContentChanged:String = "ContentChanged";
        /** Event fired when the autosize setting changes.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ScrolledContainer whose auto size
         * setting has been changed.
         */
        public static const EventAutoSizeSettingChanged:String = "AutoSizeSettingChanged";

        
        private static var d_autoSizedProperty:ScrolledContainerPropertyContentPaneAutoSized = new ScrolledContainerPropertyContentPaneAutoSized();
        private static var d_contentAreaProperty:ScrolledContainerPropertyContentArea = new ScrolledContainerPropertyContentArea();
        private static var d_childExtentsAreaProperty:ScrolledContainerPropertyChildExtentsArea = new ScrolledContainerPropertyChildExtentsArea();

        
        //! type definition for collection used to track event connections.
//        typedef std::multimap<Window*, Event::Connection>  ConnectionTracker;
//        //! Tracks event connections we make.
//        ConnectionTracker d_eventConnections;
        //! Holds extents of the content pane.
        protected var d_contentArea:Rect = new Rect(0,0,0,0);
        //! true if the pane auto-sizes itself.
        protected var d_autosizePane:Boolean = true;
        
        
        public function FlameScrolledContainer(type:String, name:String)
        {
            super(type, name);
            
            addScrolledContainerProperties();
            setMouseInputPropagationEnabled(true);
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
            return d_autosizePane;
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
            if (d_autosizePane != setting)
            {
                d_autosizePane = setting;
                
                // Fire events
                var args1:WindowEventArgs = new WindowEventArgs(this);
                onAutoSizeSettingChanged(args1);
            }
        }
        
        /*!
        \brief
        Return the current content pane area for the ScrolledContainer.
        
        \return
        Rect object that details the current pixel extents of the content
        pane represented by this ScrolledContainer.
        */
        public function getContentArea():Rect
        {
            return d_contentArea;
        }
        
        /*!
        \brief
        Set the current content pane area for the ScrolledContainer.
        
        \note
        If the ScrolledContainer is configured to auto-size the content pane
        this call will have no effect.
        
        \param area
        Rect object that details the pixel extents to use for the content
        pane represented by this ScrolledContainer.
        
        \return
        Nothing.
        */
        public function setContentArea(area:Rect):void
        {
            if (!d_autosizePane)
            {
                d_contentArea = area;
                
                // Fire event
                var args:WindowEventArgs = new WindowEventArgs(this);
                onContentChanged(args);
            }
        }
        
        /*!
        \brief
        Return the current extents of the attached content.
        
        \return
        Rect object that describes the pixel extents of the attached
        child windows.  This is effectively the smallest bounding box
        that could contain all the attached windows.
        */
        public function getChildExtentsArea():Rect
        {
            var extents:Rect = new Rect(0, 0, 0, 0);
            
            const childCount:uint = getChildCount();
            if (childCount == 0)
                return extents;
            
            for (var i:uint = 0; i < childCount; ++i)
            {
                const wnd:FlameWindow = getChildAt(i);
                const area:Rect = wnd.getArea().asAbsolute(d_pixelSize);
                
                if (area.d_left < extents.d_left)
                    extents.d_left = area.d_left;
                
                if (area.d_top < extents.d_top)
                    extents.d_top = area.d_top;
                
                if (area.d_right > extents.d_right)
                    extents.d_right = area.d_right;
                
                if (area.d_bottom > extents.d_bottom)
                    extents.d_bottom = area.d_bottom;
            }
            
            return extents;
        }

        // Overridden from Window.
        override protected function getUnclippedInnerRect_impl():Rect
        {
            return d_parent ?
                d_parent.getUnclippedInnerRect() :
                super.getUnclippedInnerRect_impl();
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
            if (class_name=="ScrolledContainer")
                return true;
            
            return super.testClassName_impl(class_name);
        }
        
        /*!
        \brief
        Notification method called whenever the content size may have changed.
        
        \param e
        WindowEventArgs object.
        
        \return
        Nothing.
        */
        protected function onContentChanged(e:WindowEventArgs):void
        {
            if (d_autosizePane)
            {
                d_contentArea = getChildExtentsArea();
            }
            
            fireEvent(EventContentChanged, e, EventNamespace);
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
            
            if (d_autosizePane)
            {
                var args:WindowEventArgs = new WindowEventArgs(this);
                onContentChanged(args);
            }
        }
        
        //! handles notifications about child windows being moved.
        protected function handleChildSized(e:EventArgs):Boolean
        {
            // Fire event that notifies that a child's area has changed.
            var args:WindowEventArgs = new WindowEventArgs(this);
            onContentChanged(args);
            return true;
        }
        //! handles notifications about child windows being sized.
        protected function handleChildMoved(e:EventArgs):Boolean
        {
            // Fire event that notifies that a child's area has changed.
            var args:WindowEventArgs = new WindowEventArgs(this);
            onContentChanged(args);
            return true;
        }
        
        // overridden from Window.
        override protected function drawSelf(ctx:RenderingContext):void
        {
        }
        
        override protected function getInnerRectClipper_impl():Rect
        {
            return d_parent ?
                d_parent.getInnerRectClipper() :
                super.getInnerRectClipper_impl();
        }
        override protected function getNonClientChildWindowContentArea_impl():Rect
        {
            if (!d_parent)
                return super.getNonClientChildWindowContentArea_impl();
            else
            {
                var pos:Vector2 = getUnclippedOuterRect().getPosition();
                var sz:Size = d_parent.getUnclippedInnerRect().getSize();
                return new Rect(
                    pos.d_x, pos.d_y, pos.d_x+sz.d_width, pos.d_y + sz.d_height);
            }
        }
        override protected function getClientChildWindowContentArea_impl():Rect
        {
            return getNonClientChildWindowContentArea_impl();
        }
        
        override protected function getHitTestRect_impl():Rect
        {
            return d_parent ? d_parent.getHitTestRect() :
                super.getHitTestRect_impl();
        }
        
        override protected function onChildAdded(e:WindowEventArgs):void
        {
            super.onChildAdded(e);
            
            // subscribe to some events on this child
            e.window.subscribeEvent(FlameWindow.EventSized, new Subscriber(handleChildSized, this), FlameWindow.EventNamespace);
            e.window.subscribeEvent(FlameWindow.EventMoved, new Subscriber(handleChildMoved, this), FlameWindow.EventNamespace);
//            d_eventConnections.insert(std::make_pair(e.window, 
//                e.window->subscribeEvent(Window::EventSized,
//                    Event::Subscriber(&ScrolledContainer::handleChildSized, this))));
//            d_eventConnections.insert(std::make_pair(e.window,
//                e.window->subscribeEvent(Window::EventMoved,
//                    Event::Subscriber(&ScrolledContainer::handleChildMoved, this))));
            
            // force window to update what it thinks it's screen / pixel areas are.
            e.window.notifyScreenAreaChanged(false);
            
            // perform notification.
            var args:WindowEventArgs = new WindowEventArgs(this);
            onContentChanged(args);
        }
        
        override protected function onChildRemoved(e:WindowEventArgs):void
        {
            super.onChildRemoved(e);
            
//            // disconnect from events for this window.
//            ConnectionTracker::iterator conn;
//            while ((conn = d_eventConnections.find(e.window)) != d_eventConnections.end())
//            {
//                conn->second->disconnect();
//                d_eventConnections.erase(conn);
//            }
//            
            // perform notification only if we're not currently being destroyed
            if (!d_destructionStarted)
            {
                var args:WindowEventArgs = new WindowEventArgs(this);
                onContentChanged(args);
            }
        }
        
        override public function onParentSized(e:WindowEventArgs):void
        {
            super.onParentSized(e);
            
            // perform notification.
            var args:WindowEventArgs = new WindowEventArgs(this);
            onContentChanged(args);
        }
        


        
        private function addScrolledContainerProperties():void
        {
            addProperty(d_autoSizedProperty);
            addProperty(d_contentAreaProperty);
            addProperty(d_childExtentsAreaProperty);
        }
    }
}