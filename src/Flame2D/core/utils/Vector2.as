

//two dimensional vector, aka a Point

package Flame2D.core.utils
{
    import Flame2D.core.properties.FlamePropertyHelper;

    public class Vector2
    {
        public var d_x:Number;
        public var d_y:Number;
        
        public function Vector2(px:Number = 0, py:Number = 0)
        {
            d_x = px;
            d_y = py;
        }
       
        public function clone():Vector2
        {
            return new Vector2(d_x, d_y);    
        }
        
        public function asSize():Size
        {
            return new Size(d_x, d_y);
        }
        
        public function add(other:Vector2):Vector2
        {
            return new Vector2(d_x + other.d_x, d_y + other.d_y);
        }
        
        public function addTo(other:Vector2):void
        {
            d_x += other.d_x;
            d_y += other.d_y;
        }
        
        public function subtract(other:Vector2):Vector2
        {
            return new Vector2(d_x - other.d_x, d_y - other.d_y);
        }
        
        public function subtractTo(other:Vector2):void
        {
            d_x -= other.d_x;
            d_y -= other.d_y;
        }
        
        public function multiply(factor:Number):Vector2
        {
            return new Vector2(d_x * factor, d_y * factor);
        }
        
        public function multiplyTo(factor:Number):void
        {
            d_x *= factor;
            d_y *= factor;
        }
        
        public function isEqual(other:Vector2):Boolean
        {
            return (d_x == other.d_x && d_y == other.d_y);
        }
        
        public function toString():String
        {
            return FlamePropertyHelper.vector2ToString(this);
        }
    }
}