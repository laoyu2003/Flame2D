/*!
\brief 
Property to access the delay between two alarm 

\par Usage:
- Name: Delay
- Format: "[float]".

\par Where:
- [float] represents the current delay of the timer
*/
package Flame2D.elements.timer
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;

    public class TimerPropertyDelay extends FlameProperty
    {
        public function TimerPropertyDelay()
        {
            super("Delay", 
                "Property to get/set the current delay used by the timer. Value is a float.", 
                "0.000000");
        }

        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString(FlameTimer(receiver).getDelay());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            FlameTimer(receiver).setDelay(FlamePropertyHelper.stringToFloat(value));
        }

    }
    
};