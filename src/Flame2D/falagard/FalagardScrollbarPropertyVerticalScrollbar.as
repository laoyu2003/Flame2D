
package Flame2D.falagard
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameWindow;
    
    /*!
    \brief
    Property to access the setting that controls whether the scrollbar is horizontal or vertical.
    
    \par Usage:
    - Name: VerticalScrollbar
    - Format: "[text]".
    
    \par Where [Text] is:
    - "True" to indicate the scrollbar operates in the vertical direction.
    - "False" to indicate the scrollbar operates in the horizontal direction.
    */
    public class FalagardScrollbarPropertyVerticalScrollbar extends FlameProperty
    {
        public function FalagardScrollbarPropertyVerticalScrollbar()
        {
            super(
                "VerticalScrollbar",
                "Property to get/set whether the Scrollbar operates in the vertical direction.  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function getValue(receiver:*):String
        {
            var wr:FalagardScrollbar = (receiver as FlameWindow).getWindowRenderer() as FalagardScrollbar;
            return FlamePropertyHelper.boolToString(wr.isVertical());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            var wr:FalagardScrollbar = (receiver as FlameWindow).getWindowRenderer() as FalagardScrollbar;
            wr.setVertical(FlamePropertyHelper.stringToBool(value));
        }
        
    }
}