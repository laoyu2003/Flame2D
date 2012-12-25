/*!
\brief
Property to access window height.

This property offers access to the Height setting for the window, using the relative metrics mode.

\par Usage:
- Name: RelativeHeight
- Format: "[float]".

\par Where:
- [float]	specifies the height as a floating point number, using the relative metrics system.
*/

package Flame2D.core.properties
{
    
    public class PropertyRelativeHeight extends FlameProperty
    {
        public function PropertyRelativeHeight()
        {
            super(
                "RelativeHeight",
                "Property to get/set the height of the Window.  Value is floating point using relative metrics.",
                "0.000000");
        }
    }
}