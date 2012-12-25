/*!
\brief
EventArgs based class that is used for objects passed to input event handlers
concerning mouse cursor events.
*/


package Flame2D.core.events
{
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.system.FlameMouseCursor;
    
    public class MouseCursorEventArgs extends EventArgs
    {
        public var mouseCursor:FlameMouseCursor = null;//!< pointer to a MouseCursor object of relevance to the event.
        public var image:FlameImage = null;//!< pointer to an Image object of relevance to the event.
        
        public function MouseCursorEventArgs(cursor:FlameMouseCursor)
        {
            this.mouseCursor = cursor;
        }
        
    }
}
