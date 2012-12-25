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
package Flame2D.elements.containers
{
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.data.RenderingContext;
    import Flame2D.core.utils.Rect;
    
    /*!
    \brief
    Helper container window that has configurable clipping.
    Used by the ItemListbox widget.
    
    \deprecated
    This class is deprecated and is scheduled for removal.  The function this
    class used to provide was broken when the inner-rect (aka client area)
    support got fixed.  The good news is that fixing inner-rect support
    effectively negated the need for this class anyway - clipping areas can
    now be established in the looknfeel and extracted via the WindowRenderer.
    */
    public class FlameClippedContainer extends FlameWindow
    {
        public static const WidgetTypeName:String = "ClippedContainer";
        public static const EventNamespace:String = "ClippedContainer";

        
        /*************************************************************************
         Data fields
         *************************************************************************/
        //! the pixel rect to be used for clipping relative to either a window or the screen.
        protected var d_clipArea:Rect = new Rect(0,0,0,0);
        //! the base window which the clipping rect is relative to.
        protected var d_clipperWindow:FlameWindow = null;
        
        
        public function FlameClippedContainer(type:String, name:String)
        {
            super(type, name);   
        }
        
        
        
        /*************************************************************************
         Public interface methods
         *************************************************************************/
        /*!
        \brief
        Return the current clipping rectangle.
        
        \return
        Rect object describing the clipping area in pixel that will be applied during rendering.
        */
        public function getClipArea():Rect
        {
            return d_clipArea;
        }
        
        /*!
        \brief
        Returns the reference window used for converting the clipper rect to screen space.
        */
        public function getClipperWindow():FlameWindow
        {
            return d_clipperWindow;
        }
        
        /*!
        \brief
        Set the custom clipper area in pixels.
        */
        public function setClipArea(r:Rect):void
        {
            if (! d_clipArea.isEqual(r))
            {
                d_clipArea = r;
                invalidate();
                notifyClippingChanged();
            }
        }
        
        /*!
        \brief
        Set the clipper reference window.
        
        \param w
        The window to be used a base for converting the custom clipper rect to
        screen space. NULL if the clipper rect is relative to the screen.
        */
        public function setClipperWindow(w:FlameWindow):void
        {
            if (d_clipperWindow != w)
            {
                d_clipperWindow = w;
                invalidate();
                notifyClippingChanged();
            }
        }
        
        // Overridden from Window.
        override protected function getUnclippedInnerRect_impl():Rect
        {
            // This is obviously doing nothing.  The reason being that whas this
            // used to to is now handled correctly via the fixed 'inner rect' usage,
            // meaning that the looknfeel named areas can be employed to do the correct
            // clipping.  Fixing the inner rect support actually broke this anyhow,
            // since it only worked because the inner rect support was broken.  As
            // such, ClippedContainer serves no useful purpose and will be removed.
            return super.getUnclippedInnerRect_impl();
        }
        
        /*************************************************************************
         Implementation methods
         *************************************************************************/
        /*!
        \brief
        Return whether this window was inherited from the given class name at some point in the inheritance hierarchy.
        
        \param class_name
        The class name that is to be checked.
        
        \return
        true if this window was inherited from \a class_name. false if not.
        */
        override protected function testClassName_impl(class_name:String):Boolean
        {
            if (class_name=="ClippedContainer")	return true;
            return super.testClassName_impl(class_name);
        }
        
        /*************************************************************************
         Overridden from Window.
         *************************************************************************/
        override protected function drawSelf(ctx:RenderingContext):void
        {
        }
    }
}