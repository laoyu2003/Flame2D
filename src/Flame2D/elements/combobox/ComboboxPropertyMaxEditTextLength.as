
/*!
\brief
Property to access the maximum text length for the edit box.

\par Usage:
- Name: MaxEditTextLength
- Format: "[uint]"

\par Where:
- [uint] is the maximum allowed text length (as a count of code points).
*/
package Flame2D.elements.combobox
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ComboboxPropertyMaxEditTextLength extends FlameProperty
    {
        public function ComboboxPropertyMaxEditTextLength()
        {
            super(
                "MaxEditTextLength",
                "Property to get/set the the maximum allowed text length (as a count of code points).  Value is \"[uint]\".",
                "1073741824");
        }
        
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.uintToString((receiver as FlameCombobox).getMaxTextLength());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameCombobox).setMaxTextLength(FlamePropertyHelper.stringToUint(value));
        }

    }
}