
package Flame2D.core.animations
{
    
    public class StringInterpolator extends Interpolator
    {
        private static const InterpolatorType:String = "String";
        
        override public function getType():String
        {
            return InterpolatorType;
        }
        
        override public function interpolateAbsolute(value1:String, value2:String, position:Number):String
        {
            return position < 0.5 ? value1 : value2;
        }
        
        override public function interpolateRelative(base:String,value1:String, value2:String, position:Number):String
        {
            return base + (position < 0.5 ? value1 : value2);
        }
        
        override public function interpolateRelativeMultiply(base:String,value1:String, value2:String, position:Number):String
        {
            //const float val1 = PropertyHelper::stringToFloat(value1);
            //const float val2 = PropertyHelper::stringToFloat(value2);
            
            //const float mul = val1 * (1.0f - position) + val2 * (position);
            
            // todo: some fancy length cutting?
            return base;
        }
    }
}