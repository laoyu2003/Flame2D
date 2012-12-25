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
package Flame2D.elements.menu
{
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.URect;
    import Flame2D.core.utils.UVector2;
    
    public class FlamePopupMenu extends FlameMenuBase
    {
        public static const EventNamespace:String = "PopupMenu";
        public static const WidgetTypeName:String = "CEGUI/PopupMenu";
        
        
        
        /*************************************************************************
         Static Properties for this class
         *************************************************************************/
        public static var d_fadeInTimeProperty:PopupMenuPropertyFadeInTime = new PopupMenuPropertyFadeInTime();
        public static var d_fadeOutTimeProperty:PopupMenuPropertyFadeOutTime = new PopupMenuPropertyFadeOutTime();
        
        
        /*************************************************************************
         Implementation Data
         *************************************************************************/
        protected var d_origAlpha:Number;      //!< The original alpha of this window.
        protected var d_fadeElapsed:Number = 0;    //!< The time in seconds this popup menu has been fading.
        protected var d_fadeOutTime:Number = 0;    //!< The time in seconds it takes for this popup menu to fade out.
        protected var d_fadeInTime:Number = 0;     //!< The time in seconds it takes for this popup menu to fade in.
        protected var d_fading:Boolean = false;          //!< true if this popup menu is fading in/out. false if not
        protected var d_fadingOut:Boolean = false;       //!< true if this popup menu is fading out. false if fading in.
        protected var d_isOpen:Boolean = false;          //!< true if this popup menu is open. false if not.

        
        
        /*************************************************************************
         Construction and Destruction
         *************************************************************************/
        /*!
        \brief
        Constructor for PopupMenu objects
        */
        public function FlamePopupMenu(type:String, name:String)
        {
            super(type, name);
            
            d_origAlpha = d_alpha;
            
            d_itemSpacing = 2;
            
            addPopupMenuProperties();
            
            // enable auto resizing
            d_autoResize = true;
            
            // disable parent clipping
            setClippedByParent(false);
            
            // hide by default
            hide();
        }
        


        /*************************************************************************
         Accessor type functions
         *************************************************************************/
        /*!
        \brief
        Get the fade in time for this popup menu.
        
        \return
        The time in seconds that it takes for the popup to fade in.
        0 if fading is disabled.
        */
        public function getFadeInTime():Number
        {
            return d_fadeInTime;
        }
        
        
        /*!
        \brief
        Get the fade out time for this popup menu.
        
        \return
        The time in seconds that it takes for the popup to fade out.
        0 if fading is disabled.
        */
        public function getFadeOutTime():Number
        {
            return d_fadeOutTime;
        }
        
        
        /*!
        \brief
        Find out if this popup menu is open or closed;
        */
        public function isPopupMenuOpen():Boolean
        {
            return d_isOpen;
        }
        
        
        /*************************************************************************
         Manipulators
         *************************************************************************/
        /*!
        \brief
        Set the fade in time for this popup menu.
        
        \param fadetime
        The time in seconds that it takes for the popup to fade in.
        If this parameter is zero, fading is disabled.
        */
        public function setFadeInTime(fadetime:Number):void
        {
            d_fadeInTime=fadetime;
        }
        
        
        /*!
        \brief
        Set the fade out time for this popup menu.
        
        \param fadetime
        The time in seconds that it takes for the popup to fade out.
        If this parameter is zero, fading is disabled.
        */
        public function setFadeOutTime(fadetime:Number):void
        {
            d_fadeOutTime=fadetime;
        }
        
        
        /*!
        \brief
        Tells the popup menu to open.
        
        \param notify
        true if the parent menu item (if any) is to handle the opening. false if not.
        */
        public function openPopupMenu(notify:Boolean=true):void
        {
            // already open and not fading, or fading in?
            if (d_isOpen && (!d_fading || !d_fadingOut))
            {
                // then don't do anything
                return;
            }
            
            // should we let the parent menu item initiate the open?
            var parent:FlameWindow = getParent();
            if (notify && parent && parent.testClassName("MenuItem"))
            {
                (parent as FlameMenuItem).openPopupMenu();
                return; // the rest will be handled when MenuItem calls us itself
            }
            
            // we'll handle it ourselves then.
            // are we fading, and fading out?
            if (d_fading && d_fadingOut)
            {
                if (d_fadeInTime>0.0 && d_fadeOutTime>0.0)
                {
                    // jump to the point of the fade in that has the same alpha as right now - this keeps it smooth
                    d_fadeElapsed = ((d_fadeOutTime-d_fadeElapsed)/d_fadeOutTime)*d_fadeInTime;
                }
                else
                {
                    // start the fade in from the beginning
                    d_fadeElapsed = 0;
                }
                // change to fade in
                d_fadingOut=false;
            }
                // otherwise just start normal fade in!
            else if (d_fadeInTime>0.0)
            {
                d_fading = true;
                d_fadingOut=false;
                setAlpha(0.0);
                d_fadeElapsed = 0;
            }
                // should not fade!
            else
            {
                d_fading = false;
                setAlpha(d_origAlpha);
            }
            
            show();
            moveToFront();
        }
        
        
        /*!
        \brief
        Tells the popup menu to close.
        
        \param notify
        true if the parent menu item (if any) is to handle the closing. false if not.
        */
        public function closePopupMenu(notify:Boolean=true):void
        {
            // already closed?
            if (!d_isOpen)
            {
                // then do nothing
                return;
            }
            
            // should we let the parent menu item close initiate the close?
            var parent:FlameWindow = getParent();
            if (notify && parent && parent.testClassName("MenuItem"))
            {
                (parent as FlameMenuItem).closePopupMenu();
                return; // the rest will be handled when MenuItem calls us itself
            }
            
            // we'll do it our selves then.
            // are we fading, and fading in?
            if (d_fading && !d_fadingOut)
            {
                // make sure the "fade back out" is smooth - if possible !
                if (d_fadeOutTime>0.0&&d_fadeInTime>0.0)
                {
                    // jump to the point of the fade in that has the same alpha as right now - this keeps it smooth
                    d_fadeElapsed = ((d_fadeInTime-d_fadeElapsed)/d_fadeInTime)*d_fadeOutTime;
                }
                else
                {
                    // start the fade in from the beginning
                    d_fadeElapsed = 0;
                }
                // change to fade out
                d_fadingOut=true;
            }
                // otherwise just start normal fade out!
            else if (d_fadeOutTime>0.0)
            {
                d_fading = true;
                d_fadingOut = true;
                setAlpha(d_origAlpha);
                d_fadeElapsed = 0;
            }
                // should not fade!
            else
            {
                d_fading = false;
                hide();
            }
        }
        

        
        /*************************************************************************
         Implementation Functions
         *************************************************************************/
        /*!
        \brief
        Perform actual update processing for this Window.
        
        \param elapsed
        float value indicating the number of seconds elapsed since the last update call.
        
        \return
        Nothing.
        */
        override protected function updateSelf(elapsed:Number):void
        {
            super.updateSelf(elapsed);
            
            // handle fading
            if (d_fading)
            {
                d_fadeElapsed+=elapsed;
                
                // fading out
                if (d_fadingOut)
                {
                    if (d_fadeElapsed>=d_fadeOutTime)
                    {
                        hide();
                        d_fading=false;
                        setAlpha(d_origAlpha); // set real alpha so users can show directly without having to restore it
                    }
                    else
                    {
                        setAlpha(d_origAlpha*(d_fadeOutTime-d_fadeElapsed)/d_fadeOutTime);
                    }
                    
                }
                    
                    // fading in
                else
                {
                    if (d_fadeElapsed>=d_fadeInTime)
                    {
                        d_fading=false;
                        setAlpha(d_origAlpha);
                    }
                    else
                    {
                        setAlpha(d_origAlpha*d_fadeElapsed/d_fadeInTime);
                    }
                }
            }
        }
        
        
        /*!
        \brief
        Setup size and position for the item widgets attached to this Listbox
        
        \return
        Nothing.
        */
        override protected function layoutItemWidgets():void
        {
            // get render area
            var render_rect:Rect = getItemRenderArea();
            
            // get starting position
            const x0:Number = Misc.PixelAligned(render_rect.d_left);
            var y0:Number = Misc.PixelAligned(render_rect.d_top);
            
            var rect:URect = new URect();
            var sz:UVector2 = new UVector2(Misc.cegui_absdim(Misc.PixelAligned(render_rect.getWidth())), 
                Misc.cegui_absdim(0)); // set item width
            
            // iterate through all items attached to this window
            for(var i:uint=0; i<d_listItems.length; i++)
            {
                // get the "optimal" height of the item and use that!
                sz.d_y.d_offset = Misc.PixelAligned(d_listItems[i].getItemPixelSize().d_height); // rounding errors ?
                
                // set destination rect
                rect.setPosition(new UVector2(Misc.cegui_absdim(x0), Misc.cegui_absdim(y0)) );
                rect.setSize( sz );
                d_listItems[i].setArea(rect.d_min, rect.d_max);
                
                // next position
                y0 += Misc.PixelAligned(sz.d_y.d_offset + d_itemSpacing);
            }
        }
        
        
        /*!
        \brief
        Resizes the popup menu to exactly fit the content that is attached to it.
        
        \return
        Nothing.
        */
        override protected function getContentSize():Size
        {
            // find the content sizes
            var widest:Number = 0;
            var total_height:Number = 0;
            
            var i:uint = 0;
            var max:uint = d_listItems.length;
            while (i < max)
            {
                const sz:Size = d_listItems[i].getItemPixelSize();
                if (sz.d_width > widest)
                    widest = sz.d_width;
                total_height += sz.d_height;
                
                i++;
            }
            
            const count:Number = Number(i);
            
            // vert item spacing
            if (count >= 2)
            {
                total_height += (count-1)*d_itemSpacing;
            }
            
            // return the content size
            return new Size(widest, total_height);
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
            if (class_name=="PopupMenu")    return true;
            return super.testClassName_impl(class_name);
        }
        
        
        /*************************************************************************
         Overridden event handlers
         *************************************************************************/
        override protected function onAlphaChanged(e:WindowEventArgs):void
        {
            super.onAlphaChanged(e);
            
            // if we are not fading, this is a real alpha change request and we save a copy of the value
            if (!d_fading)
            {
                d_origAlpha = d_alpha;
            }
        }
        
        override protected function onDestructionStarted(e:WindowEventArgs):void
        {
            // if we are attached to a menuitem, we make sure that gets updated
            var p:FlameWindow = getParent();
            if (p && p.testClassName("MenuItem"))
            {
                (p as FlameMenuItem).setPopupMenu(null);
            }
            super.onDestructionStarted(e);
        }
        
        override protected function onShown(e:WindowEventArgs):void
        {
            d_isOpen = true;
            super.onShown(e);
        }
        
        override protected function onHidden(e:WindowEventArgs):void
        {
            d_isOpen = false;
            super.onHidden(e);
        }
        
        
        override public function onMouseButtonDown(e:MouseEventArgs):void
        {
            super.onMouseButtonDown(e);
            // dont reach our parent
            ++e.handled;
        }
        
        
        override public function onMouseButtonUp(e:MouseEventArgs):void
        {
            super.onMouseButtonUp(e);
            // dont reach our parent
            ++e.handled;
        }
        
        /*************************************************************************
         Private methods
         *************************************************************************/
        private function addPopupMenuProperties():void
        {
            addProperty(d_fadeInTimeProperty);
            addProperty(d_fadeOutTimeProperty);
        }
    }
}