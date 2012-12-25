/*!
\brief
Property to access the colour used for rendering text within the selection area.

\par Usage:
- Name: SelectedTextColour
- Format: "aarrggbb".

\par Where:
- aarrggbb is the ARGB colour value to be used.
*/
package Flame2D.elements.editbox
{
    import Flame2D.core.properties.FlameProperty;
    
    public class EditboxPropertySelectedTextColour extends FlameProperty
    {
        public function EditboxPropertySelectedTextColour()
        {
            super(
                "SelectedTextColour",
                "Property to get/set the colour used for rendering text within the selection area.  Value is \"aarrggbb\" (hex).",
                "FF000000");
        }
    }
}