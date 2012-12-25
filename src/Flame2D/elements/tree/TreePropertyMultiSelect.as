
/*!
\brief
Property to access the multi-select setting of the tree.

\par Usage:
- Name: MultiSelect
- Format: "[text]"

\par Where [Text] is:
- "True" to indicate that multiple items may be selected.
- "False" to indicate that only a single item may be selected.
*/
package Flame2D.elements.tree
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class TreePropertyMultiSelect extends FlameProperty
    {
        public function TreePropertyMultiSelect()
        {
            super(
                "MultiSelect",
                "Property to get/set the multi-select setting of the tree.  " +
                "Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameTree).isMultiselectEnabled());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameTree).setMultiselectEnabled(FlamePropertyHelper.stringToBool(value));
        }
    }
}