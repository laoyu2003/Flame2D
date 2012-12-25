/*!
\brief
Property to access the current selection start index.

\par Usage:
- Name: EditSelectionStart
- Format: "[uint]"

\par Where:
- [uint] is the zero based index of the selection start position within the text.
*/
package Flame2D.elements.combobox
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ComboboxPropertyEditSelectionStart extends FlameProperty
    {
        public function ComboboxPropertyEditSelectionStart()
        {
            super(
                "EditSelectionStart",
                "Property to get/set the zero based index of the selection start position within the text.  Value is \"[uint]\".",
                "0");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.uintToString((receiver as FlameCombobox).getSelectionStartIndex());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            var eb:FlameCombobox = receiver as FlameCombobox;
            var selStart:uint = FlamePropertyHelper.stringToUint(value);
            eb.setSelection(selStart, selStart + eb.getSelectionLength());
        }
        
        
    }
}