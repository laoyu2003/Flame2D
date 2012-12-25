/*!
\brief
Property to set if the menu should close all its open child popups, when it gets hidden

\par Usage:
- Name: AutoCloseNestedPopups
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate that close on hidden is enabled.
- "False" to indicate that close on hidden is disabled.
*/
package Flame2D.elements.menu
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class MenuBasePropertyAutoCloseNestedPopups extends FlameProperty
    {
        public function MenuBasePropertyAutoCloseNestedPopups()
        {
            super(
                "AutoCloseNestedPopups",
                "Property to set if the menu should close all its open child popups, when it gets hidden.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameMenuBase).getAutoCloseNestedPopups());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameMenuBase).setAutoCloseNestedPopups(FlamePropertyHelper.stringToBool(value));
        }
    }
}