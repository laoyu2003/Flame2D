
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
    
    public class MultiLineEditboxPropertySelectionStart extends FlameProperty
    {
        public function MultiLineEditboxPropertySelectionStart()
        {
            super(
                "SelectionStart",
                "Property to get/set the zero based index of the selection start position within the text.  Value is \"[uint]\".",
                "0");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.uintToString((receiver as FlameMultiLineEditbox).getSelectionStartIndex());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            var eb:FlameMultiLineEditbox = receiver as FlameMultiLineEditbox;
            var selStart:uint = FlamePropertyHelper.stringToUint(value);
            eb.setSelection(selStart, selStart + eb.getSelectionLength());
        }
    }
}