/*!
\brief
Property to access the setting for whether the user may drag the window around by its title bar.

\par Usage:
- Name: DragMovingEnabled
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate the window may be repositioned by the user via dragging.
- "False" to indicate the window may not be repositioned by the user.
*/
package Flame2D.elements.window
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class FrameWindowPropertyDragMovingEnabled extends FlameProperty
    {
        public function FrameWindowPropertyDragMovingEnabled()
        {
            super(
                "DragMovingEnabled",
                "Property to get/set the setting for whether the user may drag the window around by its title bar.  Value is either \"True\" or \"False\".",
                "True");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameFrameWindow).isDragMovingEnabled());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameFrameWindow).setDragMovingEnabled(FlamePropertyHelper.stringToBool(value));
        }
    }
}