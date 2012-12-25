/*!
\brief
Property to access the window size.

This property offers access to the size setting for the window, using the Windows active metrics mode.

\par Usage:
- Name: Size
- Format: "w:[float] h:[float]".

\par Where:
- w:[float]	specifies the minimum width as a floating point number, using the active metrics system for the Window.
- h:[float] specifies the minimum height as a floating point number, using the active metrics system for the Window.
*/

package Flame2D.core.properties
{
    
    public class PropertySize extends FlameProperty
    {
        public function PropertySize()
        {
            super(
                "Size",
                "Property to get/set the size of the Window.  Value is \"w:[float] h:[float]\" using the active metrics mode.",
                "w:0.000000 h:0.000000");
        }
    }
}