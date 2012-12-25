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
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.data.Consts;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;

    /*!
    \brief
    Dimension type that represents some dimension of a Window/widget.  Implements BaseDim interface.
    
    When calculating the final pixel value for the dimension, a target widget name is built by
    appending the name suffix specified for the WidgetDim to the name of the window passed to
    getValue, we then find the window/widget with that name - the final value of the dimension
    is taken from this window/widget.
    */
    public class FalagardWidgetDim extends FalagardBaseDim
    {
        private var d_widgetName:String = "";    //!< Holds target window name suffix.
        private var d_what:uint;   //!< the dimension of the target window that we are to represent.
        
        /*!
        \brief
        Constructor.
        
        \param name
        String object holding the name suffix for a window/widget.
        
        \param dim
        DimensionType value indicating which dimension of the described image that this ImageDim
        is to represent.
        */
        public function FalagardWidgetDim(name:String, dim:uint)
        {
            d_widgetName = name;
            d_what = dim;
        }
        
        /*!
        \brief
        Set the name suffix to use for this WidgetDim.
        
        \param name
        String object holding the name suffix for a window/widget.
        
        \return
        Nothing.
        */
        public function setWidgetName(name:String):void
        {
            d_widgetName = name;
        }
        
        /*!
        \brief
        Sets the source dimension type for this WidgetDim.
        
        \param dim
        DimensionType value indicating which dimension of the described image that this WidgetDim
        is to represent.
        
        \return
        Nothing.
        */
        public function setSourceDimension(dim:uint):void
        {
            d_what = dim;
        }
        
        // Implementation of the base class interface
        override protected function getValue_impl(wnd:FlameWindow):Number
        {
            var widget:FlameWindow;
            
            // if target widget name is empty, then use the input window.
            if (d_widgetName.length == 0)
            {
                widget = wnd;
            }
                // name not empty, so find window with required name
            else
            {
                widget = FlameWindowManager.getSingleton().getWindow(wnd.getName() + d_widgetName);
            }
            
            // get size of parent; required to extract pixel values
            var parentSize:Size = widget.getParentPixelSize();
            
            switch (d_what)
            {
                case Consts.DimensionType_DT_WIDTH:
                    return widget.getPixelSize().d_width;
                    break;
                
                case Consts.DimensionType_DT_HEIGHT:
                    return widget.getPixelSize().d_height;
                    break;
                
                case Consts.DimensionType_DT_X_OFFSET:
                    trace("WigetDim::getValue - Nonsensical DimensionType of DT_X_OFFSET specified!  returning 0.0f");
                    return 0.0;
                    break;
                
                case Consts.DimensionType_DT_Y_OFFSET:
                    trace("WigetDim::getValue - Nonsensical DimensionType of DT_Y_OFFSET specified!  returning 0.0f");
                    return 0.0;
                    break;
                
                case Consts.DimensionType_DT_LEFT_EDGE:
                case Consts.DimensionType_DT_X_POSITION:
                    return widget.getPosition().d_x.asAbsolute(parentSize.d_width);
                    break;
                
                case Consts.DimensionType_DT_TOP_EDGE:
                case Consts.DimensionType_DT_Y_POSITION:
                    return widget.getPosition().d_y.asAbsolute(parentSize.d_height);
                    break;
                
                case Consts.DimensionType_DT_RIGHT_EDGE:
                    return widget.getArea().d_max.d_x.asAbsolute(parentSize.d_width);
                    break;
                
                case Consts.DimensionType_DT_BOTTOM_EDGE:
                    return widget.getArea().d_max.d_y.asAbsolute(parentSize.d_height);
                    break;
                
                default:
                    throw new Error("WidgetDim::getValue - unknown or unsupported DimensionType encountered.");
                    break;
            }
        }
        
        
        override protected function getValue_impl2(wnd:FlameWindow, container:Rect):Number
        {
            // This dimension type does not alter when whithin a container Rect.
            return getValue_impl(wnd);
        }
        
        //void writeXMLElementName_impl(XMLSerializer& xml_stream) const;
        //void writeXMLElementAttributes_impl(XMLSerializer& xml_stream) const;
        

        override protected function clone_impl():FalagardBaseDim
        {
            var ndim:FalagardWidgetDim = new FalagardWidgetDim(d_widgetName, d_what);
            return ndim;
        }
        
       
    }
}