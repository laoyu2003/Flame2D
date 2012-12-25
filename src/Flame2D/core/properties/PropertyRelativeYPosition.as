/*!
\brief
Property to access window Y position.

This property offers access to the Y position for the window, using the relative metrics system.

\par Usage:
- Name: RelativeYPosition
- Format: "[float]".

\par Where:
- [float]	specifies the y position co-ordinate as a floating point number, using the relative metrics system.
*/

package Flame2D.core.properties
{
    
    public class PropertyRelativeYPosition extends FlameProperty
    {
        public function PropertyRelativeYPosition()
        {
            super(
                "RelativeYPosition",
                "Property to get/set the y co-ordinate position of the Window.  Value is a floating point number using relative metrics.",
                "0.000000");
        }
    }
}