/*!
\brief
Property to access maximum window size.

This property offers access to the maximum size setting for the window, using absolute screen pixel metrics.

\par Usage:
- Name: AbsoluteMaxSize
- Format: "w:[float] h:[float]".

\par Where:
- w:[float]	specifies the maximum width as a floating point number.
- h:[float] specifies the maximum height as a floating point number.
*/

package Flame2D.core.properties
{
    
    public class PropertyAbsoluteMaxSize extends FlameProperty
    {
        public function PropertyAbsoluteMaxSize()
        {
            super(
                "AbsoluteMaxSize",
                "Property to get/set the maximum size for the Window.  Value is \"w:[float] h:[float]\" using absolute (pixel) metrics.",
                "");
        }
    }
}