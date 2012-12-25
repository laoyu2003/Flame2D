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
    import Flame2D.core.system.FlameWindowRenderer;
    import Flame2D.core.data.Consts;
    import Flame2D.elements.tab.FlameTabButton;
    import Flame2D.elements.tab.FlameTabControl;
    import Flame2D.core.falagard.FalagardWidgetLookFeel;

    /*!
    \brief
    TabButton class for the FalagardBase module.
    
    This class requires LookNFeel to be assigned.  The LookNFeel should provide the following:
    
    States (missing states will default to 'Normal'):
    - Normal    - Rendering for when the tab button is neither selected nor has the mouse hovering over it.
    - Hover     - Rendering for then the tab button has the mouse hovering over it.
    - Selected  - Rendering for when the tab button is the button for the selected tab.
    - Disabled  - Rendering for when the tab button is disabled.
    */
    public class FalagardTabButton extends FlameWindowRenderer
    {
        
        public static const TypeName:String = "Falagard/TabButton";
        
        public function FalagardTabButton(type:String)
        {
            super(type, "TabButton");
        }
        
        override public function render():void
        {
            var w:FlameTabButton = d_window as FlameTabButton;
            // get WidgetLookFeel for the assigned look.
            const wlf:FalagardWidgetLookFeel = getLookNFeel();
            
            var tc:FlameTabControl = (w.getParent().getParent()) as FlameTabControl;
            
            var state:String;
            var prefix:String = (tc.getTabPanePosition() == Consts.TabPanePosition_Top) ? "Top" : "Bottom";
            
            if (w.isDisabled())
                state = "Disabled";
            else if (w.isSelected())
                state = "Selected";
            else if (w.isPushed())
                state = "Pushed";
            else if (w.isHovering())
                state = "Hover";
            else
                state = "Normal";
            
            if (!wlf.isStateImageryPresent(prefix + state))
            {
                state = "Normal";
                if (!wlf.isStateImageryPresent(prefix + state))
                    prefix = "";
            }
            
            wlf.getStateImagery(prefix + state).render(w);
        }
        
    }
}