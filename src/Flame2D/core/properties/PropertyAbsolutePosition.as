
/*!
\brief
Property to access window position.

This property offers access to the position for the window, using the absolute metrics system.

\par Usage:
- Name: AbsolutePosition
- Format: "x:[float] y:[float]".

\par Where:
- x:[float]	specifies the x position co-ordinate as a floating point number, using the absolute metrics system.
- y:[float]	specifies the y position co-ordinate as a floating point number, using the absolute metrics system.
*/

package Flame2D.core.properties
{
    
    public class PropertyAbsolutePosition extends FlameProperty
    {
        public function PropertyAbsolutePosition()
        {
            super(
                "AbsolutePosition",
                "Property to get/set the position of the Window.  Value is \"x:[float] y:[float]\" using absolute metrics.",
                "x:0.000000 y:0.000000");
        }
    }
}