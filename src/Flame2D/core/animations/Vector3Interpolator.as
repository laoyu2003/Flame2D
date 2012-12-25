
package Flame2D.core.animations
{
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.Vector3;
    
    public class Vector3Interpolator extends Interpolator
    {
        private static const InterpolatorType:String = "Vector3";
        
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
            const val1:Vector3 = FlamePropertyHelper.stringToVector3(value1);
            const val2:Vector3 = FlamePropertyHelper.stringToVector3(value2);
            
            const result:Vector3 = val1.multiply(1.0 - position).add_(val2.multiply(position));
            
            return FlamePropertyHelper.vector3ToString(result);
        }
        
        //----------------------------------------------------------------------------//
        override public function interpolateRelative(base:String,value1:String, value2:String, position:Number):String
        {
            const bas:Vector3 = FlamePropertyHelper.stringToVector3(base);
            const val1:Vector3 = FlamePropertyHelper.stringToVector3(value1);
            const val2:Vector3 = FlamePropertyHelper.stringToVector3(value2);
            
            const result:Vector3 = bas.add_(val1.multiply(1.0 - position).add_(val2.multiply(position)));
            
            return FlamePropertyHelper.vector3ToString(result);
        }
        
        //----------------------------------------------------------------------------//
        override public function interpolateRelativeMultiply(base:String,value1:String, value2:String, position:Number):String
        {
            const bas:Vector3 = FlamePropertyHelper.stringToVector3(base);
            const val1:Number = FlamePropertyHelper.stringToFloat(value1);
            const val2:Number = FlamePropertyHelper.stringToFloat(value2);
            
            const mul:Number = val1 * (1.0 - position) + val2 * (position);
            
            const result:Vector3 = bas.multiply(mul);
            
            return FlamePropertyHelper.vector3ToString(result);
        }
        
    }
}