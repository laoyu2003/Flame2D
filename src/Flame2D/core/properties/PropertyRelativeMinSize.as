/*!
\brief
Property to access minimum window size.

This property offers access to the minimum size setting for the window, using screen relative metrics.

\par Usage:
- Name: RelativeMinSize
- Format: "w:[float] h:[float]".

\par Where:
- w:[float]	specifies the minimum width as a floating point number.
- h:[float] specifies the minimum height as a floating point number.
*/

package Flame2D.core.properties
{
    
    public class PropertyRelativeMinSize extends FlameProperty
    {
        public function PropertyRelativeMinSize()
        {
            super(
                "RelativeMinSize",
                "Property to get/set the minimum size for the Window.  Value is \"w:[float] h:[float]\" using relative metrics (this setting is relative to the display size).",
                "w:0.000000 h:0.000000");
        }
    }
}