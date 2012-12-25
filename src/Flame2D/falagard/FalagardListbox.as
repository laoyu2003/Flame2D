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
package Flame2D.falagard
{
    import Flame2D.core.falagard.FalagardStateImagery;
    import Flame2D.core.falagard.FalagardWidgetLookFeel;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.Vector3;
    import Flame2D.elements.listbox.FlameListbox;
    import Flame2D.elements.listbox.FlameListboxItem;
    import Flame2D.elements.listbox.ListboxWindowRenderer;

    /*!
    \brief
    Listbox class for the FalagardBase module.
    
    This class requires LookNFeel to be assigned.  The LookNFeel should provide the following:
    
    States:
    - Enabled
    - Disabled
    
    Named Areas:
    - ItemRenderingArea
    - ItemRenderingAreaHScroll
    - ItemRenderingAreaVScroll
    - ItemRenderingAreaHVScroll
    
    Child Widgets:
    Scrollbar based widget with name suffix "__auto_vscrollbar__"
    Scrollbar based widget with name suffix "__auto_hscrollbar__"
    */
    public class FalagardListbox extends ListboxWindowRenderer
    {
        
        public static const TypeName:String = "Falagard/Listbox";
        
        public function FalagardListbox(type:String)
        {
            super(type);
        }
        
        override public function render():void
        {
            var lb:FlameListbox = d_window as FlameListbox;
            // render frame and stuff before we handle the items
            cacheListboxBaseImagery();
            
            //
            // Render list items
            //
            var itemPos:Vector3 = new Vector3();
            var itemSize:Size = new Size();
            var itemClipper:Rect;
            var itemRect:Rect = new Rect();
            var widest:Number = lb.getWidestItemWidth();
            
            // calculate position of area we have to render into
            var itemsArea:Rect = getListRenderArea();
            
            // set up some initial positional details for items
            itemPos.x = itemsArea.d_left - lb.getHorzScrollbar().getScrollPosition();
            itemPos.y = itemsArea.d_top - lb.getVertScrollbar().getScrollPosition();
            itemPos.z = 0.0;
            
            var alpha:Number = lb.getEffectiveAlpha();
            
            // loop through the items
            var itemCount:uint = lb.getItemCount();
            
            for (var i:uint = 0; i < itemCount; ++i)
            {
                var listItem:FlameListboxItem = lb.getListboxItemFromIndex(i);
                itemSize.d_height = listItem.getPixelSize().d_height;
                
                // allow item to have full width of box if this is wider than items
                itemSize.d_width = Math.max(itemsArea.getWidth(), widest);
                
                // calculate destination area for this item.
                itemRect.d_left = itemPos.x;
                itemRect.d_top  = itemPos.y;
                itemRect.setSize(itemSize);
                itemClipper = itemRect.getIntersection(itemsArea);
                
                // skip this item if totally clipped
                if (itemClipper.getWidth() == 0)
                {
                    itemPos.y += itemSize.d_height;
                    continue;
                }
                
                // draw this item
                listItem.draw(lb.getGeometryBuffer(), itemRect, alpha, itemClipper);
                
                // update position ready for next item
                itemPos.y += itemSize.d_height;
            }

        }
        
        /*!
        \brief
        Perform caching of the widget control frame and other 'static' areas.  This
        method should not render the actual items.  Note that the items are typically
        rendered to layer 3, other layers can be used for rendering imagery behind and
        infront of the items.
        
        \return
        Nothing.
        */
        public function cacheListboxBaseImagery():void
        {
            var imagery:FalagardStateImagery;
            
            // get WidgetLookFeel for the assigned look.
            const wlf:FalagardWidgetLookFeel = getLookNFeel();
            // try and get imagery for our current state
            imagery = wlf.getStateImagery(d_window.isDisabled() ? "Disabled" : "Enabled");
            // peform the rendering operation.
            imagery.render(d_window);
        }
        

        override public function getListRenderArea():Rect
        {
            var lb:FlameListbox = d_window as FlameListbox;
            // get WidgetLookFeel for the assigned look.
            const wlf:FalagardWidgetLookFeel = getLookNFeel();
            var v_visible:Boolean = lb.getVertScrollbar().isVisible(true);
            var h_visible:Boolean= lb.getHorzScrollbar().isVisible(true);
            
            // if either of the scrollbars are visible, we might want to use another text rendering area
            if (v_visible || h_visible)
            {
                var area_name:String = "ItemRenderingArea";
                
                if (h_visible)
                    area_name += "H";
                if (v_visible)
                    area_name += "V";
                area_name += "Scroll";
                
                if (wlf.isNamedAreaDefined(area_name))
                    return wlf.getNamedArea(area_name).getArea().getPixelRect(lb);
                
                // since that did not exist, try optional alternative base name
                area_name = "ItemRenderArea";
                if (h_visible)
                    area_name += "H";
                if (v_visible)
                    area_name += "V";
                area_name += "Scroll";
                
                if (wlf.isNamedAreaDefined(area_name))
                    return wlf.getNamedArea(area_name).getArea().getPixelRect(lb);
            }
            
            // default to plain ItemRenderingArea
            if (wlf.isNamedAreaDefined("ItemRenderingArea"))
                return wlf.getNamedArea("ItemRenderingArea").getArea().getPixelRect(lb);
            else
                return wlf.getNamedArea("ItemRenderArea").getArea().getPixelRect(lb);
        }
    }
}