
/*!
\brief
Property to access the setting for whether the user is able to roll-up / shade the window.

\par Usage:
- Name: RollUpEnabled
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate the user can roll-up / shade the window.
- "False" to indicate the user can not roll-up / shade the window.
*/
package Flame2D.elements.window
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class FrameWindowPropertyRollUpEnabled extends FlameProperty
    {
        public function FrameWindowPropertyRollUpEnabled()
        {
            super(
                "RollUpEnabled",
                "Property to get/set the setting for whether the user is able to roll-up / shade the window.  Value is either \"True\" or \"False\".",
                "True");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameFrameWindow).isRollupEnabled());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameFrameWindow).setRollupEnabled(FlamePropertyHelper.stringToBool(value));
        }
    }
}