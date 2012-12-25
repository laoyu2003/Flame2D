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
    import Flame2D.core.events.KeyEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.URect;
    import Flame2D.core.utils.UVector2;
    
    public class FlameItemListbox extends FlameScrolledItemListBase
    {
        public static const EventNamespace:String = "ItemListbox";
        public static const WidgetTypeName:String = "CEGUI/ItemListbox";
        
        
        /************************************************************************
         Constants
         *************************************************************************/
        /** Event fired when the list selection changes.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ItemListbox whose current selection
         * has been changed.
         */
        public static const EventSelectionChanged:String = "SelectionChanged";
        /** Event fired when the multiselect mode of the list box is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ItemListbox whose multiselect mode
         * has been changed.
         */
        public static const EventMultiSelectModeChanged:String = "MultiSelectModeChanged";
        
        /************************************************************************
         Implementation data
         ************************************************************************/
        protected var d_multiSelect:Boolean = false; //! Controls whether multiple items can be selected simultaneously
        protected var d_lastSelected:FlameItemEntry = null; //! The last item that was selected
        protected var d_nextSelectionIndex:uint = 0; //! The index of the last item that was returned with the getFirst/NextSelection members
        
        /************************************************************************
         Static Properties for this class
         ************************************************************************/
        private static var d_multiSelectProperty:ItemListboxPropertyMultiSelect = new ItemListboxPropertyMultiSelect();

        /************************************************************************
         Object Construction and Destruction
         *************************************************************************/
        /*!
        \brief
        Constructor for the ItemListbox base class constructor.
        */
        public function FlameItemListbox(type:String, name:String)
        {
            super(type, name);
            
            addItemListboxProperties();
        }
        

        
        
        
        /************************************************************************
         Accessors
         *************************************************************************/
        /*!
        \brief
        Returns the number of selected items in this ItemListbox.
        */
        public function getSelectedCount():uint
        {
            if (!d_multiSelect)
            {
                return d_lastSelected ? 1 : 0;
            }
            
            var count:uint = 0;
            var max:uint = d_listItems.length
            for (var i:uint=0; i<max; ++i)
            {
                if (d_listItems[i].isSelected())
                {
                    ++count;
                }
            }
            
            return count;
        }
        
        /*!
        \brief
        Returns a pointer to the last selected item.
        
        \return
        A pointer to the last selected item, 0 is none.
        */
        public function getLastSelectedItem():FlameItemEntry
        {
            return d_lastSelected;
        }
        
        /*!
        \brief
        Returns a pointer to the first selected item
        
        \param start_index
        The index where the search should begin. If omitted the search will
        begin with the first item.
        
        \return
        A pointer to the first selected item in the listbox.
        If no item is selected the return value is 0.
        If \a start_index is out of bounds the return value is 0.
        
        \note
        If multiselect is disabled then this does the equivalent of calling
        getLastSelectedItem.
        If multiselect is enabled it will search the array starting at \a start_index
        */
        public function getFirstSelectedItem(start_index:uint = 0) : FlameItemEntry
        {
            if (!d_multiSelect)
            {
                return d_lastSelected;
            }
            return findSelectedItem(start_index);
        }
        
        /*!
        \brief
        Returns a pointer to the next seleced item relative to a previous call to
        getFirstSelectedItem or getNextSelectedItem.
        
        \return
        A pointer to the next seleced item. If there are no further selected items
        the return value is 0.
        If multiselect is disabled the return value is 0.
        
        \note
        This member function will take on from where the last call to
        getFirstSelectedItem or getNextSelectedItem returned. So be sure to start with a
        call to getFirstSelectedItem.
        
        This member function should be preferred over getNextSelectedItemAfter as it will
        perform better, especially on large lists.
        */
        public function getNextSelectedItem():FlameItemEntry
        {
            if (!d_multiSelect)
            {
                return null;
            }
            return findSelectedItem(d_nextSelectionIndex);
        }
        
        /*!
        \brief
        Returns a pointer to the next selected item after the item 'start_item' given.
        
        \note
        This member function will search the array from the beginning and will be slow
        for large lists, it will not advance the internal counter used by
        getFirstSelectedItem and getNextSelectedItem either.
        */
        public function getNextSelectedItemAfter(start_item:FlameItemEntry):FlameItemEntry
        {
            if (start_item == null||!d_multiSelect)
            {
                return null;
            }
            
            var max:uint = d_listItems.length;
            var i:uint = getItemIndex(start_item);
            
            while (i<max)
            {
                var li:FlameItemEntry = d_listItems[i];
                if (li.isSelected())
                {
                    return li;
                }
                ++i;
            }
            
            return null;
        }
        
        /*!
        \brief
        Returns 'true' if multiple selections are allowed. 'false' if not.
        */
        public function isMultiSelectEnabled():Boolean
        {
            return d_multiSelect;
        }
        
        /*!
        \brief
        Returns 'true' if the item at the given index is selectable and currently selected.
        */
        public function isItemSelected(index:uint):Boolean
        {
            if (index >= d_listItems.length)
            {
                throw new Error("ItemListbox::isItemSelected - The index given is out of range for this ItemListbox");
            }
            var li:FlameItemEntry = d_listItems[index];
            return li.isSelected();
        }
        
        /************************************************************************
         Manipulators
         *************************************************************************/
        // Overridden from base class
        override public function initialiseComponents():void
        {
            // call base implementation
            super.initialiseComponents();
            
            d_pane.subscribeEvent(FlameWindow.EventChildRemoved, new Subscriber(handle_PaneChildRemoved, this), FlameWindow.EventNamespace);
        }
        
        /*!
        \brief
        Set whether or not multiple selections should be allowed.
        */
        public function setMultiSelectEnabled(state:Boolean):void
        {
            if (state != d_multiSelect)
            {
                d_multiSelect = state;
                var e:WindowEventArgs = new WindowEventArgs(this);
                onMultiSelectModeChanged(e);
            }
        }
        
        /*!
        \brief
        Clears all selections.
        */
        public function clearAllSelections():void
        {
            var max:uint = d_listItems.length;
            for (var i:uint=0; i<max; ++i)
            {
                d_listItems[i].setSelected_impl(false,false);
            }
            d_lastSelected = null;
            
            var e:WindowEventArgs = new WindowEventArgs(this);
            onSelectionChanged(e);
        }
        
        /*!
        \brief
        Select a range of items.
        
        \param a
        Start item. (inclusive)
        
        \param z
        End item. (inclusive)
        */
        public function selectRange(a:uint, z:uint):void
        {
            // do nothing if the list is empty
            if (d_listItems.length == 0)
            {
                return;
            }
            
            var max:uint = d_listItems.length;
            if (a >= max)
            {
                a = 0;
            }
            if (z >= max)
            {
                z = max-1;
            }
            
            if (a>z)
            {
                var tmp:uint = a;
                a = z;
                z = tmp;
            }
            
            for (var i:uint=a; i<=z; ++i)
            {
                d_listItems[i].setSelected_impl(true,false);
            }
            d_lastSelected = d_listItems[z];
            
            
            var e:WindowEventArgs = new WindowEventArgs(this);
            onSelectionChanged(e);
        }
        
        /*!
        \brief
        Select all items.
        Does nothing if multiselect is disabled.
        */
        public function selectAllItems():void
        {
            if (!d_multiSelect)
            {
                return;
            }
            
            var max:uint = d_listItems.length;
            for (var i:uint=0; i<max; ++i)
            {
                d_lastSelected = d_listItems[i];
                d_lastSelected.setSelected_impl(true,false);
            }
            
            var e:WindowEventArgs = new WindowEventArgs(this);
            onSelectionChanged(e);
        }
        

        /************************************************************************
         Implementation functions
         ************************************************************************/
        /*!
        \brief
        Setup size and position for the item widgets attached to this ItemListbox
        */
        override protected function layoutItemWidgets():void
        {
            var y:Number = 0;
            var widest:Number = 0;
            
            //ItemEntryList::iterator i = d_listItems.begin();
            //ItemEntryList::iterator end = d_listItems.end();
            
            for(var i:uint = 0; i < d_listItems.length; i++)
            {
                var entry:FlameItemEntry = d_listItems[i];
                const pxs:Size = entry.getItemPixelSize();
                if (pxs.d_width > widest)
                {
                    widest = pxs.d_width;
                }
                
                entry.setArea(
                    new UVector2(Misc.cegui_absdim(0), Misc.cegui_absdim(y)),
                    new UVector2(Misc.cegui_reldim(1), Misc.cegui_absdim(pxs.d_height))
                );
                
                y+=pxs.d_height;
            }
            
            // reconfigure scrollbars
            configureScrollbars(new Size(widest,y));
        }
        
        /*!
        \brief
        Returns the Size in unclipped pixels of the content attached to this ItemListbox.
        */
        override protected function getContentSize():Size
        {
            var h:Number = 0;
            
            for(var i:uint = 0; i < d_listItems.length; i++)
            {
                h += d_listItems[i].getItemPixelSize().d_height;
            }
            
            return new Size(getItemRenderArea().getWidth(), h);
        }
        
        /*!
        \brief
        Return whether this window was inherited from the given class name at some point
        in the inheritance hierarchy.
        
        \param class_name
        The class name that is to be checked.
        
        \return
        true if this window was inherited from \a class_name. false if not.
        */
        override protected function testClassName_impl(class_name:String):Boolean
        {
            if (class_name=="ItemListbox")
            {
                return true;
            }
            return super.testClassName_impl(class_name);
        }
        
        /*!
        \brief
        Notify this ItemListbox that the given ListItem was just clicked.
        Internal function - not to be used from client code.
        */
        override public function notifyItemClicked(li:FlameItemEntry):void
        {
            var sel_state:Boolean = !(li.isSelected() && d_multiSelect);
            var skip:Boolean = false;
            
            // multiselect enabled
            if (d_multiSelect)
            {
                var syskeys:uint = FlameSystem.getSingleton().getSystemKeys();
                var last:FlameItemEntry = d_lastSelected;
                
                // no Control? clear others
                if (!(syskeys & Consts.SystemKey_Control))
                {
                    clearAllSelections();
                    if (!sel_state)
                    {
                        sel_state=true;
                    }
                }
                
                // select range if Shift if held, and we have a 'last selection'
                if (last && (syskeys & Consts.SystemKey_Shift))
                {
                    selectRange(getItemIndex(last),getItemIndex(li));
                    skip = true;
                }
            }
            else
            {
                clearAllSelections();
            }
            
            if (!skip)
            {
                li.setSelected_impl(sel_state,false);
                if (sel_state)
                {
                    d_lastSelected = li;
                }
                else if (d_lastSelected == li)
                {
                    d_lastSelected = null;
                }
            }
            
            var e:WindowEventArgs = new WindowEventArgs(this);
            onSelectionChanged(e);
        }
        
        /*!
        \brief
        Notify this ItemListbox that the given ListItem just changed selection state.
        Internal function - not to be used from client code.
        */
        override public function notifyItemSelectState(li:FlameItemEntry, state:Boolean):void
        {
            // deselect
            if (!state)
            {
                // clear last selection if this one was it
                if (d_lastSelected == li)
                {
                    d_lastSelected = null;
                }
            }
                // if we dont support multiselect, we must clear all the other selections
            else if (!d_multiSelect)
            {
                clearAllSelections();
                li.setSelected_impl(true,false);
                d_lastSelected = li;
            }
            
            var e:WindowEventArgs = new WindowEventArgs(this);
            onSelectionChanged(e);
        }
        
        /************************************************************************
         Protected implementation functions
         ************************************************************************/
        /*!
        \brief
        Returns a pointer to the first selected item starting the search
        from \a start_index
        
        \param start_index
        The index where the search should begin (inclusive)
        
        \return
        A pointer to the first selected item in the listbox found
        If no item is selected the return value is 0
        If \a start_index is out of bounds the return value is 0
        
        \note
        This function advances the internal counter and is made for
        getFirstSelectedItem and getNextSelectedItem
        */
        private function findSelectedItem(start_index:uint):FlameItemEntry
        {
            var max:uint = d_listItems.length;
            if (start_index >= max)
            {
                return null;
            }
            
            for (var i:uint=start_index; i<max; ++i)
            {
                var li:FlameItemEntry = d_listItems[i];
                if (li.isSelected())
                {
                    d_nextSelectionIndex = i;
                    return li;
                }
            }
            
            return null;
        }
        
        /************************************************************************
         New event handlers
         ************************************************************************/
        protected function onSelectionChanged(e:WindowEventArgs):void
        {
            fireEvent(EventSelectionChanged, e, EventNamespace);
        }
        
        protected function onMultiSelectModeChanged(e:WindowEventArgs):void
        {
            fireEvent(EventMultiSelectModeChanged, e, EventNamespace);
        }
        
        /************************************************************************
         Overridden event handlers
         ************************************************************************/
        override public function onKeyDown(e:KeyEventArgs):void
        {
            super.onKeyDown(e);
            
            // select all (if allowed) on Ctrl+A
            if (d_multiSelect)
            {
                var sysKeys:uint = FlameSystem.getSingleton().getSystemKeys();
                if (e.scancode == Consts.Key_A && (sysKeys & Consts.SystemKey_Control))
                {
                    selectAllItems();
                    ++e.handled;
                }
            }
        }
        
        private function addItemListboxProperties():void
        {
            addProperty(d_multiSelectProperty);
        }
        
        private function addItemListboxEvents():void
        {
            
        }
        
        //! Handler called when window is removed from the content pane
        override public function handle_PaneChildRemoved(e:EventArgs):Boolean
        {
            // get the window that's being removed
            const w:FlameWindow = (e as WindowEventArgs).window;
            // Clear last selected pointer if that item was just removed.
            if (w == d_lastSelected)
                d_lastSelected = null;
            
            return true;
        }
    }
}