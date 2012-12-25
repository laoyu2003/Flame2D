
package Flame2D.core.animations
{
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.utils.Colour;
    
    public class ColourInterpolator extends Interpolator
    {
        private static const InterpolatorType:String = "colour";
        
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
            const val1:Colour = FlamePropertyHelper.stringToColour(value1);
            const val2:Colour = FlamePropertyHelper.stringToColour(value2);
            
            const result:Colour = val1.multiply(1.0 - position).add(val2.multiply(position));
            
            return FlamePropertyHelper.colourToString(result);
        }
        
        //----------------------------------------------------------------------------//
        override public function interpolateRelative(base:String,value1:String, value2:String, position:Number):String
        {
            const bas:Colour = FlamePropertyHelper.stringToColour(base);
            const val1:Colour = FlamePropertyHelper.stringToColour(value1);
            const val2:Colour = FlamePropertyHelper.stringToColour(value2);
            
            const result:Colour = bas.add(val1.multiply(1.0 - position).add(val2.multiply(position)));
            
            return FlamePropertyHelper.colourToString(result);
        }
        
        //----------------------------------------------------------------------------//
        override public function interpolateRelativeMultiply(base:String,value1:String, value2:String, position:Number):String
        {
            const bas:Colour = FlamePropertyHelper.stringToColour(base);
            const val1:Number = FlamePropertyHelper.stringToFloat(value1);
            const val2:Number = FlamePropertyHelper.stringToFloat(value2);
            
            const mul:Number = val1 * (1.0 - position) + val2 * (position);
            
            const result:Colour = bas.multiply(mul);
            
            return FlamePropertyHelper.colourToString(result);
        }
        
    }
}