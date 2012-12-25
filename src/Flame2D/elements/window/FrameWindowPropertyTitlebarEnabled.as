/*!
\brief
Property to access the setting for whether the window title-bar will be enabled (or displayed depending upon choice of final widget type).

\par Usage:
- Name: TitlebarEnabled
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate the windows title bar should be enabled (and/or visible)
- "False" to indicate the windows title bar should be disabled (and/or hidden)
*/
package Flame2D.elements.window
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class FrameWindowPropertyTitlebarEnabled extends FlameProperty
    {
        public function FrameWindowPropertyTitlebarEnabled()
        {
            super(
                "TitlebarEnabled",
                "Property to get/set the setting for whether the window title-bar will be enabled (or displayed depending upon choice of final widget type).  Value is either \"True\" or \"False\".",
                "") ;
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameFrameWindow).isTitleBarEnabled());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameFrameWindow).setTitleBarEnabled(FlamePropertyHelper.stringToBool(value));
        }

    }
}