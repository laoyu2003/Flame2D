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
    import Flame2D.elements.button.FlameButtonBase;
    import Flame2D.core.falagard.FalagardWidgetLookFeel;
    
    /*!
    \brief
    Button class for the FalagardBase module.
    
    This class requires LookNFeel to be assigned.  The LookNFeel should provide the following:
    
    States (missing states will default to 'Normal'):
    - Normal    - Rendering for when the button is neither pushed or has the mouse hovering over it.
    - Hover     - Rendering for then the button has the mouse hovering over it.
    - Pushed    - Rendering for when the button is pushed and mouse is over it.
    - PushedOff - Rendering for when the button is pushed and mouse is not over it.
    - Disabled  - Rendering for when the button is disabled.
    */
    public class FalagardButton extends FlameWindowRenderer
    {
        
        public static const TypeName:String = "Falagard/Button";
        
        public function FalagardButton(type:String)
        {
            super(type);
        }
        
        override public function render():void
        {
            var w:FlameButtonBase = d_window as FlameButtonBase;
            if(!w)
            {
                trace("There must be some error!");
                return;
            }
            
            const wlf:FalagardWidgetLookFeel = getLookNFeel();
            
            var norm:Boolean = false;
            var state:String;
            
            if (w.isDisabled())
            {
                state = "Disabled";
            }
            else if (w.isPushed())
            {
                state = w.isHovering() ? "Pushed" : "PushedOff";
            }
            else if (w.isHovering())
            {
                state = "Hover";
            }
            else
            {
                state = "Normal";
                norm = true;
            }
            
            if (!norm && !wlf.isStateImageryPresent(state))
            {
                state = "Normal";
            }
            
            wlf.getStateImagery(actualStateName(state)).render(w);
            
        }

        public function actualStateName(name:String):String
        {
            return name;
        }
    }
}