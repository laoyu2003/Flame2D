
/*!
\brief
Property to access the mask text setting of the edit box.

This property offers access to the mask text setting for the Editbox object.

\par Usage:
- Name: MaskCodepoint
- Format: "[uint]"

\par Where:
- [uint] is the Unicode utf32 value of the codepoint used for masking text.
*/
package Flame2D.elements.editbox
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class EditboxPropertyMaskCodepoint extends FlameProperty
    {
        public function EditboxPropertyMaskCodepoint()
        {
            super(
                "MaskCodepoint",
                "Property to get/set the utf32 codepoint value used for masking text.  Value is \"[uint]\".",
                "42");
        }
        
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.uintToString((receiver as FlameEditbox).getMaskCodePoint());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameEditbox).setMaskCodePoint(FlamePropertyHelper.stringToUint(value));
        }
    }
}