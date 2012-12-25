/*!
\brief
Property to access the 'always show' setting for the vertical scroll bar of the list box.

\par Usage:
- Name: ForceVertScrollbar
- Format: "[text]"

\par Where [Text] is:
- "True" to indicate that the vertical scroll bar will always be shown.
- "False" to indicate that the vertical scroll bar will only be shown when it is needed.
*/
package Flame2D.elements.combobox
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ComboboxPropertyForceVertScrollbar extends FlameProperty
    {
        public function ComboboxPropertyForceVertScrollbar()
        {
            super(
                "ForceVertScrollbar",
                "Property to get/set the 'always show' setting for the vertical scroll bar of the list box.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameCombobox).isVertScrollbarAlwaysShown());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameCombobox).setShowVertScrollbar(FlamePropertyHelper.stringToBool(value));
        }

    }
}