/*!
\brief
Property to access whether the window ignores mouse events and pass them through to any windows behind it.

\par Usage:
- Name: MousePassThroughEnabled
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate the Window will not respond to mouse events but pass them directly to any children behind it.
- "False" to indicate the Window will respond to normally to all mouse events (Default).
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyMousePassThroughEnabled extends FlameProperty
    {
        public function PropertyMousePassThroughEnabled()
        {
            super(
                "MousePassThroughEnabled",
                "Property to get/set whether the window ignores mouse events and pass them through to any windows behind it. Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setMousePassThroughEnabled(FlamePropertyHelper.stringToBool(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.boolToString(FlameWindow(win).isMousePassThroughEnabled());
        }
    }
}