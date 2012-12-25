/*!
\brief
Property to access the step size of the spinner.

\par Usage:
- Name: StepSize
- Format: "[float]".

\par Where:
- [float] represents the current value of the Spinner widget.
*/
package Flame2D.elements.spinner
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class SpinnerPropertyStepSize extends FlameProperty
    {
        public function SpinnerPropertyStepSize()
        {
            super(
                "StepSize",
                "Property to get/set the step size of the spinner.  Value is a float.",
                "1.000000");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameSpinner).getStepSize());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameSpinner).setStepSize(FlamePropertyHelper.stringToFloat(value));
        }
    }
}