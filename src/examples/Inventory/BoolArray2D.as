package examples.Inventory
{
    
    public class BoolArray2D
    {
        private var d_width:int = 0;
        private var d_height:int = 0;
        private var d_content:Vector.<Boolean> = null;

        public function BoolArray2D(width:int, height:int)
        {
            resetSize(width, height);
        }
        
        // return the width of the array
        public function width():int
        {
            return d_width;
        }
        
        // return the height of the array.
        public function height():int
        {
            return d_height;
        }
        
        // get the element at the specified location.
        public function elementAtLocation(x:int, y:int):Boolean
        {
            if (x < 0 || x >= d_width || y < 0 || y >= d_height)
                throw new Error(
                    "BoolArray2D::elementAtLocation: location out of range");
            
            return d_content[y * d_width + x];
        }
        
        // set the element at the specified location.
        public function setElementAtLocation(x:int, y:int, value:Boolean):void
        {
            if (x < 0 || x >= d_width || y < 0 || y >= d_height)
                throw new Error(
                    "BoolArray2D::setElementAtLocation: location out of range");
            
            d_content[y * d_width + x] = value;
        }
        
        // clear the array to the specified value.
        public function clear(value:Boolean = false):void
        {
            if (!d_content)
                return;
            
            const sz:int = d_width * d_height;
            for (var i:int = 0; i < sz; ++i)
                d_content[i] = value;
        }
        
        // set the array size.  content is cleared to 0.
        public function resetSize(width:int, height:int):void
        {
            if (d_width != width || d_height != height)
            {
                d_content = null;
                d_width = width;
                d_height = height;
                d_content = new Vector.<Boolean>(width * height);
                for(var i:uint = 0; i<width *height; i++)
                {
                    d_content[i] = false;
                }
            }
            
            clear();
        }
        
    }
    
    
}