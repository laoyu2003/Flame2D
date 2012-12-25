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
    import Flame2D.elements.base.FlameItemListBase;
    import Flame2D.core.events.WindowEventArgs;

    /*!
    \brief
    Abstract base class for menus.
    */
    public class FlameMenuBase extends FlameItemListBase
    {
        public static const EventNamespace:String = "MenuBase";             //!< Namespace for global events
        
        
        /*************************************************************************
         Event name constants
         *************************************************************************/
        // generated internally by Window
        /** Event fired when a MenuItem attached to this menu opened a PopupMenu.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the PopupMenu that was opened.
         */
        public static const EventPopupOpened:String = "PopupOpened";
        /** Event fired when a MenuItem attached to this menu closed a PopupMenu.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the PopupMenu that was closed.
         */
        public static const EventPopupClosed:String = "PopupClosed";
        
        /*************************************************************************
         Static Properties for this class
         *************************************************************************/
        private static var d_itemSpacingProperty:MenuBasePropertyItemSpacing = new MenuBasePropertyItemSpacing();
        private static var d_allowMultiplePopupsProperty:MenuBasePropertyAllowMultiplePopups = new MenuBasePropertyAllowMultiplePopups();
        private static var d_autoCloseNestedPopupsProperty:MenuBasePropertyAutoCloseNestedPopups = new MenuBasePropertyAutoCloseNestedPopups();

        
        
        
        /*************************************************************************
         Implementation Data
         *************************************************************************/
        protected var d_itemSpacing:Number = 0.0;        //!< The spacing in pixels between items.
        
        protected var d_popupItem:FlameMenuItem = null;      //!< The currently open MenuItem. NULL if no item is open. If multiple popups are allowed, this means nothing.
        protected var d_allowMultiplePopups:Boolean = false; //!< true if multiple popup menus are allowed simultaneously.  false if not.
        protected var d_autoCloseNestedPopups:Boolean = false; //!< true if the menu should close all its open child popups, when it gets hidden
        
        
        
        
        /*************************************************************************
         Construction and Destruction
         *************************************************************************/
        /*!
        \brief
        Constructor for MenuBase objects
        */
        public function FlameMenuBase(type:String, name:String)
        {
            super(type, name);
            
            // add properties for MenuBase class
            addMenuBaseProperties();
        }
        
        
        
        
        
        /*************************************************************************
         Accessor type functions
         *************************************************************************/
        /*!
        \brief
        Get the item spacing for this menu.
        
        \return
        A float value with the current item spacing for this menu
        */
        public function getItemSpacing():Number
        {
            return d_itemSpacing;
        }
        
        
        /*!
        \brief
        Return whether this menu allows multiple popup menus to open at the same time.
        
        \return
        true if this menu allows multiple popup menus to be opened simultaneously. false if not
        */
        public function isMultiplePopupsAllowed():Boolean
        {
            return d_allowMultiplePopups;
        }
        
        /*!
        \brief
        Return whether this menu should close all its open child popups, when it gets hidden
        
        \return
        true if the menu should close all its open child popups, when it gets hidden
        */
        public function getAutoCloseNestedPopups():Boolean
        {
            return d_autoCloseNestedPopups;
        }
        
        /*!
        \brief
        Get currently opened MenuItem in this menu. Returns NULL if no menu item is open.
        
        \return
        Pointer to the MenuItem currently open.
        */
        public function getPopupMenuItem():FlameMenuItem
        {
            return d_popupItem;
        }
        
        
        /*************************************************************************
         Manipulators
         *************************************************************************/
        /*!
        \brief
        Set the item spacing for this menu.
        */
        public function setItemSpacing(spacing:Number):void
        {
            d_itemSpacing = spacing;
            handleUpdatedItemData();
        }
        
        
        /*!
        \brief
        Change the currently open MenuItem in this menu.
        
        \param item
        Pointer to a MenuItem to open or NULL to close any opened.
        */
        public function changePopupMenuItem(item:FlameMenuItem):void
        {
            if (!d_allowMultiplePopups && d_popupItem == item)
                return;
            
            if (!d_allowMultiplePopups && d_popupItem != null)
            {
                var args:WindowEventArgs = new WindowEventArgs(d_popupItem.getPopupMenu());
                d_popupItem.closePopupMenu(false);
                d_popupItem = null;
                onPopupClosed(args);
            }
            
            if (item)
            {
                d_popupItem = item;
                d_popupItem.openPopupMenu(false);
                var args2:WindowEventArgs = new WindowEventArgs(d_popupItem.getPopupMenu());
                onPopupOpened(args2);
            }
        }
        
        
        /*!
        \brief
        Set whether this menu allows multiple popup menus to be opened simultaneously.
        */
        public function setAllowMultiplePopups(setting:Boolean):void
        {
            if (d_allowMultiplePopups != setting)
            {
                // TODO :
                // close all popups except perhaps the last one opened!
                d_allowMultiplePopups = setting;
            }
        }
        
        /*!
        \brief
        Set whether the menu should close all its open child popups, when it gets hidden
        */
        public function setAutoCloseNestedPopups(setting:Boolean):void
        {
            d_autoCloseNestedPopups = setting;
        }
        /*!
        \brief
        tells the current popup that it should start its closing timer.
        */
        public function setPopupMenuItemClosing():void
        {
            if (d_popupItem)
            {
                d_popupItem.startPopupClosing();
            }
        }
        

        /*************************************************************************
         New Event Handlers
         *************************************************************************/
        /*!
        \brief
        handler invoked internally when the a MenuItem attached to this menu opens its popup.
        */
        protected function onPopupOpened(e:WindowEventArgs):void
        {
            fireEvent(EventPopupOpened, e, EventNamespace);
        }
        
        
        /*!
        \brief
        handler invoked internally when the a MenuItem attached to this menu closes its popup.
        */
        protected function onPopupClosed(e:WindowEventArgs):void
        {
            fireEvent(EventPopupClosed, e, EventNamespace);
        }
        
        // overridden from base
        override protected function onChildRemoved(e:WindowEventArgs):void
        {
            // if the removed window was our tracked popup item, zero ptr to it.
            if (e.window == d_popupItem)
                d_popupItem = null;
            
            // base class version
            super.onChildRemoved(e);
        }
        
        override protected function onHidden(e:WindowEventArgs):void
        {
            if (!getAutoCloseNestedPopups())
                return;
            
            changePopupMenuItem(null);
            
            if (d_allowMultiplePopups)
            {
                for (var i:uint = 0; i < d_listItems.length; ++i)
                {
                    if (!d_listItems[i])
                        continue;
                    
                    if (!d_listItems[i].testClassName("MenuItem"))
                        continue;
                    
                    var menuItem:FlameMenuItem = d_listItems[i] as FlameMenuItem;
                    if (!menuItem.getPopupMenu())
                        continue;
                    
                    var args:WindowEventArgs = new WindowEventArgs(menuItem.getPopupMenu());
                    menuItem.closePopupMenu(false);
                    onPopupClosed(args);
                }
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
            if (class_name == "MenuBase") return true;
            
            return super.testClassName_impl(class_name);
        }
        
        /*************************************************************************
         Private methods
         *************************************************************************/
        private function addMenuBaseProperties():void
        {
            addProperty(d_itemSpacingProperty);
            addProperty(d_allowMultiplePopupsProperty);
            addProperty(d_autoCloseNestedPopupsProperty);
        }
    }
}