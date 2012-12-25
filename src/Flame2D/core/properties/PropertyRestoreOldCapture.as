/*!
\brief
Property to access window Restore Old Capture setting.

This property offers access to the restore old capture setting for the window.  This setting is of generally limited use, it
is primary purpose is for certain operations required for compound widgets.

\par Usage:
- Name: RestoreOldCapture
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate the Window should restore any previous capture Window when it loses input capture.
- "False" to indicate the Window should not restore the old capture Window.  This is the default behaviour.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyRestoreOldCapture extends FlameProperty
    {
        public function PropertyRestoreOldCapture()
        {
            super(
                "RestoreOldCapture",
                "Property to get/set the 'restore old capture' setting for the Window.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setRestoreCapture(FlamePropertyHelper.stringToBool(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.boolToString(FlameWindow(win).restoresOldCapture());
        }
    }
}