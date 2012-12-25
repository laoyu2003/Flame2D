/*!
\brief
EventArgs based class that is used for Activated and Deactivated window events
*/


package Flame2D.core.events
{
    import Flame2D.core.system.FlameWindow;
    
    public class ActivationEventArgs extends WindowEventArgs
    {
        public var otherWindow:FlameWindow = null;//!< Pointer to the other window involved in the activation change.
        
        public function ActivationEventArgs(win:FlameWindow)
        {
            super(win);
        }
    }
}
