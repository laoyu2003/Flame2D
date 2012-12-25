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

    /*!
    \brief
    Abstract interface for a generic 'dimension' class.
    */
    public class FalagardBaseDim
    {
        //DimensionOperator   d_operator;
        //BaseDim*            d_operand;

        private var d_operator:uint = Consts.DimensionOperator_DOP_NOOP;
        private var d_operand:FalagardBaseDim = null;
        
        
        public function FalagardBaseDim()
        {
        }
        
        /*!
        \brief
        Return a value that represents this dimension as absolute pixels.
        
        \param wnd
        Window object that may be used by the specialised class to aid in
        calculating the final value.
        
        \return
        float value which represents, in pixels, the same value as this BaseDim.
        */
        public function getValue(wnd:FlameWindow) : Number
        {
            // get sub-class to return value for this dimension.
            var val:Number = getValue_impl(wnd);
            
            // if we have an attached operand, perform math on value as needed
            if (d_operand)
            {
                switch (d_operator)
                {
                    case Consts.DimensionOperator_DOP_ADD:
                        val += d_operand.getValue(wnd);
                        break;
                    case Consts.DimensionOperator_DOP_SUBTRACT:
                        val -= d_operand.getValue(wnd);
                        break;
                    case Consts.DimensionOperator_DOP_MULTIPLY:
                        val *= d_operand.getValue(wnd);
                        break;
                    case Consts.DimensionOperator_DOP_DIVIDE:
                        val /= d_operand.getValue(wnd);
                        break;
                    default:
                        // No-op.
                        break;
                }
            }
            
            return val;
        }
        
        /*!
        \brief
        Return a value that represents this dimension as absolute pixels.
        
        \param wnd
        Window object that may be used by the specialised class to aid in
        calculating the final value (typically would be used to obtain
        window/widget dimensions).
        
        \param container
        Rect object which describes an area to be considered as the base area
        when calculating the final value.  Basically this means that relative values
        are calculated from the dimensions of this Rect.
        
        \return
        float value which represents, in pixels, the same value as this BaseDim.
        */
        public function getValue2(wnd:FlameWindow, container:Rect) :Number
        {
            // get sub-class to return value for this dimension.
            var val:Number = getValue_impl2(wnd, container);
            
            // if we have an attached operand, perform math on value as needed
            if (d_operand)
            {
                switch (d_operator)
                {
                    case Consts.DimensionOperator_DOP_ADD:
                        val += d_operand.getValue2(wnd, container);
                        break;
                    case Consts.DimensionOperator_DOP_SUBTRACT:
                        val -= d_operand.getValue2(wnd, container);
                        break;
                    case Consts.DimensionOperator_DOP_MULTIPLY:
                        val *= d_operand.getValue2(wnd, container);
                        break;
                    case Consts.DimensionOperator_DOP_DIVIDE:
                        val /= d_operand.getValue2(wnd, container);
                        break;
                    default:
                        // No-op.
                        break;
                }
            }
            
            return val;
        }
        
        /*!
        \brief
        Create an exact copy of the specialised class and return it as a pointer to
        a BaseDim object.
        
        Since the system needs to be able to copy objects derived from BaseDim, but only
        has knowledge of the BaseDim interface, this clone method is provided to prevent
        slicing issues.
        
        \return
        BaseDim object pointer
        */
        public function clone():FalagardBaseDim
        {
            // get sub-class to return a cloned object
            var o:FalagardBaseDim = clone_impl();
            
            // fill in operator for cloned object
            o.d_operator = d_operator;
            
            // now clone any attached operand dimension
            if (d_operand)
                o.d_operand = d_operand.clone();
            
            return o;
        }
        
        /*!
        \brief
        Return the DimensionOperator set for this BaseDim based object.
        
        \return
        One of the DimensionOperator enumerated values representing a mathematical operation to be
        performed upon this BaseDim using the set operand.
        */
        public function getDimensionOperator() : uint
        {
            return d_operator;
        }
        
        /*!
        \brief
        Set the DimensionOperator set for this BaseDim based object.
        
        \param op
        One of the DimensionOperator enumerated values representing a mathematical operation to be
        performed upon this BaseDim using the set operand.
        
        \return
        Nothing.
        */
        public function setDimensionOperator(op:uint):void
        {
            d_operator = op;
        }   
        
        /*!
        \brief
        Return a pointer to the BaseDim set to be used as the other operand.
        
        \return
        Pointer to the BaseDim object.
        */
        public function getOperand():FalagardBaseDim
        {
            return d_operand;
        }
        
        /*!
        \brief
        Set the BaseDim set to be used as the other operand in calculations for this BaseDim.
        
        \param operand
        sub-class of BaseDim representing the 'other' operand.  The given object will be cloned; no
        transfer of ownership occurrs for the passed object.
        
        \return
        Nothing.
        */
        public function setOperand(operand:FalagardBaseDim):void
        {
            // release old operand, if any.
            //if(d_operand) delete d_operand;
            
            d_operand = operand.clone();
        }
        
        /*!
        \brief
        Writes an xml representation of this BaseDim to \a out_stream.
        
        \param xml_stream
        Stream where xml data should be output.
        
        \return
        Nothing.
        */
        //void writeXMLToStream(XMLSerializer& xml_stream) const;
        
        /*!
        \brief
        Implementataion method to return the base value for this BaseDim.  This method should
        not attempt to apply the mathematical operator; this is handled automatically.
        */
        protected function getValue_impl(wnd:FlameWindow):Number
        {
            throw new Error("must be realized");
        }
        /*!
        \brief
        Implementataion method to return the base value for this BaseDim.  This method should
        not attempt to apply the mathematical operator; this is handled automatically by BaseDim.
        */
        protected function getValue_impl2(wnd:FlameWindow, container:Rect):Number
        {
            throw new Error("must be realized");
        }
        
        /*!
        \brief
        Implementataion method to return a clone of this sub-class of BaseDim.
        This method should not attempt to clone the mathematical operator or operand; theis is
        handled automatically by BaseDim.
        */
        protected function clone_impl():FalagardBaseDim
        {
            throw new Error("must be realized");
        }
        
        /*!
        \brief
        Implementataion method to output real xml element name.
        */
        //virtual void writeXMLElementName_impl(XMLSerializer& xml_stream) const = 0;
        
        /*!
        \brief
        Implementataion method to create the element attributes
        */
        //virtual void writeXMLElementAttributes_impl(XMLSerializer& xml_stream) const = 0;
        


    }
}