
/*!
\brief
Property to control whether the window will receive autorepeat mouse button down events.

This property offers access to the setting that controls whether a window will receive autorepeat
mouse button down events.

\par Usage:
- Name: MouseButtonDownAutoRepeat
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate the Window will receive autorepeat mouse button down events.
- "False" to indicate the Window will not receive autorepeat mouse button down events.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyMouseButtonDownAutoRepeat extends FlameProperty
    {
        public function PropertyMouseButtonDownAutoRepeat()
        {
            super(
                "MouseButtonDownAutoRepeat",
                "Property to get/set whether the window will receive autorepeat mouse button down events.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setMouseAutoRepeatEnabled(FlamePropertyHelper.stringToBool(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.boolToString(FlameWindow(win).isMouseAutoRepeatEnabled());
        }
    }
}