/*!
\brief
Property to access window text setting.

This property offers access to the current text for the window.

\par Usage:
- Name: Text
- Format: "[text]".

\par Where:
- "True" to indicate the Window inherits alpha blend values from it's ancestors.
- "False" to indicate the Window does not inherit alpha blend values from it's ancestors.
*/

package Flame2D.core.properties
{
    
    public class PropertyTextOriginal extends FlameProperty
    {
        public function PropertyTextOriginal()
        {
            super(
                "TextOriginal", 
                "Property to get/set the text / caption for the Window.  Value is the text string to use.",
                "");
        }
    }
}