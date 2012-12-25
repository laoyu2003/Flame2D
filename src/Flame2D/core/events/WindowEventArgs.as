
/*!
\brief
EventArgs based class that is used for objects passed to handlers triggered for events
concerning some Window object.
*/


package Flame2D.core.events
{
    import Flame2D.core.system.FlameWindow;
    
    public class WindowEventArgs extends EventArgs
    {
        
        public var window:FlameWindow = null;
        
        public function WindowEventArgs(win:FlameWindow)
        {
            this.window = win;
        }
        
        public function clone():WindowEventArgs
        {
            return new WindowEventArgs(window);
        }
    }
    
}