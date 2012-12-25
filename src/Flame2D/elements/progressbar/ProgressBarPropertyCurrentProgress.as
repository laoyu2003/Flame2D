/*!
\brief
Property to access the current progress of the progress bar.

\par Usage:
- Name: CurrentProgress
- Format: "[float]".

\par Where:
- [float] is the current progress of the bar expressed as a value between 0 and 1.
*/
package Flame2D.elements.progressbar
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ProgressBarPropertyCurrentProgress extends FlameProperty
    {
        public function ProgressBarPropertyCurrentProgress()
        {
            super(
                "CurrentProgress",
                "Property to get/set the current progress of the progress bar.  Value is a float  value between 0.0 and 1.0 specifying the progress.",
                "0.000000");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameProgressBar).getProgress());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameProgressBar).setProgress(FlamePropertyHelper.stringToFloat(value));
        }
    }
}