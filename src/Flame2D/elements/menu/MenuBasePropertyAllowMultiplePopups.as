
/*!
\brief
Property to access the state of the allow multiple popups setting.

\par Usage:
- Name: AllowMultiplePopups
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate that auto resizing is enabled.
- "False" to indicate that auto resizing is disabled.
*/
package Flame2D.elements.menu
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class MenuBasePropertyAllowMultiplePopups extends FlameProperty
    {
        public function MenuBasePropertyAllowMultiplePopups()
        {
            super(
                "AllowMultiplePopups",
                "Property to get/set the state of the allow multiple popups setting for the menu.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameMenuBase).isMultiplePopupsAllowed());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameMenuBase).setAllowMultiplePopups(FlamePropertyHelper.stringToBool(value));
        }

    }
}