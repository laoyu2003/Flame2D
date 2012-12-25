
/*!
\brief
Property to access window text setting.

This property offers access to the current text for the window.

\par Usage:
- Name: Text
- Format: "[text]".

\par Where:
- [text] is the name of the Font to assign for this window.  The Font specified must already be loaded.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyText extends FlameProperty
    {
        public function PropertyText()
        {
            super(
                "Text",
                "Property to get/set the text / caption for the Window.  Value is the text string to use.",
                "");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setText(value);
        }
        
        override public function getValue(win:*):String
        {
            return FlameWindow(win).getText();
        }
    }
}