/*!
\brief
Property to access window Y position.

This property offers access to the Y position for the window, using the absolute metrics system.

\par Usage:
- Name: AbsoluteYPosition
- Format: "[float]".

\par Where:
- [float]	specifies the y position co-ordinate as a floating point number, using the absolute metrics system.
*/

package Flame2D.core.properties
{
    
    public class PropertyAbsoluteYPosition extends FlameProperty
    {
        public function PropertyAbsoluteYPosition()
        {
            super(
                "AbsoluteYPosition",
                "Property to get/set the y co-ordinate position of the Window.  Value is a floating point number using absolute metrics.",
                "0.000000");
        }
    }
}