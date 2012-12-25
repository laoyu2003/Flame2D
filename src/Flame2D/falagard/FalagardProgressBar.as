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
    import Flame2D.elements.progressbar.FlameProgressBar;
    import Flame2D.core.falagard.FalagardStateImagery;
    import Flame2D.core.falagard.FalagardWidgetLookFeel;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;

    /*!
    \brief
    ProgressBar class for the FalagardBase module.
    
    This class requires LookNFeel to be assigned.  The LookNFeel should provide the following:
    
    States:
    - Enabled
    - Disabled
    - EnabledProgress
    - DisabledProgress
    
    Named Areas:
    - ProgressArea
    
    Property initialiser definitions:
    - VerticalProgress - boolean property.
    Determines whether the progress widget is horizontal or vertical.
    Default is horizontal.  Optional.
    
    - ReversedProgress - boolean property.
    Determines whether the progress grows in the opposite direction to
    what is considered 'usual'.  Set to "True" to have progress grow
    towards the left or bottom of the progress area.  Optional.
    */
    public class FalagardProgressBar extends FlameWindowRenderer
    {
        
        public static const TypeName:String = "Falagard/ProgressBar";
        
        // settings to make this class universal.
        protected var d_vertical:Boolean = false;    //!< True if progress bar operates on the vertical plane.
        protected var d_reversed:Boolean = false;    //!< True if progress grows in the opposite direction to usual (i.e. to the left / downwards).
        
        // property objects
        protected static var d_verticalProperty:FalagardProgressBarPropertyVerticalProgress = new FalagardProgressBarPropertyVerticalProgress();
        protected static var d_reversedProperty:FalagardProgressBarPropertyReversedProgress = new FalagardProgressBarPropertyReversedProgress();
        
        public function FalagardProgressBar(type:String)
        {
            super(type, "ProgressBar");
            
            registerProperty(d_verticalProperty);
            registerProperty(d_reversedProperty);
        }
        
        override public function render():void
        {
            var imagery:FalagardStateImagery;
            
            // get WidgetLookFeel for the assigned look.
            const wlf:FalagardWidgetLookFeel = getLookNFeel();
            // try and get imagery for our current state
            imagery = wlf.getStateImagery(d_window.isDisabled() ? "Disabled" : "Enabled");
            // peform the rendering operation.
            imagery.render(d_window);
            
            // get imagery for actual progress rendering
            imagery = wlf.getStateImagery(d_window.isDisabled() ? "DisabledProgress" : "EnabledProgress");
            
            // get target rect for this imagery
            var progressRect:Rect = wlf.getNamedArea("ProgressArea").getArea().getPixelRect(d_window);
            
            // calculate a clipper according to the current progress.
            var progressClipper:Rect = progressRect.clone();
            
            var w:FlameProgressBar = d_window as FlameProgressBar;
            if (d_vertical)
            {
                var height:Number = Misc.PixelAligned(progressClipper.getHeight() * w.getProgress());
                
                if (d_reversed)
                {
                    progressClipper.setHeight(height);
                }
                else
                {
                    progressClipper.d_top = progressClipper.d_bottom - height;
                }
            }
            else
            {
                var width:Number = Misc.PixelAligned(progressClipper.getWidth() * w.getProgress());
                
                if (d_reversed)
                {
                    progressClipper.d_left = progressClipper.d_right - width;
                }
                else
                {
                    progressClipper.setWidth(width);
                }
            }
            
            // peform the rendering operation.
            imagery.render2(d_window, progressRect, null, progressClipper);
        }
        
        
        public function isVertical():Boolean
        {
            return d_vertical;
        }
        
        public function isReversed():Boolean
        {
            return d_reversed;
        }
        
        public function setVertical(setting:Boolean):void
        {
            d_vertical = setting;
        }
        
        public function setReversed(setting:Boolean):void
        {
            d_reversed = setting;
        }
        
    }
}