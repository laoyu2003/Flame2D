
package Flame2D.core.text
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.system.FlameFont;
    import Flame2D.core.system.FlameFontManager;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.utils.Colour;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.TextUtils;
    import Flame2D.core.utils.Vector2;
    import Flame2D.renderer.FlameGeometryBuffer;
    
    public class FlameRenderedStringTextComponent extends FlameRenderedStringComponent
    {
        //! pointer to the image drawn by the component.
        protected var d_text:String = "";
        //! Font to use for text rendering, 0 for system default.
        protected var d_font:FlameFont = null;
        //! ColourRect object describing the colours to use when rendering.
        protected var d_colours:ColourRect = null;
        
        
        
        
        //! Constructor
//        RenderedStringTextComponent();
//        RenderedStringTextComponent(const String& text);
//        RenderedStringTextComponent(const String& text, const String& font_name);
//        RenderedStringTextComponent(const String& text, Font* font);
        
        
        public function FlameRenderedStringTextComponent(text:String = "", font_name:String = "")
        {
            d_text = text;
            d_font = font_name.length == 0 ? null : FlameFontManager.getSingleton().getFont(font_name);
            d_colours = new ColourRect();
        }
        
        //! Set the text to be rendered by this component.
        public function setText(text:String):void
        {
            d_text = text;
        }
        
        //! return the text that will be rendered by this component
        public function getText():String
        {
            return d_text;
        }
        
        //! set the font to use when rendering the text.
        public function setFont(font:FlameFont):void
        {
            d_font = font;
        }
        
        //! set the font to use when rendering the text.
        public function setFontByName(font_name:String):void
        {
            d_font =
                font_name.length == 0 ? null : FlameFontManager.getSingleton().getFont(font_name);
        }
        
        //! return the font set to be used.  If 0 the default font will be used.
        public function getFont():FlameFont
        {
            return d_font;
        }
        
        //! Set the colour values used when rendering this component.
        public function setColours(cr:ColourRect):void
        {
            d_colours = cr;
        }
        
        //! Set the colour values used when rendering this component.
        public function setColours1(c:Colour):void
        {
            d_colours.setColours(c);
        }
        
        //! return the ColourRect object used when drawing this component.
        public function getColours():ColourRect
        {
            return d_colours;
        }
        
        // implementation of abstract base interface
        override public function draw(buffer:FlameGeometryBuffer, position:Vector2,
            mod_colours:ColourRect, clip_rect:Rect,
            vertical_space:Number, space_extra:Number):void
        {
            var fnt:FlameFont = d_font ? d_font : FlameSystem.getSingleton().getDefaultFont();
            
            if (!fnt)
                return;
            
            var final_pos:Vector2 = position.clone();
            var y_scale:Number = 1.0;
            
            // handle formatting options
            switch (d_verticalFormatting)
            {
                case Consts.VerticalFormatting_VF_BOTTOM_ALIGNED:
                    final_pos.d_y += vertical_space - getPixelSize().d_height;
                    break;
                
                case Consts.VerticalFormatting_VF_CENTRE_ALIGNED:
                    final_pos.d_y += (vertical_space - getPixelSize().d_height) / 2 ;
                    break;
                
                case Consts.VerticalFormatting_VF_STRETCHED:
                    y_scale = vertical_space / getPixelSize().d_height;
                    break;
                
                case Consts.VerticalFormatting_VF_TOP_ALIGNED:
                    // nothing additional to do for this formatting option.
                    break;
                
                default:
                    throw new Error("RenderedStringTextComponent::draw: " +
                        "unknown VerticalFormatting option specified.");
            }
            
            // apply padding to position:
            final_pos.addTo(d_padding.getPosition());
            
            // apply modulative colours if needed.
            var final_cols:ColourRect;
            if(d_colours) final_cols = d_colours;
            else final_cols = new ColourRect();
            
            if (mod_colours)
                final_cols = final_cols.multiplyColourRect(mod_colours);
            
            // draw the text string.
            fnt.drawText(buffer, d_text, final_pos, clip_rect, final_cols,
                space_extra, 1.0, y_scale);
        }
        
        override public function getPixelSize():Size
        {
            var fnt:FlameFont = d_font ? d_font : FlameSystem.getSingleton().getDefaultFont();
            
            var psz:Size = new Size(d_padding.d_left + d_padding.d_right,
                d_padding.d_top + d_padding.d_bottom);
            
            if (fnt)
            {
                psz.d_width += fnt.getTextExtent(d_text);
                psz.d_height += fnt.getFontHeight();
            }
            
            return psz;
        }
        
        override public function canSplit():Boolean
        {
            return d_text.length > 1;
        }
        
        override public function split(split_point:uint, first_component:Boolean):FlameRenderedStringComponent
        {
            var fnt:FlameFont = d_font ? d_font : FlameSystem.getSingleton().getDefaultFont();
            
            // This is checked, but should never fail, since if we had no font our
            // extent would be 0 and we would never cause a split to be needed here.
            if (!fnt)
                throw new Error("RenderedStringTextComponent::split: " +
                    "unable to split with no font set.");
            
            // create 'left' side of split and clone our basic configuration
            var lhs:FlameRenderedStringTextComponent = new FlameRenderedStringTextComponent();
            lhs.d_padding = d_padding;
            lhs.d_verticalFormatting = d_verticalFormatting;
            lhs.d_font = d_font;
            lhs.d_colours = d_colours;
            
            // calculate the 'best' place to split the text
            var left_len:uint = 0;
            var left_extent:Number = 0.0;
            
            while (left_len < d_text.length)
            {
                var token_len:uint = getNextTokenLength(d_text, left_len);
                // exit loop if no more valid tokens.
                if (token_len == 0)
                    break;
                
                const token_extent:Number = 
                    fnt.getTextExtent(d_text.substr(left_len, token_len));
                
                // does the next token extend past the split point?
                if (left_extent + token_extent > split_point)
                {
                    // if it was the first token, split the token itself
                    if (first_component && left_len == 0)
                        left_len =
                            Math.max(1,fnt.getCharAtPixelAtBegining(d_text.substr(0, token_len), split_point));
                    
                    // left_len is now the character index at which to split the line
                    break;
                }
                
                // add this token to the left side
                left_len += token_len;
                left_extent += token_extent;
            }
            
            // perform the split.
            lhs.d_text = d_text.substr(0, left_len);
            
            // here we're trimming leading delimiters from the substring range 
            var rhs_start:uint =
                TextUtils.find_first_not_of(d_text, TextUtils.DefaultWrapDelimiters, left_len);
            if (rhs_start == -1)
                rhs_start = left_len;
            
            d_text = d_text.substr(rhs_start);
            
            return lhs;
        }
        
        
        override public function clone():FlameRenderedStringComponent
        {
            //todo
            var c:FlameRenderedStringTextComponent = new FlameRenderedStringTextComponent();
            c.d_text = new String(d_text);
            c.d_font = d_font;
            c.d_colours = d_colours;
            
            return c;
        }
        
        
        override public function getSpaceCount():uint
        {
            // TODO: The value calculated here is a good candidate for caching.
            
            var space_count:uint = 0;
            
            // Count the number of spaces in this component.
            // NB: here I'm not countng tabs since those are really intended to be
            // something other than just a bigger space.
            const char_count:uint = d_text.length;
            for (var c:uint = 0; c < char_count; ++c)
                if (d_text.charAt(c) == ' ') // TODO: There are other space characters!
                    ++space_count;
            
            return space_count;
        }
        
        
        protected static function getNextTokenLength(text:String, start_idx:uint):uint
        {
            var word_start:int =
                TextUtils.find_first_not_of(text, TextUtils.DefaultWrapDelimiters, start_idx);
            
            if (word_start == -1)
                word_start = start_idx;
            
            var word_end:int =
                TextUtils.find_first_of(text, TextUtils.DefaultWrapDelimiters, word_start);
            
            if (word_end == -1)
                word_end = text.length;
            
            return word_end - start_idx;
        }


    }
    
}