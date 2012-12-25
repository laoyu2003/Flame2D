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

    /*!
    \brief
    Utility helper class primarily intended for use by the falagard xml parser.
    */
    public class FalagardXMLHelper
    {
        
        public static function stringToVertFormat(str:String):uint
        {
            if (str == "CentreAligned")
            {
                return Consts.VerticalFormatting_VF_CENTRE_ALIGNED;
            }
            else if (str == "BottomAligned")
            {
                return Consts.VerticalFormatting_VF_BOTTOM_ALIGNED;
            }
            else if (str == "Tiled")
            {
                return Consts.VerticalFormatting_VF_TILED;
            }
            else if (str == "Stretched")
            {
                return Consts.VerticalFormatting_VF_STRETCHED;
            }
            else
            {
                return Consts.VerticalFormatting_VF_TOP_ALIGNED;
            }
        }
            
        public static function stringToHorzFormat(str:String):uint
        {
            if (str == "CentreAligned")
            {
                return Consts.HorizontalFormatting_HF_CENTRE_ALIGNED;
            }
            else if (str == "RightAligned")
            {
                return Consts.HorizontalFormatting_HF_RIGHT_ALIGNED;
            }
            else if (str == "Tiled")
            {
                return Consts.HorizontalFormatting_HF_TILED;
            }
            else if (str == "Stretched")
            {
                return Consts.HorizontalFormatting_HF_STRETCHED;
            }
            else
            {
                return Consts.HorizontalFormatting_HF_LEFT_ALIGNED;
            }
        }
            
        public static function stringToVertAlignment(str:String):uint
        {
            if (str == "CentreAligned")
            {
                return Consts.VerticalAlignment_VA_CENTRE;
            }
            else if (str == "BottomAligned")
            {
                return Consts.VerticalAlignment_VA_BOTTOM;
            }
            else
            {
                return Consts.VerticalAlignment_VA_TOP;
            }
        }
                    
        public static function stringToHorzAlignment(str:String):uint
        {
            if (str == "CentreAligned")
            {
                return Consts.HorizontalAlignment_HA_CENTRE;
            }
            else if (str == "RightAligned")
            {
                return Consts.HorizontalAlignment_HA_RIGHT;
            }
            else
            {
                return Consts.HorizontalAlignment_HA_LEFT;
            }
        }
                        
        public static function stringToDimensionType(str:String):uint
        {
            if (str == "LeftEdge")
            {
                return Consts.DimensionType_DT_LEFT_EDGE;
            }
            else if (str == "XPosition")
            {
                return Consts.DimensionType_DT_X_POSITION;
            }
            else if (str == "TopEdge")
            {
                return Consts.DimensionType_DT_TOP_EDGE;
            }
            else if (str == "YPosition")
            {
                return Consts.DimensionType_DT_Y_POSITION;
            }
            else if (str == "RightEdge")
            {
                return Consts.DimensionType_DT_RIGHT_EDGE;
            }
            else if (str == "BottomEdge")
            {
                return Consts.DimensionType_DT_BOTTOM_EDGE;
            }
            else if (str == "Width")
            {
                return Consts.DimensionType_DT_WIDTH;
            }
            else if (str == "Height")
            {
                return Consts.DimensionType_DT_HEIGHT;
            }
            else if (str == "XOffset")
            {
                return Consts.DimensionType_DT_X_OFFSET;
            }
            else if (str == "YOffset")
            {
                return Consts.DimensionType_DT_Y_OFFSET;
            }
            else
            {
                return Consts.DimensionType_DT_INVALID;
            }
        }
                            
        public static function stringToVertTextFormat(str:String):uint
        {
            if (str == "CentreAligned")
            {
                return Consts.VerticalTextFormatting_VTF_CENTRE_ALIGNED;
            }
            else if (str == "BottomAligned")
            {
                return Consts.VerticalTextFormatting_VTF_BOTTOM_ALIGNED;
            }
            else
            {
                return Consts.VerticalTextFormatting_VTF_TOP_ALIGNED;
            }
        }
                                
        public static function stringToHorzTextFormat(str:String):uint
        {
            if (str == "CentreAligned")
            {
                return Consts.HorizontalTextFormatting_HTF_CENTRE_ALIGNED;
            }
            else if (str == "RightAligned")
            {
                return Consts.HorizontalTextFormatting_HTF_RIGHT_ALIGNED;
            }
            else if (str == "Justified")
            {
                return Consts.HorizontalTextFormatting_HTF_JUSTIFIED;
            }
            else if (str == "WordWrapLeftAligned")
            {
                return Consts.HorizontalTextFormatting_HTF_WORDWRAP_LEFT_ALIGNED;
            }
            else if (str == "WordWrapCentreAligned")
            {
                return Consts.HorizontalTextFormatting_HTF_WORDWRAP_CENTRE_ALIGNED;
            }
            else if (str == "WordWrapRightAligned")
            {
                return Consts.HorizontalTextFormatting_HTF_WORDWRAP_RIGHT_ALIGNED;
            }
            else if (str == "WordWrapJustified")
            {
                return Consts.HorizontalTextFormatting_HTF_WORDWRAP_JUSTIFIED;
            }
            else
            {
                return Consts.HorizontalTextFormatting_HTF_LEFT_ALIGNED;
            }
        }
                                    
        public static function stringToFontMetricType(str:String):uint
        {
            if (str == "LineSpacing")
            {
                return Consts.FontMetricType_FMT_LINE_SPACING;
            }
            else if (str == "Baseline")
            {
                return Consts.FontMetricType_FMT_BASELINE;
            }
            else
            {
                return Consts.FontMetricType_FMT_HORZ_EXTENT;
            }
        }
                                        
        public static function stringToDimensionOperator(str:String):uint
        {
            if (str == "Add")
            {
                return Consts.DimensionOperator_DOP_ADD;
            }
            else if (str == "Subtract")
            {
                return Consts.DimensionOperator_DOP_SUBTRACT;
            }
            else if (str == "Multiply")
            {
                return Consts.DimensionOperator_DOP_MULTIPLY;
            }
            else if (str == "Divide")
            {
                return Consts.DimensionOperator_DOP_DIVIDE;
            }
            else
            {
                return Consts.DimensionOperator_DOP_NOOP;
            }
        }
                                            
        public static function stringToFrameImageComponent(str:String):uint
        {
            if (str == "TopLeftCorner")
            {
                return Consts.FrameImageComponent_FIC_TOP_LEFT_CORNER;
            }
            if (str == "TopRightCorner")
            {
                return Consts.FrameImageComponent_FIC_TOP_RIGHT_CORNER;
            }
            if (str == "BottomLeftCorner")
            {
                return Consts.FrameImageComponent_FIC_BOTTOM_LEFT_CORNER;
            }
            if (str == "BottomRightCorner")
            {
                return Consts.FrameImageComponent_FIC_BOTTOM_RIGHT_CORNER;
            }
            if (str == "LeftEdge")
            {
                return Consts.FrameImageComponent_FIC_LEFT_EDGE;
            }
            if (str == "RightEdge")
            {
                return Consts.FrameImageComponent_FIC_RIGHT_EDGE;
            }
            if (str == "TopEdge")
            {
                return Consts.FrameImageComponent_FIC_TOP_EDGE;
            }
            if (str == "BottomEdge")
            {
                return Consts.FrameImageComponent_FIC_BOTTOM_EDGE;
            }
            else
            {
                return Consts.FrameImageComponent_FIC_BACKGROUND;
            }
        }
                                                
                                                
        //--------------------------------------------------------------------
        
        public static function vertFormatToString(format:uint):String
        {
            switch (format)
            {
                case Consts.VerticalFormatting_VF_BOTTOM_ALIGNED:
                    return String("BottomAligned");
                    break;
                case Consts.VerticalFormatting_VF_CENTRE_ALIGNED:
                    return String("CentreAligned");
                    break;
                case Consts.VerticalFormatting_VF_TILED:
                    return String("Tiled");
                    break;
                case Consts.VerticalFormatting_VF_STRETCHED:
                    return String("Stretched");
                    break;
                default:
                    return String("TopAligned");
                    break;
            }
        }
        
        public static function horzFormatToString(format:uint):String
        {
            switch (format)
            {
                case Consts.HorizontalFormatting_HF_RIGHT_ALIGNED:
                    return String("RightAligned");
                    break;
                case Consts.HorizontalFormatting_HF_CENTRE_ALIGNED:
                    return String("CentreAligned");
                    break;
                case Consts.HorizontalFormatting_HF_TILED:
                    return String("Tiled");
                    break;
                case Consts.HorizontalFormatting_HF_STRETCHED:
                    return String("Stretched");
                    break;
                default:
                    return String("LeftAligned");
                    break;
            }
        }
        
        public static function vertAlignmentToString(alignment:uint):String
        {
            switch (alignment)
            {
                case Consts.VerticalAlignment_VA_BOTTOM:
                    return String("BottomAligned");
                    break;
                case Consts.VerticalAlignment_VA_CENTRE:
                    return String("CentreAligned");
                    break;
                default:
                    return String("TopAligned");
                    break;
            }
        }
        
        public static function horzAlignmentToString(alignment:uint):String
        {
            switch (alignment)
            {
                case Consts.HorizontalAlignment_HA_RIGHT:
                    return String("RightAligned");
                    break;
                case Consts.HorizontalAlignment_HA_CENTRE:
                    return String("CentreAligned");
                    break;
                default:
                    return String("LeftAligned");
                    break;
            }
        }
        
        public static function dimensionTypeToString(dim:uint):String
        {
            switch (dim)
            {
                case Consts.DimensionType_DT_LEFT_EDGE:
                    return String("LeftEdge");
                    break;
                case Consts.DimensionType_DT_X_POSITION:
                    return String("XPosition");
                    break;
                case Consts.DimensionType_DT_TOP_EDGE:
                    return String("TopEdge");
                    break;
                case Consts.DimensionType_DT_Y_POSITION:
                    return String("YPosition");
                    break;
                case Consts.DimensionType_DT_RIGHT_EDGE:
                    return String("RightEdge");
                    break;
                case Consts.DimensionType_DT_BOTTOM_EDGE:
                    return String("BottomEdge");
                    break;
                case Consts.DimensionType_DT_WIDTH:
                    return String("Width");
                    break;
                case Consts.DimensionType_DT_HEIGHT:
                    return String("Height");
                    break;
                case Consts.DimensionType_DT_X_OFFSET:
                    return String("XOffset");
                    break;
                case Consts.DimensionType_DT_Y_OFFSET:
                    return String("YOffset");
                    break;
                default:
                    return String("Invalid");
                    break;
            }
        }
        
        public static function vertTextFormatToString(format:uint):String
        {
            switch (format)
            {
                case Consts.VerticalTextFormatting_VTF_BOTTOM_ALIGNED:
                    return String("BottomAligned");
                    break;
                case Consts.VerticalTextFormatting_VTF_CENTRE_ALIGNED:
                    return String("CentreAligned");
                    break;
                default:
                    return String("TopAligned");
                    break;
            }
        }
        
        public static function horzTextFormatToString(format:uint):String
        {
            switch (format)
            {
                case Consts.HorizontalTextFormatting_HTF_RIGHT_ALIGNED:
                    return String("RightAligned");
                    break;
                case Consts.HorizontalTextFormatting_HTF_CENTRE_ALIGNED:
                    return String("CentreAligned");
                    break;
                case Consts.HorizontalTextFormatting_HTF_JUSTIFIED:
                    return String("Justified");
                    break;
                case Consts.HorizontalTextFormatting_HTF_WORDWRAP_LEFT_ALIGNED:
                    return String("WordWrapLeftAligned");
                    break;
                case Consts.HorizontalTextFormatting_HTF_WORDWRAP_RIGHT_ALIGNED:
                    return String("WordWrapRightAligned");
                    break;
                case Consts.HorizontalTextFormatting_HTF_WORDWRAP_CENTRE_ALIGNED:
                    return String("WordWrapCentreAligned");
                    break;
                case Consts.HorizontalTextFormatting_HTF_WORDWRAP_JUSTIFIED:
                    return String("WordWrapJustified");
                    break;
                default:
                    return String("LeftAligned");
                    break;
            }
        }
        
        public static function fontMetricTypeToString(metric:uint):String
        {
            switch (metric)
            {
                case Consts.FontMetricType_FMT_BASELINE:
                    return String("Baseline");
                    break;
                case Consts.FontMetricType_FMT_HORZ_EXTENT:
                    return String("HorzExtent");
                    break;
                default:
                    return String("LineSpacing");
                    break;
            }
        }
        
        public static function dimensionOperatorToString(op:uint):String
        {
            switch (op)
            {
                case Consts.DimensionOperator_DOP_ADD:
                    return String("Add");
                    break;
                case Consts.DimensionOperator_DOP_SUBTRACT:
                    return String("Subtract");
                    break;
                case Consts.DimensionOperator_DOP_MULTIPLY:
                    return String("Multiply");
                    break;
                case Consts.DimensionOperator_DOP_DIVIDE:
                    return String("Divide");
                    break;
                default:
                    return String("Noop");
                    break;
            }
        }
        
        public static function frameImageComponentToString(imageComp:uint):String
        {
            switch (imageComp)
            {
                case Consts.FrameImageComponent_FIC_TOP_LEFT_CORNER:
                    return String("TopLeftCorner");
                    break;
                case Consts.FrameImageComponent_FIC_TOP_RIGHT_CORNER:
                    return String("TopRightCorner");
                    break;
                case Consts.FrameImageComponent_FIC_BOTTOM_LEFT_CORNER:
                    return String("BottomLeftCorner");
                    break;
                case Consts.FrameImageComponent_FIC_BOTTOM_RIGHT_CORNER:
                    return String("BottomRightCorner");
                    break;
                case Consts.FrameImageComponent_FIC_LEFT_EDGE:
                    return String("LeftEdge");
                    break;
                case Consts.FrameImageComponent_FIC_RIGHT_EDGE:
                    return String("RightEdge");
                    break;
                case Consts.FrameImageComponent_FIC_TOP_EDGE:
                    return String("TopEdge");
                    break;
                case Consts.FrameImageComponent_FIC_BOTTOM_EDGE:
                    return String("BottomEdge");
                    break;
                default:
                    return String("Background");
                    break;
            }
        }

    }
}