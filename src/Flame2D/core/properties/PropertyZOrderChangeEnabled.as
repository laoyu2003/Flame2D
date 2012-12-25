
/*!
\brief
Property to access window Z-Order changing enabled setting.

This property offers access to the setting that controls whether z-order changes are enabled for the window.

\par Usage:
- Name: ZOrderChangeEnabled
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate the Window should respect requests to change z-order.
- "False" to indicate the Window should not change it's z-order.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyZOrderChangeEnabled extends FlameProperty
    {
        public function PropertyZOrderChangeEnabled()
        {
            super(
                "ZOrderChangeEnabled",
                "Property to get/set the 'z-order changing enabled' setting for the Window.  Value is either \"True\" or \"False\".",
                "True");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setZOrderingEnabled(FlamePropertyHelper.stringToBool(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.boolToString(FlameWindow(win).isZOrderingEnabled());
        }
    }
}