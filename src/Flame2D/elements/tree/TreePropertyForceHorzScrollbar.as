/*!
\brief
Property to access the 'always show' setting for the horizontal scroll bar
of the tree.

\par Usage:
- Name: ForceHorzScrollbar
- Format: "[text]"

\par Where [Text] is:
- "True" to indicate that the horizontal scroll bar will always be
shown.
- "False" to indicate that the horizontal scroll bar will only be shown
when it is needed.
*/
package Flame2D.elements.tree
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class TreePropertyForceHorzScrollbar extends FlameProperty
    {
        public function TreePropertyForceHorzScrollbar()
        {
            super(
                "ForceHorzScrollbar",
                "Property to get/set the 'always show' setting for the horizontal " +
                "scroll bar of the tree.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameTree).isHorzScrollbarAlwaysShown());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameTree).setShowHorzScrollbar(FlamePropertyHelper.stringToBool(value));
        }
    }
}