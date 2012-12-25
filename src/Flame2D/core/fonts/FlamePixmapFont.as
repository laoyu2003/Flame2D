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
    import Flame2D.core.data.GlyphItem;
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.imagesets.FlameImageSet;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameFont;
    import Flame2D.core.system.FlameImageSetManager;
    import Flame2D.core.system.FlameResourceProvider;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.Vector2;
    import Flame2D.loaders.TextFileLoader;
    import Flame2D.renderer.FlameGeometryBuffer;
    
    import flash.utils.Dictionary;

    /*!
    \brief
    Implementation of the Font class interface using static Imageset's.
    
    To create such a font you must create a Imageset with all the glyphs,
    and then define individual glyphs via defineMapping.
    */
    
    public class FlamePixmapFont extends FlameFont
    {
        
        private static const BuiltInResourceGroup:String = "*";

        private static var d_fontPropertyPixmapImageset:FontPropertyPixmapImageset = new FontPropertyPixmapImageset();
        private static var d_fontPropertyPixmapMapping:FontPropertyPixmapMapping = new FontPropertyPixmapMapping();
        
        
        //! The imageset with the glyphs
        protected var d_glyphImages:FlameImageSet = null;
        //! Current X scaling for glyph images
        protected var d_origHorzScaling:Number = 1.0;
        //! true if we own the imageset
        protected var d_imagesetOwner:Boolean = false;
        
        //temp mapping parsed from .font file
        protected var d_codeMapping:Dictionary = new Dictionary();
        
        private var d_callback:Function = null;
        
        /*!
        \brief
        Constructor for Pixmap type fonts.
        
        \param font_name
        The name that the font will use within the CEGUI system.
        
        \param imageset_filename
        The filename of an imageset to load that will be used as the source for
        glyph images for this font.  If \a resource_group is the special value
        of "*", this parameter may instead refer to the name of an already
        loaded Imagset.
        
        \param resource_group
        The resource group identifier to use when loading the imageset file
        specified by \a imageset_filename.  If this group is set to the special
        value of "*", then \a imageset_filename instead will refer to the name
        of an existing Imageset.
        
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
        */
        public function FlamePixmapFont(
            font_name:String, 
            font_file:String,
            callback:Function,
            resource_group:String = "",
            auto_scaled:Boolean = false,
            native_horz_res:Number = 256.0,
            native_vert_res:Number = 256.0)
        {
            super(font_name, "PixmapFont", font_file,
                resource_group, auto_scaled, native_horz_res, native_vert_res);
            
            //save callback
            d_callback = callback;
            
            var url:String = FlameResourceProvider.getSingleton().getResourceDir() + 
                FlameResourceProvider.getSingleton().getFontDir() + 
                font_file;
            
            new TextFileLoader({}, url, onFontFileLoaded);
        }
        
        private function onFontFileLoaded(tag:Object, str:String):void
        {
            //parse font file
            var xml:XML = new XML(str);
            var node:XML;
            
            //parse main info
            //var name:String = node.@Name.toString();
            var filename:String = xml.@Filename.toString();
            d_nativeHorzRes = uint(xml.@NativeHorzRes.toString());
            d_nativeVertRes = uint(xml.@NativeVertRes.toString());
            d_autoScale = false;//FlamePropertyHelper.stringToBool(xml.@AutoScaled.toString());
            
            //parse codemapping
            var nodes:XMLList = xml.Mapping;
            for each(node in nodes)
            {
                var codePoint:uint = uint(node.@Codepoint.toString());
                var image:String = node.@Image.toString();
                var horzAdvance:Number = Number(node.@HorzAdvance.toString());
                if(horzAdvance == 0)
                    horzAdvance = -1.0;
                var item:GlyphItem = new GlyphItem(image, horzAdvance);
                d_codeMapping[codePoint] = item;
            }
            
            //load imageset
            FlameImageSetManager.getSingleton().create(d_name, filename, d_resourceGroup, onImageSetLoaded);
        }
        
        private function onImageSetLoaded(tag:Object):void
        {
            var name:String = tag.name;
            d_glyphImages = FlameImageSetManager.getSingleton().getImageSet(name);
            for(var obj:Object in d_codeMapping)
            {
                var key:uint = uint(obj);
                var item:GlyphItem = d_codeMapping[key];
                //define code mapping
                defineMapping(key,  item.d_name, item.d_advance);
            }
            
            addPixmapFontProperties();
            
            //reinit();
            updateFont();
            
            if(d_callback != null)
            {
                d_callback({name:d_name});
            }
        }
        
        
        public function defineMapping(codepoint:uint, image_name:String, horz_advance:Number):void
        {
            const image:FlameImage = d_glyphImages.getImage(image_name);
            
            var adv:Number = (horz_advance == -1.0) ?
                    (image.getWidth() + image.getOffsetX()) :
                    horz_advance;
            
            if (d_autoScale)
                adv *= d_origHorzScaling;
            
            if (codepoint > d_maxCodepoint)
                d_maxCodepoint = codepoint;
            
            // create a new FontGlyph with given character code
            const glyph:FlameFontGlyph = new FlameFontGlyph(adv, image);
            
            if (image.getOffsetY() < -d_ascender)
                d_ascender = -image.getOffsetY();
            if (image.getHeight() + image.getOffsetY() > -d_descender)
                d_descender = -(image.getHeight() + image.getOffsetY());
            
            d_height = d_ascender - d_descender;
            
            // add glyph to the map
            d_cp_map[codepoint] = glyph;
        }
        
        //! Return the name of the imageset the font is using for it's glyphs.
        public function getImageset():String
        {
            return d_glyphImages.getName();
        }
        
        /*!
        \brief
        Set Imageset the font is using for it's glyphs.
        
        This will potentially cause an existing imageset to be unloaded (if it
        was created specifically by, and for, this Font).  The new Imageset
        must already exist within the system.
        
        \param imageset
        Name ofan existing image set to be used as the glyph source for this
        Font.
        
        \exception UnknownObjectException
        thrown if \a imageset is not known in the system.
        */
        public function setImageset(imageset:String):void
        {
            d_resourceGroup = "*";
            d_filename = imageset;
            reinit();
        }
        
        
        
        //! Initialize the imageset.
        protected function reinit():void
        {
            if (d_imagesetOwner)
                FlameImageSetManager.getSingleton().destroy(d_glyphImages);
            
            if (d_resourceGroup == BuiltInResourceGroup)
            {
                d_glyphImages = FlameImageSetManager.getSingleton().getImageSet(d_filename);
                d_imagesetOwner = false;
            }
            else
            {
                //todo, fix async loading
                FlameImageSetManager.getSingleton().createFromImageFile(d_filename, d_filename,
                    d_resourceGroup, onGlyphImageLoaded);
                d_imagesetOwner = true;
            }
        }
        
        private function onGlyphImageLoaded(tag:Object):void
        {
            d_glyphImages = FlameImageSetManager.getSingleton().getImageSet(tag.name);
        }
        
        
        //! Register all properties of this class.
        protected function addPixmapFontProperties():void
        {
            addProperty(d_fontPropertyPixmapImageset);
            addProperty(d_fontPropertyPixmapMapping);
        }
        
        // override of functions in Font base class.
        override protected function updateFont ():void
        {
            const factor:Number = (d_autoScale ? d_horzScaling : 1.0) / d_origHorzScaling;
            
            d_ascender = 0;
            d_descender = 0;
            d_height = 0;
            d_maxCodepoint = 0;
            
//            d_glyphImages.setAutoScalingEnabled(d_autoScale);
//            d_glyphImages.setNativeResolution(new Size(d_nativeHorzRes, d_nativeVertRes));
            
            for(var obj:Object in d_cp_map)
            {
                var key:uint = uint(obj);
                if (key > d_maxCodepoint)
                    d_maxCodepoint = key;
                
                var glyph:FlameFontGlyph = d_cp_map[key];
                glyph.setAdvance(glyph.getAdvance() * factor);
                
                const img:FlameImage = glyph.getImage();
                
                if (img.getOffsetY() < d_ascender)
                    d_ascender = img.getOffsetY();
                if (img.getHeight() + img.getOffsetY() > d_descender)
                    d_descender = img.getHeight() + img.getOffsetY();
            }
            
            d_ascender = -d_ascender;
            d_descender = -d_descender;
            d_height = d_ascender - d_descender;
            
            d_origHorzScaling = d_autoScale ? d_horzScaling : 1.0;
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
            
            const base_y:Number = position.d_y + getBaseline(y_scale);
            var glyph_pos:Vector2 = position.clone();
            
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
                    if (text.charAt(c) == ' ')
                        glyph_pos.d_x += space_extra;
                }
            }
        }
        
        override protected function getGlyphData(codepoint:uint):FlameFontGlyph
        {
            if(d_cp_map.hasOwnProperty(codepoint))
            {
                return d_cp_map[codepoint];
            }
            
            throw new Error("Cound not find code glyph for codepoint:" + codepoint);
        }
        
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
    }
}