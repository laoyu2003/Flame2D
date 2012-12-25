/*!
\brief
Property to access window X position.

This property offers access to the X position for the window, using the Windows active metrics mode.

\par Usage:
- Name: XPosition
- Format: "[float]".

\par Where:
- [float]	specifies the x position co-ordinate as a floating point number, using the active metrics system for the Window.
*/

package Flame2D.core.properties
{
    
    public class PropertyXPosition extends FlameProperty
    {
        public function PropertyXPosition()
        {
            super(
                "XPosition",
                "Property to get/set the x co-ordinate position of the Window.  Value is a floating point number using the active metrics mode.",
                "0.000000");
        }
    }
}