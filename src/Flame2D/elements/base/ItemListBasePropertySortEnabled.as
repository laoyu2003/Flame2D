
/*!
\brief
Property to access the state of the sorting enabled setting.

\par Usage:
- Name: SortEnabled
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate that sorting is enabled.
- "False" to indicate that sorting is disabled.
*/
package Flame2D.elements.base
{
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ItemListBasePropertySortEnabled extends FlameProperty
    {
        public function ItemListBasePropertySortEnabled()
        {
            super(
                "SortEnabled",
                "Property to get/set the state of the sorting enabled setting for the ItemListBase.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameItemListBase).isSortEnabled());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameItemListBase).setSortEnabled(FlamePropertyHelper.stringToBool(value));
        }
    }
}