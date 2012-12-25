
/*!
\brief
Property to access the nominated selection row.

\par Usage:
- Name: NominatedSelectionRow
- Format: "[uint]".

\par Where:
- [uint] is any unsigned integer value representing the index of the row to be used.
*/
package Flame2D.elements.list
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class MultiColumnListPropertyNominatedSelectionRow extends FlameProperty
    {
        public function MultiColumnListPropertyNominatedSelectionRow()
        {
            super(
                "NominatedSelectionRow",
                "Property to get/set the nominated selection row.  Value is an unsigned integer number.",
                "0");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.uintToString((receiver as FlameMultiColumnList).getNominatedSelectionRow());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameMultiColumnList).setNominatedSelectionRow(FlamePropertyHelper.stringToUint(value));
        }
    }
}