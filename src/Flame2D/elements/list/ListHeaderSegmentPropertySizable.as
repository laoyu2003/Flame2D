/*!
\brief
Property to access the sizable setting of the header segment.

\par Usage:
- Name: Sizable
- Format: "[text]"

\par Where [Text] is:
- "True" to indicate the segment can be sized by the user.
- "False" to indicate the segment can not be sized by the user.
*/
package Flame2D.elements.list
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ListHeaderSegmentPropertySizable extends FlameProperty
    {
        public function ListHeaderSegmentPropertySizable()
        {
            super(
                "Sizable",
                "Property to get/set the sizable setting of the header segment.  Value is either \"True\" or \"False\".",
                "True");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameListHeaderSegment).isSizingEnabled());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameListHeaderSegment).setSizingEnabled(FlamePropertyHelper.stringToBool(value));
        }

    }
}