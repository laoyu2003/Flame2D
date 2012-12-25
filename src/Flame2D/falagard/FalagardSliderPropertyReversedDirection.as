
package Flame2D.falagard
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameWindow;
    
    
    /*!
    \brief
    Property to access the setting that controls the positive direction for the slider
    
    \par Usage:
    - Name: ReversedDirection
    - Format: "[text]".
    
    \par Where [Text] is:
    - "True" to indicate the slider value increases towards the bottom or left edges.
    - "False" to indicate the slider value increases towards the top or right edges (default).
    */
    public class FalagardSliderPropertyReversedDirection extends FlameProperty
    {
        public function FalagardSliderPropertyReversedDirection()
        {
            super(
                "ReversedDirection",
                "Property to get/set whether the Slider operates in reversed direction.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        
        override public function getValue(receiver:*):String
        {
            var wr:FalagardSlider = (receiver as FlameWindow).getWindowRenderer() as FalagardSlider;
            return FlamePropertyHelper.boolToString(wr.isReversedDirection());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            var wr:FalagardSlider = (receiver as FlameWindow).getWindowRenderer() as FalagardSlider;
            wr.setReversedDirection(FlamePropertyHelper.stringToBool(value));
        }
    }
}