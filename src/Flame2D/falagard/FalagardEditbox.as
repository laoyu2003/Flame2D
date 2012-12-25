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
package Flame2D.falagard
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.falagard.FalagardImagerySection;
    import Flame2D.core.falagard.FalagardStateImagery;
    import Flame2D.core.falagard.FalagardWidgetLookFeel;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameFont;
    import Flame2D.core.system.FlameWindowRenderer;
    import Flame2D.core.utils.Colour;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.CoordConverter;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Vector2;
    import Flame2D.elements.editbox.EditboxWindowRenderer;
    import Flame2D.elements.editbox.FlameEditbox;
    
    /*!
    \brief
    Editbox class for the FalagardBase module.
    
    This class requires LookNFeel to be assigned.  The LookNFeel should provide
    the following:
    
    States:
    - Enabled: Rendering for when the editbox is in enabled and is in
    read-write mode.
    - ReadOnly: Rendering for when the editbox is in enabled and is in
    read-only mode.
    - Disabled: Rendering for when the editbox is disabled.
    - ActiveSelection: additional state rendered for text selection
    (the imagery in this section is rendered within the
    selection area.)
    - InactiveSelection: additional state rendered for text selection
    (the imagery in this section is rendered within the
    selection area.)
    
    NamedAreas:
    - TextArea: area where text, selection, and carat imagery will appear.
    
    PropertyDefinitions (optional)
    - NormalTextColour: property that accesses a colour value to be used to
    render normal unselected text.  If this property is
    not defined, the colour defaults to black.
    - SelectedTextColour: property that accesses a colour value to be used
    to render selected text.  If this property is
    not defined, the colour defaults to black.
    
    Imagery Sections:
    - Carat
    */
    public class FalagardEditbox extends EditboxWindowRenderer
    {
        
        public static const TypeName:String = "Falagard/Editbox";
        
        //! Name of property to access for unselected text colour.
        public static const UnselectedTextColourPropertyName:String = "NormalTextColour";
        //! Name of property to access for selected text colour.
        public static const SelectedTextColourPropertyName:String = "SelectedTextColour";
        //! The default timeout (in seconds) used when blinking the caret.
        public static const DefaultCaretBlinkTimeout:Number = 0.66;

        
        // properties
        protected static var d_blinkCaretProperty:FalagardEditboxPropertyBlinkCaret = new FalagardEditboxPropertyBlinkCaret();
        protected static var d_blinkCaretTimeoutProperty:FalagardEditboxPropertyBlinkCaretTimeout = new FalagardEditboxPropertyBlinkCaretTimeout();
        protected static var d_textFormattingProperty:FalagardEditboxPropertyTextFormatting = new FalagardEditboxPropertyTextFormatting();

        
        //! x rendering offset used last time we drew the widget.
        protected var d_lastTextOffset:Number = 0.0;
        //! true if the caret imagery should blink.
        protected var d_blinkCaret:Boolean = false;
        //! time-out in seconds used for blinking the caret.
        protected var d_caretBlinkTimeout:Number = DefaultCaretBlinkTimeout;
        //! current time elapsed since last caret blink state change.
        protected var d_caretBlinkElapsed:Number = 0.0;
        //! true if caret should be shown.
        protected var d_showCaret:Boolean = false;
        //! horizontal formatting.  Only supports left, right, and centred.
        protected var d_textFormatting:uint = Consts.HorizontalTextFormatting_HTF_LEFT_ALIGNED;
        
        public function FalagardEditbox(type:String)
        {
            super(type);
            
            registerProperty(d_blinkCaretProperty);
            registerProperty(d_blinkCaretTimeoutProperty);
            registerProperty(d_textFormattingProperty);
        }
        
        /*!
        \brief
        return the colour to be used for rendering Editbox text oustside of the
        selected region.
        
        \return
        colour value describing the colour to be used.
        */
        public function getUnselectedTextColour():Colour
        {
            return getOptionalPropertyColour(UnselectedTextColourPropertyName);
        }
        
        /*!
        \brief
        return the colour to be used for rendering Editbox text falling within
        the selected region.
        
        \return
        colour value describing the colour to be used.
        */
        public function getSelectedTextColour():Colour
        {
            return getOptionalPropertyColour(SelectedTextColourPropertyName);
        }
        
        /*!
        \brief
        Return a colour object fetched from the named property if it exists,
        else a default colour (black).
        
        \param propertyName
        String object holding the name of the property to be accessed if it
        exists.
        */
        public function getOptionalPropertyColour(propertyName:String):Colour
        {
            if (d_window.isPropertyPresent(propertyName))
                return FlamePropertyHelper.stringToColour(
                    d_window.getProperty(propertyName));
            else
                return new Colour(0, 0, 0);
        }
        
        //! return whether the blinking caret is enabled.
        public function isCaretBlinkEnabled():Boolean
        {
            return d_blinkCaret;
        }
        
        //! return the caret blink timeout period (only used if blink is enabled).
        public function getCaretBlinkTimeout():Number
        {
            return d_caretBlinkTimeout;
        }
        
        //! set whether the blinking caret is enabled.
        public function setCaretBlinkEnabled(enable:Boolean):void
        {
            d_blinkCaret = enable;
        }
        
        //! set the caret blink timeout period (only used if blink is enabled).
        public function setCaretBlinkTimeout(seconds:Number):void
        {
            d_caretBlinkTimeout = seconds;
        }
        
        /*!
        \brief
        Sets the horizontal text formatting to be used from now onwards.
        
        \param format
        Specifies the formatting to use.  Currently can only be one of the
        following HorizontalTextFormatting values:
        - HTF_LEFT_ALIGNED (default)
        - HTF_RIGHT_ALIGNED
        - HTF_CENTRE_ALIGNED
        */
        public function setTextFormatting(format:uint):void
        {
            if (isUnsupportedFormat(format))
                throw new Error(
                    "FalagardEditbox::setTextFormatting: currently only " +
                    "HTF_LEFT_ALIGNED, HTF_RIGHT_ALIGNED and HTF_CENTRE_ALIGNED " +
                    "are accepted for Editbox formatting");
            
            d_textFormatting = format;
            d_window.invalidate();
        }
        
        public function getTextFormatting():uint
        {
            return d_textFormatting;
        }
        
        override public function render():void
        {
            const wlf:FalagardWidgetLookFeel = getLookNFeel();
            
            renderBaseImagery(wlf);

            // no font == no more rendering
            const font:FlameFont = d_window.getFont();
            if (!font)
                return;
            
            var visual_text:String = setupVisualString();
            
            const caret_imagery:FalagardImagerySection = wlf.getImagerySection("Carat");
            
            // get destination area for text
            const text_area:Rect = wlf.getNamedArea("TextArea").getArea().getPixelRect(d_window);
            
            const caret_index:uint = getCaretIndex(visual_text);
            const extent_to_caret:Number = font.getTextExtent(visual_text.substring(0, caret_index));
            const caret_width:Number = caret_imagery.getBoundingRectWithinRect(d_window, text_area).getWidth();
            const text_extent:Number = font.getTextExtent(visual_text);
            const text_offset:Number = calculateTextOffset(text_area, text_extent, caret_width, extent_to_caret);
            
            renderTextNoBidi(wlf, visual_text, text_area, text_offset);
            
            // remember this for next time.
            d_lastTextOffset = text_offset;
            
            renderCaret(caret_imagery, text_area, text_offset, extent_to_caret);
        }
        
        // overridden from EditboxWindowRenderer base class.
        override public function getTextIndexFromPosition(pt:Vector2):uint
        {
            var w:FlameEditbox = d_window as FlameEditbox;
            
            // calculate final window position to be checked
            var wndx:Number = CoordConverter.screenToWindowX(w, pt.d_x);
            
            wndx -= d_lastTextOffset;
            
            // Return the proper index
            if (w.isTextMasked())
            {
                var str:String = "";
                for(var i:uint=0; i<w.getTextVisual().length; i++)
                {
                    str += String.fromCharCode(w.getMaskCodePoint());
                }
                return w.getFont().getCharAtPixelAtBegining(str, wndx);
            } 
            else
            {
                return w.getFont().getCharAtPixelAtBegining(w.getTextVisual(), wndx);
            }
        }
        
        
        // overridden from WindowRenderer class
        override public function update(elapsed:Number = 0):void
        {
            // do base class stuff
            super.update(elapsed);
            
            // only do the update if we absolutely have to
            if (d_blinkCaret &&
                !(d_window as FlameEditbox).isReadOnly() &&
                (d_window as FlameEditbox).hasInputFocus())
            {
                d_caretBlinkElapsed += elapsed;
                
                if (d_caretBlinkElapsed > d_caretBlinkTimeout)
                {
                    d_caretBlinkElapsed = 0.0;
                    d_showCaret = ! d_showCaret;
                    // state changed, so need a redraw
                    d_window.invalidate();
                }
            }
        }
        
        
        //! helper to draw the base imagery (container and what have you)
        protected function renderBaseImagery(wlf:FalagardWidgetLookFeel):void
        {
            var w:FlameEditbox = d_window as FlameEditbox;
            
            const imagery:FalagardStateImagery = wlf.getStateImagery(
                w.isDisabled() ? "Disabled" : (w.isReadOnly() ? "ReadOnly" : "Enabled"));
            
            imagery.render(w);
        }
        
        //! helper to set 'visual' to the string we will render (part of)
        protected function setupVisualString():String
        {
            var visual:String = "";
            
            var w:FlameEditbox = d_window as FlameEditbox;
            
            if (w.isTextMasked())
            {
                var len:uint = w.getText().length;
                for(var i:uint=0; i<len; i++)
                {
                    visual += String.fromCharCode(w.getMaskCodePoint());
                }
            }
            else
            {
                //to be checked
                visual = w.getTextVisual();
            }
            
            return visual;
        }
        
        
        protected function getCaretIndex(visual_string:String):uint
        {
            var w:FlameEditbox = d_window as FlameEditbox;
            
            var caretIndex:uint = w.getCaratIndex();
            
            return caretIndex;
        }
        
        
        protected function calculateTextOffset(text_area:Rect,
            text_extent:Number,
            caret_width:Number,
            extent_to_caret:Number):Number
        {
            // if carat is to the left of the box
            if ((d_lastTextOffset + extent_to_caret) < 0)
                return -extent_to_caret;
            
            // if carat is off to the right.
            if ((d_lastTextOffset + extent_to_caret) >= (text_area.getWidth() - caret_width))
                return text_area.getWidth() - extent_to_caret - caret_width;
            
            // handle formatting of text when it's shorter than the available space
            if (text_extent < text_area.getWidth())
            {
                if (d_textFormatting == Consts.HorizontalTextFormatting_HTF_CENTRE_ALIGNED)
                    return (text_area.getWidth() - text_extent) / 2;
                
                if (d_textFormatting == Consts.HorizontalTextFormatting_HTF_RIGHT_ALIGNED)
                    return text_area.getWidth() - text_extent;
            }
            
            // no change to text position; re-use last offset value.
            return d_lastTextOffset;
        }
        
        protected function renderTextNoBidi(wlf:FalagardWidgetLookFeel,
            text:String,
            text_area:Rect,
            text_offset:Number):void
        {
            const font:FlameFont = d_window.getFont();
            
            // setup initial rect for text formatting
            var text_part_rect:Rect = text_area.clone();
            // allow for scroll position
            text_part_rect.d_left += text_offset;
            // centre text vertically within the defined text area
            text_part_rect.d_top += (text_area.getHeight() - font.getFontHeight()) * 0.5;
            
            var colours:ColourRect = new ColourRect();
            const alpha_comp:Number = d_window.getEffectiveAlpha();
            // get unhighlighted text colour (saves accessing property twice)
            const unselectedColour:Colour = getUnselectedTextColour();
            // see if the editbox is active or inactive.
            const w:FlameEditbox = d_window as FlameEditbox;
            const active:Boolean = editboxIsFocussed();
            
            if (w.getSelectionLength() != 0)
            {
                // calculate required start and end offsets of selection imagery.
                var selStartOffset:Number =
                    font.getTextExtent(text.substr(0, w.getSelectionStartIndex()));
                var selEndOffset:Number =
                    font.getTextExtent(text.substr(0, w.getSelectionEndIndex()));
                
                // calculate area for selection imagery.
                var hlarea:Rect = text_area.clone();
                hlarea.d_left += text_offset + selStartOffset;
                hlarea.d_right = hlarea.d_left + (selEndOffset - selStartOffset);
                
                // render the selection imagery.
                wlf.getStateImagery(active ? "ActiveSelection" :
                    "InactiveSelection").
                    render2(w, hlarea, null, text_area);
            }
            
            // draw pre-highlight text
            var sect:String = text.substr(0, w.getSelectionStartIndex());
            colours.setColours(unselectedColour);
            colours.modulateAlpha(alpha_comp);
            font.drawText(w.getGeometryBuffer(), sect, text_part_rect.getPosition(),
                text_area, colours);
            
            // adjust rect for next section
            text_part_rect.d_left += font.getTextExtent(sect);
            
            // draw highlight text
            sect = text.substr(w.getSelectionStartIndex(), w.getSelectionLength());
            colours.setColours(getSelectedTextColour());
            colours.modulateAlpha(alpha_comp);
            font.drawText(w.getGeometryBuffer(), sect, text_part_rect.getPosition(),
                text_area, colours);
            
            // adjust rect for next section
            text_part_rect.d_left += font.getTextExtent(sect);
            
            // draw post-highlight text
            sect = text.substr(w.getSelectionEndIndex());
            colours.setColours(unselectedColour);
            colours.modulateAlpha(alpha_comp);
            font.drawText(w.getGeometryBuffer(), sect, text_part_rect.getPosition(),
                text_area, colours);
        }
        
//        void renderTextBidi(const WidgetLookFeel& wlf,
//            const String& text,
//            const Rect& text_area,
//            float text_offset);
        
        
        protected function editboxIsFocussed():Boolean
        {
            const w:FlameEditbox = d_window as FlameEditbox;
            return (!w.isReadOnly()) && w.hasInputFocus();
        }
        
        protected function renderCaret(imagery:FalagardImagerySection,
            text_area:Rect,
            text_offset:Number,
            extent_to_caret:Number):void
        {
            if (editboxIsFocussed() && (!d_blinkCaret || d_showCaret))
            {
                var caratRect:Rect = text_area.clone();
                caratRect.d_left += extent_to_caret + text_offset;
                
                imagery.render2(d_window, caratRect, null, text_area);
            }
        }
        
        protected function isUnsupportedFormat(format:uint):Boolean
        {
            return !(format == Consts.HorizontalTextFormatting_HTF_LEFT_ALIGNED ||
                format == Consts.HorizontalTextFormatting_HTF_RIGHT_ALIGNED ||
                format == Consts.HorizontalTextFormatting_HTF_CENTRE_ALIGNED);
        }
        
    }
}