/*!
\brief
Property to access window Disabled setting.

This property offers access to the enabled / disabled setting for the window.

\par Usage:
- Name: Disabled
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate the Window is disabled, and will normally receive no inputs from the user.
- "False" to indicate the Window is not disabled and will receive inputs from the user as normal.
*/
package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyDisabled extends FlameProperty
    {
        public function PropertyDisabled()
        {
            super(
                "Disabled",
                "Property to get/set the 'disabled state' setting for the Window.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setEnabled(! FlamePropertyHelper.stringToBool(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.boolToString(FlameWindow(win).isDisabled());
        }
        
        override public function isDefault(win:*):Boolean
        {
            return ! FlameWindow(win).isDisabled(true)
        }
    }
}