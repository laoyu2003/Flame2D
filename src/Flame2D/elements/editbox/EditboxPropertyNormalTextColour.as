
/*!
\brief
Property to access the normal, unselected, text colour used for rendering text.

\par Usage:
- Name: NormalTextColour
- Format: "aarrggbb".

\par Where:
- aarrggbb is the ARGB colour value to be used.
*/
package Flame2D.elements.editbox
{
    import Flame2D.core.properties.FlameProperty;
    
    public class EditboxPropertyNormalTextColour extends FlameProperty
    {
        public function EditboxPropertyNormalTextColour()
        {
            super(
                "NormalTextColour",
                "Property to get/set the normal, unselected, text colour used for rendering text.  Value is \"aarrggbb\" (hex).",
                "FFFFFFFF");
        }
    }
}