/*!
\brief
Property to access whether the window inherits its tooltip text from its
parent when it has no tooltip text of its own.  Default state: True

\par Usage:
- Name: InheritsTooltipText
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate the Window inherits its tooltip text from its
parent.
- "False" to indicate the Window does not inherit its tooltip text.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyInheritsTooltipText extends FlameProperty
    {
        public function PropertyInheritsTooltipText()
        {
            super(
                "InheritsTooltipText",
                "Property to get/set whether the window inherits its parents tooltip text when it has none of its own.  Value is either \"True\" or \"False\".",
                "True");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setInheritsTooltipText(FlamePropertyHelper.stringToBool(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.boolToString(FlameWindow(win).inheritsTooltipText());
        }
    }
}