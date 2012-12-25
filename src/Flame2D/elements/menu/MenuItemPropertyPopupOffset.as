/*!
\brief
Property to specify an offset for the popup menu position.

\par Usage:
- Name: PopupOffset
- Format: "{{[xs],[xo]},{[ys],[yo]}}"

\par Where:
- [xs] is a floating point value describing the relative scale
value for the offset x-coordinate.
- [xo] is a floating point value describing the absolute offset
value for the offset x-coordinate.
- [ys] is a floating point value describing the relative scale
value for the offset y-coordinate.
- [yo] is a floating point value describing the absolute offset
value for the offset y-coordinate.
*/
package Flame2D.elements.menu
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class MenuItemPropertyPopupOffset extends FlameProperty
    {
        public function MenuItemPropertyPopupOffset()
        {
            super(
                "PopupOffset",
                "Property to specify an offset for the popup menu position. Value is a UVector2 property value.",
                "{{0,0},{0,0}}");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.uvector2ToString((receiver as FlameMenuItem).getPopupOffset());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameMenuItem).setPopupOffset(FlamePropertyHelper.stringToUVector2(value));
        }

    }
}