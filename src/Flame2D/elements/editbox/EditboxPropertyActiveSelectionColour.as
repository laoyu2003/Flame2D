/*!
\brief
Property to access the colour used for rendering the selection highlight when the edit box is active.

\par Usage:
- Name: ActiveSelectionColour
- Format: "aarrggbb".

\par Where:
- aarrggbb is the ARGB colour value to be used.
*/
package Flame2D.elements.editbox
{
    import Flame2D.core.properties.FlameProperty;
    
    public class EditboxPropertyActiveSelectionColour extends FlameProperty
    {
        public function EditboxPropertyActiveSelectionColour()
        {
            super(
                "ActiveSelectionColour",
                "Property to get/set the colour used for rendering the selection highlight when the edit box is active.  Value is \"aarrggbb\" (hex).",
                "FF6060FF");
        }
    }
}