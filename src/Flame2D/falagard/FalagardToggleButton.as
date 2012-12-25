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
    import Flame2D.core.properties.FlamePropertyHelper;

    /*!
    \brief
    ToggleButton class for the FalagardBase module.
    
    This class requires LookNFeel to be assigned.  The LookNFeel should provide the following:
    
    States (missing states will default to 'Normal' or 'SelectedNormal' if selected)
    - Normal            - Rendering for when the togglebutton is neither pushed or has the mouse hovering over it.
    - Hover             - Rendering for then the togglebutton has the mouse hovering over it.
    - Pushed            - Rendering for when the togglebutton is not selected, is pushed and has the mouse over it.
    - PushedOff         - Rendering for when the togglebutton is not selected, is pushed and the mouse is not over it.
    - Disabled          - Rendering for when the togglebutton is not selected and is disabled.
    - SelectedNormal    - Rendering for when the togglebutton is selected and is neither pushed or has the mouse hovering over it.
    - SelectedHover     - Rendering for then the togglebutton is selected and has the mouse hovering over it.
    - SelectedPushed    - Rendering for when the togglebutton is selected, is pushed and has the mouse over it.
    - SelectedPushedOff - Rendering for when the togglebutton is selected, is pushed and the mouse is not over it.
    - SelectedDisabled  - Rendering for when the togglebutton is selected and is disabled.
    */
    public class FalagardToggleButton extends FalagardButton
    {
        
        public static const TypeName:String = "Falagard/ToggleButton";
        
        public function FalagardToggleButton(type:String)
        {
            super(type);
        }
        

        
        override public function actualStateName(name:String):String
        {
            var selected:Boolean = FlamePropertyHelper.stringToBool(d_window.getProperty("Selected"));
            return selected ? "Selected"+name : name;
        }
        
    }
}