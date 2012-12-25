


/*!
\brief
EventArgs based class that is used for objects passed to input event handlers
concerning mouse input.
*/

package Flame2D.core.events
{
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.utils.Vector2;
    
    public class MouseEventArgs extends WindowEventArgs
    {
        public var position:Vector2 = new Vector2();          //!< holds current mouse position.
        public var moveDelta:Vector2 = new Vector2();       //!< holds variation of mouse position from last mouse input
        public var button:uint = 0;//!< one of the MouseButton enumerated values describing the mouse button causing the event (for button inputs only)
        public var sysKeys:uint = 0; //!< current state of the system keys and mouse buttons.
        public var wheelChange:Number = 0;//!< Holds the amount the scroll wheel has changed.
        public var clickCount:uint = 0;//!< Holds number of mouse button down events currently counted in a multi-click sequence (for button inputs only).
        
        public function MouseEventArgs(win:FlameWindow)
        {
            super(win);
        }
        
    }
}
