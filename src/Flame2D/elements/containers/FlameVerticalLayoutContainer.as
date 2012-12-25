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
    import Flame2D.core.utils.UDim;
    import Flame2D.core.utils.UVector2;

    /*!
    \brief
    A Layout Container window layouting it's children vertically
    */
    public class FlameVerticalLayoutContainer extends FlameSequentialLayoutContainer
    {
        
        public static const WidgetTypeName:String = "VerticalLayoutContainer";
        
 
        /*************************************************************************
         Construction and Destruction
         *************************************************************************/
        /*!
        \brief
        Constructor for GUISheet windows.
        */
        public function FlameVerticalLayoutContainer(type:String, name:String)
        {
            super(type, name);
        }

        
        //! @copydoc LayoutContainer::layout
        override public function layout():void
        {
            // used to compare UDims
            const absWidth:Number = getChildWindowContentArea().getWidth();
            
            // this is where we store the top offset
            // we continually increase this number as we go through the windows
            var topOffset:UDim = new UDim(0, 0);
            var layoutWidth:UDim = new UDim(0, 0);
            
            for(var i:uint = 0; i < d_children.length; i++)
            {
                var window:FlameWindow = d_children[i];
                
                const offset:UVector2 = getOffsetForWindow(window);
                const boundingSize:UVector2 = getBoundingSizeForWindow(window);
                
                // full child window width, including margins
                const childWidth:UDim = boundingSize.d_x;
                
                if (layoutWidth.asAbsolute(absWidth) < childWidth.asAbsolute(absWidth))
                {
                    layoutWidth = childWidth;
                }
                
                window.setPosition(offset.add(new UVector2(new UDim(0, 0), topOffset)));
                topOffset = topOffset.add(boundingSize.d_y);
            }
            
            setSize(new UVector2(layoutWidth, topOffset));
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
            if (class_name == "VerticalLayoutContainer")  return true;
            
            return super.testClassName_impl(class_name);
        }
    }
}