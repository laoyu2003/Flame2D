/*!
\brief
Property to access the tooltip text for this Window.

\par Usage:
- Name: Tooltip
- Format: "[text]".

\par Where:
- [Text] is the tooltip text for this window.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyTooltip extends FlameProperty
    {
        public function PropertyTooltip()
        {
            super(
                "Tooltip",
                "Property to get/set the tooltip text for the window.  Value is the tooltip text for the window.",
                "");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setTooltipText(value);
        }
        
        override public function getValue(win:*):String
        {
            if( ! FlameWindow(win).getParent() || FlameWindow(win).inheritsTooltipText() ||
                FlameWindow(win).getTooltipText()){
                return FlameWindow(win).getTooltipText();
            } else {
                return "";
            }
        }
    }
}