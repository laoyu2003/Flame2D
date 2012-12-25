/*!
\brief
Property to access the dragging alpha value.

\par Usage:
- Name: DragAlpha
- Format: "[float]".

\par Where:
- [float] represents the alpha value to set when dragging.
*/
package Flame2D.elements.dnd
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class DragContainerPropertyDragAlpha extends FlameProperty
    {
        public function DragContainerPropertyDragAlpha()
        {
            super(
                "DragAlpha",
                "Property to get/set the dragging alpha value.  Value is a float.",
                "0.500000");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameDragContainer).getDragAlpha());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameDragContainer).setDragAlpha(FlamePropertyHelper.stringToFloat(value));
        }
    }
}