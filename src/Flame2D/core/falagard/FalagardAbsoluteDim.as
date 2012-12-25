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
    import Flame2D.core.utils.Rect;

    /*!
    \brief
    Dimension type that represents an absolute pixel value.  Implements BaseDim interface.
    */
    public class FalagardAbsoluteDim extends FalagardBaseDim
    {
        private var d_val:Number;
        
        
        /*!
        \brief
        Constructor.
        
        \param val
        float value to be assigned to the AbsoluteDim.
        */
        public function FalagardAbsoluteDim(val:Number = 0)
        {
            this.d_val = val;
        }
        
        public function setValue(val:Number):void
        {
            this.d_val = val;
        }
        

        // Implementation of the base class interface
        override protected function getValue_impl(wnd:FlameWindow) :Number
        {
            return d_val;
        }
        
        override protected function getValue_impl2(wnd:FlameWindow, container:Rect):Number
        {
            return d_val;
        }
        
        //void writeXMLElementName_impl(XMLSerializer& xml_stream) const;
        //void writeXMLElementAttributes_impl(XMLSerializer& xml_stream) const;
        
        override protected function clone_impl():FalagardBaseDim
        {
            var ndim:FalagardAbsoluteDim = new FalagardAbsoluteDim(d_val);
            return ndim;
        }
        

    }
}