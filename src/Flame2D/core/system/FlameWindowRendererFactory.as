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
package Flame2D.core.system
{
    import Flame2D.elements.button.FlameCheckbox;

    /*!
    \brief
    Base-class for WindowRendererFactory
    */
    public class FlameWindowRendererFactory
    {
        //which class
        private var d_class:Class;
        
        
        public function FlameWindowRendererFactory(factoryClass:Class)
        {
            d_class = factoryClass;
            
            trace("Added class:" + d_class);
        }
        
        /*!
        \brief
        Returns the type name of this window renderer factory.
        */
        public function getName():String
        {
            return Object(d_class).TypeName;
        }
        
        /*!
        \brief
        Creates and returns a new window renderer object.
        */
        public function create():*
        {
            //to do
            return new d_class(getName());
        }
        
        /*!
        \brief
        Destroys a window renderer object previously created by us.
        */
        public function destroy(wr:FlameWindowRenderer):void
        {
            
        }
    }
}