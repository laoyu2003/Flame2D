/*!
\brief
Property to access window height.

This property offers access to the Height setting for the window, using the Windows active metrics mode.

\par Usage:
- Name: Height
- Format: "[float]".

\par Where:
- [float]	specifies the height as a floating point number, using the active metrics system for the Window.
*/

package Flame2D.core.properties
{
    
    public class PropertyHeight extends FlameProperty
    {
        public function PropertyHeight()
        {
            super(
                "Height",
                "Property to get/set the height of the Window.  Value is floating point using the active metrics mode.",
                "0.000000");
        }
    }
}