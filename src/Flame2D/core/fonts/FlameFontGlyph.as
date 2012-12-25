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
package Flame2D.core.fonts
{
    import Flame2D.core.utils.Size;
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.imagesets.FlameImageSet;

    /*!
    \brief
    internal class representing a single font glyph.
    
    For TrueType fonts initially all FontGlyph's are empty
    (getImage() will return 0), but they are filled by demand.
    */
    
    
    public class FlameFontGlyph
    {
        //! The image which will be rendered for this glyph.
        private var d_image:FlameImage = null;
        //! Amount to advance the pen after rendering this glyph
        private var d_advance:Number = 0.0;
        
        
        //! Constructor.
        public function FlameFontGlyph(advance:Number = 0.0, image:FlameImage = null)
        {
            d_image = image;
            d_advance = advance;
        }
        
        //! Return the CEGUI::Image object rendered for this glyph.
        public function getImage():FlameImage
        {
            return d_image;
        }
        
        //! Return the parent CEGUI::Imageset object for this glyph.
        public function getImageset():FlameImageSet
        {
            return d_image.getImageset();
        }
        
        //! Return the scaled pixel size of the glyph.
        public function getSize(x_scale:Number, y_scale:Number):Size
        {
            return new Size(getWidth(x_scale), getHeight(y_scale));
        }
        
        //! Return the scaled width of the glyph.
        public function getWidth(x_scale:Number):Number
        {
            return d_image.getWidth() * x_scale;
        }
        
        //! Return the scaled height of the glyph.
        public function getHeight(y_scale:Number):Number
        {
            return d_image.getHeight() * y_scale;
        }
        
        /*!
        \brief
        Return the rendered advance value for this glyph.
        
        The rendered advance value is the total number of pixels from the
        current pen position that will be occupied by this glyph when rendered.
        */
        public function getRenderedAdvance(x_scale:Number) :Number
        {
            return (d_image.getWidth() + d_image.getOffsetX()) * x_scale;
        }
        
        /*!
        \brief
        Return the horizontal advance value for the glyph.
        
        The returned value is the number of pixels the pen should move
        horizontally to position itself ready to render the next glyph.  This
        is not always the same as the glyph image width or rendererd advance,
        since it allows for horizontal overhangs.
        */
        public function getAdvance(x_scale:Number = 1.0):Number
        {
            return d_advance * x_scale;
        }
        
        //! Set the horizontal advance value for the glyph.
        public function setAdvance(advance:Number):void
        {
            d_advance = advance;
        }
        
        //! Set the CEGUI::Image object rendered for this glyph.
        public function setImage(image:FlameImage):void
        {
            d_image = image;
        }
        

    }
}