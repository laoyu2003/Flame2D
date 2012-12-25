/*!
\brief
Property to access the read-only setting of the edit box.

This property offers access to the read-only setting for the Editbox object.

\par Usage:
- Name: ReadOnly
- Format: "[text]"

\par Where [Text] is:
- "True" to indicate the edit box is read-only.
- "False" to indicate the edit box is not read-only (text may be edited by user).
*/
package Flame2D.elements.editbox
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class EditboxPropertyReadOnly extends FlameProperty
    {
        public function EditboxPropertyReadOnly()
        {
            super(
                "ReadOnly",
                "Property to get/set the read-only setting for the Editbox.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameEditbox).isReadOnly());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameEditbox).setReadOnly(FlamePropertyHelper.stringToBool(value));
        }

    }
}