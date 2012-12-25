/*!
\brief
Property to access the time after which the tooltip automatically de-activates itself.

\par Usage:
- Name: DisplayTime
- Format: "[float]".

\par Where:
- [float] specifies the number of seconds after which the tooltip will deactivate itself if the mouse has remained stationary.
*/
package Flame2D.elements.tooltip
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class TooltipPropertyDisplayTime extends FlameProperty
    {
        public function TooltipPropertyDisplayTime()
        {
            super(
                "DisplayTime",
                "Property to get/set the display timeout value in seconds.  Value is a float.",
                "7.500000");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameTooltip).getDisplayTime());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameTooltip).setDisplayTime(FlamePropertyHelper.stringToFloat(value));
        }
    }
}