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
    
    public class FalagardDimension
    {
        //BaseDim*        d_value;    //!< Pointer to the value for this Dimension.
        //DimensionType   d_type;     //!< What we represent.

        private var d_value:FalagardBaseDim = null;
        private var d_type:uint = Consts.DimensionType_DT_INVALID;
        
        public function FalagardDimension(dim:FalagardBaseDim, type:uint)
        {
            this.d_value = dim;
            this.d_type = type;
        }
        
        public function assign(other:FalagardDimension):FalagardDimension
        {
            // release old value, if any.
            //if (d_value)  delete d_value;
            
            d_value = other.d_value ? other.d_value.clone() : null;
            d_type = other.d_type;
            
            return this;
        }


        /*!
        \brief
        return the BaseDim object currently used as the value for this Dimension.
        
        \return
        const reference to the BaseDim sub-class object which contains the value for this Dimension.
        */
        public function getBaseDimension():FalagardBaseDim
        {
            //assert(d_value);
            return d_value;
        }
        
        /*!
        \brief
        set the current value for this Dimension.
        
        \param dim
        object based on a subclass of BaseDim which holds the dimensional value.
        
        \return
        Nothing.
        */
        public function setBaseDimension(dim:FalagardBaseDim):void
        {
            
            // release old value, if any.
            //if (d_value)  delete d_value;
            
            d_value = dim.clone();
        }
        
        /*!
        \brief
        Return a DimensionType value indicating what this Dimension represents.
        
        \return
        one of the DimensionType enumerated values.
        */
        public function getDimensionType():uint
        {
            return d_type;
        }
        
        /*!
        \brief
        Sets what this Dimension represents.
        
        \param type
        one of the DimensionType enumerated values.
        
        \return
        Nothing.
        */
        public function setDimensionType(type:uint):void
        {
            d_type = type;
        }
        /*!
        \brief
        Writes an xml representation of this Dimension to \a out_stream.
        
        \param xml_stream
        Stream where xml data should be output.
        
        \return
        Nothing.
        */
        //void writeXMLToStream(XMLSerializer& xml_stream) const;

    }
}