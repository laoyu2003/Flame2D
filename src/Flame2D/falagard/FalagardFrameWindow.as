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
    import Flame2D.core.falagard.FalagardComponentArea;
    import Flame2D.core.falagard.FalagardNamedArea;
    import Flame2D.core.falagard.FalagardStateImagery;
    import Flame2D.core.falagard.FalagardWidgetLookFeel;
    import Flame2D.core.system.FlameWindowRenderer;
    import Flame2D.core.utils.Rect;
    import Flame2D.elements.window.FlameFrameWindow;

    /*!
    \brief
    FrameWindow class for the FalagardBase module.
    
    This class requires LookNFeel to be assigned.  The LookNFeel should provide the following:
    
    States:
    - ActiveWithTitleWithFrame
    - InactiveWithTitleWithFrame
    - DisabledWithTitleWithFrame
    - ActiveWithTitleNoFrame
    - InactiveWithTitleNoFrame
    - DisabledWithTitleNoFrame
    - ActiveNoTitleWithFrame
    - InactiveNoTitleWithFrame
    - DisabledNoTitleWithFrame
    - ActiveNoTitleNoFrame
    - InactiveNoTitleNoFrame
    - DisabledNoTitleNoFrame
    
    Named Areas:
    - ClientWithTitleWithFrame
    - ClientWithTitleNoFrame
    - ClientNoTitleWithFrame
    - ClientNoTitleNoFrame
    */
    public class FalagardFrameWindow extends FlameWindowRenderer
    {
        
        public static const TypeName:String = "Falagard/FrameWindow";
        
        public function FalagardFrameWindow(type:String)
        {
            super(type);
        }
        
        override public function render():void
        {
            var w:FlameFrameWindow = d_window as FlameFrameWindow;
            
            if(!w) 
            {
                trace("There must be some error here");
                return;
            }
            
            // do not render anything for the rolled-up state.
            if (w.isRolledup())
                return;
            
            // build state name
            var stateName:String = (w.isDisabled() ? "Disabled" : (w.isActive() ? "Active" : "Inactive"));
            stateName += w.isTitleBarEnabled() ? "WithTitle" : "NoTitle";
            stateName += w.isFrameEnabled() ? "WithFrame" : "NoFrame";
            
            var imagery:FalagardStateImagery;
            
//            try
//            {
                // get WidgetLookFeel for the assigned look.
                const wlf:FalagardWidgetLookFeel = getLookNFeel();
                // try and get imagery for our current state
                imagery = wlf.getStateImagery(stateName);
//            }
//            catch (error:Error)
//            {
//                // log error so we know imagery is missing, and then quit.
//                return;
//            }
//            
            // peform the rendering operation.
            imagery.render(w);
        }
        
        
        override public function getUnclippedInnerRect():Rect
        {
            var w:FlameFrameWindow = d_window as FlameFrameWindow;
            if(!w)
            {
                return new Rect();
            }
            if (w.isRolledup())
                return new Rect(0,0,0,0);
            
            // build name of area to fetch
            var areaName:String = "Client";
            areaName += w.isTitleBarEnabled() ? "WithTitle" : "NoTitle";
            areaName += w.isFrameEnabled() ? "WithFrame" : "NoFrame";
            
            // get WidgetLookFeel for the assigned look.
            const wlf:FalagardWidgetLookFeel = getLookNFeel();
            
            return wlf.getNamedArea(areaName).getArea().getPixelRect2(w, w.getUnclippedOuterRect());
        }
    }
}