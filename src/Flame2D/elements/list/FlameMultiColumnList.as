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
package Flame2D.elements.list
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.events.HeaderSequenceEventArgs;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.CoordConverter;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.UDim;
    import Flame2D.core.utils.Vector2;
    import Flame2D.elements.base.FlameScrollbar;
    import Flame2D.elements.listbox.FlameListboxItem;
    
    public class FlameMultiColumnList extends FlameWindow
    {
        public static const EventNamespace:String = "MultiColumnList";
        public static const WidgetTypeName:String = "CEGUI/MultiColumnList";
        
        
        /*************************************************************************
         Constants
         *************************************************************************/
        // Event names
        /** Event fired when the selection mode for the list box changes.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the MultiColumnList whose selection mode
         * has been changed.
         */
        public static const EventSelectionModeChanged:String = "SelectModeChanged";
        /** Event fired when the nominated select column changes.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the MultiColumnList whose nominated
         * selection column has been changed.
         */
        public static const EventNominatedSelectColumnChanged:String = "NomSelColChanged";
        /** Event fired when the nominated select row changes.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the MultiColumnList whose nominated
         * selection row has been changed.
         */
        public static const EventNominatedSelectRowChanged:String = "NomSelRowChanged";
        /** Event fired when the vertical scroll bar 'force' setting changes.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the MultiColumnList whose vertical scroll
         * bar mode has been changed.
         */
        public static const EventVertScrollbarModeChanged:String = "VertBarModeChanged";
        /** Event fired when the horizontal scroll bar 'force' setting changes.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the MultiColumnList whose horizontal
         * scroll bar mode has been changed.
         */
        public static const EventHorzScrollbarModeChanged:String = "HorzBarModeChanged";
        /** Event fired when the current selection(s) within the list box changes.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the MultiColumnList whose current
         * selection has changed.
         */
        public static const EventSelectionChanged:String = "SelectionChanged";
        /** Event fired when the contents of the list box changes.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the MultiColumnList whose contents has
         * changed.
         */
        public static const EventListContentsChanged:String = "ContentsChanged";
        /** Event fired when the sort column changes.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the MultiColumnList whose sort column has
         * been changed.
         */
        public static const EventSortColumnChanged:String = "SortColChanged";
        /** Event fired when the sort direction changes.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the MultiColumnList whose sort direction
         * has been changed.
         */
        public static const EventSortDirectionChanged:String = "SortDirChanged";
        /** Event fired when the width of a column in the list changes.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the MultiColumnList for which a column
         * width has changed.
         */
        public static const EventListColumnSized:String = "ColSized";
        /** Event fired when the column order changes.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the MultiColumnList for which the order
         * of columns has been changed.
         */
        public static const EventListColumnMoved:String = "ColMoved";
        
        /*************************************************************************
         Child Widget name suffix constants
         *************************************************************************/
        public static const VertScrollbarNameSuffix:String = "__auto_vscrollbar__";   //!< Widget name suffix for the vertical scrollbar component.
        public static const HorzScrollbarNameSuffix:String = "__auto_hscrollbar__";   //!< Widget name suffix for the horizontal scrollbar component.
        public static const ListHeaderNameSuffix:String = "__auto_listheader__";      //!< Widget name suffix for the list header component.
        

        /*************************************************************************
         Static Properties for this class
         *************************************************************************/
        public static var d_columnsMovableProperty:MultiColumnListPropertyColumnsMovable = new MultiColumnListPropertyColumnsMovable();
        public static var d_columnsSizableProperty:MultiColumnListPropertyColumnsSizable = new MultiColumnListPropertyColumnsSizable();
        public static var d_forceHorzScrollProperty:MultiColumnListPropertyForceHorzScrollbar = new MultiColumnListPropertyForceHorzScrollbar();
        public static var d_forceVertScrollProperty:MultiColumnListPropertyForceVertScrollbar = new MultiColumnListPropertyForceVertScrollbar();
        public static var d_nominatedSelectColProperty:MultiColumnListPropertyNominatedSelectionColumnID = new MultiColumnListPropertyNominatedSelectionColumnID();
        public static var d_nominatedSelectRowProperty:MultiColumnListPropertyNominatedSelectionRow = new MultiColumnListPropertyNominatedSelectionRow();
        public static var d_selectModeProperty:MultiColumnListPropertySelectionMode = new MultiColumnListPropertySelectionMode();
        public static var d_sortColumnIDProperty:MultiColumnListPropertySortColumnID = new MultiColumnListPropertySortColumnID();
        public static var d_sortDirectionProperty:MultiColumnListPropertySortDirection = new MultiColumnListPropertySortDirection();
        public static var d_sortSettingProperty:MultiColumnListPropertySortSettingEnabled = new MultiColumnListPropertySortSettingEnabled();
        public static var d_columnHeaderProperty:MultiColumnListPropertyColumnHeader = new MultiColumnListPropertyColumnHeader();
        public static var d_rowCountProperty:MultiColumnListPropertyRowCount = new MultiColumnListPropertyRowCount;

        
        /*************************************************************************
         Implementation Data
         *************************************************************************/
        // scrollbar settings.
        protected var d_forceVertScroll:Boolean = false;		//!< true if vertical scrollbar should always be displayed
        protected var d_forceHorzScroll:Boolean = false;		//!< true if horizontal scrollbar should always be displayed
        
        // selection abilities.
        protected var d_selectMode:uint;	//!< Holds selection mode (represented by settings below).
        protected var d_nominatedSelectCol:uint = 0;	//!< Nominated column for single column selection.
        protected var d_nominatedSelectRow:uint = 0;	//!< Nominated row for single row selection.
        protected var d_multiSelect:Boolean;			//!< Allow multiple selections.
        protected var d_fullRowSelect:Boolean;		//!< All items in a row are selected.
        protected var d_fullColSelect:Boolean;		//!< All items in a column are selected.
        protected var d_useNominatedRow:Boolean;		//!< true if we use a nominated row to select.
        protected var d_useNominatedCol:Boolean;		//!< true if we use a nominated col to select.
        protected var d_lastSelected:FlameListboxItem = null;	//!< holds pointer to the last selected item (used in range selections)
        
        protected var d_columnCount:uint = 0;          //!< keeps track of the number of columns.
        
        // storage of items in the list box.
        //typedef std::vector<ListRow>		ListItemGrid;
        //ListItemGrid	d_grid;			//!< Holds the list box data.
        protected var d_grid:Vector.<ListRow> = new Vector.<ListRow>();



        /*************************************************************************
         Construction and Destruction
         *************************************************************************/
        /*!
        \brief
        Constructor for the Multi-column list base class
        */
        public function FlameMultiColumnList(type:String, name:String)
        {
            super(type, name);
         
            // add properties
            addMultiColumnListProperties();
            
            // set default selection mode
            d_selectMode = Consts.SelectionMode_CellSingle;		// hack to ensure call below does what it should.
            setSelectionMode(Consts.SelectionMode_CellSingle);
        }
        
        /*************************************************************************
         Accessor Methods
         *************************************************************************/
        /*!
        \brief
        Return whether user manipulation of the sort column and direction are enabled.
        
        \return
        true if the user may interactively modify the sort column and direction.  false if the user may not
        modify the sort column and direction (these can still be set programmatically).
        */
        public function isUserSortControlEnabled():Boolean
        {
            return getListHeader().isSortingEnabled();
        }
        
        
        /*!
        \brief
        Return whether the user may size column segments.
        
        \return
        true if the user may interactively modify the width of columns, false if they may not.
        */
        public function isUserColumnSizingEnabled():Boolean
        {
            return getListHeader().isColumnSizingEnabled();
        }
        
        
        /*!
        \brief
        Return whether the user may modify the order of the columns.
        
        \return
        true if the user may interactively modify the order of the columns, false if they may not.
        */
        public function isUserColumnDraggingEnabled():Boolean
        {
            return getListHeader().isColumnDraggingEnabled();
        }
        
        /*!
        \brief
        Return the number of columns in the multi-column list
        
        \return
        uint value equal to the number of columns in the list.
        */
        public function getColumnCount():uint
        {
            return d_columnCount;
        }
        
        
        /*!
        \brief
        Return the number of rows in the multi-column list.
        
        \return
        uint value equal to the number of rows currently in the list.
        */
        public function getRowCount():uint
        {
            return d_grid.length;
        }
        
        
        /*!
        \brief
        Return the zero based index of the current sort column.  There must be at least one column to successfully call this
        method.
        
        \return
        Zero based column index that is the current sort column.
        
        \exception	InvalidRequestException		thrown if there are no columns in this multi column list.
        */
        public function getSortColumn():uint
        {
            return getListHeader().getSortColumn();
        }
        
        
        /*!
        \brief
        Return the zero based column index of the column with the specified ID.
        
        \param col_id
        ID code of the column whos index is to be returned.
        
        \return
        Zero based column index of the first column whos ID matches \a col_id.
        
        \exception	InvalidRequestException		thrown if no attached column has the requested ID.
        */
        public function getColumnWithID(col_id:uint):uint
        {
            return getListHeader().getColumnFromID(col_id);
        }
        
        
        /*!
        \brief
        Return the zero based index of the column whos header text matches the specified text.
        
        \param text
        String object containing the text to be searched for.
        
        \return
        Zero based column index of the column whos header has the specified text.
        
        \exception InvalidRequestException	thrown if no columns header has the requested text.
        */
        public function getColumnWithHeaderText(text:String):uint
        {
            return getListHeader().getColumnWithText(text);
        }
        
        
        /*!
        \brief
        Return the total width of all column headers.
        
        \return
        Sum total of all the column header widths as a UDim.
        */
        public function getTotalColumnHeadersWidth():UDim
        {
            var header:FlameListHeader = getListHeader();
            var width:UDim = new UDim(0,0);
            
            for (var i:uint = 0; i < getColumnCount(); ++i)
                width += header.getColumnWidth(i);
            
            return width;
        }
        
        
        /*!
        \brief
        Return the width of the specified column header (and therefore the column itself).
        
        \param col_idx
        Zero based column index of the column whos width is to be returned.
        
        \return
        Width of the column header at the zero based column index specified by \a col_idx, as a UDim
        
        \exception InvalidRequestException	thrown if \a column is out of range.
        */
        public function getColumnHeaderWidth(col_idx:uint):UDim
        {
            return getListHeader().getColumnWidth(col_idx);
        }
        
        /*!
        \brief
        Return the currently set sort direction.
        
        \return
        One of the ListHeaderSegment::SortDirection enumerated values specifying the current sort direction.
        */
        public function getSortDirection():uint
        {
            return getListHeader().getSortDirection();
        }
        
        
        /*!
        \brief
        Return the ListHeaderSegment object for the specified column
        
        \param col_idx
        zero based index of the column whos ListHeaderSegment is to be returned.
        
        \return
        ListHeaderSegment object for the column at the requested index.
        
        \exception InvalidRequestException	thrown if \a col_idx is out of range.
        */
        public function getHeaderSegmentForColumn(col_idx:uint):FlameListHeaderSegment
        {
            return getListHeader().getSegmentFromColumn(col_idx);
        }
        
        
        /*!
        \brief
        Return the zero based index of the Row that contains \a item.
        
        \param item
        Pointer to the ListboxItem that the row index is to returned for.
        
        \return
        Zero based index of the row that contains ListboxItem \a item.
        
        \exception InvalidRequestException	thrown if \a item is not attached to the list box.
        */
        public function getItemRowIndex(item:FlameListboxItem):uint
        {
            for (var i:uint = 0; i < getRowCount(); ++i)
            {
                if (isListboxItemInRow(item, i))
                {
                    return i;
                }
                
            }
            
            // item is not attached to the list box, throw...
            throw new Error("MultiColumnList::getItemRowIndex - the given ListboxItem is not attached to this MultiColumnList.");
        }
        
        
        /*!
        \brief
        Return the current zero based index of the column that contains \a item.
        
        \param item
        Pointer to the ListboxItem that the column index is to returned for.
        
        \return
        Zero based index of the column that contains ListboxItem \a item.
        
        \exception InvalidRequestException	thrown if \a item is not attached to the list box.
        */
        public function getItemColumnIndex(item:FlameListboxItem):uint
        {
            for (var i:uint = 0; i < getColumnCount(); ++i)
            {
                if (isListboxItemInColumn(item, i))
                {
                    return i;
                }
                
            }
            
            // item is not attached to the list box, throw...
            throw new Error("MultiColumnList::getItemColumnIndex - the given ListboxItem is not attached to this MultiColumnList.");
        }
        
        /*!
        \brief
        Return the grid reference for \a item.
        
        \param item
        Pointer to the ListboxItem whos current grid reference is to be returned.
        
        \return
        MCLGridRef object describing the current grid reference of ListboxItem \a item.
        
        \exception InvalidRequestException	thrown if \a item is not attached to the list box.
        */
        public function getItemGridReference(item:FlameListboxItem):MCLGridRef
        {
            return new MCLGridRef(getItemRowIndex(item), getItemColumnIndex(item));
        }
        
        
        /*!
        \brief
        Return a pointer to the ListboxItem at the specified grid reference.
        
        \param grid_ref
        MCLGridRef object that describes the position of the ListboxItem to be returned.
        
        \return
        Pointer to the ListboxItem at grid reference \a grid_ref.
        
        \exception InvalidRequestException	thrown if \a grid_ref is invalid for this list box.
        */
        public function getItemAtGridReference(grid_ref:MCLGridRef):FlameListboxItem
        {
            // check for invalid grid ref
            if (grid_ref.column >= getColumnCount())
            {
               throw new Error("MultiColumnList::getItemAtGridReference - the column given in the grid reference is out of range.");
            }
            else if (grid_ref.row >= getRowCount())
            {
                throw new Error("MultiColumnList::getItemAtGridReference - the row given in the grid reference is out of range.");
            }
            else
            {
                return d_grid[grid_ref.row].getItem(grid_ref.column);
            }

        }
        
        /*!
        \brief
        return whether ListboxItem \a item is attached to the column at index \a col_idx.
        
        \param item
        Pointer to the ListboxItem to look for.
        
        \param col_idx
        Zero based index of the column that is to be searched.
        
        \return
        - true if \a item is attached to list box column \a col_idx.
        - false if \a item is not attached to list box column \a col_idx.
        
        \exception InvalidRequestException	thrown if \a col_idx is out of range.
        */
        public function isListboxItemInColumn(item:FlameListboxItem, col_idx:uint):Boolean
        {
            // check for invalid index
            if (col_idx >= getColumnCount())
            {
                throw new Error("MultiColumnList::isListboxItemInColumn - the column index given is out of range.");
            }
            else
            {
                for (var i:uint = 0; i < getRowCount(); ++i)
                {
                    if (d_grid[i].getItem(col_idx) == item)
                    {
                        return true;
                    }
                    
                }
                
                // Item was not in the column.
                return false;
            }

        }
        
        
        /*!
        \brief
        return whether ListboxItem \a item is attached to the row at index \a row_idx.
        
        \param item
        Pointer to the ListboxItem to look for.
        
        \param row_idx
        Zero based index of the row that is to be searched.
        
        \return
        - true if \a item is attached to list box row \a row_idx.
        - false if \a item is not attached to list box row \a row_idx.
        
        \exception InvalidRequestException	thrown if \a row_idx is out of range.
        */
        public function isListboxItemInRow(item:FlameListboxItem, row_idx:uint):Boolean
        {
            // check for invalid index
            if (row_idx >= getRowCount())
            {
                throw new Error("MultiColumnList::isListboxItemInRow - the row index given is out of range.");
            }
            else
            {
                for (var i:uint = 0; i < getColumnCount(); ++i)
                {
                    if (d_grid[row_idx].getItem(i) == item)
                    {
                        return true;
                    }
                    
                }
                
                // Item was not in the row.
                return false;
            }
        }
        
        
        /*!
        \brief
        return whether ListboxItem \a item is attached to the list box.
        
        \param item
        Pointer to the ListboxItem to look for.
        
        \return
        - true if \a item is attached to list box.
        - false if \a item is not attached to list box.
        */
        public function isListboxItemInList(item:FlameListboxItem):Boolean
        {
            for (var i:uint = 0; i < getRowCount(); ++i)
            {
                for (var j:uint = 0; j < getColumnCount(); ++j)
                {
                    if (d_grid[i].getItem(j) == item)
                    {
                        return true;
                    }
                    
                }
                
            }
            
            return false;
        }
        
        
        /*!
        \brief
        Return the ListboxItem in column \a col_idx that has the text string \a text.
        
        \param text
        String object containing the text to be searched for.
        
        \param col_idx
        Zero based index of the column to be searched.
        
        \param start_item
        Pointer to the ListboxItem where the exclusive search is to start, or NULL to search from the top of the column.
        
        \return
        Pointer to the first ListboxItem in column \a col_idx, after \a start_item, that has the string \a text.
        
        \exception InvalidRequestException	thrown if \a start_item is not attached to the list box, or if \a col_idx is out of range.
        */
        public function findColumnItemWithText(text:String, col_idx:uint, start_item:FlameListboxItem) : FlameListboxItem
        {
            // ensure column is valid
            if (col_idx >= getColumnCount())
            {
                throw new Error("MultiColumnList::findColumnItemWithText - specified column index is out of range.");
            }
            
            // find start position for search
            var i:uint = (!start_item) ? 0 : getItemRowIndex(start_item) + 1;
            
            for ( ; i < getRowCount(); ++i)
            {
                // does this item match?
                if (d_grid[i][col_idx].getText() == text)
                {
                    return d_grid[i].getItem(col_idx);
                }
                
            }
            
            // no matching item.
            return null;
        }
        
        /*!
        \brief
        Return the ListboxItem in row \a row_idx that has the text string \a text.
        
        \param text
        String object containing the text to be searched for.
        
        \param row_idx
        Zero based index of the row to be searched.
        
        \param start_item
        Pointer to the ListboxItem where the exclusive search is to start, or NULL to search from the start of the row.
        
        \return
        Pointer to the first ListboxItem in row \a row_idx, after \a start_item, that has the string \a text.
        
        \exception InvalidRequestException	thrown if \a start_item is not attached to the list box, or if \a row_idx is out of range.
        */
        public function findRowItemWithText(text:String, row_idx:uint, start_item:FlameListboxItem): FlameListboxItem
        {
            // ensure row is valid
            if (row_idx >= getRowCount())
            {
                throw new Error("MultiColumnList::findRowItemWithText - specified row index is out of range.");
            }
            
            // find start position for search
            var i:uint = (!start_item) ? 0 : getItemColumnIndex(start_item) + 1;
            
            for ( ; i < getColumnCount(); ++i)
            {
                // does this item match?
                if (d_grid[row_idx].getItem(i).getText() == text)
                {
                    return d_grid[row_idx].getItem(i);
                }
                
            }
            
            // no matching item.
            return null;
        }
        
        
        /*!
        \brief
        Return the ListboxItem that has the text string \a text.
        
        \note
        List box searching progresses across the columns in each row.
        
        \param text
        String object containing the text to be searched for.
        
        \param start_item
        Pointer to the ListboxItem where the exclusive search is to start, or NULL to search the whole list box.
        
        \return
        Pointer to the first ListboxItem, after \a start_item, that has the string \a text.
        
        \exception InvalidRequestException	thrown if \a start_item is not attached to the list box.
        */
        public function findListItemWithText(text:String, start_item:FlameListboxItem) : FlameListboxItem
        {
            var startRef:MCLGridRef = new MCLGridRef(0, 0);
            
            // get position of start_item if it's not NULL
            if (start_item)
            {
                startRef = getItemGridReference(start_item);
                ++startRef.column;
            }
            
            // perform the search
            for (var i:uint = startRef.row; i < getRowCount(); ++i)
            {
                for (var j:uint = startRef.column; j < getColumnCount(); ++j)
                {
                    // does this item match?
                    if (d_grid[i].getItem(j).getText() == text)
                    {
                        return d_grid[i].getItem(j);
                    }
                    
                }
                
            }
            
            // No match
            return null;
        }
        
        
        /*!
        \brief
        Return a pointer to the first selected ListboxItem attached to this list box.
        
        \note
        List box searching progresses across the columns in each row.
        
        \return
        Pointer to the first ListboxItem attached to this list box that is selected, or NULL if no item is selected.
        */
        public function getFirstSelectedItem():FlameListboxItem
        {
            return getNextSelected(null);
        }
        
        /*!
        \brief
        Return a pointer to the next selected ListboxItem after \a start_item.
        
        \note
        List box searching progresses across the columns in each row.
        
        \param start_item
        Pointer to the ListboxItem where the exclusive search is to start, or NULL to search the whole list box.
        
        \return
        Pointer to the first selected ListboxItem attached to this list box, after \a start_item, or NULL if no item is selected.
        
        \exception InvalidRequestException	thrown if \a start_item is not attached to the list box.
        */
        public function getNextSelected(start_item:FlameListboxItem):FlameListboxItem
        {
            var startRef:MCLGridRef = new MCLGridRef(0, 0);
            
            // get position of start_item if it's not NULL
            if (start_item)
            {
                startRef = getItemGridReference(start_item);
                if (++startRef.column == getColumnCount())
                {
                    startRef.column = 0;
                    ++startRef.row;
                }
            }
            
            // perform the search
            for (var i:uint = startRef.row; i < getRowCount(); ++i)
            {
                for (var j:uint = startRef.column; j < getColumnCount(); ++j)
                {
                    // does this item match?
                    var item:FlameListboxItem = d_grid[i].getItem(j);
                    
                    if ((item != null) && item.isSelected())
                    {
                        return d_grid[i].getItem(j);
                    }
                    
                }
                
            }
            
            // No match
            return null;
        }
        
        /*!
        \brief
        Return the number of selected ListboxItems attached to this list box.
        
        return
        uint value equal to the number of ListboxItems attached to this list box that are currently selected.
        */
        public function getSelectedCount():uint
        {
            var count:uint = 0;
            
            for (var i:uint = 0; i < getRowCount(); ++i)
            {
                for (var j:uint = 0; j < getColumnCount(); ++j)
                {
                    var item:FlameListboxItem = d_grid[i].getItem(j);
                    
                    if ((item != null) && item.isSelected())
                    {
                        ++count;
                    }
                    
                }
                
            }
            
            return count;
        }
        
        
        /*!
        \brief
        Return whether the ListboxItem at \a grid_ref is selected.
        
        \param grid_ref
        MCLGridRef object describing the grid reference that is to be examined.
        
        \return
        - true if there is a ListboxItem at \a grid_ref and it is selected.
        - false if there is no ListboxItem at \a grid_ref, or if the item is not selected.
        
        \exception InvalidRequestException	thrown if \a grid_ref contains an invalid grid position.
        */
        public function isItemSelected(grid_ref:MCLGridRef):Boolean
        {
            var item:FlameListboxItem = getItemAtGridReference(grid_ref);
            
            if (item)
            {
                return item.isSelected();
            }
            
            // if no item exists here, then it can't be selected.
            return false;
        }
            
        
        
        /*!
        \brief
        Return the ID of the currently set nominated selection column to be used when in one of the NominatedColumn*
        selection modes. There must be at least one column to successfully call this method.
        
        \note
        You should only ever call this when getColumnCount() returns > 0.
        
        \return
        ID code of the nominated selection column.
        */
        public function getNominatedSelectionColumnID():uint
        {
            return getListHeader().getSegmentFromColumn(d_nominatedSelectCol).getID();
        }
        
        
        /*!
        \brief
        Return the index of the currently set nominated selection column to be used when in one of the NominatedColumn*
        selection modes.
        
        \return
        Zero based index of the nominated selection column.
        */
        public function getNominatedSelectionColumn():uint
        {
            return d_nominatedSelectCol;
        }
        
        /*!
        \brief
        Return the index of the currently set nominated selection row to be used when in one of the NominatedRow*
        selection modes.
        
        \return
        Zero based index of the nominated selection column.
        */
        public function getNominatedSelectionRow():uint
        {
            return d_nominatedSelectRow;
        }
        
        
        /*!
        \brief
        Return the currently set selection mode.
        
        \return
        One of the MultiColumnList::SelectionMode enumerated values specifying the current selection mode.
        */
        public function getSelectionMode():uint
        {
            return d_selectMode;
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
        
        
        /*!
        \brief
        Return the ID code assigned to the requested column.
        
        \param col_idx
        Zero based index of the column whos ID code is to be returned.
        
        \return
        Current ID code assigned to the column at the requested index.
        
        \exception InvalidRequestException	thrown if \a col_idx is out of range
        */
        public function getColumnID(col_idx:uint):uint
        {
            return getListHeader().getSegmentFromColumn(col_idx).getID();
        }
        
        
        /*!
        \brief
        Return the ID code assigned to the requested row.
        
        \param row_idx
        Zero based index of the row who's ID code is to be returned.
        
        \return
        Current ID code assigned to the row at the requested index.
        
        \exception InvalidRequestException	thrown if \a row_idx is out of range
        */
        public function getRowID(row_idx:uint):uint
        {
            // check for invalid index
            if (row_idx >= getRowCount())
            {
                throw new Error("MultiColumnList::getRowID - the row index given is out of range.");
            }
            else
            {
                return d_grid[row_idx].d_rowID;
            }
        }
        
        
        /*!
        \brief
        Return the zero based row index of the row with the specified ID.
        
        \param row_id
        ID code of the row who's index is to be returned.
        
        \return
        Zero based row index of the first row who's ID matches \a row_id.
        
        \exception	InvalidRequestException		thrown if no row has the requested ID.
        */
        public function getRowWithID(row_id:uint):uint
        {
            for (var i:uint = 0; i < getRowCount(); ++i)
            {
                if (d_grid[i].d_rowID == row_id)
                {
                    return i;
                }
            }
            
            // No such row found, throw exception
            throw new Error("MultiColumnList::getRowWithID - no row with the requested ID is present.");
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
                var wr:MultiColumnListWindowRenderer = d_windowRenderer as MultiColumnListWindowRenderer;
                return wr.getListRenderArea();
            }
            else
            {
                //return getListRenderArea_impl();
                throw new Error("Listbox::getListRenderArea - This function must be implemented by the window renderer module");
            }
        }
        
        
        /*!
        \brief
        Return a pointer to the vertical scrollbar component widget for this
        MultiColumnList.
        
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
        MultiColumnList.
        
        \return
        Pointer to a Scrollbar object.
        
        \exception UnknownObjectException
        Thrown if the horizontal Scrollbar component does not exist.
        */
        public function getHorzScrollbar() : FlameScrollbar
        {
            return FlameWindowManager.getSingleton().getWindow(
                getName() + HorzScrollbarNameSuffix) as FlameScrollbar;
        }
        
        /*!
        \brief
        Return a pointer to the list header component widget for this
        MultiColumnList.
        
        \return
        Pointer to a ListHeader object.
        
        \exception UnknownObjectException
        Thrown if the list header component does not exist.
        */
        public function getListHeader():FlameListHeader
        {
            return FlameWindowManager.getSingleton().getWindow(
                getName() + ListHeaderNameSuffix) as FlameListHeader;
        }
        
        /*!
        \brief
        Return the sum of all row heights in pixels.
        */
        public function getTotalRowsHeight():Number
        {
            var height:Number = 0.0;
            
            for (var i:uint = 0; i < getRowCount(); ++i)
            {
                height += getHighestRowItemHeight(i);
            }
            
            return height;
        }
        
        /*!
        \brief
        Return the pixel width of the widest item in the given column
        */
        public function getWidestColumnItemWidth(col_idx:uint):Number
        {
            if (col_idx >= getColumnCount())
            {
                throw new Error("MultiColumnList::getWidestColumnItemWidth - specified column is out of range.");
            }
            else
            {
                var width:Number = 0.0;
                
                // check each item in the column
                for (var i:uint = 0; i < getRowCount(); ++i)
                {
                    var item:FlameListboxItem = d_grid[i].getItem(col_idx);
                    
                    // if the slot has an item in it
                    if (item)
                    {
                        var sz:Size = item.getPixelSize();
                        
                        // see if this item is wider than the previous widest
                        if (sz.d_width > width)
                        {
                            // update current widest
                            width = sz.d_width;
                        }
                        
                    }
                    
                }
                
                // return the widest item.
                return width;
            }
        }
        
        /*!
        \brief
        Return, in pixels, the height of the highest item in the given row.
        */
        public function getHighestRowItemHeight(row_idx:uint) :Number
        {
            if (row_idx >= getRowCount())
            {
                throw new Error("MultiColumnList::getHighestRowItemHeight - specified row is out of range.");
            }
            else
            {
                var height:Number = 0.0;
                
                // check each item in the column
                for (var i:uint = 0; i < getColumnCount(); ++i)
                {
                    var item:FlameListboxItem = d_grid[row_idx].getItem(i);
                    
                    // if the slot has an item in it
                    if (item)
                    {
                        var sz:Size = item.getPixelSize();
                        
                        // see if this item is higher than the previous highest
                        if (sz.d_height > height)
                        {
                            // update current highest
                            height = sz.d_height;
                        }
                        
                    }
                    
                }
                
                // return the hightest item.
                return height;
            }
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
            var header:FlameListHeader       = getListHeader();
            
            // subscribe some events
            header.subscribeEvent(FlameListHeader.EventSegmentRenderOffsetChanged, new Subscriber(handleHeaderScroll, this), FlameListHeader.EventNamespace);
            header.subscribeEvent(FlameListHeader.EventSegmentSequenceChanged, new Subscriber(handleHeaderSegMove, this), FlameListHeader.EventNamespace);
            header.subscribeEvent(FlameListHeader.EventSegmentSized, new Subscriber(handleColumnSizeChange, this), FlameListHeader.EventNamespace);
            header.subscribeEvent(FlameListHeader.EventSortColumnChanged , new Subscriber(handleSortColumnChange, this), FlameListHeader.EventNamespace);
            header.subscribeEvent(FlameListHeader.EventSortDirectionChanged, new Subscriber(handleSortDirectionChange, this), FlameListHeader.EventNamespace);
            header.subscribeEvent(FlameListHeader.EventSplitterDoubleClicked, new Subscriber(handleHeaderSegDblClick, this), FlameListHeader.EventNamespace);
            horzScrollbar.subscribeEvent(FlameScrollbar.EventScrollPositionChanged, new Subscriber(handleHorzScrollbar, this), FlameScrollbar.EventNamespace);
            vertScrollbar.subscribeEvent(FlameScrollbar.EventScrollPositionChanged, new Subscriber(handleVertScrollbar, this), FlameScrollbar.EventNamespace);
            
            
            // final initialisation now widget is complete
            setSortDirection(Consts.SortDirection_None);
            
            // Perform initial layout
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
        Add a column to the list box.
        
        \param text
        String object containing the text label for the column header.
        
        \param col_id
        ID code to be assigned to the column header.
        
        \param width
        UDim describing the initial width to be set for the column.
        
        \return
        Nothing.
        */
        public function addColumn(text:String, col_id:uint, width:UDim):void
        {
            insertColumn(text, col_id, width, getColumnCount());
        }
        
        
        /*!
        \brief
        Insert a new column in the list.
        
        \param text
        String object containing the text label for the column header.
        
        \param col_id
        ID code to be assigned to the column header.
        
        \param width
        UDim describing the initial width to be set for the column.
        
        \param position
        Zero based index where the column is to be inserted.  If this is greater than the current
        number of columns, the new column is inserted at the end.
        
        \return
        Nothing.
        */
        public function insertColumn(text:String, col_id:uint, width:UDim, position:uint):void
        {
            // if position is out of range, add item to end of current columns.
            if (position > getColumnCount())
            {
                position = getColumnCount();
            }
            
            // set-up the header for the new column.
            getListHeader().insertColumnAt(text, col_id, width, position);
            ++d_columnCount;
            
            // Set the font equal to that of our list
            for (var col:uint = 0; col < getColumnCount(); col++)
            {
                getHeaderSegmentForColumn(col).setFont(getFont());
            }
            
            // Insert a blank entry at the appropriate position in each row.
            for (var i:uint = 0; i < getRowCount(); ++i)
            {
//                d_grid[i].d_items.insert(
//                    d_grid[i].d_items.begin() + position,
//                    static_cast<ListboxItem*>(0));
                d_grid[i].d_items.splice(position, 0, null);
            }
            
            // update stored nominated selection column if that has changed.
            if ((d_nominatedSelectCol >= position) && (getColumnCount() > 1))
            {
                d_nominatedSelectCol++;
            }
            
            // signal a change to the list contents
            var args:WindowEventArgs = new WindowEventArgs(this);
            onListContentsChanged(args);
        }
        
        
        /*!
        \brief
        Removes a column from the list box.  This will cause any ListboxItem using the autoDelete option in the column to be deleted.
        
        \param col_idx
        Zero based index of the column to be removed.
        
        \return
        Nothing.
        
        \exception InvalidRequestException	thrown if \a col_idx is invalid.
        */
        public function removeColumn(col_idx:uint):void
        {
            // ensure index is valid, and throw if not.
            if (col_idx >= getColumnCount())
            {
                throw new Error("MultiColumnList::removeColumn - the specified column index is out of range.");
            }
            else
            {
                // update stored column index values
                if (d_nominatedSelectCol == col_idx)
                {
                    d_nominatedSelectCol = 0;
                }
                
                // remove the column from each row
                for (var i:uint = 0; i < getRowCount(); ++i)
                {
                    // extract the item pointer.
                    var item:FlameListboxItem = d_grid[i].getItem(col_idx);
                    
                    // remove the column entry from the row
                    //d_grid[i].d_items.erase(d_grid[i].d_items.begin() + col_idx);
                    d_grid[i].d_items.splice(col_idx, 1);
                    
                    // delete the ListboxItem as needed.
                    if ((item != null) && item.isAutoDeleted())
                    {
                        //delete item;
                        item = null;
                    }
                    
                }
                
                // remove header segment
                getListHeader().removeColumn(col_idx);
                --d_columnCount;
                
                // signal a change to the list contents
                var args:WindowEventArgs = new WindowEventArgs(this);
                onListContentsChanged(args);
            }
        }
        
        
        /*!
        \brief
        Removes a column from the list box.  This will cause any ListboxItem using the autoDelete option in the column to be deleted.
        
        \param col_id
        ID code of the column to be deleted.
        
        \return
        Nothing.
        
        \exception InvalidRequestException	thrown if no column with \a col_id is available on this list box.
        */
        public function removeColumnWithID(col_id:uint):void
        {
            removeColumn(getColumnWithID(col_id));
        }
        
        
        /*!
        \brief
        Move the column at index \a col_idx so it is at index \a position.
        
        \param col_idx
        Zero based index of the column to be moved.
        
        \param position
        Zero based index of the new position for the column.
        
        \return
        Nothing.
        
        \exception InvalidRequestException	thrown if \a col_idx is invalid.
        */
        public function moveColumn(col_idx:uint, position:uint):void
        {
            getListHeader().moveColumn(col_idx, position);
        }
        
        
        /*!
        \brief
        Move the column with ID \a col_id so it is at index \a position.
        
        \param col_id
        ID code of the column to be moved.
        
        \param position
        Zero based index of the new position for the column.
        
        \return
        Nothing.
        
        \exception InvalidRequestException	thrown if no column with \a col_id is available on this list box.
        */
        public function moveColumnWithID(col_id:uint, position:uint):void
        {
            moveColumn(getColumnWithID(col_id), position);
        }
        
        
        /*!
        \brief
        Add an empty row to the list box.
        
        \param row_id
        ID code to be assigned to the new row.
        
        \note
        If the list is being sorted, the new row will appear at an appropriate position according to the sorting being
        applied.  If no sorting is being done, the new row will appear at the bottom of the list.
        
        \return
        Initial zero based index of the new row.
        */
        public function addEmptyRow(row_id:uint = 0):uint
        {
            return addRow(null, 0, row_id);
        }
        
        
        /*!
        \brief
        Add a row to the list box, and set the item in the column with ID \a col_id to \a item.
        
        \note
        If the list is being sorted, the new row will appear at an appropriate position according to the sorting being
        applied.  If no sorting is being done, the new row will appear at the bottom of the list.
        
        \param item
        Pointer to a ListboxItem to be used as the initial contents for the column with ID \a col_id.
        
        \param col_id
        ID code of the column whos initial item is to be set to \a item.
        
        \param row_id
        ID code to be assigned to the new row.
        
        \return
        Initial zero based index of the new row.
        
        \exception InvalidRequestException	thrown if no column with the specified ID is attached to the list box.
        */
        public function addRow(item:FlameListboxItem, col_id:uint, row_id:uint = 0):uint
        {
            var col_idx:uint = 0;
            
            // Build the new row
            var row:ListRow = new ListRow();
            row.d_sortColumn = getSortColumn();
            //row.d_items.resize(getColumnCount(), 0);
            row.d_items.length = getColumnCount();
            row.d_rowID = row_id;
            
            if (item)
            {
                // discover which column to initially set
                col_idx = getColumnWithID(col_id);
                
                // establish item ownership & enter item into column
                item.setOwnerWindow(this);
                row[col_idx] = item;
            }
            
            var pos:uint;

            
            // if sorting is enabled, insert at an appropriate position
            const  dir:uint = getSortDirection();
            if (dir != Consts.SortDirection_None)
            {
//                // calculate where the row should be inserted
//                ListItemGrid::iterator ins_pos = dir == ListHeaderSegment::Descending ?
//                    std::upper_bound(d_grid.begin(), d_grid.end(), row, pred_descend) :
//                    std::upper_bound(d_grid.begin(), d_grid.end(), row);
//                // insert item and get final inserted position.
//                ListItemGrid::iterator final_pos = d_grid.insert(ins_pos, row);
//                // get final inserted position as an uint.
//                pos = (uint)std::distance(d_grid.begin(), final_pos);
                
                //to do....
                pos = getRowCount();
                d_grid.push(row);
            }
                // not sorted, just stick it on the end.
            else
            {
                pos = getRowCount();
                d_grid.push(row);
            }
            
            // signal a change to the list contents
            var args:WindowEventArgs = new WindowEventArgs(this);
            onListContentsChanged(args);
            
            return pos;
        }
        
        
        /*!
        \brief
        Insert an empty row into the list box.
        
        \note
        If the list is being sorted, the new row will appear at an appropriate position according to the sorting being
        applied.  If no sorting is being done, the new row will appear at the specified index.
        
        \param row_idx
        Zero based index where the row should be inserted.  If this is greater than the current number of rows, the row is
        appended to the list.
        
        \param row_id
        ID code to be assigned to the new row.
        
        \return
        Zero based index where the row was actually inserted.
        */
        public function insertRowByID(row_idx:uint, row_id:uint = 0):uint
        {
            return insertRow(null, 0, row_idx, row_id);
        }
        
        
        /*!
        \brief
        Insert a row into the list box, and set the item in the column with ID \a col_id to \a item.
        
        \note
        If the list is being sorted, the new row will appear at an appropriate position according to the sorting being
        applied.  If no sorting is being done, the new row will appear at the specified index.
        
        \param item
        Pointer to a ListboxItem to be used as the initial contents for the column with ID \a col_id.
        
        \param col_id
        ID code of the column whos initial item is to be set to \a item.
        
        \param row_idx
        Zero based index where the row should be inserted.  If this is greater than the current number of rows, the row is
        appended to the list.
        
        \param row_id
        ID code to be assigned to the new row.
        
        \return
        Zero based index where the row was actually inserted.
        
        \exception InvalidRequestException	thrown if no column with the specified ID is attached to the list box.
        */
        public function insertRow(item:FlameListboxItem, col_id:uint, row_idx:uint, row_id:uint = 0):uint
        {
            // if sorting is enabled, use add instead of insert
            if (getSortDirection() != Consts.SortDirection_None)
            {
                return addRow(item, col_id, row_id);
            }
            else
            {
                // Build the new row (empty)
                var row:ListRow = new ListRow();
                row.d_sortColumn = getSortColumn();
                row.d_items.length = getColumnCount();
                row.d_rowID = row_id;
                
                // if row index is too big, just insert at end.
                if (row_idx > getRowCount())
                {
                    row_idx = getRowCount();
                }
                
                d_grid.splice(row_idx, 0, row);
                
                // set the initial item in the new row
                setItem(item, col_id, row_idx);
                
                // signal a change to the list contents
                var args:WindowEventArgs = new WindowEventArgs(this);
                onListContentsChanged(args);
                
                return row_idx;
            }
        }
        
        
        /*!
        \brief
        Remove the list box row with index \a row_idx.  Any ListboxItem in row \a row_idx using autoDelete mode will be deleted.
        
        \param row_idx
        Zero based index of the row to be removed.
        
        \return
        Nothing.
        
        \exception InvalidRequestException	thrown if \a row_idx is invalid.
        */
        public function removeRow(row_idx:uint):void
        {
            // ensure row exists
            if (row_idx >= getRowCount())
            {
                throw new Error("MultiColumnList::removeRow - The specified row index is out of range.");
            }
            else
            {
                // delete items we are supposed to
                for (var i:uint = 0; i < getColumnCount(); ++i)
                {
                    var item:FlameListboxItem = d_grid[row_idx].getItem(i);
                    
                    if ((item != null) && item.isAutoDeleted())
                    {
                        item = null;
                    }
                    
                }
                
                // erase the row from the grid.
                d_grid.splice(row_idx, 1);// .erase(d_grid.begin() + row_idx);
                
                // if we have erased the selection row, reset that to 0
                if (d_nominatedSelectRow == row_idx)
                {
                    d_nominatedSelectRow = 0;
                }
                
                // signal a change to the list contents
                var args:WindowEventArgs = new WindowEventArgs(this);
                onListContentsChanged(args);
            }
        }
        
        
        /*!
        \brief
        Set the ListboxItem for grid reference \a position.
        
        \param item
        Pointer to the ListboxItem to be set at \a position.
        
        \param position
        MCLGridRef describing the grid reference of the item to be set.
        
        \return
        Nothing.
        
        \exception InvalidRequestException	thrown if \a position contains an invalid grid reference.
        */
        public function setItemByGridRef(item:FlameListboxItem, position:MCLGridRef):void
        {
            // validate grid ref
            if (position.column >= getColumnCount())
            {
                throw new Error("MultiColumnList::setItem - the specified column index is invalid.");
            }
            else if (position.row >= getRowCount())
            {
                throw new Error("MultiColumnList::setItem - the specified row index is invalid.");
            }
            
            // delete old item as required
            var oldItem:FlameListboxItem = d_grid[position.row].getItem(position.column);
            
            if ((oldItem != null) && oldItem.isAutoDeleted())
            {
                oldItem = null;
            }
            
            // set new item.
            if (item)
                item.setOwnerWindow(this);
            
            //d_grid[position.row].getItem(position.column) = item;
            d_grid[position.row].setItem(position.column, item);
            
            // signal a change to the list contents
            var args:WindowEventArgs = new WindowEventArgs(this);
            onListContentsChanged(args);
        }
        
        
        /*!
        \brief
        Set the ListboxItem for the column with ID \a col_id in row \a row_idx.
        
        \param item
        Pointer to the ListboxItem to be set into the list.
        
        \param col_id
        ID code of the column to receive \a item.
        
        \param row_idx
        Zero based index of the row to receive \a item.
        
        \return
        Nothing.
        
        \exception InvalidRequestException	thrown if no column with ID \a col_id exists, or of \a row_idx is out of range.
        */
        public function setItem(item:FlameListboxItem, col_id:uint, row_idx:uint):void
        {
            setItemByGridRef(item, new MCLGridRef(row_idx, getColumnWithID(col_id)));
        }
        
        
        /*!
        \brief
        Set the selection mode for the list box.
        
        \param sel_mode
        One of the MultiColumnList::SelectionMode enumerated values specifying the selection mode to be used.
        
        \return
        Nothing.
        
        \exception	InvalidRequestException	thrown if the value specified for \a sel_mode is invalid.
        */
        public function setSelectionMode(sel_mode:uint):void
        {
            if (d_selectMode != sel_mode)
            {
                d_selectMode = sel_mode;
                
                clearAllSelections();
                
                switch(d_selectMode)
                {
                    case Consts.SelectionMode_RowSingle:
                        d_multiSelect		= false;
                        d_fullRowSelect		= true;
                        d_fullColSelect		= false;
                        d_useNominatedCol	= false;
                        d_useNominatedRow	= false;
                        break;
                    
                    case Consts.SelectionMode_RowMultiple:
                        d_multiSelect		= true;
                        d_fullRowSelect		= true;
                        d_fullColSelect		= false;
                        d_useNominatedCol	= false;
                        d_useNominatedRow	= false;
                        break;
                    
                    case Consts.SelectionMode_CellSingle:
                        d_multiSelect		= false;
                        d_fullRowSelect		= false;
                        d_fullColSelect		= false;
                        d_useNominatedCol	= false;
                        d_useNominatedRow	= false;
                        break;
                    
                    case Consts.SelectionMode_CellMultiple:
                        d_multiSelect		= true;
                        d_fullRowSelect		= false;
                        d_fullColSelect		= false;
                        d_useNominatedCol	= false;
                        d_useNominatedRow	= false;
                        break;
                    
                    case Consts.SelectionMode_NominatedColumnSingle:
                        d_multiSelect		= false;
                        d_fullRowSelect		= false;
                        d_fullColSelect		= false;
                        d_useNominatedCol	= true;
                        d_useNominatedRow	= false;
                        break;
                    
                    case Consts.SelectionMode_NominatedColumnMultiple:
                        d_multiSelect		= true;
                        d_fullRowSelect		= false;
                        d_fullColSelect		= false;
                        d_useNominatedCol	= true;
                        d_useNominatedRow	= false;
                        break;
                    
                    case Consts.SelectionMode_ColumnSingle:
                        d_multiSelect		= false;
                        d_fullRowSelect		= false;
                        d_fullColSelect		= true;
                        d_useNominatedCol	= false;
                        d_useNominatedRow	= false;
                        break;
                    
                    case Consts.SelectionMode_ColumnMultiple:
                        d_multiSelect		= true;
                        d_fullRowSelect		= false;
                        d_fullColSelect		= true;
                        d_useNominatedCol	= false;
                        d_useNominatedRow	= false;
                        break;
                    
                    case Consts.SelectionMode_NominatedRowSingle:
                        d_multiSelect		= false;
                        d_fullRowSelect		= false;
                        d_fullColSelect		= false;
                        d_useNominatedCol	= false;
                        d_useNominatedRow	= true;
                        break;
                    
                    case Consts.SelectionMode_NominatedRowMultiple:
                        d_multiSelect		= true;
                        d_fullRowSelect		= false;
                        d_fullColSelect		= false;
                        d_useNominatedCol	= false;
                        d_useNominatedRow	= true;
                        break;
                    
                    default:
                        throw new Error("MultiColumnList::setSelectionMode - invalid or unknown SelectionMode value supplied.");
                        break;
                    
                }
                
                // Fire event.
                var args:WindowEventArgs = new WindowEventArgs(this);
                onSelectionModeChanged(args);
            }
        }
        
        
        /*!
        \brief
        Set the column to be used for the NominatedColumn* selection modes.
        
        \param	col_id
        ID code of the column to be used in NominatedColumn* selection modes.
        
        \return
        Nothing.
        
        \exception InvalidRequestException	thrown if no column has ID code \a col_id.
        */
        public function setNominatedSelectionColumnID(col_id:uint):void
        {
            setNominatedSelectionColumn(getColumnWithID(col_id));
        }
        
        
        /*!
        \brief
        Set the column to be used for the NominatedColumn* selection modes.
        
        \param	col_idx
        zero based index of the column to be used in NominatedColumn* selection modes.
        
        \return
        Nothing.
        
        \exception InvalidRequestException	thrown if \a col_idx is out of range.
        */
        public function setNominatedSelectionColumn(col_idx:uint):void
        {
            if (d_nominatedSelectCol != col_idx)
            {
                clearAllSelections();
                
                d_nominatedSelectCol = col_idx;
                
                // Fire event.
                var args:WindowEventArgs = new WindowEventArgs(this);
                onNominatedSelectColumnChanged(args);
            }
        }
        
        
        /*!
        \brief
        Set the row to be used for the NominatedRow* selection modes.
        
        \param	row_idx
        zero based index of the row to be used in NominatedRow* selection modes.
        
        \return
        Nothing.
        
        \exception InvalidRequestException	thrown if \a row_idx is out of range.
        */
        public function setNominatedSelectionRow(row_idx:uint):void
        {
            if (d_nominatedSelectRow != row_idx)
            {
                clearAllSelections();
                
                d_nominatedSelectRow = row_idx;
                
                // Fire event.
                var args:WindowEventArgs = new WindowEventArgs(this);
                onNominatedSelectRowChanged(args);
            }

        }
        
        
        /*!
        \brief
        Set the sort direction to be used.
        
        \param direction
        One of the ListHeaderSegment::SortDirection enumerated values specifying the sort direction to be used.
        
        \return
        Nothing.
        */
        public function setSortDirection(direction:uint):void
        {
            if (getSortDirection() != direction)
            {
                // set the sort direction on the header, events will make sure everything else is updated.
                getListHeader().setSortDirection(direction);
            }
        }
        
        
        /*!
        \brief
        Set the column to be used as the sort key.
        
        \param col_idx
        Zero based index of the column to use as the key when sorting the list items.
        
        \return
        Nothing.
        
        \exception InvalidRequestException	thrown if col_idx is out of range.
        */
        public function setSortColumn(col_idx:uint):void
        {
            if (getSortColumn() != col_idx)
            {
                // set the sort column on the header, events will make sure everything else is updated.
                getListHeader().setSortColumn(col_idx);
            }
        }
        
        
        /*!
        \brief
        Set the column to be used as the sort key.
        
        \param col_id
        ID code of the column to use as the key when sorting the list items.
        
        \return
        Nothing.
        
        \exception InvalidRequestException	thrown if col_id is invalid for this list box.
        */
        public function setSortColumnByID(col_id:uint):void
        {
            var header:FlameListHeader = getListHeader();
            
            if (header.getSegmentFromColumn(getSortColumn()).getID() != col_id)
            {
                // set the sort column on the header, events will make sure everything else is updated.
                header.setSortColumnFromID(col_id);
            }
        }
        
        
        /*!
        \brief
        Set whether the vertical scroll bar should always be shown, or just when needed.
        
        \param setting
        - true to have the vertical scroll bar shown at all times.
        - false to have the vertical scroll bar appear only when needed.
        
        \return
        Nothing.
        */
        public function setShowVertScrollbar(setting:Boolean):void
        {
            if (d_forceVertScroll != setting)
            {
                d_forceVertScroll = setting;
                
                configureScrollbars();
                
                // Event firing.
                var args:WindowEventArgs = new WindowEventArgs(this);
                onVertScrollbarModeChanged(args);
            }
        }
        
        
        /*!
        \brief
        Set whether the horizontal scroll bar should always be shown, or just when needed.
        
        \param setting
        - true to have the horizontal scroll bar shown at all times.
        - false to have the horizontal scroll bar appear only when needed.
        
        \return
        Nothing.
        */
        public function setShowHorzScrollbar(setting:Boolean):void
        {
            if (d_forceHorzScroll != setting)
            {
                d_forceHorzScroll = setting;
                
                configureScrollbars();
                
                // Event firing.
                var args:WindowEventArgs = new WindowEventArgs(this);
                onHorzScrollbarModeChanged(args);
            }
        }
        
        
        /*!
        \brief
        Removed the selected state from any currently selected ListboxItem attached to the list.
        
        \return
        Nothing.
        */
        public function clearAllSelections():void
        {
            // only fire events and update if we actually made any changes
            if (clearAllSelections_impl())
            {
                // Fire event.
                var args:WindowEventArgs = new WindowEventArgs(this);
                onSelectionChanged(args);
            }

        }
        
        
        /*!
        \brief
        Sets or clears the selected state of the given ListboxItem which must be attached to the list.
        
        \note
        Depending upon the current selection mode, this may cause other items to be selected, other
        items to be deselected, or for nothing to actually happen at all.
        
        \param item
        Pointer to the attached ListboxItem to be affected.
        
        \param state
        - true to put the ListboxItem into the selected state.
        - false to put the ListboxItem into the de-selected state.
        
        \return
        Nothing.
        
        \exception InvalidRequestException	thrown if \a item is not attached to the list box.
        */
        public function setItemSelectState(item:FlameListboxItem, state:Boolean):void
        {
            setItemSelectStateByGridRef(getItemGridReference(item), state);
        }
        
        
        /*!
        \brief
        Sets or clears the selected state of the ListboxItem at the given grid reference.
        
        \note
        Depending upon the current selection mode, this may cause other items to be selected, other
        items to be deselected, or for nothing to actually happen at all.
        
        \param grid_ref
        MCLGridRef object describing the position of the item to be affected.
        
        \param state
        - true to put the ListboxItem into the selected state.
        - false to put the ListboxItem into the de-selected state.
        
        \return
        Nothing.
        
        \exception InvalidRequestException	thrown if \a grid_ref is invalid for this list box.
        */
        public function setItemSelectStateByGridRef(grid_ref:MCLGridRef, state:Boolean):void
        {
            if (setItemSelectState_impl(grid_ref, state))
            {
                // Fire event.
                var args:WindowEventArgs = new WindowEventArgs(this);
                onSelectionChanged(args);
            }

        }
        
        
        /*!
        \brief
        Inform the list box that one or more attached ListboxItems have been externally modified, and
        the list should re-sync its internal state and refresh the display as needed.
        
        \return
        Nothing.
        */
        public function handleUpdatedItemData():void
        {
            resortList();
            configureScrollbars();
            invalidate();
        }
        
        
        /*!
        \brief
        Set the width of the specified column header (and therefore the column itself).
        
        \param col_idx
        Zero based column index of the column whos width is to be set.
        
        \param width
        UDim value specifying the new width for the column.
        
        \return
        Nothing.
        
        \exception InvalidRequestException	thrown if \a column is out of range.
        */
        public function setColumnHeaderWidth(col_idx:uint, width:UDim):void
        {
            getListHeader().setColumnWidth(col_idx, width);
        }
        
        
        /*!
        \brief
        Set whether user manipulation of the sort column and direction are enabled.
        
        \param setting
        - true if the user may interactively modify the sort column and direction.
        - false if the user may not modify the sort column and direction (these can still be set programmatically).
        
        \return
        Nothing.
        */
        public function setUserSortControlEnabled(setting:Boolean):void
        {
            getListHeader().setSortingEnabled(setting);
        }
        
        
        /*!
        \brief
        Set whether the user may size column segments.
        
        \param setting
        - true if the user may interactively modify the width of columns.
        - false if the user may not change the width of the columns.
        
        \return
        Nothing.
        */
        public function setUserColumnSizingEnabled(setting:Boolean):void
        {
            getListHeader().setColumnSizingEnabled(setting);
        }
        
        
        /*!
        \brief
        Set whether the user may modify the order of the columns.
        
        \param setting
        - true if the user may interactively modify the order of the columns.
        - false if the user may not modify the order of the columns.
        */
        public function setUserColumnDraggingEnabled(setting:Boolean):void
        {
            getListHeader().setColumnDraggingEnabled(setting);
        }
        
        
        /*!
        \brief
        Automatically determines the "best fit" size for the specified column and sets
        the column width to the same.
        
        \param col_idx
        Zero based index of the column to be sized.
        
        \return
        Nothing.
        
        \exception InvalidRequestException	thrown if \a col_idx is out of range.
        */
        public function autoSizeColumnHeader(col_idx:uint):void
        {
            // check for invalid index
            if (col_idx >= getColumnCount())
            {
                throw new Error("MultiColumnList::isListboxItemInColumn - the column index given is out of range.");
            }
            else
            {
                // get the width of the widest item in the column.
                var width:Number = Math.max(getWidestColumnItemWidth(col_idx), FlameListHeader.MinimumSegmentPixelWidth);
                
                // set new column width
                setColumnHeaderWidth(col_idx, Misc.cegui_absdim(width));
            }
        }
        
        
        /*!
        \brief
        Set the ID code assigned to a given row.
        
        \param row_idx
        Zero based index of the row who's ID code is to be set.
        
        \param row_id
        ID code to be assigned to the row at the requested index.
        
        \return
        Nothing.
        
        \exception InvalidRequestException	thrown if \a row_idx is out of range
        */
        public function setRowID(row_idx:uint, row_id:uint):void
        {
            // check for invalid index
            if (row_idx >= getRowCount())
            {
                throw new Error("MultiColumnList::setRowID - the row index given is out of range.");
            }
            else
            {
                d_grid[row_idx].d_rowID = row_id;
            }
        }
        
        
        /*************************************************************************
         Implementation Functions (abstract interface)
         *************************************************************************/
        /*!
        \brief
        Return a Rect object describing, in un-clipped pixels, the window relative area
        that is to be used for rendering list items.
        
        \return
        Rect object describing the area of the Window to be used for rendering
        list box items.
        */
        //virtual	Rect	getListRenderArea_impl(void) const		= 0;
        
        
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
            var totalHeight:Number	= getTotalRowsHeight();
            var fullWidth:Number		= getListHeader().getTotalSegmentsPixelExtent();
            
            //
            // First show or hide the scroll bars as needed (or requested)
            //
            // show or hide vertical scroll bar as required (or as specified by option)
            if ((totalHeight > getListRenderArea().getHeight()) || d_forceVertScroll)
            {
                vertScrollbar.show();
                
                // show or hide horizontal scroll bar as required (or as specified by option)
                if ((fullWidth > getListRenderArea().getWidth()) || d_forceHorzScroll)
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
                if ((fullWidth > getListRenderArea().getWidth()) || d_forceHorzScroll)
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
            
            horzScrollbar.setDocumentSize(fullWidth);
            horzScrollbar.setPageSize(renderArea.getWidth());
            horzScrollbar.setStepSize(Math.max(1.0, renderArea.getWidth() / 10.0));
            horzScrollbar.setScrollPosition(horzScrollbar.getScrollPosition());
        }
        
        
        /*!
        \brief
        select all strings between positions \a start and \a end.  (inclusive).  Returns true if something was modified.
        */
        protected function selectRange(start:MCLGridRef, end:MCLGridRef):Boolean
        {
            var tmpStart:MCLGridRef = start;
            var tmpEnd:MCLGridRef = end;
            
            // ensure start is before end
            if (tmpStart.column > tmpEnd.column)
            {
                tmpStart.column = tmpEnd.column;
                tmpEnd.column = start.column;
            }
            
            if (tmpStart.row > tmpEnd.row)
            {
                tmpStart.row = tmpEnd.row;
                tmpEnd.row = start.row;
            }
            
            var modified:Boolean = false;
            
            // loop through all items selecting them.
            for (var i:uint = tmpStart.row; i <= tmpEnd.row; ++i)
            {
                for (var j:uint = tmpStart.column; j <= tmpEnd.column; ++j)
                {
                    var item:FlameListboxItem = d_grid[i].getItem(j);
                    
                    if (item)
                    {
                        var res:Boolean = setItemSelectState_impl(getItemGridReference(item), true);
                        if(res) modified = true;
                    }
                    
                }
                
            }
            
            return modified;   
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
            
            for (var i:uint = 0; i < getRowCount(); ++i)
            {
                for (var j:uint = 0; j < getColumnCount(); ++j)
                {
                   var item:FlameListboxItem = d_grid[i].getItem(j);
                    
                    // if slot has an item, and item is selected
                    if ((item != null) && item.isSelected())
                    {
                        // clear selection state and set modified flag
                        item.setSelected(false);
                        modified = true;
                    }
                    
                }
                
            }
            
            // signal whether or not we did anything.
            return modified;
        }
        
        
        /*!
        \brief
        Return the ListboxItem under the given window local pixel co-ordinate.
        
        \return
        ListboxItem that is under window pixel co-ordinate \a pt, or NULL if no
        item is under that position.
        */
        protected function getItemAtPoint(pt:Vector2):FlameListboxItem
        {
            const header:FlameListHeader = getListHeader();
            var listArea:Rect = getListRenderArea();
            
            var y:Number = listArea.d_top - getVertScrollbar().getScrollPosition();
            var x:Number = listArea.d_left - getHorzScrollbar().getScrollPosition();
            
            for (var i:uint = 0; i < getRowCount(); ++i)
            {
                y += getHighestRowItemHeight(i);
                
                // have we located the row?
                if (pt.d_y < y)
                {
                    // scan across to find column that was clicked
                    for (var j:uint = 0; j < getColumnCount(); ++j)
                    {
                        const seg:FlameListHeaderSegment = header.getSegmentFromColumn(j);
                        x += seg.getWidth().asAbsolute(header.getPixelSize().d_width);
                        
                        // was this the column?
                        if (pt.d_x < x)
                        {
                            // return contents of grid element that was clicked.
                            return d_grid[i].getItem(j);
                        }
                        
                    }
                    
                }
                
            }
            
            return null;
        }
        
        /*!
        \brief
        Set select state for the given item.  This appropriately selects other
        items depending upon the select mode.  Returns true if something is
        changed, else false.
        */
        protected function setItemSelectState_impl(grid_ref:MCLGridRef, state:Boolean):Boolean
        {
            // validate grid ref
            if (grid_ref.column >= getColumnCount())
            {
                throw new Error("MultiColumnList::setItemSelectState - the specified column index is invalid.");
            }
            else if (grid_ref.row >= getRowCount())
            {
                throw new Error("MultiColumnList::setItemSelectState - the specified row index is invalid.");
            }
            
            // only do this if the setting is changing
            if (d_grid[grid_ref.row].getItem(grid_ref.column).isSelected() != state)
            {
                // if using nominated selection row and/ or column, check that they match.
                if ((!d_useNominatedCol || (d_nominatedSelectCol == grid_ref.column)) &&
                    (!d_useNominatedRow || (d_nominatedSelectRow == grid_ref.row)))
                {
                    // clear current selection if not multi-select box
                    if (state && (!d_multiSelect))
                    {
                        clearAllSelections_impl();
                    }
                    
                    // full row?
                    if (d_fullRowSelect)
                    {
                        // clear selection on all items in the row
                        setSelectForItemsInRow(grid_ref.row, state);
                    }
                        // full column?
                    else if (d_fullColSelect)
                    {
                        // clear selection on all items in the column
                        setSelectForItemsInColumn(grid_ref.column, state);
                        
                    }
                        // single item to be affected
                    else
                    {
                        d_grid[grid_ref.row].getItem(grid_ref.column).setSelected(state);
                    }
                    
                    return true;
                }
                
            }
            
            return false;
        }
        
        
        /*!
        \brief
        Set select state for all items in the given row
        */
        protected function setSelectForItemsInRow(row_idx:uint, state:Boolean):void
        {
            for (var i:uint = 0; i < getColumnCount(); ++i)
            {
                var item:FlameListboxItem = d_grid[row_idx].getItem(i);
                
                if (item)
                {
                    item.setSelected(state);
                }
                
            }
        }
        
        
        /*!
        \brief
        Set select state for all items in the given column
        */
        protected function setSelectForItemsInColumn(col_idx:uint, state:Boolean):void
        {
            for (var i:uint = 0; i < getRowCount(); ++i)
            {
                var item:FlameListboxItem = d_grid[i].getItem(col_idx);
                
                if (item)
                {
                    item.setSelected(state);
                }
                
            }

        }
        
        
        /*!
        \brief
        Move the column at index \a col_idx so it is at index \a position.  Implementation version which does not move the
        header segment (since that may have already happened).
        
        \exception InvalidRequestException	thrown if \a col_idx is invalid.
        */
        public function moveColumn_impl(col_idx:uint, position:uint):void
        {
            // ensure index is valid, and throw if not.
            if (col_idx >= getColumnCount())
            {
                throw new Error("MultiColumnList::moveColumn - the specified source column index is out of range.");
            }
            else
            {
                // if position is too big, insert at end.
                if (position > getColumnCount())
                {
                    position = getColumnCount();
                }
                
                // update select column index value if needed
                if (d_nominatedSelectCol == col_idx)
                {
                    d_nominatedSelectCol = position;
                }
                else if ((col_idx < d_nominatedSelectCol) && (position >= d_nominatedSelectCol))
                {
                    d_nominatedSelectCol--;
                }
                else if ((col_idx > d_nominatedSelectCol) && (position <= d_nominatedSelectCol))
                {
                    d_nominatedSelectCol++;
                }
                
                // move column entry in each row.
                for (var i:uint = 0; i < getRowCount(); ++i)
                {
                    // store entry.
                    var item:FlameListboxItem = d_grid[i].getItem(col_idx);
                    
                    // remove the original column for this row.
                    //d_grid[i].d_items.erase(d_grid[i].d_items.begin() + col_idx);
                    d_grid[i].d_items.splice(col_idx, 1);
                    
                    // insert entry at its new position
                    //d_grid[i].d_items.insert(d_grid[i].d_items.begin() + position, item);
                    d_grid[i].d_items.splice(position, 0, item);
                }
                
            }

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
        public function resetList_impl():Boolean
        {
            // just return false if the list is already empty (no rows == empty)
            if (getRowCount() == 0)
            {
                return false;
            }
                // we have items to be removed and possible deleted
            else
            {
                for (var i:uint = 0; i < getRowCount(); ++i)
                {
                    for (var j:uint = 0; j < getColumnCount(); ++j)
                    {
                        var item:FlameListboxItem = d_grid[i].getItem(j);
                        
                        // delete item as needed.
                        if ((item != null) && item.isAutoDeleted())
                        {
                            item = null;
                        }
                        
                    }
                    
                }
                
                // clear all items from the grid.
                d_grid.length = 0;
                
                // reset other affected fields
                d_nominatedSelectRow = 0;
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
        override protected function testClassName_impl(class_name:String) : Boolean
        {
            if (class_name=="MultiColumnList")	return true;
            return super.testClassName_impl(class_name);
        }
        
        
        // overrides function in base class.
        protected function validateWindowRenderer(name:String):Boolean
        {
            return (name == "MultiColumnList");
        }
        
      
        /*!
        \brief
        Causes the internal list to be (re)sorted.
        */
        protected function resortList():void
        {
            // re-sort list according to direction
            var dir:uint = getSortDirection();
            
            if (dir == Consts.SortDirection_Descending)
            {
                d_grid.sort(pred_descend);
                //std::sort(d_grid.begin(), d_grid.end(), pred_descend);
                
            }
            else if (dir == Consts.SortDirection_Ascending)
            {
                d_grid.sort(pred_ascend);
                //std::sort(d_grid.begin(), d_grid.end());
            }
            // else no (or invalid) direction, so do not sort.
        }
        
        /*************************************************************************
         New event handlers for multi column list
         *************************************************************************/
        /*!
        \brief
        Handler called when the selection mode of the list box changes
        */
        protected function onSelectionModeChanged(e:WindowEventArgs):void
        {
            fireEvent(EventSelectionModeChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the nominated selection column changes
        */
        protected function onNominatedSelectColumnChanged(e:WindowEventArgs):void
        {
            fireEvent(EventNominatedSelectColumnChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the nominated selection row changes.
        */
        protected function onNominatedSelectRowChanged(e:WindowEventArgs):void
        {
            fireEvent(EventNominatedSelectRowChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the vertical scroll bar 'force' mode is changed.
        */
        protected function onVertScrollbarModeChanged(e:WindowEventArgs):void
        {
            
        }
        
        
        /*!
        \brief
        Handler called when the horizontal scroll bar 'force' mode is changed.
        */
        protected function onHorzScrollbarModeChanged(e:WindowEventArgs):void
        {
            fireEvent(EventVertScrollbarModeChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the current selection changes.
        */
        protected function onSelectionChanged(e:WindowEventArgs):void
        {
            
            invalidate();
            fireEvent(EventSelectionChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the list contents is changed.
        */
        protected function onListContentsChanged(e:WindowEventArgs):void
        {
            configureScrollbars();
            invalidate();
            fireEvent(EventListContentsChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the sort column changes.
        */
        protected function onSortColumnChanged(e:WindowEventArgs):void
        {
            invalidate();
            fireEvent(EventSortColumnChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the sort direction changes.
        */
        protected function onSortDirectionChanged(e:WindowEventArgs):void
        {
            invalidate();
            fireEvent(EventSortDirectionChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when a column is sized.
        */
        protected function onListColumnSized(e:WindowEventArgs):void
        {
            configureScrollbars();
            invalidate();
            fireEvent(EventListColumnSized, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the column order is changed.
        */
        protected function onListColumnMoved(e:WindowEventArgs):void
        {
            invalidate();
            fireEvent(EventListColumnMoved, e, EventNamespace);
        }
        
        /*************************************************************************
         Overridden Event handlers
         *************************************************************************/
        override protected function onFontChanged(e:WindowEventArgs):void
        {
            // Propagate to children
            // Set the font equal to that of our list
            for (var col:uint = 0; col < getColumnCount(); col++)
            {
                getHeaderSegmentForColumn(col).setFont(getFont());
            }
            
            // Call base class handler
            super.onFontChanged(e);
        }
        
        
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
                
                var localPos:Vector2 = CoordConverter.screenToWindowForVector2(this, e.position);
                var item:FlameListboxItem = getItemAtPoint(localPos);
                
                if (item)
                {
                    // clear old selections if no control key is pressed or if multi-select is off
                    if (!(e.sysKeys & Consts.SystemKey_Control) || !d_multiSelect)
                    {
                        modified = clearAllSelections_impl();
                    }
                    
                    modified = true;
                    var res:Boolean;
                    // select range or item, depending upon keys and last selected item
                    if (((e.sysKeys & Consts.SystemKey_Shift) && (d_lastSelected != null)) && d_multiSelect)
                    {
                        res = selectRange(getItemGridReference(item), getItemGridReference(d_lastSelected));
                        if(res) modified = true;
                    }
                    else
                    {
                        res = setItemSelectState_impl(getItemGridReference(item), !item.isSelected() );
                        if(res) modified = true;
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
        
        
        /*************************************************************************
         Handlers for subscribed events
         *************************************************************************/
        protected function handleHeaderScroll(e:EventArgs):Boolean
        {
            // grab the header scroll value, convert to pixels, and set the scroll bar to match.
            getHorzScrollbar().setScrollPosition(getListHeader().getSegmentOffset());
            
            return true;
        }
        
        protected function handleHeaderSegMove(e:EventArgs):Boolean
        {
            moveColumn_impl((e as HeaderSequenceEventArgs).d_oldIdx, (e as HeaderSequenceEventArgs).d_newIdx);
            
            // signal change to our clients
            var args:WindowEventArgs = new WindowEventArgs(this);
            onListColumnMoved(args);
            
            return true;
        }
        
        
        protected function handleColumnSizeChange(e:EventArgs):Boolean
        {
            configureScrollbars();
            
            // signal change to our clients
            var args:WindowEventArgs = new WindowEventArgs(this);
            onListColumnSized(args);
            
            return true;
        }
        
        protected function handleHorzScrollbar(e:EventArgs):Boolean
        {
            // set header offset to match scroll position
            getListHeader().setSegmentOffset(getHorzScrollbar().getScrollPosition());
            invalidate();
            return true;
        }
        
        protected function handleVertScrollbar(e:EventArgs):Boolean
        {
            invalidate();
            return true;   
        }
        
        protected function handleSortColumnChange(e:EventArgs):Boolean
        {
            
            var col:uint = getSortColumn();
            
            // set new sort column on all rows
            for (var i:uint = 0; i < getRowCount(); ++i)
            {
                d_grid[i].d_sortColumn = col;
            }
            
            resortList();
            
            // signal change to our clients
            var args:WindowEventArgs = new WindowEventArgs(this);
            onSortColumnChanged(args);
            
            return true;
        }
        
        
        protected function handleSortDirectionChange(e:EventArgs):Boolean
        {
            resortList();
            // signal change to our clients
            var args:WindowEventArgs = new WindowEventArgs(this);
            onSortDirectionChanged(args);
            
            return true;
        }
        
        
        protected function handleHeaderSegDblClick(e:EventArgs):Boolean
        {
            // get the column index for the segment that was double-clicked
            var col:uint = getListHeader().getColumnFromSegment((e as WindowEventArgs).window as FlameListHeaderSegment);
            
            autoSizeColumnHeader(col);
            
            return true;
        }
        
        
        /*!
        \brief
        std algorithm predicate used for sorting in descending order
        */
        protected static function pred_descend(a:ListRow, b:ListRow):int
        {
            return a.greaterThan(b) ? 1 : -1;      
        }
        
        /*!
        \brief
        std algorithm predicate used for sorting in descending order
        */
        protected static function pred_ascend(a:ListRow, b:ListRow):int
        {
            return a.lessThan(b) ? 1 : -1;      
        }
        
        /*************************************************************************
         Private methods
         *************************************************************************/
        private function addMultiColumnListProperties():void
        {
            addProperty(d_columnsSizableProperty);
            addProperty(d_columnsMovableProperty);
            addProperty(d_forceHorzScrollProperty);
            addProperty(d_forceVertScrollProperty);
            addProperty(d_nominatedSelectColProperty);
            addProperty(d_nominatedSelectRowProperty);
            addProperty(d_selectModeProperty);
            addProperty(d_sortColumnIDProperty);
            addProperty(d_sortDirectionProperty);
            addProperty(d_sortSettingProperty);
            addProperty(d_columnHeaderProperty);
            addProperty(d_rowCountProperty);
        }

    }
}