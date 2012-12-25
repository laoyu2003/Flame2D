
package Flame2D.core.animations
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameEventSet;
    import Flame2D.core.utils.MultiMap;
    
    import flash.utils.Dictionary;

    /*!
    \brief
    Defines an 'animation' class
    
    This is definition of Animation. Can be reused multiple times via
    AnimationInstance class. You can't step this class directly, you have to
    instantiate it via AnimationManager::instantiateAnimation.
    
    AnimationInstance provides means for stepping the animation and applying
    it to PropertySets.
    
    \par
    Animation itself doesn't contain key frames. It is composed of Affector(s).
    Each Affector affects one Property. So one Animation can affect multiple
    properties.
    
    \see
    AnimationInstance, Affector
    */
    public class FlameAnimation
    {
        // Internal strings for the XML enumeration for replay modes
        private static const ReplayModeOnce:String = "once";
        private static const ReplayModeLoop:String = "loop";
        private static const ReplayModeBounce:String = "bounce";
        
        // Internal strings for the XML enumeration for application methods.
        private static const ApplicationMethodAbsolute:String = "absolute";
        private static const ApplicationMethodRelative:String = "relative";
        private static const ApplicationMethodRelativeMultiply:String = "relative multiply";
        
        
        //! name of this animation
        private var d_name:String;
        
        //! currently used replay mode
        private var d_replayMode:uint = Consts.ReplayMode_RM_Loop;
        //! duration of animation (in seconds)
        private var d_duration:Number = 0.0;
        /** if true, instantiations of this animation call start on themselves when
         * their target is set
         */
        private var d_autoStart:Boolean = false;
        
        //typedef std::vector<Affector*> AffectorList;
        //! list of affectors defined in this animation
        //AffectorList d_affectors;
        
        private var d_affectors:Vector.<FlameAffector> = new Vector.<FlameAffector>();
        
        //typedef std::multimap<String, String> SubscriptionMap;
        /** holds pairs of 2 strings, the left string is the Event that we will
         * subscribe to, the right string is the action that will be invoked to the
         * instance if the event is fired on target window
         */
        //SubscriptionMap d_autoSubscriptions;
        private var d_autoSubscriptions:MultiMap = new MultiMap();
        
        
        
        /** internal constructor, please only construct animations via
         * AnimationManager::createAnimation method
         */
        public function FlameAnimation(name:String)
        {
            d_name = name;
        }
        

        public function parseXML(xml:XML):void
        {
            var duration:Number = Number(xml.@duration.toString());
            var replayMode:String = xml.@replayMode.toString();
            var autoStart:Boolean = xml.hasOwnProperty("autoStart")?
                FlamePropertyHelper.stringToBool(xml.@autoStart.toString()) : false;
            
            
            setDuration(duration);
            
            if (replayMode == ReplayModeOnce)
                setReplayMode(Consts.ReplayMode_RM_Once);
            else if (replayMode == ReplayModeBounce)
                setReplayMode(Consts.ReplayMode_RM_Bounce);
            else
                setReplayMode(Consts.ReplayMode_RM_Loop);
            
            setAutoStart(autoStart);
            
            
            //parse affector
            var nodes:XMLList = xml.Affector;
            var node:XML;
            for each(node in nodes)
            {
                var property:String = node.@property.toString();
                var interpolator:String = node.@interpolator.toString();
                var applicationMethod:String = node.@applicationMethod.toString();
                

                var affector:FlameAffector = createAffector2(property, interpolator);
                
                if (applicationMethod == ApplicationMethodRelative)
                {
                    affector.setApplicationMethod(Consts.ApplicationMethod_AM_Relative);
                }
                else if (applicationMethod == ApplicationMethodRelativeMultiply)
                {
                    affector.setApplicationMethod(Consts.ApplicationMethod_AM_RelativeMultiply);
                }
                else
                {
                    affector.setApplicationMethod(Consts.ApplicationMethod_AM_Absolute);
                }
                affector.parseXML(node);
                
                d_affectors.push(affector);
            }
            
            nodes = xml.Subscription;
            for each(node in nodes)
            {
                var event:String = node.@event.toString();
                var action:String = node.@action.toString();
                
                defineAutoSubscription(event, action);
            }
        }
        
        
        /*!
        \brief
        Retrieves name of this Animation definition
        */
        public function getName():String
        {
            return d_name;
        }
        
        /*!
        \brief
        Sets the replay mode of this animation
        */
        public function setReplayMode(mode:uint):void
        {
            d_replayMode = mode;
        }
        
        /*!
        \brief
        Retrieves the replay mode of this animation
        */
        public function getReplayMode():uint
        {
            return d_replayMode;
        }
        
        /*!
        \brief
        Sets the duration of this animation
        */
        public function setDuration(duration:Number):void
        {
            d_duration = duration;
            // todo: iterate through existing key frames if any and if we
            //       find a keyframe that is now outside of the [0, duration] interval,
            //       rant about it in the log
        }
        
        /*!
        \brief
        Retrieves the duration of this animation
        */
        public function getDuration():Number
        {
            return d_duration;
        }
        
        /*!
        \brief
        Sets whether this animation auto starts or not
        
        \par
        Auto start means that the animation instances of this definition call
        Start on themselves once their target is set.
        */
        public function setAutoStart(autoStart:Boolean):void
        {
            d_autoStart = autoStart;
        }
        
        /*!
        \brief
        Retrieves auto start.
        
        \see
        Animation::setAutoStart
        */
        public function getAutoStart():Boolean
        {
            return d_autoStart;
        }
        
        /*!
        \brief
        Creates a new Affector
        
        \see
        Affector
        */
        public function createAffector():FlameAffector
        {
            // no checking needed!
            
            var ret:FlameAffector = new FlameAffector(this);
            d_affectors.push(ret);
            
            return ret;
        }
        
        /*!
        \brief
        Creates a new Affector
        
        \par
        This is just a helper, finger saving method.
        */
        public function createAffector2(targetProperty:String, interpolator:String):FlameAffector
        {
            var ret:FlameAffector = createAffector();
            ret.setTargetProperty(targetProperty);
            ret.setInterpolatorByName(interpolator);
            
            return ret;
        }
            
        
        /*!
        \brief
        Destroys given Affector
        */
        public function destroyAffector(affector:FlameAffector):void
        {
            var pos:int = d_affectors.indexOf(affector);
            
            if(pos == -1)
            {
                throw new Error("Animation::destroyAffector: Given affector not found!");
            }
            
            d_affectors.splice(pos, 1);
        }
        
        /*!
        \brief
        Retrieves the Affector at given index
        */
        public function getAffectorAtIdx(index:uint):FlameAffector
        {
            if (index >= d_affectors.length)
            {
                throw new Error("Animation::getAffectorAtIdx: Out of bounds.");
            }
            
            return d_affectors[index];
        }
            
        
        /*!
        \brief
        Retrieves number of Affectors defined in this Animation
        */
        public function getNumAffectors():uint
        {
            return d_affectors.length;
        }
        
        /*!
        \brief
        This defined a new auto subscription.
        
        \param
        eventName the name of the event we want to subscribe to,
        CEGUI::Window::EventClicked for example
        
        \param
        action is the action that will be invoked on the animation instance if
        this event is fired
        
        \par
        Auto Subscription does subscribe to event sender (usually target window)
        of Animation Instance when the event source is set.
        
        Usable action strings:
        - Start
        - Stop
        - Pause
        - Unpause
        - TogglePause
        
        eventName is the name of the event we want to subscribe to
        */
        public function defineAutoSubscription(eventName:String, action:String):void
        {
            if(d_autoSubscriptions.hasPair(eventName, action))
            {
                throw new Error(
                    "Animation::defineAutoSubscription: Unable to define " +
                    "given Auto Subscription - exactly the same auto subscription " +
                    "is already there!");
            }
            
            d_autoSubscriptions.insertVal(eventName, action);
        }
        
        /*!
        \brief
        This undefines previously defined auto subscription.
        
        \see
        Animation::defineAutoSubscription
        */
        public function undefineAutoSubscription(eventName:String, action:String):void
        {
            if(d_autoSubscriptions.hasPair(eventName, action))
            {
                d_autoSubscriptions.removePair(eventName, action);
                return;
            }
            
            throw new Error(
                "Animation::undefineAutoSubscription: Unable to undefine " +
                "given Auto Subscription - not found!");
        }
        
        /*!
        \brief
        This undefines all previously defined auto subscriptions.
        
        \see
        Animation::defineAutoSubscription
        */
        public function undefineAllAutoSubscriptions():void
        {
            d_autoSubscriptions.removeAll();
        }
        
        /*!
        \brief
        Subscribes all auto subscriptions with information from given animation
        instance
        
        \par
        This is internal method! Only use if you know what you're doing!
        */
        public function autoSubscribe(instance:FlameAnimationInstance):void
        {
            var eventSender:FlameEventSet = instance.getEventSender();
            
            if (!eventSender)
            {
                return;
            }
            
            var keys:Dictionary = d_autoSubscriptions.keys;
            for(var key:String in keys)
            {
                var vals:Dictionary = d_autoSubscriptions.getVals(key);
                for(var val:String in vals)
                {
                    if (key == "Start")
                    {
                        eventSender.subscribeEvent(key,
                            new Subscriber(instance.handleStart, instance), FlameAnimationInstance.EventNamespace);
                    }
                    else if (key == "Stop")
                    {
                        eventSender.subscribeEvent(key,
                            new Subscriber(instance.handleStop, instance), FlameAnimationInstance.EventNamespace);
                    }
                    else if (key == "Pause")
                    {
                        eventSender.subscribeEvent(key,
                            new Subscriber(instance.handlePause, instance), FlameAnimationInstance.EventNamespace);
                    }
                    else if (key == "Unpause")
                    {
                        eventSender.subscribeEvent(key,
                            new Subscriber(instance.handleUnpause, instance), FlameAnimationInstance.EventNamespace);
                    }
                    else if (key == "TogglePause")
                    {
                        eventSender.subscribeEvent(key,
                            new Subscriber(instance.handleTogglePause, instance), FlameAnimationInstance.EventNamespace);
                    }
                    else
                    {
                        throw new Error(
                            "Animation::autoSubscribe: Unable to auto subscribe! " +
                            "'" + key + "' is not a valid action.");
                    }
                    
                    //instance.addAutoConnection(connection);
                }
            }
        }
        
        /*!
        \brief
        Unsubscribes all auto subscriptions with information from given
        animation instance
        
        \par
        This is internal method! Only use if you know what you're doing!
        */
        public function autoUnsubscribe(instance:FlameAnimationInstance):void
        {
            
            // just a delegate to make things clean
            //instance.unsubscribeAutoConnections();
        }
        
        /*!
        \brief
        Internal method, causes all properties that are used by this animation
        and it's affectors to be saved
        
        \par
        So their values are still known after
        they've been affected.
        */
        public function savePropertyValues(instance:FlameAnimationInstance):void
        {
            for(var i:uint = 0; i<d_affectors.length; i++)
            {
                d_affectors[i].savePropertyValues(instance);
            }
        }
        
        /*!
        \brief
        Applies this Animation definition using information from given
        AnimationInstance
        
        \par
        This is internal method, only use if you know what you're doing!
        */
        public function apply(instance:FlameAnimationInstance):void
        {
            for(var i:uint = 0; i<d_affectors.length; i++)
            {
                d_affectors[i].apply(instance);
            }

        }
        

    }
}