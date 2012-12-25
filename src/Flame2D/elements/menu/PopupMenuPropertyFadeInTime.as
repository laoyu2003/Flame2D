/*!
\brief
Property to access the fade in time in seconds of the popup menu.

\par Usage:
- Name: FadeInTime
- Format: "[float]".

\par Where:
- [float] represents the fade in time in seconds of the popup menu.
*/
package Flame2D.elements.menu
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class PopupMenuPropertyFadeInTime extends FlameProperty
    {
        public function PopupMenuPropertyFadeInTime()
        {
            super(
                "FadeInTime",
                "Property to get/set the fade in time in seconds of the popup menu.  Value is a float.",
                "0.000000");
        }
        
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlamePopupMenu).getFadeInTime());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlamePopupMenu).setFadeInTime(FlamePropertyHelper.stringToFloat(value));
        }

    }
}