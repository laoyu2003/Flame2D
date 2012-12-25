
package Flame2D.core.animations
{
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.utils.UDim;
    import Flame2D.core.utils.URect;
    
    public class URectInterpolator extends Interpolator
    {
        private static const InterpolatorType:String = "URect";
        
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
            const val1:URect = FlamePropertyHelper.stringToURect(value1);
            const val2:URect = FlamePropertyHelper.stringToURect(value2);
            
            const result:URect = val1.multiplyUDim(new UDim(1.0 - position, 1.0 - position)).add(val2.multiplyUDim(new UDim(position, position)));
            
            return FlamePropertyHelper.urectToString(result);
        }
        
        //----------------------------------------------------------------------------//
        override public function interpolateRelative(base:String,value1:String, value2:String, position:Number):String
        {
            const bas:URect = FlamePropertyHelper.stringToURect(base);
            const val1:URect = FlamePropertyHelper.stringToURect(value1);
            const val2:URect = FlamePropertyHelper.stringToURect(value2);
            
            const result:URect = bas.add(val1.multiplyUDim(new UDim(1.0 - position, 1.0 - position)).add(val2.multiplyUDim(new UDim(position, position))));
            
            return FlamePropertyHelper.urectToString(result);
        }
        
        //----------------------------------------------------------------------------//
        override public function interpolateRelativeMultiply(base:String,value1:String, value2:String, position:Number):String
        {
            const bas:URect = FlamePropertyHelper.stringToURect(base);
            const val1:Number = FlamePropertyHelper.stringToFloat(value1);
            const val2:Number = FlamePropertyHelper.stringToFloat(value2);
            
            const mul:Number = val1 * (1.0 - position) + val2 * (position);
            
            const result:URect = bas.multiplyUDim(new UDim(mul, mul));
            
            return FlamePropertyHelper.urectToString(result);
        }
        
    }
}