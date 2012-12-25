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
    import Flame2D.core.system.FlameFont;
    import Flame2D.core.system.FlameFontManager;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.data.Consts;
    import Flame2D.core.utils.Rect;
    
    /*!
    \brief
    Dimension type that represents some metric of a Font.  Implements BaseDim interface.
    */
    public class FalagardFontDim extends FalagardBaseDim
    {
        private var d_font:String;          //!< Name of Font.  If empty font will be taken from Window.
        private var d_text:String;          //!< String to measure for extents, if empty will use window text.
        private var d_childSuffix:String;   //!< String to hold the name suffix of the window to use for fetching missing font and/or text.
        private var d_metric:uint; //!< what metric we represent.
        private var d_padding:Number;       //!< padding value to be added.
        
        /*!
        \brief
        Constructor.
        
        \param name
        String holding the name suffix of the window to be accessed to obtain the font
        and / or text strings to be used when these items are not explicitly given.
        
        \param font
        String holding the name of the font to use for this dimension.  If the string is
        empty, the font assigned to the window passed to getValue will be used.
        
        \param text
        String holding the text to be measured for horizontal extent.  If this is empty,
        the text from the window passed to getValue will be used.
        
        \param metric
        One of the FontMetricType values indicating what we should represent.
        
        \param padding
        constant pixel padding value to be added.
        */
        public function FalagardFontDim(name:String, font:String, text:String, metric:uint, padding:Number = 0)
        {
            d_font = font;
            d_text = text;
            d_childSuffix = name;
            d_metric = metric;
            d_padding = padding;
        }
        
        // Implementation of the base class interface
        override protected function getValue_impl(wnd:FlameWindow):Number
        {
            
            // get window to use.
            const sourceWindow:FlameWindow = d_childSuffix.length == 0 ? wnd : FlameWindowManager.getSingleton().getWindow(wnd.getName() + d_childSuffix);
            // get font to use
            var fontObj:FlameFont = d_font.length == 0 ? sourceWindow.getFont() : FlameFontManager.getSingleton().getFont(d_font);
            
            if (fontObj)
            {
                switch (d_metric)
                {
                    case Consts.FontMetricType_FMT_LINE_SPACING:
                        return fontObj.getLineSpacing() + d_padding;
                        break;
                    case Consts.FontMetricType_FMT_BASELINE:
                        return fontObj.getBaseline() + d_padding;
                        break;
                    case Consts.FontMetricType_FMT_HORZ_EXTENT:
                        return fontObj.getTextExtent(d_text.length == 0 ? sourceWindow.getText() : d_text) + d_padding;
                        break;
                    default:
                        throw new Error("FontDim::getValue - unknown or unsupported FontMetricType encountered.");
                        break;
                }
            }
                // no font, return padding value only.
            else
            {
                return d_padding;
            }
        }
        
        override protected function getValue_impl2(wnd:FlameWindow, container:Rect):Number
        {
            return getValue_impl(wnd);
        }
        //void writeXMLElementName_impl(XMLSerializer& xml_stream) const;
        //void writeXMLElementAttributes_impl(XMLSerializer& xml_stream) const;
        
        override protected function clone_impl():FalagardBaseDim
        {
            var ndim:FalagardFontDim = new FalagardFontDim(d_childSuffix, d_font, d_text, d_metric, d_padding);
            return ndim;
        }
        

    }
}