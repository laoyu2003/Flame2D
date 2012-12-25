/*!
\brief
Property to access the tab height setting of the tab control.

\par Usage:
- Name: TabHeight
- Format: "{scale,offset}" (Unified Dimension)

*/
package Flame2D.elements.tab
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class TabControlPropertyTabHeight extends FlameProperty
    {
        public function TabControlPropertyTabHeight()
        {
            super(
                "TabHeight",
                "Property to get/set the height of the tabs.",
                "{0.050000,0.000000}");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.udimToString((receiver as FlameTabControl).getTabHeight());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameTabControl).setTabHeight(FlamePropertyHelper.stringToUDim(value));
        }
    }
}