
/*!
\brief
Property to access the number of rows in the list (read-only)

\par Usage:
- Name: RowCount
- Format: "" (property is read-only).
*/
package Flame2D.elements.list
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class MultiColumnListPropertyRowCount extends FlameProperty
    {
        public function MultiColumnListPropertyRowCount()
        {
            super(
                "RowCount",
                "Property to access the number of rows in the list (read only)",
                "");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.uintToString((receiver as FlameMultiColumnList).getRowCount());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            // property is read only.
            trace(
                "Attempt to set read only property 'RowCount' on MultiColumnListbox '" + 
                (receiver as FlameMultiColumnList).getName() + "'.");
        }

    }
}