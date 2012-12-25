

package Flame2D.core.utils
{
    import Flame2D.core.properties.FlamePropertyHelper;

    /*!
    \brief
    Class encapsulating operations on a Rectangle
    */
    public class Rect
    {
        public var d_left:Number = 0;
        public var d_top:Number = 0;
        public var d_right:Number = 0;
        public var d_bottom:Number = 0;
        
        public function Rect(left:Number = 0, top:Number = 0, right:Number = 0, bottom:Number = 0)
        {
            d_left = left;
            d_top = top;
            d_right = right;
            d_bottom = bottom;
        }
        
        public function clone():Rect
        {
            return new Rect(d_left, d_top, d_right, d_bottom);
        }
        
        public static function createRect(p:Vector2, sz:Size):Rect
        {
            return new Rect(p.d_x, p.d_y, p.d_x + sz.d_width, p.d_y + sz.d_height);
        }
        
        public function getPosition():Vector2
        {
            return new Vector2(d_left, d_top);
        }
        
        public function getWidth():Number
        {
            return d_right - d_left;
        }
        
        public function getHeight():Number
        {
            return d_bottom - d_top;
        }
        
        public function getSize():Size
        {
            return new Size(d_right-d_left, d_bottom-d_top);
        }
        
        
        //get intersection with rect, returns a new rect
        public function getIntersection(rect:Rect):Rect
        {
            if( (d_right > rect.d_left) &&
                (d_left < rect.d_right) &&
                (d_bottom > rect.d_top) &&
                (d_top < rect.d_bottom)) {
                
                var temp:Rect = new Rect(0, 0, 0, 0);
                temp.d_left = (d_left > rect.d_left) ? d_left : rect.d_left;
                temp.d_right = (d_right < rect.d_right) ? d_right : rect.d_right;
                temp.d_top = (d_top > rect.d_top) ? d_top : rect.d_top;
                temp.d_bottom = (d_bottom < rect.d_bottom) ? d_bottom : rect.d_bottom;
                
                return temp;
            } else {
                return new Rect(0, 0, 0, 0);
            }
        }
        
        
        
        
        
        
        //apply offset to the rect
        public function offset(pt:Vector2):Rect
        {
            return new Rect(d_left + pt.d_x,
                d_top + pt.d_y,
                d_right + pt.d_x,
                d_bottom + pt.d_y);
        }
        
        public function offset2(pt:Vector2):void
        {
            d_left += pt.d_x;
            d_top += pt.d_y;
            d_right += pt.d_x;
            d_bottom += pt.d_y;
        }
        
        public function inPointInRect(pt:Vector2):Boolean
        {
            if( (d_left > pt.d_x) ||
                (d_right <= pt.d_x) ||
                (d_top > pt.d_y) ||
                (d_bottom <= pt.d_y)){
                return false;
            }
            
            return true;
        }
        
        //set location of rect, while retaining current size
        public function setPosition(pt:Vector2):void
        {
            var deltax:Number = pt.d_x - d_left;
            var deltay:Number = pt.d_y - d_top;
            d_left = pt.d_x;
            d_top = pt.d_y;
            d_right += deltax;
            d_bottom += deltay;
        }
        
        //set width while keep up-left position
        public function setWidth(width:Number):void
        {
            d_right = d_left + width;
        }
        
        //set height while keep up-left position
        public function setHeight(height:Number):void
        {
            d_bottom = d_top + height;
        }
        
        //set size of while keep up-left position
        public function setSize(size:Size):void
        {
            d_right = d_left + size.d_width;
            d_bottom = d_top + size.d_height;
        }
        
        
        //check the size of the rect object and if it is smaller than sz, resize it so it isn't
        //sz: Size object that describes the minimum dimensions that this rect should be limited to
        public function constrainSizeMax(sz:Size):void
        {
            if(getWidth() > sz.d_width){
                setWidth(sz.d_width);
            }
            
            if(getHeight() > sz.d_height){
                setHeight(sz.d_height);
            }
        }
        
        public function constrainSizeMin(sz:Size):void
        {
            if(getWidth() < sz.d_width){
                setWidth(sz.d_width);
            }
            
            if(getHeight() < sz.d_height){
                setHeight(sz.d_height);
            }
        }
        
        public function constrainSize(max_sz:Size, min_sz:Size):void
        {
            var curr_sz:Size = getSize();
            
            if(curr_sz.d_width > max_sz.d_width){
                setWidth(max_sz.d_width);
            } else if(curr_sz.d_width < min_sz.d_width){
                setWidth(min_sz.d_width);
            }
            
            if(curr_sz.d_height > max_sz.d_height){
                setHeight(max_sz.d_height);
            } else if(curr_sz.d_height < min_sz.d_height){
                setHeight(min_sz.d_height);
            }
        }
        
        public function isEqual(rhs:Rect):Boolean
        {
            return ( (d_left == rhs.d_left) &&
                (d_right == rhs.d_right) &&
                (d_top == rhs.d_top) &&
                (d_bottom == rhs.d_bottom));
        }
                
        public function assign(rhs:Rect):void
        {
            d_left = rhs.d_left;
            d_top = rhs.d_top;
            d_right = rhs.d_right;
            d_bottom = rhs.d_bottom;
        }
        
        public function scale(factor:Number):Rect
        {
            return new Rect(d_left * factor, d_top * factor, d_right * factor, d_bottom * factor);
        }
        
        public function add(r:Rect):Rect
        {
            return new Rect(d_left + r.d_left, d_top + r.d_top,
                d_right + r.d_right, d_bottom + r.d_bottom);
        }
        
        //same as scale
        public function multiply(factor:Number):Rect
        {
            return new Rect(d_left * factor, d_top * factor, d_right * factor, d_bottom * factor);
        }
        
        public static function clone(r:Rect):Rect
        {
            return new Rect(r.d_left, r.d_top, r.d_right, r.d_bottom);
        }
            
        public function isPointInRect(pt:Vector2):Boolean
        {
            if ((d_left > pt.d_x) ||
                (d_right <= pt.d_x) ||
                (d_top > pt.d_y) ||
                (d_bottom <= pt.d_y))
            {
                return false;
            }
            
            return true;
        }
        
        public function toString():String
        {
            return FlamePropertyHelper.rectToString(this);
        }
    }
}