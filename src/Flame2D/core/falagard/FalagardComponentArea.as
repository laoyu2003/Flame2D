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
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.UDim;

    /*!
    \brief
    Class that represents a target area for a widget or imagery component.
    
    This is essentially a Rect built out of Dimension objects.  Of note is that
    what would normally be the 'right' and 'bottom' edges may alternatively
    represent width and height depending upon what the assigned Dimension(s)
    represent.
    */
    public class FalagardComponentArea
    {
        private var d_wl:String = "";
        
        public var d_left:FalagardDimension;   //!< Left edge of the area.
        public var d_top:FalagardDimension;    //!< Top edge of the area.
        public var d_right_or_width:FalagardDimension;     //!< Either the right edge or the width of the area.
        public var d_bottom_or_height:FalagardDimension;   //!< Either the bototm edge or the height of the area.

        private var d_areaProperty:String = "";         //!< Property to access.  Must be a URect style property.
        
        public function FalagardComponentArea(wl:String)
        {
            d_wl = wl;
        }
        
        
        
        public function parseXML(xml:XML):void
        {
            
            //parse area
            var nodes:XMLList = xml.Dim;
            var subNode:XML;
            
            for each(var node:XML in nodes){
                
                //get dimension type
                var type:uint = FalagardXMLHelper.stringToDimensionType(node.@type.toString());
                
                switch(type){
                    case Consts.DimensionType_DT_LEFT_EDGE:
                    case Consts.DimensionType_DT_X_POSITION:
                        d_left = parseDimension(node, type);
                        break;
                    case Consts.DimensionType_DT_TOP_EDGE:
                    case Consts.DimensionType_DT_Y_POSITION:
                        d_top = parseDimension(node, type);
                        break;
                    case Consts.DimensionType_DT_RIGHT_EDGE:
                    case Consts.DimensionType_DT_WIDTH:
                        d_right_or_width = parseDimension(node, type);
                        break;
                    case Consts.DimensionType_DT_BOTTOM_EDGE:
                    case Consts.DimensionType_DT_HEIGHT:
                        d_bottom_or_height = parseDimension(node, type);
                        break;
                    default:
                        throw new("Falagard::xmlHandler::assignAreaDimension - Invalid DimensionType specified for area component.");
                        
                }
            }
        }
        
        private function parseDimension(xml:XML, dimType:uint):FalagardDimension
        {
            var baseDim:FalagardBaseDim = getBaseDim(xml);
            if(baseDim)
            {
                return new FalagardDimension(baseDim, dimType);
            }
            
            return null;
        }
         
        private function getBaseDim(xml:XML):FalagardBaseDim
        {
            var dim:FalagardBaseDim;
            
            dim = getAbsoluteDim(xml); if(dim) return dim;
            dim = getUnifiedDim(xml); if(dim) return dim;
            dim = getImageDim(xml); if(dim) return dim;
            dim = getWidgetDim(xml); if(dim) return dim;
            dim = getFontDim(xml); if(dim) return dim;
            dim = getPropertyDim(xml); if(dim) return dim;
            
            return null;
        }
        
        private function getAbsoluteDim(xml:XML):FalagardBaseDim
        {
            var node:XML;
            var val:Number;
            var dim:FalagardBaseDim;
            
            //absolute dim
            node = xml.AbsoluteDim[0];
            if(node)
            {
                val = Number(node.@value.toString());
                dim =  new FalagardAbsoluteDim(val);
                
                //DimOperator
                var operatorNode:XML = node.DimOperator[0];
                if(operatorNode)
                {
                    var op:uint = FalagardXMLHelper.stringToDimensionOperator(operatorNode.@op.toString());
                    var operand:FalagardBaseDim = getBaseDim(operatorNode);
                    if(operand)
                    {
                        dim.setDimensionOperator(op);
                        dim.setOperand(operand);
                    }
                }
                return dim;
            }
            return null;
        }
        
        private function getUnifiedDim(xml:XML):FalagardBaseDim
        {
            var node:XML;
            var val:Number;
            var dim:FalagardBaseDim;
            
            //unified dim
            node = xml.UnifiedDim[0];
            if(node)
            {
                var type:uint = FalagardXMLHelper.stringToDimensionType(node.@type.toString());
                var scale:Number = Number(node.@scale.toString());
                var offset:Number = Number(node.@offset.toString());
                
                var udim:UDim = new UDim(scale, offset);
                dim = new FalagardUnifiedDim(udim, type);
                
                //DimOperator
                var operatorNode:XML = node.DimOperator[0];
                if(operatorNode)
                {
                    var op:uint = FalagardXMLHelper.stringToDimensionOperator(operatorNode.@op.toString());
                    var operand:FalagardBaseDim = getBaseDim(operatorNode);
                    if(operand)
                    {
                        dim.setDimensionOperator(op);
                        dim.setOperand(operand);
                    }
                }
                
                return dim;
            }
            
            return null;
        }
         

        private function getImageDim(xml:XML):FalagardBaseDim
        {
            var node:XML;
            var val:Number;
            var dim:FalagardBaseDim;
            
            //image dim
            node = xml.ImageDim[0];
            if(node)
            {
                var imageset:String = node.@imageset.toString();
                var image:String = node.@image.toString();
                var type:uint = FalagardXMLHelper.stringToDimensionType(node.@dimension.toString());
                
                dim = new FalagardImageDim(imageset, image, type);
                //DimOperator
                var operatorNode:XML = node.DimOperator[0];
                if(operatorNode)
                {
                    var op:uint = FalagardXMLHelper.stringToDimensionOperator(operatorNode.@op.toString());
                    var operand:FalagardBaseDim = getBaseDim(operatorNode);
                    if(operand)
                    {
                        dim.setDimensionOperator(op);
                        dim.setOperand(operand);
                    }
                }
                
                return dim;
            }
            
            return null;
        }
        
        private function getWidgetDim(xml:XML):FalagardBaseDim
        {
            var node:XML;
            var val:Number;
            var dim:FalagardBaseDim;
            
            //widget dim
            node = xml.WidgetDim[0];
            if(node)
            {
                var widget:String = node.@widget.toString();
                var type:uint = FalagardXMLHelper.stringToDimensionType(node.@dimension.toString());
                
                dim = new FalagardWidgetDim(widget, type);
                
                //DimOperator
                var operatorNode:XML = node.DimOperator[0];
                if(operatorNode)
                {
                    var op:uint = FalagardXMLHelper.stringToDimensionOperator(operatorNode.@op.toString());
                    var operand:FalagardBaseDim = getBaseDim(operatorNode);
                    if(operand)
                    {
                        dim.setDimensionOperator(op);
                        dim.setOperand(operand);
                    }
                }
                
                return dim;
            }
            
            return null;
        }
        
        private function getFontDim(xml:XML):FalagardBaseDim
        {
            var node:XML;
            var val:Number;
            var dim:FalagardBaseDim;
            
            //font dim
            node = xml.FontDim[0];
            if(node)
            {
                var widget:String = node.@widget.toString();
                var font:String = node.@font.toString();
                var string:String = node.@string.toString();
                var type:uint = FalagardXMLHelper.stringToFontMetricType(node.@type.toString());
                var padding:Number = Misc.getAttributeAsNumber(node.@padding.toString(), 0);
                
                dim = new FalagardFontDim(widget, font, string, type, padding);
                
                //DimOperator
                var operatorNode:XML = node.DimOperator[0];
                if(operatorNode)
                {
                    var op:uint = FalagardXMLHelper.stringToDimensionOperator(operatorNode.@op.toString());
                    var operand:FalagardBaseDim = getBaseDim(operatorNode);
                    if(operand)
                    {
                        dim.setDimensionOperator(op);
                        dim.setOperand(operand);
                    }
                }
                
                return dim;
            }
            
            return null;
        }
        
        private function getPropertyDim(xml:XML):FalagardBaseDim
        {
            var node:XML;
            var val:Number;
            var dim:FalagardBaseDim;
            
            //font dim
            node = xml.PropertyDim[0];
            if(node)
            {
                var widget:String = node.@widget.toString();
                var name:String = node.@name.toString();
                var str_type:String = node.@type.toString();
                var type:uint = Consts.DimensionType_DT_INVALID;
                if(str_type.length != 0)
                {
                    type = FalagardXMLHelper.stringToDimensionType(str_type);
                }
                
                dim = new FalagardPropertyDim(widget, name, type);
                
                //DimOperator
                var operatorNode:XML = node.DimOperator[0];
                if(operatorNode)
                {
                    var op:uint = FalagardXMLHelper.stringToDimensionOperator(operatorNode.@op.toString());
                    var operand:FalagardBaseDim = getBaseDim(operatorNode);
                    if(operand)
                    {
                        dim.setDimensionOperator(op);
                        dim.setOperand(operand);
                    }
                }
                
                return dim;
            }
            
            return null;
        }
        
        /*!
        \brief
        Return a Rect describing the absolute pixel area represented by this ComponentArea.
        
        \param wnd
        Window object to be used when calculating final pixel area.
        
        \return
        Rect object describing the pixels area represented by this ComponentArea when using \a wnd
        as a reference for calculating the final pixel dimensions.
        */
        public function getPixelRect(wnd:FlameWindow) : Rect
        {
            var pixelRect:Rect;
            
            // use a property?
            if (isAreaFetchedFromProperty())
            {
                pixelRect = FlamePropertyHelper.stringToURect(wnd.getProperty(d_areaProperty)).asAbsolute(wnd.getPixelSize());
            }
                // not via property - calculate using Dimensions
            else
            {
                // sanity check, we mus be able to form a Rect from what we represent.
                Misc.assert(d_left.getDimensionType() == Consts.DimensionType_DT_LEFT_EDGE || d_left.getDimensionType() == Consts.DimensionType_DT_X_POSITION);
                Misc.assert(d_top.getDimensionType() == Consts.DimensionType_DT_TOP_EDGE || d_top.getDimensionType() == Consts.DimensionType_DT_Y_POSITION);
                Misc.assert(d_right_or_width.getDimensionType() == Consts.DimensionType_DT_RIGHT_EDGE || d_right_or_width.getDimensionType() == Consts.DimensionType_DT_WIDTH);
                Misc.assert(d_bottom_or_height.getDimensionType() == Consts.DimensionType_DT_BOTTOM_EDGE || d_bottom_or_height.getDimensionType() == Consts.DimensionType_DT_HEIGHT);
                
                pixelRect = new Rect();
                pixelRect.d_left = d_left.getBaseDimension().getValue(wnd);
                
                pixelRect.d_top = d_top.getBaseDimension().getValue(wnd);
                
                if (d_right_or_width.getDimensionType() == Consts.DimensionType_DT_WIDTH)
                    pixelRect.setWidth(d_right_or_width.getBaseDimension().getValue(wnd));
                else
                    pixelRect.d_right = d_right_or_width.getBaseDimension().getValue(wnd);
                
                if (d_bottom_or_height.getDimensionType() == Consts.DimensionType_DT_HEIGHT)
                    pixelRect.setHeight(d_bottom_or_height.getBaseDimension().getValue(wnd));
                else
                    pixelRect.d_bottom = d_bottom_or_height.getBaseDimension().getValue(wnd);
            }
            
            return pixelRect;
        }
        
        /*!
        \brief
        Return a Rect describing the absolute pixel area represented by this ComponentArea.
        
        \param wnd
        Window object to be used when calculating final pixel area.
        
        \param container
        Rect object to be used as a base or container when converting relative dimensions.
        
        \return
        Rect object describing the pixels area represented by this ComponentArea when using \a wnd
        and \a container as a reference for calculating the final pixel dimensions.
        */
        public function getPixelRect2(wnd:FlameWindow, container:Rect):Rect
        {
            var pixelRect:Rect = new Rect();
            
            // use a property?
            if (isAreaFetchedFromProperty())
            {
                pixelRect = FlamePropertyHelper.stringToURect(wnd.getProperty(d_areaProperty)).asAbsolute(wnd.getPixelSize());
            }
                // not via property - calculate using Dimensions
            else
            {
                // sanity check, we mus be able to form a Rect from what we represent.
                Misc.assert(d_left.getDimensionType() == Consts.DimensionType_DT_LEFT_EDGE || d_left.getDimensionType() == Consts.DimensionType_DT_X_POSITION);
                Misc.assert(d_top.getDimensionType() == Consts.DimensionType_DT_TOP_EDGE || d_top.getDimensionType() == Consts.DimensionType_DT_Y_POSITION);
                Misc.assert(d_right_or_width.getDimensionType() == Consts.DimensionType_DT_RIGHT_EDGE || d_right_or_width.getDimensionType() == Consts.DimensionType_DT_WIDTH);
                Misc.assert(d_bottom_or_height.getDimensionType() == Consts.DimensionType_DT_BOTTOM_EDGE || d_bottom_or_height.getDimensionType() == Consts.DimensionType_DT_HEIGHT);
                
                pixelRect.d_left = d_left.getBaseDimension().getValue2(wnd, container) + container.d_left;
                pixelRect.d_top = d_top.getBaseDimension().getValue2(wnd, container) + container.d_top;
                
                if (d_right_or_width.getDimensionType() == Consts.DimensionType_DT_WIDTH)
                    pixelRect.setWidth(d_right_or_width.getBaseDimension().getValue2(wnd, container));
                else
                    pixelRect.d_right = d_right_or_width.getBaseDimension().getValue2(wnd, container) + container.d_left;
                
                if (d_bottom_or_height.getDimensionType() == Consts.DimensionType_DT_HEIGHT)
                    pixelRect.setHeight(d_bottom_or_height.getBaseDimension().getValue2(wnd, container));
                else
                    pixelRect.d_bottom = d_bottom_or_height.getBaseDimension().getValue2(wnd, container) + container.d_top;
            }
            
            return pixelRect;
        }
        
        /*!
        \brief
        Writes an xml representation of this ComponentArea to \a out_stream.
        
        \param xml_stream
        Stream where xml data should be output.
        
        
        \return
        Nothing.
        */
        //void writeXMLToStream(XMLSerializer& xml_stream) const;
        
        /*!
        \brief
        Return whether this ComponentArea fetches it's area via a property on the target window.
        
        \return
        - true if the area comes via a Propery.
        - false if the area is defined explicitly via the Dimension fields.
        */
        public function isAreaFetchedFromProperty():Boolean
        {
            return d_areaProperty.length != 0;
        }
        
        /*!
        \brief
        Return the name of the property that will be used to determine the pixel area for this ComponentArea.
        
        \return
        String object holding the name of a Propery.
        */
        public function getAreaPropertySource():String
        {
            return d_areaProperty;
        }
        
        /*!
        \brief
        Set the name of the property that will be used to determine the pixel area for this ComponentArea.
        
        \param property
        String object holding the name of a Propery.  The property should access a URect type property.
        
        \return
        Nothing.
        */
        public function setAreaPropertySource(property:String):void
        {
            d_areaProperty = property;
        }

    }
}