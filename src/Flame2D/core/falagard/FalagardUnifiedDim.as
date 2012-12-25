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
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.data.Consts;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.UDim;

    /*!
    \brief
    Dimension type that represents an Unified dimension.  Implements BaseDim interface.
    */
    public class FalagardUnifiedDim extends FalagardBaseDim
    {
        
        private var d_value:UDim;
        private var d_what:uint;//  dimension type
        
        /*!
        \brief
        Constructor.
        
        \param value
        UDim holding the value to assign to this UnifiedDim.
        
        \param dim
        DimensionType value indicating what this UnifiedDim is to represent.  This is required
        because we need to know what part of the base Window that the UDim scale component is
        to operate against.
        */
        public function FalagardUnifiedDim(value:UDim, dim:uint)
        {
            this.d_value = value;
            this.d_what = dim;
        }
        

        // Implementation of the base class interface
        override protected function getValue_impl(wnd:FlameWindow):Number
        {
            switch (d_what)
            {
                case Consts.DimensionType_DT_LEFT_EDGE:
                case Consts.DimensionType_DT_RIGHT_EDGE:
                case Consts.DimensionType_DT_X_POSITION:
                case Consts.DimensionType_DT_X_OFFSET:
                case Consts.DimensionType_DT_WIDTH:
                    return d_value.asAbsolute(wnd.getPixelSize().d_width);
                    break;
                
                case Consts.DimensionType_DT_TOP_EDGE:
                case Consts.DimensionType_DT_BOTTOM_EDGE:
                case Consts.DimensionType_DT_Y_POSITION:
                case Consts.DimensionType_DT_Y_OFFSET:
                case Consts.DimensionType_DT_HEIGHT:
                    return d_value.asAbsolute(wnd.getPixelSize().d_height);
                    break;
                
                default:
                    trace("UnifiedDim::getValue - unknown or unsupported DimensionType encountered.");
                    break;
            }
            return 0;
        }
        
        
        override protected function getValue_impl2(wnd:FlameWindow, container:Rect) : Number
        {
            switch (d_what)
            {
                case Consts.DimensionType_DT_LEFT_EDGE:
                case Consts.DimensionType_DT_RIGHT_EDGE:
                case Consts.DimensionType_DT_X_POSITION:
                case Consts.DimensionType_DT_X_OFFSET:
                case Consts.DimensionType_DT_WIDTH:
                    return d_value.asAbsolute(container.getWidth());
                    break;
                
                case Consts.DimensionType_DT_TOP_EDGE:
                case Consts.DimensionType_DT_BOTTOM_EDGE:
                case Consts.DimensionType_DT_Y_POSITION:
                case Consts.DimensionType_DT_Y_OFFSET:
                case Consts.DimensionType_DT_HEIGHT:
                    return d_value.asAbsolute(container.getHeight());
                    break;
                
                default:
                    throw new Error("UnifiedDim::getValue - unknown or unsupported DimensionType encountered.");
                    break;
            }
            return 0;
        }
        
        //void writeXMLElementName_impl(XMLSerializer& xml_stream) const;
        //void writeXMLElementAttributes_impl(XMLSerializer& xml_stream) const;
        override protected function clone_impl():FalagardBaseDim
        {
            var ndim:FalagardUnifiedDim = new FalagardUnifiedDim(d_value, d_what);
            return ndim;
        }

    }
}