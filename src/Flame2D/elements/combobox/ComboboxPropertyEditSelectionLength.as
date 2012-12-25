
/*!
\brief
Property to access the current selection length.

\par Usage:
- Name: EditSelectionLength
- Format: "[uint]"

\par Where:
- [uint] is the length of the selection (as a count of the number of code points selected).
*/
package Flame2D.elements.combobox
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ComboboxPropertyEditSelectionLength extends FlameProperty
    {
        public function ComboboxPropertyEditSelectionLength()
        {
            super(
                "EditSelectionLength",
                "Property to get/set the length of the selection (as a count of the number of code points selected).  Value is \"[uint]\".",
                "0");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.uintToString((receiver as FlameCombobox).getSelectionLength());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            var eb:FlameCombobox = receiver as FlameCombobox;
            var selLen:uint = FlamePropertyHelper.stringToUint(value);
            eb.setSelection(eb.getSelectionStartIndex(), eb.getSelectionStartIndex() + selLen);
        }
        

    }
}