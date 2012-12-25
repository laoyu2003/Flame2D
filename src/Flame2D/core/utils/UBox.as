
package Flame2D.core.utils
{
    import Flame2D.core.properties.FlamePropertyHelper;

    /*!
    \brief
    Class encapsulating the 'Unified Box' - this is usually used for margin
    
    \par
    top, left, right and bottom represent offsets on each edge
    
    \note
    Name taken from W3 'box model'
    */
    public class UBox
    {
        public var d_top:UDim = new UDim();
        public var d_left:UDim = new UDim();
        public var d_bottom:UDim = new UDim();
        public var d_right:UDim = new UDim();
        
        public function UBox(top:UDim = null, left:UDim = null, bottom:UDim = null, right:UDim = null)
        {
            if(top == null) d_top = new UDim();
            else d_top.assign(top);
            if(left == null) d_left = new UDim();
            else d_left.assign(left);
            if(bottom == null) d_bottom = new UDim();
            else d_bottom.assign(bottom);
            if(right == null) d_right = new UDim();
            else d_right.assign(right);
        }

        
        public function assign(other:UBox):void
        {
            d_top.assign(other.d_top);
            d_left.assign(other.d_left);
            d_bottom.assign(other.d_bottom);
            d_right.assign(d_right);
        }
        
        public function isEqual(rhs:UBox):Boolean
        {
            return d_top.isEqual(rhs.d_top) &&
                d_left.isEqual(rhs.d_left) &&
                d_bottom.isEqual(rhs.d_bottom) &&
                d_right.isEqual(rhs.d_right);
        }
        
        public function multiply(dim:UDim):UBox
        {
            return new UBox(
                d_top.multiply(dim), d_left.multiply(dim),
                d_bottom.multiply(dim), d_right.multiply(dim) );
        }
        
        public function add(b:UBox):UBox
        {
            return new UBox(
                d_top.add(b.d_top), d_left.add(b.d_left),
                d_bottom.add(b.d_bottom), d_right.add(b.d_right) );
        }

        public function toString():String
        {
            return FlamePropertyHelper.uboxToString(this);
        }

    }
}