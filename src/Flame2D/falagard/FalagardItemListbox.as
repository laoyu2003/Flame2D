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
    import Flame2D.elements.base.FlameItemListbox;
    import Flame2D.elements.base.ItemListBaseWindowRenderer;
    import Flame2D.core.falagard.FalagardStateImagery;
    import Flame2D.core.falagard.FalagardWidgetLookFeel;
    import Flame2D.core.utils.CoordConverter;
    import Flame2D.core.utils.Rect;

    /*!
    \brief
    ItemListbox class for the FalagardBase module.
    
    This class requires LookNFeel to be assigned.  The LookNFeel should provide the following:
    
    States:
    - Enabled
    - Disabled
    
    Named Areas:
    ItemRenderArea
    ItemRenderAreaHScroll
    ItemRenderAreaVScroll
    ItemRenderAreaHVScroll
    */
    public class FalagardItemListbox extends ItemListBaseWindowRenderer
    {
        
        public static const TypeName:String = "Falagard/ItemListbox";
        
        
        //! flag whether target window has looknfeel assigned yet.
        protected var d_widgetLookAssigned:Boolean = false;
        
        public function FalagardItemListbox(type:String)
        {
            super(type);
        }
        
        // overridden from ItemListBaseWindowRenderer base class.
        override public function render():void
        {
            var imagery:FalagardStateImagery;
            
            // get WidgetLookFeel for the assigned look.
            const wlf:FalagardWidgetLookFeel = getLookNFeel();
            // try and get imagery for our current state
            imagery = wlf.getStateImagery(d_window.isDisabled() ? "Disabled" : "Enabled");
            // peform the rendering operation.
            imagery.render(d_window);
        }
        
        
        override public function getItemRenderArea():Rect
        {
            var lb:FlameItemListbox = d_window as FlameItemListbox;
            
            // get WidgetLookFeel for the assigned look.
            const wlf:FalagardWidgetLookFeel = getLookNFeel();
            var v_visible:Boolean = lb.getVertScrollbar().isVisible(true);
            var h_visible:Boolean = lb.getHorzScrollbar().isVisible(true);
            
            // if either of the scrollbars are visible, we might want to use another text rendering area
            if (v_visible || h_visible)
            {
                var area_name:String = "ItemRenderArea";
                
                if (h_visible)
                {
                    area_name += 'H';
                }
                if (v_visible)
                {
                    area_name += 'V';
                }
                area_name += "Scroll";
                
                if (wlf.isNamedAreaDefined(area_name))
                {
                    return wlf.getNamedArea(area_name).getArea().getPixelRect(lb);
                }
            }
            
            // default to plain ItemRenderArea
            return wlf.getNamedArea("ItemRenderArea").getArea().getPixelRect(lb);
        }
        
        // overridden from WindowRenderer base class.
        override public function getUnclippedInnerRect():Rect
        {
            if (!d_widgetLookAssigned)
                return d_window.getUnclippedOuterRect();
            
            const lr:Rect = getItemRenderArea();
            return CoordConverter.windowToScreenForRect(d_window, lr);
        }
        
        // overridden from WindowRenderer base class.
        override public function onLookNFeelAssigned():void
        {
            d_widgetLookAssigned = true;
        }
        
        override public function onLookNFeelUnassigned():void
        {
            d_widgetLookAssigned = false;
        }
        

        
    }
}