/*!
\brief
Property to access the state of the selectable setting.

\par Usage:
- Name: Selectable
- Format: "[text]".

\par Where [text] is:
- "True" to indicate that the item is selectable.
- "False" to indicate that the item is not selectable.
*/
package Flame2D.elements.base
{
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ItemEntryPropertySelectable extends FlameProperty
    {
        public function ItemEntryPropertySelectable()
        {
            super(
                "Selectable",
                "Property to get/set the state of the selectable setting for the ItemEntry.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameItemEntry).isSelectable());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameItemEntry).setSelectable(FlamePropertyHelper.stringToBool(value));
        }

    }
}