
/*!
\brief
Property to access the string used for regular expression validation of the edit box text.

\par Usage:
- Name: ValidationString
- Format: "[text]"

\par Where:
- [Text] is the string used for validating text entry.
*/
package Flame2D.elements.editbox
{
    import Flame2D.core.properties.FlameProperty;
    
    public class EditboxPropertyValidationString extends FlameProperty
    {
        public function EditboxPropertyValidationString()
        {
            super(
                "ValidationString",
                "Property to get/set the validation string Editbox.  Value is a text string.",
                ".*");
        }
        
        
        override public function getValue(receiver:*):String
        {
            return (receiver as FlameEditbox).getValidationString();
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameEditbox).setValidationString(value);
        }
    }
}