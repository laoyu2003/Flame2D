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
    Class that encapsulates access to a dynamic loadable module containing implementations of Windows, Widgets, and their factories.
    */
    public class FlameFactoryModule
    {
        
        public static const RegisterFactoryFunctionName:String = "registerFactory";
        public static const RegisterAllFunctionName:String     = "registerAllFactories";

        
        /*************************************************************************
         Implementation Data
         *************************************************************************/
        //typedef void (*FactoryRegisterFunction)(const String&); 
        //typedef uint (*RegisterAllFunction)(void);
        
        private var d_regFunc:Function;
        private var d_regAllFun:Function;
        //DynamicModule* d_module;
        /*!
        \brief
        Construct the FactoryModule object by loading the dynamic loadable module specified.
        
        \param filename
        String object holding the filename of a loadable module.
        
        \return
        Nothing
        */
        public function FlameFactoryModule(filename:String)
        {
            
        }
        
        /*!
        \brief
        Register a WindowFactory for \a type Windows.
        
        \param type
        String object holding the name of the Window type a factory is to be registered for.
        
        \return
        Nothing.
        */
        public function registerFactory(type:String):void
        {
            
        }
        
        /*!
        \brief
        Register all factories available in this module.
        
        \return
        uint value indicating the number of factories registered.
        */
        public function registerAllFactories():uint
        {
//            //Make sure we are using a dynamic factory and not a static one
//            if(d_module)
//            {
//                // are we attempting to use a missing function export
//                if (!d_regAllFunc)
//                {
//                    CEGUI_THROW(InvalidRequestException("FactoryModule::registerAllFactories - Required function export 'uint registerAllFactories(void)' was not found in module '" +
//                        d_module->getModuleName() + "'."));
//                }
//                
//                return d_regAllFunc();
//            } // if(d_module)
//            else
//            {
//                #if defined(CEGUI_STATIC)
//                //		return registerAllFactoriesFunction();
//                #endif
//            }
            
            return 0;
        }

    }
}