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
package Flame2D.core.falagard
{
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.system.FlameImageSetManager;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.data.Consts;
    import Flame2D.core.utils.Rect;

    /*!
    \brief
    Dimension type that represents some dimension of a named Image.  Implements BaseDim interface.
    */
    public class FalagardImageDim extends FalagardBaseDim
    {
        private var d_imageset:String;      //!< name of the Imageset containing the image.
        private var d_image:String;         //!< name of the Image.
        private var d_what:uint;   //!< the dimension of the image that we are to represent.
        
        
        /*!
        \brief
        Constructor.
        
        \param imageset
        String object holding the name of the imagseset which contains the image.
        
        \param image
        String object holding the name of the image.
        
        \param dim
        DimensionType value indicating which dimension of the described image that this ImageDim
        is to represent.
        */
        public function FalagardImageDim(imageset:String, image:String, dim:uint)
        {
            d_imageset = imageset;
            d_image = image;
            d_what = dim;
        }
            
        
        /*!
        \brief
        Sets the source image information for this ImageDim.
        
        \param imageset
        String object holding the name of the imagseset which contains the image.
        
        \param image
        String object holding the name of the image.
        
        \return
        Nothing.
        */
        public function setSourceImage(imageset:String, image:String):void
        {
            d_imageset = imageset;
            d_image = image;
        }
        
        /*!
        \brief
        Sets the source dimension type for this ImageDim.
        
        \param dim
        DimensionType value indicating which dimension of the described image that this ImageDim
        is to represent.
        
        \return
        Nothing.
        */
        public function setSourceDimension(dim:uint):void
        {
            d_what = dim;
        }
        
        // Implementation of the base class interface
        override protected function getValue_impl(wnd:FlameWindow):Number
        {
            
            const img:FlameImage = FlameImageSetManager.getSingleton().getImageSet(d_imageset).getImage(d_image);
            
            switch (d_what)
            {
                case Consts.DimensionType_DT_WIDTH:
                    return img.getWidth();
                    break;
                
                case Consts.DimensionType_DT_HEIGHT:
                    return img.getHeight();
                    break;
                
                case Consts.DimensionType_DT_X_OFFSET:
                    return img.getOffsetX();
                    break;
                
                case Consts.DimensionType_DT_Y_OFFSET:
                    return img.getOffsetY();
                    break;
                
                // these other options will not be particularly useful for most people since they return the edges of the
                // image on the source texture.
                case Consts.DimensionType_DT_LEFT_EDGE:
                case Consts.DimensionType_DT_X_POSITION:
                    return img.getSourceTextureArea().d_left;
                    break;
                
                case Consts.DimensionType_DT_TOP_EDGE:
                case Consts.DimensionType_DT_Y_POSITION:
                    return img.getSourceTextureArea().d_top;
                    break;
                
                case Consts.DimensionType_DT_RIGHT_EDGE:
                    return img.getSourceTextureArea().d_right;
                    break;
                
                case Consts.DimensionType_DT_BOTTOM_EDGE:
                    return img.getSourceTextureArea().d_bottom;
                    break;
                
                default:
                    throw new Error("ImageDim::getValue - unknown or unsupported DimensionType encountered.");
                    break;
            }
        }
        
        
        override protected function getValue_impl2(wnd:FlameWindow, container:Rect):Number
        {
            // This dimension type does not alter when whithin a container Rect.
            return getValue_impl(wnd);
        }
        
        //void writeXMLElementName_impl(XMLSerializer& xml_stream) const;
        //void writeXMLElementAttributes_impl(XMLSerializer& xml_stream) const;
        override protected function clone_impl():FalagardBaseDim
        {
            var ndim:FalagardImageDim = new FalagardImageDim(d_imageset, d_image, d_what);
            return ndim;
        }
        

        
    }
}