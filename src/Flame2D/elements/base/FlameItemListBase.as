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
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.UVector2;

    public class FlameItemListBase extends FlameWindow
    {
        //!< Sorting callback type
        //typedef bool (*SortCallback)(const ItemEntry* a, const ItemEntry* b);
        
        /*************************************************************************
         Constants
         *************************************************************************/
        // event names
        /** Event fired when the contents of the list is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ItemListBase whose contents
         * has changed.
         */
        public static const EventListContentsChanged:String = "ListItemsChanged";
        /** Event fired when the sort enabled state of the list is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ItemListBase whose sort enabled mode
         * has been changed.
         */
        public static const EventSortEnabledChanged:String = "SortEnabledChanged";
        /** Event fired when the sort mode of the list is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ItemListBase whose sorting mode
         * has been changed.
         */
        public static const EventSortModeChanged:String = "SortModeChanged";

        
        /*************************************************************************
         Static Properties for this class
         *************************************************************************/
        private static var d_autoResizeEnabledProperty:ItemListBasePropertyAutoResizeEnabled = new ItemListBasePropertyAutoResizeEnabled();
        private static var d_sortEnabledProperty:ItemListBasePropertySortEnabled = new ItemListBasePropertySortEnabled();
        private static var d_sortModeProperty:ItemListBasePropertySortMode = new ItemListBasePropertySortMode();
        
        
        /*************************************************************************
         Implementation Data
         *************************************************************************/
        //typedef	std::vector<ItemEntry*>	ItemEntryList;
        protected var d_listItems:Vector.<FlameItemEntry> = new Vector.<FlameItemEntry>();		//!< list of items in the list.
        
        //!< True if this ItemListBase widget should automatically resize to fit its content. False if not.
        protected var d_autoResize:Boolean = false;
        
        //!< Pointer to the content pane (for items), 0 if we're not using one
        protected var d_pane:FlameWindow;
        
        //!< True if this ItemListBase is sorted. False if not.
        protected var d_sortEnabled:Boolean = false;
        //!< The current sorting mode applied if sorting is enabled.
        protected var d_sortMode:uint = Consts.SortMode_Ascending;
        //!< The user sort callback or 0 if none.
        protected var d_sortCallback:Function = null;
        //!< True if the list needs to be resorted.
        protected var d_resort:Boolean = false;
        
        
        /*************************************************************************
         Construction and Destruction
         *************************************************************************/
        /*!
        \brief
        Constructor for ItemListBase base class.
        */
        public function FlameItemListBase(type:String, name:String)
        {
            super(type, name);
            // by default we dont have a content pane, but to make sure things still work
            // we "emulate" it by setting it to this
            d_pane = this;
            
            // add properties for ItemListBase class
            addItemListBaseProperties();
        }
        
  
        /*************************************************************************
         Accessor Methods
         *************************************************************************/
        /*!
        \brief
        Return number of items attached to the list
        
        \return
        the number of items currently attached to this list.
        */
        public function getItemCount():uint
        {
            return d_listItems.length;
        }
        
        
        /*!
        \brief
        Return the item at index position \a index.
        
        \param index
        Zero based index of the item to be returned.
        
        \return
        Pointer to the ItemEntry at index position \a index in the list.
        
        \exception	InvalidRequestException	thrown if \a index is out of range.
        */
        public function getItemFromIndex(index:uint):FlameItemEntry
        {
            if (index < d_listItems.length)
            {
                return d_listItems[index];
            }
            else
            {
                throw new Error("ItemListBase::getItemFromIndex - the specified index is out of range for this ItemListBase.");
            }
        }
        
        /*!
        \brief
        Return the index of ItemEntry \a item
        
        \param item
        Pointer to a ItemEntry whos zero based index is to be returned.
        
        \return
        Zero based index indicating the position of ItemEntry \a item in the list.
        
        \exception	InvalidRequestException	thrown if \a item is not attached to this list.
        */
        public function getItemIndex(item:FlameItemEntry):uint
        {
            var idx:int = d_listItems.indexOf(item);
            
            if(idx != -1)
            {
                return idx;
            }
            else
            {
                throw new Error("ItemListBase::getItemIndex - the specified ItemEntry is not attached to this ItemListBase.");
            }
        }
        
        
        /*!
        \brief
        Search the list for an item with the specified text
        
        \param text
        String object containing the text to be searched for.
        
        \param start_item
        ItemEntry where the search is to begin, the search will not include \a item.  If \a item is
        NULL, the search will begin from the first item in the list.
        
        \return
        Pointer to the first ItemEntry in the list after \a item that has text matching \a text.  If
        no item matches the criteria NULL is returned.
        
        \exception	InvalidRequestException	thrown if \a item is not attached to this list box.
        */
        public function findItemWithText(text:String, start_item:FlameItemEntry):FlameItemEntry
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
        Return whether the specified ItemEntry is in the List
        
        \return
        true if ItemEntry \a item is in the list, false if ItemEntry \a item is not in the list.
        */
        public function isItemInList(item:FlameItemEntry):Boolean
        {
            //return std::find(d_listItems.begin(), d_listItems.end(), item) != d_listItems.end();
            return (item.getOwnerList() == this);
        }
        
        
        /*!
        \brief
        Return whether this window is automatically resized to fit its content.
        
        \return
        true if automatic resizing is enabled, false if it is disabled.
        */
        public function isAutoResizeEnabled():Boolean
        {
            return d_autoResize;
        }
        
        
        /*!
        \brief
        Returns 'true' if the list is sorted
        */
        public function isSortEnabled():Boolean
        {
            return d_sortEnabled;
        }
        
        
        /*!
        \brief
        Get sort mode.
        */
        public function getSortMode():uint
        {
            return d_sortMode;
        }
        
        
        /*!
        \brief
        Get user sorting callback.
        */
        public function getSortCallback():Function
        {
            return d_sortCallback;
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
            // this pane may be ourselves, and in fact is by default...
           d_pane.subscribeEvent(FlameWindow.EventChildRemoved, new Subscriber(handle_PaneChildRemoved, this), FlameWindow.EventNamespace);
        }
        
        
        /*!
        \brief
        Remove all items from the list.
        
        Note that this will cause items, which does not have the 'DestroyedByParent' property set to 'false', to be deleted.
        */
        public function resetList():void
        {
            if (resetList_impl())
            {
                handleUpdatedItemData();
            }
        }
        
        
        /*!
        \brief
        Add the given ItemEntry to the list.
        
        \param item
        Pointer to the ItemEntry to be added to the list.  Note that it is the passed object that is added to the
        list, a copy is not made.  If this parameter is NULL, nothing happens.
        
        \return
        Nothing.
        */
        public function addItem(item:FlameItemEntry):void
        {
            // make sure the item is valid and that we dont already have it in our list
            if (item && item.getOwnerList() != this)
            {
                // if sorting is enabled, re-sort the list
                if (d_sortEnabled)
                {
                    d_listItems.push(item);
                    d_listItems.sort(getRealSortCallback());
                }
                    // just stick it on the end.
                else
                {
                    d_listItems.push(item);
                }
                // make sure it gets added properly
                item.setOwnerList(this);
                addChildWindow(item);
                handleUpdatedItemData();
            }
        }
        
        
        /*!
        \brief
        Insert an item into the list before a specified item already in the list.
        
        Note that if the list is sorted, the item may not end up in the
        requested position.
        
        \param item
        Pointer to the ItemEntry to be inserted.  Note that it is the passed
        object that is added to the list, a copy is not made.  If this parameter
        is NULL, nothing happens.
        
        \param position
        Pointer to a ItemEntry that \a item is to be inserted before.  If this
        parameter is NULL, the item is inserted at the start of the list.
        
        \return
        Nothing.
        */
        public function insertItem(item:FlameItemEntry, position:FlameItemEntry):void
        {
            if (d_sortEnabled)
            {
                addItem(item);
            }
            else if (item && item.getOwnerList() != this)
            {
                // if position is NULL begin insert at begining, else insert after item 'position'
                var ins_pos:int = 0;
                
                if (!position)
                {
                    ins_pos = 0;
                }
                else
                {
                    ins_pos = d_listItems.indexOf(position);
                    
                    // throw if item 'position' is not in the list
                    if (ins_pos == -1)
                    {
                        throw new Error("ItemListBase::insertItem - the specified ItemEntry for parameter 'position' is not attached to this ItemListBase.");
                    }
                    
                }
                
                d_listItems.splice(ins_pos, 0, item);
                item.setOwnerList(this);
                addChildWindow(item);
                
                handleUpdatedItemData();
            }
        }
        
        
        /*!
        \brief
        Removes the given item from the list.  If the item is has the 'DestroyedByParent' property set to 'true', the item will be deleted.
        
        \param item
        Pointer to the ItemEntry that is to be removed.  If \a item is not attached to this list then nothing
        will happen.
        
        \return
        Nothing.
        */
        public function removeItem(item:FlameItemEntry):void
        {
            if (item && item.getOwnerList() == this)
            {
                d_pane.removeChildWindow(item);
                if (item.isDestroyedByParent())
                {
                    FlameWindowManager.getSingleton().destroyWindow(item);
                }
            }
        }
        
        
        /*!
        \brief
        Causes the list to update it's internal state after changes have been made to one or more
        attached ItemEntry objects.
        
        It should not be necessary to call this from client code, as the ItemEntries themselves call it if their parent is an ItemListBase.
        
        \param resort
        'true' to redo the list sorting as well.
        'false' to only do layout and perhaps auto resize.
        (defaults to 'false')
        
        \return
        Nothing.
        */
        public function handleUpdatedItemData(resort:Boolean=false):void
        {
            if (!d_destructionStarted)
            {
                //d_resort |= resort;
                if(resort) d_resort = true;
                var args:WindowEventArgs = new WindowEventArgs(this);
                onListContentsChanged(args);
            }
        }
        
        
        /*!
        \brief
        Set whether or not this ItemListBase widget should automatically resize to fit its content.
        
        \param setting
        Boolean value that if true enables automatic resizing, if false disables automatic resizing.
        
        \return
        Nothing.
        */
        public function setAutoResizeEnabled(setting:Boolean):void
        {
            var old:Boolean = d_autoResize;
            d_autoResize = setting;
            
            // if not already enabled, trigger a resize - only if not currently initialising
            if ( d_autoResize && !old && !d_initialising)
            {
                sizeToContent();
            }
        }
        
        
        /*!
        \brief
        Resize the ItemListBase to exactly fit the content that is attached to it.
        Return a Rect object describing, in un-clipped pixels, the window relative area
        that is to be used for rendering items.
        
        \return
        Nothing
        */
        public function sizeToContent():void
        {
            sizeToContent_impl();
        }
        
        
        /*!
        \brief
        Triggers a ListContentsChanged event.
        These are not fired during initialisation for optimization purposes.
        */
        override public function endInitialisation():void
        {
            /////super.endInitialisation();
            handleUpdatedItemData(true);
        }
        
        
        /*!
        \brief
        method called to perform extended laying out of attached child windows.
        
        The system may call this at various times (like when it is resized for
        example), and it may be invoked directly where required.
        
        \return
        Nothing.
        */
        override public function performChildWindowLayout():void
        {
            super.performChildWindowLayout();
            // if we are not currently initialising
            if (!d_initialising)
            {
                // Redo the item layout.
                // We don't just call handleUpdateItemData, as that could trigger a resize,
                // which is not what is being requested.
                // It would also cause infinite recursion... so lets just avoid that :)
                layoutItemWidgets();
            }
        }
        
        
        /*!
        \brief
        Return a Rect object describing, in un-clipped pixels, the window relative area
        that is to be used for rendering list items.
        
        \return
        Rect object describing the window relative area of the that is to be used for rendering
        the items.
        */
        public function getItemRenderArea():Rect
        {
            if (d_windowRenderer != null)
            {
                var wr:ItemListBaseWindowRenderer = d_windowRenderer as ItemListBaseWindowRenderer;
                return wr.getItemRenderArea();
            }
            else
            {
                //return getItemRenderArea_impl();
                throw new Error("ItemListBase::getItemRenderArea - This function must be implemented by the window renderer module");
            }
        }
        
        /*!
        \brief
        Returns a pointer to the window that all items are directed too.
        
        \return
        A pointer to the content pane window, or 'this' if children are added
        directly to this window.
        */
        public function getContentPane():FlameWindow
        {
            return d_pane;
        }
        
        /*!
        \brief
        Notify this ItemListBase that the given item was just clicked.
        Internal function - NOT to be used from client code.
        */
        public function notifyItemClicked(item:FlameItemEntry):void
        {
        }
        
        /*!
        \brief
        Notify this ItemListBase that the given item just changed selection state.
        Internal function - NOT to be used from client code.
        */
        public function notifyItemSelectState(item:FlameItemEntry, state:Boolean):void 
        {
        }
        
        /*!
        \brief
        Set whether the list should be sorted (by text).
        */
        public function setSortEnabled(setting:Boolean):void
        {
            if (d_sortEnabled != setting)
            {
                d_sortEnabled = setting;
                
                if (d_sortEnabled && !d_initialising)
                {
                    sortList();
                }
                
                var e:WindowEventArgs = new WindowEventArgs(this);
                onSortEnabledChanged(e);
            }
        }
        
        /*!
        \brief
        Set mode to be used when sorting the list.
        \param mode
        SortMode enum.
        */
        public function setSortMode(mode:uint):void
        {
            if (d_sortMode != mode)
            {
                d_sortMode = mode;
                if (d_sortEnabled && !d_initialising)
                    sortList();
                
                var e:WindowEventArgs = new WindowEventArgs(this);
                onSortModeChanged(e);
            }
        }
            
        
        /*!
        \brief
        Set a user callback as sorting function
        
        \param mode
        SortCallback
        */
        public function setSortCallback(cb:Function):void
        {
            if (d_sortCallback != cb)
            {
                d_sortCallback = cb;
                if (d_sortEnabled && !d_initialising)
                {
                    sortList();
                }
                handleUpdatedItemData(true);
            }
        }
        
        /*!
        \brief
        Sort the list.
        
        \param relayout
        True if the item layout should be redone after the sorting.
        False to only sort the internal list. Nothing more.
        
        This parameter defaults to true and should generally not be
        used in client code.
        */
        public function sortList(relayout:Boolean=true):void
        {
            d_listItems.sort( getRealSortCallback());
            if (relayout)
            {
                layoutItemWidgets();
            }
        }
        
        
        
        /*************************************************************************
         Abstract Implementation Functions (must be provided by derived class)
         *************************************************************************/
        /*!
        \brief
        Resize the ItemListBase to exactly fit the content that is attached to it.
        Return a Rect object describing, in un-clipped pixels, the window relative area
        that is to be used for rendering items.
        
        \return
        Nothing
        */
        protected function sizeToContent_impl():void
        {
            var renderArea:Rect = getItemRenderArea();
            var wndArea:Rect = getArea().asAbsolute(getParentPixelSize());
            
            // get size of content
            var sz:Size = getContentSize();
            
            // calculate the full size with the frame accounted for and resize the window to this
            sz.d_width  += wndArea.getWidth() - renderArea.getWidth();
            sz.d_height += wndArea.getHeight() - renderArea.getHeight();
            setSize(new UVector2(Misc.cegui_absdim(sz.d_width), Misc.cegui_absdim(sz.d_height)));
        }
        
        
        /*!
        \brief
        Returns the Size in unclipped pixels of the content attached to this ItemListBase that is attached to it.
        
        \return
        Size object describing in unclipped pixels the size of the content ItemEntries attached to this menu.
        */
        protected function getContentSize():Size
        {
            return new Size();
        }
        
        
        /*!
        \brief
        Return a Rect object describing, in un-clipped pixels, the window relative area
        that is to be used for rendering list items.
        
        \return
        Rect object describing the window relative area of the that is to be used for rendering
        the items.
        */
        //virtual	Rect	getItemRenderArea_impl(void) const		= 0;
        
        
        /*!
        \brief
        Setup size and position for the item widgets attached to this ItemListBase
        
        \return
        Nothing.
        */
        protected function layoutItemWidgets():void
        {
            
        }
        
        
        /*************************************************************************
         Implementation Functions
         *************************************************************************/
        /*!
        \brief
        Remove all items from the list.
        
        \note
        Note that this will cause items with the 'DestroyedByParent' property set to 'true', to be deleted.
        
        \return
        - true if the list contents were changed.
        - false if the list contents were not changed (list already empty).
        */
        protected function resetList_impl():Boolean
        {
            // just return false if the list is already empty
            if (d_listItems.length == 0)
            {
                return false;
            }
                // we have items to be removed and possible deleted
            else
            {
                // delete any items we are supposed to
                while (d_listItems.length != 0)
                {
                    var item:FlameItemEntry = d_listItems[0];
                    d_pane.removeChildWindow(item);
                    if (item.isDestroyedByParent())
                    {
                        FlameWindowManager.getSingleton().destroyWindow(item);
                    }
                }
                
                // list is cleared by the removeChild calls
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
            if (class_name=="ItemListBase")	return true;
            return super.testClassName_impl(class_name);
        }
        
        // validate window renderer
        protected function validateWindowRenderer(name:String):Boolean
        {
            return (name == EventNamespace);
        }
        
        /*!
        \brief
        Returns the SortCallback that's really going to be used for the sorting operation.
        */
        protected function getRealSortCallback():Function
        {
            switch (d_sortMode)
            {
                case Consts.SortMode_Ascending:
                    return ItemEntry_less;
                    
                case Consts.SortMode_Descending:
                    return ItemEntry_greater;
                    
                case Consts.SortMode_UserSort:
                    return (d_sortCallback!=null) ? d_sortCallback : ItemEntry_less;
                    
                    // we default to ascending sorting
                default:
                    return ItemEntry_less;
            }
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
            // if we are not currently initialising we might have things todo
            if (!d_initialising)
            {
                invalidate();
                
                // if auto resize is enabled - do it
                if (d_autoResize)
                    sizeToContent();
                
                // resort list if requested and enabled
                if (d_resort && d_sortEnabled)
                    sortList(false);
                d_resort = false;
                
                // redo the item layout and fire our event
                layoutItemWidgets();
                fireEvent(EventListContentsChanged, e, EventNamespace);
            }
        }
        
        /*!
        \brief
        Handler called internally when sorting gets enabled.
        */
        protected function onSortEnabledChanged(e:WindowEventArgs):void
        {
            fireEvent(EventSortEnabledChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called internally when the sorting mode is changed.
        */
        protected function onSortModeChanged(e:WindowEventArgs):void
        {
            fireEvent(EventSortModeChanged, e, EventNamespace);
        }
        
        /*************************************************************************
         Overridden Event handlers
         *************************************************************************/
        override public function onParentSized(e:WindowEventArgs):void
        {
            super.onParentSized(e);
            
            if (d_autoResize)
                sizeToContent();
        }
        //virtual void    onChildRemoved(WindowEventArgs& e);
        //virtual void    onDestructionStarted(WindowEventArgs& e);
        
        

        

        /*!
        \brief
        Add given window to child list at an appropriate position
        */
        override protected function addChild_impl(wnd:FlameWindow):void
        {
            // if this is an ItemEntry we add it like one, but only if it is not already in the list!
            if (wnd.testClassName("ItemEntry"))
            {
                // add to the pane if we have one
                if (d_pane != this)
                {
                    d_pane.addChildWindow(wnd);
                }
                    // add item directly to us
                else
                {
                    super.addChild_impl(wnd);
                }
                
                var item:FlameItemEntry = wnd as FlameItemEntry;
                if (item.getOwnerList() != this)
                {
                    // perform normal addItem
                    // if sorting is enabled, re-sort the list
                    if (d_sortEnabled)
                    {
                        d_listItems.push(item);
                        d_listItems.sort(getRealSortCallback())
                    }
                        // just stick it on the end.
                    else
                    {
                        d_listItems.push(item);
                    }
                    item.setOwnerList(this);
                    handleUpdatedItemData();
                }
            }
                // otherwise it's base class processing
            else
            {
                super.addChild_impl(wnd);
            }
        }
        
        /*!
        \brief
        Handler to manage items being removed from the content pane.
        If there is one!
        */
        public function handle_PaneChildRemoved(e:EventArgs):Boolean
        {
            var w:FlameWindow = (e as WindowEventArgs).window;
            
            // make sure it is removed from the itemlist if we have an ItemEntry
            if (w.testClassName("ItemEntry"))
            {
                //ItemEntryList::iterator pos = std::find(d_listItems.begin(), d_listItems.end(), w);
                
                var pos:int = d_listItems.indexOf(w);
                // if item is in the list
                if(pos != -1)
                {
                    // make sure the item is no longer related to us
                    d_listItems[pos].setOwnerList(null);
                    // remove item
                    d_listItems.splice(pos, 1);
                    // trigger list update
                    handleUpdatedItemData();
                }
            }
            
            return false;
        }
        
        
        /*************************************************************************
         Private methods
         *************************************************************************/
        private function addItemListBaseProperties():void
        {
            addProperty(d_autoResizeEnabledProperty);
            addProperty(d_sortEnabledProperty);
            addProperty(d_sortModeProperty);
        }
        

        
        /*************************************************************************
         used for < comparisons between ItemEntry pointers
         *************************************************************************/
        private static function ItemEntry_less(a:FlameItemEntry, b:FlameItemEntry):int
        {
            return (a.getText() < b.getText()) ? 1 : -1;
        }
        
        
        /*************************************************************************
         used for > comparisons between ItemEntry pointers
         *************************************************************************/
        private static function ItemEntry_greater(a:FlameItemEntry, b:FlameItemEntry):int
        {
            return (a.getText() > b.getText()) ? 1 : -1;
        }

    }
}