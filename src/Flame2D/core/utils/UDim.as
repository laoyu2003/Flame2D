
package Flame2D.core.utils
{
    import Flame2D.core.properties.FlamePropertyHelper;

    /*!
    \brief
    Class representing a unified dimension; that is a dimension that has both
    a relative 'scale' portion and and absolute 'offset' portion.
    */
    public class UDim
    {
        public var d_scale:Number = 0;
        public var d_offset:Number = 0;
        
        public function UDim(scale:Number = 0, offset:Number = 0)
        {
            this.d_scale = scale;
            this.d_offset = offset;
        }
        
        public function clone():UDim
        {
            return new UDim(d_scale, d_offset);
        }
            
        public function assign(other:UDim):void
        {
            d_scale = other.d_scale;
            d_offset = other.d_offset;
        }
        
        public function asAbsolute(base:Number):Number
        {
            return Misc.PixelAligned(base * d_scale) + d_offset;
        }
        
        public function asRelative(base:Number):Number
        {
            return (base != 0)? d_offset / base + d_scale : 0;
        }
        
        public function add(other:UDim):UDim
        {
            return new UDim(d_scale + other.d_scale, d_offset + other.d_offset);
        }
        
        public function addTo(other:UDim):void
        {
            d_scale += other.d_scale;
            d_offset += other.d_offset;
        }
        
        public function substract(other:UDim):UDim
        {
            return new UDim(d_scale - other.d_scale, d_offset - other.d_offset);
        }
        
        public function substractTo(other:UDim):void
        {
            d_scale -= other.d_scale;
            d_offset -= other.d_offset;
        }
        
        public function multiply(other:UDim):UDim
        {
            return new UDim(d_scale * other.d_scale, d_offset * other.d_offset);
        }
        
        public function multiplyFactor(factor:Number):UDim
        {
            return new UDim(d_scale * factor, d_offset * factor);
        }
        
        public function multiplyTo(other:UDim):void
        {
            d_scale *= other.d_scale;
            d_offset *= other.d_offset;
        }
        
        public function dividedBy(other:UDim):UDim
        {
            // division by zero sets component to zero.  Not technically correct
            // but probably better than exceptions and/or NaN values.
            return new UDim(other.d_scale == 0.0 ? 0.0 : d_scale / other.d_scale,
                other.d_offset == 0.0 ? 0.0 : d_offset / other.d_offset);
        }
        
        public function dividedByTo(other:UDim):void
        {
            if(other.d_scale == 0)
            {
                throw new Error("UDim divide error");
            }
            if(other.d_offset == 0)
            {
                throw new Error("UDim divide error");
            }
            d_scale /= other.d_scale;
            d_offset /= other.d_offset;
        }
        
        public function isEqual(other:UDim):Boolean
        {
            return d_scale == other.d_scale && d_offset == other.d_offset;
        }
        
        public function toString():String
        {
            return FlamePropertyHelper.udimToString(this);
        }
    }
}