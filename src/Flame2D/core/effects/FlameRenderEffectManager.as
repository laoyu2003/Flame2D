
package Flame2D.core.effects
{
    import Flame2D.renderer.FlameRenderEffect;
    
    import flash.utils.Dictionary;
    
    public class FlameRenderEffectManager
    {
        //! Collection type used for the render effect registry
        //typedef std::map<String, RenderEffectFactory*, String::FastLessCompare> RenderEffectRegistry;
        private var d_effectRegistry:Dictionary = new Dictionary(); 
        
        //! Collection type to track which effects we created with which factories
        //typedef std::map<RenderEffect*, RenderEffectFactory*> EffectCreatorMap;
        private var d_effects:Dictionary = new Dictionary();

        
        private static var d_singleton:FlameRenderEffectManager = new FlameRenderEffectManager();
        
        public function FlameRenderEffectManager()
        {
            if(d_singleton != null)
            {
                throw new Error("Please use singleton in renderEffectManager.");
            }
        }
        
        public static function getSingleton():FlameRenderEffectManager
        {
            return d_singleton;
        }
        
        

        
        //! Destructor for RenderEffectManager objects.
        public function dispose():void
        {
//            // Destroy any RenderEffect objects we created that still exist.
//            while (!d_effects.empty())
//                destroy(*d_effects.begin()->first);
//            
//            // Remove (destroy) all the RenderEffectFactory objects.
//            while (!d_effectRegistry.empty())
//                removeEffect(d_effectRegistry.begin()->first);
//            
//            char addr_buff[32];
//            sprintf(addr_buff, "(%p)", static_cast<void*>(this));
//            Logger::getSingleton().logEvent(
//                "CEGUI::RenderEffectManager singleton destroyed " + String(addr_buff));
        }
        
        /*!
        \brief
        Register a RenderEffect type with the system and associate it with the
        identifier \a name.
        
        This registers a RenderEffect based class, such that instances of that
        class can subsequently be created by requesting an effect using the
        specified identifier.
        
        \tparam T
        The RenderEffect based class to be instantiated when an effect is
        requested using the identifier \a name.
        
        \param name
        String object describing the identifier that the RenderEffect based
        class will be registered under.
        
        \exception AlreadyExistsException
        thrown if a RenderEffect is already registered using \a name.
        */
        
        public function addEffect(name:String):void
        {
//            if (isEffectAvailable(name))
//            {
//                throw new Error("RenderEffectManager::addEffect: " +
//                    "A RenderEffect is already registered under the name '" +
//                    name + "'");
//            }
//            // create an instance of a factory to create effects of type T
//            d_effectRegistry[name] = new FlameRenderEffectFactory();
//            
//            trace("Registered RenderEffect named '" + name + "'");
        }
                
        /*!
        \brief
        Remove / unregister any RenderEffect using the specified identifier.
        
        \param name
        String object describing the identifier of the RenderEffect that is to
        be removed / unregistered.  If no such RenderEffect is present, no
        action is taken.
        
        \note
        You should avoid removing RenderEffect types that are still in use.
        Internally a factory system is employed for the creation and deletion
        of RenderEffect objects; if an effect - and therefore it's factory - is
        removed while instances are still active, it will not be possible to
        safely delete those RenderEffect object instances.
        */
        public function removeEffect(name:String):void
        {
            if(! d_effectRegistry.hasOwnProperty(name))
            {
                return;
            }
            
            trace("Unregistered RenderEffect named '" + name + "'");
            
            d_effectRegistry[name].dispose();
            delete d_effectRegistry[name];
        }
        
        /*!
        \brief
        Return whether a RenderEffect has been registered under the specified
        name.
        
        \param name
        String object describing the identifier of a RenderEffect to test for.
        
        \return
        - true if a RenderEffect with the specified name is registered.
        - false if no RenderEffect with the specified name is registered.
        */
        public function isEffectAvailable(name:String):Boolean
        {
            return d_effectRegistry.hasOwnProperty(name);
        }
        
        /*!
        \brief
        Create an instance of the RenderEffect based class identified by the
        specified name.
        
        \param name
        String object describing the identifier of the RenderEffect based
        class that is to be created.
        
        \return
        Reference to the newly created RenderEffect.
        
        \exception UnknownObjectException
        thrown if no RenderEffect class has been registered using the
        identifier \a name.
        */
        public function create(name:String):FlameRenderEffect
        {
            
            //RenderEffectRegistry::iterator i(d_effectRegistry.find(name));
            
            // throw if no factory exists for this type
            if(! d_effectRegistry.hasOwnProperty(name))
            {
                throw new Error("RenderEffectManager::create: " +
                    "No RenderEffect has been registered with the name '" + name + "'");
            }
            
            var effect:FlameRenderEffect = (d_effectRegistry[name] as FlameRenderEffectFactory).create();
               
            // here we keep track of the factory used to create the effect object.
            d_effects[effect] = d_effectRegistry[name];
            
            trace("RenderEffectManager::create: Created " +
                "instance of effect " + name);
            
            return effect;
        }
        
        /*!
        \brief
        Destroy the given RenderEffect object.
        
        \note
        This function will only destroy objects that were created via the
        RenderEffectManager.  Attempts to destroy objects created by other
        means will result in an InvalidRequestException.  This option was
        chosen over silently ignoring the request in order to aid application
        developers in thier debugging.
        
        \param effect
        Reference to the RenderEffect object that is to be destroyed.
        
        \exception InvalidRequestException
        thrown if \a effect was not created by the RenderEffectManager.
        */
        public function destroy(effect:FlameRenderEffect):void
        {
            if(! d_effects.hasOwnProperty(effect))
            {
                throw new Error("RenderEffectManager::destroy: " +
                    "The given RenderEffect was not created by the " +
                    "RenderEffectManager - perhaps you created it directly?");
            }
            
            // use the same factory to delete the RenderEffect as what created it
            d_effects[effect].destroy(effect);
            
            // erase record of the object now it's gone
            delete d_effects[effect];
            
            trace("RenderEffectManager::destroy: Destroyed " +
                "RenderEffect object");
        }

        

    }
    
}