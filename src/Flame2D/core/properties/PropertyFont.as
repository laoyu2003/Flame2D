/*!
\brief
Property to access window Font setting.

This property offers access to the current Font setting for the window.

\par Usage:
- Name: Font
- Format: "[text]".

\par Where:
- [text] is the name of the Font to assign for this window.  The Font specified must already be loaded.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameFont;
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyFont extends FlameProperty
    {
        public function PropertyFont()
        {
            super(
                "Font",
                "Property to get/set the font for the Window.  Value is the name of the font to use (must be loaded already).",
                "");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setFontName(value);
        }
        
        override public function getValue(win:*):String
        {
            var fnt:FlameFont = FlameWindow(win).getFont();
            if(fnt){
                return fnt.getName();
            } else {
                return "";
            }
        }
        
        override public function isDefault(win:*):Boolean
        {
            return FlameWindow(win).getFont(false) == null;
        }
    }
}