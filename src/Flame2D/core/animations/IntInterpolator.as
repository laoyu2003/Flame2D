
package Flame2D.core.animations
{
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class IntInterpolator extends Interpolator
    {
        private static const InterpolatorType:String = "int";
        
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
            const val1:int = FlamePropertyHelper.stringToInt(value1);
            const val2:int = FlamePropertyHelper.stringToInt(value2);
            
            const result:int = int(val1 * (1.0 - position) + val2 * (position));
            
            return FlamePropertyHelper.intToString(result);
        }
        
        //----------------------------------------------------------------------------//
        override public function interpolateRelative(base:String,value1:String, value2:String, position:Number):String
        {
            const bas:int = FlamePropertyHelper.stringToInt(base);
            const val1:int = FlamePropertyHelper.stringToInt(value1);
            const val2:int = FlamePropertyHelper.stringToInt(value2);
            
            const result:int = int(bas + (val1 * (1.0 - position) + val2 * (position)));
            
            return FlamePropertyHelper.intToString(result);
        }
        
        //----------------------------------------------------------------------------//
        override public function interpolateRelativeMultiply(base:String,value1:String, value2:String, position:Number):String
        {
            const bas:int = FlamePropertyHelper.stringToInt(base);
            const val1:int = FlamePropertyHelper.stringToInt(value1);
            const val2:int = FlamePropertyHelper.stringToInt(value2);
            
            const mul:Number = val1 * (1.0 - position) + val2 * (position);
            
            const result:int = int(bas * mul);
            
            return FlamePropertyHelper.intToString(result);
        }
        
    }
}