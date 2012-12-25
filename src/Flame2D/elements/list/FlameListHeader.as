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
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.system.FlameEventManager;
    import Flame2D.core.system.FlameMouseCursor;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.utils.CoordConverter;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.UDim;
    import Flame2D.core.utils.UVector2;
    import Flame2D.core.utils.Vector2;
    
    public class FlameListHeader extends FlameWindow
    {
        public static const EventNamespace:String = "ListHeader";
        public static const WidgetTypeName:String = "CEGUI/ListHeader";
        
        
        
        /*************************************************************************
         Constants
         *************************************************************************/
        // Event names
        /** Event fired when the current sort column of the header is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ListHeader whose sort column has
         * been changed.
         */
        public static const EventSortColumnChanged:String = "SortColumnChanged";
        /** Event fired when the sort direction of the header is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ListHeader whose sort direction had
         * been changed.
         */
        public static const EventSortDirectionChanged:String = "SortDirectionChanged";
        /** Event fired when a segment of the header is sized by the user.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ListHeaderSegment that has been sized.
         */
        public static const EventSegmentSized:String = "SegmentSized";
        /** Event fired when a segment of the header is clicked by the user.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ListHeaderSegment that was clicked.
         */
        public static const EventSegmentClicked:String = "SegmentClicked";
        /** Event fired when a segment splitter of the header is double-clicked.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ListHeaderSegment whose splitter area
         * was double-clicked.
         */
        public static const EventSplitterDoubleClicked:String = "SplitterDoubleClicked";
        /** Event fired when the order of the segments in the header has changed.
         * Handlers are passed a const HeaderSequenceEventArgs reference with
         * WindowEventArgs::window set to the ListHeader whose segments have changed
         * sequence, HeaderSequenceEventArgs::d_oldIdx is the original index of the
         * segment that has moved, and HeaderSequenceEventArgs::d_newIdx is the new
         * index of the segment that has moved.
         */
        public static const EventSegmentSequenceChanged:String = "SegmentSequenceChanged";
        /** Event fired when a segment is added to the header.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ListHeader that has had a new segment
         * added.
         */
        public static const EventSegmentAdded:String = "SegmentAdded";
        /** Event fired when a segment is removed from the header.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ListHeader that has had a segment
         * removed.
         */
        public static const EventSegmentRemoved:String = "SegmentRemoved";
        /** Event fired when setting that controls user modification to sort
         * configuration is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ListHeader whose user sort control
         * setting has been changed.
         */
        public static const EventSortSettingChanged:String = "SortSettingChanged";
        /** Event fired when setting that controls user drag & drop of segments is
         * changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ListHeader whose drag & drop enabled
         * setting has changed.
         */
        public static const EventDragMoveSettingChanged:String = "DragMoveSettingChanged";
        /** Event fired when setting that controls user sizing of segments is
         * changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ListHeader whose user sizing setting
         * has changed.
         */
        public static const EventDragSizeSettingChanged:String = "DragSizeSettingChanged";
        /** Event fired when the rendering offset for the segments changes.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ListHeader whose segment rendering
         * offset has changed.
         */
        public static const EventSegmentRenderOffsetChanged:String = "SegmentOffsetChanged";
        
        // values
        public static const ScrollSpeed:Number = 8.0;				//!< Speed to scroll at when dragging outside header.
        public static const MinimumSegmentPixelWidth:Number = 20.0;	//!< Miniumum width of a segment in pixels.
        
        /*************************************************************************
         Child Widget name suffix constants
         *************************************************************************/
        public static const SegmentNameSuffix:String = "__auto_seg_";          //!< Widget name suffix for header segments.

        
        /*************************************************************************
         Static Properties for this class
         *************************************************************************/
        private static var d_sortSettingProperty:ListHeaderPropertySortSettingEnabled = new ListHeaderPropertySortSettingEnabled();
        private static var d_sizableProperty:ListHeaderPropertyColumnsSizable = new ListHeaderPropertyColumnsSizable();
        private static var d_movableProperty:ListHeaderPropertyColumnsMovable = new ListHeaderPropertyColumnsMovable();
        private static var d_sortColumnIDProperty:ListHeaderPropertySortColumnID = new ListHeaderPropertySortColumnID();
        private static var d_sortDirectionProperty:ListHeaderPropertySortDirection = new ListHeaderPropertySortDirection();

        
        /*************************************************************************
         Implementation Data
         *************************************************************************/
        //typedef	std::vector<ListHeaderSegment*>		SegmentList;
        protected var d_segments:Vector.<FlameListHeaderSegment> = new Vector.<FlameListHeaderSegment>();			//!< Attached segment windows in header order.
        protected var d_sortSegment:FlameListHeaderSegment = null;	//!< Pointer to the segment that is currently set as the sork-key,
        protected var d_sizingEnabled:Boolean = true;		//!< true if segments can be sized by the user.
        protected var d_sortingEnabled:Boolean = true;		//!< true if the sort criteria modifications by user are enabled (no sorting is actuall done)
        protected var d_movingEnabled:Boolean = true;		//!< true if drag & drop moving of columns / segments is enabled.
        protected var d_uniqueIDNumber:uint = 0;		//!< field used to create unique names.
        protected var d_segmentOffset:Number = 0.0;		//!< Base offset used to layout the segments (allows scrolling within the window area)
        protected var d_sortDir:uint = Consts.SortDirection_None;		//!< Brief copy of the current sort direction.
        
        
        public function FlameListHeader(type:String, name:String)
        {
            super(type, name);
            
            addHeaderProperties();
        }
        
        
        
        
        /*************************************************************************
         Accessor Methods
         *************************************************************************/
        /*!
        \brief
        Return the number of columns or segments attached to the header.
        
        \return
        uint value equal to the number of columns / segments currently in the header.
        */
        public function getColumnCount():uint
        {
            return d_segments.length;
        }
        
        
        /*!
        \brief
        Return the ListHeaderSegment object for the specified column
        
        \param column
        zero based column index of the ListHeaderSegment to be returned.
        
        \return
        ListHeaderSegment object at the requested index.
        
        \exception InvalidRequestException	thrown if column is out of range.
        */
        public function getSegmentFromColumn(column:uint):FlameListHeaderSegment
        {
            if (column >= getColumnCount())
            {
                throw new Error("ListHeader::getSegmentFromColumn - requested column index is out of range for this ListHeader.");
            }
            else
            {
                return d_segments[column];
            }
        }
        
        
        /*!
        \brief
        Return the ListHeaderSegment object with the specified ID.
        
        \param id
        id code of the ListHeaderSegment to be returned.
        
        \return
        ListHeaderSegment object with the ID \a id.  If more than one segment has the same ID, only the first one will
        ever be returned.
        
        \exception	InvalidRequestException		thrown if no segment with the requested ID is attached.
        */
        public function getSegmentFromID(id:uint):FlameListHeaderSegment
        {
            for (var i:uint = 0; i < getColumnCount(); ++i)
            {
                if (d_segments[i].getID() == id)
                {
                    return d_segments[i];
                }
                
            }
            
            // No such segment found, throw exception
            throw new Error("ListHeader::getSegmentFromID - no segment with the requested ID is attached to this ListHeader.");
        }
        
        
        /*!
        \brief
        Return the ListHeaderSegment that is marked as being the 'sort key' segment.  There must be at least one segment
        to successfully call this method.
        
        \return
        ListHeaderSegment object which is the sort-key segment.
        
        \exception	InvalidRequestException		thrown if no segments are attached to the ListHeader.
        */
        public function getSortSegment():FlameListHeaderSegment
        {
            if (!d_sortSegment)
            {
                throw new Error("ListHeader::getSortSegment - Sort segment was invalid!  (No segments are attached to the ListHeader?)");
            }
            else
            {
                return d_sortSegment;
            }
        }
        
        
        /*!
        \brief
        Return the zero based column index of the specified segment.
        
        \param segment
        ListHeaderSegment whos zero based index is to be returned.
        
        \return
        Zero based column index of the ListHeaderSegment \a segment.
        
        \exception	InvalidRequestException		thrown if \a segment is not attached to this ListHeader.
        */
        public function getColumnFromSegment(segment:FlameListHeaderSegment):uint
        {
            for (var i:uint = 0; i < getColumnCount(); ++i)
            {
                if (d_segments[i] == segment)
                {
                    return i;
                }
                
            }
            
            // No such segment found, throw exception
            throw new Error("ListHeader::getColumnFromSegment - the given ListHeaderSegment is not attached to this ListHeader.");
        }
        
        
        /*!
        \brief
        Return the zero based column index of the segment with the specified ID.
        
        \param id
        ID code of the segment whos column index is to be returned.
        
        \return
        Zero based column index of the first ListHeaderSegment whos ID matches \a id.
        
        \exception	InvalidRequestException		thrown if no attached segment has the requested ID.
        */
        public function getColumnFromID(id:uint):uint
        {
            for (var i:uint = 0; i < getColumnCount(); ++i)
            {
                if (d_segments[i].getID() == id)
                {
                    return i;
                }
                
            }
            
            // No such segment found, throw exception
            throw new Error("ListHeader::getColumnFromID - no column with the requested ID is available on this ListHeader.");
        }
        
        
        /*!
        \brief
        Return the zero based index of the current sort column.  There must be at least one segment/column to successfully call this
        method.
        
        \return
        Zero based column index that is the current sort column.
        
        \exception	InvalidRequestException		thrown if there are no segments / columns in this ListHeader.
        */
        public function getSortColumn():uint
        {
            return getColumnFromSegment(getSortSegment());
        }
        
        
        /*!
        \brief
        Return the zero based column index of the segment with the specified text.
        
        \param text
        String object containing the text to be searched for.
        
        \return
        Zero based column index of the segment with the specified text.
        
        \exception InvalidRequestException	thrown if no attached segments have the requested text.
        */
        public function getColumnWithText(text:String):uint
        {
            for (var i:uint = 0; i < getColumnCount(); ++i)
            {
                if (d_segments[i].getText() == text)
                {
                    return i;
                }
                
            }
            
            // No such segment found, throw exception
            throw new Error("ListHeader::getColumnWithText - no column with the text '" + text + "' is attached to this ListHeader.");
        }
        
        
        /*!
        \brief
        Return the pixel offset to the given ListHeaderSegment.
        
        \param segment
        ListHeaderSegment object that the offset to is to be returned.
        
        \return
        The number of pixels up-to the begining of the ListHeaderSegment described by \a segment.
        
        \exception InvalidRequestException	thrown if \a segment is not attached to the ListHeader.
        */
        public function getPixelOffsetToSegment(segment:FlameListHeaderSegment):Number
        {
            var offset:Number = 0.0;
            
            for (var i:uint = 0; i < getColumnCount(); ++i)
            {
                if (d_segments[i] == segment)
                {
                    return offset;
                }
                
                offset += d_segments[i].getPixelSize().d_width;
            }
            
            // No such segment found, throw exception
            throw new Error("ListHeader::getPixelOffsetToSegment - the given ListHeaderSegment is not attached to this ListHeader.");
        }
        
        
        /*!
        \brief
        Return the pixel offset to the ListHeaderSegment at the given zero based column index.
        
        \param column
        Zero based column index of the ListHeaderSegment whos pixel offset it to be returned.
        
        \return
        The number of pixels up-to the begining of the ListHeaderSegment located at zero based column
        index \a column.
        
        \exception InvalidRequestException	thrown if \a column is out of range.
        */
        public function getPixelOffsetToColumn(column:uint):Number
        {
            if (column >= getColumnCount())
            {
                throw new Error("ListHeader::getPixelOffsetToColumn - requested column index is out of range for this ListHeader.");
            }
            else
            {
                var offset:Number = 0.0;
                
                for (var i:uint = 0; i < column; ++i)
                {
                    offset += d_segments[i].getPixelSize().d_width;
                }
                
                return offset;
            }
        }
        
        
        /*!
        \brief
        Return the total pixel width of all attached segments.
        
        \return
        Sum of the pixel widths of all attached ListHeaderSegment objects.
        */
        public function getTotalSegmentsPixelExtent():Number
        {
            var extent:Number = 0.0;
            
            for (var i:uint = 0; i < getColumnCount(); ++i)
            {
                extent += d_segments[i].getPixelSize().d_width;
            }
            
            return extent;
        }
        
        
        /*!
        \brief
        Return the width of the specified column.
        
        \param column
        Zero based column index of the segment whose width is to be returned.
        
        \return
        UDim describing the width of the ListHeaderSegment at the zero based
        column index specified by \a column.
        
        \exception InvalidRequestException	thrown if \a column is out of range.
        */
        public function getColumnWidth(column:uint):UDim
        {
            if (column >= getColumnCount())
            {
                throw new Error("ListHeader::getColumnWidth - requested column index is out of range for this ListHeader.");
            }
            else
            {
                return d_segments[column].getWidth();
            }

        }
        
        
        /*!
        \brief
        Return the currently set sort direction.
        
        \return
        One of the ListHeaderSegment::SortDirection enumerated values specifying the current sort direction.
        */
        public function getSortDirection():uint
        {
            return d_sortDir;
        }
        
        
        /*!
        \brief
        Return whether user manipulation of the sort column & direction are enabled.
        
        \return
        true if the user may interactively modify the sort column and direction.  false if the user may not
        modify the sort column and direction (these can still be set programmatically).
        */
        public function isSortingEnabled():Boolean
        {
            return d_sortingEnabled;
        }
        
        /*!
        \brief
        Return whether the user may size column segments.
        
        \return
        true if the user may interactively modify the width of column segments, false if they may not.
        */
        public function isColumnSizingEnabled():Boolean
        {
            return d_sizingEnabled;
        }
        
        
        /*!
        \brief
        Return whether the user may modify the order of the segments.
        
        \return
        true if the user may interactively modify the order of the column segments, false if they may not.
        */
        public function isColumnDraggingEnabled():Boolean
        {
            return d_movingEnabled;
        }
        
        
        /*!
        \brief
        Return the current segment offset value.  This value is used to implement scrolling of the header segments within
        the ListHeader area.
        
        \return
        float value specifying the current segment offset value in whatever metrics system is active for the ListHeader.
        */
        public function getSegmentOffset():Number
        {
            return d_segmentOffset;
        }
        
        
        /*************************************************************************
         Manipulator Methods
         *************************************************************************/
        /*!
        \brief
        Set whether user manipulation of the sort column and direction is enabled.
        
        \param setting
        - true to allow interactive user manipulation of the sort column and direction.
        - false to disallow interactive user manipulation of the sort column and direction.
        
        \return
        Nothing.
        */
        public function setSortingEnabled(setting:Boolean):void
        {
            if (d_sortingEnabled != setting)
            {
                d_sortingEnabled = setting;
                
                // make the setting change for all component segments.
                for (var i:uint = 0; i <getColumnCount(); ++i)
                {
                    d_segments[i].setClickable(d_sortingEnabled);
                }
                
                // Fire setting changed event.
                var args:WindowEventArgs = new WindowEventArgs(this);
                onSortSettingChanged(args);
            }
        }
        
        
        /*!
        \brief
        Set the current sort direction.
        
        \param direction
        One of the ListHeaderSegment::SortDirection enumerated values indicating the sort direction to be used.
        
        \return
        Nothing.
        */
        public function setSortDirection(direction:uint):void
        {
            if (d_sortDir != direction)
            {
                d_sortDir = direction;
                
                // set direction of current sort segment
                if (d_sortSegment)
                {
                    d_sortSegment.setSortDirection(direction);
                }
                
                // Fire sort direction changed event.
                var args:WindowEventArgs = new WindowEventArgs(this);
                onSortDirectionChanged(args);
            }
        }
        
        
        /*!
        \brief
        Set the column segment to be used as the sort column.
        
        \param segment
        ListHeaderSegment object indicating the column to be sorted.
        
        \return
        Nothing.
        
        \exception InvalidRequestException	thrown if \a segment is not attached to this ListHeader.
        */
        public function setSortSegment(segment:FlameListHeaderSegment):void
        {
            setSortColumn(getColumnFromSegment(segment));
        }
        
        
        /*!
        \brief
        Set the column to be used as the sort column.
        
        \param column
        Zero based column index indicating the column to be sorted.
        
        \return
        Nothing.
        
        \exception InvalidRequestException	thrown if \a column is out of range for this ListHeader.
        */
        public function setSortColumn(column:uint):void
        {
            if (column >= getColumnCount())
            {
                throw new Error("ListHeader::setSortColumn - specified column index is out of range for this ListHeader.");
            }
            else
            {
                // if column is different to current sort segment
                if (d_sortSegment != d_segments[column])
                {
                    // set sort direction on 'old' sort segment to none.
                    if (d_sortSegment)
                    {
                        d_sortSegment.setSortDirection(Consts.SortDirection_None);
                    }
                    
                    // set-up new sort segment
                    d_sortSegment = d_segments[column];
                    d_sortSegment.setSortDirection(d_sortDir);
                    
                    // Fire sort column changed event
                    var args:WindowEventArgs = new WindowEventArgs(this);
                    onSortColumnChanged(args);
                }
                
            }
        }
        
        
        /*!
        \brief
        Set the column to to be used for sorting via its ID code.
        
        \param id
        ID code of the column segment that is to be used as the sort column.
        
        \return
        Nothing.
        
        \exception InvalidRequestException	thrown if no segment with ID \a id is attached to the ListHeader.
        */
        public function setSortColumnFromID(id:uint):void
        {
            setSortSegment(getSegmentFromID(id));
        }
        
        
        /*!
        \brief
        Set whether columns may be sized by the user.
        
        \param setting
        - true to indicate that the user may interactively size segments.
        - false to indicate that the user may not interactively size segments.
        
        \return
        Nothing.
        */
        public function setColumnSizingEnabled(setting:Boolean):void
        {
            if (d_sizingEnabled != setting)
            {
                d_sizingEnabled = setting;
                
                // make the setting change for all component segments.
                for (var i:uint = 0; i <getColumnCount(); ++i)
                {
                    d_segments[i].setSizingEnabled(d_sizingEnabled);
                }
                
                // Fire setting changed event.
                var args:WindowEventArgs = new WindowEventArgs(this);
                onDragSizeSettingChanged(args);
            }
        }
            
        
        
        /*!
        \brief
        Set whether columns may be reordered by the user via drag and drop.
        
        \param setting
        - true to indicate the user may change the order of the column segments via drag and drop.
        - false to indicate the user may not change the column segment order.
        
        \return
        Nothing.
        */
        public function setColumnDraggingEnabled(setting:Boolean):void
        {
            if (d_movingEnabled != setting)
            {
                d_movingEnabled = setting;
                
                // make the setting change for all component segments.
                for (var i:uint = 0; i <getColumnCount(); ++i)
                {
                    d_segments[i].setDragMovingEnabled(d_movingEnabled);
                }
                
                // Fire setting changed event.
                var args:WindowEventArgs = new WindowEventArgs(this);
                onDragMoveSettingChanged(args);
            }
        }
        
        
        /*!
        \brief
        Add a new column segment to the end of the header.
        
        \param text
        String object holding the initial text for the new segment
        
        \param id
        Client specified ID code to be assigned to the new segment.
        
        \param width
        UDim describing the initial width of the new segment.
        
        \return
        Nothing.
        */
        public function addColumn(text:String, id:uint, width:UDim):void
        {
            // add just inserts at end.
            insertColumnAt(text, id, width, getColumnCount());
        }
        
        
        /*!
        \brief
        Insert a new column segment at the specified position.
        
        \param text
        String object holding the initial text for the new segment
        
        \param id
        Client specified ID code to be assigned to the new segment.
        
        \param width
        UDim describing the initial width of the new segment.
        
        \param position
        Zero based column index indicating the desired position for the new column.  If this is greater than
        the current number of columns, the new segment is added to the end if the header.
        
        \return
        Nothing.
        */
        public function insertColumnAt(text:String, id:uint, width:UDim, position:uint):void
        {
            // if position is too big, insert at end.
            if (position > getColumnCount())
            {
                position = getColumnCount();
            }
            
            var seg:FlameListHeaderSegment = createInitialisedSegment(text, id, width);
            
            //d_segments.insert((d_segments.begin() + position), seg);
            d_segments.splice(position, 0, seg);
            
            // add window as a child of this
            addChildWindow(seg);
            
            layoutSegments();
            
            // Fire segment added event.
            var args:WindowEventArgs = new WindowEventArgs(this);
            onSegmentAdded(args);
            
            // if sort segment is invalid, make it valid now we have a segment attached
            if (!d_sortSegment)
            {
                setSortColumn(position);
            }
        }
        
        
        /*!
        \brief
        Insert a new column segment at the specified position.
        
        \param text
        String object holding the initial text for the new segment
        
        \param id
        Client specified ID code to be assigned to the new segment.
        
        \param width
        UDim describing the initial width of the new segment.
        
        \param position
        ListHeaderSegment object indicating the insert position for the new segment.  The new segment will be
        inserted before the segment indicated by \a position.
        
        \return
        Nothing.
        
        \exception InvalidRequestException	thrown if ListHeaderSegment \a position is not attached to the ListHeader.
        */
        public function insertColumn(text:String, id:uint, width:UDim, position:FlameListHeaderSegment):void
        {
            insertColumnAt(text, id, width, getColumnFromSegment(position));
        }
        
        
        /*!
        \brief
        Removes a column segment from the ListHeader.
        
        \param column
        Zero based column index indicating the segment to be removed.
        
        \return
        Nothing.
        
        \exception InvalidRequestException	thrown if \a column is out of range.
        */
        public function removeColumn(column:uint):void
        {
            if (column >= getColumnCount())
            {
                throw new Error("ListHeader::removeColumn - specified column index is out of range for this ListHeader.");
            }
            else
            {
                var seg:FlameListHeaderSegment = d_segments[column];
                
                // remove from the list of segments
                //d_segments.erase(d_segments.begin() + column);
                d_segments.splice(column, 1);
                
                // have we removed the sort column?
                if (d_sortSegment == seg)
                {
                    // any other columns?
                    if (getColumnCount() > 0)
                    {
                        // put first column in as sort column
                        d_sortDir = Consts.SortDirection_None;
                        setSortColumn(0);
                    }
                        // no columns, set sort segment to NULL
                    else
                    {
                        d_sortSegment = null;
                    }
                    
                }
                
                // detach segment window from the header (this)
                removeChildWindow(seg);
                
                // destroy the segment (done in derived class, since that's where it was created).
                destroyListSegment(seg);
                
                layoutSegments();
                
                // Fire segment removed event.
                var args:WindowEventArgs = new WindowEventArgs(this);
                onSegmentRemoved(args);
            }
        }
                
        
        
        /*!
        \brief
        Remove the specified segment from the ListHeader.
        
        \param segment
        ListHeaderSegment object that is to be removed from the ListHeader.
        
        \return
        Nothing.
        
        \exception InvalidRequestException	thrown if \a segment is not attached to this ListHeader.
        */
        public function removeSegment(segment:FlameListHeaderSegment):void
        {
            removeColumn(getColumnFromSegment(segment));
        }
        
        
        /*!
        \brief
        Moves a column segment into a new position.
        
        \param column
        Zero based column index indicating the column segment to be moved.
        
        \param position
        Zero based column index indicating the new position for the segment.  If this is greater than the current number of segments,
        the segment is moved to the end of the header.
        
        \return
        Nothing.
        
        \exception InvalidRequestException thrown if \a column is out of range for this ListHeader.
        */
        public function moveColumn(column:uint, position:uint):void
        {
            if (column >= getColumnCount())
            {
                throw new Error("ListHeader::moveColumn - specified column index is out of range for this ListHeader.");
            }
            else
            {
                // if position is too big, move to end.
                if (position >= getColumnCount())
                {
                    position = getColumnCount() - 1;
                }
                
                var seg:FlameListHeaderSegment = d_segments[column];
                
                // remove original copy of segment
                //d_segments.erase(d_segments.begin() + column);
                d_segments.splice(column, 1);
                
                // insert the segment at it's new position
                // d_segments.insert(d_segments.begin() + position, seg);
                d_segments.splice(position, 0, seg);
                
                // Fire sequence changed event
                var args:HeaderSequenceEventArgs = new HeaderSequenceEventArgs(this, column, position);
                onSegmentSequenceChanged(args);
                
                layoutSegments();
            }
        }
            
        
        
        /*!
        \brief
        Move a column segment to a new position.
        
        \param column
        Zero based column index indicating the column segment to be moved.
        
        \param position
        ListHeaderSegment object indicating the new position for the segment.  The segment at \a column
        will be moved behind segment \a position (that is, segment \a column will appear to the right of
        segment \a position).
        
        \return
        Nothing.
        
        \exception InvalidRequestException thrown if \a column is out of range for this ListHeader, or if \a position
        is not attached to this ListHeader.
        */
        public function moveColumnByPosition(column:uint, position:FlameListHeaderSegment):void
        {
            moveColumn(column, getColumnFromSegment(position));
        }
        
        
        /*!
        \brief
        Moves a segment into a new position.
        
        \param segment
        ListHeaderSegment object that is to be moved.
        
        \param position
        Zero based column index indicating the new position for the segment.  If this is greater than the current number of segments,
        the segment is moved to the end of the header.
        
        \return
        Nothing.
        
        \exception InvalidRequestException thrown if \a segment is not attached to this ListHeader.
        */
        public function moveSegmentByColumn(segment:FlameListHeaderSegment, position:uint):void
        {
            moveColumn(getColumnFromSegment(segment), position);
        }
        
        
        /*!
        \brief
        Move a segment to a new position.
        
        \param segment
        ListHeaderSegment object that is to be moved.
        
        \param position
        ListHeaderSegment object indicating the new position for the segment.  The segment \a segment
        will be moved behind segment \a position (that is, segment \a segment will appear to the right of
        segment \a position).
        
        \return
        Nothing.
        
        \exception InvalidRequestException thrown if either \a segment or \a position are not attached to this ListHeader.
        */
        public function moveSegmentWithBothSegment(segment:FlameListHeaderSegment, position:FlameListHeaderSegment):void
        {
            moveColumn(getColumnFromSegment(segment), getColumnFromSegment(position));
        }
        
        
        /*!
        \brief
        Set the current base segment offset.  (This implements scrolling of the header segments within
        the header area).
        
        \param offset
        New base offset for the first segment.  The segments will of offset to the left by the amount specified.
        \a offset should be specified using the active metrics system for the ListHeader.
        
        \return
        Nothing.
        */
        public function setSegmentOffset(offset:Number):void
        {
            if (d_segmentOffset != offset)
            {
                d_segmentOffset = offset;
                layoutSegments();
                invalidate();
                
                // Fire event.
                var args:WindowEventArgs = new WindowEventArgs(this);
                onSegmentOffsetChanged(args);
            }
        }
        
        
        /*!
        \brief
        Set the width of the specified column.
        
        \param column
        Zero based column index of the segment whose width is to be set.
        
        \param width
        UDim value specifying the new width to set for the ListHeaderSegment at the zero based column
        index specified by \a column.
        
        \return
        Nothing
        
        \exception InvalidRequestException	thrown if \a column is out of range.
        */
        public function setColumnWidth(column:uint, width:UDim):void
        {
            if (column >= getColumnCount())
            {
                throw new Error("ListHeader::setColumnWidth - specified column index is out of range for this ListHeader.");
            }
            else
            {
                d_segments[column].setWidth(width);
                
                layoutSegments();
                
                // Fire segment sized event.
                var args:WindowEventArgs = new WindowEventArgs(d_segments[column]);
                onSegmentSized(args);
            }
        }
        
   
        /*************************************************************************
         Abstract Implementation Methods
         *************************************************************************/
        /*!
        \brief
        Create and return a pointer to a new ListHeaderSegment based object.
        
        \param name
        String object holding the name that should be given to the new Window.
        
        \return
        Pointer to an ListHeaderSegment based object of whatever type is appropriate for
        this ListHeader.
        */
        //virtual ListHeaderSegment*	createNewSegment_impl(const String& name) const	= 0;
        
        
        /*!
        \brief
        Cleanup and destroy the given ListHeaderSegment that was created via the
        createNewSegment method.
        
        \param segment
        Pointer to a ListHeaderSegment based object to be destroyed.
        
        \return
        Nothing.
        */
        //virtual void	destroyListSegment_impl(ListHeaderSegment* segment) const = 0;
        
        
        /*************************************************************************
         Implementation Methods
         *************************************************************************/
        /*!
        \brief
        Create initialise and return a ListHeaderSegment object, with all events subscribed and ready to use.
        */
        protected function createInitialisedSegment(text:String, id:uint, width:UDim):FlameListHeaderSegment
        {
            // Build unique name
            var name:String = getName() + SegmentNameSuffix + d_uniqueIDNumber;
            
            // create segment.
            var newseg:FlameListHeaderSegment = createNewSegment(name);
            d_uniqueIDNumber++;
            
            // setup segment;
            newseg.setSize(new UVector2(width, Misc.cegui_reldim(1.0)));
            newseg.setMinSize(new UVector2(Misc.cegui_absdim(MinimumSegmentPixelWidth), Misc.cegui_absdim(0)));
            newseg.setText(text);
            newseg.setID(id);
            newseg.setSizingEnabled(d_sizingEnabled);
            newseg.setDragMovingEnabled(d_movingEnabled);
            newseg.setClickable(d_sortingEnabled);
            
            // subscribe events we listen to
            newseg.subscribeEvent(FlameListHeaderSegment.EventSegmentSized,  new Subscriber(segmentSizedHandler, this), FlameListHeaderSegment.EventNamespace);
            newseg.subscribeEvent(FlameListHeaderSegment.EventSegmentDragStop,  new Subscriber(segmentMovedHandler, this), FlameListHeaderSegment.EventNamespace);
            newseg.subscribeEvent(FlameListHeaderSegment.EventSegmentClicked,  new Subscriber(segmentClickedHandler, this), FlameListHeaderSegment.EventNamespace);
            newseg.subscribeEvent(FlameListHeaderSegment.EventSplitterDoubleClicked, new Subscriber(segmentDoubleClickHandler, this), FlameListHeaderSegment.EventNamespace);
            newseg.subscribeEvent(FlameListHeaderSegment.EventSegmentDragPositionChanged, new Subscriber(segmentDragHandler, this), FlameListHeaderSegment.EventNamespace);
            
            return newseg;
        }
        
        
        /*!
        \brief
        Layout the attached segments
        */
        protected function layoutSegments():void
        {
            var pos:UVector2 = new UVector2(Misc.cegui_absdim(-d_segmentOffset), Misc.cegui_absdim(0.0));
            
            for (var i:uint = 0; i < getColumnCount(); ++i)
            {
                d_segments[i].setPosition(pos);
                pos.d_x.addTo(d_segments[i].getWidth());
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
            if (class_name=="ListHeader")	return true;
            return super.testClassName_impl(class_name);
        }
        
        
        /*!
        \brief
        Create and return a pointer to a new ListHeaderSegment based object.
        
        \param name
        String object holding the name that should be given to the new Window.
        
        \return
        Pointer to an ListHeaderSegment based object of whatever type is appropriate for
        this ListHeader.
        */
        protected function createNewSegment(name:String):FlameListHeaderSegment
        {
            if (d_windowRenderer != null)
            {
                var wr:ListHeaderWindowRenderer  =  d_windowRenderer as ListHeaderWindowRenderer;
                return wr.createNewSegment(name);
            }
            else
            {
                //return createNewSegment_impl(name);
                throw new Error("ListHeader::createNewSegment - This function must be implemented by the window renderer module");
            }
        }
        
        
        /*!
        \brief
        Cleanup and destroy the given ListHeaderSegment that was created via the
        createNewSegment method.
        
        \param segment
        Pointer to a ListHeaderSegment based object to be destroyed.
        
        \return
        Nothing.
        */
        protected function destroyListSegment(segment:FlameListHeaderSegment):void
        {
            if (d_windowRenderer != null)
            {
                var wr:ListHeaderWindowRenderer = d_windowRenderer as ListHeaderWindowRenderer;
                return wr.destroyListSegment(segment);
            }
            else
            {
                //return destroyListSegment_impl(segment);
                throw new Error("ListHeader::destroyListSegment - This function must be implemented by the window renderer module");
            }
        }
        
        // validate window renderer
        protected function validateWindowRenderer(name:String):Boolean
        {
            return (name == "ListHeader");
        }
        
        /*************************************************************************
         New List header event handlers
         *************************************************************************/
        /*!
        \brief
        Handler called when the sort column is changed.
        */
        protected function onSortColumnChanged(e:WindowEventArgs):void
        {
            fireEvent(EventSortColumnChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the sort direction is changed.
        */
        protected function onSortDirectionChanged(e:WindowEventArgs):void
        {
            fireEvent(EventSortDirectionChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when a segment is sized by the user.  e.window points to the segment.
        */
        protected function onSegmentSized(e:WindowEventArgs):void
        {
            fireEvent(EventSegmentSized, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when a segment is clicked by the user.  e.window points to the segment.
        */
        protected function onSegmentClicked(e:WindowEventArgs):void
        {
            fireEvent(EventSegmentClicked, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when a segment splitter / sizer is double-clicked.  e.window points to the segment.
        */
        protected function onSplitterDoubleClicked(e:WindowEventArgs):void
        {
            fireEvent(EventSplitterDoubleClicked, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the segment / column order changes.
        */
        protected function onSegmentSequenceChanged(e:WindowEventArgs):void
        {
            fireEvent(EventSegmentSequenceChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when a new segment is added to the header.
        */
        protected function onSegmentAdded(e:WindowEventArgs):void
        {
            fireEvent(EventSegmentAdded, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when a segment is removed from the header.
        */
        protected function onSegmentRemoved(e:WindowEventArgs):void
        {
            fireEvent(EventSegmentRemoved, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called then setting that controls the users ability to modify the search column & direction changes.
        */
        protected function onSortSettingChanged(e:WindowEventArgs):void
        {
            fireEvent(EventSortSettingChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the setting that controls the users ability to drag and drop segments changes.
        */
        protected function onDragMoveSettingChanged(e:WindowEventArgs):void
        {
            fireEvent(EventDragMoveSettingChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the setting that controls the users ability to size segments changes.
        */
        protected function onDragSizeSettingChanged(e:WindowEventArgs):void
        {
            fireEvent(EventDragSizeSettingChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the base rendering offset for the segments (scroll position) changes.
        */
        protected function onSegmentOffsetChanged(e:WindowEventArgs):void
        {
            fireEvent(EventSegmentRenderOffsetChanged, e, EventNamespace);
        }
        
        /*************************************************************************
         handlers for events we subscribe to from segments
         *************************************************************************/
        protected function segmentSizedHandler(e:EventArgs):Boolean
        {
            layoutSegments();
            
            // Fire segment sized event.
            var args:WindowEventArgs = new WindowEventArgs((e as WindowEventArgs).window);
            onSegmentSized(args);
            
            return true;
        }
        
        protected function segmentMovedHandler(e:EventArgs):Boolean
        {
            const mousePos:Vector2 =  
                getUnprojectedPosition(FlameMouseCursor.getSingleton().getPosition());
            
            // segment must be dropped within the window
            if (isHit(mousePos))
            {
                // get mouse position as something local
                var localMousePos:Vector2 = CoordConverter.screenToWindowForVector2(this, mousePos);
                
                // set up to allow for current offsets
                var currwidth:Number = -d_segmentOffset;
                
                // calculate column where dragged segment was dropped
                var col:uint;
                for (col = 0; col < getColumnCount(); ++col)
                {
                    currwidth += d_segments[col].getPixelSize().d_width;
                    
                    if (localMousePos.d_x < currwidth)
                    {
                        // this is the column, exit loop early
                        break;
                    }
                    
                }
                
                // find original column for dragged segment.
                var seg:FlameListHeaderSegment = ((e as WindowEventArgs).window) as FlameListHeaderSegment;
                var curcol:uint = getColumnFromSegment(seg);
                
                // move column
                moveColumn(curcol, col);
            }
            
            return true;
        }
        
        protected function segmentClickedHandler(e:EventArgs):Boolean
        {
            // double-check we allow this action
            if (d_sortingEnabled)
            {
                var seg:FlameListHeaderSegment = ((e as WindowEventArgs).window) as FlameListHeaderSegment;
                
                // is this a new sort column?
                if (d_sortSegment != seg)
                {
                    d_sortDir = Consts.SortDirection_Descending;
                    setSortSegment(seg);
                }
                // not a new segment, toggle current direction
                else if (d_sortSegment)
                {
                    var currDir:uint = d_sortSegment.getSortDirection();
                    
                    // set new direction based on the current value.
                    switch (currDir)
                    {
                        case Consts.SortDirection_None:
                            setSortDirection(Consts.SortDirection_Descending);
                            break;
                        
                        case Consts.SortDirection_Ascending:
                            setSortDirection(Consts.SortDirection_Descending);
                            break;
                        
                        case Consts.SortDirection_Descending:
                            setSortDirection(Consts.SortDirection_Ascending);
                            break;
                    }
                    
                }
                
                // Notify that a segment has been clicked
                var args:WindowEventArgs = new WindowEventArgs((e as WindowEventArgs).window);
                onSegmentClicked(args);
            }
            
            return true;
        }
        
        
        protected function segmentDoubleClickHandler(e:EventArgs):Boolean
        {
            var args:WindowEventArgs = new WindowEventArgs((e as WindowEventArgs).window);
            onSplitterDoubleClicked(args);
            
            return true;
        }
        
        
        protected function segmentDragHandler(e:EventArgs):Boolean
        {
            // what we do here is monitor the position and scroll if we can when mouse is outside area.
            
            // get mouse position as something local
            const localMousePos:Vector2 = CoordConverter.screenToWindowForVector2(this,
                getUnprojectedPosition(
                    FlameMouseCursor.getSingleton().getPosition()));
            
            // scroll left?
            if (localMousePos.d_x < 0.0)
            {
                if (d_segmentOffset > 0.0)
                {
                    setSegmentOffset(Math.max(0.0, d_segmentOffset - ScrollSpeed));
                }
            }
                // scroll right?
            else if (localMousePos.d_x >= d_pixelSize.d_width)
            {
                var maxOffset:Number = Math.max(0.0, getTotalSegmentsPixelExtent() - d_pixelSize.d_width);
                
                // if we have not scrolled to the limit
                if (d_segmentOffset < maxOffset)
                {
                    // scroll, but never beyond the limit
                    setSegmentOffset(Math.min(maxOffset, d_segmentOffset + ScrollSpeed));
                }
                
            }
            
            return true;
        }
        

        
        /*************************************************************************
         Private methods
         *************************************************************************/
        private function addHeaderProperties():void
        {
            addProperty(d_sizableProperty);
            addProperty(d_movableProperty);
            addProperty(d_sortSettingProperty);
            addProperty(d_sortColumnIDProperty);
            addProperty(d_sortDirectionProperty);
        }
        
    }
}