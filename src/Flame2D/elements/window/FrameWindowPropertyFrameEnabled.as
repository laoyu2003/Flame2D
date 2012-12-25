/*!
\brief
Property to access the setting for whether the window frame will be displayed.

\par Usage:
- Name: FrameEnabled
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate the windows frame should be displayed.
- "False" to indicate the windows frame should not be displayed.
*/
package Flame2D.elements.window
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class FrameWindowPropertyFrameEnabled extends FlameProperty
    {
        public function FrameWindowPropertyFrameEnabled()
        {
            super(
                "FrameEnabled",
                "Property to get/set the setting for whether the window frame will be displayed.  Value is either \"True\" or \"False\".",
                "True");
        }
        
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameFrameWindow).isFrameEnabled());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameFrameWindow).setFrameEnabled(FlamePropertyHelper.stringToBool(value));
        }

    }
}