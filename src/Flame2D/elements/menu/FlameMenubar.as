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
    import Flame2D.core.data.Consts;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.URect;
    import Flame2D.core.utils.UVector2;
    
    public class FlameMenubar extends FlameMenuBase
    {
        public static const EventNamespace:String = "Menubar";
        public static const WidgetTypeName:String = "CEGUI/Menubar";
        
        
        /*************************************************************************
         Construction and Destruction
         *************************************************************************/
        /*!
        \brief
        Constructor for Menubar objects
        */
        public function FlameMenubar(type:String, name:String)
        {
            super(type, name);
            
            d_itemSpacing = 10;
        }

        
        
        
        /*************************************************************************
         Implementation Functions
         *************************************************************************/
        /*!
        \brief
        Setup size and position for the item widgets attached to this Menubar
        
        \return
        Nothing.
        */
        override protected function layoutItemWidgets():void
        {
            var render_rect:Rect = getItemRenderArea();
            var x0:Number = Misc.PixelAligned(render_rect.d_left);
            
            var rect:URect = new URect();
            
            for(var i:uint=0; i<d_listItems.length; i++)
            {
                const optimal:Size = d_listItems[i].getItemPixelSize();
                
                d_listItems[i].setVerticalAlignment(Consts.VerticalAlignment_VA_CENTRE);
                rect.setPosition(new UVector2(Misc.cegui_absdim(x0), Misc.cegui_absdim(0)) );
                rect.setSize(new UVector2( Misc.cegui_absdim(Misc.PixelAligned(optimal.d_width)),
                    Misc.cegui_absdim(Misc.PixelAligned(optimal.d_height))));
                
                d_listItems[i].setArea(rect.d_min, rect.d_max);
                
                x0 += optimal.d_width + d_itemSpacing;
            }
        }
        
        
        /*!
        \brief
        Returns the Size in unclipped pixels of the content attached to this ItemListBase that is attached to it.
        
        \return
        Size object describing in unclipped pixels the size of the content ItemEntries attached to this menu.
        */
        override protected function getContentSize():Size
        {
            // find the content sizes
            var tallest:Number = 0;
            var total_width:Number = 0;
            
            var i:uint = 0;
            var max:uint = d_listItems.length;
            while (i < max)
            {
                const sz:Size = d_listItems[i].getItemPixelSize();
                if (sz.d_height > tallest)
                    tallest = sz.d_height;
                total_width += sz.d_width;
                
                i++;
            }
            
            const count:Number = Number(i);
            
            // horz item spacing
            if (count >= 2)
            {
                total_width += (count-1)*d_itemSpacing;
            }
            
            // return the content size
            return new Size(total_width, tallest);
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
            if (class_name=="Menubar")	return true;
            return super.testClassName_impl(class_name);
        }
    }
}