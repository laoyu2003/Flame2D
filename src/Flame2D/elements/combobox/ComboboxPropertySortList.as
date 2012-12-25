
/*!
\brief
Property to access the sort setting of the list box.

\par Usage:
- Name: SortList
- Format: "[text]"

\par Where [Text] is:
- "True" to indicate the list items should be sorted.
- "False" to indicate the list items should not be sorted.
*/
package Flame2D.elements.combobox
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ComboboxPropertySortList extends FlameProperty
    {
        public function ComboboxPropertySortList()
        {
            super(
                "SortList",
                "Property to get/set the sort setting of the list box.  Value is either \"True\" or \"False\".",
                "False")
        }
        
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameCombobox).isSortEnabled());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameCombobox).setSortingEnabled(FlamePropertyHelper.stringToBool(value));
        }

    }
}