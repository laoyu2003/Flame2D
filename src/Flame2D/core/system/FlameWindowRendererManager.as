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
    import Flame2D.falagard.FalagardWRModule;
    
    import flash.utils.Dictionary;
    
    
    public class FlameWindowRendererManager
    {
        /*************************************************************************
         Implementation data
         *************************************************************************/
        //typedef std::map<String, WindowRendererFactory*, String::FastLessCompare> WR_Registry;
        //WR_Registry d_wrReg;
        private var d_wrReg:Dictionary = new Dictionary();
        
        private var d_wrModuleInitialized:Boolean = false;
        
        //! Container type to hold WindowRenderFacory objects that we created.
        //typedef std::vector<WindowRendererFactory*> OwnedFactoryList;
        //! Container that tracks WindowFactory objects we created ourselves.
        //static OwnedFactoryList d_ownedFactories;
        private static var d_ownedFactories:Vector.<FlameWindowRendererFactory> = new Vector.<FlameWindowRendererFactory>();
        
        
        private static var d_singleton:FlameWindowRendererManager = new FlameWindowRendererManager();
        
        
        public function FlameWindowRendererManager()
        {
            if(d_singleton){
                throw new Error("FlameWindowRendererManager: only init once");
            }
        }
        
        public static function getSingleton():FlameWindowRendererManager
        {
            return d_singleton;
        }
        
        
        public function initialize():void
        {
            if(!d_wrModuleInitialized){
                new FalagardWRModule();
                d_wrModuleInitialized = true;
            }
        }
        
        /*************************************************************************
         Accessors
         *************************************************************************/
        
        
        
        public function isFactoryPresent(name:String):Boolean
        {
            return d_wrReg.hasOwnProperty(name);
        }
        
        
        
        public function getFactory(name:String):FlameWindowRendererFactory
        {
            if(d_wrReg.hasOwnProperty(name))
            {
                return d_wrReg[name];
            }
            
            throw new Error("WindowRenderFactory:" + name + " does not exist");
        }
        
        /*************************************************************************
         Manipulators
         *************************************************************************/
        /*!
        \brief
        Creates a WindowRendererFactory of the type \a T and adds it to the
        system for use.
        
        The created WindowRendererFactory will automatically be deleted when the
        factory is removed from the system (either directly or at system
        deletion time).
        
        \tparam T
        Specifies the type of WindowRendererFactory subclass to add a factory
        for.
        */
            
        public function addFactory(wr:FlameWindowRendererFactory):void
        {
            if (wr == null)
            {
                return;
            }

            //check duplicated
            if(d_wrReg.hasOwnProperty(wr.getName()))
            {
                throw new Error("WindowRenderer Factory:" + wr.getName() + " already exist");
            }
            
            d_wrReg[wr.getName()] = wr;
            
            trace("WindowRendererFactory '" + wr.getName()+ "' added. ");
        }
        
        public function removeFactory(name:String):void
        {
            if(!d_wrReg.hasOwnProperty(name))
            {
                trace("Removing factory.." + name + ": name not exist");
                return;
            }
            
            delete d_wrReg[name];
            
            trace("WindowRendererFactory for '" + name + "' WindowRenderers removed. ");
            
        }
        
        /*************************************************************************
         Factory usage
         *************************************************************************/
        public function createWindowRenderer(name:String):FlameWindowRenderer
        {
            var wr:FlameWindowRendererFactory = getFactory(name);
            return wr.create();
        }
        
        public function destroyWindowRenderer(wr:FlameWindowRenderer):void
        {
            
        }
        
      
        
        
    }
}