
package Flame2D.elements.containers
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.data.Consts;
    
    /*!
    \brief
    Property to access the overlap size for the horizontal Scrollbar.
    
    \par Usage:
    - Name: HorzOverlapSize
    - Format: "[float]".
    
    \par Where:
    - [float] specifies the size of the per-page overlap (as a fraction of one page).
    */
    public class ScrollablePanePropertyHorzOverlapSize extends FlameProperty
    {
        public function ScrollablePanePropertyHorzOverlapSize()
        {
            super(
                "HorzOverlapSize",
                "Property to get/set the overlap size for the horizontal Scrollbar.  Value is a float.",
                "0.010000")
        }
        
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameScrollablePane).getHorizontalOverlapSize());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameScrollablePane).setHorizontalOverlapSize(FlamePropertyHelper.stringToFloat(value));
        }
    }
}