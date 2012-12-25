
package Flame2D.core.animations
{
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class UintInterpolator extends Interpolator
    {
        private static const InterpolatorType:String = "uint";
        
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
            const val1:uint = FlamePropertyHelper.stringToUint(value1);
            const val2:uint = FlamePropertyHelper.stringToUint(value2);
            
            const result:uint = uint(val1 * (1.0 - position) + val2 * (position));
            
            return FlamePropertyHelper.uintToString(result);
        }
        
        //----------------------------------------------------------------------------//
        override public function interpolateRelative(base:String,value1:String, value2:String, position:Number):String
        {
            const bas:uint = FlamePropertyHelper.stringToUint(base);
            const val1:uint = FlamePropertyHelper.stringToUint(value1);
            const val2:uint = FlamePropertyHelper.stringToUint(value2);
            
            const result:uint = uint(bas + (val1 * (1.0 - position) + val2 * (position)));
            
            return FlamePropertyHelper.uintToString(result);
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