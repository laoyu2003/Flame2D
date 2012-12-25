/*!
\brief
Property to access the setting for user sizing of the column headers.

\par Usage:
- Name: ColumnsSizable
- Format: "[text]"

\par Where [Text] is:
- "True" to indicate the column headers can be sized by the user.
- "False" to indicate the column headers can not be sized by the user.
*/
package Flame2D.elements.list
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ListHeaderPropertyColumnsSizable extends FlameProperty
    {
        public function ListHeaderPropertyColumnsSizable()
        {
            super(
                "ColumnsSizable",
                "Property to get/set the setting for user sizing of the column headers.  Value is either \"True\" or \"False\".",
                "True");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameListHeader).isColumnSizingEnabled());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameListHeader).setColumnSizingEnabled(FlamePropertyHelper.stringToBool(value));
        }
    }
}