
/*!
\brief
Property to access the setting for whether the window close button will be enabled (or displayed depending upon choice of final widget type).

\par Usage:
- Name: CloseButtonEnabled
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate the windows close button should be enabled (and/or visible)
- "False" to indicate the windows close button should be disabled (and/or hidden)
*/
package Flame2D.elements.window
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class FrameWindowPropertyCloseButtonEnabled extends FlameProperty
    {
        public function FrameWindowPropertyCloseButtonEnabled()
        {
            super(
                "CloseButtonEnabled",
                "Property to get/set the setting for whether the window close button will be enabled (or displayed depending upon choice of final widget type).  Value is either \"True\" or \"False\".",
                "True");
        }
        
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameFrameWindow).isCloseButtonEnabled());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameFrameWindow).setCloseButtonEnabled(FlamePropertyHelper.stringToBool(value));
        }

    }
}