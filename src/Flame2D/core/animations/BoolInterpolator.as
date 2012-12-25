
package Flame2D.core.animations
{
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class BoolInterpolator extends Interpolator
    {
        private static const InterpolatorType:String = "bool";
        
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
            const val1:Boolean = FlamePropertyHelper.stringToBool(value1);
            const val2:Boolean = FlamePropertyHelper.stringToBool(value2);
            
            return FlamePropertyHelper.boolToString(position < 0.5 ? val1 : val2);
        }
        
        //----------------------------------------------------------------------------//
        override public function interpolateRelative(base:String,value1:String, value2:String, position:Number):String
        {
            //const bas:Boolean = FlamePropertyHelper.stringToBool(base);
            const val1:Boolean = FlamePropertyHelper.stringToBool(value1);
            const val2:Boolean = FlamePropertyHelper.stringToBool(value2);
            
            return FlamePropertyHelper.boolToString(position < 0.5 ? val1 : val2);
        }
        
        //----------------------------------------------------------------------------//
        override public function interpolateRelativeMultiply(base:String,value1:String, value2:String, position:Number):String
        {
            return base;
        }
        
    }
}