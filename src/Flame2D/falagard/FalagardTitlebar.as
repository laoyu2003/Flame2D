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
    import Flame2D.core.falagard.FalagardStateImagery;
    import Flame2D.core.falagard.FalagardWidgetLookFeel;

    /*!
    \brief
    Titlebar class for the FalagardBase module.
    
    This class requires LookNFeel to be assigned.  The LookNFeel should provide the following:
    
    States:
    - Active
    - Inactive
    - Disabled
    */
    public class FalagardTitlebar extends FlameWindowRenderer
    {
        
        public static const TypeName:String = "Falagard/Titlebar";
        
        public function FalagardTitlebar(type:String)
        {
            super(type, "Titlebar");
        }
        
        override public function render():void
        {
            var imagery:FalagardStateImagery;
            
            try
            {
                // get WidgetLookFeel for the assigned look.
                const wlf:FalagardWidgetLookFeel = getLookNFeel();
                // try and get imagery for our current state
                if (!d_window.isDisabled())
                    imagery = wlf.getStateImagery((d_window.getParent() && d_window.getParent().isActive()) ? "Active" : "Inactive");
                else
                    imagery = wlf.getStateImagery("Disabled");
            }
            catch (error:Error)
            {
                // log error so we know imagery is missing, and then quit.
                return;
            }
            
            // peform the rendering operation.
            imagery.render(d_window);
        }
        
    }
}