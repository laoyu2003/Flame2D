/*!
\brief
Property to access the current selection start index.

\par Usage:
- Name: SelectionStart
- Format: "[uint]"

\par Where:
- [uint] is the zero based index of the selection start position within the text.
*/
package Flame2D.elements.editbox
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class EditboxPropertySelectionStart extends FlameProperty
    {
        public function EditboxPropertySelectionStart()
        {
            super(
                "SelectionStart",
                "Property to get/set the zero based index of the selection start position within the text.  Value is \"[uint]\".",
                "0");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.uintToString((receiver as FlameEditbox).getSelectionStartIndex());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            var eb:FlameEditbox = (receiver as FlameEditbox);
            var selStart:uint = FlamePropertyHelper.stringToUint(value);
            eb.setSelection(selStart, selStart + eb.getSelectionLength());
        }

    }
}