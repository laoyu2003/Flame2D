/*!
\brief
Property to access window "Always-On-Top" setting.

This property offers access to the always on top / topmost setting for the window.

\par Usage:
- Name: AlwaysOnTop
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate the Window is always on top, and appears above all other non-always on top Windows.
- "False" to indicate the Window is not always on top, and will appear below all other always on top Windows.
*/
package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyAlwaysOnTop extends FlameProperty
    {
        public function PropertyAlwaysOnTop()
        {
            super(
                "AlwaysOnTop",
                "Property to get/set the 'always on top' setting for the Window.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function setValue(win:*, value:String):void
        {
            super.setValue(win, value);
            FlameWindow(win).setAlwaysOnTop(FlamePropertyHelper.stringToBool(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.boolToString(FlameWindow(win).isAlwaysOnTop());
        }
    }
}