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
    import Flame2D.core.system.FlameWindowRendererFactory;
    import Flame2D.core.system.FlameWindowRendererManager;

//    import Flame2D.core.system.FlameWindowRendererModule;
    
    //! Implementation of WindowRendererModule for the Falagard window renderers
    
    public class FalagardWRModule //extends FlameWindowRendererModule
    {
        
        public function FalagardWRModule()
        {
            var mgr:FlameWindowRendererManager = FlameWindowRendererManager.getSingleton();
            mgr.addFactory(new FlameWindowRendererFactory(FalagardButton));
            mgr.addFactory(new FlameWindowRendererFactory(FalagardDefault));
            mgr.addFactory(new FlameWindowRendererFactory(FalagardEditbox));
            mgr.addFactory(new FlameWindowRendererFactory(FalagardFrameWindow));
            mgr.addFactory(new FlameWindowRendererFactory(FalagardItemEntry));
            mgr.addFactory(new FlameWindowRendererFactory(FalagardListHeader));
            mgr.addFactory(new FlameWindowRendererFactory(FalagardListHeaderSegment));
            mgr.addFactory(new FlameWindowRendererFactory(FalagardListbox));
            mgr.addFactory(new FlameWindowRendererFactory(FalagardMenubar));
            mgr.addFactory(new FlameWindowRendererFactory(FalagardMenuItem));
            mgr.addFactory(new FlameWindowRendererFactory(FalagardMultiColumnList));
            mgr.addFactory(new FlameWindowRendererFactory(FalagardMultiLineEditbox));
            mgr.addFactory(new FlameWindowRendererFactory(FalagardPopupMenu));
            mgr.addFactory(new FlameWindowRendererFactory(FalagardProgressBar));
            mgr.addFactory(new FlameWindowRendererFactory(FalagardScrollablePane));
            mgr.addFactory(new FlameWindowRendererFactory(FalagardScrollbar));
            mgr.addFactory(new FlameWindowRendererFactory(FalagardSlider));
            mgr.addFactory(new FlameWindowRendererFactory(FalagardStatic));
            mgr.addFactory(new FlameWindowRendererFactory(FalagardStaticImage));
            mgr.addFactory(new FlameWindowRendererFactory(FalagardStaticText));
            mgr.addFactory(new FlameWindowRendererFactory(FalagardSystemButton));
            mgr.addFactory(new FlameWindowRendererFactory(FalagardTabButton));
            mgr.addFactory(new FlameWindowRendererFactory(FalagardTabControl));
            mgr.addFactory(new FlameWindowRendererFactory(FalagardTitlebar));
            mgr.addFactory(new FlameWindowRendererFactory(FalagardToggleButton));
            mgr.addFactory(new FlameWindowRendererFactory(FalagardTooltip));
            mgr.addFactory(new FlameWindowRendererFactory(FalagardItemListbox));
            mgr.addFactory(new FlameWindowRendererFactory(FalagardTree));
        }
    }
}