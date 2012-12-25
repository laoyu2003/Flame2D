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
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.imagesets.FlameImageSet;
    import Flame2D.core.system.FlameFont;
    import Flame2D.core.system.FlameImageSetManager;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.Vector2;
    import Flame2D.renderer.FlameGeometryBuffer;
    import Flame2D.renderer.FlameRenderer;
    import Flame2D.renderer.FlameTexture;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.system.Capabilities;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.engine.ElementFormat;
    import flash.text.engine.FontDescription;
    import flash.text.engine.FontMetrics;
    import flash.text.engine.FontPosture;
    import flash.text.engine.FontWeight;
    import flash.text.engine.TextBlock;
    import flash.text.engine.TextElement;
    import flash.text.engine.TextLine;
    import flash.utils.Dictionary;
    
    public class FlameSystemFont extends FlameFont
    {
        //a auto generated string to specify this type of font
        protected var d_imageSetPrefix:String;
        
        //an implementation of flash system font
        //! If non-zero, the overridden line spacing that we're to report.
        protected var d_specificLineSpacing:Number;
        //! Point size of font.
        protected var d_ptSize:Number;
        
        
        //flash specific
        protected var d_fontName:String = "Arial";
//        protected var d_fontWeight:String = FontWeight.NORMAL;
//        protected var d_fontPosture:String = FontPosture.NORMAL;
        
        //codepoint to font glyph map
        protected var d_codePageMap:Dictionary = new Dictionary();
        
         //cached font pages
        protected var d_fontPages:Vector.<FlameImageSet> = new Vector.<FlameImageSet>();
        //used to track if a fontPage is full, we create the next font texture automatically when texture full
        //to do: a manager to confine total font textures
        private var d_lastCodeIndex:uint = 0;
        
        //a textfield for measuring and drawing character into bitmapdata
        private var d_textField:TextField;
        //drawing from textfield to this bitmapdata first, and then copy to texture's bitmapdata
        private var d_bitmapDataCache:BitmapData;
        //texture size, should be configurable???
        private var d_textureSize:uint = 256;
        //font size: we create two sizes, if pointSize <= 16, the char size in texture is 16x16
        //if pointSize <= 32, the char size in texture is 32x32
        //larger size can be extended, if necessary
        private var d_fontSize:Number;
        //derived chars-per-row in the texture
        private var d_charsPerRow:uint;
        
        //to do
        public function FlameSystemFont(
            font_name:String, 
            point_size:Number,
            resource_group:String = "",
            auto_scaled:Boolean = false,
            native_horz_res:Number = 800.0,
            native_vert_res:Number = 600.0,
            specific_line_spacing:Number = 0.0)
        {
            super(font_name, "SystemFont", "", resource_group, auto_scaled, native_horz_res, native_vert_res);
            
            //set prefix for this kind of font
            d_imageSetPrefix = "system_font_" + font_name + "_" + point_size;

            createImageSet();

            d_fontName = font_name;
            d_ptSize = point_size;
            d_specificLineSpacing = specific_line_spacing;

            //init text field
            d_textField = new TextField();
            d_textField.text = "";
            d_textField.x = 0;
            d_textField.y = 120;
            d_textField.wordWrap = false;
            d_textField.antiAliasType = AntiAliasType.NORMAL;//AntiAliasType.ADVANCED;
            d_textField.width = 128;
            d_textField.height = 64;
            d_textField.autoSize = TextFieldAutoSize.NONE;
            d_textField.border = false;
            d_textField.textColor = 0xFFFFFF;
            //d_textField.autoSize = TextFieldAutoSize.LEFT;
            var tf:TextFormat = new TextFormat(d_fontName, d_ptSize);
            d_textField.defaultTextFormat = tf;
            
            //test only
            //FlameRenderer.getSingleton().getStage().addChild(d_textField);

            //create cache for drawing textfield
            d_fontSize = getDesiredFontSize();
            d_charsPerRow = uint(d_textureSize / d_fontSize);
            d_bitmapDataCache = new BitmapData(d_fontSize, d_fontSize, true, 0);
            
            //test only
//            var bmp:Bitmap = new Bitmap(d_bitmapDataCache);
//            bmp.x = 0;
//            bmp.y = 400;
//            FlameRenderer.getSingleton().getStage().addChild(bmp);

            
            updateFont();
            
        }
        
        override public function drawText(buffer:FlameGeometryBuffer,
                                 text:String,
                                 position:Vector2,
                                 clip_rect:Rect,
                                 colours:ColourRect,
                                 space_extra:Number = 0.0,
                                 x_scale:Number = 1.0, 
                                 y_scale:Number = 1.0):void
        {
            //trace("draw text:" + text + " onto:" + position.toString());
            //we could not draw on base line
            const base_y:Number = position.d_y + getBaseline(y_scale);
            var glyph_pos:Vector2 = position.clone();
            glyph_pos.d_x -= 2;
            
            for (var c:uint = 0; c < text.length; ++c)
            {
                var glyph:FlameFontGlyph;
                if ((glyph = getGlyphData(text.charCodeAt(c)))) // NB: assignment
                {
                    const img:FlameImage = glyph.getImage();
                    glyph_pos.d_y = base_y - (img.getOffsetY() - img.getOffsetY() * y_scale);
                    
                    //trace("     draw character:" + text.charAt(c) + " onto:" + glyph_pos.toString());
                    img.draw(buffer, glyph_pos, glyph.getSize(x_scale, y_scale), 
                        clip_rect, colours.d_top_left, colours.d_top_right,
                        colours.d_bottom_left, colours.d_bottom_right);
                    
                    //advance x position
                    glyph_pos.d_x += glyph.getAdvance(x_scale);
                    // apply extra spacing to space chars
                    if (text.charAt(c) == ' ')
                        glyph_pos.d_x += space_extra;
                }
            }
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
        override public function isCodepointAvailable(cp:uint):Boolean
        {
            return d_codePageMap.hasOwnProperty(cp);
        }
        
        override public function isCodepointAvailableOnInput(cp:uint):Boolean
        {
            if(isCodepointAvailable(cp)) return true;
            
            //create new char
            getGlyphData(cp);
            
            return true;
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
        override protected function getGlyphData(codepoint:uint):FlameFontGlyph
        {
            if(d_codePageMap.hasOwnProperty(codepoint))
            {
                return d_codePageMap[codepoint];
            }
            
            //not found, fetch font page
            var imageSet:FlameImageSet = getFreeImageSet();
            
            Misc.assert(imageSet != null);
            
            //draw text to textfield
            d_textField.text = String.fromCharCode(codepoint);
            d_bitmapDataCache.fillRect(d_bitmapDataCache.rect, 0);
            d_bitmapDataCache.draw(d_textField);
             
            //get character info
            var width:Number = d_textField.textWidth;
            var height:Number = d_textField.textHeight;
            
            //add code to imageset
            var posX:Number = int(d_lastCodeIndex % d_charsPerRow) * d_fontSize;
            var posY:Number = int(d_lastCodeIndex / d_charsPerRow) * d_fontSize;

            //copy bitmapdata to texture
            var destBitmapData:BitmapData = imageSet.getTexture().getBitmapData();
            destBitmapData.copyPixels(d_bitmapDataCache, new Rectangle(0,0,d_fontSize,d_fontSize), new Point(posX, posY));
            //destBitmapData.copyPixels(d_bitmapDataCache, d_textField.getRect(d_textField), new Point(posX, posY));
            //refresh texture in the imageset
            imageSet.getTexture().getTexture().uploadFromBitmapData(destBitmapData);
            
            //test only
//            var bitmap:Bitmap = new Bitmap(destBitmapData);
//            bitmap.x = 256;
//            bitmap.y = 0;
//            FlameRenderer.getSingleton().getStage().addChild(bitmap);
                
            var rect:Rect = new Rect(posX, posY, posX + d_fontSize, posY + d_fontSize);
            var offset:Vector2 = new Vector2(0, 0);
            var img:FlameImage = imageSet.defineImage(String.fromCharCode(codepoint), rect, offset);

            //forward to next char
            d_lastCodeIndex ++;
            
            //add to codepoint map
            var glyph:FlameFontGlyph = new FlameFontGlyph(width, img);
            d_codePageMap[codepoint] = glyph;

            return glyph;
        }
        
        private function createImageSet():FlameImageSet
        {
            var index:uint = d_fontPages.length + 1;
            
            //create a new texture, with specified size
            var tex:FlameTexture = FlameRenderer.getSingleton().createTexture();
            tex.createTextureWithSize(new Size(d_textureSize, d_textureSize));
            var bitmapData:BitmapData = new BitmapData(d_textureSize, d_textureSize, true, 0);
            tex.setBitmapData(bitmapData);
            tex.getTexture().uploadFromBitmapData(bitmapData);
            
            //create imageset, with prefix and texture
            var fset:FlameImageSet = FlameImageSetManager.getSingleton().createFontTexture(
                d_imageSetPrefix + "_" + index, tex);

            d_fontPages.push(fset);
                        
            return fset;
        }
        
        private function getFreeImageSet():FlameImageSet
        {
            var fset:FlameImageSet;
            
            //no free imageset, create new one
            if(d_lastCodeIndex == d_charsPerRow * d_charsPerRow)
            {
                fset = createImageSet();
                d_lastCodeIndex = 0;
            }
            else
            {
                fset = d_fontPages[d_fontPages.length -1];
            }
            
            return fset;
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
        override public function getTextExtent(text:String, x_scale:Number = 1.0):Number
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
            
            //return Math.max(adv_extent, cur_extent);
            return adv_extent;
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
        override public function getCharAtPixelAtBegining(text:String, pixel:Number, x_scale:Number = 1.0):uint
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
        override public function getCharAtPixel(text:String, start_char:uint, pixel:Number, x_scale:Number = 1.0):uint
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
        
        private function getDesiredFontSize():Number
        {
            if(d_ptSize <= 16) return 16;
            else if(d_ptSize <= 32) return 32;
            else throw new Error("Cannot support font bigger than 32pt");
        }
        
        override protected function updateFont():void
        {
//            uint horzdpi = System::getSingleton().getRenderer()->getDisplayDPI().d_x;
//            uint vertdpi = System::getSingleton().getRenderer()->getDisplayDPI().d_y;
//            var horzdpi:uint = Capabilities.screenDPI;
//            var vertdpi:uint = Capabilities.screenDPI;
//            
//            var hps:Number = d_ptSize * 64;
//            var vps:Number = d_ptSize * 64;
//
//            if (d_autoScale)
//            {
//                hps *= d_horzScaling;
//                vps *= d_vertScaling;
//            }
//            
            
            d_ascender = d_ptSize;
            d_descender = 0;
            d_height = d_ascender + d_descender;
            
            if (d_specificLineSpacing > 0.0)
            {
                d_height += d_specificLineSpacing;
            }

        }
        
        override protected function setMaxCodepoint(codepoint:uint):void
        {
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
        override public function getBaseline(y_scale:Number = 1.0) :Number
        {
            return -4;//-d_height;
        }
    }
}