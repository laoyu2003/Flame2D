
package Flame2D.elements.containers
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.data.Consts;
    /*!
    \brief
    Property to access the setting which controls whether the horizontal scroll bar will 
    always be displayed, or only displayed when it is required.
    
    \par Usage:
    - Name: ForceHorzScrollbar
    - Format: "[text]"
    
    \par Where [Text] is:
    - "True" to indicate that the horizontal scroll bar will always be shown.
    - "False" to indicate that the horizontal scroll bar will only be shown when it is needed.
    */
    public class ScrollablePanePropertyForceHorzScrollbar extends FlameProperty
    {
        public function ScrollablePanePropertyForceHorzScrollbar()
        {
            super(
                "ForceHorzScrollbar",
                "Property to get/set the setting which controls whether the horizontal scroll bar is aways shown.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameScrollablePane).isHorzScrollbarAlwaysShown());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameScrollablePane).setShowHorzScrollbar(FlamePropertyHelper.stringToBool(value));
        }
    }
}