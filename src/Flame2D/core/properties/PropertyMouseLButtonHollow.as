/*!
\brief
Property to access window mouselbuttonhollow setting.

This property to get/set whether the window will ignore all l-button mouse input events.

\par Usage:
- Name: MouseLButtonHollow
- Format: "[text]"

\par Where:
- "True" to indicate the Window ignore all mouse l-button input events.
- "False" to indicate the Window does not ignore any l-button mouse input events.
*/

package Flame2D.core.properties
{
    
    public class PropertyMouseLButtonHollow extends FlameProperty
    {
        public function PropertyMouseLButtonHollow()
        {
            super(
                "MouseLButtonHollow", 
                "Property to get/set whether the window will ignore all mouse l-button input events.  Value is either \"True\" or \"False\".",
                "Flase");
        }
    }
}