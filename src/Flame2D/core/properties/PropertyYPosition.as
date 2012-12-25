/*!
\brief
Property to access window Y position.

This property offers access to the Y position for the window, using the Windows active metrics mode.

\par Usage:
- Name: YPosition
- Format: "[float]".

\par Where:
- [float]	specifies the y position co-ordinate as a floating point number, using the active metrics system for the Window.
*/

package Flame2D.core.properties
{
    
    public class PropertyYPosition extends FlameProperty
    {
        public function PropertyYPosition()
        {
            super(
                "YPosition",
                "Property to get/set the y co-ordinate position of the Window.  Value is a floating point number using the active metrics mode.",
                "0.000000");
        }
    }
}