
package Flame2D.core.animations
{
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.utils.Colour;
    import Flame2D.core.utils.ColourRect;
    
    public class ColourRectInterpolator extends Interpolator
    {
        private static const InterpolatorType:String = "ColourRect";
        
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
            const val1:ColourRect = FlamePropertyHelper.stringToColourRect(value1);
            const val2:ColourRect = FlamePropertyHelper.stringToColourRect(value2);
            
            const result:ColourRect = val1.multiply(1.0 - position).add(val2.multiply(position));
            
            return FlamePropertyHelper.colourRectToString(result);
        }
        
        //----------------------------------------------------------------------------//
        override public function interpolateRelative(base:String,value1:String, value2:String, position:Number):String
        {
            const bas:ColourRect = FlamePropertyHelper.stringToColourRect(base);
            const val1:ColourRect = FlamePropertyHelper.stringToColourRect(value1);
            const val2:ColourRect = FlamePropertyHelper.stringToColourRect(value2);
            
            const result:ColourRect = bas.add(val1.multiply(1.0 - position).add(val2.multiply(position)));
            
            return FlamePropertyHelper.colourRectToString(result);
        }
        
        //----------------------------------------------------------------------------//
        override public function interpolateRelativeMultiply(base:String,value1:String, value2:String, position:Number):String
        {
            const bas:ColourRect = FlamePropertyHelper.stringToColourRect(base);
            const val1:Number = FlamePropertyHelper.stringToFloat(value1);
            const val2:Number = FlamePropertyHelper.stringToFloat(value2);
            
            const mul:Number = val1 * (1.0 - position) + val2 * (position);
            
            const result:ColourRect = bas.multiply(mul);
            
            return FlamePropertyHelper.colourRectToString(result);
        }
        
    }
}