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
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.system.FlameWindow;

    /*!
    \brief
    common base class used for types representing a new property to be
    available on all widgets that use the WidgetLook that the property
    definition is a part of.
    */
    public class FalagardPropertyDefinitionBase extends FlameProperty
    {
        protected var d_writeCausesRedraw:Boolean;
        protected var d_writeCausesLayout:Boolean;
        
        
        public function FalagardPropertyDefinitionBase(name:String, help:String, initialValue:String, 
                                               redrawOnWrite:Boolean, layoutOnWrite:Boolean)
        {
            super(name, help, initialValue);
            
            d_writeCausesRedraw = redrawOnWrite;
            d_writeCausesLayout = layoutOnWrite;
        }
        
        
        /*!
        \brief
        Sets the value of the property.
        
        \note
        When overriding the set() member of PropertyDefinitionBase, you MUST
        call the base class implementation after you have set the property
        value (i.e. you must call PropertyDefinitionBase::set()).
        
        \param receiver
        Pointer to the target object.
        
        \param value
        A String object that contains a textual representation of the new value to assign to the Property.
        
        \return
        Nothing.
        
        \exception InvalidRequestException  Thrown when the Property was unable to interpret the content of \a value.
        */
        override public function setValue(receiver:*, value:String):void
        {
            if (d_writeCausesLayout)
                (receiver as FlameWindow).performChildWindowLayout();
            
            if (d_writeCausesRedraw)
                (receiver as FlameWindow).invalidate();
        }
        
        /*!
        \brief
        Writes an xml representation of the PropertyDefinitionBase based
        object to \a out_stream.
        
        \param xml_stream
        Stream where xml data should be output.
        
        
        \return
        Nothing.
        */
        //virtual void writeXMLToStream(XMLSerializer& xml_stream) const;
        
        /*!
        \brief
        Write out the text of the XML element type.  Note that you should
        not write the opening '<' character, nor any other information such
        as attributes in this function.  The writeExtraAttributes function
        can be used for writing attributes.
        
        \param xml_stream
        Stream where xml data should be output.
        */
        //protected virtual void writeXMLElementType(XMLSerializer& xml_stream) const = 0;
        
        /*!
        \brief
        Write out any xml attributes added in a sub-class.  Note that you
        should not write the closing '/>' character sequence, nor any other
        information in this function.  You should always call the base class
        implementation of this function when overriding.
        
        \param xml_stream
        Stream where xml data should be output.
        */
        //virtual void writeXMLAttributes(XMLSerializer& xml_stream) const;
    }
}