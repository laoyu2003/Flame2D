/*!
\brief
Property to access window area rectangle.

This property offers access to the area rectangle (Rect) for the window, using the relative metrics system.

\par Usage:
- Name: RelativeRect
- Format: "l:[float] t:[float] r:[float] b:[float]".

\par Where:
- l:[float]	specifies the position of the left edge of the area as a floating point number, using the relative metrics system.
- t:[float]	specifies the position of the top edge of the area as a floating point number, using the relative metrics system.
- r:[float]	specifies the position of the right edge of the area as a floating point number, using the relative metrics system.
- b:[float]	specifies the position of the bottom edge of the area as a floating point number, using the relative metrics system.
*/

package Flame2D.core.properties
{
    
    public class PropertyRelativeRect extends FlameProperty
    {
        public function PropertyRelativeRect()
        {
            super(
                "RelativeRect",
                "Property to get/set the area rectangle of the Window.  Value is \"l:[float] t:[float] r:[float] b:[float]\" (where l is left, t is top, r is right, and b is bottom) using relative metrics.",
                "l:0.000000 t:0.000000 r:0.000000 b:0.000000");
        }
    }
}