//package examples.Inventory
//{
//    import Flame2D.core.utils.Rect;
//    import Flame2D.core.utils.Size;
//
//    public class InventoryBase
//    {
//        
//        // array holding the content grid data.
//        protected var d_content:BoolArray2D;
//        
//        
//        // returns the pixel size of a single square in the content grid.
//        public function squarePixelSize():Size
//        {
//            const area:Rect = gridBasePixelRect();
//            return new Size(area.getWidth() / d_content.width(),
//                area.getHeight() / d_content.height());
//        }
//        
//        // set the size of the content grid and initialise it.
//        public function setContentSize(width:int, height:int):void
//        {
//            d_content.resetSize(width, height);
//        }
//        
//        // return the width of the content grid, in grid squares.
//        public function contentWidth():int
//        {
//            return d_content.width();
//        }
//        
//        // return the height of the content grid, in grid squares.
//        public function contentHeight():int
//        {
//            return d_content.height();
//        }
//        
//        // return the grid x co-ordinate that corresponds to the given screen
//        // pixel co-ordinate.
//        public function gridXLocationFromPixelPosition(x_pixel_location:Number):int
//        {
//            const area:Rect = gridBasePixelRect();
//            
//            if (x_pixel_location < int(area.d_left) ||
//                x_pixel_location >= int(area.d_right))
//                return -1;
//            
//            return (x_pixel_location - int(area.d_left)) / (area.getWidth() / d_content.width());
//        }
//        
//        // return the grid y co-ordinate that corresponds to the given screen
//        // pixel co-ordinate.
//        public function gridYLocationFromPixelPosition(y_pixel_location:Number):int
//        {
//            const area:Rect = gridBasePixelRect();
//            
//            if (y_pixel_location < int(area.d_top) ||
//                y_pixel_location >= int(area.d_bottom))
//                return -1;
//            
//            return (y_pixel_location - int(area.d_top)) / (area.getHeight() / d_content.height());
//        }
//        
//        
//        // return the screen rect where the content grid is rendered.
//        //vritual
//        protected function gridBasePixelRect():Rect
//        {
//            return new Rect();
//        }
//        
//
//
//    }
//}