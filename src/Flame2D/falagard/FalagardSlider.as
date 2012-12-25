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
    import Flame2D.elements.slider.FlameSlider;
    import Flame2D.elements.slider.SliderWindowRenderer;
    import Flame2D.elements.thumb.FlameThumb;
    import Flame2D.core.falagard.FalagardStateImagery;
    import Flame2D.core.falagard.FalagardWidgetLookFeel;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.UVector2;
    import Flame2D.core.utils.Vector2;

    /*!
    \brief
    Slider class for the FalagardBase module.
    
    This class requires LookNFeel to be assigned.  The LookNFeel should provide the following:
    
    States:
    - Enabled
    - Disabled
    
    Named Areas:
    - ThumbTrackArea
    
    Child Widgets:
    Thumb based widget with name suffix "__auto_thumb__"
    
    Property initialiser definitions:
    - VerticalSlider - boolean property.
    Indicates whether this slider will operate in the vertical or
    horizontal direction.  Default is for horizontal.  Optional.
    */
    public class FalagardSlider extends SliderWindowRenderer
    {
        public static const TypeName:String = "Falagard/Slider";

        // property objects
        protected static var d_verticalProperty:FalagardSliderPropertyVerticalSlider = new FalagardSliderPropertyVerticalSlider();
        protected static var d_reversedProperty:FalagardSliderPropertyReversedDirection = new FalagardSliderPropertyReversedDirection();
        
        // data members
        protected var d_vertical:Boolean = false;     //!< True if slider operates in vertical direction.
        protected var d_reversed:Boolean = false;     //!< true if slider operates in reversed direction to 'normal'.
        
        
        public function FalagardSlider(type:String)
        {
            super(type);
            
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
        }
        
        public function isVertical():Boolean
        {
            return d_vertical;
        }
        
        public function setVertical(setting:Boolean):void
        {
            d_vertical = setting;
        }
        
        public function isReversedDirection():Boolean
        {
            return d_reversed;
        }
        
        public function setReversedDirection(setting:Boolean):void
        {
            d_reversed = setting;
        }
        
        override public function performChildWindowLayout():void
        {
            updateThumb();
        }
        
        // overridden from Slider base class.
        override public function updateThumb():void
        {
            var w:FlameSlider = d_window as FlameSlider;
            // get area the thumb is supposed to use as it's area.
            const wlf:FalagardWidgetLookFeel = getLookNFeel();
            var area:Rect = wlf.getNamedArea("ThumbTrackArea").getArea().getPixelRect(w);
            // get accesss to the thumb
            var theThumb:FlameThumb = w.getThumb();
            
            const w_pixel_size:Size = w.getPixelSize();
            
            var thumbRelXPos:Number = w_pixel_size.d_width == 0.0 ? 0.0 : (area.d_left / w_pixel_size.d_width);
            var thumbRelYPos:Number = w_pixel_size.d_height == 0.0 ? 0.0 : (area.d_top / w_pixel_size.d_height);
            // get base location for thumb widget
            var thumbPosition:UVector2 = new UVector2(Misc.cegui_reldim(thumbRelXPos), Misc.cegui_reldim(thumbRelYPos));
            
            var slideExtent:Number;
            var thumbOffset:Number;
            
            // Is this a vertical slider
            if (d_vertical)
            {
                // pixel extent of total available area the thumb moves in
                slideExtent = area.getHeight() - theThumb.getPixelSize().d_height;
                
                // Set range of motion for the thumb widget
                if (w_pixel_size.d_height != 0.0)
                    theThumb.setVertRange(area.d_top  / w_pixel_size.d_height,
                        (area.d_top + slideExtent) / w_pixel_size.d_height);
                else
                    theThumb.setVertRange(0.0, 0.0);
                
                // calculate vertical positon for thumb
                thumbOffset = w.getCurrentValue() * (slideExtent / w.getMaxValue());
                
                if (w_pixel_size.d_height != 0.0)
                    thumbPosition.d_y.d_scale +=
                        (d_reversed ? thumbOffset : slideExtent - thumbOffset) / w_pixel_size.d_height;
            }
                // Horizontal slider
            else
            {
                // pixel extent of total available area the thumb moves in
                slideExtent = area.getWidth() - theThumb.getPixelSize().d_width;
                
                // Set range of motion for the thumb widget
                if (w_pixel_size.d_width != 0.0)
                    theThumb.setHorzRange(area.d_left / w_pixel_size.d_width,
                        (area.d_left + slideExtent) / w_pixel_size.d_width);
                else
                    theThumb.setHorzRange(0.0, 0.0);
                
                
                // calculate horizontal positon for thumb
                thumbOffset = w.getCurrentValue() * (slideExtent / w.getMaxValue());
                
                if (w_pixel_size.d_width != 0.0)
                    thumbPosition.d_x.d_scale +=
                        (d_reversed ? slideExtent - thumbOffset : thumbOffset)  / w_pixel_size.d_width;
            }
            
            // set new position for thumb.
            theThumb.setPosition(thumbPosition);
        }
        
        
        override public function getValueFromThumb():Number
        {
            var w:FlameSlider = d_window as FlameSlider;
            // get area the thumb is supposed to use as it's area.
            const wlf:FalagardWidgetLookFeel = getLookNFeel();
            var area:Rect = wlf.getNamedArea("ThumbTrackArea").getArea().getPixelRect(w);
            // get accesss to the thumb
            var theThumb:FlameThumb = w.getThumb();
            
            var slideExtent:Number;
            var thumbValue:Number;
            
            // slider is vertical
            if (d_vertical)
            {
                // pixel extent of total available area the thumb moves in
                slideExtent = area.getHeight() - theThumb.getPixelSize().d_height;
                // calculate value represented by current thumb position
                thumbValue = (theThumb.getYPosition().asAbsolute(w.getPixelSize().d_height) - area.d_top) / (slideExtent / w.getMaxValue());
                // return final thumb value according to slider settings
                return d_reversed ? thumbValue : w.getMaxValue() - thumbValue;
            }
                // slider is horizontal
            else
            {
                // pixel extent of total available area the thumb moves in
                slideExtent = area.getWidth() - theThumb.getPixelSize().d_width;
                // calculate value represented by current thumb position
                thumbValue = (theThumb.getXPosition().asAbsolute(w.getPixelSize().d_width) - area.d_left) / (slideExtent / w.getMaxValue());
                // return final thumb value according to slider settings
                return d_reversed ? w.getMaxValue() - thumbValue : thumbValue;
            }
        }
        
        override public function getAdjustDirectionFromPoint(pt:Vector2):Number
        {
            var w:FlameSlider = d_window as FlameSlider;
            var absrect:Rect = w.getThumb().getUnclippedOuterRect();
            
            if ((d_vertical && (pt.d_y < absrect.d_top)) ||
                (!d_vertical && (pt.d_x > absrect.d_right)))
            {
                return d_reversed ? -1.0 : 1.0;
            }
            else if ((d_vertical && (pt.d_y > absrect.d_bottom)) ||
                (!d_vertical && (pt.d_x < absrect.d_left)))
            {
                return d_reversed ? 1.0 : -1.0;
            }
            else
            {
                return 0;
            }
        }
        

        
    }
}