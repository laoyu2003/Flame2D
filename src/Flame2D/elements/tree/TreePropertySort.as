/*!
\brief
Property to access the sort setting of the Tree.

\par Usage:
- Name: Sort
- Format: "[text]"

\par Where [Text] is:
- "True" to indicate the tree items should be sorted.
- "False" to indicate the tree items should not be sorted.
*/
package Flame2D.elements.tree
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class TreePropertySort extends FlameProperty
    {
        public function TreePropertySort()
        {
            super(
                "Sort",
                "Property to get/set the sort setting of the tree.  " +
                "Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameTree).isSortEnabled());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameTree).setSortingEnabled(FlamePropertyHelper.stringToBool(value));
        }

    }
}