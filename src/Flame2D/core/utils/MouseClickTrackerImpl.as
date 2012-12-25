
package Flame2D.core.utils
{
    import Flame2D.core.data.Consts;

    public class MouseClickTrackerImpl
    {
        public var click_trackers:Vector.<MouseClickTracker>;
        
        public function MouseClickTrackerImpl()
        {
            click_trackers = new Vector.<MouseClickTracker>(Consts.MouseButton_MouseButtonCount);
            for(var i:uint = 0; i<click_trackers.length; i++)
            {
                click_trackers[i] = new MouseClickTracker();
            }
        }
    }
}