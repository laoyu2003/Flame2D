

package Flame2D.falagard
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.system.FlameWindow;

    /*!
    \brief
    Property to access the segment widget type.
    
    \par Usage:
    - Name: SegmentWidgetType
    - Format: "[widgetTypeName]".
    
    */
    public class FalagardListHeaderPropertySegmentWidgetType extends FlameProperty
    {
        public function FalagardListHeaderPropertySegmentWidgetType()
        {
            super(
                "SegmentWidgetType",
                "Property to get/set the widget type used when creating header segments.  Value should be \"[widgetTypeName]\".",
                "");
        }
        
        override public function getValue(receiver:*):String
        {
            var wr:FalagardListHeader = (receiver as FlameWindow).getWindowRenderer() as FalagardListHeader;
            return wr.getSegmentWidgetType();
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            var wr:FalagardListHeader = (receiver as FlameWindow).getWindowRenderer() as FalagardListHeader;
            wr.setSegmentWidgetType(value);
        }
        
    }
}