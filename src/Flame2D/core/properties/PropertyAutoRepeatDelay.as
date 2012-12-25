/*!
\brief
Property to access window autorepeat delay value.

This property offers access to the value that controls the initial delay for autorepeat mouse button down events.

\par Usage:
- Name: AutoRepeatDelay
- Format: "[float]".

\par Where:
- [float]   specifies the delay in seconds.
*/
package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyAutoRepeatDelay extends FlameProperty
    {
        public function PropertyAutoRepeatDelay()
        {
            super(
                "AutoRepeatDelay",
                "Property to get/set the autorepeat delay.  Value is a floating point number indicating the delay required in seconds.",
                "0.3");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setAutoRepeatDelay(FlamePropertyHelper.stringToFloat(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.floatToString(FlameWindow(win).getAutoRepeatDelay());
        }
    }
}