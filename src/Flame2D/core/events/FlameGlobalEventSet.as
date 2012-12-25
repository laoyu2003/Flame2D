
package Flame2D.core.events
{
    import Flame2D.core.system.FlameEventSet;
    
    public class FlameGlobalEventSet extends FlameEventSet
    {
        /*!
        \brief
        The GlobalEventSet singleton allows you to subscribe to an event for all
        instances of a class.  The GlobalEventSet effectively supports "late binding"
        to events; which means you can subscribe to some event that does not actually
        exist (yet).
        */
        
        
        private static var d_singleton:FlameGlobalEventSet = new FlameGlobalEventSet();
        
        public function FlameGlobalEventSet()
        {
            if(d_singleton){
                throw new Error("FlameGlobalEventSet: only be accessed from singleton");
            }
        }
        
        
        /*!
        \brief
        Return singleton System object
        
        \return
        Singleton System object
        */
        public static function getSingleton():FlameGlobalEventSet
        {
            return d_singleton;
        }
        
        
        /*!
        \brief
        Fires the named event passing the given EventArgs object.
        
        \param name
        String object holding the name of the Event that is to be fired (triggered)
        
        \param args
        The EventArgs (or derived) object that is to be bassed to each subscriber of the Event.  Once all subscribers
        have been called the 'handled' field of the event is updated appropriately.
        
        \param eventNamespace
        String object describing the namespace prefix to use when firing the global event.
        
        \return
        Nothing.
        */
//        public function fireEvent(name:String, args:FlameEventArgs, eventNamespace:String = ""):void
//        {
//            fireEvent_impl(eventNamespace + "/" + name, args);
//        }
    }
}
    