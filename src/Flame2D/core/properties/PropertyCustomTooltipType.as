/*!
\brief
Property to access the custom tooltip for this Window.

\par Usage:
- Name: CustomTooltipType
- Format: "[text]".

\par Where:
- [Text] is the typename of the custom tooltip for the Window.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyCustomTooltipType extends FlameProperty
    {
        public function PropertyCustomTooltipType()
        {
            super(
                "CustomTooltipType",
                "Property to get/set the custom tooltip for the window.  Value is the type name of the custom tooltip.",
                "");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setTooltipType(value);
        }
        
        override public function getValue(win:*):String
        {
            return FlameWindow(win).getTooltipType();
        }
    }
}