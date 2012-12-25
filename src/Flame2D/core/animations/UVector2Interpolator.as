
package Flame2D.core.animations
{
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.utils.UDim;
    import Flame2D.core.utils.UVector2;
    
    public class UVector2Interpolator extends Interpolator
    {
        private static const InterpolatorType:String = "UVector2";
        
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
            const val1:UVector2 = FlamePropertyHelper.stringToUVector2(value1);
            const val2:UVector2 = FlamePropertyHelper.stringToUVector2(value2);
            
            const result:UVector2 = val1.multiplyUDim(new UDim(1.0 - position, 1.0 - position)).add(val2.multiplyUDim(new UDim(position, position)));
            
            return FlamePropertyHelper.uvector2ToString(result);
        }
        
        //----------------------------------------------------------------------------//
        override public function interpolateRelative(base:String,value1:String, value2:String, position:Number):String
        {
            const bas:UVector2 = FlamePropertyHelper.stringToUVector2(base);
            const val1:UVector2 = FlamePropertyHelper.stringToUVector2(value1);
            const val2:UVector2 = FlamePropertyHelper.stringToUVector2(value2);
            
            const result:UVector2 = bas.add(val1.multiplyUDim(new UDim(1.0 - position, 1.0 - position)).add(val2.multiplyUDim(new UDim(position, position))));
            
            return FlamePropertyHelper.uvector2ToString(result);
        }
        
        //----------------------------------------------------------------------------//
        override public function interpolateRelativeMultiply(base:String,value1:String, value2:String, position:Number):String
        {
            const bas:UVector2 = FlamePropertyHelper.stringToUVector2(base);
            const val1:Number = FlamePropertyHelper.stringToFloat(value1);
            const val2:Number = FlamePropertyHelper.stringToFloat(value2);
            
            const mul:Number = val1 * (1.0 - position) + val2 * (position);
            
            const result:UVector2 = bas.multiplyUDim(new UDim(mul, mul));
            
            return FlamePropertyHelper.uvector2ToString(result);
        }
        
    }
}