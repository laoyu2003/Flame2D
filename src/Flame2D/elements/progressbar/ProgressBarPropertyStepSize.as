
/*!
\brief
Property to access the step size setting for the progress bar.

\par Usage:
- Name: StepSize
- Format: "[float]".

\par Where:
- [float] is the size of the invisible sizing border in screen pixels.
*/
package Flame2D.elements.progressbar
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ProgressBarPropertyStepSize extends FlameProperty
    {
        public function ProgressBarPropertyStepSize()
        {
            super(
                "StepSize",
                "Property to get/set the step size setting for the progress bar.  Value is a float value.",
                "0.010000");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameProgressBar).getStep());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameProgressBar).setStepSize(FlamePropertyHelper.stringToFloat(value));
        }
    }
}