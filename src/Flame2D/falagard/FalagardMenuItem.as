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
    import Flame2D.core.system.FlameWindow;
    import Flame2D.elements.base.ItemEntryWindowRenderer;
    import Flame2D.elements.menu.FlameMenuItem;
    import Flame2D.core.falagard.FalagardNamedArea;
    import Flame2D.core.falagard.FalagardStateImagery;
    import Flame2D.core.falagard.FalagardWidgetLookFeel;
    import Flame2D.core.utils.Size;

    /*!
    \brief
    MenuItem class for the FalagardBase module.
    
    This class requires LookNFeel to be assigned.  The LookNFeel should provide the following:
    
    States (missing states will default to '***Normal'):
    - EnabledNormal
    - EnabledHover
    - EnabledPushed
    - EnabledPushedOff
    - EnabledPopupOpen
    - DisabledNormal
    - DisabledHover
    - DisabledPushed
    - DisabledPushedOff
    - DisabledPopupOpen
    - PopupClosedIcon   - Additional state drawn when item has a pop-up attached (in closed state)
    - PopupOpenIcon     - Additional state drawn when item has a pop-up attached (in open state)
    
    Named Areas:
    ContentSize
    HasPopupContentSize
    */
    public class FalagardMenuItem extends ItemEntryWindowRenderer
    {
        
        public static const TypeName:String = "Falagard/MenuItem";
        
        public function FalagardMenuItem(type:String)
        {
            super(type);
        }
        
        override public function render():void
        {
            var w:FlameMenuItem = d_window as FlameMenuItem;
            // build name of state we're in
            var stateName:String = (w.isDisabled() ? "Disabled" : "Enabled");
            
            var suffix:String;
            
            // only show opened imagery if the menu items popup window is not closing
            // (otherwise it might look odd)
            if (w.isOpened() && !(w.hasAutoPopup() && w.isPopupClosing()))
                suffix = "PopupOpen";
            else if (w.isPushed())
                suffix = w.isHovering() ? "Pushed" : "PushedOff";
            else if (w.isHovering())
                suffix = "Hover";
            else
                suffix = "Normal";
            
            var imagery:FalagardStateImagery;
            // get WidgetLookFeel for the assigned look.
            const wlf:FalagardWidgetLookFeel = getLookNFeel();
            
            // try and get imagery for our current state
            if (wlf.isStateImageryPresent(stateName + suffix))
            {
                imagery = wlf.getStateImagery(stateName + suffix);
            }
            else
            {
                imagery = wlf.getStateImagery(stateName + "Normal");
            }
            
            // peform the rendering operation.
            imagery.render(w);
            
            // only draw popup-open/closed-icon if we have a popup menu, and parent is not a menubar
            var parent_window:FlameWindow = w.getParent();
            var not_menubar:Boolean = (!parent_window) ? true : !parent_window.testClassName("Menubar");
            
            if (w.getPopupMenu() && not_menubar)
            {
                // get imagery for popup open/closed state
                imagery = wlf.getStateImagery(w.isOpened() ? "PopupOpenIcon" : "PopupClosedIcon");
                // peform the rendering operation.
                imagery.render(w);
            }
        }
        
        override public function getItemPixelSize():Size
        {
            var w:FlameMenuItem = d_window as FlameMenuItem;
            var parent:FlameWindow = w.getParent();
            var not_menubar:Boolean = (!parent) ? true : !parent.testClassName("Menubar");
            const wlf:FalagardWidgetLookFeel = getLookNFeel();
            var area:FalagardNamedArea;
            
            if (w.getPopupMenu() && not_menubar && wlf.isNamedAreaDefined("HasPopupContentSize"))
            {
                area = wlf.getNamedArea("HasPopupContentSize");
            }
            else
            {
                area = wlf.getNamedArea("ContentSize");
            }
            
            return area.getArea().getPixelRect(w).getSize();
        }
    }
}