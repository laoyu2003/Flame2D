
package Flame2D.falagard
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameWindow;
    
    /*!
    \brief
    Property to access the setting that controls whether the caret will blink.
    
    \par Usage:
    - Name: BlinkCaret
    - Format: "[text]".
    
    \par Where [Text] is:
    - "True" to indicate the caret should blink when he editbox is active.
    - "False" to indicate the caret should not blink.
    */
    public class FalagardEditboxPropertyBlinkCaret extends FlameProperty
    {
        public function FalagardEditboxPropertyBlinkCaret()
        {
            super(
                "BlinkCaret",
                "Property to get/set whether the Editbox caret should blink.  " +
                "Value is either \"True\" or \"False\".",
                "False");
        }
        
        //----------------------------------------------------------------------------//
        override public function getValue(receiver:*):String
        {
            var wr:FalagardEditbox = (receiver as FlameWindow).getWindowRenderer() as FalagardEditbox;
            
            return FlamePropertyHelper.boolToString(wr.isCaretBlinkEnabled());
        }
        
        //----------------------------------------------------------------------------//
        override public function setValue(receiver:*, value:String):void
        {
            var wr:FalagardEditbox = (receiver as FlameWindow).getWindowRenderer() as FalagardEditbox;
            
            wr.setCaretBlinkEnabled(FlamePropertyHelper.stringToBool(value));
        }
    }
}