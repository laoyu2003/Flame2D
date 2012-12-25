
package Flame2D.core.utils
{
    import Flame2D.core.properties.FlamePropertyHelper;

    /*!
    \brief
    Two dimensional vector class built using unified dimensions (UDims).
    The UVector2 class is used for representing both positions and sizes.
    */
    public class UVector2
    {
        
        public var d_x:UDim = new UDim();
        public var d_y:UDim = new UDim();
        
        public function UVector2(x:UDim = null, y:UDim = null)
        {
            if(x == null) d_x = new UDim();
            else d_x.assign(x);
            
            if(y == null) d_y = new UDim();
            else d_y.assign(y);
        }
        
        //added by yumj
        public function clone():UVector2
        {
            return new UVector2(d_x.clone(), d_y.clone());
        }
        
        public function assign(other:UVector2):void
        {
            d_x.assign(other.d_x);
            d_y.assign(other.d_y);
        }
        
        
        public function asAbsolute(base:Size):Vector2
        {
            return new Vector2(d_x.asAbsolute(base.d_width), d_y.asAbsolute(base.d_height));
        }
            
        public function asRelative(base:Size):Vector2
        {
            return new Vector2(d_x.asRelative(base.d_width), d_y.asRelative(base.d_height));
        }
        //add----------------
        public function add(other:UVector2):UVector2
        {
            return new UVector2(d_x.add(other.d_x), d_y.add(other.d_y));
        }
        
        public function addUDim(other:UDim):UVector2
        {
            return new UVector2(d_x.add(other), d_y.add(other));
        }
        
        public function addTo(other:UVector2):void
        {
            d_x.addTo(other.d_x);
            d_y.addTo(other.d_y);
        }
        
        // substract
        public function substract(other:UVector2):UVector2
        {
            return new UVector2(d_x.substract(other.d_x), d_y.substract(other.d_y));
        }
        
        public function substractUDim(other:UDim):UVector2
        {
            return new UVector2(d_x.substract(other), d_y.substract(other));
        }

        public function substractTo(other:UVector2):void
        {
            d_x.substractTo(other.d_x);
            d_y.substractTo(other.d_y);
        }
        
        //divide
        public function dividedBy(other:UVector2):UVector2
        {
            return new UVector2(d_x.dividedBy(other.d_x), d_y.dividedBy(other.d_y));
        }
        
        public function dividedByTo(other:UVector2):void
        {
            d_x.dividedByTo(other.d_x);
            d_y.dividedByTo(other.d_y);
        }
        
        //multiply
        public function multiply(other:UVector2):UVector2
        {
            return new UVector2(d_x.multiply(other.d_x), d_y.multiply(other.d_y));
        }
        
        public function multiplyUDim(other:UDim):UVector2
        {
            return new UVector2(d_x.multiply(other), d_y.multiply(other));
        }
        
        public function multiplyTo(other:UVector2):void
        {
            d_x.multiplyTo(other.d_x);
            d_y.multiplyTo(other.d_y);
        }
        
        //equal operator
        public function isEqual(other:UVector2):Boolean
        {
            return d_x.isEqual(other.d_x) && d_y.isEqual(other.d_y);
        }
        
        public function toString():String
        {
            return FlamePropertyHelper.uvector2ToString(this);
        }
                        
    }
}