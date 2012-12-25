
package Flame2D.core.utils
{
    import Flame2D.core.system.FlameWindow;
    
    public class MouseClickTracker
    {
        public var d_timer:SimpleTimer = new SimpleTimer();	//!< Timer used to track clicks for this button.
        public var d_click_count:int = 0;		//!< count of clicks made so far.
        public var d_click_area:Rect = new Rect(0,0,0,0);		//!< area used to detect multi-clicks
        public var d_target_window:FlameWindow = null;    //!< target window for any events generated.
        
        public function MouseClickTracker()
        {
            
        }
    }
}