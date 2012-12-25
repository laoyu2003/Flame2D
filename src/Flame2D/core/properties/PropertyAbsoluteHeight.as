/*!
\brief
Property to access window height.

This property offers access to the Height setting for the window, using the absolute metrics mode.

\par Usage:
- Name: AbsoluteHeight
- Format: "[float]".

\par Where:
- [float]	specifies the height as a floating point number, using the absolute metrics system.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyAbsoluteHeight extends FlameProperty
    {
        public function PropertyAbsoluteHeight()
        {
            super(
                "AbsoluteHeight",
                "Property to get/set the height of the Window.  Value is floating point using absolute metrics.",
                "0.000000");
        }
        
    }
}