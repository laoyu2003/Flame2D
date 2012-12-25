
/*!
\brief
Property to access the string used for regular expression validation of the edit box text.

\par Usage:
- Name: ValidationString
- Format: "[text]"

\par Where:
- [Text] is the string used for validating text entry.
*/
package Flame2D.elements.combobox
{
    import Flame2D.core.properties.FlameProperty;
    
    public class ComboboxPropertyValidationString extends FlameProperty
    {
        public function ComboboxPropertyValidationString()
        {
            super(
                "ValidationString",
                "Property to get/set the validation string Editbox.  Value is a text string.",
                ".*");
        }
        
        
        override public function getValue(receiver:*) :String
        {
            return (receiver as FlameCombobox).getValidationString();
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameCombobox).setValidationString(value);
        }
    }
}