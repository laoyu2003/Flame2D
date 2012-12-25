/*!
\brief
Property to access the overlap size for the Scrollbar.

\par Usage:
- Name: OverlapSize
- Format: "[float]".

\par Where:
- [float] specifies the size of the per-page overlap (as defined by the client code).
*/
package Flame2D.elements.base
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ScrollbarPropertyOverlapSize extends FlameProperty
    {
        public function ScrollbarPropertyOverlapSize()
        {
            super(
                "OverlapSize",
                "Property to get/set the overlap size for the Scrollbar.  Value is a float.",
                "0.000000");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameScrollbar).getOverlapSize());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameScrollbar).setOverlapSize(FlamePropertyHelper.stringToFloat(value));
        }
    }
}