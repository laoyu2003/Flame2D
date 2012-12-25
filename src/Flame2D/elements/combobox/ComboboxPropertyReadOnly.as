/*!
\brief
Property to access the read-only setting of the edit box.

\par Usage:
- Name: ReadOnly
- Format: "[text]"

\par Where [Text] is:
- "True" to indicate the edit box is read-only.
- "False" to indicate the edit box is not read-only (text may be edited by user).
*/
package Flame2D.elements.combobox
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ComboboxPropertyReadOnly extends FlameProperty
    {
        public function ComboboxPropertyReadOnly()
        {
            super(
                "ReadOnly",
                "Property to get/set the read-only setting for the Editbox.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameCombobox).isReadOnly());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameCombobox).setReadOnly(FlamePropertyHelper.stringToBool(value));
        }

    }
    
    
    
    
}