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
package Flame2D.elements.listbox
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.system.FlameEventManager;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.CoordConverter;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Vector2;
    import Flame2D.elements.base.FlameScrollbar;
    import Flame2D.elements.tooltip.FlameTooltip;
    
    public class FlameListbox extends FlameWindow
    {
        public static const EventNamespace:String = "Listbox";
        public static const WidgetTypeName:String = "CEGUI/Listbox";
        
        /*************************************************************************
         Constants
         *************************************************************************/
        // event names
        /** Event fired when the contents of the list is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Listbox whose content is changed.
         */
        public static const EventListContentsChanged:String = "ListItemsChanged";
        /** Event fired when there is a change to the currently selected item(s)
         * within the list.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Litbox that has had a change in the
         * selected items.
         */
        public static const EventSelectionChanged:String = "ItemSelectionChanged";
        /** Event fired when the sort mode setting changes for the Listbox.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Listbox whose sort mode has been
         * changed.
         */
        public static const EventSortModeChanged:String = "SortModeChanged";
        /** Event fired when the multi-select mode setting changes for the Listbox.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Listbox whose multi-select mode has
         * been changed.
         */
        public static const EventMultiselectModeChanged:String = "MuliselectModeChanged";
        /** Event fired when the mode setting that forces the display of the
         * vertical scroll bar for the Listbox is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Listbox whose vertical
         * scrollbar mode has been changed.
         */
        public static const EventVertScrollbarModeChanged:String = "VertScrollModeChanged";
        /** Event fired when the mode setting that forces the display of the
         * horizontal scroll bar for the Listbox is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Listbox whose horizontal
         * scrollbar mode has been changed.
         */
        public static const EventHorzScrollbarModeChanged:String = "HorzScrollModeChanged";
        
        /*************************************************************************
         Child Widget name suffix constants
         *************************************************************************/
        public static const VertScrollbarNameSuffix:String = "__auto_vscrollbar__";   //!< Widget name suffix for the vertical scrollbar component.
        public static const HorzScrollbarNameSuffix:String = "__auto_hscrollbar__";   //!< Widget name suffix for the horizontal scrollbar component.
        

        /*************************************************************************
         Static Properties for this class
         *************************************************************************/
        private static var d_sortProperty:ListboxPropertySort                   = new ListboxPropertySort();
        private static var d_multiSelectProperty:ListboxPropertyMultiSelect     = new ListboxPropertyMultiSelect();
        private static var d_forceVertProperty:ListboxPropertyForceVertScrollbar= new ListboxPropertyForceVertScrollbar();
        private static var d_forceHorzProperty:ListboxPropertyForceHorzScrollbar= new ListboxPropertyForceHorzScrollbar();
        private static var d_itemTooltipsProperty:ListboxPropertyItemTooltips   = new ListboxPropertyItemTooltips();
        
        
        /*************************************************************************
         Implementation Data
         *************************************************************************/
        //typedef	std::vector<ListboxItem*>	LBItemList;
        protected var d_sorted:Boolean = false;				//!< true if list is sorted
        protected var d_multiselect:Boolean = false;			//!< true if multi-select is enabled
        protected var d_forceVertScroll:Boolean = false;		//!< true if vertical scrollbar should always be displayed
        protected var d_forceHorzScroll:Boolean = false;		//!< true if horizontal scrollbar should always be displayed
        protected var d_itemTooltips:Boolean = false;			//!< true if each item should have an individual tooltip
        //LBItemList	d_listItems;		//!< list of items in the list box.
        protected var d_listItems:Vector.<FlameListboxItem> = new Vector.<FlameListboxItem>();
        protected var d_lastSelected:FlameListboxItem = null;	//!< holds pointer to the last selected item (used in range selections)
        
        
        private static var lastItem:FlameListboxItem = null;

        
        public function FlameListbox(type:String, name:String)
        {
               super(type, name);
               
               addListboxProperties();
        }
        
        /*************************************************************************
         Accessor Methods
         *************************************************************************/
        /*!
        \brief
        Return number of items attached to the list box
        
        \return
        the number of items currently attached to this list box.
        */
        public function getItemCount():uint
        {
            return d_listItems.length;
        }
        
        
        /*!
        \brief
        Return the number of selected items in the list box.
        
        \return
        Total number of attached items that are in the selected state.
        */
        public function getSelectedCount():uint
        {
            var count:uint = 0;
            
            for (var index:uint = 0; index < d_listItems.length; ++index)
            {
                if (d_listItems[index].isSelected())
                {
                    count++;
                }
                
            }
            
            return count;
        }
        
        
        /*!
        \brief
        Return a pointer to the first selected item.
        
        \return
        Pointer to a ListboxItem based object that is the first selected item in the list.  will return NULL if
        no item is selected.
        */
        public function getFirstSelectedItem():FlameListboxItem
        {
            return getNextSelected(null);
        }
        
        
        /*!
        \brief
        Return a pointer to the next selected item after item \a start_item
        
        \param start_item
        Pointer to the ListboxItem where the search for the next selected item is to begin.  If this
        parameter is NULL, the search will begin with the first item in the list box.
        
        \return
        Pointer to a ListboxItem based object that is the next selected item in the list after
        the item specified by \a start_item.  Will return NULL if no further items were selected.
        
        \exception	InvalidRequestException	thrown if \a start_item is not attached to this list box.
        */
        public function getNextSelected(start_item:FlameListboxItem):FlameListboxItem
        {
            // if start_item is NULL begin search at begining, else start at item after start_item
            var index:uint = (start_item == null) ? null : (getItemIndex(start_item) + 1);
            
            while (index < d_listItems.length)
            {
                // return pointer to this item if it's selected.
                if (d_listItems[index].isSelected())
                {
                    return d_listItems[index];
                }
                    // not selected, advance to next
                else
                {
                    index++;
                }
                
            }
            
            // no more selected items.
            return null;
        }
        
        
        /*!
        \brief
        Return the item at index position \a index.
        
        \param index
        Zero based index of the item to be returned.
        
        \return
        Pointer to the ListboxItem at index position \a index in the list box.
        
        \exception	InvalidRequestException	thrown if \a index is out of range.
        */
        public function getListboxItemFromIndex(index:uint):FlameListboxItem
        {
            if (index < d_listItems.length)
            {
                return d_listItems[index];
            }
            else
            {
                throw new Error("Listbox::getListboxItemFromIndex - the specified index is out of range for this Listbox.");
            }
        }
        
        
        /*!
        \brief
        Return the index of ListboxItem \a item
        
        \param item
        Pointer to a ListboxItem whos zero based index is to be returned.
        
        \return
        Zero based index indicating the position of ListboxItem \a item in the list box.
        
        \exception	InvalidRequestException	thrown if \a item is not attached to this list box.
        */
        public function getItemIndex(item:FlameListboxItem):uint
        {
            for(var i:uint=0; i<d_listItems.length; i++)
            {
                if(d_listItems[i] == item)
                {
                    return i;
                }
            }
            throw new Error("Listbox::getItemIndex - the specified ListboxItem is not attached to this Listbox.");
        }
        
        
        /*!
        \brief
        return whether list sorting is enabled
        
        \return
        true if the list is sorted, false if the list is not sorted
        */
        public function isSortEnabled():Boolean
        {
            return d_sorted;
        }
        
        /*!
        \brief
        return whether multi-select is enabled
        
        \return
        true if multi-select is enabled, false if multi-select is not enabled.
        */
        public function isMultiselectEnabled():Boolean
        {
            return d_multiselect;
        }
        
        public function isItemTooltipsEnabled():Boolean
        {
            return d_itemTooltips;
        }
        
        /*!
        \brief
        return whether the string at index position \a index is selected
        
        \param index
        Zero based index of the item to be examined.
        
        \return
        true if the item at \a index is selected, false if the item at \a index is not selected.
        
        \exception	InvalidRequestException	thrown if \a index is out of range.
        */
        public function isItemSelected(index:uint):Boolean
        {
            if (index < d_listItems.length)
            {
                return d_listItems[index].isSelected();
            }
            else
            {
                throw new Error("Listbox::isItemSelected - the specified index is out of range for this Listbox.");
            }

        }
        
        
        /*!
        \brief
        Search the list for an item with the specified text
        
        \param text
        String object containing the text to be searched for.
        
        \param start_item
        ListboxItem where the search is to begin, the search will not include \a item.  If \a item is
        NULL, the search will begin from the first item in the list.
        
        \return
        Pointer to the first ListboxItem in the list after \a item that has text matching \a text.  If
        no item matches the criteria NULL is returned.
        
        \exception	InvalidRequestException	thrown if \a item is not attached to this list box.
        */
        public function findItemWithText(text:String, start_item:FlameListboxItem):FlameListboxItem
        {
            // if start_item is NULL begin search at begining, else start at item after start_item
            var index:uint = (!start_item) ? 0 : (getItemIndex(start_item) + 1);
            
            while (index < d_listItems.length)
            {
                // return pointer to this item if it's text matches
                if (d_listItems[index].getText() == text)
                {
                    return d_listItems[index];
                }
                    // no matching text, advance to next item
                else
                {
                    index++;
                }
                
            }
            
            // no items matched.
            return null;
        }
        
        
        /*!
        \brief
        Return whether the specified ListboxItem is in the List
        
        \return
        true if ListboxItem \a item is in the list, false if ListboxItem \a item is not in the list.
        */
        public function isListboxItemInList(item:FlameListboxItem):Boolean
        {
            return d_listItems.indexOf(item) > -1;
        }
        
        
        /*!
        \brief
        Return whether the vertical scroll bar is always shown.
        
        \return
        - true if the scroll bar will always be shown even if it is not required.
        - false if the scroll bar will only be shown when it is required.
        */
        public function isVertScrollbarAlwaysShown():Boolean
        {
            return d_forceVertScroll;
        }
        
        
        /*!
        \brief
        Return whether the horizontal scroll bar is always shown.
        
        \return
        - true if the scroll bar will always be shown even if it is not required.
        - false if the scroll bar will only be shown when it is required.
        */
        public function isHorzScrollbarAlwaysShown():Boolean
        {
            return d_forceHorzScroll;
        }
        
        
        /*************************************************************************
         Manipulator Methods
         *************************************************************************/
        /*!
        \brief
        Initialise the Window based object ready for use.
        
        \note
        This must be called for every window created.  Normally this is handled automatically by the WindowFactory for each Window type.
        
        \return
        Nothing
        */
        override public function initialiseComponents():void
        {
            // get the component sub-widgets
            var vertScrollbar:FlameScrollbar = getVertScrollbar();
            var horzScrollbar:FlameScrollbar = getHorzScrollbar();
            
            vertScrollbar.subscribeEvent(FlameScrollbar.EventScrollPositionChanged, new Subscriber(handle_scrollChange, this), FlameScrollbar.EventNamespace);
            horzScrollbar.subscribeEvent(FlameScrollbar.EventScrollPositionChanged, new Subscriber(handle_scrollChange, this), FlameScrollbar.EventNamespace);
            
            configureScrollbars();
            performChildWindowLayout();
        }
        
        
        /*!
        \brief
        Remove all items from the list.
        
        Note that this will cause 'AutoDelete' items to be deleted.
        */
        public function resetList():void
        {
            if (resetList_impl())
            {
                var args:WindowEventArgs = new WindowEventArgs(this);
                onListContentsChanged(args);
            }
        }
        
        
        /*!
        \brief
        Add the given ListboxItem to the list.
        
        \param item
        Pointer to the ListboxItem to be added to the list.  Note that it is the passed object that is added to the
        list, a copy is not made.  If this parameter is NULL, nothing happens.
        
        \return
        Nothing.
        */
        public function addItem(item:FlameListboxItem):void
        {
            if (item)
            {
                // establish ownership
                item.setOwnerWindow(this);
                
                // if sorting is enabled, re-sort the list
                d_listItems.push(item);
                
                if (isSortEnabled())
                {
                    //d_listItems.insert(std::upper_bound(d_listItems.begin(), d_listItems.end(), item, &lbi_less), item);
                    d_listItems.sort(lbi_less);
                }
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onListContentsChanged(args);
            }
        }
        
        
        /*!
        \brief
        Insert an item into the list box before a specified item already in the
        list.
        
        Note that if the list is sorted, the item may not end up in the
        requested position.
        
        \param item
        Pointer to the ListboxItem to be inserted.  Note that it is the passed
        object that is added to the list, a copy is not made.  If this parameter
        is NULL, nothing happens.
        
        \param position
        Pointer to a ListboxItem that \a item is to be inserted before.  If this
        parameter is NULL, the item is inserted at the start of the list.
        
        \return
        Nothing.
        
        \exception InvalidRequestException	thrown if no ListboxItem \a position is
        attached to this list box.
        */
        public function insertItem(item:FlameListboxItem, position:FlameListboxItem):void
        {
            // if the list is sorted, it's the same as a normal add operation
            if (isSortEnabled())
            {
                addItem(item);
            }
            else if (item)
            {
                // establish ownership
                item.setOwnerWindow(this);
                
                // if position is NULL begin insert at begining, else insert after item 'position'
                //LBItemList::iterator ins_pos;
                var ins_pos:int = d_listItems.indexOf(position);
                
                // throw if item 'position' is not in the list
                if (ins_pos == -1)
                {
                    throw new Error("Listbox::insertItem - the specified ListboxItem for parameter 'position' is not attached to this Listbox.");
                }
                
                d_listItems.splice(ins_pos, 0, item);
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onListContentsChanged(args);
            }
        }
        
        
        /*!
        \brief
        Removes the given item from the list box.  If the item is has the auto delete state set, the item will be deleted.
        
        \param item
        Pointer to the ListboxItem that is to be removed.  If \a item is not attached to this list box then nothing
        will happen.
        
        \return
        Nothing.
        */
        public function removeItem(item:FlameListboxItem):void
        {
            if (item)
            {
                var pos:int = d_listItems.indexOf(item);

                // if item is in the list
                if (pos != -1)
                {
                    // disown item
                    d_listItems[pos].setOwnerWindow(null);
                    
                    // remove item
                    d_listItems.splice(pos, 1);
                    
                    // if item was the last selected item, reset that to NULL
                    if (item == d_lastSelected)
                    {
                        d_lastSelected = null;
                    }
                    
                    // if item is supposed to be deleted by us
                    if (item.isAutoDeleted())
                    {
                        // clean up this item.
                        //delete item;
                    }
                    
                    var args:WindowEventArgs = new WindowEventArgs(this);
                    onListContentsChanged(args);
                }
                
            }
        }
        
        
        /*!
        \brief
        Clear the selected state for all items.
        
        \return
        Nothing.
        */
        public function clearAllSelections():void
        {
            // only fire events and update if we actually made any changes
            if (clearAllSelections_impl())
            {
                var args:WindowEventArgs = new WindowEventArgs(this);
                onSelectionChanged(args);
            }
        }
        
        
        /*!
        \brief
        Set whether the list should be sorted.
        
        \param setting
        true if the list should be sorted, false if the list should not be sorted.
        
        \return
        Nothing.
        */
        public function setSortingEnabled(setting:Boolean):void
        {
            // only react if the setting will change
            if (d_sorted != setting)
            {
                d_sorted = setting;
                
                // if we are enabling sorting, we need to sort the list
                if (d_sorted)
                {
                    resortList();
                }
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onSortModeChanged(args);
            }
        }
        
        
        /*!
        \brief
        Set whether the list should allow multiple selections or just a single selection
        
        \param  setting
        true if the widget should allow multiple items to be selected, false if the widget should only allow
        a single selection.
        
        \return
        Nothing.
        */
        public function setMultiselectEnabled(setting:Boolean):void
        {
            // only react if the setting is changed
            if (d_multiselect != setting)
            {
                d_multiselect = setting;
                
                // if we change to single-select, deselect all except the first selected item.
                var args:WindowEventArgs = new WindowEventArgs(this);
                if ((!d_multiselect) && (getSelectedCount() > 1))
                {
                    var itm:FlameListboxItem = getFirstSelectedItem();
                    
                    while ((itm = getNextSelected(itm)))
                    {
                        itm.setSelected(false);
                    }
                    
                    onSelectionChanged(args);
                    
                }
                
                onMultiselectModeChanged(args);
            }
        }
        
        
        /*!
        \brief
        Set whether the vertical scroll bar should always be shown.
        
        \param setting
        true if the vertical scroll bar should be shown even when it is not required.  false if the vertical
        scroll bar should only be shown when it is required.
        
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
        Set whether the horizontal scroll bar should always be shown.
        
        \param setting
        true if the horizontal scroll bar should be shown even when it is not required.  false if the horizontal
        scroll bar should only be shown when it is required.
        
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
        
        public function setItemTooltipsEnabled(setting:Boolean):void
        {
            d_itemTooltips = setting;
        }
        /*!
        \brief
        Set the select state of an attached ListboxItem.
        
        This is the recommended way of selecting and deselecting items attached to a list box as it respects the
        multi-select mode setting.  It is possible to modify the setting on ListboxItems directly, but that approach
        does not respect the settings of the list box.
        
        \param item
        The ListboxItem to be affected.  This item must be attached to the list box.
        
        \param state
        true to select the item, false to de-select the item.
        
        \return
        Nothing.
        
        \exception	InvalidRequestException	thrown if \a item is not attached to this list box.
        */
        public function setItemSelectState(item:FlameListboxItem, state:Boolean):void
        {
            var pos:int = d_listItems.indexOf(item);
            
            if (pos != -1)
            {
                //setItemSelectState(std::distance(d_listItems.begin(), pos), state);
                setItemSelectStateByIndex(pos, state);
            }
            else
            {
                throw new Error("Listbox::setItemSelectState - the specified ListboxItem is not attached to this Listbox.");
            }
        }
        
        
        /*!
        \brief
        Set the select state of an attached ListboxItem.
        
        This is the recommended way of selecting and deselecting items attached to a list box as it respects the
        multi-select mode setting.  It is possible to modify the setting on ListboxItems directly, but that approach
        does not respect the settings of the list box.
        
        \param item_index
        The zero based index of the ListboxItem to be affected.  This must be a valid index (0 <= index < getItemCount())
        
        \param state
        true to select the item, false to de-select the item.
        
        \return
        Nothing.
        
        \exception	InvalidRequestException	thrown if \a item_index is out of range for the list box
        */
        public function setItemSelectStateByIndex(item_index:uint, state:Boolean):void
        {
            if (item_index < getItemCount())
            {
                // only do this if the setting is changing
                if (d_listItems[item_index].isSelected() != state)
                {
                    // conditions apply for single-select mode
                    if (state && !d_multiselect)
                    {
                        clearAllSelections_impl();
                    }
                    
                    d_listItems[item_index].setSelected(state);
                    var args:WindowEventArgs = new WindowEventArgs(this);
                    onSelectionChanged(args);
                }
                
            }
            else
            {
                throw new Error("Listbox::setItemSelectState - the value passed in the 'item_index' parameter is out of range for this Listbox.");
            }

        }
        
        /*!
        \brief
        Causes the list box to update it's internal state after changes have been made to one or more
        attached ListboxItem objects.
        
        Client code must call this whenever it has made any changes to ListboxItem objects already attached to the
        list box.  If you are just adding items, or removed items to update them prior to re-adding them, there is
        no need to call this method.
        
        \return
        Nothing.
        */
        public function handleUpdatedItemData():void
        {
            if (d_sorted)
                resortList();
            
            configureScrollbars();
            invalidate();
        }
        
        
        /*!
        \brief
        Ensure the item at the specified index is visible within the list box.
        
        \param item_index
        Zero based index of the item to be made visible in the list box.  If this value is out of range, the
        list is always scrolled to the bottom.
        
        \return
        Nothing.
        */
        public function ensureItemIsVisibleByIndex(item_index:uint):void
        {
            var vertScrollbar:FlameScrollbar = getVertScrollbar();
            
            // handle simple "scroll to the bottom" case
            if (item_index >= getItemCount())
            {
                vertScrollbar.setScrollPosition(vertScrollbar.getDocumentSize() - vertScrollbar.getPageSize());
            }
            else
            {
                var bottom:Number;
                var listHeight:Number = getListRenderArea().getHeight();
                var top:Number = 0;
                
                // get height to top of item
                var i:uint;
                for (i = 0; i < item_index; ++i)
                {
                    top += d_listItems[i].getPixelSize().d_height;
                }
                
                // calculate height to bottom of item
                bottom = top + d_listItems[i].getPixelSize().d_height;
                
                // account for current scrollbar value
                var currPos:Number = vertScrollbar.getScrollPosition();
                top		-= currPos;
                bottom	-= currPos;
                
                // if top is above the view area, or if item is too big to fit
                if ((top < 0.0) || ((bottom - top) > listHeight))
                {
                    // scroll top of item to top of box.
                    vertScrollbar.setScrollPosition(currPos + top);
                }
                    // if bottom is below the view area
                else if (bottom >= listHeight)
                {
                    // position bottom of item at the bottom of the list
                    vertScrollbar.setScrollPosition(currPos + bottom - listHeight);
                }
                
                // Item is already fully visible - nothing more to do.
            }
        }
        
        
        /*!
        \brief
        Ensure the item at the specified index is visible within the list box.
        
        \param item
        Pointer to the ListboxItem to be made visible in the list box.
        
        \return
        Nothing.
        
        \exception	InvalidRequestException	thrown if \a item is not attached to this list box.
        */
        public function ensureItemIsVisible(item:FlameListboxItem):void
        {
            ensureItemIsVisibleByIndex(getItemIndex(item));
        }
        
        
        /*!
        \brief
        Return a Rect object describing, in un-clipped pixels, the window relative area
        that is to be used for rendering list items.
        
        \return
        Rect object describing the area of the Window to be used for rendering
        list box items.
        */
        public function getListRenderArea():Rect
        {
            if (d_windowRenderer != null)
            {
                var wr:ListboxWindowRenderer =  d_windowRenderer as ListboxWindowRenderer;
                return wr.getListRenderArea();
            }
            else
            {
                throw new Error("Listbox::getListRenderArea - This function must be implemented by the window renderer module");
            }
        }
        
        
        /*!
        \brief
        Return a pointer to the vertical scrollbar component widget for this
        Listbox.
        
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
        Return a pointer to the horizontal scrollbar component widget for this
        Listbox.
        
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
        
        
        /*!
        \brief
        Return the sum of all item heights
        */
        public function getTotalItemsHeight():Number
        {
            var height:Number = 0;
            
            for (var i:uint = 0; i < getItemCount(); ++i)
            {
                height += d_listItems[i].getPixelSize().d_height;
            }
            
            return height;
        }
        
        
        /*!
        \brief
        Return the width of the widest item
        */
        public function getWidestItemWidth():Number
        {
            var widest:Number = 0;
            
            for (var i:uint = 0; i < getItemCount(); ++i)
            {
                var thisWidth:Number = d_listItems[i].getPixelSize().d_width;
                
                if (thisWidth > widest)
                {
                    widest = thisWidth;
                }
                
            }
            
            return widest;
        }
        
        
        /*!
        \brief
        Return a pointer to the ListboxItem attached to this Listbox at the
        given screen pixel co-ordinate.
        
        \return
        Pointer to the ListboxItem attached to this Listbox that is at screen
        position \a pt, or 0 if no ListboxItem attached to this Listbox is at
        that position.
        */
        public function getItemAtPoint(pt:Vector2):FlameListboxItem
        {
            const local_pos:Vector2 = CoordConverter.screenToWindowForVector2(this, pt);
            const renderArea:Rect = getListRenderArea();
            
            // point must be within the rendering area of the Listbox.
            if (renderArea.isPointInRect(local_pos))
            {
                var y:Number = renderArea.d_top - getVertScrollbar().getScrollPosition();
                
                // test if point is above first item
                if (local_pos.d_y >= y)
                {
                    for (var i:uint = 0; i < getItemCount(); ++i)
                    {
                        y += d_listItems[i].getPixelSize().d_height;
                        
                        if (local_pos.d_y < y)
                        {
                            return d_listItems[i];
                        }
                        
                    }
                }
            }
            
            return null;
        }
        
        /*************************************************************************
         Abstract Implementation Functions (must be provided by derived class)
         *************************************************************************/
        /*!
        \brief
        Return a Rect object describing, in un-clipped pixels, the window relative area
        that is to be used for rendering list items.
        
        \return
        Rect object describing the area of the Window to be used for rendering
        list box items.
        */
        protected function getListRenderArea_impl():Rect
        {
            return new Rect();
        }
        
        
        /*************************************************************************
         Implementation Functions
         *************************************************************************/
        /*!
        \brief
        display required integrated scroll bars according to current state of the list box and update their values.
        */
        protected function configureScrollbars():void
        {
            var vertScrollbar:FlameScrollbar = getVertScrollbar();
            var horzScrollbar:FlameScrollbar = getHorzScrollbar();
            
            var totalHeight:Number	= getTotalItemsHeight();
            var widestItem:Number	= getWidestItemWidth();
            
            //
            // First show or hide the scroll bars as needed (or requested)
            //
            // show or hide vertical scroll bar as required (or as specified by option)
            if ((totalHeight > getListRenderArea().getHeight()) || d_forceVertScroll)
            {
                vertScrollbar.show();
                
                // show or hide horizontal scroll bar as required (or as specified by option)
                if ((widestItem > getListRenderArea().getWidth()) || d_forceHorzScroll)
                {
                    horzScrollbar.show();
                }
                else
                {
                    horzScrollbar.hide();
                }
                
            }
            else
            {
                // show or hide horizontal scroll bar as required (or as specified by option)
                if ((widestItem > getListRenderArea().getWidth()) || d_forceHorzScroll)
                {
                    horzScrollbar.show();
                    
                    // show or hide vertical scroll bar as required (or as specified by option)
                    if ((totalHeight > getListRenderArea().getHeight()) || d_forceVertScroll)
                    {
                        vertScrollbar.show();
                    }
                    else
                    {
                        vertScrollbar.hide();
                    }
                    
                }
                else
                {
                    vertScrollbar.hide();
                    horzScrollbar.hide();
                }
                
            }
            
            //
            // Set up scroll bar values
            //
            var renderArea:Rect = getListRenderArea();
            
            vertScrollbar.setDocumentSize(totalHeight);
            vertScrollbar.setPageSize(renderArea.getHeight());
            vertScrollbar.setStepSize(Math.max(1.0, renderArea.getHeight() / 10.0));
            vertScrollbar.setScrollPosition(vertScrollbar.getScrollPosition());
            
            horzScrollbar.setDocumentSize(widestItem);
            horzScrollbar.setPageSize(renderArea.getWidth());
            horzScrollbar.setStepSize(Math.max(1.0, renderArea.getWidth() / 10.0));
            horzScrollbar.setScrollPosition(horzScrollbar.getScrollPosition());
        }
        
        /*!
        \brief
        select all strings between positions \a start and \a end.  (inclusive)
        including \a end.
        */
        protected function selectRange(start:uint, end:uint):void
        {
            // only continue if list has some items
            if (d_listItems.length > 0)
            {
                // if start is out of range, start at begining.
                if (start > d_listItems.length)
                {
                    start = 0;
                }
                
                // if end is out of range end at the last item.
                if (end >= d_listItems.length)
                {
                    end = d_listItems.length - 1;
                }
                
                // ensure start becomes before the end.
                if (start > end)
                {
                    var tmp:uint;
                    tmp = start;
                    start = end;
                    end = tmp;
                }
                
                // perform selections
                for( ; start <= end; ++start)
                {
                    d_listItems[start].setSelected(true);
                }
                
            }
        }
        
        
        /*!
        \brief
        Clear the selected state for all items (implementation)
        
        \return
        true if some selections were cleared, false nothing was changed.
        */
        protected function clearAllSelections_impl():Boolean
        {
            // flag used so we can track if we did anything.
            var modified:Boolean = false;
            
            for (var index:uint = 0; index < d_listItems.length; ++index)
            {
                if (d_listItems[index].isSelected())
                {
                    d_listItems[index].setSelected(false);
                    modified = true;
                }
                
            }
            
            return modified;
        }
        
        
        /*!
        \brief
        Remove all items from the list.
        
        \note
        Note that this will cause 'AutoDelete' items to be deleted.
        
        \return
        - true if the list contents were changed.
        - false if the list contents were not changed (list already empty).
        */
        protected function resetList_impl():Boolean
        {
            // just return false if the list is already empty
            if (getItemCount() == 0)
            {
                return false;
            }
                // we have items to be removed and possible deleted
            else
            {
                
                // delete any items we are supposed to
                for (var i:uint = 0; i < getItemCount(); ++i)
                {
                    // if item is supposed to be deleted by us
                    if (d_listItems[i].isAutoDeleted())
                    {
                        // clean up this item.
                        //delete d_listItems[i];
                    }
                    
                }
                
                // clear out the list.
                d_listItems.length = 0
                
                d_lastSelected = null;
                
                return true;
            }
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
            if (class_name=="Listbox")	return true;
            return super.testClassName_impl(class_name);
        }
        
        /*!
        \brief
        Internal handler that is triggered when the user interacts with the scrollbars.
        */
        protected function handle_scrollChange(args:EventArgs):Boolean
        {
            // simply trigger a redraw of the Listbox.
            invalidate();
            return true;
        }
        
        // validate window renderer
        protected function validateWindowRenderer(name:String):Boolean
        {
            return (name == "Listbox");
        }
        
        /*!
        \brief
        Causes the internal list to be (re)sorted.
        */
        protected function resortList():void
        {
            d_listItems.sort(lbi_less);
        }
            
        
        /*************************************************************************
         New event handlers
         *************************************************************************/
        /*!
        \brief
        Handler called internally when the list contents are changed
        */
        protected function onListContentsChanged(e:WindowEventArgs):void
        {
            configureScrollbars();
            invalidate();
            fireEvent(EventListContentsChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called internally when the currently selected item or items changes.
        */
        protected function onSelectionChanged(e:WindowEventArgs):void
        {
            invalidate();
            fireEvent(EventSelectionChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called internally when the sort mode setting changes.
        */
        protected function onSortModeChanged(e:WindowEventArgs):void
        {
            invalidate();
            fireEvent(EventSortModeChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called internally when the multi-select mode setting changes.
        */
        protected function onMultiselectModeChanged(e:WindowEventArgs):void
        {
            fireEvent(EventMultiselectModeChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called internally when the forced display of the vertical scroll bar setting changes.
        */
        protected function onVertScrollbarModeChanged(e:WindowEventArgs):void
        {
            invalidate();
            fireEvent(EventVertScrollbarModeChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called internally when the forced display of the horizontal scroll bar setting changes.
        */
        protected function onHorzScrollbarModeChanged(e:WindowEventArgs):void
        {
            invalidate();
            fireEvent(EventHorzScrollbarModeChanged, e, EventNamespace);
        }
        
        
        /*************************************************************************
         Overridden Event handlers
         *************************************************************************/
        override protected function onSized(e:WindowEventArgs):void
        {
            // base class handling
            super.onSized(e);
            
            configureScrollbars();
            
            ++e.handled;
        }
        
        override public function onMouseButtonDown(e:MouseEventArgs):void
        {
            // base class processing
            super.onMouseButtonDown(e);
            
            if (e.button == Consts.MouseButton_LeftButton)
            {
                var modified:Boolean = false;
                
                // clear old selections if no control key is pressed or if multi-select is off
                if (!(e.sysKeys & Consts.SystemKey_Control) || !d_multiselect)
                {
                    modified = clearAllSelections_impl();
                }
                
                var item:FlameListboxItem = getItemAtPoint(e.position);
                
                if (item)
                {
                    modified = true;
                    
                    // select range or item, depending upon keys and last selected item
                    if (((e.sysKeys & Consts.SystemKey_Shift) && (d_lastSelected != null)) && d_multiselect)
                    {
                        selectRange(getItemIndex(item), getItemIndex(d_lastSelected));
                    }
                    else
                    {
                        item.setSelected(item.isSelected() ? false : true);
                    }
                    
                    // update last selected item
                    d_lastSelected = item.isSelected() ? item : null;
                }
                
                // fire event if needed
                if (modified)
                {
                    var args:WindowEventArgs = new WindowEventArgs(this);
                    onSelectionChanged(args);
                }
                
                ++e.handled;
            }
        }
        
        
        override public function onMouseWheel(e:MouseEventArgs):void
        {
            // base class processing.
            super.onMouseWheel(e);
            
            var vertScrollbar:FlameScrollbar = getVertScrollbar();
            var horzScrollbar:FlameScrollbar = getHorzScrollbar();
            
            if (vertScrollbar.isVisible() && (vertScrollbar.getDocumentSize() > vertScrollbar.getPageSize()))
            {
                vertScrollbar.setScrollPosition(vertScrollbar.getScrollPosition() + vertScrollbar.getStepSize() * -e.wheelChange);
            }
            else if (horzScrollbar.isVisible() && (horzScrollbar.getDocumentSize() > horzScrollbar.getPageSize()))
            {
                horzScrollbar.setScrollPosition(horzScrollbar.getScrollPosition() + horzScrollbar.getStepSize() * -e.wheelChange);
            }
            
            ++e.handled;
        }
        
        override public function onMouseMove(e:MouseEventArgs):void
        {
            if (d_itemTooltips)
            {
                
                var item:FlameListboxItem = getItemAtPoint(e.position);
                if (item != lastItem)
                {
                    if (item)
                    {
                        setTooltipText(item.getTooltipText());
                    }
                    else
                    {
                        setTooltipText("");
                    }
                    lastItem = item;
                }
                
                // must check the result from getTooltip(), as the tooltip object could
                // be 0 at any time for various reasons.
                var tooltip:FlameTooltip = getTooltip();
                
                if (tooltip)
                {
                    if (tooltip.getTargetWindow() != this)
                        tooltip.setTargetWindow(this);
                    else
                        tooltip.positionSelf();
                }
            }
            
            super.onMouseMove(e);
        }
        
        

            
        /*************************************************************************
         Private methods
         *************************************************************************/
        private function addListboxProperties():void
        {
            addProperty(d_sortProperty);
            addProperty(d_multiSelectProperty);
            addProperty(d_forceHorzProperty);
            addProperty(d_forceVertProperty);
            addProperty(d_itemTooltipsProperty);
        }
        
        
        /*!
        \brief
        Helper function used in sorting to compare two list box item text strings
        via the ListboxItem pointers and return if \a a is less than \a b.
        */
        private function lbi_less(a:FlameListboxItem, b:FlameListboxItem):int
        {
            return (a.getText() < b.getText()) ? 1 : -1;
        }
        
        
        /*!
        \brief
        Helper function used in sorting to compare two list box item text strings
        via the ListboxItem pointers and return if \a a is greater than \a b.
        */
        private function lbi_greater(a:FlameListboxItem, b:FlameListboxItem):int
        {
            return (a.getText() > b.getText()) ? 1 : -1;
        }
        
        
    }
}

