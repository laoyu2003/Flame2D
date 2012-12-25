
package Flame2D.falagard
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.system.FlameWindow;
    
    /*!
    \brief
    Property to access the segment sizing cursor image
    
    \par Usage:
    - Name: TabButtonType
    - Format: "[widgetTypeName]".
    
    */
    public class FalagardTabControlPropertyTabButtonType extends FlameProperty
    {
        public function FalagardTabControlPropertyTabButtonType()
        {
            super(
                "TabButtonType",
                "Property to get/set the widget type used when creating tab buttons.  Value should be \"[widgetTypeName]\".",
                "");
        }
        
        override public function getValue(receiver:*):String
        {
            var wr:FalagardTabControl = (receiver as FlameWindow).getWindowRenderer() as FalagardTabControl;
            return wr.getTabButtonType();
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            var wr:FalagardTabControl = (receiver as FlameWindow).getWindowRenderer() as FalagardTabControl;
            wr.setTabButtonType(value);
        }
    }
}