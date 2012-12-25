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
    import Flame2D.core.utils.UDim;

    /*!
    \brief
    NamedArea defines an area for a component which may later be obtained
    and referenced by a name unique to the WidgetLook holding the NamedArea.
    */
    public class FalagardNamedArea
    {
        private var d_wl:String;
        
        private var d_name:String;
        private var d_area:FalagardComponentArea;

        public function FalagardNamedArea(wl:String, name:String)
        {
            d_wl = wl;
            d_name = name;
        }
        
        public function parseXML(xml:XML):void
        {
            d_area = new FalagardComponentArea(d_wl);
            d_area.parseXML(xml.Area[0]);
            
            //parse AreaProperty ???
        }
        
        
  
        /*!
        \brief
        Return the name of this NamedArea.
        
        \return
        String object holding the name of this NamedArea.
        */
        public function getName():String
        {
            return d_name;
        }
        
        /*!
        \brief
        Return the ComponentArea of this NamedArea
        
        \return
        ComponentArea object describing the NamedArea's current target area.
        */
        public function getArea():FalagardComponentArea
        {
            return d_area;
        }
        
        /*!
        \brief
        Set the Area for this NamedArea.
        
        \param area
        ComponentArea object describing a new target area for the NamedArea..
        
        \return
        Nothing.
        */
        public function setArea(area:FalagardComponentArea):void
        {
            d_area = area;
        }
               
        
        /*!
        \brief
        Writes an xml representation of this NamedArea to \a out_stream.
        
        \param out_stream
        Stream where xml data should be output.
        
        \param indentLevel
        Current XML indentation level
        
        \return
        Nothing.
        */
        //void writeXMLToStream(XMLSerializer& xml_stream) const;
        

    }
    
    
}