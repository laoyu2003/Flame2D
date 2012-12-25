/*!
\brief
Property to access the roll-up / shade state of the window.

\par Usage:
- Name: RollUpState
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate the window is / should be rolled-up.
- "False" to indicate the window is not / should not be rolled up
*/
package Flame2D.elements.window
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class FrameWindowPropertyRollUpState extends FlameProperty
    {
        public function FrameWindowPropertyRollUpState()
        {
            super(
                "RollUpState",
                "Property to get/set the roll-up / shade state of the window.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameFrameWindow).isRolledup());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            var reqState:Boolean = FlamePropertyHelper.stringToBool(value);
            
            if (reqState != (receiver as FlameFrameWindow).isRolledup())
            {
                (receiver as FlameFrameWindow).toggleRollup();
            }
            
        }
    }
}