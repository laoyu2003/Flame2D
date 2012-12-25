/*!
\brief
Property to access window X position.

This property offers access to the X position for the window, using the absolute metrics system.

\par Usage:
- Name: AbsoluteXPosition
- Format: "[float]".

\par Where:
- [float]	specifies the x position co-ordinate as a floating point number, using the absolute metrics system.
*/

package Flame2D.core.properties
{
    
    public class PropertyAbsoluteXPosition extends FlameProperty
    {
        public function PropertyAbsoluteXPosition()
        {
            super(
                "AbsoluteXPosition",
                "Property to get/set the x co-ordinate position of the Window.  Value is a floating point number using absolute metrics.",
                "0.000000");
        }
    }
}