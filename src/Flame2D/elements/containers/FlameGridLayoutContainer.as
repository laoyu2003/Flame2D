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
package Flame2D.elements.containers
{
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.data.Consts;
    import Flame2D.elements.button.FlameButtonBase;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.UDim;
    import Flame2D.core.utils.UVector2;
    
    public class FlameGridLayoutContainer extends FlameLayoutContainer
    {
        public static const EventNamespace:String = "GridLayoutContainer";
        public static const WidgetTypeName:String = "GridLayoutContainer";
        
        /*************************************************************************
         Child Widget name suffix constants
         *************************************************************************/
        //! Widget name suffix for dummies.
        public static const DummyNameSuffix:String = "__auto_dummy_";
        
        //! fired when child windows get rearranged
        public static const EventChildWindowOrderChanged:String = "ChildWindowOrderChanged";
        
        
        /*************************************************************************
         Properties for GridLayoutContainer class
         *************************************************************************/
        private static var d_gridSizeProperty:GridLayoutContainerPropertyGridSize = new GridLayoutContainerPropertyGridSize();
        private static var d_autoPositioningProperty:GridLayoutContainerPropertyAutoPositioning = new GridLayoutContainerPropertyAutoPositioning();
        
        
        //! stores grid width - amount of columns
        protected var d_gridWidth:uint = 0;
        //! stores grid height - amount of rows
        protected var d_gridHeight:uint = 0;
        
        //! stores currently used auto positioning method
        protected var d_autoPositioning:uint = Consts.AutoPositioning_AP_LeftToRight;
        /** stores next auto positioning index (will be used for next
         * added window if d_autoPositioning != AP_Disabled)
         */
        protected var d_nextAutoPositioningIdx:uint = 0;
        
        /** stores next used grid X position
         * (only used if d_autoPositioning == AP_Disabled)
         */
        protected var d_nextGridX:uint = uint.MAX_VALUE;
        /** stores next used grid Y position
         * (only used if d_autoPositioning == AP_Disabled)
         */
        protected var d_nextGridY:uint = uint.MAX_VALUE;
        
        /** stores next used dummy suffix index
         * (used to generate unique dummy names)
         */
        protected var d_nextDummyIdx:uint = 0;
        
        
        
        
        public function FlameGridLayoutContainer(type:String, name:String)
        {
            super(type, name);
            
            // grid size is 0x0 that means 0 child windows,
            // no need to populate d_children with dummies
            
            addGridLayoutContainerProperties();
        }
        
        /*!
        \brief
        Sets grid's dimensions.
        */
        public function setGridDimensions(width:uint, height:uint):void
        {
            // copy the old children list
            var oldChildren:Vector.<FlameWindow> = d_children.slice();
            
            // remove all child windows
            while (getChildCount() != 0)
            {
                var wnd:FlameWindow = d_children[0];
                removeChildWindow(wnd);
            }
            
            // we simply fill the grid with dummies to ensure everything works smoothly
            // when something is added to the grid, it simply replaces the dummy
            for (var i:uint = 0; i < width * height; ++i)
            {
                var dummy:FlameWindow = createDummy();
                addChildWindow(dummy);
            }
            
            const oldWidth:uint = d_gridWidth;
            
            const oldHeight:uint = d_gridHeight;
            
            const oldAO:uint = d_autoPositioning;
            
            d_gridWidth = width;
            
            d_gridHeight = height;
            
            // now we have to map oldChildren to new children
            for (var y:uint = 0; y < height; ++y)
            {
                for (var x:uint = 0; x < width; ++x)
                {
                    // we have to skip if we are out of the old grid
                    if (x >= oldWidth || y >= oldHeight)
                        continue;
                    
                    const oldIdx:uint = mapFromGridToIdx(x, y, oldWidth, oldHeight);
                    var previous:FlameWindow = oldChildren[oldIdx];
                    
                    if (isDummy(previous))
                    {
                        FlameWindowManager.getSingleton().destroyWindow(previous);
                    }
                    else
                    {
                        addChildWindowToPosition(previous, x, y);
                    }
                    
                    oldChildren[oldIdx] = null;
                }
            }
            
            setAutoPositioning(oldAO);
            // oldAOIdx could mean something completely different now!
            // todo: perhaps convert oldAOOdx to new AOIdx?
            setNextAutoPositioningIdx(0);
            
            // we have to destroy windows that don't fit the new grid if they are set
            // to be destroyed by parent
            for ( i = 0; i < oldChildren.length; ++i)
            {
                if (oldChildren[i] && oldChildren[i].isDestroyedByParent())
                {
                    FlameWindowManager.getSingleton().destroyWindow(oldChildren[i]);
                }
            }
        }
        
        /*!
        \brief
        Retrieves grid width, the amount of cells in one row
        */
        public function getGridWidth():uint
        {
            return d_gridWidth;
        }
        
        /*!
        \brief
        Retrieves grid height, the amount of rows in the grid
        */
        public function getGridHeight():uint
        {
            return d_gridHeight;
        }
        
        /*!
        \brief
        Sets new auto positioning method.
        
        \par
        The newly set auto positioning sequence will start over!
        Use setAutoPositioningIdx to set it's starting point
        */
        public function setAutoPositioning(positioning:uint):void
        {
            d_autoPositioning = positioning;
            d_nextAutoPositioningIdx = 0;
        }
        
        /*!
        \brief
        Retrieves current auto positioning method.
        */
        public function getAutoPositioning():uint
        {
            return d_autoPositioning;
        }
        
        /*!
        \brief
        Sets the next auto positioning "sequence position", this will be used
        next time when addChildWindow is called.
        */
        public function setNextAutoPositioningIdx(idx:uint):void
        {
            d_nextAutoPositioningIdx = idx;
        }
        
        /*!
        \brief
        Retrieves auto positioning "sequence position", this will be used next
        time when addChildWindow is called.
        */
        public function getNextAutoPositioningIdx():uint
        {
            return d_nextAutoPositioningIdx;
        }
        
        /*!
        \brief
        Skips given number of cells in the auto positioning sequence
        */
        public function autoPositioningSkipCells(cells:uint):void
        {
            setNextAutoPositioningIdx(getNextAutoPositioningIdx() + cells);
        }
        
        /*!
        \brief
        Add the specified Window to specified grid position as a child of
        this Grid Layout Container.  If the Window \a window is already
        attached to a Window, it is detached before being added to this Window.
        
        \par
        If something is already in given grid cell, it gets removed!
        
        \par
        This disabled auto positioning from further usage! You need to call
        setAutoPositioning(..) to set it back to your desired value and use
        setAutoPositioningIdx(..) to set it's starting point back
        
        \see
        Window::addChildWindow
        */
        public function addChildWindowToPosition(window:FlameWindow, gridX:uint, gridY:uint):void
        {
            // when user starts to add windows to specific locations, AO has to be disabled
            setAutoPositioning(Consts.AutoPositioning_AP_Disabled);
            d_nextGridX = gridX;
            d_nextGridY = gridY;
            
            super.addChildWindow(window);
        }
        
        /*!
        \brief
        Add the named Window to specified grid position as a child of
        this Grid Layout Container.  If the Window \a window is already
        attached to a Window, it is detached before being added to this Window.
        
        \par
        If something is already in given grid cell, it gets removed!
        
        \par
        This disabled auto positioning from further usage! You need to call
        setAutoPositioning(..) to set it back to your desired value and use
        setAutoPositioningIdx(..) to set it's starting point back
        
        \see
        Window::addChildWindow
        */
        public function addChildWindowToPositionByName(name:String, gridX:uint, gridY:uint):void
        {
            addChildWindowToPosition(FlameWindowManager.getSingleton().getWindow(name),
                gridX, gridY);
        }
        
        /*!
        \brief
        Retrieves child window that is currently at given grid position
        */
        public function getChildWindowAtPosition(gridX:uint, gridY:uint):FlameWindow
        {
            //assert(gridX < d_gridWidth && "out of bounds");
            //assert(gridY < d_gridHeight && "out of bounds");
            
            return getChildAt(mapFromGridToIdx(gridX, gridY,
                d_gridWidth, d_gridHeight));
        }
        
        /*!
        \brief
        Removes the child window that is currently at given grid position
        
        \see
        Window::removeChildWindow
        */
        public function removeChildWindowFromPosition(gridX:uint, gridY:uint):void
        {
            removeChildWindow(getChildWindowAtPosition(gridX, gridY));
        }
        
        /*!
        \brief
        Swaps positions of 2 windows given by their index
        
        \par
        For advanced users only!
        */
        public function swapChildWindowPositionsByIdx(wnd1:uint, wnd2:uint):void
        {
            if (wnd1 < d_children.length && wnd2 < d_children.length)
            {
                Misc.swap(d_children[wnd1], d_children[wnd2]);
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onChildWindowOrderChanged(args);
            }
        }
        
        /*!
        \brief
        Swaps positions of 2 windows given by grid positions
        */
        public function swapChildWindowPositions(gridX1:uint, gridY1:uint, gridX2:uint, gridY2:uint):void
        {
            swapChildWindowPositionsByIdx(
                mapFromGridToIdx(gridX1, gridY1, d_gridWidth, d_gridHeight),
                mapFromGridToIdx(gridX2, gridY2, d_gridWidth, d_gridHeight));
        }
        
        /*!
        \brief
        Swaps positions of given windows
        */
        public function swapChildWindows(wnd1:FlameWindow, wnd2:FlameWindow):void
        {
            swapChildWindowPositionsByIdx(getIdxOfChildWindow(wnd1),
                getIdxOfChildWindow(wnd2));
        }
        
        /*!
        \brief
        Swaps positions of given windows
        */
        public function swapChildWindowsWindowAndName(wnd1:FlameWindow, wnd2:String):void
        {
            swapChildWindows(wnd1, FlameWindowManager.getSingleton().getWindow(wnd2));
        }
        
        /*!
        \brief
        Swaps positions of given windows
        */
        public function swapChildWindowsNameAndWindow(wnd1:String, wnd2:FlameWindow):void
        {
            swapChildWindows(FlameWindowManager.getSingleton().getWindow(wnd1), wnd2);
        }
        
        /*!
        \brief
        Moves given child window to given grid position
        */
        public function moveChildWindowToPosition(wnd:FlameWindow, gridX:uint, gridY:uint):void
        {
            removeChildWindow(wnd);
            addChildWindowToPosition(wnd, gridX, gridY);
        }
        
        /*!
        \brief
        Moves named child window to given grid position
        */
        public function moveChildWindowToPositionByName(wnd:String, gridX:uint, gridY:uint):void
        {
            moveChildWindowToPosition(FlameWindowManager.getSingleton().getWindow(wnd),
                gridX, gridY);
        }
        
        //! @copydoc LayoutContainer::layout
        override public function layout():void
        {
            var colSizes:Vector.<UDim> = new Vector.<UDim>();
            for(var i:uint = 0; i< d_gridWidth; i++)
            {
                colSizes[i] = new UDim(0, 0);
            }
            var rowSizes:Vector.<UDim> = new Vector.<UDim>();
            for(i = 0; i<d_gridHeight; i++)
            {
                rowSizes[i] = new UDim(0, 0);
            }
            
            // used to compare UDims
            const absWidth:Number = getChildWindowContentArea().getWidth();
            const absHeight:Number = getChildWindowContentArea().getHeight();
            
            // first, we need to determine rowSizes and colSizes, this is needed before
            // any layouting work takes place
            for (var y:uint = 0; y < d_gridHeight; ++y)
            {
                for (var x:uint = 0; x < d_gridWidth; ++x)
                {
                    // x and y is the position of window in the grid
                    var childIdx:uint =
                        mapFromGridToIdx(x, y, d_gridWidth, d_gridHeight);
                    
                    var window:FlameWindow = getChildAt(childIdx);
                    var size:UVector2 = getBoundingSizeForWindow(window);
                    
                    if (colSizes[x].asAbsolute(absWidth) < size.d_x.asAbsolute(absWidth))
                    {
                        colSizes[x] = size.d_x;
                    }
                    
                    if (rowSizes[y].asAbsolute(absHeight) < size.d_y.asAbsolute(absHeight))
                    {
                        rowSizes[y] = size.d_y;
                    }
                }
            }
            
            // OK, now in rowSizes[y] is the height of y-th row
            //         in colSizes[x] is the width of x-th column
            
            // second layouting phase starts now
            for ( y = 0; y < d_gridHeight; ++y)
            {
                for ( x = 0; x < d_gridWidth; ++x)
                {
                    // x and y is the position of window in the grid
                    childIdx = mapFromGridToIdx(x, y,
                        d_gridWidth, d_gridHeight);
                    window = getChildAt(childIdx);
                    var offset:UVector2 = getOffsetForWindow(window);
                    var gridCellOffset:UVector2 = getGridCellOffset(colSizes,
                        rowSizes,
                        x, y);
                    
                    window.setPosition(gridCellOffset + offset);
                }
            }
            
            // now we just need to determine the total width and height and set it
            setSize(getGridSize(colSizes, rowSizes));
        }
        
        /*!
        \brief
        Handler called when children of this window gets rearranged in any way
        
        \param e
        WindowEventArgs object whose 'window' field is set this layout
        container.
        */
        protected function onChildWindowOrderChanged(e:WindowEventArgs):void
        {
            markNeedsLayouting();
            
            fireEvent(EventChildWindowOrderChanged, e, EventNamespace);
        }
        
        //! converts from grid cell position to idx
        protected function mapFromGridToIdx(gridX:uint, gridY:uint, gridWidth:uint, gridHeight:uint) :uint
        {
            // example:
            // d_children = {1, 2, 3, 4, 5, 6}
            // grid is 3x2
            // 1 2 3
            // 4 5 6
            
            //assert(gridX < gridWidth);
            //assert(gridY < gridHeight);
            
            return gridY * gridWidth + gridX;
        }
        
        
        //return value , to be checked
        //! converts from idx to grid cell position
        protected function mapFromIdxToGrid(idx:uint, gridX:uint,  gridY:uint,
             gridWidth:uint, gridHeight:uint):void
        {
            gridX = 0;
            gridY = 0;
            
            while (idx >= gridWidth)
            {
                idx -= gridWidth;
                ++gridY;
            }
            
            //assert(gridY < gridHeight);
            
            gridX = idx;
        }
        
        /** calculates grid cell offset
         * (relative to position of this layout container)
         */
        protected function getGridCellOffset(colSizes:Vector.<UDim>, rowSizes:Vector.<UDim>, gridX:uint, gridY:uint): UVector2
        {
            //assert(gridX < d_gridWidth);
            //assert(gridY < d_gridHeight);
            
            var ret:UVector2 = new UVector2(new UDim(0, 0), new UDim(0, 0));
            
            for (var i:uint = 0; i < gridX; ++i)
            {
                ret.d_x += colSizes[i];
            }
            
            for ( i = 0; i < gridY; ++i)
            {
                ret.d_y += rowSizes[i];
            }
            
            return ret;
        }
        
        //! calculates total grid size
        protected function getGridSize(colSizes:Vector.<UDim>, rowSizes:Vector.<UDim>) : UVector2
        {
            var ret:UVector2 = new UVector2(new UDim(0, 0), new UDim(0, 0));
            
            for (var i:uint = 0; i < colSizes.length; ++i)
            {
                ret.d_x += colSizes[i];
            }
            
            for ( i = 0; i < rowSizes.length; ++i)
            {
                ret.d_y += rowSizes[i];
            }
            
            return ret;
        }
        
        //! translates auto positioning index to absolute grid index
        protected function translateAPToGridIdx(APIdx:uint) : uint
        {
            // todo: more auto positioning variants? will someone use them?
            
            if (d_autoPositioning == Consts.AutoPositioning_AP_Disabled)
            {
                //assert(0);
            }
            else if (d_autoPositioning == Consts.AutoPositioning_AP_LeftToRight)
            {
                // this is the same positioning as implementation
                return APIdx;
            }
            else if (d_autoPositioning == Consts.AutoPositioning_AP_TopToBottom)
            {
                // we want
                // 1 3 5
                // 2 4 6
                
                var x:uint, y:uint;
                var done:Boolean = false;
                
                for (x = 0; x < d_gridWidth; ++x)
                {
                    for (y = 0; y < d_gridHeight; ++y)
                    {
                        if (APIdx == 0)
                        {
                            done = true;
                            break;
                        }
                        
                        --APIdx;
                    }
                    
                    if (done)
                    {
                        break;
                    }
                }
                
                //assert(APIdx == 0);
                return mapFromGridToIdx(x, y, d_gridWidth, d_gridHeight);
            }
            
            // should never happen
            //assert(0);
            return APIdx;
        }
        
        //! creates a dummy window
        protected function createDummy():FlameWindow
        {
            var buff:String = d_nextDummyIdx.toString();
            ++d_nextDummyIdx;
            
            var dummy:FlameWindow = FlameWindowManager.getSingleton().createWindow("DefaultWindow",
                getName() + DummyNameSuffix + buff);
            
            dummy.setVisible(false);
            dummy.setSize(new UVector2(new UDim(0, 0), new UDim(0, 0)));
            dummy.setDestroyedByParent(true);
            
            return dummy;
        }
        
        //! checks whether given window is a dummy
        protected function isDummy(wnd:FlameWindow):Boolean
        {
            // all auto windows inside grid are dummies
            return wnd.isAutoWindow();
        }
        
        /// @copydoc Window::addChild_impl
        override protected function addChild_impl(wnd:FlameWindow):void
        {
            if (isDummy(wnd))
            {
                super.addChild_impl(wnd);
            }
            else
            {
                super.addChild_impl(wnd);
                
                // OK, wnd is already in d_children
                
                // idx is the future index of the child that's being added
                var idx:uint;
                
                if (d_autoPositioning == Consts.AutoPositioning_AP_Disabled)
                {
                    if ((d_nextGridX == uint.MAX_VALUE) &&
                        (d_nextGridY == uint.MAX_VALUE))
                    {
                        throw new Error(
                            "GridLayoutContainer::addChild_impl: Unable to add child " +
                            "without explicit grid position because auto positioning is " +
                            "disabled.  Consider using the " +
                            "GridLayoutContainer::addChildWindowToPosition functions.");
                    }
                    
                    idx = mapFromGridToIdx(d_nextGridX, d_nextGridY,
                        d_gridWidth, d_gridHeight);
                    
                    // reset location to sentinel values.
                    d_nextGridX = d_nextGridY = uint.MAX_VALUE;
                }
                else
                {
                    idx = translateAPToGridIdx(d_nextAutoPositioningIdx);
                    ++d_nextAutoPositioningIdx;
                }
                
                // we swap the dummy and the added child
                // this essentially places the added child to it's right position and
                // puts the dummy at the end of d_children it will soon get removed from
                Misc.swap(d_children[idx], d_children[d_children.length - 1]);
                
                var toBeRemoved:FlameWindow = d_children[d_children.length - 1];
                removeChildWindow(toBeRemoved);
                
                if (toBeRemoved.isDestroyedByParent())
                {
                    FlameWindowManager.getSingleton().destroyWindow(toBeRemoved);
                }
            }
        }
        /// @copydoc Window::removeChild_impl
        override protected function removeChild_impl(wnd:FlameWindow):void
        {
            if (!isDummy(wnd) && ! FlameWindowManager.getSingleton().isLocked())
            {
                // before we remove the child, we must add new dummy and place it
                // instead of the removed child
                var dummy:FlameWindow = createDummy();
                addChildWindow(dummy);
                
                const i:uint = getIdxOfChildWindow(wnd);
                Misc.swap(d_children[i], d_children[d_children.length - 1]);
            }
            
            super.removeChild_impl(wnd);
        }
        
        /*!
        \brief
        Return whether this window was inherited from the given class name at
        some point in the inheritance hierarchy.
        
        \param class_name
        The class name that is to be checked.
        
        \return
        true if this window was inherited from \a class_name. false if not.
        */
        override protected function testClassName_impl(class_name:String):Boolean
        {
            if (class_name == "GridLayoutContainer")  return true;
            
            return super.testClassName_impl(class_name);
        }
        
        
        
        private function addGridLayoutContainerProperties():void
        {
            addProperty(d_gridSizeProperty);
            addProperty(d_autoPositioningProperty);
        }

    }
}