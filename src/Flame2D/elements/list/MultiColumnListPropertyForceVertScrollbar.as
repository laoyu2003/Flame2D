
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
package Flame2D.elements.list
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class MultiColumnListPropertyForceVertScrollbar extends FlameProperty
    {
        public function MultiColumnListPropertyForceVertScrollbar()
        {
            super(
                "ForceVertScrollbar",
                "Property to get/set the 'always show' setting for the vertical scroll bar of the list box.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameMultiColumnList).isVertScrollbarAlwaysShown());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameMultiColumnList).setShowVertScrollbar(FlamePropertyHelper.stringToBool(value));
        }

    }
}