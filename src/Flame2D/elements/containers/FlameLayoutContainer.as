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
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.UBox;
    import Flame2D.core.utils.UDim;
    import Flame2D.core.utils.UVector2;
    import Flame2D.core.utils.Vector2;
    
    /*!
    \brief
    An abstract base class providing common functionality and specifying the
    required interface for derived classes.
    
    Layout Container provide means for automatic positioning based on sizes of
    it's child Windows. This is usefull for dynamic UIs.
    */
    public class FlameLayoutContainer extends FlameWindow
    {
        
        /*************************************************************************
         Event name constants
         *************************************************************************/
        //! Namespace for global events
        public static const EventNamespace:String = "LayoutContainer";
        
        /*************************************************************************
         Implementation Data
         *************************************************************************/
        // if true, we will relayout before rendering of this window starts
        protected var d_needsLayouting:Boolean = false;
        
        //typedef std::multimap<Window*, Event::Connection>  ConnectionTracker;
        //! Tracks event connections we make.
        //ConnectionTracker d_eventConnections;
        
        
        

        
        /*!
        \brief
        Constructor for Window base class
        
        \param type
        String object holding Window type (usually provided by WindowFactory).
        
        \param name
        String object holding unique name for the Window.
        */
        public function FlameLayoutContainer(type:String, name:String)
        {
            super(type, name);
        }
        

        
        /*!
        \brief
        marks this layout container for relayouting before drawing
        */
        public function markNeedsLayouting():void
        {
            d_needsLayouting = true;
        }
        
        /*!
        \brief
        returns true if this layout container will be relayouted before drawing
        */
        public function needsLayouting():Boolean
        {
            return d_needsLayouting;
        }
        
        /*!
        \brief
        (re)layouts all windows inside this layout container immediately
        */
        public function layout():void
        {
            
        }
        
        /*!
        \brief
        (re)layouts all windows inside this layout container if it was marked
        necessary
        */
        public function layoutIfNecessary():void
        {
            if (d_needsLayouting)
            {
                layout();
                
                d_needsLayouting = false;
            }
        }
        
        /// @copydoc Window::getUnclippedInnerRect_impl
        override protected function getUnclippedInnerRect_impl():Rect
        {
            return d_parent ?
                d_parent.getUnclippedInnerRect() :
                super.getUnclippedInnerRect_impl();
        }
        
        /// @copydoc Window::update
        override public function update(elapsed:Number):void
        {
            super.update(elapsed);
            
            layoutIfNecessary();
        }
        
        
        
        /// @copydoc Window::getClientChildWindowContentArea_impl
        override protected function getClientChildWindowContentArea_impl():Rect
        {
            if (!d_parent)
                return super.getClientChildWindowContentArea_impl();
            else
            {
                //return new Rect(getUnclippedOuterRect().getPosition(),
                 //   d_parent.getUnclippedInnerRect().getSize());
                var pos:Vector2 = getUnclippedOuterRect().getPosition();
                var size:Size = d_parent.getUnclippedInnerRect().getSize();
                return new Rect(pos.d_x, pos.d_y, pos.d_x + size.d_width, pos.d_y + size.d_height);
            }
        }
        
        //! @copydoc Window::testClassName_impl
        override protected function testClassName_impl(class_name:String):Boolean
        {
            if (class_name == "LayoutContainer")  return true;
            
            return super.testClassName_impl(class_name);
        }
        
        protected function getIdxOfChildWindow(wnd:FlameWindow):uint
        {
            for (var i:uint = 0; i < getChildCount(); ++i)
            {
                if (getChildAt(i) == wnd)
                {
                    return i;
                }
            }
            
            //assert(0);
            return 0;
        }
        
        /// @copydoc Window::addChild_impl
        override protected function addChild_impl(wnd:FlameWindow):void
        {
            super.addChild_impl(wnd);
            
            // we have to subscribe to the EventSized for layout updates
            //            d_eventConnections.insert(std::make_pair(wnd,
            //                wnd->subscribeEvent(Window::EventSized,
            //                    Event::Subscriber(&LayoutContainer::handleChildSized, this))));
            //            d_eventConnections.insert(std::make_pair(wnd,
            //                wnd->subscribeEvent(Window::EventMarginChanged,
            //                    Event::Subscriber(&LayoutContainer::handleChildMarginChanged, this))));
            wnd.subscribeEvent(FlameWindow.EventSized, new Subscriber(handleChildSized, this), FlameWindow.EventNamespace);
            wnd.subscribeEvent(FlameWindow.EventMarginChanged, new Subscriber(handleChildMarginChanged, this), FlameWindow.EventNamespace);
        }
        
        
        /// @copydoc Window::removeChild_impl
        override protected function removeChild_impl(wnd:FlameWindow):void
        {
            // we want to get rid of the subscription, because the child window could
            // get removed and added somewhere else, we would be wastefully updating
            // layouts if it was sized inside other Window
//            ConnectionTracker::iterator conn;
//            
//            while ((conn = d_eventConnections.find(wnd)) != d_eventConnections.end())
//            {
//                conn->second->disconnect();
//                d_eventConnections.erase(conn);
//            }
            
            super.removeChild_impl(wnd);
        }
        
        /*************************************************************************
         Event trigger methods
         *************************************************************************/
        /*!
        \brief
        Handler called when child window gets sized
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the
        window that triggered the event.  For this event the trigger window is
        the one that was sized.
        */
        protected function handleChildSized(e:EventArgs):Boolean
        {
            markNeedsLayouting();
            
            return true;
        }
        
        /*!
        \brief
        Handler called when child window changes margin(s)
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the
        window that triggered the event.  For this event the trigger window is
        the one that has had it's margin(s) changed.
        */
        protected function handleChildMarginChanged(e:EventArgs):Boolean
        {
            markNeedsLayouting();
            
            return true;
        }
        
        /*!
        \brief
        Handler called when child window gets added
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the
        window that triggered the event.  For this event the trigger window is
        the one that was added.
        */
        protected function handleChildAdded(e:EventArgs):Boolean
        {
            markNeedsLayouting();
            
            return true;
        }
        
        /*!
        \brief
        Handler called when child window gets removed
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the
        window that triggered the event.  For this event the trigger window is
        the one that was removed.
        */
        protected function handleChildRemoved(e:EventArgs):Boolean
        {
            markNeedsLayouting();
            
            return true;
        }
        
        /*!
        \brief
        returns margin offset for given window
        */
        protected function getOffsetForWindow(window:FlameWindow):UVector2
        {
            const margin:UBox = window.getMargin();
            
            return new UVector2(margin.d_left, margin.d_top);
        }
        
        /*!
        \brief
        returns bounding size for window, including margins
        */
        protected function getBoundingSizeForWindow(window:FlameWindow):UVector2
        {
            const pixelSize:Size = window.getPixelSize();
            
            // we rely on pixelSize rather than mixed absolute and relative getSize
            // this seems to solve problems when windows overlap because their size
            // is constrained by min size
            const size:UVector2 = new UVector2(new UDim(0, pixelSize.d_width), new UDim(0, pixelSize.d_height));
            // todo: we still do mixed absolute/relative margin, should we convert the
            //       value to absolute?
            const margin:UBox = window.getMargin();
            
            return new UVector2(
                margin.d_left + size.d_x + margin.d_right,
                margin.d_top + size.d_y + margin.d_bottom
            );
        }

    }
    
 
}