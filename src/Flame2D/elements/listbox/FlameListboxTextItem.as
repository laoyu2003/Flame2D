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
package Flame2D.elements.listbox
{
    import Flame2D.core.system.FlameFont;
    import Flame2D.core.system.FlameFontManager;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.text.FlameBasicRenderedStringParser;
    import Flame2D.core.text.FlameDefaultRenderedStringParser;
    import Flame2D.core.text.FlameRenderedString;
    import Flame2D.core.utils.Colour;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.Vector2;
    import Flame2D.renderer.FlameGeometryBuffer;

    public class FlameListboxTextItem extends FlameListboxItem
    {
        
        /*************************************************************************
         Constants
         *************************************************************************/
        public static const DefaultTextColour:Colour = new Colour();			//!< Default text colour.
        
        
        /*************************************************************************
         Implementation Data
         *************************************************************************/
        //! Parser used to produce a final RenderedString from the standard String.
        protected static var d_stringParser:FlameBasicRenderedStringParser = new FlameBasicRenderedStringParser();
        //! Parser used when parsing is off.  Basically just does linebreaks.
        protected static var d_noTagsStringParser:FlameDefaultRenderedStringParser = new FlameDefaultRenderedStringParser();

        protected var d_textCols:ColourRect;			//!< Colours used for rendering the text.
        protected var d_font:FlameFont = null;				//!< Font used for rendering text.
        //! RenderedString drawn by this item.
        protected var d_renderedString:FlameRenderedString;
        //! boolean used to track when item state changes (and needs re-parse)
        protected var d_renderedStringValid:Boolean = false;
        //! boolean that specifies whether text parsing is enabled for the item.
        protected var d_textParsingEnabled:Boolean = true;
        
        /*************************************************************************
         Construction and Destruction
         *************************************************************************/
        /*!
        \brief
        base class constructor
        */
        public function FlameListboxTextItem(text:String, item_id:uint = 0, 
                                             item_data:* = null, disabled:Boolean = false, auto_delete:Boolean = true)
        {
            super(text, item_id, item_data, disabled, auto_delete);
            
            d_textCols = new ColourRect(DefaultTextColour, DefaultTextColour, DefaultTextColour, DefaultTextColour);
            
        }
        
        

        /*************************************************************************
         Accessor methods
         *************************************************************************/
        /*!
        \brief
        Return a pointer to the font being used by this ListboxTextItem
        
        This method will try a number of places to find a font to be used.  If no font can be
        found, NULL is returned.
        
        \return
        Font to be used for rendering this item
        */
        public function getFont():FlameFont
        {
            // prefer out own font
            if (d_font)
            {
                return d_font;
            }
                // try our owner window's font setting (may be null if owner uses no existant default font)
            else if (d_owner)
            {
                return d_owner.getFont();
            }
                // no owner, just use the default (which may be NULL anyway)
            else
            {
                return FlameSystem.getSingleton().getDefaultFont();
            }
        }
        
        
        /*!
        \brief
        Return the current colours used for text rendering.
        
        \return
        ColourRect object describing the currently set colours
        */
        public function getTextColours():ColourRect
        {
            return d_textCols;
        }
        
        
        /*************************************************************************
         Manipulator methods
         *************************************************************************/
        /*!
        \brief
        Set the font to be used by this ListboxTextItem
        
        \param font
        Font to be used for rendering this item
        
        \return
        Nothing
        */
        public function setFont(font:FlameFont):void
        {
            d_font = font;
            
            d_renderedStringValid = false;
        }
        
        
        /*!
        \brief
        Set the font to be used by this ListboxTextItem
        
        \param font_name
        String object containing the name of the Font to be used for rendering this item
        
        \return
        Nothing
        */
        public function setFontByName(font_name:String):void
        {
            setFont(FlameFontManager.getSingleton().getFont(font_name));
        }
        
        
        /*!
        \brief
        Set the colours used for text rendering.
        
        \param cols
        ColourRect object describing the colours to be used.
        
        \return
        Nothing.
        */
        public function setTextColours(cols:ColourRect):void
        {
            d_textCols = cols;
        }
        
        
        /*!
        \brief
        Set the colours used for text rendering.
        
        \param top_left_colour
        Colour (as ARGB value) to be applied to the top-left corner of each text glyph rendered.
        
        \param top_right_colour
        Colour (as ARGB value) to be applied to the top-right corner of each text glyph rendered.
        
        \param bottom_left_colour
        Colour (as ARGB value) to be applied to the bottom-left corner of each text glyph rendered.
        
        \param bottom_right_colour
        Colour (as ARGB value) to be applied to the bottom-right corner of each text glyph rendered.
        
        \return 
        Nothing.
        */
        public function setTextColours4(top_left_colour:Colour, top_right_colour:Colour, 
                                       bottom_left_colour:Colour, bottom_right_colour:Colour):void
        {
            d_textCols.d_top_left		= top_left_colour;
            d_textCols.d_top_right		= top_right_colour;
            d_textCols.d_bottom_left	= bottom_left_colour;
            d_textCols.d_bottom_right	= bottom_right_colour;
            
            d_renderedStringValid = false;
        }
        
        
        /*!
        \brief
        Set the colours used for text rendering.
        
        \param col
        colour value to be used when rendering.
        
        \return
        Nothing.
        */
        public function setTextColours1(col:Colour):void
        {
            setTextColours4(col, col, col, col);
        }
        
        /*!
        \brief
        Set whether the the ListboxTextItem will have it's text parsed via the
        BasicRenderedStringParser or not.
        
        \param enable
        - true if the ListboxTextItem text will be parsed.
        - false if the ListboxTextItem text will be used verbatim.
        */
        public function setTextParsingEnabled(enable:Boolean):void
        {
            d_textParsingEnabled = enable;
            d_renderedStringValid = false;
        }
        
        //! return whether text parsing is enabled for this ListboxTextItem.
        public function isTextParsingEnabled():Boolean
        {
            return d_textParsingEnabled;
        }
        
        // base class overrides
        override public function setText(text:String):void
        {
            super.setText(text);
            
            d_renderedStringValid = false;
        }
        
        
        /*************************************************************************
         Required implementations of pure virtuals from the base class.
         *************************************************************************/
        override public function getPixelSize():Size
        {
            var fnt:FlameFont = getFont();
            
            if (!fnt)
                return new Size(0, 0);
            
            if (!d_renderedStringValid)
                parseTextString();
            
            var sz:Size = new Size(0.0, 0.0);
            
            for (var i:uint = 0; i < d_renderedString.getLineCount(); ++i)
            {
                const line_sz:Size = d_renderedString.getPixelSize(i);
                sz.d_height += line_sz.d_height;
                
                if (line_sz.d_width > sz.d_width)
                    sz.d_width = line_sz.d_width;
            }
            
            return sz;
        }
        
        override public function draw(buffer:FlameGeometryBuffer, targetRect:Rect, alpha:Number, clipper:Rect):void
        {
            if (d_selected && d_selectBrush != null)
                d_selectBrush.draw2(buffer, targetRect, clipper,
                    getModulateAlphaColourRect(d_selectCols, alpha));
            
            var font:FlameFont = getFont();
            
            if (!font)
                return;
            
            var draw_pos:Vector2 = targetRect.getPosition();
            
            draw_pos.d_y += Misc.PixelAligned(
                (font.getLineSpacing() - font.getFontHeight()) * 0.5);
            
            if (!d_renderedStringValid)
                parseTextString();
            
            const final_colours:ColourRect =
                getModulateAlphaColourRect(new ColourRect(), alpha);
            
            for (var i:uint = 0; i < d_renderedString.getLineCount(); ++i)
            {
                d_renderedString.draw(i, buffer, draw_pos, final_colours, clipper, 0.0);
                draw_pos.d_y += d_renderedString.getPixelSize(i).d_height;
            }
        }
        
        protected function parseTextString():void
        {
            if (d_textParsingEnabled)
                d_renderedString =
                    d_stringParser.parse(super.getTextVisual(), getFont(), d_textCols);
            else
                d_renderedString =
                    d_noTagsStringParser.parse(getTextVisual(), getFont(), d_textCols);
            
            d_renderedStringValid = true;
        }
    }
}