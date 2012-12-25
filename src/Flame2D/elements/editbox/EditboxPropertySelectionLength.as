/*!
\brief
Property to access the current selection length.

\par Usage:
- Name: SelectionLength
- Format: "[uint]"

\par Where:
- [uint] is the length of the selection (as a count of the number of code points selected).
*/
package Flame2D.elements.editbox
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class EditboxPropertySelectionLength extends FlameProperty
    {
        public function EditboxPropertySelectionLength()
        {
            super(
                "SelectionLength",
                "Property to get/set the length of the selection (as a count of the number of code points selected).  Value is \"[uint]\".",
                "0");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.uintToString((receiver as FlameEditbox).getSelectionLength());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            var eb:FlameEditbox = receiver as FlameEditbox;
            var selLen:uint = FlamePropertyHelper.stringToUint(value);
            eb.setSelection(eb.getSelectionStartIndex(), eb.getSelectionStartIndex() + selLen);
        }
    }
}