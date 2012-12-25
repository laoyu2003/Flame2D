/*!
\brief
Property to access the current carat index.

\par Usage:
- Name: CaratIndex
- Format: "[uint]"

\par Where:
- [uint] is the zero based index of the carat position within the text.
*/
package Flame2D.elements.combobox
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ComboboxPropertyCaratIndex extends FlameProperty
    {
        public function ComboboxPropertyCaratIndex()
        {
            super(
                "CaratIndex",
                "Property to get/set the current carat index.  Value is \"[uint]\".",
                "0");
        }
        

        override public function getValue(receiver:*) :String
        {
            return FlamePropertyHelper.uintToString((receiver as FlameCombobox).getCaratIndex());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameCombobox).setCaratIndex(FlamePropertyHelper.stringToUint(value));
        }

    }
}