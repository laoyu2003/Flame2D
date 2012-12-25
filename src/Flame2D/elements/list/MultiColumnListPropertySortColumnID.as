
/*!
\brief
Property to access the current sort column (via ID code).

\par Usage:
- Name: SortColumnID
- Format: "[uint]".

\par Where:
- [uint] is any unsigned integer value.
*/
package Flame2D.elements.list
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class MultiColumnListPropertySortColumnID extends FlameProperty
    {
        public function MultiColumnListPropertySortColumnID()
        {
            super(
                "SortColumnID",
                "Property to get/set the current sort column (via ID code).  Value is an unsigned integer number.",
                "0");
        }
        
        override public function getValue(receiver:*):String
        {
            const mcl:FlameMultiColumnList = receiver as FlameMultiColumnList;
            // scriptkid: this check was added to fix mantis ticket #219 (editor), but could also get called
            // from another client app. Also, the API docs state that getSortColumn requires at least one column,
            // so this check doesn't hurt.
            if (mcl.getColumnCount() > 0)
            {
                return FlamePropertyHelper.uintToString(mcl.getColumnID(mcl.getSortColumn()));
            }
            return "0"; // Return default value. For the Setting part, responsibility lies with the caller again.
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameMultiColumnList).setSortColumnByID(FlamePropertyHelper.stringToUint(value));
        }
    }
}