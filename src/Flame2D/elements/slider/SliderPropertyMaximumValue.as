
/*!
\brief
Property to access the maximum value of the slider.

\par Usage:
- Name: MaximumValue
- Format: "[float]".

\par Where:
- [float] represents the maximum value of the slider.
*/
package Flame2D.elements.slider
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class SliderPropertyMaximumValue extends FlameProperty
    {
        public function SliderPropertyMaximumValue()
        {
            super(
                "MaximumValue",
                "Property to get/set the maximum value of the slider.  Value is a float.",
                "1.000000");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameSlider).getMaxValue());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameSlider).setMaxValue(FlamePropertyHelper.stringToFloat(value));
        }

    }
}