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
    
    import flash.display.BitmapData;
    import flash.utils.ByteArray;
    import Flame2D.core.imagesets.FlameImageSet;
    import Flame2D.core.system.FlameFont;

    /*!
    \brief
    Implementation of the Font class interface using the FreeType library.
    
    This implementation tries to provide maximal support for any kind of
    fonts supported by FreeType. It has been tested on outline font formats
    like TTF and PS as well as on bitmap font formats like PCF and FON.
    
    Glyphs are rendered dynamically on demand, so a large font with lots
    of glyphs won't slow application startup time.
    */
    public class FlameTrueTypeFont extends FlameFont
    {
      
        //! If non-zero, the overridden line spacing that we're to report.
        protected var d_specificLineSpacing:Number;
        //! Point size of font.
        protected var d_ptSize:Number;
        //! True if the font should be rendered as anti-alaised by freeType.
        protected var d_antiAliased:Boolean;
        //! Type definition for ImagesetVector.
        //typedef std::vector<Imageset*> ImagesetVector;
        //! Imagesets that holds the glyphs for this font.
        //mutable ImagesetVector d_glyphImages;
        protected var d_glyphImages:Vector.<FlameImageSet> = new Vector.<FlameImageSet>();
        
        
        private static var d_fontPropertyFreeTypePointSize:FontPropertyFreeTypePointSize = new FontPropertyFreeTypePointSize() ;
        private static var d_fontPropertyFreeTypeAntialiased:FontPropertyFreeTypeAntialiased = new FontPropertyFreeTypeAntialiased();
        
        /*!
        \brief
        Constructor for FreeTypeFont based fonts.
        
        \param font_name
        The name that the font will use within the CEGUI system.
        
        \param point_size
        Specifies the point size that the font is to be rendered at.
        
        \param anti_aliased
        Specifies whether the font should be rendered using anti aliasing.
        
        \param font_filename
        The filename of an font file that will be used as the source for
        glyph images for this font.
        
        \param resource_group
        The resource group identifier to use when loading the font file
        specified by \a font_filename.
        
        \param auto_scaled
        Specifies whether the font imagery should be automatically scaled to
        maintain the same physical size (which is calculated by using the
        native resolution setting).
        
        \param native_horz_res
        The horizontal native resolution value.  This is only significant when
        auto scaling is enabled.
        
        \param native_vert_res
        The vertical native resolution value.  This is only significant when
        auto scaling is enabled.
        
        \param specific_line_spacing
        If specified (non-zero), this will be the line spacing that we will
        report for this font, regardless of what is mentioned in the font file
        itself.
        */
        public function FlameTrueTypeFont(
            font_name:String, 
            point_size:Number,
            anti_aliased:Boolean,
            font_filename:String,
            resource_group:String = "",
            auto_scaled:Boolean = false,
            native_horz_res:Number = 640.0,
            native_vert_res:Number = 480.0,
            specific_line_spacing:Number = 0.0)
        {
            super(font_name, "FreeType", font_filename,
                resource_group, auto_scaled, native_horz_res, native_vert_res);
            
            d_specificLineSpacing = specific_line_spacing;
            d_ptSize = point_size;
            d_antiAliased = anti_aliased;
                
            addFreeTypeFontProperties();
            
            updateFont();
                
        }

        //! return the point size of the freetype font.
        public function getPointSize():Number
        {
            return d_ptSize;
        }
        
        //! return whether the freetype font is rendered anti-aliased.
        public function isAntiAliased():Boolean
        {
            return d_antiAliased;
        }
        
        //! return the point size of the freetype font.
        public function setPointSize(point_size:Number):void
        {
            if (point_size == d_ptSize)
                return;
            
            d_ptSize = point_size;
            updateFont();
        }
        
        //! return whether the freetype font is rendered anti-aliased.
        public function setAntiAliased(anti_alaised:Boolean):void
        {
            if (anti_alaised == d_antiAliased)
                return;
            
            d_antiAliased = anti_alaised;
            updateFont();
        }
        
        /*!
        \brief
        Copy the current glyph data into \a buffer, which has a width of
        \a buf_width pixels (not bytes).
        
        \param buffer
        Memory buffer large enough to receive the imagery for the currently
        loaded glyph.
        
        \param buf_width
        Width of \a buffer in pixels (where each pixel is a argb_t).
        
        \return
        Nothing.
        */
        protected function drawGlyphToBuffer(buffer:BitmapData, buf_width:uint):void
        {
            
        }
        
        /*!
        \brief
        Return the required texture size required to store imagery for the
        glyphs from s to e
        \param s
        The first glyph in set
        \param e
        The last glyph in set
        */
//        protected function getTextureSize(CodepointMap::const_iterator s,
//            CodepointMap::const_iterator e):uint
//        {
//            
//        }
        
        
        //! Register all properties of this class.
        protected function addFreeTypeFontProperties():void
        {
            addProperty(d_fontPropertyFreeTypePointSize);
            addProperty(d_fontPropertyFreeTypeAntialiased);
        }
        
        // overrides of functions in Font base class.
        protected function rasterise(start_codepoint:uint, utf32 end_codepoint:uint):void
        {
            
        }

        
        protected function updateFont():void
        {
//            
//            // check that default Unicode character map is available
//            if (!d_fontFace->charmap)
//            {
//                FT_Done_Face(d_fontFace);
//                d_fontFace = 0;
//                CEGUI_THROW(GenericException("FreeTypeFont::updateFont: "
//                    "The font '" + d_name + "' does not have a Unicode charmap, and "
//                    "cannot be used."));
//            }
//            
//            uint horzdpi = System::getSingleton().getRenderer()->getDisplayDPI().d_x;
//            uint vertdpi = System::getSingleton().getRenderer()->getDisplayDPI().d_y;
//            
//            float hps = d_ptSize * 64;
//            float vps = d_ptSize * 64;
//            if (d_autoScale)
//            {
//                hps *= d_horzScaling;
//                vps *= d_vertScaling;
//            }
//            
//            if (FT_Set_Char_Size(d_fontFace, FT_F26Dot6(hps), FT_F26Dot6(vps), horzdpi, vertdpi))
//            {
//                // For bitmap fonts we can render only at specific point sizes.
//                // Try to find nearest point size and use it, if that is possible
//                float ptSize_72 = (d_ptSize * 72.0f) / vertdpi;
//                float best_delta = 99999;
//                float best_size = 0;
//                for (int i = 0; i < d_fontFace->num_fixed_sizes; i++)
//                {
//                    float size = d_fontFace->available_sizes [i].size * float(FT_POS_COEF);
//                    float delta = fabs(size - ptSize_72);
//                    if (delta < best_delta)
//                    {
//                        best_delta = delta;
//                        best_size = size;
//                    }
//                }
//                
//                if ((best_size <= 0) ||
//                    FT_Set_Char_Size(d_fontFace, 0, FT_F26Dot6(best_size * 64), 0, 0))
//                {
//                    char size [20];
//                    snprintf(size, sizeof(size), "%g", d_ptSize);
//                    CEGUI_THROW(GenericException("FreeTypeFont::load - The font '" + d_name + "' cannot be rasterised at a size of " + size + " points, and cannot be used."));
//                }
//            }
//            
//            if (d_fontFace->face_flags & FT_FACE_FLAG_SCALABLE)
//            {
//                //float x_scale = d_fontFace->size->metrics.x_scale * FT_POS_COEF * (1.0/65536.0);
//                float y_scale = d_fontFace->size->metrics.y_scale * float(FT_POS_COEF) * (1.0f / 65536.0f);
//                d_ascender = d_fontFace->ascender * y_scale;
//                d_descender = d_fontFace->descender * y_scale;
//                d_height = d_fontFace->height * y_scale;
//            }
//            else
//            {
//                d_ascender = d_fontFace->size->metrics.ascender * float(FT_POS_COEF);
//                d_descender = d_fontFace->size->metrics.descender * float(FT_POS_COEF);
//                d_height = d_fontFace->size->metrics.height * float(FT_POS_COEF);
//            }
//            
//            if (d_specificLineSpacing > 0.0f)
//            {
//                d_height = d_specificLineSpacing;
//            }
//            
//            // Create an empty FontGlyph structure for every glyph of the font
//            FT_UInt gindex;
//            FT_ULong codepoint = FT_Get_First_Char(d_fontFace, &gindex);
//            FT_ULong max_codepoint = codepoint;
//            while (gindex)
//            {
//                if (max_codepoint < codepoint)
//                    max_codepoint = codepoint;
//                
//                // load-up required glyph metrics (don't render)
//                if (FT_Load_Char(d_fontFace, codepoint,
//                    FT_LOAD_DEFAULT | FT_LOAD_FORCE_AUTOHINT))
//                    continue; // glyph error
//                
//                float adv = d_fontFace->glyph->metrics.horiAdvance * float(FT_POS_COEF);
//                
//                // create a new empty FontGlyph with given character code
//                d_cp_map[codepoint] = FontGlyph(adv);
//                
//                // proceed to next glyph
//                codepoint = FT_Get_Next_Char(d_fontFace, codepoint, &gindex);
//            }
//            
//            setMaxCodepoint(max_codepoint);
        }
        

       
        

    
    }
}