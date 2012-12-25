/*!
\brief
Property to access the metrics mode setting.

This property offers access to the metrics mode setting for the window.

\par Usage:
- Name: MetricsMode
- Format: "[text]".

\par Where [text] is:
- "Relative" for the relative metrics mode.
- "Absolute" for the absolute metrics mode.
- "Inherited" if metrics should be inherited from the parent (only used with set method).
*/

package Flame2D.core.properties
{
    
    public class PropertyMetricsMode extends FlameProperty
    {
        public function PropertyMetricsMode()
        {
            super(
                "MetricsMode",
                "Property to get/set the metrics mode for the Window.  Value is \"Relative\", \"Absolute\", or \"Inherited\".",
                "Relative");
        }
    }
}