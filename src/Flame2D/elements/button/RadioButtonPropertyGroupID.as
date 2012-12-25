/*!
\brief
Property to access the radio button group ID.

\par Usage:
- Name: GroupID
- Format: "[uint]".

\par Where:
- [uint] is any unsigned integer value.
*/
package Flame2D.elements.button
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class RadioButtonPropertyGroupID extends FlameProperty
    {
        public function RadioButtonPropertyGroupID()
        {
            super(
                "GroupID",
                "Property to get/set the radio button group ID.  Value is an unsigned integer number.",
                "0");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.uintToString((receiver as FlameRadioButton).getGroupID());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameRadioButton).setGroupID(FlamePropertyHelper.stringToUint(value));
        }
    }
}