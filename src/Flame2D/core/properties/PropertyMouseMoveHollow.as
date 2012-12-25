
/*!
\brief
Property to access window mousehollow setting.

This property to get/set whether the window will ignore all mouse input events.

\par Usage:
- Name: MouseHollow
- Format: "[text]"

\par Where:
- "True" to indicate the Window ignore all mouse input events.
- "False" to indicate the Window does not ignore any mouse input events.
*/

package Flame2D.core.properties
{
    
    public class PropertyMouseMoveHollow extends FlameProperty
    {
        public function PropertyMouseMoveHollow()
        {
            super(
                "MouseMoveHollow", 
                "Property to get/set whether the window will ignore all mouse input events.  Value is either \"True\" or \"False\".",
                "Flase");
        }
    }
}