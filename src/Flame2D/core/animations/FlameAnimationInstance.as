
package Flame2D.core.animations
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.events.AnimationEventArgs;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.properties.FlamePropertySet;
    import Flame2D.core.system.FlameEventSet;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.utils.Misc;
    
    import flash.utils.Dictionary;
    
    /*!
    \brief
    Defines an 'animation instance' class
    
    Animation classes hold definition of the animation. Whilst this class holds
    data needed to use the animation definition - target PropertySet, event
    receiver, animation position, ...
    
    You have to define animation first and then instantiate it via
    AnimationManager::instantiateAnimation
    
    \see
    Animation
    */
    public class FlameAnimationInstance
    {
        //! Namespace for animation instance events
        //! these are fired on event receiver, not this animation instance!
        public static const EventNamespace:String = "AnimationInstance";
        
        //! fired when animation instance starts
        public static const EventAnimationStarted:String = "AnimationStarted";
        //! fired when animation instance stops
        public static const EventAnimationStopped:String = "AnimationStopped";
        //! fired when animation instance pauses
        public static const EventAnimationPaused:String = "AnimationPaused";
        //! fired when animation instance unpauses
        public static const EventAnimationUnpaused:String = "AnimationUnpaused";
        //! fired when animation instance ends
        public static const EventAnimationEnded:String = "AnimationEnded";
        //! fired when animation instance loops
        public static const EventAnimationLooped:String = "AnimationLooped";
        
        //! parent Animation definition
        private var d_definition:FlameAnimation;
        
        //! target property set, properties of this are affected by Affectors
        private var d_target:FlameWindow = null;
        //! event receiver, receives events about this animation instance
        private var d_eventReceiver:FlameEventSet = null;
        /** event sender, sends events and can control this animation instance if
         * there are any auto subscriptions
         */
        private var d_eventSender:FlameEventSet = null;
        
        /** position of this animation instance,
         * should always be higher or equal to 0.0 and lower or equal to duration of
         * animation definition
         */
        private var d_position:Number = 0.0;
        //! playback speed, 1.0 means normal playback
        private var d_speed:Number = 1.0;
        //! needed for RM_Bounce mode, if true, we bounce backwards
        private var d_bounceBackwards:Boolean = false;
        //! true if this animation is unpaused
        private var d_running:Boolean = false;
        //! skip next update (true if the next update should be skipped entirely)
        private var d_skipNextStep:Boolean = false;
        //! skip the update if the step is larger than this value
        private var d_maxStepDeltaSkip:Number = -1.0;
        //! always clamp step delta to this value
        private var d_maxStepDeltaClamp:Number = -1.0;
        
        //typedef std::map<String, String> PropertyValueMap;
        /** cached saved values, used for relative application method
         *  and keyframe property source, see Affector and KeyFrame classes
         */
        //PropertyValueMap d_savedPropertyValues;
        private var d_savedPropertyValues:Dictionary = new Dictionary();
        
        
        //typedef std::vector<Event::Connection> ConnectionTracker;
        //! tracks auto event connections we make.
        //ConnectionTracker d_autoConnections;

        //! internal constructor, please use AnimationManager::instantiateAnimation
        public function FlameAnimationInstance(definition:FlameAnimation)
        {
            d_definition = definition;
        }
        
        
        /*!
        \brief
        Retrieves the animation definition that is used in this instance
        */
        public function getDefinition():FlameAnimation
        {
            return d_definition;
        }
        
        /*!
        \brief
        Sets the target property set - this class will get it's properties
        affected by the Affectors!
        */
        public function setTarget(target:FlameWindow):void
        {
            d_target = target;
            
            purgeSavedPropertyValues();
            
            if (d_definition.getAutoStart() && !isRunning())
            {
                start();
            }
        }
        
        /*!
        \brief
        Retrieves the target property set
        */
        public function getTarget():FlameWindow
        {
            return d_target;
        }
        
        /*!
        \brief
        Sets event receiver - this class will receive events when something
        happens to the playback of this animation - it starts, stops, pauses,
        unpauses, ends and loops
        */
        public function setEventReceiver(receiver:FlameEventSet):void
        {
            d_eventReceiver = receiver;
        }
        
        /*!
        \brief
        Retrieves the event receiver
        */
        public function getEventReceiver():FlameEventSet
        {
            return d_eventReceiver;
        }
        
        /*!
        \brief
        Sets event sender - this class will send events and can affect this
        animation instance if there are any auto subscriptions defined in the
        animation definition
        */
        public function setEventSender(sender:FlameEventSet):void
        {
            if (d_eventSender)
            {
                d_definition.autoUnsubscribe(this);
            }
            
            d_eventSender = sender;
            
            if (d_eventSender)
            {
                d_definition.autoSubscribe(this);
            }
        }
        
        /*!
        \brief
        Retrieves the event sender
        */
        public function getEventSender():FlameEventSet
        {
            return d_eventSender;
        }
        
        /*!
        \brief
        Helper method, sets given window as target property set, event receiver
        and event set
        */
        public function setTargetWindow(target:FlameWindow):void
        {
            setTarget(target);
            setEventReceiver(target);
            setEventSender(target);
        }
        
        /*!
        \brief
        Sets playback position. Has to be higher or equal to 0.0 and lower or
        equal to Animation definition's duration.
        */
        public function setPosition(position:Number):void
        {
            if (position < 0.0 || position > d_definition.getDuration())
            {
                throw new Error(
                    "AnimationInstance::setPosition: Unable to set position " +
                    "of this animation instace because given position isn't " +
                    "in interval [0.0, duration of animation].");
            }
            
            d_position = position;
        }
        
        /*!
        \brief
        Retrieves current playback position
        */
        public function getPosition():Number
        {
            return d_position;
        }
        
        /*!
        \brief
        Sets playback speed - you can speed up / slow down individual instances
        of the same animation. 1.0 means normal playback.
        */
        public function setSpeed(speed:Number):void
        {
            // first sort out the adventurous users
            if (speed < 0.0)
            {
                throw new Error(
                    "AnimationInstance::setSpeed: You can't set playback speed " +
                    "to a value that's lower than 0.0");
            }
            
            if (speed == 0.0)
            {
                throw new Error(
                    "AnimationInstance::setSpeed: You can't set playback speed " +
                    "to zero, please use AnimationInstance::pause instead");
            }
            
            d_speed = speed;
        }
        
        /*!
        \brief
        Retrieves current playback speed
        */
        public function getSpeed():Number
        {
            return d_speed;
        }
        
        /*!
        \brief
        Controls whether the next time step is skipped
        */
        public function setSkipNextStep(skip:Boolean):void
        {
            d_skipNextStep = skip;
        }
        
        /*!
        \brief
        Returns true if the next step is *going* to be skipped
        
        \par
        If it was skipped already, this returns false as step resets
        it to false after it skips one step.
        */
        public function getSkipNextStep():Boolean
        {
            return  d_skipNextStep;
        }
        
        /*!
        \brief
        Sets the max delta before step skipping occurs
        
        \param
        maxDelta delta in seconds, if this value is reached, the step is skipped
        (use -1.0f if you never want to skip - this is the default)
        
        \par
        If you want to ensure your animation is not skipped entirely after layouts
        are loaded or other time consuming operations are done, use this method.
        
        For example setMaxStepDeltaSkip(1.0f / 25.0f) ensures that if FPS drops
        below 25, the animation just stops progressing and waits till FPS raises.
        */
        public function setMaxStepDeltaSkip(maxDelta:Number):void
        {
            d_maxStepDeltaSkip = maxDelta;
        }
        
        /*!
        \brief
        Gets the max delta before step skipping occurs
        */
        public function getMaxStepDeltaSkip():Number
        {
            return d_maxStepDeltaSkip;
        }
        
        /*!
        \brief
        Sets the max delta before step clamping occurs
        
        \param
        maxDelta delta in seconds, if this value is reached, the step is clamped.
        (use -1.0f if you never want to clamp - this is the default)
        
        \par
        If you want to ensure the animation steps at most 1.0 / 60.0 seconds at a timem
        you should call setMaxStepDeltaClamp(1.0f / 60.0f). This essentially slows
        the animation down in case the FPS drops below 60.
        */
        public function setMaxStepDeltaClamp(maxDelta:Number):void
        {
            d_maxStepDeltaClamp = maxDelta;
        }
        
        /*!
        \brief
        Gets the max delta before step clamping occurs
        */
        public function getMaxStepDeltaClamp():Number
        {
            return d_maxStepDeltaClamp;
        }
        
        /*!
        \brief
        Starts this animation instance - sets position to 0.0 and unpauses
        
        \param
        skipNextStep if true the next injected time pulse is skipped
        
        \par
        This also causes base values to be purged!
        */
        public function start(skipNextStep:Boolean = true):void
        {
            setPosition(0.0);
            d_running = true;
            d_skipNextStep = skipNextStep;
            onAnimationStarted();
        }
        
        /*!
        \brief
        Stops this animation instance - sets position to 0.0 and pauses
        */
        public function stop():void
        {
            setPosition(0.0);
            d_running = false;
            onAnimationStopped();
        }
        
        /*!
        \brief
        Pauses this animation instance - stops it from stepping forward
        */
        public function pause():void
        {
            d_running = false;
            onAnimationPaused();
        }
        
        /*!
        \brief
        Unpauses this animation instance - allows it to step forward again
        
        \param
        skipNextStep if true the next injected time pulse is skipped
        */
        public function unpause(skipNextStep:Boolean = true):void
        {
            d_running = true;
            d_skipNextStep = skipNextStep;
            onAnimationUnpaused();
        }
        
        /*!
        \brief
        Pauses the animation if it's running and unpauses it if it isn't
        
        \param
        skipNextStep if true the next injected time pulse is skipped
        (only applies when unpausing!)
        */
        public function togglePause(skipNextStep:Boolean = true):void
        {
            if (isRunning())
            {
                pause();
            }
            else
            {
                unpause(skipNextStep);
            }
        }
        
        /*!
        \brief
        Returns true if this animation instance is currently unpaused,
        if it is stepping forward.
        */
        public function isRunning():Boolean
        {
            return d_running;
        }
        
        /*!
        \brief
        Internal method, steps the animation forward by the given delta
        */
        public function step(delta:Number):void
        {
            if (!d_running)
            {
                // nothing to do if this animation instance isn't running
                return;
            }
            
            if (delta < 0.0)
            {
                throw new Error(
                    "AnimationInstance::step: You can't step the Animation Instance " +
                    "with negative delta! You can't reverse the flow of time, stop " +
                    "trying!");
            }
            
            // first we deal with delta size
            if (d_maxStepDeltaSkip > 0.0 && delta > d_maxStepDeltaSkip)
            {
                // skip the step entirely if delta gets over the threshold
                // note that default value is 0.0f which means this never gets triggered
                delta = 0.0;
            }
            
            if (d_maxStepDeltaClamp > 0.0)
            {
                // clamp to threshold, note that default value is -1.0f which means
                // this line does nothing (delta should always be larger or equal than 0.0f
                delta = Math.min(delta, d_maxStepDeltaClamp);
            }
            
            // if asked to do so, we skip this step, but mark that the next one
            // shouldn't be skipped
            // NB: This gets rid of annoying animation skips when FPS gets too low
            //     after complex layout loading, etc...
            if (d_skipNextStep)
            {
                d_skipNextStep = false;
                // we skip the step by setting delta to 0, this doesn't step the time
                // but still sets the animation position accordingly
                delta = 0.0;
            }
            
            const duration:Number = d_definition.getDuration();
            
            // we modify the delta according to playback speed
            delta *= d_speed;
            
            // the position could have gotten out of the desired range, we have to
            // alter it depending on replay method of our animation definition
            
            // first a simple clamp with RM_Once
            if (d_definition.getReplayMode() == Consts.ReplayMode_RM_Once)
            {
                var newPosition:Number = d_position + delta;
                
                newPosition = Math.max(0.0, newPosition);
                
                if (newPosition >= duration)
                {
                    newPosition = duration;
                    
                    stop();
                    onAnimationEnded();
                }
                
                setPosition(newPosition);
            }
                // a both sided wrap with RM_Loop
            else if (d_definition.getReplayMode() == Consts.ReplayMode_RM_Loop)
            {
                newPosition = d_position + delta;
                
                while (newPosition > duration)
                {
                    newPosition -= duration;
                    onAnimationLooped();
                }
                
                setPosition(newPosition);
            }
                // bounce back and forth with RM_Bounce
            else if (d_definition.getReplayMode() == Consts.ReplayMode_RM_Bounce)
            {
                if (d_bounceBackwards)
                {
                    delta = -delta;
                }
                
                newPosition = d_position + delta;
                
                while (newPosition <= 0 || newPosition > duration)
                {
                    if (newPosition <= 0)
                    {
                        d_bounceBackwards = false;
                        
                        newPosition = -newPosition;
                        onAnimationLooped();
                    }
                    
                    if (newPosition > duration)
                    {
                        d_bounceBackwards = true;
                        
                        newPosition = 2.0 * duration - newPosition;
                        onAnimationLooped();
                    }
                }
                
                setPosition(newPosition);
            }
            
            apply();
        }
        
        /*!
        \brief
        handler that starts the animation instance
        */
        public function handleStart(e:EventArgs):Boolean
        {
            start();
            
            return true;
        }
        
        /*!
        \brief
        handler that stops the animation instance
        */
        public function handleStop(e:EventArgs):Boolean
        {
            stop();
            
            return true;
        }
        
        /*!
        \brief
        handler that pauses the animation instance
        */
        public function handlePause(e:EventArgs):Boolean
        {
            pause();
            
            return true;
        }
        
        /*!
        \brief
        handler that unpauses the animation instance
        */
        public function handleUnpause(e:EventArgs):Boolean
        {
            unpause();
            
            return true;
        }
        
        /*!
        \brief
        handler that toggles pause on this animation instance
        */
        public function handleTogglePause(e:EventArgs):Boolean
        {
            togglePause();
            
            return true;
        }
        
        /*!
        \brief
        Internal method, saves given property (called before it's affected)
        */
        public function savePropertyValue(propertyName:String):void
        {
            Misc.assert(d_target != null);
            
            d_savedPropertyValues[propertyName] = d_target.getProperty(propertyName);
        }
        
        /** this purges all saved values forcing this class to gather new ones fresh
         * from the properties
         */
        public function purgeSavedPropertyValues():void
        {
            d_savedPropertyValues = new Dictionary();
        }
        
        /** retrieves saved value, if it isn't cached already, it retrieves it fresh
         * from the properties
         */
        public function getSavedPropertyValue(propertyName:String):String
        {
            if(! d_savedPropertyValues.hasOwnProperty(propertyName))
            {
                // even though we explicitly save all used property values when
                // starting the animation, this can happen when user changes
                // animation definition whilst the animation is running
                // (Yes, it's nasty, but people do nasty things)
                savePropertyValue(propertyName);
                return getSavedPropertyValue(propertyName);
            }
            
            return d_savedPropertyValues[propertyName];
        }
        
        /*!
        \brief
        Internal method, adds reference to created auto connection
        
        \par
        DO NOT USE THIS DIRECTLY
        */
        //public function addAutoConnection(Event::Connection conn);
        
        /*!
        \brief
        Internal method, unsubscribes auto connections
        
        \par
        DO NOT USE THIS DIRECTLY
        */
        //void unsubscribeAutoConnections();
        
        //! applies this animation instance
        private function apply():void
        {
            if (d_target)
            {
                d_definition.apply(this);
            }
        }
        
        //! this is called when animation starts
        private function onAnimationStarted():void
        {
            purgeSavedPropertyValues();
            d_definition.savePropertyValues(this);
            
            if (d_eventReceiver)
            {
                var args:AnimationEventArgs = new AnimationEventArgs(this);
                d_eventReceiver.fireEvent(EventAnimationStarted, args, EventNamespace);
            }
        }
        //! this is called when animation stops
        private function onAnimationStopped():void
        {
            if (d_eventReceiver)
            {
                var args:AnimationEventArgs = new AnimationEventArgs(this);
                d_eventReceiver.fireEvent(EventAnimationStopped, args, EventNamespace);
            }
        }
        //! this is called when animation pauses
        private function onAnimationPaused():void
        {
            if (d_eventReceiver)
            {
                var args:AnimationEventArgs = new AnimationEventArgs(this);
                d_eventReceiver.fireEvent(EventAnimationPaused, args, EventNamespace);
            }
        }
        //! this is called when animation unpauses
        private function onAnimationUnpaused():void
        {
            if (d_eventReceiver)
            {
                var args:AnimationEventArgs = new AnimationEventArgs(this);
                d_eventReceiver.fireEvent(EventAnimationUnpaused, args, EventNamespace);
            }
        }
        
        //! this is called when animation ends
        private function onAnimationEnded():void
        {
            if (d_eventReceiver)
            {
                var args:AnimationEventArgs = new AnimationEventArgs(this);
                d_eventReceiver.fireEvent(EventAnimationEnded, args, EventNamespace);
            }
        }
        //! this is called when animation loops (in RM_Loop or RM_Bounce mode)
        private function onAnimationLooped():void
        {
            if (d_eventReceiver)
            {
                var args:AnimationEventArgs = new AnimationEventArgs(this);
                d_eventReceiver.fireEvent(EventAnimationLooped, args, EventNamespace);
            }
        }


        
    }
}