
/*!
\brief
WindowEventArgs class that is primarily used by lua scripts
*/


package Flame2D.core.events
{
    import Flame2D.core.system.FlameWindow;
    
    public class UpdateEventArgs extends WindowEventArgs
    {
        public var d_timeSinceLastFrame:Number = 0;
        
        public function UpdateEventArgs(win:FlameWindow, tslf:Number)
        {
            super(win);
            
            this.d_timeSinceLastFrame = tslf;
        }
        
    }
    
}
