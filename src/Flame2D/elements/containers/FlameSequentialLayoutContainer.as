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
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.utils.Misc;
    
    public class FlameSequentialLayoutContainer extends FlameLayoutContainer
    {
        /*************************************************************************
         Event name constants
         *************************************************************************/
        //! Namespace for global events
        public static const EventNamespace:String = "SequentialLayoutContainer";
        
        //! fired when child windows get rearranged
        public static const EventChildWindowOrderChanged:String = "ChildWindowOrderChanged";

        
        /*!
        \brief
        Constructor for Window base class
        
        \param type
        String object holding Window type (usually provided by WindowFactory).
        
        \param name
        String object holding unique name for the Window.
        */
        public function FlameSequentialLayoutContainer(type:String, name:String)
        {
            super(type, name);
        }
     
        /*!
        \brief
        Gets the position of given child window
        */
        public function getPositionOfChildWindow(wnd:FlameWindow):uint
        {
            return getIdxOfChildWindow(wnd);
        }
        
        /*!
        \brief
        Gets the position of given child window
        */
        public function getPositionOfChildWindowByName(wnd:String):uint
        {
            return getPositionOfChildWindow(FlameWindowManager.getSingleton().getWindow(wnd));   
        }
        
        /*!
        \brief
        Gets the child window that currently is at given position
        */
        public function getChildWindowAtPosition(position:uint):FlameWindow
        {
            return getChildAt(position);
        }
        
        /*!
        \brief
        Swaps windows at given positions
        */
        public function swapChildWindowPositions(wnd1:uint, wnd2:uint):void
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
        Swaps positions of given windows
        */
        public function swapChildWindows(wnd1:FlameWindow, wnd2:FlameWindow):void
        {
            if (isChild(wnd1) && isChild(wnd2))
            {
                swapChildWindowPositions(getPositionOfChildWindow(wnd1),
                    getPositionOfChildWindow(wnd2));
            }
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
        public function swapChildWindowsByNames(wnd1:String, wnd2:String):void
        {
            swapChildWindows(FlameWindowManager.getSingleton().getWindow(wnd1),
                FlameWindowManager.getSingleton().getWindow(wnd2));
        }
        
        /*!
        \brief
        Moves a window that is alrady child of thi layout container
        to given position (if the window is currently in a position
        that is smaller than given position, given position is
        automatically decremented
        */
        public function moveChildWindowToPosition(wnd:FlameWindow, position:uint):void
        {
            if (!isChild(wnd))
                return;
            
            position = Math.min(position, d_children.length - 1);
            
            const oldPosition:uint = getPositionOfChildWindow(wnd);
            
            if (oldPosition == position)
            {
                return;
            }
            
            // we get the iterator of the old position
            //ChildList::iterator it = d_children.begin();
            //std::advance(it, oldPosition);
            
            // we are the window from it's old position
            d_children.splice(oldPosition, 1);
            
            // if the window comes before the point we want to insert to,
            // we have to decrement the position
            if (oldPosition < position)
            {
                --position;
            }
            
            // find iterator of the new position
            //it = d_children.begin();
            //std::advance(it, position);
            // and insert the window there
            d_children.splice(position, 0, wnd);
            
            var args:WindowEventArgs = new WindowEventArgs(this);
            onChildWindowOrderChanged(args);
        }
        
        /*!
        \brief
        Moves a window that is alrady child of thi layout container
        to given position (if the window is currently in a position
        that is smaller than given position, given position is
        automatically decremented
        */
        public function moveChildWindowToPositionByName(wnd:String, position:uint):void
        {
            moveChildWindowToPosition(FlameWindowManager.getSingleton().getWindow(wnd),
                position);
        }
        
        /*!
        \brief
        Moves a window forward or backward, depending on delta
        (-1 moves it backward one step, 1 moves it forward one step)
        
        \param delta
        The amount of steps the window will be moved
        (old position + delta = new position)
        */
        public function moveChildWindow(window:FlameWindow, delta:int = 1):void
        {
            const oldPosition:uint = getPositionOfChildWindow(window);
            var newPosition:int = oldPosition + delta;
            newPosition = Math.max(newPosition, 0);
            // this is handled by moveChildWindowToPosition itself
            //newPosition = std::min(newPosition, (int)(d_children.size() - 1));
            
            moveChildWindowToPosition(window, newPosition);
        }
            
        
        /*!
        \brief
        Adds a window to given position
        */
        public function addChildWindowToPosition(window:FlameWindow, position:uint):void
        {
            addChildWindow(window);
            
            moveChildWindowToPosition(window, position);
        }
        
        /*!
        \brief
        Adds a window to given position
        */
        public function addChildWindowToPositionByName(window:String, position:uint):void
        {
            addChildWindowToPosition(FlameWindowManager.getSingleton().getWindow(window),
                position);
        }
        
        /*!
        \brief
        Removes a window from given position
        */
        public function removeChildWindowFromPosition(position:uint):void
        {
            removeChildWindow(getChildWindowAtPosition(position));
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
        
        //! @copydoc Window::testClassName_impl
        override protected function testClassName_impl(class_name:String):Boolean
        {
            if (class_name == "SequentialLayoutContainer")    return true;
            
            return super.testClassName_impl(class_name);
        }
    }
}