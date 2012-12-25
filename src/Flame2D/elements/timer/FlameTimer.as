
package Flame2D.elements.timer
{
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.utils.UDim;
    import Flame2D.core.utils.UVector2;

    public class FlameTimer extends FlameWindow
    {
        
        /*************************************************************************
         Constants
         *************************************************************************/
        // type name for this widget
        public static const WidgetTypeName:String = "Timer";             //!< The unique typename of this widget
        public static const EventNamespace:String = "Timer";             //!< Store the event namespace related to the timer 
        public static const EventTimerAlarm:String = "EventTimerAlarm";            //!< The name of the event generated  by this widget 
        
        
        private static var d_delayProperty:TimerPropertyDelay = new TimerPropertyDelay();
        private static var d_delay:Number = 0; //!< Store the current delay between two alarm 
        private static var d_currentValue:Number = 0; //!< Set the current value 
        private static var  d_started:Boolean = false; //!< Store wether the timer should produce event or not 

        
        /*************************************************************************
         Construction and Destruction
         *************************************************************************/
        /*!
        \brief
        Constructor for Timer windows.
        */
        public function FlameTimer(type:String, name:String)
        {
            super(type, name);
            
            var sz:UVector2 = new UVector2(new UDim(1.0, 0.0), new UDim(1.0, 0.0));
            setMaxSize(sz);
            setSize(sz);
            addTimerProperties();
        }

        /*!
        \brief start the timer in order to generate alarm event 
        */
        public function start():void
        {
            d_started = true;
        }
        
        /*!
        \brief stop generating alarm event  
        */
        public function stop():void
        {
            d_started = false;
        }
            
        /*!
        \brief Check wether the timer is started or not 
        */
        public function isStarted():Boolean
        {
            return d_started;
        }
        /*! 
        \brief 
        Set the delay between to event generation in seconds 
        */
        public function setDelay(delay:Number):void
        {
            d_delay = delay;
        }
        
        public function getDelay():Number
        {
            return d_delay;
        }
        
        override protected function updateSelf(elapsed:Number):void
        {
            if (d_delay > 0 && d_started)
            {
                d_currentValue += elapsed;
                if (d_currentValue >= d_delay)
                {
                    d_currentValue -= d_delay;
                    var args:WindowEventArgs = new WindowEventArgs(this);
                    fireEvent(EventTimerAlarm, args, EventNamespace);
                }
            }
        }
        
        /*!
        \brief
        Return whether this window was inherited from the given class name at some point in the inheritance hierarchy.
        
        \param class_name
        The class name that is to be checked.
        
        \return
        true if this window was inherited from \a class_name. false if not.
        */
        override protected function testClassName_impl(class_name:String):Boolean
        {
            if (class_name=="Timer")	
                return true;
            return super.testClassName_impl(class_name);
        }
        
        private function addTimerProperties():void
        {
            addProperty(d_delayProperty);
        }
            

        
        
    }
}