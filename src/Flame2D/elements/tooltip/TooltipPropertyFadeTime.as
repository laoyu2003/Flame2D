/*!
\brief
Property to access the duration of the fade effect for the tooltip.

\par Usage:
- Name: FadeTime
- Format: "[float]".

\par Where:
- [float] specifies the number of seconds over which the fade in / fade out effect will happen.
*/
package Flame2D.elements.tooltip
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class TooltipPropertyFadeTime extends FlameProperty
    {
        public function TooltipPropertyFadeTime()
        {
            super(
                "FadeTime",
                "Property to get/set duration of the fade effect in seconds.  Value is a float.",
                "0.330000");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameTooltip).getFadeTime());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameTooltip).setFadeTime(FlamePropertyHelper.stringToFloat(value));
        }
    }
}