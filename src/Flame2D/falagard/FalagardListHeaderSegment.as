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
    import Flame2D.core.data.Consts;
    import Flame2D.core.falagard.FalagardStateImagery;
    import Flame2D.core.falagard.FalagardWidgetLookFeel;
    import Flame2D.core.system.FlameWindowRenderer;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.elements.list.FlameListHeaderSegment;
    
    public class FalagardListHeaderSegment extends FlameWindowRenderer
    {
        
        public static const TypeName:String = "Falagard/ListHeaderSegment";
        
        public function FalagardListHeaderSegment(type:String)
        {
            super(type);
        }
        
        override public function render():void
        {
            var w:FlameListHeaderSegment = d_window as FlameListHeaderSegment;
            // get WidgetLookFeel for the assigned look.
            const wlf:FalagardWidgetLookFeel = getLookNFeel();
            
            var imagery:FalagardStateImagery;
            
            // get imagery for main state.
            if (w.isDisabled())
            {
                imagery = wlf.getStateImagery("Disabled");
            }
            else if ((w.isSegmentHovering() != w.isSegmentPushed()) && !w.isSplitterHovering() && w.isClickable())
            {
                imagery = wlf.getStateImagery("Hover");
            }
            else if (w.isSplitterHovering())
            {
                imagery = wlf.getStateImagery("SplitterHover");
            }
            else
            {
                imagery = wlf.getStateImagery("Normal");
            }
            
            // do main rendering
            imagery.render(w);
            
            // Render sorting icon as needed
            var sort_dir:uint = w.getSortDirection();
            if (sort_dir == Consts.SortDirection_Ascending)
            {
                imagery = wlf.getStateImagery("AscendingSortIcon");
                imagery.render(w);
            }
            else if (sort_dir == Consts.SortDirection_Descending)
            {
                imagery = wlf.getStateImagery("DescendingSortIcon");
                imagery.render(w);
            }
            
            // draw ghost copy if the segment is being dragged.
            if (w.isBeingDragMoved())
            {
                var pixel_size:Size = w.getPixelSize();
                var targetArea:Rect = new Rect(0, 0, pixel_size.d_width, pixel_size.d_height);
                targetArea.offset2(w.getDragMoveOffset());
                imagery = wlf.getStateImagery("DragGhost");
                imagery.render2(w, targetArea);
                
                // Render sorting icon as needed
                if (sort_dir == Consts.SortDirection_Ascending)
                {
                    imagery = wlf.getStateImagery("GhostAscendingSortIcon");
                    imagery.render2(w, targetArea);
                }
                else if (sort_dir == Consts.SortDirection_Descending)
                {
                    imagery = wlf.getStateImagery("GhostDescendingSortIcon");
                    imagery.render2(w, targetArea);
                }
            }
        }
        
    }
}