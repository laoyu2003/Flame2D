
package Flame2D.falagard
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameWindow;
    
    /*!
    \brief
    Property to access the setting that controls whether the progress bar is horizontal or vertical.
    
    \par Usage:
    - Name: VerticalProgress
    - Format: "[text]".
    
    \par Where [Text] is:
    - "True" to indicate the progress bar's operates in the vertical direction.
    - "False" to indicate the progress bar's operates in the horizontal direction.
    */
    public class FalagardProgressBarPropertyVerticalProgress extends FlameProperty
    {
        public function FalagardProgressBarPropertyVerticalProgress()
        {
            super(
                "VerticalProgress",
                "Property to get/set whether the ProgressBar operates in the vertical direction.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            var pb:FalagardProgressBar = (receiver as FlameWindow).getWindowRenderer() as FalagardProgressBar;
            return FlamePropertyHelper.boolToString(pb.isVertical());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            var pb:FalagardProgressBar = (receiver as FlameWindow).getWindowRenderer() as FalagardProgressBar;
            pb.setVertical(FlamePropertyHelper.stringToBool(value));
        }
    }
}