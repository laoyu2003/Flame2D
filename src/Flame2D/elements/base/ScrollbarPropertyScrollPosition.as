/*!
\brief
Property to access the scroll position of the Scrollbar.

\par Usage:
- Name: ScrollPosition
- Format: "[float]".

\par Where:
- [float] specifies the current scroll position / value of the Scrollbar.
*/
package Flame2D.elements.base
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ScrollbarPropertyScrollPosition extends FlameProperty
    {
        public function ScrollbarPropertyScrollPosition()
        {
            super(
                "ScrollPosition",
                "Property to get/set the scroll position of the Scrollbar.  Value is a float.",
                "0.000000");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameScrollbar).getScrollPosition());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameScrollbar).setScrollPosition(FlamePropertyHelper.stringToFloat(value));
        }
    }
}