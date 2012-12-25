/*!
\brief
Property to access the state the setting to free the thumb horizontally.

\par Usage:
- Name: HorzFree
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate the thumb will be free (movable) horizontally.
- "False" to indicate the thumb will be fixed horizontally.
*/
package Flame2D.elements.thumb
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ThumbPropertyHorzFree extends FlameProperty
    {
        public function ThumbPropertyHorzFree()
        {
            super(
                "HorzFree", 
                "Property to get/set the state the setting to free the thumb horizontally.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameThumb).isHorzFree());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameThumb).setHorzFree(FlamePropertyHelper.stringToBool(value));
        }
    }
}