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
    import Flame2D.core.data.AliasTargetStack;
    import Flame2D.core.data.FalagardWindowMapping;
    
    import flash.utils.Dictionary;

    /*! 
    \brief
    Class that manages WindowFactory objects
    
    \todo
    I think we could clean up the mapping stuff a bit. Possibly make it more generic now
    with the window renderers and all.
    */
    public class FlameWindowFactoryManager
    {
        /*************************************************************************
         Implementation Data
         *************************************************************************/
        //typedef	std::map<String, WindowFactory*, String::FastLessCompare>	WindowFactoryRegistry;		//!< Type used to implement registry of WindowFactory objects
        //typedef std::map<String, AliasTargetStack, String::FastLessCompare>	TypeAliasRegistry;		//!< Type used to implement registry of window type aliases.
        //typedef std::map<String, FalagardWindowMapping, String::FastLessCompare> FalagardMapRegistry;    //!< Type used to implement registry of falagard window mappings.
        //! Type used for list of WindowFacory objects that we created ourselves
        //typedef std::vector<WindowFactory*> OwnedWindowFactoryList;
        
        //WindowFactoryRegistry	d_factoryRegistry;			//!< The container that forms the WindowFactory registry
        //TypeAliasRegistry		d_aliasRegistry;			//!< The container that forms the window type alias registry.
        //FalagardMapRegistry     d_falagardRegistry;         //!< Container that hold all the falagard window mappings.
        //! Container that tracks WindowFactory objects we created ourselves.
        //static OwnedWindowFactoryList  d_ownedFactories;   
       
        
        private var d_factoryRegistry:Dictionary = new Dictionary();
        private var d_aliasRegistry:Dictionary = new Dictionary();
        private var d_falagardRegistry:Dictionary = new Dictionary();
        private static var d_ownedFactories:Vector.<FlameWindowFactory> = new Vector.<FlameWindowFactory>();
        
        private static var _singleton:FlameWindowFactoryManager = new FlameWindowFactoryManager();
        
        public function FlameWindowFactoryManager()
        {
            if(_singleton){
                throw new Error("FlameWindowFactory, only init once");
            }
        }
        
        public static function getSingleton():FlameWindowFactoryManager
        {
            return _singleton;
        }
        
        
        
        /*************************************************************************
         Public Interface
         *************************************************************************/
        /*!
        \brief
        Adds a new WindowFactory to the list of registered factories.
        
        \param factory
        Pointer to the WindowFactory to be added to the WindowManager.
        
        \return
        Nothing
        
        \exception NullObjectException		\a factory was null.
        \exception AlreadyExistsException	\a factory provided a Window type name which is in use by another registered WindowFactory.
        */
        public function addFactory(factory:FlameWindowFactory):void
        {
            // throw exception if passed factory is null.
            if (!factory)
            {
                throw new Error("WindowFactoryManager::addFactory - The provided WindowFactory pointer was invalid.");
            }
            // throw exception if type name for factory is already in use
            if (d_factoryRegistry.hasOwnProperty(factory.getTypeName()))
            {
                throw new Error("WindowFactoryManager::addFactory - A WindowFactory for type '" + 
                    factory.getTypeName() + "' is already registered.");
            }
            
            // add the factory to the registry
            d_factoryRegistry[factory.getTypeName()] = factory;
            
            //trace("WindowFactory for '" + factory.getTypeName() +"' windows added. ");
        }
        
        /*!
        \brief
        Creates a WindowFactory of the type \a T and adds it to the system for
        use.  The created WindowFactory will automatically be deleted when the
        factory is removed from the system (either directly or at system 
        deletion time).
        
        \tparam T
        Specifies the type of WindowFactory subclass to add a factory for.
        
        \return
        Nothing
        */
        //template <typename T>  static void addFactory();
        
        
        /*!
        \brief
        Removes a WindowFactory from the list of registered factories.
        
        \note
        The WindowFactory object is not destroyed (since it was created externally), instead it is just removed from the list.
        
        \param name
        String which holds the name (technically, Window type name) of the WindowFactory to be removed.  If \a name is not
        in the list, no error occurs (nothing happens).
        
        \return
        Nothing
        */
        public function removeFactoryByName(name:String):void
        {
            if(! d_factoryRegistry.hasOwnProperty(name)){
                return;
            }

            var factory:FlameWindowFactory = d_factoryRegistry[name];

            //delete from owned list
            for(var i:uint = 0; i<d_ownedFactories.length; i++){
                if(d_ownedFactories[i] == factory){
                    d_ownedFactories.splice(i, 1);
                    break;
                }
            }
            
            delete d_factoryRegistry[name];
        }
        
        /*!
        \brief
        Removes a WindowFactory from the list of registered factories.
        
        \note
        The WindowFactory object is not destroyed (since it was created externally), instead it is just removed from the list.
        
        \param factory
        Pointer to the factory object to be removed.  If \a factory is null, or if no such WindowFactory is in the list, no
        error occurs (nothing happens).
        
        \return
        Nothing
        */
        public function removeFactory(factory:FlameWindowFactory):void
        {
            if (factory)
            {
                removeFactoryByName(factory.getTypeName());
            }
        }
        
        /*!
        \brief
        Remove all WindowFactory objects from the list.
        
        \return
        Nothing
        */
        public function removeAllFactories():void
        {
            d_factoryRegistry = new Dictionary();
        }
        
        
        /*!
        \brief
        Return a pointer to the specified WindowFactory object.
        
        \param type
        String holding the Window object type to return the WindowFactory for.
        
        \return
        Pointer to the WindowFactory object that creates Windows of the type \a type.
        
        \exception UnknownObjectException	No WindowFactory object for Window objects of type \a type was found.
        */
        public function getFactory(type:String):FlameWindowFactory
        {
            // first, dereference aliased types, as needed.
            var targetType:String = getDereferencedAliasType(type);
            
            // try for a 'real' type
            if(d_factoryRegistry.hasOwnProperty(targetType))
            {
                return d_factoryRegistry[targetType];
            }
                // no concrete type, try for a falagard mapped type
            else
            {
                if(d_falagardRegistry.hasOwnProperty(targetType))
                {
                    // recursively call getFactory on the target base type
                    return getFactory(d_falagardRegistry[targetType].d_baseType);
                }
                    // type not found anywhere, give up with an exception.
                else
                {
                    throw new Error("WindowFactoryManager::getFactory - A WindowFactory object, an alias, or mapping for '" + 
                        type + "' Window objects is not registered with the system.");
                }
            }
        }
        
        
        /*!
        \brief
        Checks the list of registered WindowFactory objects, aliases, and
        falagard mapped types for one which can create Window objects of the
        specified type.
        
        \param name
        String containing the Window type name to check for.
        
        \return
        - true if a WindowFactory, alias, or falagard mapping for Window objects
        of type \a name is registered.
        - false if the system knows nothing about windows of type \a name.
        */
        public function isFactoryPresent(name:String):Boolean
        {
            // first, dereference aliased types, as needed.
            var targetType:String = getDereferencedAliasType(name);
            
            // now try for a 'real' type
            if (d_factoryRegistry.hasOwnProperty(targetType))
            {
                return true;
            }
            // not a concrete type, so return whether it's a Falagard mapped type.
            else
            {
                return d_falagardRegistry.hasOwnProperty(targetType);
            }
        }
        
        
        /*!
        \brief
        Adds an alias for a current window type.
        
        This method allows you to create an alias for a specified window type.  This means that you can then use
        either name as the type parameter when creating a window.
        
        \note
        You need to be careful using this system.  Creating an alias using a name that already exists will replace the previous
        mapping for that alias.  Each alias name maintains a stack, which means that it is possible to remove an alias and have the
        previous alias restored.  The windows created via an alias use the real type, so removing an alias after window creation is always
        safe (i.e. it is not the same as removing a real factory, which would cause an exception when trying to destroy a window with a missing
        factory).
        
        \param aliasName
        String object holding the alias name.  That is the name that \a targetType will also be known as from no on.
        
        \param targetType
        String object holding the type window type name that is to be aliased.  This type must already exist.
        
        \return
        Nothing.
        
        \exception UnknownObjectException	thrown if \a targetType is not known within the system.
        */
        public function addWindowTypeAlias(aliasName:String, targetType:String):void
        {
            if(! d_aliasRegistry.hasOwnProperty(aliasName))
            {
                var ats:AliasTargetStack = new AliasTargetStack();
                ats.d_targetStack.push(targetType);
                d_aliasRegistry[aliasName] = ats;
            }
                // alias already exists, add our new entry to the list already there
            else
            {
                
                (d_aliasRegistry[aliasName] as AliasTargetStack).d_targetStack.push(targetType);
            }
            
            //Logger::getSingleton().logEvent("Window type alias named '" + aliasName + "' added for window type '" + targetType +"'.");
        }
        
        
        /*!
        \brief
        Remove the specified alias mapping.  If the alias mapping does not exist, nothing happens.
        
        \note
        You are required to supply both the alias and target names because there may exist more than one entry for a given
        alias - therefore you are required to be explicit about which alias is to be removed.
        
        \param aliasName
        String object holding the alias name.
        
        \param targetType
        String object holding the type window type name that was aliased.
        
        \return
        Nothing.
        */
        public function removeWindowTypeAlias(aliasName:String, targetType:String):void
        {
            // if alias name exists
            if(d_aliasRegistry.hasOwnProperty(aliasName)){
                var ats:AliasTargetStack = d_aliasRegistry[aliasName];
                
                // find the specified target for this alias
                for(var i:uint=0; i<ats.d_targetStack.length; i++){
                    if(ats.d_targetStack[i] == targetType){
                        ats.d_targetStack.splice(i, 1);
                        break;
                    }
                }
                if(ats.d_targetStack.length == 0){
                    delete d_aliasRegistry[aliasName];
                }
            }
        }
        
        
        
        
        //added by yumj
        public function hasWindowTypeAlias(aliasName:String):Boolean
        {
            if(d_aliasRegistry.hasOwnProperty(aliasName))
            {
                return true;
            }
            
            return false;
        }
        
        
        
        /*!
        \brief
        Add a mapping for a falagard based window.
        
        This function creates maps a target window type and target 'look' name onto a registered window type, thus allowing
        the ususal window creation interface to be used to create windows that require extra information to full initialise
        themselves.
        \note
        These mappings support 'late binding' to the target window type, as such the type indicated by \a targetType need not
        exist in the system until attempting to create a Window using the type.
        \par
        Also note that creating a mapping for an existing type will replace any previous mapping for that same type.
        
        \param newType
        The type name that will be used to create windows using the target type and look.
        
        \param targetType
        The base window type.
        
        \param lookName
        The name of the 'look' that will be used by windows of this type.
        
        \param renderer
        The type of window renderer to assign for windows of this type.
        
        \param effectName
        The identifier of the RenderEffect to attempt to set up for windows of this type.
        
        \return
        Nothing.
        */
        public function addFalagardWindowMapping(newType:String, targetType:String,
                                                 lookName:String, renderer:String, effectName:String = ""):void
        {
            var mapping:FalagardWindowMapping = new FalagardWindowMapping();
            mapping.d_windowType = newType;
            mapping.d_baseType   = targetType;
            mapping.d_lookName   = lookName;
            mapping.d_rendererType = renderer;
            mapping.d_effectName = effectName;
            

            // see if the type we're creating already exists
            if(d_falagardRegistry.hasOwnProperty(newType))
            {
                // type already exists, log the fact that it's going to be replaced.
                trace("Falagard mapping for type '" + newType + "' already exists - current mapping will be replaced.");
            }
            
//            char addr_buff[32];
//            sprintf(addr_buff, "(%p)", static_cast<void*>(&mapping));
//            Logger::getSingleton().logEvent("Creating falagard mapping for type '" +
//                newType + "' using base type '" + targetType + "', window renderer '" +
//                renderer + "' Look'N'Feel '" + lookName + "' and RenderEffect '" +
//                effectName + "'. " + addr_buff);
            
            d_falagardRegistry[newType] = mapping;    
        }
        
        /*!
        \brief
        Remove the specified falagard type mapping if it exists.
        
        \return
        Nothing.
        */
        public function removeFalagardWindowMapping(type:String):void
        {
            if(d_falagardRegistry.hasOwnProperty(type)){
                delete d_falagardRegistry[type];
                return;
            }
        }
        
        /*!
        \brief
        Return whether the given type is a falagard mapped type.
        
        \param type
        Name of a window type.
        
        \return
        - true if the requested type is a Falagard mapped window type.
        - false if the requested type is a normal WindowFactory (or alias), or if the type does not exist.
        */
        public function isFalagardMappedType(type:String):Boolean
        {
            return d_falagardRegistry.hasOwnProperty(type);
        }
        
        /*!
        \brief
        Return the name of the LookN'Feel assigned to the specified window mapping.
        
        \param type
        Name of a window type.  The window type referenced should be a falagard mapped type.
        
        \return
        String object holding the name of the look mapped for the requested type.
        
        \exception InvalidRequestException thrown if \a type is not a falagard mapping type (or maybe the type didn't exist).
        */
        public function getMappedLookForType(type:String):String
        {
            var dat:String = getDereferencedAliasType(type);
            if(d_falagardRegistry.hasOwnProperty(dat))
            {
                return (d_falagardRegistry[dat] as FalagardWindowMapping).d_lookName;
            }
                // type does not exist as a mapped type (or an alias for one)
            else
            {
                throw new Error("WindowFactoryManager::getMappedLookForType - Window factory type '" + 
                    type + "' is not a falagard mapped type (or an alias for one).");
            }
        }
        
        /*!
        \brief
        Return the name of the WindowRenderer assigned to the specified window mapping.
        
        \param type
        Name of a window type.  The window type referenced should be a falagard mapped type.
        
        \return
        String object holding the name of the window renderer mapped for the requested type.
        
        \exception InvalidRequestException thrown if \a type is not a falagard mapping type (or maybe the type didn't exist).
        */
        public function getMappedRendererForType(type:String):String
        {
            var dat:String = getDereferencedAliasType(type);
            if(d_falagardRegistry.hasOwnProperty(dat))
            {
                return (d_falagardRegistry[dat] as FalagardWindowMapping).d_rendererType;
            }
                // type does not exist as a mapped type (or an alias for one)
            else
            {
                throw new Error("WindowFactoryManager::getMappedLookForType - Window factory type '" + 
                    type + "' is not a falagard mapped type (or an alias for one).");
            }
        }
        
        /*!
        \brief
        Use the alias system, where required, to 'de-reference' the specified
        type to an actual window type that can be created directly (that being
        either a concrete window type, or a falagard mapped type).
        
        \note
        Even though implied by the above description, this method does not
        check that a factory for the final type exists; we simply say that the
        returned type is not an alias for some other type.
        
        \param type
        String describing the type to be de-referenced.
        
        \return
        String object holding a type for a window that can be created directly;
        that is, a type that does not describe an alias to some other type.
        */
        public function getDereferencedAliasType(type:String):String
        {
            if(d_aliasRegistry.hasOwnProperty(type))
            {
                // if this is an aliased type, ensure to fully dereference by recursively
                // calling ourselves on the active target for the given type.
                return getDereferencedAliasType(d_aliasRegistry[type].getActiveTarget());
            }            
            // we're not an alias, so return the input type unchanged
            return type;
        }
        
        /*!
        \brief
        Return the FalagardWindowMapping for the specified window mapping \a type.
        
        \param type
        Name of a window type.  The window type referenced should be a falagard mapped type.
        
        \return
        FalagardWindowMapping object describing the falagard mapping.
        
        \exception InvalidRequestException thrown if \a type is not a falagard mapping type (or maybe the type didn't exist).
        */
        public function getFalagardMappingForType(type:String):FalagardWindowMapping
        {
            var dat:String = getDereferencedAliasType(type);
            if(d_falagardRegistry.hasOwnProperty(dat))
            {
                return d_falagardRegistry[dat];
            }
                // type does not exist as a mapped type (or an alias for one)
            else
            {
                throw new Error("WindowFactoryManager::getFalagardMappingForType - Window factory type '" + 
                    type + "' is not a falagard mapped type (or an alias for one).");
            }
        }
    }
}
    