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
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.data.Consts;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.UDim;
    
    public class FalagardPropertyDim extends FalagardBaseDim
    {
        
        private var d_property:String;      //!< Propery that this object represents.
        private var d_childSuffix:String;   //!< String to hold the name suffix of the child to access the property form.
        private var d_type:uint;   //!< String to hold the type of dimension
        /*!
        \brief
        Constructor.
        
        \param name
        String holding the name suffix of the window on which the property
        is to be accessed.
        
        \param property
        String object holding the name of the property this PropertyDim
        represents the value of.  The property named should represent either
        a UDim value or a simple float value - dependning upon what \a type
        is specified as.
        
        \param type
        DimensionType value indicating what dimension named property
        represents.  The possible DimensionType values are as follows:
        - DT_INVALID the property should represent a simple float value.
        - DT_WIDTH the property should represent a UDim value where the
        scale is relative to the targetted Window's width.
        - DT_HEIGHT the property should represent a UDim value where the
        scale is relative to the targetted Window's height.
        - All other values will cause an InvalidRequestException exception
        to be thrown.
        */
        public function FalagardPropertyDim(widget:String, name:String, type:uint)
        {
            d_property = name;
            d_childSuffix = widget;
            d_type = type;
        }
        
        // Implementation of the base class interface
        override protected function getValue_impl(wnd:FlameWindow):Number
        {
            // get window to use.
            const sourceWindow:FlameWindow = d_childSuffix.length == 0 ? wnd : 
                    FlameWindowManager.getSingleton().getWindow(wnd.getName() + d_childSuffix);
            
            if (d_type == Consts.DimensionType_DT_INVALID)
                // return float property value.
                return FlamePropertyHelper.stringToFloat(sourceWindow.getProperty(d_property));
            
            var d:UDim = FlamePropertyHelper.stringToUDim(sourceWindow.getProperty(d_property));
            var s:Size = sourceWindow.getPixelSize();
            
            switch (d_type)
            {
                case Consts.DimensionType_DT_WIDTH:
                    return d.asAbsolute(s.d_width);
                    
                case Consts.DimensionType_DT_HEIGHT:
                    return d.asAbsolute(s.d_height);
                    
                default:
                    throw new Error("PropertyDim::getValue - unknown or unsupported DimensionType encountered.");
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
            var ndim:FalagardPropertyDim = new FalagardPropertyDim(d_childSuffix, d_property, d_type);
            return ndim;
        }
        
       
    }
}