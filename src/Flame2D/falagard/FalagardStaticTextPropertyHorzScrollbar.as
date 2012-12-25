
package Flame2D.falagard
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameWindow;
    
    /*!
    \brief
    Property to access the setting for enabling the horizontal scroll bar.
    
    \par Usage:
    - Name: HorzScrollbar
    - Format: "[text]"
    
    \par Where [Text] is:
    - "True" to indicate the scroll bar is enabled and will be shown when needed.
    - "False" to indicate the scroll bar is disabled and will never be shown
    */
    public class FalagardStaticTextPropertyHorzScrollbar extends FlameProperty
    {
        public function FalagardStaticTextPropertyHorzScrollbar()
        {
            super(
                "HorzScrollbar",
                "Property to get/set the setting for the horizontal scroll bar.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            var wr:FalagardStaticText = (receiver as FlameWindow).getWindowRenderer() as FalagardStaticText;
            return FlamePropertyHelper.boolToString(wr.isHorizontalScrollbarEnabled());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            var wr:FalagardStaticText = (receiver as FlameWindow).getWindowRenderer() as FalagardStaticText;
            wr.setHorizontalScrollbarEnabled(FlamePropertyHelper.stringToBool(value));
        }

    }
}