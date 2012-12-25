
package Flame2D.core.utils
{
    import Flame2D.core.properties.FlamePropertyHelper;

    /*!
    \brief
    Class that holds the size (width & height) of something.
    */
    public class Size
    {
        public var d_width:Number = 0;
        public var d_height:Number = 0;
        
        public function Size(width:Number = 0, height:Number = 0)
        {
            this.d_width = width;
            this.d_height = height;
        }
        
        public function clone():Size
        {
            return new Size(d_width, d_height);
        }
        
        public function multiply(factor:Number):Size
        {
            return new Size(d_width * factor, d_height * factor);
        }
        
        public function add(s:Size):Size
        {
            return new Size(d_width + s.d_width, d_height + s.d_height);
        }
        
        public function isEqual(other:Size):Boolean
        {
            return d_width == other.d_width && d_height == other.d_height;
        }
        
        public function toString():String
        {
            return FlamePropertyHelper.sizeToString(this);
        }
    }
}