/*!
\brief
Property to access the sorting mode.

\par Usage:
- Name: SortMode
- Format: "[text]".

\par Where [Text] is:
- "Ascending" to use ascending sorting.
- "Descending" to use descending sorting.
- "UserSort" to use a user specifed callback as sorting function,
defaults to ascending sorting if no user callback has been specified
by the application.
*/
package Flame2D.elements.base
{
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.data.Consts;
    
    public class ItemListBasePropertySortMode extends FlameProperty
    {
        public function ItemListBasePropertySortMode()
        {
            super(
                "SortMode",
                "Property to get/set the sorting mode for the ItemListBase.  Value is either \"Ascending\", \"Descending\" or \"UserSort\".",
                "Ascending");
        }
        
        override public function getValue(receiver:*):String
        {
            var out:String = "Ascending";
            var sm:uint = (receiver as FlameItemListBase).getSortMode();
            if (sm == Consts.SortMode_Descending)
                out = "Descending";
            else if (sm == Consts.SortMode_UserSort)
                out = "UserSort";
            return out;
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            var sm:uint = Consts.SortMode_Ascending;
            if (value == "Descending")
                sm = Consts.SortMode_Descending;
            else if (value == "UserSort")
                sm = Consts.SortMode_UserSort;
            (receiver as FlameItemListBase).setSortMode(sm);
        }
    }
}