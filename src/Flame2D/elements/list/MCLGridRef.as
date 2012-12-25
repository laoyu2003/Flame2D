
package Flame2D.elements.list
{
    public class MCLGridRef
    {
        public var row:uint;
        public var column:uint;
        
        public function MCLGridRef(r:uint, c:uint)
        {
            row = r;
            column = c;
        }
        
        // operators
//        MCLGridRef& operator=(const MCLGridRef& rhs);
        public function assign(rhs:MCLGridRef):void
        {
            column = rhs.column;
            row = rhs.row;
        }
//        bool operator<(const MCLGridRef& rhs) const;
        public function lessThan(rhs:MCLGridRef):Boolean
        {
            if ((row < rhs.row) ||
                ((row == rhs.row) && (column < rhs.column)))
            {
                return true;
            }
            else
            {
                return false;
            }
        }
//        bool operator<=(const MCLGridRef& rhs) const;
        public function lessOrEqual(rhs:MCLGridRef):Boolean
        {
            return ! greaterThan(rhs);
        }
//        bool operator>(const MCLGridRef& rhs) const;
        public function greaterThan(rhs:MCLGridRef):Boolean
        {
            return (lessThan(rhs) || equalTo(rhs)) ? false : true;
        }
//        bool operator>=(const MCLGridRef& rhs) const;
        public function greaterOrEqual(rhs:MCLGridRef):Boolean
        {
            return ! lessThan(rhs);
        }
//        bool operator==(const MCLGridRef& rhs) const;
        public function equalTo(rhs:MCLGridRef):Boolean
        {
            return ((column == rhs.column) && (row == rhs.row)) ? true : false;
        }
//        bool operator!=(const MCLGridRef& rhs) const;
    }
}