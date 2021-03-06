
package Flame2D.core.events
{
    /*!
    \brief
    Base class used as the argument to all subscribers Event object.
    
    The base EventArgs class does not contain any useful information, it is intended
    to be specialised for each type of event that can be generated by objects within
    the system.  The use of this base class allows all event subscribers to have the
    same function signature.
    
    The \a handled field is used to signal whether an event was actually handled or not.  While
    the event system does not look at this value, code at a higher level can use it to determine
    how far to propagate an event.
    */
    public class EventArgs
    {
        
        
        /*************************************************************************
         Data members
         *************************************************************************/
        //! handlers should increment this if they handled the event.
        public var handled:uint = 0;
        
        
        public function EventArgs()
        {
            
        }
    }
}