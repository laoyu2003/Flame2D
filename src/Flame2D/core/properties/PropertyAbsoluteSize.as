/*!
\brief
Property to access the window size.

This property offers access to the size setting for the window, using the absolute metrics system.

\par Usage:
- Name: AbsoluteSize
- Format: "w:[float] h:[float]".

\par Where:
- w:[float]	specifies the minimum width as a floating point number, using the absolute metrics system.
- h:[float] specifies the minimum height as a floating point number, using the absolute metrics system.
*/
package Flame2D.core.properties
{
    
    public class PropertyAbsoluteSize extends FlameProperty
    {
        public function PropertyAbsoluteSize()
        {
            super(
                "AbsoluteSize",
                "Property to get/set the size of the Window.  Value is \"w:[float] h:[float]\" using absolute metrics.",
                "w:0.000000 h:0.000000");
        }
    }
}