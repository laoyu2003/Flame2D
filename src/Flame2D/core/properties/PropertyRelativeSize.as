/*!
\brief
Property to access the window size.

This property offers access to the size setting for the window, using the relative metrics system.

\par Usage:
- Name: RelativeSize
- Format: "w:[float] h:[float]".

\par Where:
- w:[float]	specifies the minimum width as a floating point number, using the relative metrics system.
- h:[float] specifies the minimum height as a floating point number, using the relative metrics system.
*/

package Flame2D.core.properties
{
    
    public class PropertyRelativeSize extends FlameProperty
    {
        public function PropertyRelativeSize()
        {
            super(
                "RelativeSize",
                "Property to get/set the size of the Window.  Value is \"w:[float] h:[float]\" using relative metrics.",
                "w:0.000000 h:0.000000");
        }
    }
}