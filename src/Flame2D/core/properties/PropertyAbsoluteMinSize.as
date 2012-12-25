/*!
\brief
Property to access minimum window size.

This property offers access to the minimum size setting for the window, using absolute screen pixel metrics.

\par Usage:
- Name: AbsoluteMinSize
- Format: "w:[float] h:[float]".

\par Where:
- w:[float]	specifies the minimum width as a floating point number.
- h:[float] specifies the minimum height as a floating point number.
*/

package Flame2D.core.properties
{
    
    public class PropertyAbsoluteMinSize extends FlameProperty
    {
        public function PropertyAbsoluteMinSize()
        {
            super(
                "AbsoluteMinSize",
                "Property to get/set the minimum size for the Window.  Value is \"w:[float] h:[float]\" using absolute (pixel) metrics.",
                "w:0.000000 h:0.000000");
        }
    }
}