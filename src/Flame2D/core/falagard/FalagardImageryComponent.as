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
    import Flame2D.core.data.Consts;
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameImageSetManager;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.utils.Colour;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;

    /*!
    \brief
    Class that encapsulates information for a single image component.
    */
    public class FalagardImageryComponent extends FalagardComponentBase
    {
        private var d_wl:String = "";
        
        protected var d_imagePropertyName:String = "";            //!< Name of the property to access to obtain the image to be used.
        protected var d_image:FlameImage = null;           //!< CEGUI::Image to be drawn by this image component.
        protected var d_vertFormatting:uint = Consts.VerticalFormatting_VF_TOP_ALIGNED;  //!< Vertical formatting to be applied when rendering the image component.
        protected var d_horzFormatting:uint = Consts.HorizontalFormatting_HF_LEFT_ALIGNED;  //!< Horizontal formatting to be applied when rendering the image component.
        
        public function FalagardImageryComponent(wl:String)
        {
            d_wl = wl;
        }
        
        public function parseXML(xml:XML):void
        {
            parseArea(xml);
            parseImage(xml);
            parseColour(xml);
            parseFormat(xml);
        }
        
        private function parseArea(xml:XML):void
        {
            d_area = new FalagardComponentArea(d_wl);
            d_area.parseXML(xml.Area[0]);
        }
        
        private function parseImage(xml:XML):void
        {
            var node:XML = xml.Image[0];
            if(node)
            {
                var image:String = node.@image.toString();
                var imageset:String = node.@imageset.toString();
                
                d_image = FlameImageSetManager.getSingleton().getImageSet(imageset).getImage(image);
            }
            
            node = xml.ImageProperty[0];
            if(node)
            {
                d_imagePropertyName = node.@name.toString();
            }
            
        }
        
        
        private function parseColour(xml:XML):void
        {
            var node:XML;
            
            //<Colour colour="#FFFFFF"/>
            node = xml.Colour[0];
            if(node)
            {
                var colour:uint = Misc.getAttributeHexAsUint(node.@colour.toString());
                var cols:ColourRect = new ColourRect(
                    Colour.getColour(colour),
                    Colour.getColour(colour),
                    Colour.getColour(colour),
                    Colour.getColour(colour));
                setColours(cols);
            }
            
            //Colours
            //<Colours topLeft="FFA7C7FF" topRight="FFA7C7FF" bottomLeft="FFA7C7FF" bottomRight="FFA7C7FF" />
            node = xml.Colours[0];
            if(node)
            {
                var topLeft:uint = Misc.getAttributeHexAsUint(node.@topLeft.toString());
                var topRight:uint = Misc.getAttributeHexAsUint(node.@topRight.toString());
                var bottomLeft:uint = Misc.getAttributeHexAsUint(node.@bottomLeft.toString());
                var bottomRight:uint = Misc.getAttributeHexAsUint(node.@bottomRight.toString());
                cols = new ColourRect(
                    Colour.getColour(topLeft),
                    Colour.getColour(topRight),
                    Colour.getColour(bottomLeft),
                    Colour.getColour(bottomRight));
                setColours(cols);
            }
            
            //ColourProperty
            node = xml.ColourProperty[0];
            if(node)
            {
                d_colourPropertyName = node.@name.toString();
                setColoursPropertyIsColourRect(false);
            }
            
            //ColourRectProperty
            node = xml.ColourRectProperty[0];
            if(node)
            {
                setColoursPropertySource(node.@name.toString);
                setColoursPropertyIsColourRect(true);
            }
        }
        
        private function parseFormat(xml:XML):void
        {
            var node:XML;
            
            //format
            node = xml.VertFormat[0];
            if(node)
            {
                var vfmt:uint = FalagardXMLHelper.stringToVertFormat(node.@type.toString());
                setVerticalFormatting(vfmt);
            }
            node = xml.HorzFormat[0];
            if(node)
            {
                var hfmt:uint = FalagardXMLHelper.stringToHorzFormat(node.@type.toString());
                setHorizontalFormatting(hfmt);
            }
            

            
            //format property
            node = xml.VertFormatProperty[0];
            if(node)
            {
                setVertFormattingPropertySource(node.@name.toString());
            }
            
            node = xml.HorzFormatProperty[0];
            if(node)
            {
                setHorzFormattingPropertySource(node.@name.toString());
            }
            
        }
        
        
        /*!
        \brief
        Return the Image object that will be drawn by this ImageryComponent.
        
        \return
        Image object.
        */
        public function getImage():FlameImage
        {
            return d_image;
        }
        
        /*!
        \brief
        Set the Image that will be drawn by this ImageryComponent.
        
        \param
        Pointer to the Image object to be drawn by this ImageryComponent.
        
        \return
        Nothing.
        */
        public function setImage(image:FlameImage):void
        {
            d_image = image;
        }
        
        /*!
        \brief
        Set the Image that will be drawn by this ImageryComponent.
        
        \param imageset
        String holding the name of the Imagset that contains the Image to be rendered.
        
        \param image
        String holding the name of the Image to be rendered.
        
        \return
        Nothing.
        */
        public function setImageByImageSet(imageset:String, image:String):void
        {
            try
            {
                d_image = FlameImageSetManager.getSingleton().getImageSet(imageset).getImage(image);
            }
            catch (error:Error)
            {
                d_image = null;
            }
        }
        
        /*!
        \brief
        Return the current vertical formatting setting for this ImageryComponent.
        
        \return
        One of the VerticalFormatting enumerated values.
        */
        public function getVerticalFormatting():uint
        {
            return d_vertFormatting;
        }
        
        /*!
        \brief
        Set the vertical formatting setting for this ImageryComponent.
        
        \param fmt
        One of the VerticalFormatting enumerated values.
        
        \return
        Nothing.
        */
        public function setVerticalFormatting(fmt:uint):void
        {
            d_vertFormatting = fmt;
        }
        
        /*!
        \brief
        Return the current horizontal formatting setting for this ImageryComponent.
        
        \return
        One of the HorizontalFormatting enumerated values.
        */
        public function getHorizontalFormatting():uint
        {
            return d_horzFormatting;
        }
        
        /*!
        \brief
        Set the horizontal formatting setting for this ImageryComponent.
        
        \param fmt
        One of the HorizontalFormatting enumerated values.
        
        \return
        Nothing.
        */
        public function setHorizontalFormatting(fmt:uint):void
        {
            d_horzFormatting = fmt;
        }
        
        /*!
        \brief
        Writes an xml representation of this ImageryComponent to \a out_stream.
        
        \param xml_stream
        Stream where xml data should be output.
        
        
        \return
        Nothing.
        */
        //void writeXMLToStream(XMLSerializer& xml_stream) const;
        
        /*!
        \brief
        Return whether this ImageryComponent fetches it's image via a property on the target window.
        
        \return
        - true if the image comes via a Propery.
        - false if the image is defined explicitly.
        */
        public function isImageFetchedFromProperty() :Boolean
        {
            return d_imagePropertyName.length != 0;
        }
        
        /*!
        \brief
        Return the name of the property that will be used to determine the image for this ImageryComponent.
        
        \return
        String object holding the name of a Propery.
        */
        public function getImagePropertySource():String
        {
            return d_imagePropertyName;
        }
        
        /*!
        \brief
        Set the name of the property that will be used to determine the image for this ImageryComponent.
        
        \param property
        String object holding the name of a Propery.  The property should access a imageset & image specification.
        
        \return
        Nothing.
        */
        public function setImagePropertySource(property:String):void
        {
            d_imagePropertyName = property;
        }
        
        override public function render(srcWindow:FlameWindow, modColours:ColourRect = null, 
                                           clipper:Rect = null, clipToDisplay:Boolean = false):void
        {
            var dest_rect:Rect = d_area.getPixelRect(srcWindow);
            
            if (!clipper)
                clipper = dest_rect;
            
            const final_clip_rect:Rect = dest_rect.getIntersection(clipper);
            render_impl(srcWindow, dest_rect, modColours,
                final_clip_rect, clipToDisplay);
        }
        
        override public function render2(srcWindow:FlameWindow, baseRect:Rect, 
                                modColours:ColourRect = null, clipper:Rect = null, clipToDisplay:Boolean = false):void
        {
            var dest_rect:Rect = d_area.getPixelRect2(srcWindow, baseRect);
            
            if (!clipper)
                clipper = dest_rect;
            
            const final_clip_rect:Rect = dest_rect.getIntersection(clipper);
            render_impl(srcWindow, dest_rect, modColours,
                final_clip_rect, clipToDisplay);
        }
        
        // implemets abstract from base
        override protected function render_impl(srcWindow:FlameWindow, destRect:Rect, modColours:ColourRect, 
                                       clipper:Rect, clipToDisplay:Boolean):void
        {
            // get final image to use.
            const img:FlameImage = isImageFetchedFromProperty() ?
                FlamePropertyHelper.stringToImage(srcWindow.getProperty(d_imagePropertyName)) :
                d_image;
            
            // do not draw anything if image is not set.
            if (!img)
                return;
            
            var horzFormatting:uint = d_horzFormatPropertyName.length == 0 ? d_horzFormatting :
                FalagardXMLHelper.stringToHorzFormat(srcWindow.getProperty(d_horzFormatPropertyName));
            
            var vertFormatting:uint = d_vertFormatPropertyName.length == 0 ? d_vertFormatting :
                FalagardXMLHelper.stringToVertFormat(srcWindow.getProperty(d_vertFormatPropertyName));
            
            var horzTiles:uint, vertTiles:uint;
            var xpos:Number, ypos:Number;
            
            var imgSz:Size = img.getSize();
            
            // calculate final colours to be used
            var finalColours:ColourRect = initColoursRect(srcWindow, modColours);
            
            // calculate initial x co-ordinate and horizontal tile count according to formatting options
            switch (horzFormatting)
            {
                case Consts.HorizontalFormatting_HF_STRETCHED:
                    imgSz.d_width = destRect.getWidth();
                    xpos = destRect.d_left;
                    horzTiles = 1;
                    break;
                
                case Consts.HorizontalFormatting_HF_TILED:
                    xpos = destRect.d_left;
                    horzTiles = Math.abs(int((destRect.getWidth() + (imgSz.d_width - 1)) / imgSz.d_width));
                    break;
                
                case Consts.HorizontalFormatting_HF_LEFT_ALIGNED:
                    xpos = destRect.d_left;
                    horzTiles = 1;
                    break;
                
                case Consts.HorizontalFormatting_HF_CENTRE_ALIGNED:
                    xpos = destRect.d_left + Misc.PixelAligned((destRect.getWidth() - imgSz.d_width) * 0.5);
                    horzTiles = 1;
                    break;
                
                case Consts.HorizontalFormatting_HF_RIGHT_ALIGNED:
                    xpos = destRect.d_right - imgSz.d_width;
                    horzTiles = 1;
                    break;
                
                default:
                    throw new Error("ImageryComponent::render - An unknown HorizontalFormatting value was specified.");
            }
            
            // calculate initial y co-ordinate and vertical tile count according to formatting options
            switch (vertFormatting)
            {
                case Consts.VerticalFormatting_VF_STRETCHED:
                    imgSz.d_height = destRect.getHeight();
                    ypos = destRect.d_top;
                    vertTiles = 1;
                    break;
                
                case Consts.VerticalFormatting_VF_TILED:
                    ypos = destRect.d_top;
                    vertTiles = Math.abs(int((destRect.getHeight() + (imgSz.d_height - 1)) / imgSz.d_height));
                    break;
                
                case Consts.VerticalFormatting_VF_TOP_ALIGNED:
                    ypos = destRect.d_top;
                    vertTiles = 1;
                    break;
                
                case Consts.VerticalFormatting_VF_CENTRE_ALIGNED:
                    ypos = destRect.d_top + Misc.PixelAligned((destRect.getHeight() - imgSz.d_height) * 0.5);
                    vertTiles = 1;
                    break;
                
                case Consts.VerticalFormatting_VF_BOTTOM_ALIGNED:
                    ypos = destRect.d_bottom - imgSz.d_height;
                    vertTiles = 1;
                    break;
                
                default:
                    throw new Error("ImageryComponent::render - An unknown VerticalFormatting value was specified.");
            }
            
            // perform final rendering (actually is now a caching of the images which will be drawn)
            var finalRect:Rect = new Rect();
            var finalClipper:Rect = new Rect();
            var clippingRect:Rect;
            finalRect.d_top = ypos;
            finalRect.d_bottom = ypos + imgSz.d_height;
            
            for (var row:uint = 0; row < vertTiles; ++row)
            {
                finalRect.d_left = xpos;
                finalRect.d_right = xpos + imgSz.d_width;
                
                for (var col:uint = 0; col < horzTiles; ++col)
                {
                    // use custom clipping for right and bottom edges when tiling the imagery
                    if (((vertFormatting == Consts.VerticalFormatting_VF_TILED) && row == vertTiles - 1) ||
                        ((horzFormatting == Consts.HorizontalFormatting_HF_TILED) && col == horzTiles - 1))
                    {
                        finalClipper = clipper ? clipper.getIntersection(destRect) : destRect;
                        clippingRect = finalClipper;
                    }
                        // not tiliing, or not on far edges, just used passed in clipper (if any).
                    else
                    {
                        clippingRect = clipper;
                    }
                    
                    // add geometry for image to the target window.
                    img.draw2(srcWindow.getGeometryBuffer(), finalRect, clippingRect, finalColours);
                    
                    finalRect.d_left += imgSz.d_width;
                    finalRect.d_right += imgSz.d_width;
                }
                
                finalRect.d_top += imgSz.d_height;
                finalRect.d_bottom += imgSz.d_height;
            }
        }

    }
}