/*!
\brief
Property to specify the time, which has to elapse before the popup window is opened/closed if the hovering state changes

\par Usage:
- Name: AutoPopupTimeout
- Format: "[Float]"

\par Where [Float] is:
- wait time in seconds
- set to 0.0f if you want no automatic popups
*/
package Flame2D.elements.menu
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class MenuItemPropertyAutoPopupTimeout extends FlameProperty
    {
        public function MenuItemPropertyAutoPopupTimeout()
        {
            super(
                "AutoPopupTimeout",
                "Property to specify the time, which has to elapse before the popup window is opened/closed if the hovering state changes. Value is a float property value.",
                "0.0");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameMenuItem).getAutoPopupTimeout());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameMenuItem).setAutoPopupTimeout(FlamePropertyHelper.stringToFloat(value));
        }
    }
}