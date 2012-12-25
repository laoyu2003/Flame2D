/*!
\brief
Property to access the state of the selected setting.

\par Usage:
- Name: Selected
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
    
    public class ItemEntryPropertySelected extends FlameProperty
    {
        public function ItemEntryPropertySelected()
        {
            super(
                "Selected",
                "Property to get/set the state of the selected setting for the ItemEntry.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameItemEntry).isSelected());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameItemEntry).setSelected(FlamePropertyHelper.stringToBool(value));
        }
    }
}