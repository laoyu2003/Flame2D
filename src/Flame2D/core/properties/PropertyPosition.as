
/*!
\brief
Property to access window position.

This property offers access to the position for the window, using the Windows active metrics mode.

\par Usage:
- Name: Position
- Format: "x:[float] y:[float]".

\par Where:
- x:[float]	specifies the x position co-ordinate as a floating point number, using the active metrics system for the Window.
- y:[float]	specifies the y position co-ordinate as a floating point number, using the active metrics system for the Window.
*/
package Flame2D.core.properties
{
    
    public class PropertyPosition extends FlameProperty
    {
        public function PropertyPosition()
        {
            super(
                "Position",
                "Property to get/set the position of the Window.  Value is \"x:[float] y:[float]\" using the active metrics mode.",
                "x:0.000000 y:0.000000");
        }
    }
}