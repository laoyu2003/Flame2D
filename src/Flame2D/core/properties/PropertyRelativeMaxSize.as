/*!
\brief
Property to access maximum window size.

This property offers access to the maximum size setting for the window, using screen relative metrics.

\par Usage:
- Name: RelativeMaxSize
- Format: "w:[float] h:[float]".

\par Where:
- w:[float]	specifies the maximum width as a floating point number.
- h:[float] specifies the maximum height as a floating point number.
*/

package Flame2D.core.properties
{
    
    public class PropertyRelativeMaxSize extends FlameProperty
    {
        public function PropertyRelativeMaxSize()
        {
            super(
                "RelativeMaxSize",
                "Property to get/set the maximum size for the Window.  Value is \"w:[float] h:[float]\" using relative metrics (this setting is relative to the display size).",
                "w:1.000000 h:1.000000");
        }
    }
}