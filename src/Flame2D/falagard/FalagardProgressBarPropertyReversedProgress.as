
package Flame2D.falagard
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameWindow;
    
    
    /*!
    \brief
    Property to access the setting that controls the direction that progress 'grows' towards
    
    \par Usage:
    - Name: ReversedProgress
    - Format: "[text]".
    
    \par Where [Text] is:
    - "True" to indicate the progress grows towards the left or bottom edge.
    - "False" to indicate the progress grows towards the right or top edge.
    */
    public class FalagardProgressBarPropertyReversedProgress extends FlameProperty
    {
        public function FalagardProgressBarPropertyReversedProgress()
        {
            super(
                "ReversedProgress",
                "Property to get/set whether the ProgressBar operates in reversed direction.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            var pb:FalagardProgressBar = (receiver as FlameWindow).getWindowRenderer() as FalagardProgressBar;
            return FlamePropertyHelper.boolToString(pb.isReversed());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            var pb:FalagardProgressBar = (receiver as FlameWindow).getWindowRenderer() as FalagardProgressBar;
            pb.setReversed(FlamePropertyHelper.stringToBool(value));
        }
    }
}