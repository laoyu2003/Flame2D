/*!
\brief
Property to access the state of the sticky mode setting.

\par Usage:
- Name: StickyMode
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate that sticky mode is enabled.
- "False" to indicate that sticky mode is disabled.
*/
package Flame2D.elements.dnd
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class DragContainerPropertyStickyMode extends FlameProperty
    {
        public function DragContainerPropertyStickyMode()
        {
            super(
                "StickyMode",
                "Property to get/set the state of the sticky mode setting for the " +
                "DragContainer.  Value is either \"True\" or \"False\".",
                "True");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString(
                (receiver as FlameDragContainer).isStickyModeEnabled());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameDragContainer).
                setStickyModeEnabled(FlamePropertyHelper.stringToBool(value));
        }

    }
}