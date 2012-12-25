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
package Flame2D.core.system
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.fonts.FlameFontGlyph;
    import Flame2D.core.fonts.FontPropertyAutoScaled;
    import Flame2D.core.fonts.FontPropertyName;
    import Flame2D.core.fonts.FontPropertyNativeRes;
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.properties.FlamePropertySet;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.Vector2;
    import Flame2D.renderer.FlameGeometryBuffer;
    import Flame2D.renderer.FlameRenderer;
    
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;

    /*!
    \brief
    Class that encapsulates a typeface.
    
    A Font object is created for each unique typeface required.
    The Font class provides methods for loading typefaces from various sources,
    and then for outputting text via the Renderer object.
    
    This class is not specific to any font renderer, it just provides the
    basic interfaces needed to manage fonts.
    */
    public class FlameFont extends FlamePropertySet
    {
        //! Colour value used whenever a colour is not specified.
        public static const DefaultColour:uint = 0xFFFFFFFF;

        
        //! Holds default resource group for font loading.
        protected static var d_defaultResourceGroup:String;
        
        
        
        public static const GLYPHS_PER_PAGE:uint                =  256;
        public static const BITS_PER_UINT:uint                  = 32;
        // Pixels to put between glyphs
        public static const INTER_GLYPH_PAD_SPACE:uint          = 2;
        // A multiplication coefficient to convert FT_Pos values into normal floats
        public static const FT_POS_COEF:Number                  = (1.0/64.0);
        
        //----------------------------------------------------------------------------//
        // Font objects usage count
        public static const ft_usage_count:uint = 0;
        
        
        private static var d_fontPropertyName:FontPropertyName = new FontPropertyName();
        private static var d_fontPropertyNativeRes:FontPropertyNativeRes = new FontPropertyNativeRes();
        private static var d_fontPropertyAutoScaled:FontPropertyAutoScaled = new FontPropertyAutoScaled();
        
        
        //! Name of this font.
        protected var d_name:String;
        //! Type name string for this font (not used internally)
        protected var d_type:String;
        //! Name of the file used to create this font (font file or imagset)
        protected var d_filename:String;
        //! Name of the font file's resource group.
        protected var d_resourceGroup:String;

        //! maximal font ascender (pixels above the baseline)
        protected var d_ascender:Number = 0.0;
        //! maximal font descender (negative pixels below the baseline)
        protected var d_descender:Number = 0.0;
        //! (ascender - descender) + linegap
        protected var d_height:Number = 0.0;

        //! native horizontal resolution for this Imageset.
        protected var d_nativeHorzRes:Number;
        //! native vertical resolution for this Imageset.
        protected var d_nativeVertRes:Number;

        //! true when auto-scaling is enabled.
        protected var d_autoScale:Boolean = false;
        //! current horizontal scaling factor.
        protected var d_horzScaling:Number = 1.0;
        //! current vertical scaling factor.
        protected var d_vertScaling:Number = 1.0;
        
        
        //! Maximal codepoint for font glyphs
        protected var d_maxCodepoint:uint = 0;

        
        /*!
        \brief
        This bitmap holds information about loaded 'pages' of glyphs.
        A glyph page is a set of 256 codepoints, starting at 256-multiples.
        For example, the 1st glyph page is 0-255, fourth is 1024-1279 etc.
        When a specific glyph is required for painting, the corresponding
        bit is checked to see if the respective page has been rasterised.
        If not, the rasterise() method is invoked, which prepares the
        glyphs from the respective glyph page for being painted.
        
        This array is big enough to hold at least max_codepoint bits.
        If this member is NULL, all glyphs are considered pre-rasterised.
        */
        protected var d_glyphPageLoaded:ByteArray = new ByteArray();
        
        //! Definition of CodepointMap type.
        //typedef std::map<utf32, FontGlyph> CodepointMap;
        //! Contains mappings from code points to Image objects
        //CodepointMap d_cp_map;
        protected var d_cp_map:Dictionary = new Dictionary();

        
        
        //! Constructor.
        public function FlameFont(name:String, 
                                  type_name:String,
                                  filename:String,
                                  resource_group:String,
                                  auto_scaled:Boolean,
                                  native_horz_res:Number,
                                  native_vert_res:Number)
        {
            d_name = name;
            d_type = type_name;
            d_filename = filename;
            d_resourceGroup = resource_group;
            d_autoScale = auto_scaled;
            d_nativeHorzRes = native_horz_res;
            d_nativeVertRes = native_vert_res;
            
            addFontProperties();
            
//            const size:Size = FlameSystem.getSingleton().getRenderer().getDisplaySize();
//            d_horzScaling = size.d_width / d_nativeHorzRes;
//            d_vertScaling = size.d_height / d_nativeVertRes;
        }
        
        
        
        //! Return the string holding the font name.
        public function getName():String
        {
            return d_name;
        }
        
        //! Return the type of the font.
        public function getTypeName():String
        {
            return d_type;
        }
        
        /*!
        \brief
        Return whether this Font can draw the specified code-point
        
        \param cp
        utf32 code point that is the subject of the query.
        
        \return
        true if the font contains a mapping for code point \a cp,
        false if it does not contain a mapping for \a cp.
        */
        public function isCodepointAvailable(cp:uint):Boolean
        {
            return (d_cp_map.find(cp) != d_cp_map.end()); 
        }
        
        public function isCodepointAvailableOnInput(cp:uint):Boolean
        {
            return true;
        }
        
        /*!
        \brief
        Draw text into a specified area of the display.
        
        \param buffer
        GeometryBuffer object where the geometry for the text be queued.
        
        \param text
        String object containing the text to be drawn.
        
        \param position
        Reference to a Vector2 object describing the location at which the text
        is to be drawn.
        
        \param clip_rect
        Rect object describing the clipping area for the drawing.
        No drawing will occur outside this Rect.
        
        \param colours
        ColourRect object describing the colours to be applied when drawing the
        text.  NB: The colours specified in here are applied to each glyph,
        rather than the text as a whole.
        
        \param space_extra
        Number of additional pixels of spacing to be added to space characters.
        
        \param x_scale
        Scaling factor to be applied to each glyph's x axis, where 1.0f is
        considered to be 'normal'.
        
        \param y_scale
        Scaling factor to be applied to each glyph's y axis, where 1.0f is
        considered to be 'normal'.
        
        \return
        Nothing.
        */
        
        public function drawText(buffer:FlameGeometryBuffer,
                                 text:String,
                                 position:Vector2,
                                 clip_rect:Rect,
                                 colours:ColourRect,
                                 space_extra:Number = 0.0,
                                 x_scale:Number = 1.0, 
                                 y_scale:Number = 1.0):void
        {
            
            const base_y:Number = position.d_y + getBaseline(y_scale);
            var glyph_pos:Vector2 = position.clone();
            
            //test only
//            clip_rect.d_right += 50;
//            clip_rect.d_bottom += 50;
            
            for (var c:uint = 0; c < text.length; ++c)
            {
                var glyph:FlameFontGlyph;
                if ((glyph = getGlyphData(text.charCodeAt(c)))) // NB: assignment
                {
                    const img:FlameImage = glyph.getImage();
                    
                    Misc.assert(img != null);
                    
                    glyph_pos.d_y =
                        base_y - (img.getOffsetY() - img.getOffsetY() * y_scale);
                    img.draw(buffer, glyph_pos.clone(),
                        glyph.getSize(x_scale, y_scale), clip_rect, colours.d_top_left, colours.d_top_right,
                                colours.d_bottom_left, colours.d_bottom_right);
                    glyph_pos.d_x += glyph.getAdvance(x_scale);
                    // apply extra spacing to space chars
                    if (text.charAt(0) == ' ')
                        glyph_pos.d_x += space_extra;
                }
            }
        }
        

        /*!
        \brief
        Set the native resolution for this Font
        
        \param size
        Size object describing the new native screen resolution for this Font.
        */
        public function setNativeResolution(size:Size):void
        {
            d_nativeHorzRes = size.d_width;
            d_nativeVertRes = size.d_height;
            
            // re-calculate scaling factors & notify images as required
            notifyDisplaySizeChanged(
                FlameSystem.getSingleton().getRenderer().getDisplaySize());
        }
        
        /*!
        \brief
        Return the native display size for this Font.  This is only relevant if
        the Font is being auto-scaled.
        
        \return
        Size object describing the native display size for this Font.
        */
        public function getNativeResolution():Size
        {
            return new Size(d_nativeHorzRes, d_nativeVertRes);
        }
        
        /*!
        \brief
        Enable or disable auto-scaling for this Font.
        
        \param auto_scaled
        - true to enable auto-scaling.
        - false to disable auto-scaling.
        */
        public function setAutoScaled(auto_scaled:Boolean):void
        {
            if (auto_scaled == d_autoScale)
                return;
            
            d_autoScale = auto_scaled;
            updateFont();
        }
        
        /*!
        \brief
        Return whether this Font is auto-scaled.
        
        \return
        - true if Font is auto-scaled.
        - false if Font is not auto-scaled.
        */
        public function isAutoScaled():Boolean
        {
            return d_autoScale;
        }
        
        /*!
        \brief
        Notify the Font that the display size may have changed.
        
        \param size
        Size object describing the display resolution
        */
        public function notifyDisplaySizeChanged(size:Size):void
        {
            d_horzScaling = size.d_width / d_nativeHorzRes;
            d_vertScaling = size.d_height / d_nativeVertRes;
            
            if (d_autoScale)
                updateFont();
        }
        
        /*!
        \brief
        Return the pixel line spacing value for.
        
        \param y_scale
        Scaling factor to be applied to the line spacing, where 1.0f
        is considered to be 'normal'.
        
        \return
        Number of pixels between vertical base lines, i.e. The minimum
        pixel space between two lines of text.
        */
        public function getLineSpacing(y_scale:Number = 1.0):Number
        { 
            return d_height * y_scale; 
        }
        
        /*!
        \brief
        return the exact pixel height of the font.
        
        \param y_scale
        Scaling factor to be applied to the height, where 1.0f
        is considered to be 'normal'.
        
        \return
        float value describing the pixel height of the font without
        any additional padding.
        */
        public function getFontHeight(y_scale:Number = 1.0):Number
        { 
            return (d_ascender - d_descender) * y_scale; 
        }
        
        /*!
        \brief
        Return the number of pixels from the top of the highest glyph
        to the baseline
        
        \param y_scale
        Scaling factor to be applied to the baseline distance, where 1.0f
        is considered to be 'normal'.
        
        \return
        pixel spacing from top of front glyphs to baseline
        */
        public function getBaseline(y_scale:Number = 1.0) :Number
        {
            return d_ascender * y_scale; 
        }
        
        /*!
        \brief
        Return the pixel width of the specified text if rendered with
        this Font.
        
        \param text
        String object containing the text to return the rendered pixel
        width for.
        
        \param x_scale
        Scaling factor to be applied to each glyph's x axis when
        measuring the extent, where 1.0f is considered to be 'normal'.
        
        \return
        Number of pixels that \a text will occupy when rendered with
        this Font.
        */
        public function getTextExtent(text:String, x_scale:Number = 1.0):Number
        {
            var glyph:FlameFontGlyph;
            var cur_extent:Number = 0, adv_extent:Number = 0, width:Number;
            
            for (var c:uint = 0; c < text.length; ++c)
            {
                glyph = getGlyphData(text.charCodeAt(c));
                
                if (glyph)
                {
                    width = glyph.getRenderedAdvance(x_scale);
                    
                    if (adv_extent + width > cur_extent)
                        cur_extent = adv_extent + width;
                    
                    adv_extent += glyph.getAdvance(x_scale);
                }
            }
            
            return Math.max(adv_extent, cur_extent);
        }
        
        /*!
        \brief
        Return the index of the closest text character in String \a text
        that corresponds to pixel location \a pixel if the text were rendered.
        
        \param text
        String object containing the text.
        
        \param pixel
        Specifies the (horizontal) pixel offset to return the character
        index for.
        
        \param x_scale
        Scaling factor to be applied to each glyph's x axis when measuring
        the text extent, where 1.0f is considered to be 'normal'.
        
        \return
        Returns a character index into String \a text for the character that
        would be rendered closest to horizontal pixel offset \a pixel if the
        text were to be rendered via this Font.  Range of the return is from
        0 to text.length(), so may actually return an index past the end of
        the string, which indicates \a pixel was beyond the last character.
        */
        public function getCharAtPixelAtBegining(text:String, pixel:Number, x_scale:Number = 1.0):uint
        {
            return getCharAtPixel(text, 0, pixel, x_scale); 
        }
        
        /*!
        \brief
        Return the index of the closest text character in String \a text,
        starting at character index \a start_char, that corresponds
        to pixel location \a pixel if the text were to be rendered.
        
        \param text
        String object containing the text.
        
        \param start_char
        index of the first character to consider.  This is the lowest
        value that will be returned from the call.
        
        \param pixel
        Specifies the (horizontal) pixel offset to return the character
        index for.
        
        \param x_scale
        Scaling factor to be applied to each glyph's x axis when measuring
        the text extent, where 1.0f is considered to be 'normal'.
        
        \return
        Returns a character index into String \a text for the character that
        would be rendered closest to horizontal pixel offset \a pixel if the
        text were to be rendered via this Font.  Range of the return is from
        0 to text.length(), so may actually return an index past the end of
        the string, which indicates \a pixel was beyond the last character.
        */
        public function getCharAtPixel(text:String, start_char:uint, pixel:Number, x_scale:Number = 1.0):uint
        {
            var glyph:FlameFontGlyph;
            var cur_extent:Number = 0;
            var char_count:uint = text.length;
            
            // handle simple cases
            if ((pixel <= 0) || (char_count <= start_char))
                return start_char;
            
            for (var c:uint = start_char; c < char_count; ++c)
            {
                glyph = getGlyphData(text.charCodeAt(c));
                
                if (glyph)
                {
                    cur_extent += glyph.getAdvance(x_scale);
                    
                    if (pixel < cur_extent)
                        return c;
                }
            }
            
            return char_count;
        }
        
        /*!
        \brief
        Sets the default resource group to be used when loading font data
        
        \param resourceGroup
        String describing the default resource group identifier to be used.
        
        \return
        Nothing.
        */
        public static function setDefaultResourceGroup(resourceGroup:String):void
        {
            d_defaultResourceGroup = resourceGroup;
        }
        
        /*!
        \brief
        Returns the default resource group currently set for Fonts.
        
        \return
        String describing the default resource group identifier that will be
        used when loading font data.
        */
        public static function getDefaultResourceGroup():String
        {
            return d_defaultResourceGroup; 
        }
   
        /*!
        \brief
        Return a pointer to the glyphDat struct for the given codepoint,
        or 0 if the codepoint does not have a glyph defined.
        
        \param codepoint
        utf32 codepoint to return the glyphDat structure for.
        
        \return
        Pointer to the glyphDat struct for \a codepoint, or 0 if no glyph
        is defined for \a codepoint.
        */
        protected function getGlyphData(codepoint:uint):FlameFontGlyph
        {
            if (codepoint > d_maxCodepoint)
                return null;
            
            if (d_glyphPageLoaded)
            {
                // Check if glyph page has been rasterised
                var page:uint = codepoint / GLYPHS_PER_PAGE;
                var mask:uint = 1 << (page & (BITS_PER_UINT - 1));
                if (!(d_glyphPageLoaded[page / BITS_PER_UINT] & mask))
                {
                    d_glyphPageLoaded[page / BITS_PER_UINT] |= mask;
                    rasterise(codepoint & ~(GLYPHS_PER_PAGE - 1),
                        codepoint | (GLYPHS_PER_PAGE - 1));
                }
            }
            
            //CodepointMap::const_iterator pos = d_cp_map.find(codepoint);
            if(d_cp_map.hasOwnProperty(codepoint))
            {
                return d_cp_map[codepoint];
            }
            
            
            return null;
        }
        
        /*!
        \brief
        This function prepares a certain range of glyphs to be ready for
        displaying. This means that after returning from this function
        glyphs from d_cp_map[start_codepoint] to d_cp_map[end_codepoint]
        should have their d_image member set. If there is an error
        during rasterisation of some glyph, it's okay to leave the
        d_image field set to NULL, in which case such glyphs will
        be skipped from display.
        \param start_codepoint
        The lowest codepoint that should be rasterised
        \param end_codepoint
        The highest codepoint that should be rasterised
        */
        protected function rasterise(start_codepoint:uint, end_codepoint:uint):void
        {
            
        }
        
        
        //! Update the font as needed, according to the current parameters.
        protected function updateFont():void
        {
            
        }
       
        /*!
        \brief
        Set the maximal glyph index. This reserves the respective
        number of bits in the d_glyphPageLoaded array.
        */
        protected function setMaxCodepoint(codepoint:uint):void
        {
            d_maxCodepoint = codepoint;
            
//            delete[] d_glyphPageLoaded;
            var npages:uint = (codepoint + GLYPHS_PER_PAGE) / GLYPHS_PER_PAGE;
            var size:uint = (npages + BITS_PER_UINT - 1) / BITS_PER_UINT;
//            d_glyphPageLoaded = new uint[size];
//            memset(d_glyphPageLoaded, 0, size * sizeof(uint));
            d_glyphPageLoaded = new ByteArray();
            d_glyphPageLoaded.length = size;
            //reset
        }
        
        private function addFontProperties():void
        {
            addProperty(d_fontPropertyName);
            addProperty(d_fontPropertyAutoScaled);
            addProperty(d_fontPropertyNativeRes);
            
        }
        
        
        

    }
}