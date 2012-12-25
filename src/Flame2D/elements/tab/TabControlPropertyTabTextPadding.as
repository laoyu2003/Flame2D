/*!
\brief
Property to access the tab text padding setting of the tab control.

\par Usage:
- Name: TabTextPadding
- Format: "{scale,offset}" (Unified Dimension)

*/
package Flame2D.elements.tab
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class TabControlPropertyTabTextPadding extends FlameProperty
    {
        public function TabControlPropertyTabTextPadding()
        {
            super(
                "TabTextPadding", 
                "Property to get/set the padding either side of the tab buttons.",
                "{0.000000,5.000000}");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.udimToString((receiver as FlameTabControl).getTabTextPadding());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameTabControl).setTabTextPadding(FlamePropertyHelper.stringToUDim(value));
        }
    }
}