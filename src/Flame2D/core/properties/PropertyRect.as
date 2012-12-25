/*!
\brief
Property to access window area rectangle.

This property offers access to the area rectangle (Rect) for the window, using the Windows active metrics mode.

\par Usage:
- Name: Rect
- Format: "l:[float] t:[float] r:[float] b:[float]".

\par Where:
- l:[float]	specifies the position of the left edge of the area as a floating point number, using the active metrics system for the Window.
- t:[float]	specifies the position of the top edge of the area as a floating point number, using the active metrics system for the Window.
- r:[float]	specifies the position of the right edge of the area as a floating point number, using the active metrics system for the Window.
- b:[float]	specifies the position of the bottom edge of the area as a floating point number, using the active metrics system for the Window.
*/

package Flame2D.core.properties
{
    
    public class PropertyRect extends FlameProperty
    {
        public function PropertyRect()
        {
            super(
                "Rect",
                "Property to get/set the area rectangle of the Window.  Value is \"l:[float] t:[float] r:[float] b:[float]\" (where l is left, t is top, r is right, and b is bottom) using the active metrics system.",
                "l:0.000000 t:0.000000 r:0.000000 b:0.000000");
        }
    }
}