
/*!
\brief
Property to access window width.

This property offers access to the Width setting for the window, using the relative metrics mode.

\par Usage:
- Name: RelativeWidth
- Format: "[float]".

\par Where:
- [float]	specifies the width as a floating point number, using the relative metrics system.
*/

package Flame2D.core.properties
{
    
    public class PropertyRelativeWidth extends FlameProperty
    {
        public function PropertyRelativeWidth()
        {
            super(
                "RelativeWidth",
                "Property to get/set the width of the Window.  Value is floating point using relative metrics.",
                "0.000000");
        }
    }
}