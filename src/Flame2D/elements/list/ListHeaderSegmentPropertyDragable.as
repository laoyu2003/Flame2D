/*!
\brief
Property to access the drag-able setting of the header segment.

\par Usage:
- Name: Dragable
- Format: "[text]"

\par Where [Text] is:
- "True" to indicate the segment can be dragged by the user.
- "False" to indicate the segment can not be dragged by the user.
*/
package Flame2D.elements.list
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ListHeaderSegmentPropertyDragable extends FlameProperty
    {
        public function ListHeaderSegmentPropertyDragable()
        {
            super(
                "Dragable",
                "Property to get/set the drag-able setting of the header segment.  Value is either \"True\" or \"False\".",
                "True");
        }
        
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameListHeaderSegment).isDragMovingEnabled());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameListHeaderSegment).setDragMovingEnabled(FlamePropertyHelper.stringToBool(value));
        }
    }
}