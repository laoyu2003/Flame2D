
package Flame2D.elements.containers
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.data.Consts;
    
    /*!
    \brief
    Property to access the scroll position of the vertical Scrollbar.
    
    \par Usage:
    - Name: VertScrollPosition
    - Format: "[float]".
    
    \par Where:
    - [float] specifies the current scroll position / value of the vertical Scrollbar (as a fraction of the whole).
    */
    public class ScrollablePanePropertyVertScrollPosition extends FlameProperty
    {
        public function ScrollablePanePropertyVertScrollPosition()
        {
            super(
                "VertScrollPosition",
                "Property to get/set the scroll position of the vertical Scrollbar as a fraction.  Value is a float.",
                "0.000000");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameScrollablePane).getHorizontalScrollPosition());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameScrollablePane).setVerticalScrollPosition(FlamePropertyHelper.stringToFloat(value));
        }
    }
}