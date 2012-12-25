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
    import Flame2D.elements.base.FlameItemEntry;
    import Flame2D.elements.base.ItemEntryWindowRenderer;
    import Flame2D.core.falagard.FalagardStateImagery;
    import Flame2D.core.falagard.FalagardWidgetLookFeel;
    import Flame2D.core.utils.Size;

    /*!
    \brief
    ItemEntry class for the FalagardBase module.
    
    This class requires LookNFeel to be assigned.  The LookNFeel should provide the following:
    
    States:
    - Enabled           - basic rendering for enabled state.
    - Disabled          - basic rendering for disabled state.
    
    Optional states:
    - SelectedEnabled   - basic rendering for enabled and selected state.
    - SelectedDisabled  - basic rendering for disabled and selected state.
    
    You only need to provide the 'Selected' states if the item will be selectable.
    If if the item is selected (which implies that it is selectable) only the SelectedEnabled
    state will be rendered.
    
    Named areas:
    - ContentSize
    */
    public class FalagardItemEntry extends ItemEntryWindowRenderer
    {
        
        public static const TypeName:String = "Falagard/ItemEntry";
        
        public function FalagardItemEntry(type:String)
        {
            super(type);
        }
        
        override public function render():void
        {
            var item:FlameItemEntry = d_window as FlameItemEntry;
            
            // get WidgetLookFeel for the assigned look.
            const wlf:FalagardWidgetLookFeel = getLookNFeel();
            
            var imagery:FalagardStateImagery;
            // render basic imagery
            var state:String = item.isDisabled() ? "Disabled" : "Enabled";
            if (item.isSelectable() && item.isSelected())
            {
                imagery = wlf.getStateImagery(item.isDisabled()?"SelectedDisabled":"SelectedEnabled");
            }
            else
            {
                imagery = wlf.getStateImagery(item.isDisabled()?"Disabled":"Enabled");
            }
            imagery.render(d_window);
        }
        
        override public function getItemPixelSize():Size
        {
            // get WidgetLookFeel for the assigned look.
            const wlf:FalagardWidgetLookFeel = getLookNFeel();
            return wlf.getNamedArea("ContentSize").getArea().getPixelRect(d_window).getSize();
        }
    }
}