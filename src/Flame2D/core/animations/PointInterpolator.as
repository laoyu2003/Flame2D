
package Flame2D.core.animations
{
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.utils.Vector2;
    
    public class PointInterpolator extends Interpolator
    {
        private static const InterpolatorType:String = "Point";
        
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
            const val1:Vector2 = FlamePropertyHelper.stringToVector2(value1);
            const val2:Vector2 = FlamePropertyHelper.stringToVector2(value2);
            
            const result:Vector2 = val1.multiply(1.0 - position).add(val2.multiply(position));
            
            return FlamePropertyHelper.vector2ToString(result);
        }
        
        //----------------------------------------------------------------------------//
        override public function interpolateRelative(base:String,value1:String, value2:String, position:Number):String
        {
            const bas:Vector2 = FlamePropertyHelper.stringToVector2(base);
            const val1:Vector2 = FlamePropertyHelper.stringToVector2(value1);
            const val2:Vector2 = FlamePropertyHelper.stringToVector2(value2);
            
            const result:Vector2 = bas.add(val1.multiply(1.0 - position).add(val2.multiply(position)));
            
            return FlamePropertyHelper.vector2ToString(result);
        }
        
        //----------------------------------------------------------------------------//
        override public function interpolateRelativeMultiply(base:String,value1:String, value2:String, position:Number):String
        {
            const bas:Vector2 = FlamePropertyHelper.stringToVector2(base);
            const val1:Number = FlamePropertyHelper.stringToFloat(value1);
            const val2:Number = FlamePropertyHelper.stringToFloat(value2);
            
            const mul:Number = val1 * (1.0 - position) + val2 * (position);
            
            const result:Vector2 = bas.multiply(mul);
            
            return FlamePropertyHelper.vector2ToString(result);
        }
        
    }
}