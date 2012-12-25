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
    import Flame2D.core.system.FlameMouseCursor;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.data.Consts;
    import Flame2D.elements.base.FlameItemEntry;
    import Flame2D.elements.base.FlameItemListBase;
    import Flame2D.elements.button.FlameButtonBase;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.UDim;
    import Flame2D.core.utils.UVector2;
    import Flame2D.core.utils.Vector2;
    
    public class FlameMenuItem extends FlameItemEntry
    {
        public static const WidgetTypeName:String = "CEGUI/MenuItem";
        
        public static const EventNamespace:String = "MenuItem";             //!< Namespace for global events
        
        
        /*************************************************************************
         Event name constants
         *************************************************************************/
        // generated internally by Window
        /** Event fired when the menu item is clicked.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the MenuItem that was clicked.
         */
        public static const EventClicked:String = "Clicked";
        
        
        /************************************************************************
         Static Properties for this class
         ************************************************************************/
        private static var d_popupOffsetProperty:MenuItemPropertyPopupOffset = new MenuItemPropertyPopupOffset();
        private static var d_autoPopupTimeoutProperty:MenuItemPropertyAutoPopupTimeout = new MenuItemPropertyAutoPopupTimeout();


        /*************************************************************************
         Implementation Data
         *************************************************************************/
        protected var d_pushed:Boolean = false;          //!< true when widget is pushed
        protected var d_hovering:Boolean = false;        //!< true when the button is in 'hover' state and requires the hover rendering.
        protected var d_opened:Boolean = false;          //!< true when the menu item's popup menu is in its opened state.
        protected var d_popupClosing:Boolean = false;    //!< true when the d_popupTimerTimeElapsed timer is running to close the popup (another menu item of our container is hovered)
        protected var d_popupOpening:Boolean = false;    //!< true when the d_popupTimerTimeElapsed timer is running to open the popup (the menu item is hovered)
        protected var d_autoPopupTimeout:Number = 0.0; //!< the time in seconds, to wait before opening / closing the popup if the mouse is over the item / over another item in our container
        protected var d_autoPopupTimeElapsed:Number = 0.0;  //!< the current time, which is already elapsed if the timer is running (d_popupClosing or d_popupOpening is true)
        
        protected var d_popup:FlamePopupMenu = null;    //!< PopupMenu that this item displays when activated.
        
        protected var d_popupWasClosed:Boolean = false;  //!< Used internally to determine if a popup was just closed on a Clicked event
        
        protected var d_popupOffset:UVector2 = new UVector2(new UDim(), new UDim()); //!< current offset for popup placement.
        

        /*************************************************************************
         Construction and Destruction
         *************************************************************************/
        /*!
        \brief
        Constructor for MenuItem objects
        */
        public function FlameMenuItem(type:String, name:String)
        {
            super(type, name);
            
            // menuitems dont want multi-click events
            setWantsMultiClickEvents(false);
            // add the new properties
            addMenuItemProperties();
            d_popupOffset.d_x = Misc.cegui_absdim(0);
            d_popupOffset.d_y = Misc.cegui_absdim(0);
        }
        
     
        /*************************************************************************
         Accessor type functions
         *************************************************************************/
        /*!
        \brief
        return true if user is hovering over this widget (or it's pushed and user is not over it for highlight)
        
        \return
        true if the user is hovering or if the button is pushed and the mouse is not over the button.  Otherwise return false.
        */
        public function isHovering():Boolean
        {
            return d_hovering;
        }
        
        
        /*!
        \brief
        Return true if the button widget is in the pushed state.
        
        \return
        true if the button-type widget is pushed, false if the widget is not pushed.
        */
        public function isPushed():Boolean
        {
            return d_pushed;
        }
        
        
        /*!
        \brief
        Returns true if the popup menu attached to the menu item is open.
        */
        public function isOpened():Boolean
        {
            return d_opened;
        }
        
        /*!
        \brief
        Returns true if the menu item popup is closing or not.
        */
        public function isPopupClosing():Boolean
        {
            return d_popupClosing;
        }
        
        /*!
        \brief
        Returns true if the menu item popup is closed or opened automatically if hovering with the mouse.
        */
        public function hasAutoPopup():Boolean
        {
            return d_autoPopupTimeout > 0.0;
        }
        
        /*!
        \brief
        Returns the time, which has to elapse before the popup window is opened/closed if the hovering state changes.
        */
        public function getAutoPopupTimeout():Number
        {
            return d_autoPopupTimeout;
        }
        
        /*!
        \brief
        Sets the time, which has to elapse before the popup window is opened/closed if the hovering state changes.
        */
        public function setAutoPopupTimeout(time:Number):void
        {
            d_autoPopupTimeout = time;
        }
        
        /*!
        \brief
        Get the PopupMenu that is currently attached to this MenuItem.
        
        \return
        A pointer to the currently attached PopupMenu.  Null is there is no PopupMenu attached.
        */
        public function getPopupMenu():FlamePopupMenu
        {
            return d_popup;
        }
        
        /*!
        \brief
        Returns the current offset for popup placement.
        */
        public function getPopupOffset():UVector2
        {
            return d_popupOffset;
        }
        
        /*!
        \brief
        sets the current offset for popup placement.
        */
        public function setPopupOffset(popupOffset:UVector2):void
        {
            d_popupOffset = popupOffset;
        }
        
        /*************************************************************************
         Manipulators
         *************************************************************************/
        /*!
        \brief
        Set the popup menu for this item.
        
        \param popup
        popupmenu window to attach to this item
        
        \return
        Nothing.
        */
        public function setPopupMenu(popup:FlamePopupMenu):void
        {
            setPopupMenu_impl(popup);
        }
        
        
        /*!
        \brief
        Opens the PopupMenu.
        
        \param notify
        true if the parent menu bar or menu popup (if any) is to handle the open.
        */
        public function openPopupMenu(notify:Boolean = true):void
        {
            // no popup? or already open...
            if (d_popup == null || d_opened)
                return;
            
            d_popupOpening = false;
            d_popupClosing = false;
            
            // should we notify ?
            // if so, and we are attached to a menu bar or popup menu, we let it handle the "activation"
            var p:FlameWindow = d_ownerList;
            
            if (notify && p)
            {
                if (p.testClassName("Menubar"))
                {
                    // align the popup to the bottom-left of the menuitem
                    var pos:UVector2 = new UVector2(Misc.cegui_absdim(0), Misc.cegui_absdim(d_pixelSize.d_height));
                    d_popup.setPosition(pos.add(d_popupOffset));
                    
                    (p as FlameMenubar).changePopupMenuItem(this);
                    return; // the rest is handled when the menu bar eventually calls us itself
                }
                    // or maybe a popup menu?
                else if (p.testClassName("PopupMenu"))
                {
                    // align the popup to the top-right of the menuitem
                    pos = new UVector2(Misc.cegui_absdim(d_pixelSize.d_width), Misc.cegui_absdim(0));
                    d_popup.setPosition(pos.add(d_popupOffset));
                    
                    (p as FlamePopupMenu).changePopupMenuItem(this);
                    return; // the rest is handled when the popup menu eventually calls us itself
                }
            }
            
            // by now we must handle it ourselves
            // match up with Menubar::changePopupMenu
            d_popup.openPopupMenu(false);
            
            d_opened = true;
            invalidate();
        }
        
        
        /*!
        \brief
        Closes the PopupMenu.
        
        \param notify
        true if the parent menubar (if any) is to handle the close.
        
        \return
        Nothing.
        */
        public function closePopupMenu(notify:Boolean = true):void
        {
            // no popup? or not open...
            if (d_popup == null || !d_opened)
                return;
            
            d_popupOpening = false;
            d_popupClosing = false;
            
            // should we notify the parent menu base?
            // if we are attached to a menu base, we let it handle the "deactivation"
            var p:FlameWindow = d_ownerList;
            
            if (notify && p && p.testClassName("MenuBase"))
            {
                var menu:FlameMenuBase = p as FlameMenuBase;
                
                // only if the menu base does not allow multiple popups
                if (!menu.isMultiplePopupsAllowed())
                {
                    menu.changePopupMenuItem(null);
                    return; // the rest is handled when the menu base eventually call us again itself
                }
            }
                // otherwise we do ourselves
            else
            {
                // match up with Menubar::changePopupMenu
                //d_popup->hide();
                d_popup.closePopupMenu(false);
            }
            
            d_opened = false;
            invalidate();
        }
        
        
        /*!
        \brief
        Toggles the PopupMenu.
        
        \return
        true if the popup was opened. false if it was closed.
        */
        public function togglePopupMenu():Boolean
        {
            if (d_opened)
            {
                closePopupMenu();
                return false;
            }
            
            openPopupMenu();
            return true;
        }
        
        /*!
        \brief
        starts the closing timer for the popup, which will close it if the timer is enabled.
        */
        public function startPopupClosing():void
        {
            d_popupOpening = false;
            
            if (d_opened)
            {
                d_autoPopupTimeElapsed = 0.0;
                d_popupClosing = true;
                invalidate();
            }
            else
            {
                d_popupClosing = false;
            }
        }
        
        /*!
        \brief
        starts the opening timer for the popup, which will open it if the timer is enabled.
        */
        public function startPopupOpening():void
        {
            d_popupClosing = false;
            
            if (d_opened)
            {
                d_popupOpening = false;
            }
            else
            {
                d_autoPopupTimeElapsed = 0.0;
                d_popupOpening = true;
            }
        }

        
        
        
        /*************************************************************************
         New Event Handlers
         *************************************************************************/
        /*!
        \brief
        handler invoked internally when the MenuItem is clicked.
        */
        protected function onClicked(e:WindowEventArgs):void
        {
            // close the popup if we did'nt spawn a child
            if (!d_opened && !d_popupWasClosed)
            {
                closeAllMenuItemPopups();
            }
            
            d_popupWasClosed = false;
            fireEvent(EventClicked, e, EventNamespace);
        }
        
        
        /*************************************************************************
         Overridden event handlers
         *************************************************************************/
        override public function onMouseMove(e:MouseEventArgs):void
        {
            // this is needed to discover whether mouse is in the widget area or not.
            // The same thing used to be done each frame in the rendering method,
            // but in this version the rendering method may not be called every frame
            // so we must discover the internal widget state here - which is actually
            // more efficient anyway.
            
            // base class processing
            super.onMouseMove(e);
            
            updateInternalState(e.position);
            ++e.handled;
        }
        
        
        override public function onMouseButtonDown(e:MouseEventArgs):void
        {
            // default processing
            super.onMouseButtonDown(e);
            
            if (e.button == Consts.MouseButton_LeftButton)
            {
                d_popupWasClosed = false;
                
                if (captureInput())
                {
                    d_pushed = true;
                    updateInternalState(e.position);
                    d_popupWasClosed = !togglePopupMenu();
                    invalidate();
                }
                
                // event was handled by us.
                ++e.handled;
            }
        }
    
        override public function onMouseButtonUp(e:MouseEventArgs):void
        {
            // default processing
            super.onMouseButtonUp(e);
            
            if (e.button == Consts.MouseButton_LeftButton)
            {
                releaseInput();
                
                // was the button released over this window?
                // (use mouse position, as e.position in args has been unprojected)
                if (!d_popupWasClosed &&
                    FlameSystem.getSingleton().getGUISheet().getTargetChildAtPosition(
                        FlameMouseCursor.getSingleton().getPosition()) == this)
                {
                    var we:WindowEventArgs = new WindowEventArgs(this);
                    onClicked(we);
                }
                
                // event was handled by us.
                ++e.handled;
            }
        }
        
        
        override protected function onCaptureLost(e:WindowEventArgs):void
        {
            // Default processing
            super.onCaptureLost(e);
            
            d_pushed = false;
            updateInternalState(
                getUnprojectedPosition(FlameMouseCursor.getSingleton().getPosition()));
            invalidate();
            
            // event was handled by us.
            ++e.handled;
        }
        
        override public function onMouseLeaves(e:MouseEventArgs):void
        {
            // deafult processing
            super.onMouseLeaves(e);
            
            d_hovering = false;
            invalidate();
            
            ++e.handled;
        }
        
        override protected function onTextChanged(e:WindowEventArgs):void
        {
            super.onTextChanged(e);
            
            // if we are attached to a ItemListBase, we make it update as necessary
            var parent:FlameWindow = getParent();
            
            if (parent && parent.testClassName("ItemListBase"))
            {
                (parent as FlameItemListBase).handleUpdatedItemData();
            }
            
            ++e.handled;
        }
        
        override protected function updateSelf(elapsed:Number):void
        {
            super.updateSelf(elapsed);
            
            //handle delayed popup closing/opening when hovering with the mouse
            if (d_autoPopupTimeout != 0.0 && (d_popupOpening || d_popupClosing))
            {
                // stop timer if the hovering state isn't set appropriately anymore
                if (d_hovering)
                {
                    d_popupClosing = false;
                }
                else
                {
                    d_popupOpening = false;
                }
                
                //check if the timer elapsed and take action appropriately
                d_autoPopupTimeElapsed += elapsed;
                
                if (d_autoPopupTimeElapsed > d_autoPopupTimeout)
                {
                    if (d_popupOpening)
                    {
                        d_popupOpening = false;
                        openPopupMenu(true);
                    }
                    else if (d_popupClosing)
                    {
                        d_popupClosing = false;
                        closePopupMenu(true);
                    }
                }
            }
        }
        
        
        /*************************************************************************
         Implementation Functions
         *************************************************************************/
        /*!
        \brief
        Update the internal state of the widget with the mouse at the given position.
        
        \param mouse_pos
        Point object describing, in screen pixel co-ordinates, the location of the mouse cursor.
        
        \return
        Nothing
        */
        protected function updateInternalState(mouse_pos:Vector2):void
        {
            var oldstate:Boolean = d_hovering;
            
            // assume not hovering
            d_hovering = false;
            
            // if input is captured, but not by 'this', then we never hover highlight
            const capture_wnd:FlameWindow = getCaptureWindow();
            
            if (capture_wnd == null)
            {
                var sys:FlameSystem = FlameSystem.getSingleton();
                
                if (sys.getWindowContainingMouse() == this && isHit(mouse_pos))
                {
                    d_hovering = true;
                }
            }
            else if (capture_wnd == this && isHit(mouse_pos))
            {
                d_hovering = true;
            }
            
            // if state has changed, trigger a re-draw
            // and possible make the parent menu open another popup
            if (oldstate != d_hovering)
            {
                // are we attached to a menu ?
                if (d_ownerList && d_ownerList.testClassName("MenuBase"))
                {
                    if (d_hovering)
                    {
                        var menu:FlameMenuBase = d_ownerList as FlameMenuBase;
                        // does this menubar only allow one popup open? and is there a popup open?
                        const curpopup:FlameMenuItem = menu.getPopupMenuItem();
                        
                        if (!menu.isMultiplePopupsAllowed())
                        {
                            if (curpopup != this && curpopup != null)
                            {
                                if (!hasAutoPopup())
                                {
                                    // open this popup instead
                                    openPopupMenu();
                                }
                                else
                                {
                                    // start close timer on current popup
                                    menu.setPopupMenuItemClosing();
                                    startPopupOpening();
                                }
                            }
                            else
                            {
                                startPopupOpening();
                            }
                        }
                    }
                }
                
                invalidate();
            }
        }
        
        /*!
        \brief
        Recursive function that closes all popups down the hierarcy starting with this one.
        
        \return
        Nothing.
        */
        public function closeAllMenuItemPopups():void
        {
            // are we attached to a PopupMenu?
            var p:FlameWindow = d_ownerList;
            
            if (p && p.testClassName("Menubar"))
            {
                closePopupMenu();
                return;
            }
            
            if (p && p.testClassName("PopupMenu"))
            {
                var pop:FlamePopupMenu = p as FlamePopupMenu;
                // is this parent popup attached to a menu item?
                p = pop.getParent();
                
                if (p && p.testClassName("MenuItem"))
                {
                    var mi:FlameMenuItem = p as FlameMenuItem;
                    // recurse
                    mi.closeAllMenuItemPopups();
                }
                    // otherwise we just hide the parent popup
                else
                {
                    pop.closePopupMenu(false);
                }
            }
        }
        
        
        /*!
        \brief
        Set the popup menu for this item.
        
        \param popup
        popupmenu window to attach to this item
        
        \return
        Nothing.
        */
        public function setPopupMenu_impl(popup:FlamePopupMenu, add_as_child:Boolean = true):void
        {
            // is it the one we have already ?
            if (popup == d_popup)
            {
                // then do nothing;
                return;
            }
            
            // keep the old one around
            var old_popup:FlamePopupMenu = d_popup;
            // update the internal state pointer
            d_popup = popup;
            d_opened = false;
            
            // is there already a popup ?
            if (old_popup)
            {
                removeChildWindow(old_popup);
                
                // should we destroy it as well?
                if (old_popup.isDestroyedByParent())
                {
                    // then do so
                    FlameWindowManager.getSingleton().destroyWindow(old_popup);
                }
            }
            
            // we are setting a new popup and not just clearing. and we are told to add the child
            if (popup != null && add_as_child)
            {
                addChildWindow(popup);
            }
            
            invalidate();
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
            if (class_name == "MenuItem") return true;
            
            return super.testClassName_impl(class_name);
        }
        
        /*************************************************************************
         Private methods
         *************************************************************************/
        private function addMenuItemProperties():void
        {
            addProperty(d_popupOffsetProperty);
            addProperty(d_autoPopupTimeoutProperty);
        }
        
        /*!
        \brief
        Add given window to child list at an appropriate position
        */
        override protected function addChild_impl(wnd:FlameWindow):void
        {
            super.addChild_impl(wnd);
            
            // if this is a PopupMenu we add it like one
            if (wnd.testClassName("PopupMenu"))
            {
                setPopupMenu_impl(wnd as FlamePopupMenu, false);
            }
        }
    }
}