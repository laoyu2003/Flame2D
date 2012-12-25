
package Flame2D.elements.containers
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.data.Consts;
    /*!
    \brief
    Property to access the step size for the horizontal Scrollbar.
    
    \par Usage:
    - Name: HorzStepSize
    - Format: "[float]".
    
    \par Where:
    - [float] specifies the size of the increase/decrease button step for the horizontal scrollbar (as a fraction of 1 page).
    */
    public class ScrollablePanePropertyHorzStepSize extends FlameProperty
    {
        public function ScrollablePanePropertyHorzStepSize()
        {
            super(
                "HorzStepSize",
                "Property to get/set the step size for the horizontal Scrollbar.  Value is a float.",
                "0.100000");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameScrollablePane).getHorizontalStepSize());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameScrollablePane).setHorizontalStepSize(FlamePropertyHelper.stringToFloat(value));
        }
    }
}