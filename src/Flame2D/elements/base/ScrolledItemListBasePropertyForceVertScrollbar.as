/*!
\brief
Property to access the state of the force vertical scrollbar setting.

\par Usage:
- Name: ForceVertScrollbar
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate that the vertical scrollbar should always be shown.
- "False" to indicate that the vertical scrollbar should only be shown when needed.
*/
package Flame2D.elements.base
{
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ScrolledItemListBasePropertyForceVertScrollbar extends FlameProperty
    {
        public function ScrolledItemListBasePropertyForceVertScrollbar()
        {
            super(
                "ForceVertScrollbar",
                "Property to get/set the state of the force vertical scrollbar setting for the ScrolledItemListBase.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameScrolledItemListBase).isVertScrollbarAlwaysShown());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameScrolledItemListBase).setShowVertScrollbar(FlamePropertyHelper.stringToBool(value));
        }
        
    }
}