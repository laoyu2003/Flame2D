
/*!
\brief
Property to access the show item tooltips setting of the tree.

\par Usage:
- Name: ItemTooltips
- Format: "[text]"

\par Where [Text] is:
- "True" to indicate that the tooltip of the tree will be set by the
item below the mouse pointer
- "False" to indicate that the tree has a static tooltip.
*/
package Flame2D.elements.tree
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class TreePropertyItemTooltips extends FlameProperty
    {
        public function TreePropertyItemTooltips()
        {
            super(
                "ItemTooltips",
                "Property to access the show item tooltips setting of the tree.  " +
                "Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameTree).isItemTooltipsEnabled());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameTree).setItemTooltipsEnabled(FlamePropertyHelper.stringToBool(value));
        }
    }
}