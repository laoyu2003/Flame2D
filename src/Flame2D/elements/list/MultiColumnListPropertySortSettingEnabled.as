/*!
\brief
Property to access the setting for user modification of the sort column & direction.

\par Usage:
- Name: SortSettingEnabled
- Format: "[text]"

\par Where [Text] is:
- "True" to indicate the user may modify the sort column and direction by clicking the header segments.
- "False" to indicate the user may not modify the sort column or direction.
*/
package Flame2D.elements.list
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class MultiColumnListPropertySortSettingEnabled extends FlameProperty
    {
        public function MultiColumnListPropertySortSettingEnabled()
        {
            super(
                "SortSettingEnabled",
                "Property to get/set the setting for for user modification of the sort column & direction.  Value is either \"True\" or \"False\".",
                "True");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameMultiColumnList).isUserSortControlEnabled());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameMultiColumnList).setUserSortControlEnabled(FlamePropertyHelper.stringToBool(value));
        }
    }
}