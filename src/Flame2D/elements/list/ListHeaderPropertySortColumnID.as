/*!
\brief
Property to access the current sort column (via ID code).

\par Usage:
- Name: SortColumnID
- Format: "[uint]".

\par Where:
- [uint] is any unsigned integer value.
*/
package Flame2D.elements.list
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ListHeaderPropertySortColumnID extends FlameProperty
    {
        public function ListHeaderPropertySortColumnID()
        {
            super(
                "SortColumnID",
                "Property to get/set the current sort column (via ID code).  Value is an unsigned integer number.",
                "0");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.uintToString((receiver as FlameListHeader).getSortSegment().getID());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameListHeader).setSortColumnFromID(FlamePropertyHelper.stringToUint(value));
        }
    }
}