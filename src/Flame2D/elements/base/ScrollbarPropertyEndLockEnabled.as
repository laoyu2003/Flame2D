/*!
\brief
Property to access the end lock mode setting for the Scrollbar.

\par Usage:
- Name: EndLockEnabled
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate end lock mode is enabled.
- "False" to indicate end lock mode is disabled.
*/
package Flame2D.elements.base
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ScrollbarPropertyEndLockEnabled extends FlameProperty
    {
        public function ScrollbarPropertyEndLockEnabled()
        {
            super(
                "EndLockEnabled",
                "Property to get/set the 'end lock' mode setting for the Scrollbar. " +
                "Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameScrollbar).isEndLockEnabled());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameScrollbar).setEndLockEnabled(FlamePropertyHelper.stringToBool(value));
        }
    }
}