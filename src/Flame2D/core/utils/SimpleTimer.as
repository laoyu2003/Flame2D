
package Flame2D.core.utils
{
    import flash.utils.getTimer;
    
    public class SimpleTimer
    {
        private var d_baseTime:Number;
        
        public function SimpleTimer()
        {
            d_baseTime = getTimer();
        }
        
        public static function currentTime():Number
        {
            return getTimer();
        }
        
        public function restart():void
        {
            d_baseTime = getTimer();
        }
        
        public function elapsed():Number
        {
            return currentTime() - d_baseTime;
        }
    }
}