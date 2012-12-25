/*!
\brief
Property to access the minimum value setting of the spinner.

\par Usage:
- Name: MinimumValue
- Format: "[float]".

\par Where:
- [float] represents the current minimum value of the Spinner widget.
*/
package Flame2D.elements.spinner
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class SpinnerPropertyMinimumValue extends FlameProperty
    {
        public function SpinnerPropertyMinimumValue()
        {
            super(
                "MinimumValue",
                "Property to get/set the minimum value setting of the spinner.  Value is a float.",
                "-32768.000000");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameSpinner).getMinimumValue());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameSpinner).setMinimumValue(FlamePropertyHelper.stringToFloat(value));
        }
    }
}