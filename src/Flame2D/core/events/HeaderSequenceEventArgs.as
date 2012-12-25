
package Flame2D.core.events
{
    import Flame2D.core.system.FlameWindow;

    public class HeaderSequenceEventArgs extends WindowEventArgs
    {
        
        public var d_oldIdx:uint;		//!< The original column index of the segment that has moved.
        public var d_newIdx:uint;		//!< The new column index of the segment that has moved.
        
        public function HeaderSequenceEventArgs(wnd:FlameWindow, old_idx:uint, new_idx:uint)
        {
            super(wnd);
            d_oldIdx = old_idx;
            d_newIdx = new_idx;
        }
    }
}