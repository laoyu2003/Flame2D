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
package Flame2D.core.imagesets
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.utils.Colour;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.Vector2;
    import Flame2D.renderer.FlameGeometryBuffer;
        
    public class FlameImage
    {
        //members
        
        //the imageset this image belong to
        private var d_imageSet:FlameImageSet;
        
        //name of the image
        private var d_name:String;
        
        //the rectangle area of this image
        private var d_area:Rect;
        
        //the offset when rendered
        private var d_offset:Vector2;
        
        //scaling of the image
        private var d_scaledWidth:Number;
        private var d_scaledHeight:Number;
        
        //
        private var d_scaledOffset:Vector2 = new Vector2();
        
        
        
        public function FlameImage(imageSet:FlameImageSet, name:String, area:Rect, render_offset:Vector2, horzScaling:Number, vertScaling:Number)
        {
            this.d_imageSet = imageSet;
            this.d_name = name;
            this.d_area = area;
            this.d_offset = render_offset;

            //set up initial image scaling
            setHorzScaling(horzScaling);
            setVertScaling(vertScaling);
        }
    
        public function setHorzScaling(factor:Number):void
        {
            this.d_scaledWidth = this.d_area.getWidth() * factor;
            this.d_scaledOffset.d_x = this.d_offset.d_x * factor;
        }
        
        public function setVertScaling(factor:Number):void
        {
            this.d_scaledHeight = this.d_area.getHeight() * factor;
            this.d_scaledOffset.d_y = this.d_offset.d_y * factor;
        }
        

        /*!
        \brief
        Queue the image to be drawn.
        
        \note
        The final position of the Image will be adjusted by the offset values
        defined for this Image object.  If absolute positioning is essential
        then these values should be taken into account prior to calling the
        draw() methods.  However, by doing this you take away the ability of the
        Imageset designer to adjust the alignment and positioning of Images,
        therefore your component is far less useful since it requires code
        changes to modify image positioning that could have been handled from a
        data file.
        
        \param buffer
        GeometryBuffer object where the geometry for the image will be queued.
        
        \param position
        Vector2 object containing the location where the Image is to be drawn
        
        \param size
        Size object describing the size that the Image is to be drawn at.
        
        \param clip_rect
        Rect object that defines an on-screen area that the Image will be
        clipped to when drawing.
        
        \param top_left_colour
        Colour to be applied to the top-left corner of the Image.
        
        \param top_right_colour
        Colour to be applied to the top-right corner of the Image.
        
        \param bottom_left_colour
        Colour to be applied to the bottom-left corner of the Image.
        
        \param bottom_right_colour
        Colour to be applied to the bottom-right corner of the Image.
        
        \param quad_split_mode
        One of the QuadSplitMode values specifying the way the quad geometry for
        the image is to be split into triangles.
        
        \return
        Nothing
        */
        public function draw(buffer:FlameGeometryBuffer, 
                             position:Vector2, 
                             size:Size, 
                             clip_rect:Rect,
                             top_left_colour:Colour = null,
                             top_right_colour:Colour = null,
                             bottom_left_colour:Colour = null,
                             bottom_right_colour:Colour = null,
                             quad_split_mode:uint = 0
                            ):void
        {
            if(top_left_colour == null) top_left_colour = new Colour();
            if(top_right_colour == null) top_right_colour = new Colour();
            if(bottom_left_colour == null) bottom_left_colour = new Colour();
            if(bottom_right_colour == null) bottom_right_colour = new Colour();
            var colourRect:ColourRect = new ColourRect(top_left_colour, top_right_colour, 
                                bottom_left_colour, bottom_right_colour);
            
            var rect:Rect = new Rect(position.d_x, position.d_y, position.d_x + size.d_width, position.d_y + size.d_height);
            rect.offset2(d_scaledOffset);
           
            //trace("add image:" + d_area.toString() + " from " + d_imageSet.getName() + " to " + rect.toString());
            this.d_imageSet.draw(buffer, d_area, rect, clip_rect, colourRect, quad_split_mode);
            
        }
        

        
        /*!
        \brief
        Queue the image to be drawn. 
        
        \note
        The final position of the Image will be adjusted by the offset values
        defined for this Image object.  If absolute positioning is essential
        then these values should be taken into account prior to calling the
        draw() methods.  However, by doing this you take away the ability of the
        Imageset designer to adjust the alignment and positioning of Images,
        therefore your component is far less useful since it requires code
        changes to modify image positioning that could have been handled from a
        data file.
        
        \param buffer
        GeometryBuffer object where the geometry for the image will be queued.
        
        \param position
        Vector2 object containing the location where the Image is to be drawn.
        
        \param size
        Size object describing the size that the Image is to be drawn at.
        
        \param clip_rect
        Rect object that defines an on-screen area that the Image will be
        clipped to when drawing.
        
        \param colours
        ColourRect object that describes the colour values to use for each
        corner of the Image.
        
        \param quad_split_mode
        One of the QuadSplitMode values specifying the way the quad geometry for
        the image is to be split into triangles.
        
        \return
        Nothing
        */
//        void draw(GeometryBuffer& buffer, const Vector2& position, const Size& size,
//            const Rect* clip_rect, const ColourRect& colours,
//            QuadSplitMode quad_split_mode = TopLeftToBottomRight) const
//        {
//            draw(buffer, Rect(position.d_x, position.d_y,
//                position.d_x + size.d_width,
//                position.d_y + size.d_height),
//                clip_rect, colours, quad_split_mode);
//        }
        
        /*!
        \brief
        Queue the image to be drawn.
        
        \note
        The final position of the Image will be adjusted by the offset values
        defined for this Image object.  If absolute positioning is essential
        then these values should be taken into account prior to calling the
        draw() methods.  However, by doing this you take away the ability of the
        Imageset designer to adjust the alignment and positioning of Images,
        therefore your component is far less useful since it requires code
        changes to modify image positioning that could have been handled from a
        data file.
        
        \param buffer
        GeometryBuffer object where the geometry for the image will be queued.
        
        \param position
        Vector2 object containing the location where the Image is to be drawn
        
        \note
        The image will be drawn at it's internally defined size.
        
        \param clip_rect
        Rect object that defines an on-screen area that the Image will be
        clipped to when drawing.
        
        \param colours
        ColourRect object that describes the colour values to use for each
        corner of the Image.
        
        \param quad_split_mode
        One of the QuadSplitMode values specifying the way the quad geometry for
        the image is to be split into triangles.
        
        \return
        Nothing
        */
        
//        void draw(GeometryBuffer& buffer, const Vector2& position,
//            const Rect* clip_rect, const ColourRect& colours,
//            QuadSplitMode quad_split_mode = TopLeftToBottomRight) const
//        {
//            draw(buffer, Rect(position.d_x, position.d_y,
//                position.d_x + getWidth(),
//                position.d_y + getHeight()),
//                clip_rect, colours, quad_split_mode);
//        }
        
        /*!
        \brief
        Queue the image to be drawn.
        
        \note
        The final position of the Image will be adjusted by the offset values
        defined for this Image object.  If absolute positioning is essential
        then these values should be taken into account prior to calling the
        draw() methods.  However, by doing this you take away the ability of the
        Imageset designer to adjust the alignment and positioning of Images,
        therefore your component is far less useful since it requires code
        changes to modify image positioning that could have been handled from a
        data file.
        
        \param buffer
        GeometryBuffer object where the geometry for the image will be queued.
        
        \param position
        Vector2 object containing the location where the Image is to be drawn
        
        \param clip_rect
        Rect object that defines an on-screen area that the Image will be
        clipped to when drawing.
        
        \param top_left_colour
        Colour to be applied to the top-left corner of the Image.
        
        \param top_right_colour
        Colour to be applied to the top-right corner of the Image.
        
        \param bottom_left_colour
        Colour to be applied to the bottom-left corner of the Image.
        
        \param bottom_right_colour
        Colour to be applied to the bottom-right corner of the Image.
        
        \param quad_split_mode
        One of the QuadSplitMode values specifying the way the quad geometry for
        the image is to be split into triangles.
        
        \return
        Nothing
        */
        
//        void draw(GeometryBuffer& buffer, const Vector2& position,
//            const Rect* clip_rect,
//            const colour& top_left_colour = 0xFFFFFFFF,
//            const colour& top_right_colour = 0xFFFFFFFF,
//            const colour& bottom_left_colour = 0xFFFFFFFF,
//            const colour& bottom_right_colour = 0xFFFFFFFF,
//            QuadSplitMode quad_split_mode = TopLeftToBottomRight) const
//        {
//            draw(buffer, Rect(position.d_x, position.d_y,
//                position.d_x + getWidth(),
//                position.d_y + getHeight()),
//                clip_rect,
//                ColourRect(top_left_colour, top_right_colour,
//                    bottom_left_colour, bottom_right_colour),
//                quad_split_mode);
//        }
        
        /*!
        \brief
        Queue the image to be drawn.
        
        \note
        The final position of the Image will be adjusted by the offset values
        defined for this Image object.  If absolute positioning is essential
        then these values should be taken into account prior to calling the
        draw() methods.  However, by doing this you take away the ability of the
        Imageset designer to adjust the alignment and positioning of Images,
        therefore your component is far less useful since it requires code
        changes to modify image positioning that could have been handled from a
        data file.
        
        \param buffer
        GeometryBuffer object where the geometry for the image will be queued.
        
        \param dest_rect
        Rect object defining the area on-screen where the Image is to be drawn.
        The Image will be scaled to fill the area as required.
        
        \param clip_rect
        Rect object that defines an on-screen area that the Image will be
        clipped to when drawing.
        
        \param colours
        ColourRect object that describes the colour values to use for each
        corner of the Image.
        
        \param quad_split_mode
        One of the QuadSplitMode values specifying the way the quad geometry for
        the image is to be split into triangles.
        
        \return
        Nothing
        */
        public function draw2(buffer:FlameGeometryBuffer,
                              dest_rect:Rect,
                              clip_rect:Rect,
                              colours:ColourRect,
                              quad_split_mode:uint = 0):void
        {
            var dest:Rect = dest_rect.clone();
            
            // apply rendering offset to the destination Rect
            dest.offset2(d_scaledOffset);
            
            // draw
            
            //trace("draw image from " + d_imageSet.getName() + " ---- " + d_name + "  == onto:" + dest.toString());
            this.d_imageSet.draw(buffer, d_area, dest, clip_rect, colours, quad_split_mode);
            
        }
        
        
        
        
        //public methods
        /*!
        \brief
        Return a Size object containing the dimensions of the Image.
        
        \return
        Size object holding the width and height of the Image.
        */
        public function getSize():Size
        {
            return new Size(d_scaledWidth, d_scaledHeight);
        }

        /*!
        \brief
        Return the pixel width of the image.
        
        \return
        Width of this Image in pixels.
        */
        public function getWidth():Number
        {
            return d_scaledWidth;
        }
        
        /*!
        \brief
        Return the pixel height of the image.
        
        \return
        Height of this Image in pixels
        */
        public function getHeight():Number
        {
            return d_scaledHeight;
        }
        
        /*!
        \brief
        Return a Point object that contains the offset applied when rendering this Image
        
        \return
        Point object containing the offsets applied when rendering this Image
        */
        public function getOffsets():Vector2
        {
            return d_scaledOffset;
        }
        
        /*!
        \brief
        Return the X rendering offset
        
        \return
        X rendering offset.  This is the number of pixels that the image is offset by when rendering at any given location.
        */
        public function getOffsetX():Number
        {
            return d_scaledOffset.d_x;
        }
        
        /*!
        \brief
        Return the Y rendering offset
        
        \return
        Y rendering offset.  This is the number of pixels that the image is offset by when rendering at any given location.
        */
        public function getOffsetY():Number
        {
            return d_scaledOffset.d_y;
        }
        
        /*!
        \brief
        Return the name of this Image object.
        
        \return
        String object containing the name of this Image
        */
        public function getName():String
        {
            return d_name;
        }
        
        /*!
        \brief
        Return the name of the Imageset that contains this Image
        
        \return
        String object containing the name of the Imageset which this Image is a part of.
        */
        public function getImagesetName():String
        {
            return d_imageSet.getName();
        }
       
        /*!
        \brief
        Return the parent Imageset object that contains this Image
        
        \return
        The parent Imageset object.
        */
        public function getImageset():FlameImageSet
        {
            return d_imageSet;
        }
        
        
        /*!
        \brief
        Return Rect describing the source texture area used by this Image.
        
        \return
        Rect object that describes, in pixels, the area upon the source texture
        which is used when rendering this Image.
        */
        public function getSourceTextureArea():Rect
        {
            return d_area;
        }
        
        public function toString():String
        {
            return FlamePropertyHelper.imageToString(this);
        }
    }
}