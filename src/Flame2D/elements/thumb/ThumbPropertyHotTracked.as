/*!
\brief
Property to access the state of the "hot-tracked" setting for the thumb.

\par Usage:
- Name: HotTracked
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate the thumb will send notifications as it is dragged.
- "False" to indicate the thumb will only notify once, when it is released.
*/
package Flame2D.elements.thumb
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ThumbPropertyHotTracked extends FlameProperty
    {
        public function ThumbPropertyHotTracked()
        {
            super(
                "HotTracked",
                "Property to get/set the state of the state of the 'hot-tracked' setting for the thumb.  Value is either \"True\" or \"False\".",
                "True");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameThumb).isHotTracked());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameThumb).setHotTracked(FlamePropertyHelper.stringToBool(value));
        }
    }
}