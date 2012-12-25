
/*!
\brief
Property to access the step size for the Scrollbar.

\par Usage:
- Name: StepSize
- Format: "[float]".

\par Where:
- [float] specifies the size of the increase/decrease button step (as defined by the client code).
*/
package Flame2D.elements.base
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ScrollbarPropertyStepSize extends FlameProperty
    {
        public function ScrollbarPropertyStepSize()
        {
            super(
                "StepSize",
                "Property to get/set the step size for the Scrollbar.  Value is a float.",
                "1.000000");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameScrollbar).getStepSize());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameScrollbar).setStepSize(FlamePropertyHelper.stringToFloat(value));
        }

    }
}