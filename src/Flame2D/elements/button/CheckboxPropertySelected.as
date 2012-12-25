/*!
\brief
Property to access the selected state of the check box.

This property offers access to the select state for the Checkbox object.

\par Usage:
- Name: Selected
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate the check box is selected (has check mark).
- "False" to indicate the check box is not selected (does not have check mark).
*/
package Flame2D.elements.button
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class CheckboxPropertySelected extends FlameProperty
    {
        public function CheckboxPropertySelected()
        {
            super(
                "Selected",
                "Property to get/set the selected state of the Checkbox.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameCheckbox).isSelected());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameCheckbox).setSelected(FlamePropertyHelper.stringToBool(value));
        }
    }
}