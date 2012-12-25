/*!
\brief
Property to access the current carat index.

\par Usage:
- Name: CaratIndex
- Format: "[uint]"

\par Where:
- [uint] is the zero based index of the carat position within the text.
*/
package Flame2D.elements.editbox
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class MultiLineEditboxPropertyCaratIndex extends FlameProperty
    {
        public function MultiLineEditboxPropertyCaratIndex()
        {
            super(
                "CaratIndex",
                "Property to get/set the current carat index.  Value is \"[uint]\".",
                "0");
        }
        
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.uintToString((receiver as FlameMultiLineEditbox).getCaratIndex());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameMultiLineEditbox).setCaratIndex(FlamePropertyHelper.stringToUint(value));
        }

    }
}