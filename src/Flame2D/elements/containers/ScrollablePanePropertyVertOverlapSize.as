
package Flame2D.elements.containers
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.data.Consts;
    
    /*!
    \brief
    Property to access the overlap size for the vertical Scrollbar.
    
    \par Usage:
    - Name: VertOverlapSize
    - Format: "[float]".
    
    \par Where:
    - [float] specifies the size of the per-page overlap (as a fraction of one page).
    */
    public class ScrollablePanePropertyVertOverlapSize extends FlameProperty
    {
        public function ScrollablePanePropertyVertOverlapSize()
        {
            super(
                "VertOverlapSize",
                "Property to get/set the overlap size for the vertical Scrollbar.  Value is a float.",
                "0.010000");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameScrollablePane).getHorizontalOverlapSize());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameScrollablePane).setVerticalOverlapSize(FlamePropertyHelper.stringToFloat(value));
        }
    }
}