/*!
\brief
Property to access the multi-select setting of the list box.

\par Usage:
- Name: MultiSelect
- Format: "[text]"

\par Where [Text] is:
- "True" to indicate that multiple items may be selected.
- "False" to indicate that only a single item may be selected.
*/
package Flame2D.elements.listbox
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ListboxPropertyMultiSelect extends FlameProperty
    {
        public function ListboxPropertyMultiSelect()
        {
            super(
                "MultiSelect",
                "Property to get/set the multi-select setting of the list box.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameListbox).isMultiselectEnabled());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameListbox).setMultiselectEnabled(FlamePropertyHelper.stringToBool(value));
        }
    }
}