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
    import Flame2D.elements.base.FlameScrollbar;
    import Flame2D.elements.list.FlameListHeader;
    import Flame2D.elements.list.FlameMultiColumnList;
    import Flame2D.elements.list.MCLGridRef;
    import Flame2D.elements.list.MultiColumnListWindowRenderer;
    import Flame2D.elements.listbox.FlameListboxItem;

    /*!
    \brief
    MultiColumnList class for the FalagardBase module.
    
    This class requires LookNFeel to be assigned.  The LookNFeel should provide the following:
    
    States:
    - Enabled
    - Disabled
    
    Named Areas:
    - ItemRenderingArea         - area where items will be drawn when no scrollbars are visible.
    - ItemRenderingAreaHScroll  - area where items will be drawn when the horizontal scrollbar is visible.
    - ItemRenderingAreaVScroll  - area where items will be drawn when the vertical scrollbar is visible.
    - ItemRenderingAreaHVScroll - area where items will be drawn when both scrollbars are visible.
    
    Child Widgets:
    Scrollbar based widget with name suffix "__auto_vscrollbar__"
    Scrollbar based widget with name suffix "__auto_hscrollbar__"
    ListHeader based widget with name suffix "__auto_listheader__"
    */
    public class FalagardMultiColumnList extends MultiColumnListWindowRenderer
    {
        
        public static const TypeName:String = "Falagard/MultiColumnList";
        
        public function FalagardMultiColumnList(type:String)
        {
            super(type);
        }
        
        override public function render():void
        {
            var w:FlameMultiColumnList = d_window as FlameMultiColumnList;
            const header:FlameListHeader = w.getListHeader();
            const vertScrollbar:FlameScrollbar = w.getVertScrollbar();
            const horzScrollbar:FlameScrollbar = w.getHorzScrollbar();
            
            // render general stuff before we handle the items
            cacheListboxBaseImagery();
            
            //
            // Render list items
            //
            var itemPos:Vector3 = new Vector3();
            var itemSize:Size = new Size();
            var itemClipper:Rect, itemRect:Rect = new Rect();
            
            // calculate position of area we have to render into
            var itemsArea:Rect = getListRenderArea();
            
            // set up initial positional details for items
            itemPos.y = itemsArea.d_top - vertScrollbar.getScrollPosition();
            itemPos.z = 0.0;
            
            var alpha:Number = w.getEffectiveAlpha();
            
            // loop through the items
            for (var i:uint = 0; i < w.getRowCount(); ++i)
            {
                // set initial x position for this row.
                itemPos.x = itemsArea.d_left - horzScrollbar.getScrollPosition();
                
                // calculate height for this row.
                itemSize.d_height = w.getHighestRowItemHeight(i);
                
                // loop through the columns in this row
                for (var j:uint = 0; j < w.getColumnCount(); ++j)
                {
                    // allow item to use full width of the column
                    itemSize.d_width = header.getColumnWidth(j).asAbsolute(header.getPixelSize().d_width);
                    
                    var item:FlameListboxItem = w.getItemAtGridReference(new MCLGridRef(i,j));
                    
                    // is the item for this column set?
                    if (item)
                    {
                        // calculate destination area for this item.
                        itemRect.d_left = itemPos.x;
                        itemRect.d_top  = itemPos.y;
                        itemRect.setSize(itemSize);
                        itemClipper = itemRect.getIntersection(itemsArea);
                        
                        // skip this item if totally clipped
                        if (itemClipper.getWidth() == 0)
                        {
                            itemPos.x += itemSize.d_width;
                            continue;
                        }
                        
                        // draw this item
                        item.draw(w.getGeometryBuffer(), itemRect, alpha, itemClipper);
                    }
                    
                    // update position for next column.
                    itemPos.x += itemSize.d_width;
                }
                
                // update position ready for next row
                itemPos.y += itemSize.d_height;
            }
        }
        
        /*!
        \brief
        Perform rendering of the widget control frame and other 'static'
        areas.  This method should not render the actual items.  Note that
        the items are typically rendered to layer 3, other layers can be
        used for rendering imagery behind and infront of the items.
        
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
        
        // overridden from MultiColumnList base class.
        override public function getListRenderArea():Rect
        {
            var w:FlameMultiColumnList = d_window as FlameMultiColumnList;
            // get WidgetLookFeel for the assigned look.
            const wlf:FalagardWidgetLookFeel = getLookNFeel();
            var v_visible:Boolean = w.getVertScrollbar().isVisible(true);
            var h_visible:Boolean = w.getHorzScrollbar().isVisible(true);
            
            // if either of the scrollbars are visible, we might want to use another item rendering area
            if (v_visible || h_visible)
            {
                var area_name:String = "ItemRenderingArea";
                
                if (h_visible)
                {
                    area_name += "H";
                }
                if (v_visible)
                {
                    area_name += "V";
                }
                area_name += "Scroll";
                
                if (wlf.isNamedAreaDefined(area_name))
                {
                    return wlf.getNamedArea(area_name).getArea().getPixelRect(w);
                }
            }
            
            // default to plain ItemRenderingArea
            return wlf.getNamedArea("ItemRenderingArea").getArea().getPixelRect(w);
        }

    }
}