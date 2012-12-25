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
    import Flame2D.core.system.FlameFont;
    import Flame2D.core.system.FlameFontManager;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.text.FlameCentredRenderedString;
    import Flame2D.core.text.FlameCentredRenderedStringWordWrapper;
    import Flame2D.core.text.FlameFormattedRenderedString;
    import Flame2D.core.text.FlameJustifiedRenderedString;
    import Flame2D.core.text.FlameJustifiedRenderedStringWordWrapper;
    import Flame2D.core.text.FlameLeftAignedRenderedStringWordWrapper;
    import Flame2D.core.text.FlameLeftAlignedRenderedString;
    import Flame2D.core.text.FlameRenderedString;
    import Flame2D.core.text.FlameRightAlignedRenderedString;
    import Flame2D.core.text.FlameRightAlignedRenderedStringWordWrapper;
    import Flame2D.core.utils.Colour;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;

    /*!
    \brief
    Class that encapsulates information for a text component.
    */
    public class FalagardTextComponent extends FalagardComponentBase
    {
        private var d_wl:String = "";
        
        private var d_textLogical:String = "";            //!< text rendered by this component.
        //! pointer to bidirection support object
        //BiDiVisualMapping* d_bidiVisualMapping;
        //! whether bidi visual mapping has been updated since last text change.
        //mutable bool d_bidiDataValid;
        //! RenderedString used when not using the one from the target Window.
        private var d_renderedString:FlameRenderedString = new FlameRenderedString();
        //! FormattedRenderedString object that applies formatting to the string
        //mutable RefCounted<FormattedRenderedString> d_formattedRenderedString;
        private var d_formattedRenderedString:FlameFormattedRenderedString;
        //! Tracks last used horizontal formatting (in order to detect changes)
        private var d_lastHorzFormatting:uint = Consts.HorizontalTextFormatting_HTF_LEFT_ALIGNED;
        
        private var d_font:String = "";            //!< name of font to use.
        private var d_vertFormatting:uint = Consts.VerticalTextFormatting_VTF_TOP_ALIGNED;  //!< Vertical formatting to be applied when rendering the component.
        private var d_horzFormatting:uint = Consts.HorizontalTextFormatting_HTF_LEFT_ALIGNED;  //!< Horizontal formatting to be applied when rendering the component.
        private var d_textPropertyName:String = "";             //!< Name of the property to access to obtain the text string to render.
        private var d_fontPropertyName:String = "";             //!< Name of the property to access to obtain the font to use for rendering.
        
        public function FalagardTextComponent(wl:String)
        {
            d_wl = wl;
            d_formattedRenderedString = new FlameLeftAlignedRenderedString(d_renderedString);
        }
        
        public function parseXML(xml:XML):void
        {
            parseArea(xml);
            parseText(xml);
            parseTextProperty(xml);
            parseFontProperty(xml);
            parseColours(xml);
            parseFormats(xml)
        }
        
        private function parseArea(xml:XML):void
        {
            d_area = new FalagardComponentArea(d_wl);
            d_area.parseXML(xml.Area[0]);
        }

        private function parseText(xml:XML):void
        {
            var node:XML = xml.Text[0];
            if(node)
            {
                d_textLogical = node.@string.toString();
                d_font = node.@font.toString();
            }
        }
        
        private function parseTextProperty(xml:XML):void
        {
            var node:XML = xml.TextProperty[0];
            if(node)
            {
                d_textPropertyName = node.@name.toString();
            }
        }
        
        private function parseFontProperty(xml:XML):void
        {
            var node:XML = xml.FontProperty[0];
            if(node)
            {
                d_fontPropertyName = node.@name.toString();
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
                setColoursPropertySource(node.@name.toString());
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
                var vfmt:uint = FalagardXMLHelper.stringToVertTextFormat(node.@type.toString());
                setVerticalFormatting(vfmt);
            }
            node = xml.HorzFormat[0];
            if(node)
            {
                var hfmt:uint = FalagardXMLHelper.stringToHorzTextFormat(node.@type.toString());
                setHorizontalFormatting(hfmt);
            }
            
            
            
            //format property
            node = xml.VertFormatProperty[0];
            if(node)
            {
                setVertFormattingPropertySource(node.@name.toString());
            }
            
            node = xml.HorzFormatProperty[0];
            if(node)
            {
                setHorzFormattingPropertySource(node.@name.toString());
            }
            
        }
        
        
        //! Copy constructor
        public function assign(other:FalagardTextComponent):void
        {
            if (this == other) return;
            
            d_textLogical = other.d_textLogical;
            // note we do not assign the BiDiVisualMapping object, we just mark our
            // existing one as invalid so it's data gets regenerated next time it's
            // needed.
            d_renderedString = other.d_renderedString;
            d_formattedRenderedString = other.d_formattedRenderedString;
            d_lastHorzFormatting = other.d_lastHorzFormatting;
            d_font = other.d_font;
            d_vertFormatting = other.d_vertFormatting;
            d_horzFormatting = other.d_horzFormatting;
            d_textPropertyName = other.d_textPropertyName;
            d_fontPropertyName = other.d_fontPropertyName;
            
        }
 
        /*!
        \brief
        Return the text object that will be rendered by this TextComponent.
        
        \return
        String object containing the text that will be rendered.
        */
        public function getText():String
        {
            return d_textLogical;
        }
        
        //! return text string with \e visual ordering of glyphs.
        public function getTextVisual():String
        {
            // no bidi support
//            if (!d_bidiVisualMapping)
//                return d_textLogical;
//            
//            if (!d_bidiDataValid)
//            {
//                d_bidiVisualMapping->updateVisual(d_textLogical);
//                d_bidiDataValid = true;
//            }
//            
//            return d_bidiVisualMapping->getTextVisual();
            return d_textLogical;
        }
        
        /*!
        \brief
        Set the text that will be rendered by this TextComponent.
        
        Note that setting this to the empty string ("") will cause the text from the
        base window passed when rendering to be used instead.
        
        \param text
        String containing text to render, or "" to render text from window.
        
        \return
        Nothing.
        */
        public function setText(text:String):void
        {
            d_textLogical = new String(text);
            //d_bidiDataValid = false;
        }
        
        /*!
        \brief
        Return the name of the font to be used when rendering this TextComponent.
        
        \return
        String object containing the name of a font, or "" if the window font is to be used.
        */
        public function getFont():String
        {
            return d_font;
        }
        
        /*!
        \brief
        Set the name of the font to be used when rendering this TextComponent.
        
        Note that setting this to the empty string ("") will cause the font from the
        base window passed when rendering to be used instead.
        
        \param font
        String containing name of a font
        
        \return
        Nothing.
        */
        public function setFont(font:String):void
        {
            d_font = font;
        }
        
        /*!
        \brief
        Return the current vertical formatting setting for this TextComponent.
        
        \return
        One of the VerticalTextFormatting enumerated values.
        */
        public function getVerticalFormatting():uint
        {
            return d_vertFormatting;
        }
        
        /*!
        \brief
        Set the vertical formatting setting for this TextComponent.
        
        \param fmt
        One of the VerticalTextFormatting enumerated values.
        
        \return
        Nothing.
        */
        public function setVerticalFormatting(fmt:uint):void
        {
            d_vertFormatting = fmt;
        }
        
        /*!
        \brief
        Return the current horizontal formatting setting for this TextComponent.
        
        \return
        One of the HorizontalTextFormatting enumerated values.
        */
        public function getHorizontalFormatting():uint
        {
            return d_horzFormatting;
        }
        
        /*!
        \brief
        Set the horizontal formatting setting for this TextComponent.
        
        \param fmt
        One of the HorizontalTextFormatting enumerated values.
        
        \return
        Nothing.
        */
        public function setHorizontalFormatting(fmt:uint):void
        {
            d_horzFormatting = fmt;
        }
        
        /*!
        \brief
        Writes an xml representation of this TextComponent to \a out_stream.
        
        \param xml_stream
        Stream where xml data should be output.
        
        
        \return
        Nothing.
        */
        //void writeXMLToStream(XMLSerializer& xml_stream) const;
        
        /*!
        \brief
        Return whether this TextComponent fetches it's text string via a property on the target window.
        
        \return
        - true if the text string comes via a Propery.
        - false if the text string is defined explicitly, or will come from the target window.
        */
        public function isTextFetchedFromProperty():Boolean
        {
            return d_textPropertyName.length != 0;
        }
        
        /*!
        \brief
        Return the name of the property that will be used to determine the text string to render
        for this TextComponent.
        
        \return
        String object holding the name of a Propery.
        */
        public function getTextPropertySource():String
        {
            return d_textPropertyName;
        }
        
        /*!
        \brief
        Set the name of the property that will be used to determine the text string to render
        for this TextComponent.
        
        \param property
        String object holding the name of a Propery.  The property can contain any text string to render.
        
        \return
        Nothing.
        */
        public function setTextPropertySource(property:String):void
        {
            d_textPropertyName = property;
        }
        
        /*!
        \brief
        Return whether this TextComponent fetches it's font via a property on the target window.
        
        \return
        - true if the font comes via a Propery.
        - false if the font is defined explicitly, or will come from the target window.
        */
        public function isFontFetchedFromProperty():Boolean
        {
            return d_fontPropertyName.length != 0;
        }
        
        /*!
        \brief
        Return the name of the property that will be used to determine the font to use for rendering
        the text string for this TextComponent.
        
        \return
        String object holding the name of a Propery.
        */
        public function getFontPropertySource():String
        {
            return d_fontPropertyName;
        }
        
        /*!
        \brief
        Set the name of the property that will be used to determine the font to use for rendering
        the text string of this TextComponent.
        
        \param property
        String object holding the name of a Propery.  The property should access a valid font name.
        
        \return
        Nothing.
        */
        public function setFontPropertySource(property:String):void
        {
            d_fontPropertyName = property;
        }
        
        //! return the horizontal pixel extent of the formatted rendered string.
        public function getHorizontalTextExtent():Number
        {
            return d_formattedRenderedString.getHorizontalExtent();
        }
        
        //! return the vertical pixel extent of the formatted rendered string.
        public function getVerticalTextExtent():Number
        {
            return d_formattedRenderedString.getVerticalExtent();
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
            // get font to use
            var font:FlameFont;
            
//            try
//            {
                font = d_fontPropertyName.length == 0 ?
                    ((d_font.length == 0) ? srcWindow.getFont() : FlameFontManager.getSingleton().getFont(d_font))
                    : FlameFontManager.getSingleton().getFont(srcWindow.getProperty(d_fontPropertyName));
//            }
//            catch (error:Error)
//            {
//                font = null;
//            }
            
            // exit if we have no font to use.
            if (!font)
                return;
            
            var rs:FlameRenderedString = d_renderedString;
            // do we fetch text from a property
            if (d_textPropertyName.length != 0)
            {
                // fetch text & do bi-directional reordering as needed
                var vis:String;

                vis = srcWindow.getProperty(d_textPropertyName);
                // parse string using parser from Window.
                d_renderedString =
                    srcWindow.getRenderedStringParser().parse(vis, font, null);
            }
                // do we use a static text string from the looknfeel
            else if (getTextVisual().length != 0)
                // parse string using parser from Window.
                d_renderedString = srcWindow.getRenderedStringParser().
                    parse(getTextVisual(), font, null);
                // do we have to override the font?
            else if (font != srcWindow.getFont())
                d_renderedString = srcWindow.getRenderedStringParser().
                    parse(srcWindow.getTextVisual(), font, null);
                // use ready-made RenderedString from the Window itself
            else
                rs = srcWindow.getRenderedString();
            
            setupStringFormatter(srcWindow, rs);
            d_formattedRenderedString.format(destRect.getSize());
            
            // Get total formatted height.
            const textHeight:Number = d_formattedRenderedString.getVerticalExtent();
            
            // handle dest area adjustments for vertical formatting.
            var vertFormatting:uint = d_vertFormatPropertyName.length == 0 ? d_vertFormatting :
                FalagardXMLHelper.stringToVertTextFormat(srcWindow.getProperty(d_vertFormatPropertyName));
            
            switch(vertFormatting)
            {
                case Consts.VerticalTextFormatting_VTF_CENTRE_ALIGNED:
                    destRect.d_top += (destRect.getHeight() - textHeight) * 0.5;
                    break;
                
                case Consts.VerticalTextFormatting_VTF_BOTTOM_ALIGNED:
                    destRect.d_top = destRect.d_bottom - textHeight;
                    break;
                
                default:
                    // default is VTF_TOP_ALIGNED, for which we take no action.
                    break;
            }
            
            // calculate final colours to be used
            var finalColours:ColourRect = initColoursRect(srcWindow, modColours);
            
            // offset the font little down so that it's centered within its own spacing
            //        destRect.d_top += (font->getLineSpacing() - font->getFontHeight()) * 0.5f;
            // add geometry for text to the target window.
            d_formattedRenderedString.draw(srcWindow.getGeometryBuffer(),
                destRect.getPosition(),
                finalColours, clipper);
        }
        
        
        //! helper to set up an appropriate FormattedRenderedString
        public function setupStringFormatter(window:FlameWindow, rendered_string:FlameRenderedString):void
        {
            //d_formattedRenderedString = new FlameLeftAlignedRenderedString(rendered_string);
            
            const horzFormatting:uint = d_horzFormatPropertyName.length == 0 ? d_horzFormatting :
                FalagardXMLHelper.stringToHorzTextFormat(window.getProperty(d_horzFormatPropertyName));
            
            // no formatting change
            if (horzFormatting == d_lastHorzFormatting)
            {
                d_formattedRenderedString.setRenderedString(rendered_string);
                return;
            }
            
            d_lastHorzFormatting = horzFormatting;
            
            switch(horzFormatting)
            {
                case Consts.HorizontalTextFormatting_HTF_LEFT_ALIGNED:
                    d_formattedRenderedString = new FlameLeftAlignedRenderedString(rendered_string);
                    break;
                
                case Consts.HorizontalTextFormatting_HTF_CENTRE_ALIGNED:
                    d_formattedRenderedString = new FlameCentredRenderedString(rendered_string);
                    break;
                
                case Consts.HorizontalTextFormatting_HTF_RIGHT_ALIGNED:
                    d_formattedRenderedString = new FlameRightAlignedRenderedString(rendered_string);
                    break;
                
                case Consts.HorizontalTextFormatting_HTF_JUSTIFIED:
                    d_formattedRenderedString = new FlameJustifiedRenderedString(rendered_string);
                    break;
                
                case Consts.HorizontalTextFormatting_HTF_WORDWRAP_LEFT_ALIGNED:
                    d_formattedRenderedString = new FlameLeftAignedRenderedStringWordWrapper(rendered_string);
                    break;
                
                case Consts.HorizontalTextFormatting_HTF_WORDWRAP_CENTRE_ALIGNED:
                    d_formattedRenderedString = new FlameCentredRenderedStringWordWrapper(rendered_string);
                    break;
                
                case Consts.HorizontalTextFormatting_HTF_WORDWRAP_RIGHT_ALIGNED:
                    d_formattedRenderedString = new FlameRightAlignedRenderedStringWordWrapper(rendered_string);
                    break;
                
                case Consts.HorizontalTextFormatting_HTF_WORDWRAP_JUSTIFIED:
                    d_formattedRenderedString = new FlameJustifiedRenderedStringWordWrapper(rendered_string);
                    break;
            }
        }

    }
}