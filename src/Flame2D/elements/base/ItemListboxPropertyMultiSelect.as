/*!
\brief
Property to access the state of the multiselect enabled setting.

\par Usage:
- Name: MultiSelect
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate that multiselect is enabled.
- "False" to indicate that multiselect is disabled.
*/
package Flame2D.elements.base
{
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ItemListboxPropertyMultiSelect extends FlameProperty
    {
        public function ItemListboxPropertyMultiSelect()
        {
            super(
                "MultiSelect",
                "Property to get/set the state of the multiselect enabled setting for the ItemListbox.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameItemListbox).isMultiSelectEnabled());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameItemListbox).setMultiSelectEnabled(FlamePropertyHelper.stringToBool(value));
        }
    }
}