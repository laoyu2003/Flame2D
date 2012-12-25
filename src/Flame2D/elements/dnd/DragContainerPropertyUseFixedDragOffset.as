/*!
\brief
Property to access the setting that controls whether the fixed drag
offset will be used.

\par Usage:
- Name: UseFixedDragOffset
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate that the fixed dragging offset will be used.
- "False" to indicate that the fixed dragging offset will not be
used.
*/
package Flame2D.elements.dnd
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class DragContainerPropertyUseFixedDragOffset extends FlameProperty
    {
        public function DragContainerPropertyUseFixedDragOffset()
        {
            super(
                "UseFixedDragOffset",
                "Property to get/set the setting that control whether the fixed " +
                "dragging offset will be used.  " +
                "Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString(
                (receiver as FlameDragContainer).isUsingFixedDragOffset());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameDragContainer).setUsingFixedDragOffset(FlamePropertyHelper.stringToBool(value));
        }
    }
}