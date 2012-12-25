/*!
\brief
Property to access the state of the dragging enabled setting.

\par Usage:
- Name: DraggingEnabled
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate that dragging is enabled.
- "False" to indicate that dragging is disabled.
*/
package Flame2D.elements.dnd
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class DragContainerPropertyDraggingEnabled extends FlameProperty
    {
        public function DragContainerPropertyDraggingEnabled()
        {
            super(
                "DraggingEnabled",
                "Property to get/set the state of the dragging enabled setting for the DragContainer.  Value is either \"True\" or \"False\".",
                "True");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameDragContainer).isDraggingEnabled());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameDragContainer).setDraggingEnabled(FlamePropertyHelper.stringToBool(value));
        }
    }
}