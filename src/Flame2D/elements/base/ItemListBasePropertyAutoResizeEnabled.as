/*!
\brief
Property to access the state of the auto resize enabled setting.

\par Usage:
- Name: AutoResizeEnabled
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate that auto resizing is enabled.
- "False" to indicate that auto resizing is disabled.
*/
package Flame2D.elements.base
{
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ItemListBasePropertyAutoResizeEnabled extends FlameProperty
    {
        public function ItemListBasePropertyAutoResizeEnabled()
        {
            super(
                "AutoResizeEnabled",
                "Property to get/set the state of the auto resizing enabled setting for the ItemListBase.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameItemListBase).isAutoResizeEnabled());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameItemListBase).setAutoResizeEnabled(FlamePropertyHelper.stringToBool(value));
        }
    }
}