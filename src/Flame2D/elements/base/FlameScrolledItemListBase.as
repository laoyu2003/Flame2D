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
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.UVector2;
    import Flame2D.elements.containers.FlameClippedContainer;
    
    /*!
    \brief
    ScrolledItemListBase window class
    */
    public class FlameScrolledItemListBase extends FlameItemListBase
    {
        public static const EventNamespace:String   = "ScrolledItemListBase"; //!< Namespace for global events
        
        /************************************************************************
         Constants
         *************************************************************************/
        public static const VertScrollbarNameSuffix:String = "__auto_vscrollbar__"; //!< Name suffix for vertical scrollbar component
        public static const HorzScrollbarNameSuffix:String = "__auto_hscrollbar__"; //!< Name suffix for horizontal scrollbar component
        public static const ContentPaneNameSuffix:String = "__auto_content_pane__";   //!< Name suffix for the content pane component
        
        /** Event fired when the vertical scroll bar mode changes.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ScrolledItemListBase whose vertical
         * scroll bar mode has been changed.
         */
        public static const EventVertScrollbarModeChanged:String = "VertScrollbarModeChanged";
        /** Event fired when the horizontal scroll bar mode change.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ScrolledItemListBase whose horizontal
         * scroll bar mode has been changed.
         */
        public static const EventHorzScrollbarModeChanged:String = "HorzScrollbarModeChanged";
        
        
        /************************************************************************
         Static Properties for this class
         ************************************************************************/
        private static var d_forceVertScrollbarProperty:ScrolledItemListBasePropertyForceVertScrollbar = new ScrolledItemListBasePropertyForceVertScrollbar();
        private static var d_forceHorzScrollbarProperty:ScrolledItemListBasePropertyForceHorzScrollbar = new ScrolledItemListBasePropertyForceHorzScrollbar();
        
        /************************************************************************
         Implementation data
         ************************************************************************/
        protected var d_forceVScroll:Boolean = false;
        protected var d_forceHScroll:Boolean = false;
        
        
        
        
        
        
        /************************************************************************
         Object Construction and Destruction
         *************************************************************************/
        /*!
        \brief
        Constructor for the ScrolledItemListBase base class constructor
        */
        public function FlameScrolledItemListBase(type:String, name:String)
        {
            super(type, name);
            
            d_pane = null;
            
            addScrolledItemListBaseProperties();
        }
        

        // overridden from ItemListBase
        override public function initialiseComponents():void
        {
            // Only process the content pane if it hasn't been done in the past
            // NOTE: This ensures that a duplicate content pane is not created. An example where
            // this would be possible would be when changing the Look'N'Feel of the widget
            // (for instance an ItemListBox), an operation which would reconstruct the child components
            // of the widget by destroying the previous ones and creating new ones with the
            // new Look'N'Feel. However, since the content pane is not defined in the
            // look and feel file and thus not associated with the look'N'Feel itself
            // but instead created here manually, the destruction would not contemplate the content
            // pane itself, so when the children would be rebuilt, a duplicate content pane
            // would be attempted (and an exception would be issued).
            if(!d_pane)
            {
                // IMPORTANT:
                // we must do this before the base class handling or we'll lose the onChildRemoved subscriber!!!
                d_pane = FlameWindowManager.getSingleton().createWindow("ClippedContainer", d_name + ContentPaneNameSuffix);
                
                // set up clipping
                (d_pane as FlameClippedContainer).setClipperWindow(this);
                // allow propagation back to us
                d_pane.setMouseInputPropagationEnabled(true);
                
                addChildWindow(d_pane);
            }
            
            // base class handling
            super.initialiseComponents();
            
            // init scrollbars
            var v:FlameScrollbar = getVertScrollbar();
            var h:FlameScrollbar = getHorzScrollbar();
            
            v.setAlwaysOnTop(true);
            h.setAlwaysOnTop(true);
            
            v.subscribeEvent(FlameScrollbar.EventScrollPositionChanged, new Subscriber(handle_VScroll, this), FlameScrollbar.EventNamespace);
            h.subscribeEvent(FlameScrollbar.EventScrollPositionChanged, new Subscriber(handle_HScroll, this), FlameScrollbar.EventNamespace);
            
            v.hide();
            h.hide();
        }
        
        
        
        
        
        /************************************************************************
         Accessors
         *************************************************************************/
        /*!
        \brief
        Returns whether the vertical scrollbar is being forced visible. Despite content size.
        */
        public function isVertScrollbarAlwaysShown():Boolean
        {
            return d_forceVScroll;
        }
        
        /*!
        \brief
        Returns whether the horizontal scrollbar is being forced visible. Despite content size.
        */
        public function isHorzScrollbarAlwaysShown():Boolean
        {
            return d_forceHScroll;
        }
        
        /*!
        \brief
        Get the vertical scrollbar component attached to this window.
        */
        public function getVertScrollbar():FlameScrollbar
        {
            return FlameWindowManager.getSingleton()
                .getWindow(d_name+VertScrollbarNameSuffix) as FlameScrollbar;
        }
        
        /*!
        \brief
        Get the horizontal scrollbar component attached to this window.
        */
        public function getHorzScrollbar():FlameScrollbar
        {
            return FlameWindowManager.getSingleton()
                .getWindow(d_name+HorzScrollbarNameSuffix) as FlameScrollbar;
        }
        
        /************************************************************************
         Manipulators
         *************************************************************************/
        /*!
        \brief
        Sets whether the vertical scrollbar should be forced visible. Despite content size.
        */
        public function setShowVertScrollbar(mode:Boolean):void
        {
            if (mode != d_forceVScroll)
            {
                d_forceVScroll = mode;
                var e:WindowEventArgs = new WindowEventArgs(this);
                onVertScrollbarModeChanged(e);
            }
        }
        
        /*!
        \brief
        Sets whether the horizontal scrollbar should be forced visible. Despite content size.
        */
        public function setShowHorzScrollbar(mode:Boolean):void
        {
            if (mode != d_forceHScroll)
            {
                d_forceHScroll = mode;
                var e:WindowEventArgs = new WindowEventArgs(this);
                onHorzScrollbarModeChanged(e);
            }
        }
        
        /*!
        \brief
        Scroll the vertical list position if needed to ensure that the ItemEntry
        \a item is, if possible,  fully visible witin the ScrolledItemListBase
        viewable area.
        
        \param item
        const reference to an ItemEntry attached to this ScrolledItemListBase
        that should be made visible in the view area.
        
        \return
        Nothing.
        */
        public function ensureItemIsVisibleVert(item:FlameItemEntry):void
        {
            const render_area:Rect = getItemRenderArea();
            const v:FlameScrollbar = getVertScrollbar();
            const currPos:Number = v.getScrollPosition();
            
            const top:Number =
                item.getYPosition().asAbsolute(this.getPixelSize().d_height) - currPos;
            const bottom:Number = top + item.getItemPixelSize().d_height;
            
            // if top is above the view area, or if item is too big, scroll item to top
            if ((top < render_area.d_top) || ((bottom - top) > render_area.getHeight()))
                v.setScrollPosition(currPos + top);
                // if bottom is below the view area, scroll item to bottom of list
            else if (bottom >= render_area.d_bottom)
                v.setScrollPosition(currPos + bottom - render_area.getHeight());
        }
        
        /*!
        \brief
        Scroll the horizontal list position if needed to ensure that the
        ItemEntry \a item is, if possible, fully visible witin the
        ScrolledItemListBase viewable area.
        
        \param item
        const reference to an ItemEntry attached to this ScrolledItemListBase
        that should be made visible in the view area.
        
        \return
        Nothing.
        */
        public function ensureItemIsVisibleHorz(item:FlameItemEntry):void
        {
            const render_area:Rect = getItemRenderArea();
            const h:FlameScrollbar = getHorzScrollbar();
            const currPos:Number = h.getScrollPosition();
            
            const left:Number =
                item.getXPosition().asAbsolute(this.getPixelSize().d_width) - currPos;
            const right:Number = left + item.getItemPixelSize().d_width;
            
            // if left is left of the view area, or if item too big, scroll item to left
            if ((left < render_area.d_left) || ((right - left) > render_area.getWidth()))
                h.setScrollPosition(currPos + left);
                // if right is right of the view area, scroll item to right of list
            else if (right >= render_area.d_right)
                h.setScrollPosition(currPos + right - render_area.getWidth());
        }

        
        /************************************************************************
         Implementation functions
         ************************************************************************/
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
            if (class_name=="ScrolledItemListBase")
            {
                return true;
            }
            return super.testClassName_impl(class_name);
        }
        
        /*!
        \brief
        Configure scrollbars
        */
        protected function configureScrollbars(doc_size:Size):void
        {
            var v:FlameScrollbar = getVertScrollbar();
            var h:FlameScrollbar = getHorzScrollbar();
            
            const old_vert_visible:Boolean = v.isVisible(true);
            const old_horz_visible:Boolean = h.isVisible(true);
            
            var render_area_size:Size = getItemRenderArea().getSize();
            
            // setup the pane size
            var pane_size_w:Number = Math.max(doc_size.d_width, render_area_size.d_width);
            var pane_size:UVector2 = new UVector2(Misc.cegui_absdim(pane_size_w), Misc.cegui_absdim(doc_size.d_height));
            
            d_pane.setMinSize(pane_size);
            d_pane.setMaxSize(pane_size);
            //d_pane->setWindowSize(pane_size);
            
            // "fix" scrollbar visibility
            if (d_forceVScroll || doc_size.d_height > render_area_size.d_height)
            {
                v.show();
            }
            else
            {
                v.hide();
            }
            
            //render_area_size = getItemRenderArea().getSize();
            
            if (d_forceHScroll || doc_size.d_width > render_area_size.d_width)
            {
                h.show();
            }
            else
            {
                h.hide();
            }
            
            // if some change occurred, invalidate the inner rect area caches.
            if ((old_vert_visible != v.isVisible(true)) ||
                (old_horz_visible != h.isVisible(true)))
            {
                d_innerUnclippedRectValid = false;
                d_innerRectClipperValid = false;
            }
            
            // get a fresh item render area
            var render_area:Rect = getItemRenderArea();
            render_area_size = render_area.getSize();
            
            // update the pane clipper area
            (d_pane as FlameClippedContainer).setClipArea(render_area);
            
            // setup vertical scrollbar
            v.setDocumentSize(doc_size.d_height);
            v.setPageSize(render_area_size.d_height);
            v.setStepSize(Math.max(1.0, render_area_size.d_height / 10.0));
            v.setScrollPosition(v.getScrollPosition());
            
            // setup horizontal scrollbar
            h.setDocumentSize(doc_size.d_width);
            h.setPageSize(render_area_size.d_width);
            h.setStepSize(Math.max(1.0, render_area_size.d_width / 10.0));
            h.setScrollPosition(h.getScrollPosition());
        }
        
        /************************************************************************
         New event handlers
         ************************************************************************/
        protected function onVertScrollbarModeChanged(e:WindowEventArgs):void
        {
            fireEvent(EventVertScrollbarModeChanged, e, EventNamespace);
        }
        
        protected function onHorzScrollbarModeChanged(e:WindowEventArgs):void
        {
            fireEvent(EventHorzScrollbarModeChanged, e, EventNamespace);
        }
        
        /************************************************************************
         Overridden event handlers
         ************************************************************************/
        override public function onMouseWheel(e:MouseEventArgs):void
        {
            super.onMouseWheel(e);
            
            var count:uint = getItemCount();
            var v:FlameScrollbar = getVertScrollbar();
            
            // dont do anything if we are no using scrollbars
            // or have'nt got any items
            if (!v.isVisible(true) || !count)
            {
                return;
            }
            
            var pixH:Number = d_pane.getUnclippedOuterRect().getHeight();
            var delta:Number = (pixH/Number(count)) * -e.wheelChange;
            v.setScrollPosition(v.getScrollPosition() + delta);
            ++e.handled;
        }
        
        /************************************************************************
         Event subscribers
         ************************************************************************/
        protected function handle_VScroll(e:EventArgs):Boolean
        {
            const we:WindowEventArgs = e as WindowEventArgs;
            var v:FlameScrollbar =we.window as FlameScrollbar;
            var newpos:Number = -v.getScrollPosition();
            d_pane.setYPosition(Misc.cegui_absdim(newpos));
            return true;
        }
        
        
        protected function handle_HScroll(e:EventArgs):Boolean
        {
            const we:WindowEventArgs = e as WindowEventArgs;
            var h:FlameScrollbar = we.window as FlameScrollbar;
            var newpos:Number = -h.getScrollPosition();
            d_pane.setXPosition(Misc.cegui_absdim(newpos));
            return true;
        }
        

        
        private function addScrolledItemListBaseProperties():void
        {
            addProperty(d_forceVertScrollbarProperty);
            addProperty(d_forceHorzScrollbarProperty);
        }
            

    }
}