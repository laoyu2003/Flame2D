/*!
\brief
Property to access the fade out time in seconds of the popup menu.

\par Usage:
- Name: FadeOutTime
- Format: "[float]".

\par Where:
- [float] represents the fade out time in seconds of the popup menu.
*/
package Flame2D.elements.menu
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class PopupMenuPropertyFadeOutTime extends FlameProperty
    {
        public function PopupMenuPropertyFadeOutTime()
        {
            super(
                "FadeOutTime",
                "Property to get/set the fade out time in seconds of the popup menu.  Value is a float.",
                "0.000000");
        }
        
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlamePopupMenu).getFadeOutTime());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlamePopupMenu).setFadeOutTime(FlamePropertyHelper.stringToFloat(value));
        }
    }
}