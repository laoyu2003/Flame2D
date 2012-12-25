
package Flame2D.falagard
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameWindow;
    
    
    /*!
    \brief
    Property to access the setting that controls whether the slider is horizontal or vertical.
    
    \par Usage:
    - Name: VerticalSlider
    - Format: "[text]".
    
    \par Where [Text] is:
    - "True" to indicate the slider operates in the vertical direction.
    - "False" to indicate the slider operates in the horizontal direction.
    */
    public class FalagardSliderPropertyVerticalSlider extends FlameProperty
    {
        public function FalagardSliderPropertyVerticalSlider()
        {
            super(
                "VerticalSlider",
                "Property to get/set whether the Slider operates in the vertical direction.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            var wr:FalagardSlider = (receiver as FlameWindow).getWindowRenderer() as FalagardSlider;
            return FlamePropertyHelper.boolToString(wr.isVertical());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            var wr:FalagardSlider = (receiver as FlameWindow).getWindowRenderer() as FalagardSlider;
            wr.setVertical(FlamePropertyHelper.stringToBool(value));
        }

    }
}