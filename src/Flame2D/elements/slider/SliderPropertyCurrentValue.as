/*!
\brief
Property to access the current value of the slider.

\par Usage:
- Name: CurrentValue
- Format: "[float]".

\par Where:
- [float] represents the current value of the slider.
*/
package Flame2D.elements.slider
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class SliderPropertyCurrentValue extends FlameProperty
    {
        public function SliderPropertyCurrentValue()
        {
            super(
                "CurrentValue",
                "Property to get/set the current value of the slider.  Value is a float.",
                "0.000000");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameSlider).getCurrentValue());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameSlider).setCurrentValue(FlamePropertyHelper.stringToFloat(value));
        }
    }
}