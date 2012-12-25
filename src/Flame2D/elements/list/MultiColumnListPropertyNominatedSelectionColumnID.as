/*!
\brief
Property to access the nominated selection column (via ID).

\par Usage:
- Name: NominatedSelectionColumnID
- Format: "[uint]".

\par Where:
- [uint] is any unsigned integer value representing the ID code of the column to be used.
*/
package Flame2D.elements.list
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class MultiColumnListPropertyNominatedSelectionColumnID extends FlameProperty
    {
        public function MultiColumnListPropertyNominatedSelectionColumnID()
        {
            super(
                "NominatedSelectionColumnID",
                "Property to get/set the nominated selection column (via ID).  Value is an unsigned integer number.",
                "0");
        }
        
        override public function getValue(receiver:*):String
        {
            const mcl:FlameMultiColumnList = receiver as FlameMultiColumnList;
            if (mcl.getColumnCount() > 0)
            {
                return FlamePropertyHelper.uintToString(mcl.getNominatedSelectionColumnID());
            }
            return "0"; // Return default value. For the Setting part, responsibility lies with the caller again.
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameMultiColumnList).setNominatedSelectionColumn(FlamePropertyHelper.stringToUint(value));
        }

    }
}