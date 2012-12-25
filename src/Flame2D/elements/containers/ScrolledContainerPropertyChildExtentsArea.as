
/*!
\brief
Property offering read-only access to the current content extents rectangle (as window relative pixels).

\par Usage:
- Name: ChildExtentsArea
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
    
    public class ScrolledContainerPropertyChildExtentsArea extends FlameProperty
    {
        public function ScrolledContainerPropertyChildExtentsArea()
        {
            super(
                "ChildExtentsArea",
                "Property to get the current content extents rectangle.  Value is \"l:[float] t:[float] r:[float] b:[float]\" (where l is left, t is top, r is right, and b is bottom).",
                "l:0.000000 t:0.000000 r:0.000000 b:0.000000");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.rectToString((receiver as FlameScrolledContainer).getChildExtentsArea());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            trace("ScrolledContainerProperties::ChildExtentsArea property does not support being set.");        
        }
    }
}