/*!
\brief
Property to access the item spacing of the menu.

\par Usage:
- Name: ItemSpacing
- Format: "[float]".

\par Where:
- [float] represents the item spacing of the menu.
*/
package Flame2D.elements.menu
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class MenuBasePropertyItemSpacing extends FlameProperty
    {
        public function MenuBasePropertyItemSpacing()
        {
            super(
                "ItemSpacing",
                "Property to get/set the item spacing of the menu.  Value is a float.",
                "10.000000");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameMenuBase).getItemSpacing());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameMenuBase).setItemSpacing(FlamePropertyHelper.stringToFloat(value));
        }

    }
}