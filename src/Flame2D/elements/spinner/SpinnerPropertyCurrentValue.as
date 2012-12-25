/*!
\brief
Property to access the current value of the spinner.

\par Usage:
- Name: CurrentValue
- Format: "[float]".

\par Where:
- [float] represents the current value of the Spinner widget.
*/
package Flame2D.elements.spinner
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class SpinnerPropertyCurrentValue extends FlameProperty
    {
        public function SpinnerPropertyCurrentValue()
        {
            super(
                "CurrentValue",
                "Property to get/set the current value of the spinner.  Value is a float.",
                "0.000000");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameSpinner).getCurrentValue());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameSpinner).setCurrentValue(FlamePropertyHelper.stringToFloat(value));
        }
    }
}