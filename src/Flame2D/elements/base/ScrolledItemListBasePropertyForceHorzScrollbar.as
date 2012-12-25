/*!
\brief
Property to access the state of the force horizontal scrollbar setting.

\par Usage:
- Name: ForceHorzScrollbar
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate that the horizontal scrollbar should always be shown.
- "False" to indicate that the horizontal scrollbar should only be shown when needed.
*/
package Flame2D.elements.base
{
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ScrolledItemListBasePropertyForceHorzScrollbar extends FlameProperty
    {
        public function ScrolledItemListBasePropertyForceHorzScrollbar()
        {
            super(
                "ForceHorzScrollbar",
                "Property to get/set the state of the force horizontal scrollbar setting for the ScrolledItemListBase.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameScrolledItemListBase).isHorzScrollbarAlwaysShown());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameScrolledItemListBase).setShowHorzScrollbar(FlamePropertyHelper.stringToBool(value));
        }
    }
}