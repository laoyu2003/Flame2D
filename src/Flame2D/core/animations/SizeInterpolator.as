
package Flame2D.core.animations
{
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.utils.Size;
    
    public class SizeInterpolator extends Interpolator
    {
        private static const InterpolatorType:String = "Size";
        
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
            const val1:Size = FlamePropertyHelper.stringToSize(value1);
            const val2:Size = FlamePropertyHelper.stringToSize(value2);
            
            const result:Size = val1.multiply(1.0 - position).add(val2.multiply(position));
            
            return FlamePropertyHelper.sizeToString(result);
        }
        
        //----------------------------------------------------------------------------//
        override public function interpolateRelative(base:String,value1:String, value2:String, position:Number):String
        {
            const bas:Size = FlamePropertyHelper.stringToSize(base);
            const val1:Size = FlamePropertyHelper.stringToSize(value1);
            const val2:Size = FlamePropertyHelper.stringToSize(value2);
            
            const result:Size = bas.add(val1.multiply(1.0 - position).add(val2.multiply(position)));
            
            return FlamePropertyHelper.sizeToString(result);
        }
        
        //----------------------------------------------------------------------------//
        override public function interpolateRelativeMultiply(base:String,value1:String, value2:String, position:Number):String
        {
            const bas:Size = FlamePropertyHelper.stringToSize(base);
            const val1:Number = FlamePropertyHelper.stringToFloat(value1);
            const val2:Number = FlamePropertyHelper.stringToFloat(value2);
            
            const mul:Number = val1 * (1.0 - position) + val2 * (position);
            
            const result:Size = bas.multiply(mul);
            
            return FlamePropertyHelper.sizeToString(result);
        }
        
    }
}