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
    import Flame2D.elements.base.FlameScrollbar;
    import Flame2D.elements.base.ScrollbarWindowRenderer;
    import Flame2D.elements.thumb.FlameThumb;
    import Flame2D.core.falagard.FalagardStateImagery;
    import Flame2D.core.falagard.FalagardWidgetLookFeel;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.UVector2;
    import Flame2D.core.utils.Vector2;

    /*!
    \brief
    Scrollbar class for the FalagardBase module.
    
    This class requires LookNFeel to be assigned.  The LookNFeel should provide the following:
    
    States:
    - Enabled
    - Disabled
    
    Named Areas:
    - ThumbTrackArea
    
    Child Widgets:
    Thumb based widget with name suffix "__auto_thumb__"
    PushButton based widget with name suffix "__auto_incbtn__"
    PushButton based widget with name suffix "__auto_decbtn__"
    
    Property initialiser definitions:
    - VerticalScrollbar - boolean property.
    Indicates whether this scrollbar will operate in the vertical or
    horizontal direction.  Default is for horizontal.  Optional.
    */
    public class FalagardScrollbar extends ScrollbarWindowRenderer
    {
        
        public static const TypeName:String = "Falagard/Scrollbar";
        
        // property objects
        protected static var d_verticalProperty:FalagardScrollbarPropertyVerticalScrollbar = new FalagardScrollbarPropertyVerticalScrollbar();
        // data members
        protected var d_vertical:Boolean = false;     //!< True if slider operates in vertical direction.

        public function FalagardScrollbar(type:String)
        {
            super(type);
            
            registerProperty(d_verticalProperty);
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
        
        override public function performChildWindowLayout():void
        {
            this.updateThumb();
        }
        
        // overridden from Scrollbar base class.
        override public function updateThumb():void
        {
            var w:FlameScrollbar = d_window as FlameScrollbar;
            const wlf:FalagardWidgetLookFeel = getLookNFeel();
            var area:Rect = wlf.getNamedArea("ThumbTrackArea").getArea().getPixelRect(w);
            
            var theThumb:FlameThumb = w.getThumb();
            
            var posExtent:Number = w.getDocumentSize() - w.getPageSize();
            var slideExtent:Number;
            
            if (d_vertical)
            {
                slideExtent = area.getHeight() - theThumb.getPixelSize().d_height;
                theThumb.setVertRange(area.d_top / w.getPixelSize().d_height, (area.d_top + slideExtent) / w.getPixelSize().d_height);
                theThumb.setPosition(new UVector2(Misc.cegui_absdim(area.d_left),
                    Misc.cegui_reldim((area.d_top + (w.getScrollPosition() * (slideExtent / posExtent))) / w.getPixelSize().d_height)));
            }
            else
            {
                slideExtent = area.getWidth() - theThumb.getPixelSize().d_width;
                theThumb.setHorzRange(area.d_left / w.getPixelSize().d_width, (area.d_left + slideExtent)  / w.getPixelSize().d_width);
                theThumb.setPosition(new UVector2(Misc.cegui_reldim((area.d_left + (w.getScrollPosition() * (slideExtent / posExtent))) / w.getPixelSize().d_width),
                    Misc.cegui_absdim(area.d_top)));
            }
        }
        
        override public function getValueFromThumb():Number
        {
            var w:FlameScrollbar = d_window as FlameScrollbar;
            const wlf:FalagardWidgetLookFeel = getLookNFeel();
            var area:Rect = wlf.getNamedArea("ThumbTrackArea").getArea().getPixelRect(w);
            
            var theThumb:FlameThumb = w.getThumb();
            var posExtent:Number = w.getDocumentSize() - w.getPageSize();
            var slideExtent:Number;
            
            if (d_vertical)
            {
                slideExtent = area.getHeight() - theThumb.getPixelSize().d_height;
                return (theThumb.getYPosition().asAbsolute(w.getPixelSize().d_height) - area.d_top) / (slideExtent / posExtent);
            }
            else
            {
                slideExtent = area.getWidth() - theThumb.getPixelSize().d_width;
                return (theThumb.getXPosition().asAbsolute(w.getPixelSize().d_width) - area.d_left) / (slideExtent / posExtent);
            }
        }
        
        override public function getAdjustDirectionFromPoint(pt:Vector2):Number
        {
            var w:FlameScrollbar = d_window as FlameScrollbar;
            var absrect:Rect = w.getThumb().getUnclippedOuterRect();
            
            if ((d_vertical && (pt.d_y > absrect.d_bottom)) ||
                (!d_vertical && (pt.d_x > absrect.d_right)))
            {
                return 1;
            }
            else if ((d_vertical && (pt.d_y < absrect.d_top)) ||
                (!d_vertical && (pt.d_x < absrect.d_left)))
            {
                return -1;
            }
            else
            {
                return 0;
            }
        }
        
        
    }
}