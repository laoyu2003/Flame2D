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
    import Flame2D.core.system.FlameImageSetManager;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.utils.Colour;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.Vector2;
    
    import flashx.textLayout.debug.assert;

    /*!
    \brief
    Class that encapsulates information for a frame with background (9 images in total)
    
    Corner images are always drawn at their natural size, edges are stretched between the corner
    pieces for a particular edge, the background image will cover the inner rectangle formed by
    the edge images and can be stretched or tiled in either dimension.
    */
    public class FalagardFrameComponent extends FalagardComponentBase
    {
        private var d_wl:String = "";
        
        // formatting options for background
        private var d_vertFormatting:uint = Consts.HorizontalFormatting_HF_STRETCHED;  //!< Vertical formatting to be applied when rendering the background for the component.
        private var d_horzFormatting:uint = Consts.VerticalFormatting_VF_STRETCHED;  //!< Horizontal formatting to be applied when rendering the background for the component.
        // images for the frame
        //const Image* d_frameImages[FIC_FRAME_IMAGE_COUNT = 9];  //!< Array that holds the assigned images.
        private var d_frameImages:Vector.<FlameImage> = new Vector.<FlameImage>(Consts.FrameImageComponent_FIC_FRAME_IMAGE_COUNT, true);
        
        public function FalagardFrameComponent(wl:String)
        {
            d_wl = wl;
            for(var i:uint = 0; i<d_frameImages.length; i++)
            {
                d_frameImages[i] = null;
            }
        }
        
        public function parseXML(xml:XML):void
        {
            parseArea(xml);
            parseImages(xml);
            
            //should be forwarded to Image?
            parseColours(xml);
            parseFormats(xml);
        }
        
        private function parseArea(xml:XML):void
        {
            d_area = new FalagardComponentArea(d_wl);
            d_area.parseXML(xml.Area[0]);
        }
        
        private function parseImages(xml:XML):void
        {
            var nodes:XMLList = xml.Image;
            for each(var node:XML in nodes){
                var type:String = node.@type.toString();
                var image:String = node.@image.toString();
                var imageset:String = node.@imageset.toString();
                
                //which part in the 9 images
                var part:uint = FalagardXMLHelper.stringToFrameImageComponent(type);
                if(part >= Consts.FrameImageComponent_FIC_FRAME_IMAGE_COUNT){
                    throw new Error("Error in parse FrameComponent images, count error");
                }
                
                var mgr:FlameImageSetManager = FlameImageSetManager.getSingleton();
                d_frameImages[part] = FlameImageSetManager.getSingleton().getImageSet(imageset).getImage(image);
            }
        }
        
        private function parseColours(xml:XML):void
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
                setColoursPropertySource(node.@name.toString());
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
        
        private function parseFormats(xml:XML):void
        {
            var node:XML;
            
            //format
            node = xml.VertFormat[0];
            if(node)
            {
                var vfmt:uint = FalagardXMLHelper.stringToVertFormat(node.@type.toString());
                setBackgroundVerticalFormatting(vfmt);
            }
            node = xml.HorzFormat[0];
            if(node)
            {
                var hfmt:uint = FalagardXMLHelper.stringToHorzFormat(node.@type.toString());
                setBackgroundHorizontalFormatting(hfmt);
            }
            
            
            
            //format property
            node = xml.VertFormatProperty[0];
            if(node)
            {
                setVertFormattingPropertySource(node.@name.tostring());
            }
            
            node = xml.HorzFormatProperty[0];
            if(node)
            {
                setHorzFormattingPropertySource(node.@name.toString());
            }
        }
        
   
        
        /*!
        \brief
        Return the current vertical formatting setting for this FrameComponent.
        
        \return
        One of the VerticalFormatting enumerated values.
        */
        public function getBackgroundVerticalFormatting():uint
        {
            return d_vertFormatting;
        }
        
        /*!
        \brief
        Set the vertical formatting setting for this FrameComponent.
        
        \param fmt
        One of the VerticalFormatting enumerated values.
        
        \return
        Nothing.
        */
        public function setBackgroundVerticalFormatting(fmt:uint):void
        {
            d_vertFormatting = fmt;
        }
        
        /*!
        \brief
        Return the current horizontal formatting setting for this FrameComponent.
        
        \return
        One of the HorizontalFormatting enumerated values.
        */
        public function getBackgroundHorizontalFormatting():uint
        {
            return d_horzFormatting;
        }
        
        /*!
        \brief
        Set the horizontal formatting setting for this FrameComponent.
        
        \param fmt
        One of the HorizontalFormatting enumerated values.
        
        \return
        Nothing.
        */
        public function setBackgroundHorizontalFormatting(fmt:uint):void
        {
            this.d_horzFormatting = fmt;
        }
        
        /*!
        \brief
        Return the Image object that will be drawn by this FrameComponent for a specified frame part.
        
        \param part
        One of the FrameImageComponent enumerated values specifying the component image to be accessed.
        
        \return
        Image object.
        */
        public function getImage(part:uint):FlameImage
        {
            //assert(part < Consts.FrameImageComponent_FIC_FRAME_IMAGE_COUNT);
            return d_frameImages[part];
        }
        
        /*!
        \brief
        Set the Image that will be drawn by this ImageryComponent.
        
        \param part
        One of the FrameImageComponent enumerated values specifying the component image to be accessed.
        
        \param image
        Pointer to the Image object to be drawn by this FrameComponent.
        
        \return
        Nothing.
        */
        public function setImage(part:uint, image:FlameImage):void
        {
            //assert(part < Consts.FrameImageComponent_FIC_FRAME_IMAGE_COUNT);
            
            d_frameImages[part] = image;
        }
        
        /*!
        \brief
        Set the Image that will be drawn by this FrameComponent.
        
        \param part
        One of the FrameImageComponent enumerated values specifying the component image to be accessed.
        
        \param imageset
        String holding the name of the Imagset that contains the Image to be rendered.
        
        \param image
        String holding the name of the Image to be rendered.
        
        \return
        Nothing.
        */
        public function setImageFromImageSet(part:uint, imageset:String, image:String):void
        {
            this.d_frameImages[part] = FlameImageSetManager.getSingleton().getImageSet(imageset).getImage(image);
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
            var backgroundRect:Rect = destRect.clone();
            var finalRect:Rect = new Rect();
            var imageSize:Size = new Size();
            var imageOffsets:Vector2 = new Vector2();
            var imageColours:ColourRect;
            var leftfactor:Number, rightfactor:Number, topfactor:Number, bottomfactor:Number;
            var calcColoursPerImage:Boolean;
            
            // vars we use to track what to do with the side pieces.
            var topOffset:Number = 0, bottomOffset:Number = 0, leftOffset:Number = 0, rightOffset:Number = 0;
            var topWidth:Number, bottomWidth:Number, leftHeight:Number, rightHeight:Number;
            topWidth = bottomWidth = destRect.getWidth();
            leftHeight = rightHeight = destRect.getHeight();
            
            // calculate final overall colours to be used
            var finalColours:ColourRect = initColoursRect(srcWindow, modColours);
            
            if (finalColours.isMonochromatic())
            {
                calcColoursPerImage = false;
                imageColours = finalColours;
            }
            else
            {
                calcColoursPerImage = true;
            }
            
            // top-left image
            if (d_frameImages[Consts.FrameImageComponent_FIC_TOP_LEFT_CORNER])
            {
                // calculate final destination area
                imageSize = d_frameImages[Consts.FrameImageComponent_FIC_TOP_LEFT_CORNER].getSize();
                imageOffsets = d_frameImages[Consts.FrameImageComponent_FIC_TOP_LEFT_CORNER].getOffsets();
                finalRect.d_left = destRect.d_left;
                finalRect.d_top  = destRect.d_top;
                finalRect.setSize(imageSize);
                finalRect = destRect.getIntersection (finalRect);
                
                // update adjustments required to edges do to presence of this element.
                topOffset  += imageSize.d_width + imageOffsets.d_x;
                leftOffset += imageSize.d_height + imageOffsets.d_y;
                topWidth   -= topOffset;
                leftHeight -= leftOffset;
                
                // calculate colours that are to be used to this component image
                if (calcColoursPerImage)
                {
                    leftfactor   = (finalRect.d_left + imageOffsets.d_x) / destRect.getWidth();
                    rightfactor  = leftfactor + finalRect.getWidth() / destRect.getWidth();
                    topfactor    = (finalRect.d_top + imageOffsets.d_y) / destRect.getHeight();
                    bottomfactor = topfactor + finalRect.getHeight() / destRect.getHeight();
                    
                    imageColours = finalColours.getSubRectangle( leftfactor, rightfactor, topfactor, bottomfactor);
                }
                
                // draw this element.
                d_frameImages[Consts.FrameImageComponent_FIC_TOP_LEFT_CORNER].draw2(srcWindow.getGeometryBuffer(), finalRect, clipper, imageColours);
            }
            
            // top-right image
            if (d_frameImages[Consts.FrameImageComponent_FIC_TOP_RIGHT_CORNER])
            {
                // calculate final destination area
                imageSize = d_frameImages[Consts.FrameImageComponent_FIC_TOP_RIGHT_CORNER].getSize();
                imageOffsets = d_frameImages[Consts.FrameImageComponent_FIC_TOP_RIGHT_CORNER].getOffsets();
                finalRect.d_left = destRect.d_right - imageSize.d_width;
                finalRect.d_top  = destRect.d_top;
                finalRect.setSize(imageSize);
                finalRect = destRect.getIntersection (finalRect);
                
                // update adjustments required to edges do to presence of this element.
                rightOffset += imageSize.d_height + imageOffsets.d_y;
                topWidth    -= imageSize.d_width - imageOffsets.d_x;
                rightHeight -= rightOffset;
                
                // calculate colours that are to be used to this component image
                if (calcColoursPerImage)
                {
                    leftfactor   = (finalRect.d_left + imageOffsets.d_x) / destRect.getWidth();
                    rightfactor  = leftfactor + finalRect.getWidth() / destRect.getWidth();
                    topfactor    = (finalRect.d_top + imageOffsets.d_y) / destRect.getHeight();
                    bottomfactor = topfactor + finalRect.getHeight() / destRect.getHeight();
                    
                    imageColours = finalColours.getSubRectangle( leftfactor, rightfactor, topfactor, bottomfactor);
                }
                
                // draw this element.
                d_frameImages[Consts.FrameImageComponent_FIC_TOP_RIGHT_CORNER].draw2(srcWindow.getGeometryBuffer(), finalRect, clipper, imageColours);
            }
            
            // bottom-left image
            if (d_frameImages[Consts.FrameImageComponent_FIC_BOTTOM_LEFT_CORNER])
            {
                // calculate final destination area
                imageSize = d_frameImages[Consts.FrameImageComponent_FIC_BOTTOM_LEFT_CORNER].getSize();
                imageOffsets = d_frameImages[Consts.FrameImageComponent_FIC_BOTTOM_LEFT_CORNER].getOffsets();
                finalRect.d_left = destRect.d_left;
                finalRect.d_top  = destRect.d_bottom - imageSize.d_height;
                finalRect.setSize(imageSize);
                finalRect = destRect.getIntersection (finalRect);
                
                // update adjustments required to edges do to presence of this element.
                bottomOffset += imageSize.d_width + imageOffsets.d_x;
                bottomWidth  -= bottomOffset;
                leftHeight   -= imageSize.d_height - imageOffsets.d_y;
                
                // calculate colours that are to be used to this component image
                if (calcColoursPerImage)
                {
                    leftfactor   = (finalRect.d_left + imageOffsets.d_x) / destRect.getWidth();
                    rightfactor  = leftfactor + finalRect.getWidth() / destRect.getWidth();
                    topfactor    = (finalRect.d_top + imageOffsets.d_y) / destRect.getHeight();
                    bottomfactor = topfactor + finalRect.getHeight() / destRect.getHeight();
                    
                    imageColours = finalColours.getSubRectangle( leftfactor, rightfactor, topfactor, bottomfactor);
                }
                
                // draw this element.
                d_frameImages[Consts.FrameImageComponent_FIC_BOTTOM_LEFT_CORNER].draw2(srcWindow.getGeometryBuffer(), finalRect, clipper, imageColours);
            }
            
            // bottom-right image
            if (d_frameImages[Consts.FrameImageComponent_FIC_BOTTOM_RIGHT_CORNER])
            {
                // calculate final destination area
                imageSize = d_frameImages[Consts.FrameImageComponent_FIC_BOTTOM_RIGHT_CORNER].getSize();
                imageOffsets = d_frameImages[Consts.FrameImageComponent_FIC_BOTTOM_RIGHT_CORNER].getOffsets();
                finalRect.d_left = destRect.d_right - imageSize.d_width;
                finalRect.d_top  = destRect.d_bottom - imageSize.d_height;
                finalRect.setSize(imageSize);
                finalRect = destRect.getIntersection (finalRect);
                
                // update adjustments required to edges do to presence of this element.
                bottomWidth -= imageSize.d_width - imageOffsets.d_x;
                rightHeight -= imageSize.d_height - imageOffsets.d_y;
                
                // calculate colours that are to be used to this component image
                if (calcColoursPerImage)
                {
                    leftfactor   = (finalRect.d_left + d_frameImages[Consts.FrameImageComponent_FIC_BOTTOM_RIGHT_CORNER].getOffsetX()) / destRect.getWidth();
                    rightfactor  = leftfactor + finalRect.getWidth() / destRect.getWidth();
                    topfactor    = (finalRect.d_top + d_frameImages[Consts.FrameImageComponent_FIC_BOTTOM_RIGHT_CORNER].getOffsetY()) / destRect.getHeight();
                    bottomfactor = topfactor + finalRect.getHeight() / destRect.getHeight();
                    
                    imageColours = finalColours.getSubRectangle( leftfactor, rightfactor, topfactor, bottomfactor);
                }
                
                // draw this element.
                d_frameImages[Consts.FrameImageComponent_FIC_BOTTOM_RIGHT_CORNER].draw2(srcWindow.getGeometryBuffer(), finalRect, clipper, imageColours);
            }
            
            // top image
            if (d_frameImages[Consts.FrameImageComponent_FIC_TOP_EDGE])
            {
                // calculate final destination area
                imageSize = d_frameImages[Consts.FrameImageComponent_FIC_TOP_EDGE].getSize();
                finalRect.d_left   = destRect.d_left + topOffset;
                finalRect.d_right  = finalRect.d_left + topWidth;
                finalRect.d_top    = destRect.d_top;
                finalRect.d_bottom = finalRect.d_top + imageSize.d_height;
                finalRect = destRect.getIntersection (finalRect);
                
                // adjust background area to miss this edge
                backgroundRect.d_top += imageSize.d_height + d_frameImages[Consts.FrameImageComponent_FIC_TOP_EDGE].getOffsetY();;
                
                // calculate colours that are to be used to this component image
                if (calcColoursPerImage)
                {
                    leftfactor   = (finalRect.d_left + d_frameImages[Consts.FrameImageComponent_FIC_TOP_EDGE].getOffsetX()) / destRect.getWidth();
                    rightfactor  = leftfactor + finalRect.getWidth() / destRect.getWidth();
                    topfactor    = (finalRect.d_top + d_frameImages[Consts.FrameImageComponent_FIC_TOP_EDGE].getOffsetY()) / destRect.getHeight();
                    bottomfactor = topfactor + finalRect.getHeight() / destRect.getHeight();
                    
                    imageColours = finalColours.getSubRectangle( leftfactor, rightfactor, topfactor, bottomfactor);
                }
                
                // draw this element.
                d_frameImages[Consts.FrameImageComponent_FIC_TOP_EDGE].draw2(srcWindow.getGeometryBuffer(), finalRect, clipper, imageColours);
            }
            
            // bottom image
            if (d_frameImages[Consts.FrameImageComponent_FIC_BOTTOM_EDGE])
            {
                // calculate final destination area
                imageSize = d_frameImages[Consts.FrameImageComponent_FIC_BOTTOM_EDGE].getSize();
                finalRect.d_left   = destRect.d_left + bottomOffset;
                finalRect.d_right  = finalRect.d_left + bottomWidth;
                finalRect.d_bottom = destRect.d_bottom;
                finalRect.d_top    = finalRect.d_bottom - imageSize.d_height;
                finalRect = destRect.getIntersection (finalRect);
                
                // adjust background area to miss this edge
                backgroundRect.d_bottom -= imageSize.d_height - d_frameImages[Consts.FrameImageComponent_FIC_BOTTOM_EDGE].getOffsetY();;
                
                // calculate colours that are to be used to this component image
                if (calcColoursPerImage)
                {
                    leftfactor   = (finalRect.d_left + d_frameImages[Consts.FrameImageComponent_FIC_BOTTOM_EDGE].getOffsetX()) / destRect.getWidth();
                    rightfactor  = leftfactor + finalRect.getWidth() / destRect.getWidth();
                    topfactor    = (finalRect.d_top + d_frameImages[Consts.FrameImageComponent_FIC_BOTTOM_EDGE].getOffsetY()) / destRect.getHeight();
                    bottomfactor = topfactor + finalRect.getHeight() / destRect.getHeight();
                    
                    imageColours = finalColours.getSubRectangle( leftfactor, rightfactor, topfactor, bottomfactor);
                }
                
                // draw this element.
                d_frameImages[Consts.FrameImageComponent_FIC_BOTTOM_EDGE].draw2(srcWindow.getGeometryBuffer(), finalRect, clipper, imageColours);
            }
            
            // left image
            if (d_frameImages[Consts.FrameImageComponent_FIC_LEFT_EDGE])
            {
                // calculate final destination area
                imageSize = d_frameImages[Consts.FrameImageComponent_FIC_LEFT_EDGE].getSize();
                finalRect.d_left   = destRect.d_left;
                finalRect.d_right  = finalRect.d_left + imageSize.d_width;
                finalRect.d_top    = destRect.d_top + leftOffset;
                finalRect.d_bottom = finalRect.d_top + leftHeight;
                finalRect = destRect.getIntersection (finalRect);
                
                // adjust background area to miss this edge
                backgroundRect.d_left += imageSize.d_width + d_frameImages[Consts.FrameImageComponent_FIC_LEFT_EDGE].getOffsetX();
                
                // calculate colours that are to be used to this component image
                if (calcColoursPerImage)
                {
                    leftfactor   = (finalRect.d_left + d_frameImages[Consts.FrameImageComponent_FIC_LEFT_EDGE].getOffsetX()) / destRect.getWidth();
                    rightfactor  = leftfactor + finalRect.getWidth() / destRect.getWidth();
                    topfactor    = (finalRect.d_top + d_frameImages[Consts.FrameImageComponent_FIC_LEFT_EDGE].getOffsetY()) / destRect.getHeight();
                    bottomfactor = topfactor + finalRect.getHeight() / destRect.getHeight();
                    
                    imageColours = finalColours.getSubRectangle( leftfactor, rightfactor, topfactor, bottomfactor);
                }
                
                // draw this element.
                d_frameImages[Consts.FrameImageComponent_FIC_LEFT_EDGE].draw2(srcWindow.getGeometryBuffer(), finalRect, clipper, imageColours);
            }
            
            // right image
            if (d_frameImages[Consts.FrameImageComponent_FIC_RIGHT_EDGE])
            {
                // calculate final destination area
                imageSize = d_frameImages[Consts.FrameImageComponent_FIC_RIGHT_EDGE].getSize();
                finalRect.d_top    = destRect.d_top + rightOffset;
                finalRect.d_bottom = finalRect.d_top + rightHeight;
                finalRect.d_right  = destRect.d_right;
                finalRect.d_left   = finalRect.d_right - imageSize.d_width;
                finalRect = destRect.getIntersection (finalRect);
                
                // adjust background area to miss this edge
                backgroundRect.d_right -= imageSize.d_width - d_frameImages[Consts.FrameImageComponent_FIC_RIGHT_EDGE].getOffsetX();
                
                // calculate colours that are to be used to this component image
                if (calcColoursPerImage)
                {
                    leftfactor   = (finalRect.d_left + d_frameImages[Consts.FrameImageComponent_FIC_RIGHT_EDGE].getOffsetX()) / destRect.getWidth();
                    rightfactor  = leftfactor + finalRect.getWidth() / destRect.getWidth();
                    topfactor    = (finalRect.d_top + d_frameImages[Consts.FrameImageComponent_FIC_RIGHT_EDGE].getOffsetY()) / destRect.getHeight();
                    bottomfactor = topfactor + finalRect.getHeight() / destRect.getHeight();
                    
                    imageColours = finalColours.getSubRectangle( leftfactor, rightfactor, topfactor, bottomfactor);
                }
                
                // draw this element.
                d_frameImages[Consts.FrameImageComponent_FIC_RIGHT_EDGE].draw2(srcWindow.getGeometryBuffer(), finalRect, clipper, imageColours);
            }
            
            if (d_frameImages[Consts.FrameImageComponent_FIC_BACKGROUND])
            {
                // calculate colours that are to be used to this component image
                if (calcColoursPerImage)
                {
                    leftfactor   = (backgroundRect.d_left + d_frameImages[Consts.FrameImageComponent_FIC_BACKGROUND].getOffsetX()) / destRect.getWidth();
                    rightfactor  = leftfactor + backgroundRect.getWidth() / destRect.getWidth();
                    topfactor    = (backgroundRect.d_top + d_frameImages[Consts.FrameImageComponent_FIC_BACKGROUND].getOffsetY()) / destRect.getHeight();
                    bottomfactor = topfactor + backgroundRect.getHeight() / destRect.getHeight();
                    
                    imageColours = finalColours.getSubRectangle( leftfactor, rightfactor, topfactor, bottomfactor);
                }
                
                // render background image.
                doBackgroundRender(srcWindow, backgroundRect, imageColours, clipper, clipToDisplay);
            }
            
        }
        
        // renders the background image (basically a clone of render_impl from ImageryComponent - maybe we need a helper class?)
        public function doBackgroundRender(srcWindow:FlameWindow, destRect:Rect, 
                                           colours:ColourRect, clipper:Rect, clipToDisplay:Boolean):void
        {
            var horzFormatting:uint = d_horzFormatPropertyName.length == 0 ? d_horzFormatting :
                FalagardXMLHelper.stringToHorzFormat(srcWindow.getProperty(d_horzFormatPropertyName));
            
            var vertFormatting:uint = d_vertFormatPropertyName.length == 0 ? d_vertFormatting :
                FalagardXMLHelper.stringToVertFormat(srcWindow.getProperty(d_vertFormatPropertyName));
            
            var horzTiles:uint, vertTiles:uint;
            var xpos:Number, ypos:Number;
            
            var imgSz:Size = d_frameImages[Consts.FrameImageComponent_FIC_BACKGROUND].getSize();
            
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
                    horzTiles = Math.abs((destRect.getWidth() + (imgSz.d_width - 1)) / imgSz.d_width);
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
                    throw new Error("FrameComponent::doBackgroundRender - An unknown HorizontalFormatting value was specified.");
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
                    vertTiles = Math.abs((destRect.getHeight() + (imgSz.d_height - 1)) / imgSz.d_height);
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
                    throw new Error("FrameComponent::doBackgroundRender - An unknown VerticalFormatting value was specified.");
            }
            
            // perform final rendering (actually is now a caching of the images which will be drawn)
            var finalRect:Rect = new Rect();;
            var finalClipper:Rect;
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
                    
                    // add image to the rendering cache for the target window.
                    d_frameImages[Consts.FrameImageComponent_FIC_BACKGROUND].draw2(srcWindow.getGeometryBuffer(), finalRect, clippingRect, colours);
                    
                    finalRect.d_left += imgSz.d_width;
                    finalRect.d_right += imgSz.d_width;
                }
                
                finalRect.d_top += imgSz.d_height;
                finalRect.d_bottom += imgSz.d_height;
            }
            
        }
        

            
    }
}