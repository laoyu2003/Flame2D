/*!
\brief
Property to access the colour used for rendering the selection highlight when the edit box is inactive.

\par Usage:
- Name: InactiveSelectionColour
- Format: "aarrggbb".

\par Where:
- aarrggbb is the ARGB colour value to be used.
*/
package Flame2D.elements.editbox
{
    import Flame2D.core.properties.FlameProperty;
    
    public class EditboxPropertyInactiveSelectionColour extends FlameProperty
    {
        public function EditboxPropertyInactiveSelectionColour()
        {
            super(
                "InactiveSelectionColour",
                "Property to get/set the colour used for rendering the selection highlight when the edit box is inactive.  Value is \"aarrggbb\" (hex).",
                "FF808080");
        }
    }
}