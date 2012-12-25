/*!
\brief
Property to access window text parsing enabled setting.

This property offers access to the text parsing setting for the window that
specifies whether parsing will be done or whether text will be rendered
verbatim.

\par Usage:
- Name: TextParsingEnabled
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate some form of parsing of window text is to occur.
- "False" to indicate that text should not be parsed, but be rendered
verbatim.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyTextParsingEnabled extends FlameProperty
    {
        public function PropertyTextParsingEnabled()
        {
            super(
                "TextParsingEnabled",
                "Property to get/set the text parsing setting for the Window.  " +
                "Value is either \"True\" or \"False\".",
                "True");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setTextParsingEnabled(FlamePropertyHelper.stringToBool(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.boolToString(FlameWindow(win).isTextParsingEnabled());
        }
    }
}