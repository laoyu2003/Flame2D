/*!
\brief
EventArgs based class that is used for notifications regarding the main
display.
*/

package Flame2D.core.events
{
    import Flame2D.core.utils.Size;
    
    public class DisplayEventArgs extends EventArgs
    {
        public var size:Size = null;
        
        public function DisplayEventArgs(sz:Size)
        {
            this.size = sz;
        }
        
    }
}
