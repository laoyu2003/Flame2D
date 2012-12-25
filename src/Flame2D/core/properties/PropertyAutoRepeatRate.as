/*!
\brief
Property to access window ID field.

This property offers access to the client specified ID for the window.

\par Usage:
- Name: ID
- Format: "[uint]".

\par Where:
- [uint] is any unsigned integer value.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyAutoRepeatRate extends FlameProperty
    {
        public function PropertyAutoRepeatRate()
        {
            super(
                "AutoRepeatRate",
                "Property to get/set the autorepeat rate.  Value is a floating point number indicating the rate required in seconds.",
                "0.06");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setAutoRepeatRate(FlamePropertyHelper.stringToFloat(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.floatToString(FlameWindow(win).getAutoRepeatRate());
        }
    }
}