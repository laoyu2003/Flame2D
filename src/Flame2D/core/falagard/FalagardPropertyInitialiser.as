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
    import Flame2D.core.properties.FlamePropertySet;
    import Flame2D.core.system.FlameWindow;

    /*!
    \brief
    Class that holds information about a property and it's required initial value.
    */
    public class FalagardPropertyInitialiser
    {
        public var d_propertyName:String;
        public var d_propertyValue:String;
        
        
        
        /*!
        \brief
        Constructor
        
        \param property
        String holding the name of the property targetted by this PropertyInitialiser.
        
        \param value
        String holding the value to be set by this PropertyInitialiser.
        */
        public function FalagardPropertyInitialiser(property:String, value:String)
        {
            d_propertyName = property;
            d_propertyValue = value;
        }
        
        
        /*!
        \brief
        Apply this property initialiser to the specified target CEGUI::PropertySet object.
        
        \param target
        CEGUI::PropertySet object to be initialised by this PropertyInitialiser.
        
        \return
        Nothing.
        */
        public function apply(target:FlamePropertySet):void
        {
            try
            {
                target.setProperty(d_propertyName, d_propertyValue);
            }
            // allow 'missing' properties
               catch(error:Error)
            {
            }
        }
        
        public function applyWindow(target:FlameWindow):void
        {
            try
            {
                target.setProperty(d_propertyName, d_propertyValue);
            }
            // allow 'missing' properties
            catch(error:Error)
            {
                throw new Error("unknown property name");
            }
        }
        
        
        /*!
        \brief
        Return the name of the property targetted by this PropertyInitialiser.
        
        \return
        String object holding the name of the target property.
        */
        public function getTargetPropertyName():String
        {
            return d_propertyName;
        }
        
        /*!
        \brief
        Return the value string to be set on the property targetted by this PropertyInitialiser.
        
        \return
        String object holding the value string.
        */
        public function getInitialiserValue():String
        {
            return d_propertyValue;
        }
    }
}