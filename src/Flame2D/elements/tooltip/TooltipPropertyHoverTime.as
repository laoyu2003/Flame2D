/*!
\brief
Property to access the timout that must expire before the tooltip gets activated.

\par Usage:
- Name: HoverTime
- Format: "[float]".

\par Where:
- [float] specifies the number of seconds the mouse must hover stationary on a widget before the tooltip gets activated.
*/
package Flame2D.elements.tooltip
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class TooltipPropertyHoverTime extends FlameProperty
    {
        public function TooltipPropertyHoverTime()
        {
            super(
                "HoverTime",
                "Property to get/set the hover timeout value in seconds.  Value is a float.",
                "0.400000");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameTooltip).getHoverTime());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameTooltip).setHoverTime(FlamePropertyHelper.stringToFloat(value));
        }
    }
}