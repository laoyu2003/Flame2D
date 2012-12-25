/*!
\brief
EventArgs based class that is used for objects passed to input event handlers
concerning keyboard input.
*/

package Flame2D.core.events
{
    import Flame2D.core.system.FlameWindow;
    
    public class KeyEventArgs extends WindowEventArgs
    {
        public var codepoint:uint = 0;//!< utf32 codepoint for the key (only used for Character inputs).
        public var scancode:uint = 0;//!< Scan code of key that caused event (only used for key up & down inputs.
        public var sysKeys:uint = 0;//!< current state of the system keys and mouse buttons.
        
        public function KeyEventArgs(win:FlameWindow)
        {
            super(win);
        }
        
    }
}
