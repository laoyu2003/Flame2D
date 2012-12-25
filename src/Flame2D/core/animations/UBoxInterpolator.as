
package Flame2D.core.animations
{
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.utils.UBox;
    import Flame2D.core.utils.UDim;
    
    public class UBoxInterpolator extends Interpolator
    {
        private static const InterpolatorType:String = "UBox";
        
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
            const val1:UBox = FlamePropertyHelper.stringToUBox(value1);
            const val2:UBox = FlamePropertyHelper.stringToUBox(value2);
            
            const result:UBox = val1.multiply(new UDim(1.0 - position, 1.0 - position)).add(val2.multiply(new UDim(position, position)));
            
            return FlamePropertyHelper.uboxToString(result);
        }
        
        //----------------------------------------------------------------------------//
        override public function interpolateRelative(base:String,value1:String, value2:String, position:Number):String
        {
            const bas:UBox = FlamePropertyHelper.stringToUBox(base);
            const val1:UBox = FlamePropertyHelper.stringToUBox(value1);
            const val2:UBox = FlamePropertyHelper.stringToUBox(value2);
            
            const result:UBox = bas.add(val1.multiply(new UDim(1.0 - position, 1.0 - position)).add(val2.multiply(new UDim(position, position))));
            
            return FlamePropertyHelper.uboxToString(result);
        }
        
        //----------------------------------------------------------------------------//
        override public function interpolateRelativeMultiply(base:String,value1:String, value2:String, position:Number):String
        {
            const bas:UBox = FlamePropertyHelper.stringToUBox(base);
            const val1:Number = FlamePropertyHelper.stringToFloat(value1);
            const val2:Number = FlamePropertyHelper.stringToFloat(value2);
            
            const mul:Number = val1 * (1.0 - position) + val2 * (position);
            
            const result:UBox = bas.multiply(new UDim(mul, mul));
            
            return FlamePropertyHelper.uboxToString(result);
        }
        
    }
}