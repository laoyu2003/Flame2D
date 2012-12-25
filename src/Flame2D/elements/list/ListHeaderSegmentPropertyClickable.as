/*!
\brief
Property to access the click-able setting of the header segment.

\par Usage:
- Name: Clickable
- Format: "[text]"

\par Where [Text] is:
- "True" to indicate the segment can be clicked by the user.
- "False" to indicate the segment can not be clicked by the user.
*/
package Flame2D.elements.list
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ListHeaderSegmentPropertyClickable extends FlameProperty
    {
        public function ListHeaderSegmentPropertyClickable()
        {
            super(
                "Clickable",
                "Property to get/set the click-able setting of the header segment.  Value is either \"True\" or \"False\".",
                "True");
        }
        
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameListHeaderSegment).isClickable());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameListHeaderSegment).setClickable(FlamePropertyHelper.stringToBool(value));
        }
    }
}