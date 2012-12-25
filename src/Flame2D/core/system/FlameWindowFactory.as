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

    /*!
    \brief
    Abstract class that defines the required interface for all WindowFactory
    objects.
    
    A WindowFactory is used to create and destroy windows of a specific type.
    For every type of Window object wihin the system (widgets, dialogs, movable
    windows etc) there must be an associated WindowFactory registered with the
    WindowFactoryManager so that the system knows how to create and destroy
    those types of Window base object.
    
    \note
    The use if of the CEGUI_DECLARE_WINDOW_FACTORY, CEGUI_DEFINE_WINDOW_FACTORY
    and CEGUI_WINDOW_FACTORY macros is deprecated in favour of the
    template class TplWindowFactory and templatised
    WindowFactoryManager::addFactory function, whereby you no longer need to
    directly create any supporting structure for your new window type, and can
    simply do:
    \code
    CEGUI::WindowFactoryManager::addFactory<TplWindowFactory<MyWidget> >();
    \endcode
    */
    
    //re-implement in as3 by yumj, to be checked
    public class FlameWindowFactory
    {
        //! String holding the type of object created by this factory.
        //protected var d_type:String;
        
        
        private var d_class:Class;
        
        
        public function FlameWindowFactory(factoryClass:Class)
        {
            d_class = factoryClass;
        }
        
        /*!
        \brief
        Create a new Window object of whatever type this WindowFactory produces.
        
        \param name
        A unique name that is to be assigned to the newly created Window object
        
        \return
        Pointer to the new Window object.
        */
        public function createWindow(name:String):*
        {
            //to be checked
            
            return new d_class(getTypeName(), name);
        }
        /*!
        \brief
        Destroys the given Window object.
        
        \param window
        Pointer to the Window object to be destroyed.
        
        \return
        Nothing.
        */
        public function destroyWindow(window:FlameWindow):void
        {
        }
        
        /*!
        \brief
        Get the string that describes the type of Window object this
        WindowFactory produces.
        
        \return
        String object that contains the unique Window object type produced by
        this WindowFactory
        */
        public function getTypeName():String
        {
            return Object(d_class).WidgetTypeName;
            //return String(d_class);
        }

        public function getWindowFactory():Class
        {
            return d_class;
        }
        
    }
}