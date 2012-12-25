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
    import Flame2D.elements.tree.FlameTree;
    import Flame2D.core.falagard.FalagardStateImagery;
    import Flame2D.core.falagard.FalagardWidgetLookFeel;
    import Flame2D.core.utils.Rect;

    /*!
    \brief
    Tree class for the FalagardBase module.
    
    This class requires LookNFeel to be assigned.  The LookNFeel should provide the following:
    
    States:
    - Enabled
    - Disabled
    
    Named Areas:
    - ItemRenderingArea
    - ItemRenderingAreaHScroll
    - ItemRenderingAreaVScroll
    - ItemRenderingAreaHVScroll
    
    Child Widgets:
    Scrollbar based widget with name suffix "__auto_vscrollbar__"
    Scrollbar based widget with name suffix "__auto_hscrollbar__"
    */
    public class FalagardTree extends FlameWindowRenderer
    {
        
        public static const TypeName:String = "Falagard/Tree";
        
        public function FalagardTree(type:String)
        {
            super(type);
        }
        
        override public function render():void
        {
            var tree:FlameTree = d_window as FlameTree;
            //Set the render area for this.
            var rect:Rect = getTreeRenderArea();
            tree.setItemRenderArea(rect);
            const wlf:FalagardWidgetLookFeel = getLookNFeel();
            
            var imagery:FalagardStateImagery;
            //Get the Falagard imagery to render
            imagery = wlf.getStateImagery(tree.isDisabled()? "Disabled" : "Enabled");
            //Render the window
            imagery.render(tree);
            //Fix Scrollbars
            tree.doScrollbars();
            //Render the tree.
            tree.doTreeRender();
        }
        
        protected function getTreeRenderArea():Rect
        {
            // get WidgetLookFeel for the assigned look.
            const wlf:FalagardWidgetLookFeel = getLookNFeel();
            var tree:FlameTree = d_window as FlameTree;
            
            var v_visible:Boolean = tree.getVertScrollbar().isVisible(true);
            var h_visible:Boolean = tree.getHorzScrollbar().isVisible(true);
            
            // if either of the scrollbars are visible, we might want to use another text rendering area
            if (v_visible || h_visible)
            {
                var area_name:String = "ItemRenderingArea";
                
                if (h_visible)
                {
                    area_name += "H";
                }
                if (v_visible)
                {
                    area_name += "V";
                }
                area_name += "Scroll";
                
                if (wlf.isNamedAreaDefined(area_name))
                {
                    return wlf.getNamedArea(area_name).getArea().getPixelRect(tree);
                }
            }
            
            // default to plain ItemRenderingArea
            return wlf.getNamedArea("ItemRenderingArea").getArea().getPixelRect(tree);
        }
    }
}