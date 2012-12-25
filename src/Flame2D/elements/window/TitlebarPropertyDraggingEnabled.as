/*!
\brief
Property to access the state of the dragging enabled setting for the Titlebar.

\par Usage:
- Name: DraggingEnabled
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate that drag moving is enabled.
- "False" to indicate that drag moving is disabled.
*/
package Flame2D.elements.window
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class TitlebarPropertyDraggingEnabled extends FlameProperty
    {
        public function TitlebarPropertyDraggingEnabled()
        {
            super(
                "DraggingEnabled",
                "Property to get/set the state of the dragging enabled setting for the Titlebar.  Value is either \"True\" or \"False\".",
                "True");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameTitlebar).isDraggingEnabled());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameTitlebar).setDraggingEnabled(FlamePropertyHelper.stringToBool(value));
        }
    }
}