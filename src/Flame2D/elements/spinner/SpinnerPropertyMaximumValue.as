/*!
\brief
Property to access the maximum value setting of the spinner.

\par Usage:
- Name: MaximumValue
- Format: "[float]".

\par Where:
- [float] represents the current maximum value of the Spinner widget.
*/
package Flame2D.elements.spinner
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class SpinnerPropertyMaximumValue extends FlameProperty
    {
        public function SpinnerPropertyMaximumValue()
        {
            super(
                "MaximumValue",
                "Property to get/set the maximum value setting of the spinner.  Value is a float.",
                "32767.000000");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameSpinner).getMaximumValue());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameSpinner).setMaximumValue(FlamePropertyHelper.stringToFloat(value));
        }
    }
}