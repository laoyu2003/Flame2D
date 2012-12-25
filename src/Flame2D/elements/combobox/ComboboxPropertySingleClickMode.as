
/*!
\brief
Property to access the 'single click mode' setting for the combo box.

\par Usage:
- Name: SingleClickMode
- Format: "[text]"

\par Where [Text] is:
- "True" to indicate that the box will operate in single click mode
- "False" to indicate that the box will not operate in single click mode
*/
package Flame2D.elements.combobox
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ComboboxPropertySingleClickMode extends FlameProperty
    {
        public function ComboboxPropertySingleClickMode()
        {
            super(
                "SingleClickMode",
                "Property to get/set the 'single click mode' setting for the combo box.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameCombobox).getSingleClickEnabled());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameCombobox).setSingleClickEnabled(FlamePropertyHelper.stringToBool(value));
        }

    }
}