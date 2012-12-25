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
    import Flame2D.core.system.FlameWindowManager;

    /*!
    \brief
    Class representing a generic get/set property.
    */
    public class FalagardPropertyDefinition extends FalagardPropertyDefinitionBase
    {
        protected var d_userStringName:String;
        
        //! Constructor.
        public function FalagardPropertyDefinition(name:String, initialValue:String, help:String,
                    redrawOnWrite:Boolean, layoutOnWrite:Boolean)
        {
            super(name, help, initialValue, redrawOnWrite, layoutOnWrite);
            
            d_userStringName = name + "_fal_auto_prop__";
        }
        
        
        override public function getValue(receiver:*) :String
        {
            const wnd:FlameWindow = receiver as FlameWindow;
            
            // the try/catch is used instead of querying the existence of the user
            // string in order that for the 'usual' case - where the user string
            // exists - there is basically no additional overhead, and that any
            // overhead is incurred only for the initial creation of the user
            // string.
            // Maybe the only negative here is that an error gets logged, though
            // this can be treated as a 'soft' error.
            try
            {
                return wnd.getUserString(d_userStringName);
            }
            catch (error:Error)
            {
                //trace("PropertyDefiniton::get: Defining new user string: " + d_userStringName);
                
                // get a non-const reference to target window.
                FlameWindowManager.getSingleton().getWindow(wnd.getName()).
                    setUserString(d_userStringName, d_default);
                
                return d_default;
            }
            
            return "";
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameWindow).setUserString(d_userStringName, value);
            
            super.setValue(receiver, value);
            //(receiver as FlameWindow).setProperty(d_userStringName, value);
        }
        
        // overrides
        override public function initialisePropertyReceiver(receiver:*):void
        {
            (receiver as FlameWindow).setUserString(d_userStringName, d_default);
        }
        
        //protected: void writeXMLElementType(XMLSerializer& xml_stream) const;
        
        
    }
}