

package Flame2D.elements.list
{
    import Flame2D.elements.listbox.FlameListboxItem;
    
    public class ListRow
    {
        //typedef	std::vector<ListboxItem*>	RowItems;
        //RowItems	d_items;
        public var d_items:Vector.<FlameListboxItem> = new Vector.<FlameListboxItem>();
        public var d_sortColumn:uint;
        public var d_rowID:uint;
        
        // operators
        //ListboxItem* const& operator[](uint idx) const	{return d_items[idx];}
        public function getItem(col:uint):FlameListboxItem
        {
            return d_items[col];
        }
        
        public function setItem(col:uint, item:FlameListboxItem):void
        {
            d_items[col] = item;
        }
        
        
        //ListboxItem*&	operator[](uint idx) {return d_items[idx];}
        public function lessThan(rhs:ListRow):Boolean
        {
            var a:FlameListboxItem = d_items[d_sortColumn];
            var b:FlameListboxItem = rhs.d_items[d_sortColumn];
            
            // handle cases with empty slots
            if (!b)
            {
                return false;
            }
            else if (!a)
            {
                return true;
            }
            else
            {
                return a.lessThan(b);
            }
        }
        public function greaterThan(rhs:ListRow):Boolean
        {
            var a:FlameListboxItem = d_items[d_sortColumn];
            var b:FlameListboxItem = rhs.d_items[d_sortColumn];
            
            // handle cases with empty slots
            if (!a)
            {
                return false;
            }
            else if (!b)
            {
                return true;
            }
            else
            {
                return a.greaterThan(b);
            }

        }
    }
}