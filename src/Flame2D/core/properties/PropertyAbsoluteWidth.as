/*!
\brief
Property to access window width.

This property offers access to the Width setting for the window, using the absolute metrics mode.

\par Usage:
- Name: AbsoluteWidth
- Format: "[float]".

\par Where:
- [float]	specifies the width as a floating point number, using the absolute metrics system.
*/

package Flame2D.core.properties
{
    
    public class PropertyAbsoluteWidth extends FlameProperty
    {
        public function PropertyAbsoluteWidth()
        {
            super(
                "AbsoluteWidth",
                "Property to get/set the width of the Window.  Value is floating point using absolute metrics.",
                "0.000000");
        }
    }
}