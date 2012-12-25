
/*!
\brief
Property to access window X position.

This property offers access to the X position for the window, using the relative metrics system.

\par Usage:
- Name: RelativeXPosition
- Format: "[float]".

\par Where:
- [float]	specifies the x position co-ordinate as a floating point number, using the relative metrics system.
*/

package Flame2D.core.properties
{
    
    public class PropertyRelativeXPosition extends FlameProperty
    {
        public function PropertyRelativeXPosition()
        {
            super(
                "RelativeXPosition",
                "Property to get/set the x co-ordinate position of the Window.  Value is a floating point number using relative metrics.",
                "0.000000");
        }
    }
}