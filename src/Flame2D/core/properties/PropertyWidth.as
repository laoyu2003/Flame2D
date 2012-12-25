
/*!
\brief
Property to access window width.

This property offers access to the Width setting for the window, using the Windows active metrics mode.

\par Usage:
- Name: Width
- Format: "[float]".

\par Where:
- [float]	specifies the width as a floating point number, using the active metrics system for the Window.
*/

package Flame2D.core.properties
{
    
    public class PropertyWidth extends FlameProperty
    {
        public function PropertyWidth()
        {
            super(
                "Width",
                "Property to get/set the width of the Window.  Value is floating point using the active metrics mode.",
                "0.000000");
        }
    }
}