/*!
\brief
Property to access the dragging threshold value.

\par Usage:
- Name: DragThreshold
- Format: "[float]".

\par Where:
- [float] represents the movement threshold (in pixels) which must be exceeded to commence dragging.
*/
package Flame2D.elements.dnd
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class DragContainerPropertyDragThreshold extends FlameProperty
    {
        public function DragContainerPropertyDragThreshold()
        {
            super(
                "DragThreshold",
                "Property to get/set the dragging threshold value.  Value is a float.",
                "8.000000");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameDragContainer).getPixelDragThreshold());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameDragContainer).setPixelDragThreshold(FlamePropertyHelper.stringToFloat(value));
        }
    }
}