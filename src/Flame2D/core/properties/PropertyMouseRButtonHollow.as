/*!
\brief
Property to access window mouserbuttonhollow setting.

This property to get/set whether the window will ignore all r-button mouse input events.

\par Usage:
- Name: MouseRButtonHollow
- Format: "[text]"

\par Where:
- "True" to indicate the Window ignore all mouse r-button input events.
- "False" to indicate the Window does not ignore any r-button mouse input events.
*/

package Flame2D.core.properties
{
    
    public class PropertyMouseRButtonHollow extends FlameProperty
    {
        public function PropertyMouseRButtonHollow()
        {
            super(
                "MouseRButtonHollow", 
                "Property to get/set whether the window will ignore all mouse r-button input events.  Value is either \"True\" or \"False\".",
                "Flase");
        }
    }
}