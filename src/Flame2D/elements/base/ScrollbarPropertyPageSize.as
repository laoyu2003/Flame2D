
/*!
\brief
Property to access the page size for the Scrollbar.

\par Usage:
- Name: PageSize
- Format: "[float]".

\par Where:
- [float] specifies the size of the visible page (as defined by the client code).
*/
package Flame2D.elements.base
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ScrollbarPropertyPageSize extends FlameProperty
    {
        public function ScrollbarPropertyPageSize()
        {
            super(
                "PageSize",
                "Property to get/set the page size for the Scrollbar.  Value is a float.",
                "0.000000");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameScrollbar).getPageSize());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameScrollbar).setPageSize(FlamePropertyHelper.stringToFloat(value));
        }
    }
}