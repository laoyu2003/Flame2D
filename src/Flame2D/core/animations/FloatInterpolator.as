
package Flame2D.core.animations
{
    import Flame2D.core.properties.FlamePropertyHelper;

    public class FloatInterpolator extends Interpolator
    {
        private static const InterpolatorType:String = "float";
        
        /********************************************
         * Float interpolator
         ********************************************/
        override public function getType():String
        {
            return InterpolatorType;
        }
        
        //----------------------------------------------------------------------------//
        override public function interpolateAbsolute(value1:String, value2:String, position:Number):String
        {
            const val1:Number = FlamePropertyHelper.stringToFloat(value1);
            const val2:Number = FlamePropertyHelper.stringToFloat(value2);
            
            const result:Number = val1 * (1.0 - position) + val2 * (position);
            
            return FlamePropertyHelper.floatToString(result);
        }
            
        //----------------------------------------------------------------------------//
        override public function interpolateRelative(base:String,value1:String, value2:String, position:Number):String
        {
            const bas:Number = FlamePropertyHelper.stringToFloat(base);
            const val1:Number = FlamePropertyHelper.stringToFloat(value1);
            const val2:Number = FlamePropertyHelper.stringToFloat(value2);
            
            const result:Number = bas + (val1 * (1.0 - position) + val2 * (position));
            
            return FlamePropertyHelper.floatToString(result);
        }
                
        //----------------------------------------------------------------------------//
        override public function interpolateRelativeMultiply(base:String,value1:String, value2:String, position:Number):String
        {
            const bas:Number = FlamePropertyHelper.stringToFloat(base);
            const val1:Number = FlamePropertyHelper.stringToFloat(value1);
            const val2:Number = FlamePropertyHelper.stringToFloat(value2);
            
            const mul:Number = val1 * (1.0 - position) + val2 * (position);
            
            const result:Number = bas * mul;
            
            return FlamePropertyHelper.floatToString(result);
        }

    }
}