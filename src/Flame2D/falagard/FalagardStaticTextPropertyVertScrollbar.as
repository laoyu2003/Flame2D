
package Flame2D.falagard
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameWindow;
    
    /*!
    \brief
    Property to access the setting for enabling the vertical scroll bar.
    
    \par Usage:
    - Name: VertScrollbar
    - Format: "[text]"
    
    \par Where [Text] is:
    - "True" to indicate the scroll bar is enabled and will be shown when needed.
    - "False" to indicate the scroll bar is disabled and will never be shown
    */
    public class FalagardStaticTextPropertyVertScrollbar extends FlameProperty
    {
        public function FalagardStaticTextPropertyVertScrollbar()
        {
            super(
                "VertScrollbar",
                "Property to get/set the setting for the vertical scroll bar.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        
        override public function getValue(receiver:*):String
        {
            var wr:FalagardStaticText = (receiver as FlameWindow).getWindowRenderer() as FalagardStaticText;
            return FlamePropertyHelper.boolToString(wr.isVerticalScrollbarEnabled());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            var wr:FalagardStaticText = (receiver as FlameWindow).getWindowRenderer() as FalagardStaticText;
            wr.setVerticalScrollbarEnabled(FlamePropertyHelper.stringToBool(value));
        }
    }
}