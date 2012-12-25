/*!
\brief
Property to access window non-client setting.

This property offers access to the "non client" setting for the window.

\par Usage:
- Name: NonClient
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate the Window is a non-client window.
- "False" to indicate the Window is not a non-client.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyNonClient extends FlameProperty
    {
        public function PropertyNonClient()
        {
            super(
                "NonClient",
                "Property to get/set the 'non-client' setting for the Window.  " +
                "Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setNonClientWindow(FlamePropertyHelper.stringToBool(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.boolToString(FlameWindow(win).isNonClientWindow());
        }
    }
}