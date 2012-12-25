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
    import Flame2D.core.system.FlameFont;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.data.LineInfo;
    import Flame2D.core.data.MLineInfo;
    import Flame2D.elements.editbox.FlameMultiLineEditbox;
    import Flame2D.elements.editbox.MultiLineEditboxWindowRenderer;
    import Flame2D.core.falagard.FalagardImagerySection;
    import Flame2D.core.falagard.FalagardStateImagery;
    import Flame2D.core.falagard.FalagardWidgetLookFeel;
    import Flame2D.core.utils.Colour;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Vector2;

    /*!
    \brief
    MultiLineEditbox class for the FalagardBase module.
    
    This class requires LookNFeel to be assigned.  The LookNFeel should provide the following:
    
    States:
    - Enabled    - Rendering for when the editbox is in enabled and is in read-write mode.
    - ReadOnly  - Rendering for when the editbox is in enabled and is in read-only mode.
    - Disabled  - Rendering for when the editbox is disabled.
    
    NamedAreas:
    TextArea         - area where text, selection, and carat imagery will appear.
    TextAreaHScroll  - TextArea when only horizontal scrollbar is visible.
    TextAreaVScroll  - TextArea when only vertical scrollbar is visible.
    TextAreaHVScroll - TextArea when both horizontal and vertical scrollbar is visible.
    
    PropertyDefinitions (optional, defaults will be black):
    - NormalTextColour        - property that accesses a colour value to be used to render normal unselected text.
    - SelectedTextColour      - property that accesses a colour value to be used to render selected text.
    - ActiveSelectionColour   - property that accesses a colour value to be used to render active selection highlight.
    - InactiveSelectionColour - property that accesses a colour value to be used to render inactive selection highlight.
    
    Imagery Sections:
    - Carat
    
    Child Widgets:
    Scrollbar based widget with name suffix "__auto_vscrollbar__"
    Scrollbar based widget with name suffix "__auto_hscrollbar__"
    
    */
    public class FalagardMultiLineEditbox extends MultiLineEditboxWindowRenderer
    {
        
        public static const TypeName:String = "Falagard/MultiLineEditbox";
        
        //! Name of property to use to obtain unselected text rendering colour.
        public static const UnselectedTextColourPropertyName:String = "NormalTextColour";
        //! Name of property to use to obtain selected text rendering colour.
        public static const SelectedTextColourPropertyName:String = "SelectedTextColour";
        //! Name of property to use to obtain active selection rendering colour.
        public static const ActiveSelectionColourPropertyName:String = "ActiveSelectionColour";
        //! Name of property to use to obtain inactive selection rendering colour.
        public static const InactiveSelectionColourPropertyName:String = "InactiveSelectionColour";
        //! The default timeout (in seconds) used when blinking the caret.
        public static const DefaultCaretBlinkTimeout:Number = 0.66;

        
        
        // properties
        protected static var d_blinkCaretProperty:FalagardMultiLineEditboxPropertyBlinkCaret = new FalagardMultiLineEditboxPropertyBlinkCaret();
        protected static var d_blinkCaretTimeoutProperty:FalagardMultiLineEditboxPropertyBlinkCaretTimeout = new FalagardMultiLineEditboxPropertyBlinkCaretTimeout();
        
        //! true if the caret imagery should blink.
        protected var d_blinkCaret:Boolean = false;
        //! time-out in seconds used for blinking the caret.
        protected var d_caretBlinkTimeout:Number = DefaultCaretBlinkTimeout;
        //! current time elapsed since last caret blink state change.
        protected var d_caretBlinkElapsed:Number = 0.0;
        //! true if caret should be shown.
        protected var d_showCaret:Boolean = true;
        
        
        public function FalagardMultiLineEditbox(type:String)
        {
            super(type);
            
            registerProperty(d_blinkCaretProperty);
            registerProperty(d_blinkCaretTimeoutProperty);
        }
        
        override public function render():void
        {
            var w:FlameMultiLineEditbox = d_window as FlameMultiLineEditbox;
            // render general frame and stuff before we handle the text itself
            cacheEditboxBaseImagery();
            
            // Render edit box text
            var textarea:Rect = getTextRenderArea();
            cacheTextLines(textarea);
            
            // draw caret
            if ((w.hasInputFocus() && !w.isReadOnly()) &&
                (!d_blinkCaret || d_showCaret))
                cacheCaratImagery(textarea);
        }
        
        // overridden from base classes.
        override public function getTextRenderArea():Rect
        {
            var w:FlameMultiLineEditbox = d_window as FlameMultiLineEditbox;
            const wlf:FalagardWidgetLookFeel= getLookNFeel();
            var v_visible:Boolean = w.getVertScrollbar().isVisible(true);
            var h_visible:Boolean = w.getHorzScrollbar().isVisible(true);
            
            // if either of the scrollbars are visible, we might want to use another text rendering area
            if (v_visible || h_visible)
            {
                var area_name:String = "TextArea";
                
                if (h_visible)
                {
                    area_name += "H";
                }
                if (v_visible)
                {
                    area_name += "V";
                }
                area_name += "Scroll";
                
                if (wlf.isNamedAreaDefined(area_name))
                {
                    return wlf.getNamedArea(area_name).getArea().getPixelRect(w);
                }
            }
            
            // default to plain TextArea
            return wlf.getNamedArea("TextArea").getArea().getPixelRect(w);
        }
        
        override public function update(elapsed:Number = 0):void
        {
            // do base class stuff
            super.update(elapsed);
            
            // only do the update if we absolutely have to
            if (d_blinkCaret &&
                !(d_window as FlameMultiLineEditbox).isReadOnly() &&
                (d_window as FlameMultiLineEditbox).hasInputFocus())
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
        Perform rendering of the widget control frame and other 'static' areas.  This
        method should not render the actual text.  Note that the text will be rendered
        to layer 4 and the selection brush to layer 3, other layers can be used for
        rendering imagery behind and infront of the text & selection..
        
        \return
        Nothing.
        */
        protected function cacheEditboxBaseImagery():void
        {
            var w:FlameMultiLineEditbox = d_window as FlameMultiLineEditbox;
            var imagery:FalagardStateImagery;
            
            // get WidgetLookFeel for the assigned look.
            const wlf:FalagardWidgetLookFeel = getLookNFeel();
            // try and get imagery for our current state
            imagery = wlf.getStateImagery(w.isDisabled() ? "Disabled" : (w.isReadOnly() ? "ReadOnly" : "Enabled"));
            // peform the rendering operation.
            imagery.render(w);
        }
        
        /*!
        \brief
        Render the carat.
        
        \return
        Nothing
        */
        protected function cacheCaratImagery(textArea:Rect):void
        {
            var w:FlameMultiLineEditbox = d_window as FlameMultiLineEditbox;
            var fnt:FlameFont = w.getFont();
            
            // require a font so that we can calculate carat position.
            if (fnt)
            {
                // get line that carat is in
                var caratLine:uint = w.getLineNumberFromIndex(w.getCaratIndex());
                
                const d_lines:Vector.<MLineInfo> = w.getFormattedLines();
                
                // if carat line is valid.
                if (caratLine < d_lines.length)
                {
                    // calculate pixel offsets to where carat should be drawn
                    var caratLineIdx:uint = w.getCaratIndex() - d_lines[caratLine].d_startIdx;
                    var ypos:Number = caratLine * fnt.getLineSpacing();
                    var xpos:Number = fnt.getTextExtent(w.getText().substr(d_lines[caratLine].d_startIdx, caratLineIdx));
                    
                    //             // get base offset to target layer for cursor.
                    //             Renderer* renderer = System::getSingleton().getRenderer();
                    //             float baseZ = renderer->getZLayer(7) - renderer->getCurrentZ();
                    
                    // get WidgetLookFeel for the assigned look.
                    const wlf:FalagardWidgetLookFeel = getLookNFeel();
                    // get carat imagery
                    const caratImagery:FalagardImagerySection = wlf.getImagerySection("Carat");
                    
                    // calculate finat destination area for carat
                    var caratArea:Rect = new Rect();
                    caratArea.d_left    = textArea.d_left + xpos;
                    caratArea.d_top     = textArea.d_top + ypos;
                    caratArea.setWidth(caratImagery.getBoundingRect(w).getSize().d_width);
                    caratArea.setHeight(fnt.getLineSpacing());
                    caratArea.offset2(new Vector2(-w.getHorzScrollbar().getScrollPosition(), 
                        -w.getVertScrollbar().getScrollPosition()));
                    
                    // cache the carat image for rendering.
                    caratImagery.render2(w, caratArea, null, textArea);
                }
            }
        }
        
        /*!
        \brief
        Render text lines.
        */
        protected function cacheTextLines(dest_area:Rect):void
        {
            var w:FlameMultiLineEditbox = d_window as FlameMultiLineEditbox;
            // text is already formatted, we just grab the lines and render them with the required alignment.
            var drawArea:Rect = dest_area.clone();
            var vertScrollPos:Number = w.getVertScrollbar().getScrollPosition();
            drawArea.offset2(new Vector2(-w.getHorzScrollbar().getScrollPosition(), -vertScrollPos));
            
            var fnt:FlameFont = w.getFont();
            
            if (fnt)
            {
                // calculate final colours to use.
                var colours:ColourRect = new ColourRect();
                var alpha:Number = w.getEffectiveAlpha();
                var normalTextCol:Colour = getUnselectedTextColour();
                normalTextCol.setAlpha(normalTextCol.getAlpha() * alpha);
                var selectTextCol:Colour = getSelectedTextColour();
                selectTextCol.setAlpha(selectTextCol.getAlpha() * alpha);
                var selectBrushCol:Colour = w.hasInputFocus() ? getActiveSelectionColour() :
                    getInactiveSelectionColour();
                selectBrushCol.setAlpha(selectBrushCol.getAlpha() * alpha);
                
                var d_lines:Vector.<MLineInfo> = w.getFormattedLines();
                const numLines:uint = d_lines.length;
                
                // calculate the range of visible lines
                var sidx:uint,eidx:uint;
                sidx = uint(vertScrollPos / fnt.getLineSpacing());
                eidx = 1 + sidx + uint(dest_area.getHeight() / fnt.getLineSpacing());
                eidx = Math.min(eidx, numLines);
                drawArea.d_top += fnt.getLineSpacing()*Number(sidx);
                
                // for each formatted line.
                for (var i:uint = sidx; i < eidx; ++i)
                {
                    var lineRect:Rect = drawArea.clone();
                    var currLine:MLineInfo = d_lines[i];
                    var lineText:String = w.getTextVisual().substr(currLine.d_startIdx, currLine.d_length);
                    
                    // offset the font little down so that it's centered within its own spacing
                    var old_top:Number = lineRect.d_top;
                    lineRect.d_top += (fnt.getLineSpacing() - fnt.getFontHeight()) * 0.5;
                    
                    // if it is a simple 'no selection area' case
                    if ((currLine.d_startIdx >= w.getSelectionEndIndex()) ||
                        ((currLine.d_startIdx + currLine.d_length) <= w.getSelectionStartIndex()) ||
                        (w.getSelectionBrushImage() == null))
                    {
                        colours.setColours(normalTextCol);
                        // render the complete line.
                        fnt.drawText(w.getGeometryBuffer(), lineText,
                            lineRect.getPosition(), dest_area, colours);
                    }
                    // we have at least some selection highlighting to do
                    else
                    {
                        // Start of actual rendering section.
                        var sect:String;
                        var sectIdx:uint = 0, sectLen:uint;
                        var selStartOffset:Number = 0.0, selAreaWidth:Number = 0.0;
                        
                        // render any text prior to selected region of line.
                        if (currLine.d_startIdx < w.getSelectionStartIndex())
                        {
                            // calculate length of text section
                            sectLen = w.getSelectionStartIndex() - currLine.d_startIdx;
                            
                            // get text for this section
                            sect = lineText.substr(sectIdx, sectLen);
                            sectIdx += sectLen;
                            
                            // get the pixel offset to the beginning of the selection area highlight.
                            selStartOffset = fnt.getTextExtent(sect);
                            
                            // draw this portion of the text
                            colours.setColours(normalTextCol);
                            fnt.drawText(w.getGeometryBuffer(), sect,
                                lineRect.getPosition(), dest_area, colours);
                            
                            // set position ready for next portion of text
                            lineRect.d_left += selStartOffset;
                        }
                        
                        // calculate the length of the selected section
                        sectLen = Math.min(w.getSelectionEndIndex() - currLine.d_startIdx, currLine.d_length) - sectIdx;
                        
                        // get the text for this section
                        sect = lineText.substr(sectIdx, sectLen);
                        sectIdx += sectLen;
                        
                        // get the extent to use as the width of the selection area highlight
                        selAreaWidth = fnt.getTextExtent(sect);
                        
                        const text_top:Number = lineRect.d_top;
                        lineRect.d_top = old_top;
                        
                        // calculate area for the selection brush on this line
                        lineRect.d_left = drawArea.d_left + selStartOffset;
                        lineRect.d_right = lineRect.d_left + selAreaWidth;
                        lineRect.d_bottom = lineRect.d_top + fnt.getLineSpacing();
                        
                        // render the selection area brush for this line
                        colours.setColours(selectBrushCol);
                        w.getSelectionBrushImage().draw2(w.getGeometryBuffer(), lineRect, dest_area, colours);
                        
                        // draw the text for this section
                        colours.setColours(selectTextCol);
                        fnt.drawText(w.getGeometryBuffer(), sect,
                            lineRect.getPosition(), dest_area, colours);
                        
                        lineRect.d_top = text_top;
                        
                        // render any text beyond selected region of line
                        if (sectIdx < currLine.d_length)
                        {
                            // update render position to the end of the selected area.
                            lineRect.d_left += selAreaWidth;
                            
                            // calculate length of this section
                            sectLen = currLine.d_length - sectIdx;
                            
                            // get the text for this section
                            sect = lineText.substr(sectIdx, sectLen);
                            
                            // render the text for this section.
                            colours.setColours(normalTextCol);
                            fnt.drawText(w.getGeometryBuffer(), sect,
                                lineRect.getPosition(), dest_area, colours);
                        }
                    }
                    
                    // update master position for next line in paragraph.
                    drawArea.d_top += fnt.getLineSpacing();
                }
            }
        }
        
        /*!
        \brief
        return the colour to be used for rendering Editbox text oustside of the
        selected region.
        
        \return
        colour value describing the colour to be used.
        */
        protected function getUnselectedTextColour():Colour
        {
            return getOptionalPropertyColour(UnselectedTextColourPropertyName);
        }
        
        /*!
        \brief
        return the colour to be used for rendering the selection highlight
        when the editbox is active.
        
        \return
        colour value describing the colour to be used.
        */
        protected function getActiveSelectionColour():Colour
        {
            return getOptionalPropertyColour(ActiveSelectionColourPropertyName);
        }
        
        /*!
        \brief
        return the colour to be used for rendering the selection highlight
        when the editbox is inactive.
        
        \return
        colour value describing the colour to be used.
        */
        protected function getInactiveSelectionColour():Colour
        {
            return getOptionalPropertyColour(InactiveSelectionColourPropertyName);
        }
        
        /*!
        \brief
        return the colour to be used for rendering Editbox text falling within
        the selected region.
        
        \return
        colour value describing the colour to be used.
        */
        protected function getSelectedTextColour():Colour
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
        protected function getOptionalPropertyColour(propertyName:String):Colour
        {
            if (d_window.isPropertyPresent(propertyName))
                return FlamePropertyHelper.stringToColour(d_window.getProperty(propertyName));
            else
                return new Colour(0,0,0);
        }
        
    }
}