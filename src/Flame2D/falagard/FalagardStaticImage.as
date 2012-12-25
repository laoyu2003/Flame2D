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
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.falagard.FalagardWidgetLookFeel;

    /*!
    \brief
    StaticImage class for the FalagardBase module.
    
    This class requires LookNFeel to be assigned.  The LookNFeel should provide the following:
    
    States:
    - Enabled                     - basic rendering for enabled state.
    - Disabled                    - basic rendering for disabled state.
    - EnabledFrame                - frame rendering for enabled state
    - DisabledFrame               - frame rendering for disabled state.
    - WithFrameEnabledBackground  - backdrop rendering for enabled state with frame enabled.
    - WithFrameDisabledBackground - backdrop rendering for disabled state with frame enabled.
    - NoFrameEnabledBackground    - backdrop rendering for enabled state with frame disabled.
    - NoFrameDisabledBackground   - backdrop rendering for disabled state with frame disabled.
    - WithFrameImage              - image rendering when frame is enabled
    - NoFrameImage                - image rendering when frame is disabled (defaults to WithFrameImage if not present)
    */
    public class FalagardStaticImage extends FalagardStatic
    {
        
        public static const TypeName:String = "Falagard/StaticImage";
        
        // static properties
        protected static var d_imageProperty:FalagardStaticImagePropertyImage = new FalagardStaticImagePropertyImage();
        
        // implementation data
        protected var d_image:FlameImage = null;
        
        public function FalagardStaticImage(type:String)
        {
            super(type);
            
            registerProperty(d_imageProperty);
        }
        
        override public function render():void
        {
            // base class rendering
            super.render();
            
            // render image if there is one
            if (d_image!=null)
            {
                // get WidgetLookFeel for the assigned look.
                const wlf:FalagardWidgetLookFeel = getLookNFeel();
                var imagery_name:String = (!d_frameEnabled && wlf.isStateImageryPresent("NoFrameImage")) ? "NoFrameImage" : "WithFrameImage";
                wlf.getStateImagery(imagery_name).render(d_window);
            }
        }
        
        /*!
        \brief
        Set the image for this FalagardStaticImage widget
        */
        public function setImage(img:FlameImage):void
        {
            d_image = img;
            d_window.invalidate();
        }
        
        /*!
        \brief
        Get the image for this FalagardStaticImage widget
        */
        public function getImage():FlameImage
        {
            return d_image;
        }
        
    }
}