
package Flame2D.core.events
{
    import Flame2D.core.system.FlameWindow;
    /*!
    \brief
    EventArgs based class that is passed to handlers subcribed to hear about
    begin/end events on rendering queues that are part of a RenderingSurface
    object.
    */
    public class RenderQueueEventArgs extends EventArgs
    {
        
        //! ID of the queue that this event has been fired for.
        public var queueID:uint = 0;

        /*!
        \brief
        Constructor for RenderQueueEventArgs objects.
        
        \param id
        RenderQueueID value indicating the queue that the event is being
        generated for.
        */
        public function RenderQueueEventArgs(id:uint)
        {
            queueID = id;
        }
    }
    
}
