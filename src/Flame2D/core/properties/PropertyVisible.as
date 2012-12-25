
/*!
\brief
Property to access window Visible setting.

This property offers access to the visible setting for the window.

\par Usage:
- Name: Visible
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate the Window is visible.
- "False" to indicate the Window is not visible.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyVisible extends FlameProperty
    {
        public function PropertyVisible()
        {
            super(
                "Visible",
                "Property to get/set the 'visible state' setting for the Window.  Value is either \"True\" or \"False\".",
                "True");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setVisible(FlamePropertyHelper.stringToBool(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.boolToString(FlameWindow(win).isVisible());
        }
        
        override public function isDefault(win:*):Boolean
        {
            return win.isVisible(true);
        }
    }
}