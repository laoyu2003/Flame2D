/*!
\brief
Property to access the sort setting of the list box.

\par Usage:
- Name: Sort
- Format: "[text]"

\par Where [Text] is:
- "True" to indicate the list items should be sorted.
- "False" to indicate the list items should not be sorted.
*/
package Flame2D.elements.listbox
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ListboxPropertySort extends FlameProperty
    {
        public function ListboxPropertySort()
        {
            super(
                "Sort",
                "Property to get/set the sort setting of the list box.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameListbox).isSortEnabled());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameListbox).setSortingEnabled(FlamePropertyHelper.stringToBool(value));
        }

    }
}