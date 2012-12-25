
/*!
\brief
Property to access the click-step size for the slider.

\par Usage:
- Name: ClickStepSize
- Format: "[float]".

\par Where:
- [float] represents the click-step size slider (this is how much the value changes when the slider container is clicked).
*/
package Flame2D.elements.slider
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class SliderPropertyClickStepSize extends FlameProperty
    {
        public function SliderPropertyClickStepSize()
        {
            super(
                "ClickStepSize",
                "Property to get/set the click-step size for the slider.  Value is a float.",
                "0.010000");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameSlider).getClickStep());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameSlider).setClickStep(FlamePropertyHelper.stringToFloat(value));
        }
    }
}