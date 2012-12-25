
package Flame2D.elements.containers
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.data.Consts;
    
    /*!
    \brief
    Property to access the step size for the vertical Scrollbar.
    
    \par Usage:
    - Name: VertStepSize
    - Format: "[float]".
    
    \par Where:
    - [float] specifies the size of the increase/decrease button step for the vertical scrollbar (as a fraction of 1 page).
    */
    public class ScrollablePanePropertyVertStepSize extends FlameProperty
    {
        public function ScrollablePanePropertyVertStepSize()
        {
            super(
                "VertStepSize",
                "Property to get/set the step size for the vertical Scrollbar.  Value is a float.",
                "0.100000");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameScrollablePane).getHorizontalStepSize());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameScrollablePane).setVerticalStepSize(FlamePropertyHelper.stringToFloat(value));
        }
    }
}