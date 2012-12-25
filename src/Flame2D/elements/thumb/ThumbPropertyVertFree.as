/*!
\brief
Property to access the state the setting to free the thumb vertically.

\par Usage:
- Name: VertFree
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate the thumb will be free (movable) vertically.
- "False" to indicate the thumb will be fixed vertically.
*/
package Flame2D.elements.thumb
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ThumbPropertyVertFree extends FlameProperty
    {
        public function ThumbPropertyVertFree()
        {
            super(
                "VertFree",
                "Property to get/set the state the setting to free the thumb vertically.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameThumb).isVertFree());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameThumb).setVertFree(FlamePropertyHelper.stringToBool(value));
        }
    }
}