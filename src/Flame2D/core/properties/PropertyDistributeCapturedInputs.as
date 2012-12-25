/*!
\brief
Property to access whether inputs are passed to child windows when
input is captured to this window.

\par Usage:
- Name: DistributeCapturedInputs
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate 'captured' inputs should be passed to attached child windows.
- "False" to indicate 'captured' inputs should be passed to this window only.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyDistributeCapturedInputs extends FlameProperty
    {
        public function PropertyDistributeCapturedInputs()
        {
            super(
                "DistributeCapturedInputs",
                "Property to get/set whether captured inputs are passed to child windows.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setDistributesCapturedInputs(FlamePropertyHelper.stringToBool(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.boolToString(FlameWindow(win).distributesCapturedInputs());
        }
    }
}