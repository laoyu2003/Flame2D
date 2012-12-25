
/*!
\brief
Property to access the current content pane area rectangle (as window relative pixels).

\par Usage:
- Name: ContentArea
- Format: "l:[float] t:[float] r:[float] b:[float]".

\par Where:
- l:[float]	specifies the position of the left edge of the area as a floating point number.
- t:[float]	specifies the position of the top edge of the area as a floating point number.
- r:[float]	specifies the position of the right edge of the area as a floating point number.
- b:[float]	specifies the position of the bottom edge of the area as a floating point number.
*/
package Flame2D.elements.containers
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.data.Consts;
    
    public class ScrolledContainerPropertyContentArea extends FlameProperty
    {
        public function ScrolledContainerPropertyContentArea()
        {
            super(
                "ContentArea",
                "Property to get/set the current content area rectangle of the content pane.  Value is \"l:[float] t:[float] r:[float] b:[float]\" (where l is left, t is top, r is right, and b is bottom).",
                "l:0.000000 t:0.000000 r:0.000000 b:0.000000");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.rectToString((receiver as FlameScrolledContainer).getContentArea());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameScrolledContainer).setContentArea(FlamePropertyHelper.stringToRect(value));
        }
    }
}