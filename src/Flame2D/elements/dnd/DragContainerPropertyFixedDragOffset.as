/*!
\brief
Property to access the state of the fixed dragging offset setting.

\par Usage:
- Name: FixedDragOffset
- Format: "{{[xs],[xo]},{[ys],[yo]}}"

\par Where:
- [xs] is a floating point value describing the relative scale
value for the position x-coordinate.
- [xo] is a floating point value describing the absolute offset
value for the position x-coordinate.
- [ys] is a floating point value describing the relative scale
value for the position y-coordinate.
- [yo] is a floating point value describing the absolute offset
value for the position y-coordinate.
*/
package Flame2D.elements.dnd
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class DragContainerPropertyFixedDragOffset extends FlameProperty
    {
        public function DragContainerPropertyFixedDragOffset()
        {
            super(
                "FixedDragOffset",
                "Property to get/set the state of the fixed dragging offset " +
                "setting for the DragContainer.  " +
                "Value is a UVector2 property value.",
                "{{0,0},{0,0}}");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.uvector2ToString(
                (receiver as FlameDragContainer).getFixedDragOffset());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameDragContainer).
                setFixedDragOffset(FlamePropertyHelper.stringToUVector2(value));
        }
    }
}