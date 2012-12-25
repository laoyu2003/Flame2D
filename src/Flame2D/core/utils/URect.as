
package Flame2D.core.utils
{
    import Flame2D.core.properties.FlamePropertyHelper;

    /*!
    \brief
    Area rectangle class built using unified dimensions (UDims).
    */
    public class URect
    {
        public var d_min:UVector2 = new UVector2();
        public var d_max:UVector2 = new UVector2();
        

        public function URect(min:UVector2 = null, max:UVector2 = null)
        {
            if(min == null) d_min = new UVector2();
            else this.d_min.assign(min)
            
            if(max == null) d_max = new UVector2();
            else this.d_max.assign(max);
        }
        
        public function clone():URect
        {
            return new URect(d_min.clone(), d_max.clone());
        }
        
        public function assign(other:URect):void
        {
            d_min.assign(other.d_min);
            d_max.assign(other.d_max);
        }
        

        
        public function asAbsolute(base:Size):Rect
        {
            return new Rect(
                d_min.d_x.asAbsolute(base.d_width),
                d_min.d_y.asAbsolute(base.d_height),
                d_max.d_x.asAbsolute(base.d_width),
                d_max.d_y.asAbsolute(base.d_height)
            );
        }
        
        public function asRelative(base:Size):Rect
        {
            return new Rect(
                d_min.d_x.asRelative(base.d_width),
                d_min.d_y.asRelative(base.d_height),
                d_max.d_x.asRelative(base.d_width),
                d_max.d_y.asRelative(base.d_height)
            );
        }
        
        public function add(other:URect):URect
        {
            return new URect(d_min.add(other.d_min), d_max.add(other.d_max));    
        }
        
        public function addUDim(other:UDim):URect
        {
            return new URect(d_min.addUDim(other), d_max.addUDim(other));
        }
        
        public function multiplyUDim(other:UDim):URect
        {
            return new URect(d_min.multiplyUDim(other), d_max.multiplyUDim(other));
        }
        
        
        
        
        
        
        
        public function getPosition():UVector2
        {
            return d_min.clone();
        }
        
        public function getSize():UVector2
        {
            return d_max.substract(d_min);
        }
        
        public function getWidth():UDim
        {
            return d_max.d_x.substract(d_min.d_x);
        }
        
        public function getHeight():UDim
        {
            return d_max.d_y.substract(d_min.d_y);
        }

        public function setPosition(pos:UVector2):void
        {
            var sz:UVector2 = d_max.substract(d_min);
            d_min.assign(pos);
            d_max.assign(d_min.add(sz));
        }
        
        public function setSize(sz:UVector2):void
        {
            d_max.assign(d_min.add(sz));
        }
        
        public function setWidth(w:UDim):void
        { 
            d_max.d_x.assign(d_min.d_x.add(w));
        }
        
        public function setHeight(h:UDim):void
        { 
            d_max.d_y.assign(d_min.d_y.add(h)); 
        }
        
        public function offset(sz:UVector2):void
        {
            d_min.assign(d_min.add(sz));
            d_max.assign(d_max.add(sz));
        }
        
        public function toString():String
        {
            return FlamePropertyHelper.urectToString(this);
        }
    }
}