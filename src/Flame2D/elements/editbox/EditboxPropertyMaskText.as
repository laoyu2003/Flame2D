/*!
\brief
Property to access the mask text setting of the edit box.

This property offers access to the mask text setting for the Editbox object.

\par Usage:
- Name: MaskText
- Format: "[text]"

\par Where [Text] is:
- "True" to indicate the text should be masked.
- "False" to indicate the text should not be masked.
*/
package Flame2D.elements.editbox
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class EditboxPropertyMaskText extends FlameProperty
    {
        public function EditboxPropertyMaskText()
        {
            super(
                "MaskText",
                "Property to get/set the mask text setting for the Editbox.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameEditbox).isTextMasked());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameEditbox).setTextMasked(FlamePropertyHelper.stringToBool(value));
        }
    }
}