package examples.Inventory
{
    import Flame2D.core.events.DragDropEventArgs;
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.utils.Colour;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.UDim;
    import Flame2D.core.utils.UVector2;
    import Flame2D.core.utils.Vector2;

    public class InventoryReceiver extends FlameWindow implements IInventoryBase
    {
        public static const WidgetTypeName:String = "InventoryReceiver";
        public static const EventNamespace:String = "InventoryReceiver";
        
        // array holding the content grid data.
        protected var d_content:BoolArray2D = new BoolArray2D(0,0);
        
        public function InventoryReceiver(type:String, name:String)
        {
            super(type, name);
            
            setDragDropTarget(true);
        }
        
        // return whether the given item will fit at the given content grid
        // co-ordinates.
        public function itemWillFitAtLocation(item:InventoryItem, x:int, y:int):Boolean
        {
            if (x < 0 || y < 0)
                return false;
            
            if (x + item.contentWidth() > d_content.width() ||
                y + item.contentHeight() > d_content.height())
                return false;
            
            const already_attached:Boolean = (this == item.getParent());
            // if item is already attatched erase its data from the content map so the
            // test result is reliable.
            if (already_attached)
                eraseItemFromContentMap(item);
            
            var result:Boolean = true;
            for (var item_y:int = 0; item_y < item.contentHeight() && result; ++item_y)
            {
                for (var item_x:int = 0; item_x < item.contentWidth() && result; ++item_x)
                {
                    if (d_content.elementAtLocation(item_x + x, item_y + y) &&
                        item.isSolidAtLocation(item_x, item_y))
                        result = false;
                }
            }
            
            // re-write item into content map if we erased it earlier.
            if (already_attached)
                writeItemToContentMap(item);
            
            return result;
        }
        
        // adds the given item at the given content grid co-ordinates.  The item
        // is only added if the item will fit at the given location.  Returns
        // true if the item was added successfully.
        public function addItemAtLocation(item:InventoryItem, x:int, y:int):Boolean
        {
            if (itemWillFitAtLocation(item, x, y))
            {
                var old_receiver:InventoryReceiver = InventoryReceiver(item.getParent());
                
                if (old_receiver)
                    old_receiver.removeItem(item);
                
                item.setLocationOnReceiver(x, y);
                writeItemToContentMap(item);
                addChildWindow(item);
                
                // set position and size.  This ensures the items visually match the
                // logical content map.
                
                
                item.setPosition(new UVector2(
                    new UDim(Number(x) / contentWidth(), 0),
                    new UDim(Number(y) / contentHeight(), 0)));
                item.setSize(new UVector2(
                    new UDim(Number(item.contentWidth()) / contentWidth(), 0),
                    new UDim(Number(item.contentHeight()) / contentHeight(), 0)));
                
                return true;
            }
            return false;
        }
        
        // removes the given item.
        public function removeItem(item:InventoryItem):void
        {
            if (item.getParent() != this ||
                item.locationOnReceiverX() == -1 ||
                item.locationOnReceiverY() == -1)
                return;
            
            eraseItemFromContentMap(item);
            item.setLocationOnReceiver(-1, -1);
            removeChildWindow(item);
        }
        
        // write the item's layout data into the content map.
        protected function writeItemToContentMap(item:InventoryItem):void
        {
            if (item.locationOnReceiverX() == -1 || item.locationOnReceiverY() == -1)
                return;
            
            for (var y:int = 0; y < item.contentHeight(); ++y)
            {
                const map_y:int = item.locationOnReceiverY() + y;
                
                for (var x:int = 0; x < item.contentWidth(); ++x)
                {
                    const map_x:int = item.locationOnReceiverX() + x;
                    
                    var val:Boolean = d_content.elementAtLocation(map_x, map_y) ||
                        item.isSolidAtLocation(x, y);
                    d_content.setElementAtLocation(map_x, map_y, val);
                }
            }
            
            invalidate();
        }
        // erase the item's layout data from the content map.
        protected function eraseItemFromContentMap(item:InventoryItem):void
        {
            if (item.locationOnReceiverX() == -1 || item.locationOnReceiverY() == -1)
                return;
            
            for (var y:int = 0; y < item.contentHeight(); ++y)
            {
                const map_y:int = item.locationOnReceiverY() + y;
                
                for (var x:int = 0; x < item.contentWidth(); ++x)
                {
                    const map_x:int = item.locationOnReceiverX() + x;
                    
                    var val:Boolean = d_content.elementAtLocation(map_x, map_y) &&
                        !item.isSolidAtLocation(x, y);
                    d_content.setElementAtLocation(map_x, map_y, val);
                }
            }
            
            invalidate();
        }
            
        
        // base class overrides
        override protected function onDragDropItemDropped(e:DragDropEventArgs):void
        {
            var item:InventoryItem = InventoryItem(e.dragDropItem);
            
            if (!item)
                return;
            
            const square_size:Size = squarePixelSize();
            
            var item_area:Rect = item.getUnclippedOuterRect();
            item_area.offset(new Vector2(square_size.d_width / 2, square_size.d_height / 2));
            
            const drop_x:int = gridXLocationFromPixelPosition(item_area.d_left);
            const drop_y:int = gridYLocationFromPixelPosition(item_area.d_top);
            
            addItemAtLocation(item, drop_x, drop_y);
        }
        
        override protected function populateGeometryBuffer():void
        {
            if (!isUserStringDefined("BlockImage"))
                return;
            
            const img:FlameImage = FlamePropertyHelper.stringToImage(getUserString("BlockImage"));
            
            if (!img)
                return;
            
            const square_size:Size = squarePixelSize();
            
            for (var y:int = 0; y < d_content.height(); ++y)
            {
                for (var x:int = 0; x < d_content.width(); ++x)
                {
                    var col:uint = 0xFFFFFFFF;
                    if (d_content.elementAtLocation(x, y))
                        col = 0xFF0000FF;
                    
                    var colour:Colour = Colour.fromUint(col);
                    img.draw(d_geometry,
                        new Vector2(x * square_size.d_width + 1, y * square_size.d_height + 1),
                        new Size(square_size.d_width - 2, square_size.d_height - 2), null,
                        colour, colour, colour, colour);
                }
            }
        }
        
        protected function gridBasePixelRect():Rect
        {
            return getChildWindowContentArea();
        }
        
        // return the width of the content grid, in grid squares.
        public function contentWidth():int
        {
            return d_content.width();
        }
        
        // return the height of the content grid, in grid squares.
        public function contentHeight():int
        {
            return d_content.height();
        }
        
        // returns the pixel size of a single square in the content grid.
        public function squarePixelSize():Size
        {
            const area:Rect = gridBasePixelRect();
            return new Size(area.getWidth() / d_content.width(),
                area.getHeight() / d_content.height());
        }
        
        // return the grid x co-ordinate that corresponds to the given screen
        // pixel co-ordinate.
        public function gridXLocationFromPixelPosition(x_pixel_location:Number):int
        {
            const area:Rect = gridBasePixelRect();
            
            if (x_pixel_location < int(area.d_left) ||
                x_pixel_location >= int(area.d_right))
                return -1;
            
            return (x_pixel_location - int(area.d_left)) / (area.getWidth() / d_content.width());
        }
        
        // return the grid y co-ordinate that corresponds to the given screen
        // pixel co-ordinate.
        public function gridYLocationFromPixelPosition(y_pixel_location:Number):int
        {
            const area:Rect = gridBasePixelRect();
            
            if (y_pixel_location < int(area.d_top) ||
                y_pixel_location >= int(area.d_bottom))
                return -1;
            
            return (y_pixel_location - int(area.d_top)) / (area.getHeight() / d_content.height());
        }
        
        // set the size of the content grid and initialise it.
        public function setContentSize(width:int, height:int):void
        {
            d_content.resetSize(width, height);
        }
        
    }
}