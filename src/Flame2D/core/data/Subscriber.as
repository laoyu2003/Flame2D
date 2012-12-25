

package Flame2D.core.data
{
    public class Subscriber
    {
        public var callback:Function;
        public var instance:*;
        
        public function Subscriber(_callback:Function, _instance:*)
        {
            callback = _callback;
            instance = _instance;
        }
    }
}