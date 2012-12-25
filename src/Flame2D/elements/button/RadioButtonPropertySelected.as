/*!
\brief
Property to access the selected state of the RadioButton.

\par Usage:
- Name: Selected
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate the radio button is selected.
- "False" to indicate the radio button is not selected.
*/
package Flame2D.elements.button
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class RadioButtonPropertySelected extends FlameProperty
    {
        public function RadioButtonPropertySelected()
        {
            super(
                "Selected",
                "Property to get/set the selected state of the RadioButton.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameRadioButton).isSelected());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameRadioButton).setSelected(FlamePropertyHelper.stringToBool(value));
        }

    }
}