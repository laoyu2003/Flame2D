/*!
\brief
Property to access the show item tooltips setting of the list box.

\par Usage:
- Name: ItemTooltips
- Format: "[text]"

\par Where [Text] is:
- "True" to indicate that the tooltip of the list box will be set by the item below the mouse pointer
- "False" to indicate that the list box has a static tooltip.
*/
package Flame2D.elements.listbox
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ListboxPropertyItemTooltips extends FlameProperty
    {
        public function ListboxPropertyItemTooltips()
        {
            super(
                "ItemTooltips",
                "Property to access the show item tooltips setting of the list box.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameListbox).isItemTooltipsEnabled());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameListbox).setItemTooltipsEnabled(FlamePropertyHelper.stringToBool(value));
        }
    }
}