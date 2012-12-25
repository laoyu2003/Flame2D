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
package Flame2D.elements.tree
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.TreeEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.falagard.FalagardImagerySection;
    import Flame2D.core.falagard.FalagardWidgetLookFeel;
    import Flame2D.core.falagard.FalagardWidgetLookManager;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.CoordConverter;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.Vector2;
    import Flame2D.elements.base.FlameScrollbar;
    import Flame2D.elements.tooltip.FlameTooltip;
    import Flame2D.renderer.FlameGeometryBuffer;
    

    /*!
    \brief
    Base class for standard Tree widget.
    
    \deprecated
    The CEGUI::Tree, CEGUI::TreeItem and any other associated classes are
    deprecated and thier use should be minimised - preferably eliminated -
    where possible.  It is extremely unfortunate that this widget was ever added
    to CEGUI since its design and implementation are poor and do not meet 
    established standards for the CEGUI project.
    \par
    While no alternative currently exists, a superior, replacement tree widget
    will be provided prior to the final removal of the current implementation.
    */
    public class FlameTree extends FlameWindow
    {
        public static const EventNamespace:String = "Tree";
        public static const WidgetTypeName:String = "CEGUI/Tree";
        
        
        
        /*************************************************************************
         Constants
         *************************************************************************/
        // event names
        /** Event fired when the content of the tree is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Tree whose content has changed.
         */
        public static const EventListContentsChanged:String = "ListItemsChanged";
        /** Event fired when there is a change to the currently selected item(s).
         * Handlers are passed a TreeEventArgs reference with
         * WindowEventArgs::window set to the Tree whose item selection has changed,
         * and TreeEventArgs::treeItem is set to the (last) item to be selected, or
         * 0 if none.
         */
        public static const EventSelectionChanged:String = "ItemSelectionChanged";
        /** Event fired when the sort mode setting for the Tree is changed.
         * Handlers are passed a WindowEventArgs reference with
         * WindowEventArgs::window set to the Tree whose sort mode has been
         * changed.
         */
        public static const EventSortModeChanged:String = "SortModeChanged";
        /** Event fired when the multi-select mode setting for the Tree changes.
         * Handlers are passed a TreeEventArgs reference with
         * WindowEventArgs::window set to the Tree whose setting has changed.
         * TreeEventArgs::treeItem is always set to 0.
         */
        public static const EventMultiselectModeChanged:String = "MuliselectModeChanged";
        /** Event fired when the mode setting that forces the display of the
         * vertical scroll bar for the tree is changed.
         * Handlers are passed a WindowEventArgs reference with
         * WindowEventArgs::window set to the Tree whose vertical scrollbar mode has
         * been changed.
         */
        public static const EventVertScrollbarModeChanged:String = "VertScrollModeChanged";
        /** Event fired when the mode setting that forces the display of the
         * horizontal scroll bar for the tree is changed.
         * Handlers are passed a WindowEventArgs reference with
         * WindowEventArgs::window set to the Tree whose horizontal scrollbar mode
         * has been changed.
         */
        public static const EventHorzScrollbarModeChanged:String = "HorzScrollModeChanged";
        /** Event fired when a branch of the tree is opened by the user.
         * Handlers are passed a TreeEventArgs reference with
         * WindowEventArgs::window set to the Tree containing the branch that has
         * been opened and TreeEventArgs::treeItem set to the TreeItem at the head
         * of the opened branch.
         */
        public static const EventBranchOpened:String = "BranchOpened";
        /** Event fired when a branch of the tree is closed by the user.
         * Handlers are passed a TreeEventArgs reference with
         * WindowEventArgs::window set to the Tree containing the branch that has
         * been closed and TreeEventArgs::treeItem set to the TreeItem at the head
         * of the closed branch.
         */
        public static const EventBranchClosed:String = "BranchClosed";

        /*************************************************************************
         Static Properties for this class
         *************************************************************************/
        private static var d_sortProperty:TreePropertySort = new TreePropertySort();
        private static var d_multiSelectProperty:TreePropertyMultiSelect = new TreePropertyMultiSelect();
        private static var d_forceVertProperty:TreePropertyForceVertScrollbar = new TreePropertyForceVertScrollbar();
        private static var d_forceHorzProperty:TreePropertyForceHorzScrollbar = new TreePropertyForceHorzScrollbar();
        private static var d_itemTooltipsProperty:TreePropertyItemTooltips = new TreePropertyItemTooltips();
        
        
        private const HORIZONTAL_STEP_SIZE_DIVISOR:Number = 20.0;
        
        
        private static var __lastItem:FlameTreeItem = null;


        /*************************************************************************
         Implementation Data
         *************************************************************************/
        //! true if tree is sorted
        protected var d_sorted:Boolean = false;
        //! true if multi-select is enabled
        protected var d_multiselect:Boolean = false;
        //! true if vertical scrollbar should always be displayed
        protected var d_forceVertScroll:Boolean = false;
        //! true if horizontal scrollbar should always be displayed
        protected var d_forceHorzScroll:Boolean = false;
        //! true if each item should have an individual tooltip
        protected var d_itemTooltips:Boolean = false;
        //! vertical scroll-bar widget
        protected var d_vertScrollbar:FlameScrollbar = null;
        //! horizontal scroll-bar widget
        protected var d_horzScrollbar:FlameScrollbar = null;
        //! list of items in the tree.
        protected var d_listItems:Vector.<FlameTreeItem> = new Vector.<FlameTreeItem>();
        //! holds pointer to the last selected item (used in range selections)
        public var d_lastSelected:FlameTreeItem = null;
        protected var d_openButtonImagery:FalagardImagerySection = null;
        protected var d_closeButtonImagery:FalagardImagerySection = null;
        
        
        private var d_itemArea:Rect = new Rect();

        /*************************************************************************
         Construction and Destruction
         *************************************************************************/
        /*!
        \brief
        Constructor for Tree base class.
        */
        public function FlameTree(type:String, name:String)
        {
            super(type, name);
            
            // add new events specific to tree.
            addTreeEvents();
            
            addTreeProperties();
        }
        
        
        
        //Render the actual tree
        public function doTreeRender():void
        {
            populateGeometryBuffer();
        }
        
        //UpdateScrollbars
        public function doScrollbars():void
        {
            configureScrollbars();
        }
        
        /*************************************************************************
         Accessor Methods
         *************************************************************************/
        /*!
        \brief
        Return number of items attached to the tree
        
        \return
        the number of items currently attached to this tree.
        */
        public function getItemCount():uint
        {
            return d_listItems.length;
        }
        
        /*!
        \brief
        Return the number of selected items in the tree.
        
        \return
        Total number of attached items that are in the selected state.
        */
        public function getSelectedCount():uint
        {
            var count:uint = 0;
            
            for (var index:uint = 0; index < d_listItems.length; ++index)
            {
                if (d_listItems[index].isSelected())
                    count++;
            }
            
            return count;
        }
        
        /*!
        \brief
        Return a pointer to the first selected item.
        
        \return
        Pointer to a TreeItem based object that is the first selected item in
        the tree.  will return 0 if no item is selected.
        */
        public function getFirstSelectedItem():FlameTreeItem
        {
            var found_first:Boolean = true;
            return getNextSelectedItemFromList(d_listItems, null, found_first);
        }
        
        /*!
        \brief
        Return a pointer to the first selected item.
        
        \return
        Pointer to a TreeItem based object that is the last item selected by the
        user, not necessarily the last selected in the tree.  Will return 0 if
        no item is selected.
        */
        public function getLastSelectedItem():FlameTreeItem
        {
            return d_lastSelected;
        }
        
        /*!
        \brief
        Return a pointer to the next selected item after item \a start_item
        
        \param start_item
        Pointer to the TreeItem where the search for the next selected item is
        to begin.  If this parameter is 0, the search will begin with the first
        item in the tree.
        
        \return
        Pointer to a TreeItem based object that is the next selected item in
        the tree after the item specified by \a start_item.  Will return 0 if
        no further items were selected.
        
        \exception	InvalidRequestException	thrown if \a start_item is not attached
        to this tree.
        */
        public function getNextSelected(start_item:FlameTreeItem):FlameTreeItem
        {
            var found_first:Boolean = (start_item == null);
            return getNextSelectedItemFromList(d_listItems, start_item, found_first);
        }
        
        public function getNextSelectedItemFromList(itemList:Vector.<FlameTreeItem>,
            startItem:FlameTreeItem, foundStartItem:Boolean):FlameTreeItem
        {
            var itemCount:uint = itemList.length;
            
            for (var index:uint = 0; index < itemCount; ++index)
            {
                if (foundStartItem == true)
                {
                    // Already found the startItem, now looking for next selected item.
                    if (itemList[index].isSelected())
                        return itemList[index];
                }
                else
                {
                    // Still looking for startItem.  Is this it?
                    if (itemList[index] == startItem)
                        foundStartItem = true;
                }
                
                if (itemList[index].getItemCount() > 0)
                {
                    if (itemList[index].getIsOpen())
                    {
                        var foundSelectedTree:FlameTreeItem;
                        foundSelectedTree = getNextSelectedItemFromList(itemList[index].getItemList(), startItem, foundStartItem);
                        if (foundSelectedTree != true)
                            return foundSelectedTree;
                    }
                }
            }
            
            return null;
        }
        
        /*!
        \brief
        return whether tree sorting is enabled
        
        \return
        - true if the tree is sorted
        - false if the tree is not sorted
        */
        public function isSortEnabled():Boolean
        {
            return d_sorted;
        }
        
        public function setItemRenderArea(r:Rect):void
        {
            d_itemArea = r;
        }
        
        public function getVertScrollbar():FlameScrollbar
        {
            return d_vertScrollbar;
        }
        
        public function getHorzScrollbar():FlameScrollbar
        {
            return d_horzScrollbar;
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
        Search the tree for an item with the specified text
        
        \param text
        String object containing the text to be searched for.
        
        \param start_item
        TreeItem where the search is to begin, the search will not include \a
        item.  If \a item is 0, the search will begin from the first item in
        the tree.
        
        \return
        Pointer to the first TreeItem in the tree after \a item that has text
        matching \a text.  If no item matches the criteria, 0 is returned.
        
        \exception	InvalidRequestException	thrown if \a item is not attached to
        this tree.
        */
        public function findFirstItemWithText(text:String):FlameTreeItem
        {
            return findItemWithTextFromList(d_listItems, text, null, true);
        }
        
        public function findNextItemWithText(text:String, start_item:FlameTreeItem):FlameTreeItem
        {
            if (start_item == null)
                return findItemWithTextFromList(d_listItems, text, null, true);
            else
                return findItemWithTextFromList(d_listItems, text, start_item, false);
        }
        
        public function findItemWithTextFromList(itemList:Vector.<FlameTreeItem>,
                                                 text:String, startItem:FlameTreeItem,
                                                 foundStartItem:Boolean):FlameTreeItem
        {
            var itemCount:uint = itemList.length;
            
            for (var index:uint = 0; index < itemCount; ++index)
            {
                if (foundStartItem == true)
                {
                    // Already found the startItem, now looking for the actual text.
                    if (itemList[index].getText() == text)
                        return itemList[index];
                }
                else
                {
                    // Still looking for startItem.  Is this it?
                    if (itemList[index] == startItem)
                        foundStartItem = true;
                }
                
                if (itemList[index].getItemCount() > 0)
                {
                    // Search the current item's itemList regardless if it's open or not.
                    var foundSelectedTree:FlameTreeItem;
                    foundSelectedTree = findItemWithTextFromList(itemList[index].getItemList(), text, startItem, foundStartItem);
                    if (foundSelectedTree != null)
                        return foundSelectedTree;
                }
            }
            
            return null;
        }
        
        /*!
        \brief
        Search the tree for an item with the specified text
        
        \param text
        String object containing the text to be searched for.
        
        \param start_item
        TreeItem where the search is to begin, the search will not include
        \a item.  If \a item is 0, the search will begin from the first item in
        the tree.
        
        \return
        Pointer to the first TreeItem in the tree after \a item that has text
        matching \a text.  If no item matches the criteria 0 is returned.
        
        \exception	InvalidRequestException	thrown if \a item is not attached to
        this tree.
        */
        public function findFirstItemWithID(searchID:uint):FlameTreeItem
        {
            return findItemWithIDFromList(d_listItems, searchID, null, true);
        }
        
        public function findNextItemWithID(searchID:uint, start_item:FlameTreeItem):FlameTreeItem
        {
            if (start_item == null)
                return findItemWithIDFromList(d_listItems, searchID, null, true);
            else
                return findItemWithIDFromList(d_listItems, searchID, start_item, false);
        }
        
        public function findItemWithIDFromList(itemList:Vector.<FlameTreeItem>, searchID:uint,
            startItem:FlameTreeItem, foundStartItem:Boolean):FlameTreeItem
        {
            var itemCount:uint = itemList.length;
            
            for (var index:uint = 0; index < itemCount; ++index)
            {
                if (foundStartItem == true)
                {
                    // Already found the startItem, now looking for the actual text.
                    if (itemList[index].getID() == searchID)
                        return itemList[index];
                }
                else
                {
                    // Still looking for startItem.  Is this it?
                    if (itemList[index] == startItem)
                        foundStartItem = true;
                }
                
                if (itemList[index].getItemCount() > 0)
                {
                    // Search the current item's itemList regardless if it's open or not.
                    var foundSelectedTree:FlameTreeItem;
                    foundSelectedTree = findItemWithIDFromList(itemList[index].getItemList(), searchID, startItem, foundStartItem);
                    if (foundSelectedTree != null)
                        return foundSelectedTree;
                }
            }
            
            return null;
        }
        
        /*!
        \brief
        Return whether the specified TreeItem is in the tree
        
        \return
        - true if TreeItem \a item is in the tree
        - false if TreeItem \a item is not in the tree.
        */
        public function isTreeItemInList(item:FlameTreeItem):Boolean
        {
            //return std::find(d_listItems.begin(), d_listItems.end(), item) != d_listItems.end();
            return d_listItems.indexOf(item) != -1;
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
        This must be called for every window created.  Normally this is handled
        automatically by the WindowFactory for each Window type.
        
        \return
        Nothing
        */
        public function initialise():void
        {
            // get WidgetLookFeel for the assigned look.
            const wlf:FalagardWidgetLookFeel = FalagardWidgetLookManager.getSingleton().getWidgetLook(d_lookName);
            const tempOpenImagery:FalagardImagerySection = wlf.getImagerySection("OpenTreeButton");
            const tempCloseImagery:FalagardImagerySection = wlf.getImagerySection("CloseTreeButton");
            d_openButtonImagery = tempOpenImagery;
            d_closeButtonImagery = tempCloseImagery;
            
            // create the component sub-widgets
            d_vertScrollbar = createVertScrollbar(getName() + "__auto_vscrollbar__");
            d_horzScrollbar = createHorzScrollbar(getName() + "__auto_hscrollbar__");
            
            addChildWindow(d_vertScrollbar);
            addChildWindow(d_horzScrollbar);
            
            d_vertScrollbar.subscribeEvent(FlameScrollbar.EventScrollPositionChanged, new Subscriber(handle_scrollChange, this), FlameScrollbar.EventNamespace);
            d_horzScrollbar.subscribeEvent(FlameScrollbar.EventScrollPositionChanged, new Subscriber(handle_scrollChange, this), FlameScrollbar.EventNamespace);
            
            configureScrollbars();
            performChildWindowLayout();
        }
        
        /*!
        \brief
        Remove all items from the tree.
        
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
        Add the given TreeItem to the tree.
        
        \param item
        Pointer to the TreeItem to be added to the tree.  Note that it is the
        passed object that is added to the tree, a copy is not made.  If this
        parameter is NULL, nothing happens.
        
        \return
        Nothing.
        */
        public function addItem(item:FlameTreeItem):void
        {
            if (item != null)
            {
                // establish ownership
                item.setOwnerWindow(this);
                
                // if sorting is enabled, re-sort the list
                if (isSortEnabled())
                {
                    //d_listItems.insert(std::upper_bound(d_listItems.begin(), d_listItems.end(), item, &lbi_less), item);
                    d_listItems.push(item);
                    d_listItems.sort(lbi_less);
                }
                // not sorted, just stick it on the end.
                else
                {
                    d_listItems.push(item);
                }
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onListContentsChanged(args);
            }
        }
        
        /*!
        \brief
        Insert an item into the tree after a specified item already in the
        tree.
        
        Note that if the tree is sorted, the item may not end up in the
        requested position.
        
        \param item
        Pointer to the TreeItem to be inserted.  Note that it is the passed
        object that is added to the tree, a copy is not made.  If this
        parameter is 0, nothing happens.
        
        \param position
        Pointer to a TreeItem that \a item is to be inserted after.  If this
        parameter is 0, the item is inserted at the start of the tree.
        
        \return
        Nothing.
        
        \exception InvalidRequestException	thrown if no TreeItem \a position is
        attached to this tree.
        */
        public function insertItem(item:FlameTreeItem, position:FlameTreeItem):void
        {
            // if the list is sorted, it's the same as a normal add operation
            if (isSortEnabled())
            {
                addItem(item);
            }
            else if (item != null)
            {
                // establish ownership
                item.setOwnerWindow(this);
                
                // if position is NULL begin insert at begining, else insert after item 'position'
                //LBItemList::iterator ins_pos;
                
                var ins_pos:int = 0
                if (position == null)
                {
                    ins_pos = 0;
                }
                else
                {
                    ins_pos = d_listItems.indexOf(position);
                        //std::find(d_listItems.begin(), d_listItems.end(), position);
                    
                    // throw if item 'position' is not in the list
                    if (ins_pos == -1)
                    {
                        throw new Error("Tree::insertItem - the specified TreeItem for parameter 'position' is not attached to this Tree.");
                    }
                }
                
                d_listItems.splice(ins_pos, 0, item);
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onListContentsChanged(args);
            }
        }
        
        /*!
        \brief
        Removes the given item from the tree.  If the item is has the auto
        delete state set, the item will be deleted.
        
        \param item
        Pointer to the TreeItem that is to be removed.  If \a item is not
        attached to this tree then nothing will happen.
        
        \return
        Nothing.
        */
        public function removeItem(item:FlameTreeItem):void
        {
            if (item != null)
            {
                //LBItemList::iterator pos = std::find(d_listItems.begin(), d_listItems.end(), item);
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
                var args:TreeEventArgs = new TreeEventArgs(this);
                onSelectionChanged(args);
            }
        }
        
        public function clearAllSelectionsFromList(itemList:Vector.<FlameTreeItem>):Boolean
        {
            // flag used so we can track if we did anything.
            var modified:Boolean = false;
            
            for (var index:uint = 0; index < itemList.length; ++index)
            {
                if (itemList[index].isSelected())
                {
                    itemList[index].setSelected(false);
                    modified = true;
                }
                
                if (itemList[index].getItemCount() > 0)
                {
                    var modifiedSubList:Boolean = clearAllSelectionsFromList(itemList[index].getItemList());
                    if (modifiedSubList)
                        modified = true;
                }
            }
            
            return modified;
        }
        
        /*!
        \brief
        Set whether the tree should be sorted.
        
        \param setting
        - true if the tree should be sorted
        - false if the tree should not be sorted.
        
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
                    //std::sort(d_listItems.begin(), d_listItems.end(), &lbi_less);
                    d_listItems.sort(lbi_less);
                }
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onSortModeChanged(args);
            }
        }
        
        /*!
        \brief
        Set whether the tree should allow multiple selections or just a single
        selection.
        
        \param  setting
        - true if the widget should allow multiple items to be selected
        - false if the widget should only allow a single selection.
        
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
                var args:TreeEventArgs  = new TreeEventArgs(this);
                if ((!d_multiselect) && (getSelectedCount() > 1))
                {
                    var itm:FlameTreeItem = getFirstSelectedItem();
                    
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
        
        public function setItemTooltipsEnabled(setting:Boolean):void
        {
            // only react if the setting will change
            if (d_sorted != setting)
            {
                d_sorted = setting;
                
                // if we are enabling sorting, we need to sort the list
                if (d_sorted)
                {
                    //std::sort(d_listItems.begin(), d_listItems.end(), &lbi_less);
                    d_listItems.sort(lbi_less);
                }
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onSortModeChanged(args);
            }
        }
        
        /*!
        \brief
        Set the select state of an attached TreeItem.
        
        This is the recommended way of selecting and deselecting items attached
        to a tree as it respects the multi-select mode setting.  It is
        possible to modify the setting on TreeItems directly, but that approach
        does not respect the settings of the tree.
        
        \param item
        The TreeItem to be affected.
        This item must be attached to the tree.
        
        \param state
        - true to select the item.
        - false to de-select the item.
        
        \return
        Nothing.
        
        \exception	InvalidRequestException	thrown if \a item is not attached to
        this tree.
        */
        public function setItemSelectState(item:FlameTreeItem, state:Boolean):void
        {
            if (containsOpenItemRecursive(d_listItems, item))
            {
                var args:TreeEventArgs = new TreeEventArgs(this);
                args.treeItem = item;
                
                if (state && !d_multiselect)
                    clearAllSelections_impl();
                
                item.setSelected(state);
                d_lastSelected = item.isSelected() ? item : null;
                onSelectionChanged(args);
            }
            else
            {
                throw new Error("Tree::setItemSelectState - the " +
                    "specified TreeItem is not attached to this Tree or not visible.");
            }
        }
        
        /*!
        \brief
        Set the select state of an attached TreeItem.
        
        This is the recommended way of selecting and deselecting items attached
        to a tree as it respects the multi-select mode setting.  It is
        possible to modify the setting on TreeItems directly, but that approach
        does not respect the settings of the tree.
        
        \param item_index
        The zero based index of the TreeItem to be affected.
        This must be a valid index (0 <= index < getItemCount())
        
        \param state
        - true to select the item.
        - false to de-select the item.
        
        \return
        Nothing.
        
        \exception	InvalidRequestException	thrown if \a item_index is out of range
        for the tree
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
                    var args:TreeEventArgs = new TreeEventArgs(this);
                    args.treeItem = d_listItems[item_index];
                    onSelectionChanged(args);
                }
            }
            else
            {
                throw new Error("Tree::setItemSelectState - the value passed in the 'item_index' parameter is out of range for this Tree.");
            }
        }
        
        /*!
        \brief
        Set the LookNFeel that shoule be used for this window.
        
        \param look
        String object holding the name of the look to be assigned to the window.
        
        \return
        Nothing.
        
        \exception UnknownObjectException
        thrown if the look'n'feel specified by \a look does not exist.
        
        \note
        Once a look'n'feel has been assigned it is locked - as in cannot be
        changed.
        */
        override public function setLookNFeel(look:String):void
        {
            super.setLookNFeel( look );
            initialise();
        }
        
        /*!
        \brief
        Causes the tree to update it's internal state after changes have
        been made to one or more attached TreeItem objects.
        
        Client code must call this whenever it has made any changes to TreeItem
        objects already attached to the tree.  If you are just adding items,
        or removed items to update them prior to re-adding them, there is no
        need to call this method.
        
        \return
        Nothing.
        */
        public function handleUpdatedItemData():void
        {
            configureScrollbars();
            invalidate();
        }
        
        /*!
        \brief
        Ensure the item at the specified index is visible within the tree.
        
        \param item
        Pointer to the TreeItem to be made visible in the tree.
        
        \return
        Nothing.
        
        \exception	InvalidRequestException	thrown if \a item is not attached to
        this tree.
        */
        public function ensureItemIsVisible(treeItem:FlameTreeItem):void
        {
            if (!treeItem)
                return;
            
            var top:Number = 0;
            if (!getHeightToItemInList(d_listItems, treeItem, 0, top))
                return;  // treeItem wasn't found by getHeightToItemInList
            
            // calculate height to bottom of item
            var bottom:Number = top + treeItem.getPixelSize().d_height;
            
            // account for current scrollbar value
            const currPos:Number = d_vertScrollbar.getScrollPosition();
            top      -= currPos;
            bottom   -= currPos;
            
            const listHeight:Number = getTreeRenderArea().getHeight();
            
            // if top is above the view area, or if item is too big to fit
            if ((top < 0.0) || ((bottom - top) > listHeight))
            {
                // scroll top of item to top of box.
                d_vertScrollbar.setScrollPosition(currPos + top);
            }
                // if bottom is below the view area
            else if (bottom >= listHeight)
            {
                // position bottom of item at the bottom of the list
                d_vertScrollbar.setScrollPosition(currPos + bottom - listHeight);
            }
        }
        
        
        /*************************************************************************
         Abstract Implementation Functions (must be provided by derived class)
         *************************************************************************/
        /*!
        \brief
        Return a Rect object describing, in un-clipped pixels, the window
        relative area that is to be used for rendering tree items.
        
        \return
        Rect object describing the area of the Window to be used for rendering
        tree items.
        */
        protected function getTreeRenderArea():Rect
        {
            return d_itemArea;
        }
        
        /*!
        \brief
        create and return a pointer to a Scrollbar widget for use as vertical
        scroll bar.
        
        \param name
        String holding the name to be given to the created widget component.
        
        \return
        Pointer to a Scrollbar to be used for scrolling the tree vertically.
        */
        protected function createVertScrollbar(name:String):FlameScrollbar
        {
            return FlameWindowManager.getSingleton().getWindow(name) as FlameScrollbar;
        }
        
        /*!
        \brief
        create and return a pointer to a Scrollbar widget for use as horizontal
        scroll bar.
        
        \param name
        String holding the name to be given to the created widget component.
        
        \return
        Pointer to a Scrollbar to be used for scrolling the tree horizontally.
        */
        protected function createHorzScrollbar(name:String):FlameScrollbar
        {
            return FlameWindowManager.getSingleton().getWindow(name) as FlameScrollbar;
        }
        
        /*!
        \brief
        Perform caching of the widget control frame and other 'static' areas.
        This method should not render the actual items.  Note that the items
        are typically rendered to layer 3, other layers can be used for
        rendering imagery behind and infront of the items.
        
        \return
        Nothing.
        */
        protected function cacheTreeBaseImagery():void
        {
        }
        
        /*************************************************************************
         Implementation Functions
         *************************************************************************/
        /*!
        \brief
        Checks if a tree item is visible (searches sub-items)
        */
        protected function containsOpenItemRecursive(itemList:Vector.<FlameTreeItem>, item:FlameTreeItem):Boolean
        {
            var itemCount:uint = itemList.length;
            for (var index:uint = 0; index < itemCount; ++index)
            {
                if (itemList[index] == item)
                    return true;
                
                if (itemList[index].getItemCount() > 0)
                {
                    if (itemList[index].getIsOpen())
                    {
                        if (containsOpenItemRecursive(itemList[index].getItemList(), item))
                            return true;
                    }
                }
            }
            
            return false;
        }
        
        /*!
        \brief
        Add tree specific events
        */
        protected function addTreeEvents():void
        {
            addEvent(EventListContentsChanged);
            addEvent(EventSelectionChanged);
            addEvent(EventSortModeChanged);
            addEvent(EventMultiselectModeChanged);
            addEvent(EventVertScrollbarModeChanged);
            addEvent(EventHorzScrollbarModeChanged);
            addEvent(EventBranchOpened);
            addEvent(EventBranchClosed);
        }
        
        
        /*!
        \brief
        display required integrated scroll bars according to current state of
        the tree and update their values.
        */
        protected function configureScrollbars():void
        {
            var renderArea:Rect = getTreeRenderArea();
            
            
            //This is becuase CEGUI IS GAY! and fires events before the item is initialized
            if(!d_vertScrollbar)
                d_vertScrollbar = createVertScrollbar(getName() + "__auto_vscrollbar__");
            if(!d_horzScrollbar)
                d_horzScrollbar = createHorzScrollbar(getName() + "__auto_hscrollbar__");
            
            var totalHeight:Number = getTotalItemsHeight();
            var widestItem:Number  = getWidestItemWidth() + 20;
            
            //
            // First show or hide the scroll bars as needed (or requested)
            //
            // show or hide vertical scroll bar as required (or as specified by option)
            if ((totalHeight > renderArea.getHeight()) || d_forceVertScroll)
            {
                d_vertScrollbar.show();
                renderArea.d_right -= d_vertScrollbar.getWidth().d_offset + d_vertScrollbar.getXPosition().d_offset;
                //      renderArea.d_right -= d_vertScrollbar->getAbsoluteWidth() + d_vertScrollbar->getAbsoluteXPosition();
                // show or hide horizontal scroll bar as required (or as specified by option)
                if ((widestItem > renderArea.getWidth()) || d_forceHorzScroll)
                {
                    d_horzScrollbar.show();
                    //         renderArea.d_bottom -= d_horzScrollbar->getAbsoluteHeight();
                    renderArea.d_bottom -= d_horzScrollbar.getHeight().d_offset;
                }
                else
                {
                    d_horzScrollbar.hide();
                    d_horzScrollbar.setScrollPosition(0);
                }
            }
            else
            {
                // show or hide horizontal scroll bar as required (or as specified by option)
                if ((widestItem > renderArea.getWidth()) || d_forceHorzScroll)
                {
                    d_horzScrollbar.show();
                    //         renderArea.d_bottom -= d_horzScrollbar->getAbsoluteHeight();
                    renderArea.d_bottom -= d_vertScrollbar.getHeight().d_offset;
                    
                    // show or hide vertical scroll bar as required (or as specified by option)
                    if ((totalHeight > renderArea.getHeight()) || d_forceVertScroll)
                    {
                        d_vertScrollbar.show();
                        //            renderArea.d_right -= d_vertScrollbar->getAbsoluteWidth();
                        renderArea.d_right -= d_vertScrollbar.getWidth().d_offset;
                    }
                    else
                    {
                        d_vertScrollbar.hide();
                        d_vertScrollbar.setScrollPosition(0);
                    }
                }
                else
                {
                    d_vertScrollbar.hide();
                    d_vertScrollbar.setScrollPosition(0);
                    d_horzScrollbar.hide();
                    d_horzScrollbar.setScrollPosition(0);
                }
            }
            
            //
            // Set up scroll bar values
            //
            
            var itemHeight:Number;
            if (d_listItems.length > 0)
                itemHeight = d_listItems[0].getPixelSize().d_height;
            else
                itemHeight = 10;
            
            d_vertScrollbar.setDocumentSize(totalHeight);
            d_vertScrollbar.setPageSize(renderArea.getHeight());
            d_vertScrollbar.setStepSize(Math.max(1.0, renderArea.getHeight() / itemHeight));
            d_vertScrollbar.setScrollPosition(d_vertScrollbar.getScrollPosition());
            
            d_horzScrollbar.setDocumentSize(widestItem + d_vertScrollbar.getWidth().d_offset);
            //   d_horzScrollbar->setDocumentSize(widestItem + d_vertScrollbar->getAbsoluteWidth());
            d_horzScrollbar.setPageSize(renderArea.getWidth());
            d_horzScrollbar.setStepSize(Math.max(1.0, renderArea.getWidth() / HORIZONTAL_STEP_SIZE_DIVISOR));
            d_horzScrollbar.setScrollPosition(d_horzScrollbar.getScrollPosition());
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
        Return the sum of all item heights
        */
        protected function getTotalItemsHeight():Number
        {
            return getTotalItemsInListHeight(d_listItems);
        }
        
        
        protected function getTotalItemsInListHeight(itemList:Vector.<FlameTreeItem>):Number
        {
            var heightSum:Number = 0;
            var itemCount:uint = itemList.length;
            for (var index:uint = 0; index < itemCount; ++index)
            {
                heightSum += itemList[index].getPixelSize().d_height;
                if (itemList[index].getIsOpen() && (itemList[index].getItemCount() > 0))
                    heightSum += getTotalItemsInListHeight(itemList[index].getItemList());
            }
            return heightSum;
        }
        
        /*!
        \brief
        Return the width of the widest item
        */
        protected function getWidestItemWidth():Number
        {
            return getWidestItemWidthInList(d_listItems, 0);
        }

        protected function getWidestItemWidthInList(itemList:Vector.<FlameTreeItem>, itemDepth:int):Number
        {
            var widest:Number = 0;
            var itemCount:uint = itemList.length;
            for (var index:uint = 0; index < itemCount; ++index)
            {
                var buttonLocation:Rect = itemList[index].getButtonLocation();
                var thisWidth:Number = itemList[index].getPixelSize().d_width +
                    buttonLocation.getWidth() +
                    (d_horzScrollbar.getScrollPosition() / HORIZONTAL_STEP_SIZE_DIVISOR) +
                    (itemDepth * 20);
                
                if (thisWidth > widest)
                    widest = thisWidth;
                
                if (itemList[index].getIsOpen() && (itemList[index].getItemCount() > 0)){
                    var res:Number = getWidestItemWidthInList(itemList[index].getItemList(), itemDepth + 1);
                    if(res > widest)
                        widest = res;
                }
            }
            return widest;
        }
        
        /*!
        \brief
        Clear the selected state for all items (implementation)
        
        \return
        - true if treeItem was found in the search.
        - false if it was not.
        */
        protected function getHeightToItemInList(itemList:Vector.<FlameTreeItem>,  treeItem:FlameTreeItem,
                                                 itemDepth:int, height:Number):Boolean
        {
            var itemCount:uint = itemList.length;
            for (var index:uint = 0; index < itemCount; ++index)
            {
                if (treeItem == itemList[index])
                    return true;
                
                height += itemList[index].getPixelSize().d_height;
                
                if (itemList[index].getIsOpen() && (itemList[index].getItemCount() > 0))
                {
                    if (getHeightToItemInList(itemList[index].getItemList(), treeItem, itemDepth + 1, height))
                        return true;
                }
            }
            
            return false;
        }
        
        /*!
        \brief
        Clear the selected state for all items (implementation)
        
        \return
        - true if some selections were cleared
        - false nothing was changed.
        */
        protected function clearAllSelections_impl():Boolean
        {
            return clearAllSelectionsFromList(d_listItems);
        }
        
        /*!
        \brief
        Return the TreeItem under the given window local pixel co-ordinate.
        
        \return
        TreeItem that is under window pixel co-ordinate \a pt, or 0 if no
        item is under that position.
        */
        protected function getItemAtPoint(pt:Vector2):FlameTreeItem
        {
            var renderArea:Rect = getTreeRenderArea();
            
            // point must be within the rendering area of the Tree.
            if (renderArea.isPointInRect(pt))
            {
                var y:Number = new Number(renderArea.d_top - d_vertScrollbar.getScrollPosition());
                
                // test if point is above first item
                if (pt.d_y >= y)
                    return getItemFromListAtPoint(d_listItems, y, pt);
            }
            
            return null;
        }
        
        protected function getItemFromListAtPoint(itemList:Vector.<FlameTreeItem>, bottomY:Number, pt:Vector2):FlameTreeItem
        {
            var itemCount:uint = itemList.length;
            
            for (var i:uint = 0; i < itemCount; ++i)
            {
                bottomY += itemList[i].getPixelSize().d_height;
                if (pt.d_y < bottomY)
                    return itemList[i];
                
                if (itemList[i].getItemCount() > 0)
                {
                    if (itemList[i].getIsOpen())
                    {
                        var foundPointedAtTree:FlameTreeItem;
                        foundPointedAtTree = getItemFromListAtPoint(itemList[i].getItemList(), bottomY, pt);
                        if (foundPointedAtTree != null)
                            return foundPointedAtTree;
                    }
                }
            }
            
            return null;
        }
        
        /*!
        \brief
        Remove all items from the tree.
        
        \note
        Note that this will cause 'AutoDelete' items to be deleted.
        
        \return
        - true if the tree contents were changed.
        - false if the tree contents were not changed (tree already empty).
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
                        d_listItems[i] = null;
                    }
                }
                
                // clear out the list.
                d_listItems.length = 0;
                d_lastSelected = null;
                return true;
            }
        }
        
        /*!
        \brief
        Return whether this window was inherited from the given class name at
        some point in the inheritance heirarchy.
        
        \param class_name
        The class name that is to be checked.
        
        \return
        true if this window was inherited from \a class_name. false if not.
        */
        override protected function testClassName_impl(class_name:String):Boolean
        {
            if (class_name== "Tree")
                return true;
            
            return super.testClassName_impl(class_name);
        }
        
        /*!
        \brief
        Internal handler that is triggered when the user interacts with the
        scrollbars.
        */
        protected function handle_scrollChange(args:EventArgs):Boolean
        {
            // simply trigger a redraw of the Tree.
            invalidate();
            return true;
        }
        
        // overridden from Window base class.
        override protected function populateGeometryBuffer():void
        {
            // get the derived class to render general stuff before we handle the items
            cacheTreeBaseImagery();
            
            // Render list items
            var  itemPos:Vector2 = new Vector2();
            var  widest:Number = getWidestItemWidth();
            
            // calculate position of area we have to render into
            //Rect itemsArea(getTreeRenderArea());
            //Rect itemsArea(0,0,500,500);
            
            // set up some initial positional details for items
            itemPos.d_x = d_itemArea.d_left - d_horzScrollbar.getScrollPosition();
            itemPos.d_y = d_itemArea.d_top - d_vertScrollbar.getScrollPosition();
            
            drawItemList(d_listItems, d_itemArea, widest, itemPos, d_geometry,
                getEffectiveAlpha());
        }
        
        protected function drawItemList(itemList:Vector.<FlameTreeItem>, itemsArea:Rect, widest:Number,
                    itemPos:Vector2, geometry:FlameGeometryBuffer, alpha:Number):void
        {
            if (itemList.length == 0)
                return;
            
            // loop through the items
            var     itemSize:Size = new Size();
            var     itemClipper:Rect = new Rect();
            var     itemRect:Rect = new Rect();
            var     itemCount:uint = itemList.length;
            var     itemIsVisible:Boolean;
            for (var i:uint = 0; i < itemCount; ++i)
            {
                itemSize.d_height = itemList[i].getPixelSize().d_height;
                
                // allow item to have full width of box if this is wider than items
                itemSize.d_width = Math.max(itemsArea.getWidth(), widest);
                
                // calculate destination area for this item.
                itemRect.d_left = itemPos.d_x;
                itemRect.d_top  = itemPos.d_y;
                itemRect.setSize(itemSize);
                itemClipper = itemRect.getIntersection(itemsArea);
                itemRect.d_left += 20;     // start text past open/close buttons
                
                if (itemClipper.getHeight() > 0)
                {
                    itemIsVisible = true;
                    itemList[i].draw(geometry, itemRect, alpha, itemClipper);
                }
                else
                {
                    itemIsVisible = false;
                }
                
                // Process this item's list if it has items in it.
                if (itemList[i].getItemCount() > 0)
                {
                    var buttonRenderRect:Rect = new Rect();
                    buttonRenderRect.d_left = itemPos.d_x;
                    buttonRenderRect.d_right = buttonRenderRect.d_left + 10;
                    buttonRenderRect.d_top = itemPos.d_y;
                    buttonRenderRect.d_bottom = buttonRenderRect.d_top + 10;
                    itemList[i].setButtonLocation(buttonRenderRect);
                    
                    if (itemList[i].getIsOpen())
                    {
                        // Draw the Close button
                        if (itemIsVisible)
                            d_closeButtonImagery.render2(this, buttonRenderRect, null, itemClipper);
                        
                        // update position ready for next item
                        itemPos.d_y += itemSize.d_height;
                        
                        itemPos.d_x += 20;
                        drawItemList(itemList[i].getItemList(), itemsArea, widest,
                            itemPos, geometry, alpha);
                        itemPos.d_x -= 20;
                    }
                    else
                    {
                        // Draw the Open button
                        if (itemIsVisible)
                            d_openButtonImagery.render2(this, buttonRenderRect, null, itemClipper);
                        
                        // update position ready for next item
                        itemPos.d_y += itemSize.d_height;
                    }
                }
                else
                {
                    // update position ready for next item
                    itemPos.d_y += itemSize.d_height;
                }
            }
            
            // Successfully drew all items, so vertical scrollbar not needed.
            //   setShowVertScrollbar(false);
        }
        
        /*************************************************************************
         New event handlers
         *************************************************************************/
        /*!
        \brief
        Handler called internally when the tree contents are changed
        */
        public function onListContentsChanged(e:WindowEventArgs):void
        {
            configureScrollbars();
            invalidate();
            fireEvent(EventListContentsChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called internally when the currently selected item or items
        changes.
        */
        protected function onSelectionChanged(e:TreeEventArgs):void
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
        Handler called internally when the forced display of the vertical scroll
        bar setting changes.
        */
        protected function onVertScrollbarModeChanged(e:WindowEventArgs):void
        {
            invalidate();
            fireEvent(EventVertScrollbarModeChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called internally when the forced display of the horizontal
        scroll bar setting changes.
        */
        protected function onHorzScrollbarModeChanged(e:WindowEventArgs):void
        {
            invalidate();
            fireEvent(EventHorzScrollbarModeChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called internally when the user opens a branch of the tree.
        */
        protected function onBranchOpened(e:TreeEventArgs):void
        {
            invalidate();
            fireEvent(EventBranchOpened, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called internally when the user closes a branch of the tree.
        */
        protected function onBranchClosed(e:TreeEventArgs):void
        {
            invalidate();
            fireEvent(EventBranchClosed, e, EventNamespace);
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
            // populateGeometryBuffer();
            super.onMouseButtonDown(e);
            
            if (e.button == Consts.MouseButton_LeftButton)
            {
                var modified:Boolean = false;
                
                var localPos:Vector2 = CoordConverter.screenToWindowForVector2(this, e.position);
                //      Point localPos(screenToWindow(e.position));
                
                var item:FlameTreeItem = getItemAtPoint(localPos);
                
                if (item != null)
                {
                    modified = true;
                    var args1:TreeEventArgs = new TreeEventArgs(this);
                    args1.treeItem = item;
                    populateGeometryBuffer();
                    var buttonLocation:Rect = item.getButtonLocation();
                    if ((localPos.d_x >= buttonLocation.d_left) && (localPos.d_x <= buttonLocation.d_right) &&
                        (localPos.d_y >= buttonLocation.d_top) && (localPos.d_y <= buttonLocation.d_bottom))
                    {
                        item.toggleIsOpen();
                        if (item.getIsOpen())
                        {
                            var lastItemInList:FlameTreeItem = item.getTreeItemFromIndex(item.getItemCount() - 1);
                            ensureItemIsVisible(lastItemInList);
                            ensureItemIsVisible(item);
                            onBranchOpened(args1);
                        }
                        else
                        {
                            onBranchClosed(args1);
                        }
                        
                        // Update the item screen locations, needed to update the scrollbars.
                        //	populateGeometryBuffer();
                        
                        // Opened or closed a tree branch, so must update scrollbars.
                        configureScrollbars();
                    }
                    else
                    {
                        // clear old selections if no control key is pressed or if multi-select is off
                        if (!(e.sysKeys & Consts.SystemKey_Control) || !d_multiselect)
                            clearAllSelections_impl();
                        
                        // select range or item, depending upon keys and last selected item
//                        #if 0 // TODO: fix this
//                        if (((e.sysKeys & Consts.SystemKey_Shift) && (d_lastSelected != null)) && d_multiselect)
//                            selectRange(getItemIndex(item), getItemIndex(d_lastSelected));
//                        else
//                        #endif
                        item.setSelected(!item.isSelected());
                        
                        // update last selected item
                        d_lastSelected = item.isSelected() ? item :null;
                        onSelectionChanged(args1);
                    }
                }
                else
                {
                    // clear old selections if no control key is pressed or if multi-select is off
                    if (!(e.sysKeys & Consts.SystemKey_Control) || !d_multiselect)
                    {
                        if (clearAllSelections_impl())
                        {
                            // Changes to the selections were actually made
                            var args2:TreeEventArgs = new TreeEventArgs(this);
                            args2.treeItem = item;
                            onSelectionChanged(args2);
                        }
                    }
                }
                
                
                ++e.handled;
            }
        }
        
        
        override public function onMouseWheel(e:MouseEventArgs):void
        {
            // base class processing.
            super.onMouseWheel(e);
            
            if (d_vertScrollbar.isVisible() && (d_vertScrollbar.getDocumentSize() > d_vertScrollbar.getPageSize()))
                d_vertScrollbar.setScrollPosition(d_vertScrollbar.getScrollPosition() + d_vertScrollbar.getStepSize() * -e.wheelChange);
            else if (d_horzScrollbar.isVisible() && (d_horzScrollbar.getDocumentSize() > d_horzScrollbar.getPageSize()))
                d_horzScrollbar.setScrollPosition(d_horzScrollbar.getScrollPosition() + d_horzScrollbar.getStepSize() * -e.wheelChange);
            
            ++e.handled;
        }

        
        override public function onMouseMove(e:MouseEventArgs):void
        {
            if (d_itemTooltips)
            {
                
                var posi:Vector2 = CoordConverter.screenToWindowForVector2(this, e.position);
                //      Point posi = relativeToAbsolute(CoordConverter::screenToWindow(*this, e.position));
                var item:FlameTreeItem = getItemAtPoint(posi);
                if (item != __lastItem)
                {
                    if (item != null)
                    {
                        setTooltipText(item.getTooltipText());
                    }
                    else
                    {
                        setTooltipText("");
                    }
                    __lastItem = item;
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
        private function addTreeProperties():void
        {
            addProperty(d_sortProperty);
            addProperty(d_multiSelectProperty);
            addProperty(d_forceHorzProperty);
            addProperty(d_forceVertProperty);
            addProperty(d_itemTooltipsProperty);
        }
        
        
        /*!
        \brief
        Helper function used in sorting to compare two tree item text strings
        via the TreeItem pointers and return if \a a is less than \a b.
        */
        private function lbi_less(a:FlameTreeItem, b:FlameTreeItem):int
        {
            return (a.getText() < b.getText()) ? 1 : -1;
        }
        
        
        /*!
        \brief
        Helper function used in sorting to compare two tree item text strings
        via the TreeItem pointers and return if \a a is greater than \a b.
        */
        private function lbi_greater(a:FlameTreeItem, b:FlameTreeItem):int
        {
            return (a.getText() > b.getText()) ? 1 : -1;
        }
    }
}