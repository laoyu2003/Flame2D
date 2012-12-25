
package Flame2D.core.animations
{
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.utils.Rect;
    
    public class RectInterpolator extends Interpolator
    {
        private static const InterpolatorType:String = "Rect";
        
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
            const val1:Rect = FlamePropertyHelper.stringToRect(value1);
            const val2:Rect = FlamePropertyHelper.stringToRect(value2);
            
            const result:Rect = val1.multiply(1.0 - position).add(val2.multiply(position));
            
            return FlamePropertyHelper.rectToString(result);
        }
        
        //----------------------------------------------------------------------------//
        override public function interpolateRelative(base:String,value1:String, value2:String, position:Number):String
        {
            const bas:Rect = FlamePropertyHelper.stringToRect(base);
            const val1:Rect = FlamePropertyHelper.stringToRect(value1);
            const val2:Rect = FlamePropertyHelper.stringToRect(value2);
            
            const result:Rect = bas.add(val1.multiply(1.0 - position).add(val2.multiply(position)));
            
            return FlamePropertyHelper.rectToString(result);
        }
        
        //----------------------------------------------------------------------------//
        override public function interpolateRelativeMultiply(base:String,value1:String, value2:String, position:Number):String
        {
            const bas:Rect = FlamePropertyHelper.stringToRect(base);
            const val1:Number = FlamePropertyHelper.stringToFloat(value1);
            const val2:Number = FlamePropertyHelper.stringToFloat(value2);
            
            const mul:Number = val1 * (1.0 - position) + val2 * (position);
            
            const result:Rect = bas.multiply(mul);
            
            return FlamePropertyHelper.rectToString(result);
        }
        
    }
}