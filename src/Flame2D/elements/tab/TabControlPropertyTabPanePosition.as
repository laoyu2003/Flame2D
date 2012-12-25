
/*!
\brief
Property to query/set the position of the button pane in tab control.

\par Usage:
- Name: TabPanePosition
- Format: "top" | "bottom"

*/
package Flame2D.elements.tab
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.data.Consts;
    
    public class TabControlPropertyTabPanePosition extends FlameProperty
    {
        public function TabControlPropertyTabPanePosition()
        {
            super(
                "TabPanePosition", 
                "Property to get/set the position of the buttons pane.",
                "top");
        }
        
        override public function getValue(receiver:*):String
        {
            var tpp:uint = (receiver as FlameTabControl).getTabPanePosition ();
            if (tpp == Consts.TabPanePosition_Top)
                return "Top";
            return "Bottom";
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            var tpp:uint;
            if ((value == "top") || (value == "Top"))
                tpp = Consts.TabPanePosition_Top;
            else if ((value == "bottom") || (value == "Bottom"))
                tpp = Consts.TabPanePosition_Bottom;
            else
                return;
            (receiver as FlameTabControl).setTabPanePosition (tpp);
        }

    }
}