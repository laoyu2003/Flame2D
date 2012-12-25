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
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.EventArgs;
    
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;

    /*!
    \brief
    Class that collects together a set of Event objects.
    
    The EventSet is a means for code to attach a handler function to some
    named event, and later, for that event to be fired and the subscribed
    handler(s) called.
    \par
    As of 0.5, the EventSet no longer needs to be filled with available events.
    Events are now added to the set as they are first used; that is, the first
    time a handler is subscribed to an event for a given EventSet, an Event
    object is created and added to the EventSet.
    \par
    Instead of throwing an exception when firing an event that does not actually
    exist in the set, we now do nothing (if the Event does not exist, then it
    has no handlers subscribed, and therefore doing nothing is the correct
    course action).
    */
    public class FlameEventSet extends EventDispatcher
    {

            
        //typedef std::map<String, Event*, String::FastLessCompare>	EventMap;
        protected var d_events:Dictionary = new Dictionary();
        protected var d_muted:Boolean = false;	//!< true if events for this EventSet have been muted.

        
        public function FlameEventSet()
        {

        }
        
        /*!
        \brief
        Add a new Event to the EventSet with the given name.
        
        \param name
        String object containing the name to give the new Event.  The name must be unique for the EventSet.
        
        \return
        Nothing
        
        \exception AlreadyExistsException	Thrown if an Event already exists named \a name.
        */
        public function addEvent(name:String):void
        {
            if (isEventPresent(name))
            {
                throw new Error("An event named '" + name + "' already exists in the EventSet.");
            }
            
 //           d_events[name] = new FlameEvent(name);
        }
        
        
        /*!
        \brief
        Removes the Event with the given name.  All connections to the event are disconnected.
        
        \param name
        String object containing the name of the Event to remove.  If no such Event exists, nothing happens.
        
        \return
        Nothing.
        */
        public function removeEvent(name:String):void
        {
            if(d_events.hasOwnProperty(name))
            {
                delete d_events[name];
            }
        }
        
        
        /*!
        \brief
        Remove all Event objects from the EventSet
        
        \return
        Nothing
        */
        public function removeAllEvents():void
        {
            d_events = new Dictionary();
        }
        
        
        /*!
        \brief
        Checks to see if an Event with the given name is present in the EventSet.
        
        \return
        true if an Event named \a name was found, or false if the Event was not found
        */
        public function isEventPresent(name:String):Boolean
        {
            return d_events.hasOwnProperty(name);
        }
        
        
        /*!
        \brief
        Subscribes a handler to the named Event.  If the named Event is not yet
        present in the EventSet, it is created and added.
        
        \param name
        String object containing the name of the Event to subscribe to.
        
        \param subscriber
        Function or object that is to be subscribed to the Event.
        
        \return
        Connection object that can be used to check the status of the Event
        connection and to disconnect (unsubscribe) from the Event.
        */
        public function subscribeEvent(name:String, subscriber:Subscriber, eventNamespace:String):void
        {
            var eventName:String = eventNamespace + "/" + name;
            
            d_events[eventName] = subscriber;

            addEventListener(eventName, onEvent);
            //addEventListener(name, onEvent);
            
        }
        
        private function onEvent(e:FlameEvent):void
        {
            var args:EventArgs = e.d_args;
            var name:String = e.type;
            var subscriber:Subscriber = getEventObject(name);
        
            subscriber.callback(args);
        }
        
        /*!
        \brief
        Subscribes a handler to the specified group of the named Event.  If the
        named Event is not yet present in the EventSet, it is created and added.
        
        \param name
        String object containing the name of the Event to subscribe to.
        
        \param group
        Group which is to be subscribed to.  Subscription groups are called in
        ascending order.
        
        \param subscriber
        Function or object that is to be subscribed to the Event.
        
        \return
        Connection object that can be used to check the status of the Event
        connection and to disconnect (unsubscribe) from the Event.
        */
        //virtual Event::Connection subscribeEvent(const String& name, Event::Group group, Event::Subscriber subscriber);
        
        
        /*!
        \brief
        Subscribes the named Event to a scripted funtion
        
        \param name
        String object containing the name of the Event to subscribe to.
        
        \param subscriber_name
        String object containing the name of the script funtion that is to be
        subscribed to the Event.
        
        \return
        Connection object that can be used to check the status of the Event
        connection and to disconnect (unsubscribe) from the Event.
        */
        public function subscribeScriptedEvent(instance:FlameWindow, name:String, func:String):void
        {
        }
        
        /*!
        \brief
        Subscribes the specified group of the named Event to a scripted funtion.
        
        \param name
        String object containing the name of the Event to subscribe to.
        
        \param group
        Group which is to be subscribed to.  Subscription groups are called in
        ascending order.
        
        \param subscriber_name
        String object containing the name of the script funtion that is to be
        subscribed to the Event.
        
        \return
        Connection object that can be used to check the status of the Event
        connection and to disconnect (unsubscribe) from the Event.
        */
        //virtual Event::Connection subscribeScriptedEvent(const String& name, Event::Group group, const String& subscriber_name);
        
        
        /*!
        \brief
        Fires the named event passing the given EventArgs object.
        
        \param name
        String object holding the name of the Event that is to be fired
        (triggered)
        
        \param args
        The EventArgs (or derived) object that is to be bassed to each
        subscriber of the Event.  Once all subscribers
        have been called the 'handled' field of the event is updated
        appropriately.
        
        \param eventNamespace
        String object describing the global event namespace prefix for this
        event.
        
        \return
        Nothing.
        */
        public function fireEvent(name:String, args:EventArgs, eventNamespace:String):void
        {
            var event:FlameEvent = new FlameEvent(eventNamespace + "/" + name, args);
            //var event:FlameEvent = new FlameEvent(name, args);
            dispatchEvent(event);
        }
        
        
        /*!
        \brief
        Return whether the EventSet is muted or not.
        
        \return
        - true if the EventSet is muted.  All requests to fire events will be ignored.
        - false if the EventSet is not muted.  All requests to fire events are processed as normal.
        */
        public function isMuted():Boolean
        {
            return d_muted;
        }
        
        
        /*!
        \brief
        Set the mute state for this EventSet.
        
        \param setting
        - true if the EventSet is to be muted (no further event firing requests will be honoured until EventSet is unmuted).
        - false if the EventSet is not to be muted and all events should fired as requested.
        
        \return
        Nothing.
        */
        public function setMutedState(setting:Boolean):void
        {
            d_muted = setting;
        }
        
        
        /*!
        \brief
        Return a pointer to the Event object with the given name, optionally
        adding such an Event object to the EventSet if it does not already
        exist.
        
        \param name
        String object holding the name of the Event to return.
        
        \param autoAdd
        - true if an Event object named \a name should be added to the set
        if such an Event does not currently exist.
        - false if no object should automatically be added to the set.  In this
        case, if the Event does not already exist 0 will be returned.
        
        \return
        Pointer to the Event object in this EventSet with the specifed name.
        Or 0 if such an Event does not exist and \a autoAdd was false.
        */
        protected function getEventObject(name:String):Subscriber
        {
            // if event did not exist, add it and then find it.
            if(d_events.hasOwnProperty(name))
            {
                return d_events[name];
            }
            
            return null;
        }

        
    }
}