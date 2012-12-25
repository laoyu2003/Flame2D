package examples.Inventory
{
    import Flame2D.core.events.DragDropEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.utils.Colour;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.Vector2;
    import Flame2D.elements.dnd.FlameDragContainer;

    public class InventoryItem extends FlameDragContainer implements IInventoryBase
    {
        public static const WidgetTypeName:String = "InventoryItem";
        public static const EventNamespace:String = "InventoryItem";
        
        // whether the current drag / drop target is a valid drop location for this
        // item
        protected var d_validDropTarget:Boolean = false;
        // where our data is on our receivers content map.
        protected var d_receiverLocationX:int = -1;
        // where our data is on our receivers content map.
        protected var d_receiverLocationY:int = -1;
        
        
        // array holding the content grid data.
        protected var d_content:BoolArray2D = new BoolArray2D(0,0);
        
        public function InventoryItem(type:String, name:String)
        {
            super(type, name);
        }
        
        // return whether the specified content location is solid.
        public function isSolidAtLocation(x:int, y:int):Boolean
        {
            return d_content.elementAtLocation(x, y);
        }
        
        // set the content based on the given array.  Input array must
        // hold enough data given the current content size.
        public function setItemLayout(layout:Vector.<Boolean>):void
        {
            var idx:uint = 0;
            for (var y:int = 0; y < d_content.height(); ++y)
            {
                for (var x:int = 0; x < d_content.width(); ++x)
                {
                    d_content.setElementAtLocation(x, y, layout[idx++]);
                }
            }
        }
        
        // return current X grid location on InventoryReceiver.  -1 means
        // invalid / not set.  This is typically set and invalidated by the
        // InventoryReciever::addItemAtLocation and InventoryReciever::removeItem
        // calls respectively.
        public function locationOnReceiverX():int
        {
            return d_receiverLocationX;
        }
        
        // return current Y grid location on InventoryReceiver.  -1 means
        // invalid / not set.  This is typically set and invalidated by the
        // InventoryReciever::addItemAtLocation and InventoryReciever::removeItem
        // calls respectively.
        public function locationOnReceiverY():int
        {
            return d_receiverLocationY;
        }
        
        // set the current grid location.  Note this does not update anything as
        // far as the receiver goes.  You will not normally call this directly, see
        // InventoryReciever::addItemAtLocation instead.
        public function setLocationOnReceiver(x:int, y:int):void
        {
            d_receiverLocationX = x;
            d_receiverLocationY = y;
        }
        
        // returns whether the current drag/drop target is a valid drop location for
        // this InventoryItem.  Only meaningful if isBeingDragged returns true.
        public function currentDropTargetIsValid():Boolean
        {
            return d_validDropTarget;
        }
        
        // base class overrides
        override protected function isHit(position:Vector2, allow_disabled:Boolean = false):Boolean
        {
            if (!super.isHit(position, allow_disabled))
                return false;
            
            var gx:int = gridXLocationFromPixelPosition(position.d_x);
            var gy:int = gridYLocationFromPixelPosition(position.d_y);
            
            if (gx < 0 || gx >= d_content.width() || gy < 0 || gy >= d_content.height())
                return false;
            
            return d_content.elementAtLocation(gx, gy);
        }
        
        public function setContentSize(width:int, height:int):void
        {
            d_content.resetSize(width, height);
            d_content.clear(true);
        }
        
        // base class overrides
        override protected function onMoved(e:WindowEventArgs):void
        {
            invalidate();
            
            super.onMoved(e);
            
            var receiver:InventoryReceiver = d_dropTarget as InventoryReceiver;
            
            if (receiver)
            {
                const square_size:Size = receiver.squarePixelSize();
                var area:Rect = getUnclippedOuterRect();
                area.offset(new Vector2(square_size.d_width / 2, square_size.d_height / 2));
                const x:int = receiver.gridXLocationFromPixelPosition(area.d_left);
                const y:int = receiver.gridYLocationFromPixelPosition(area.d_top);
                
                d_validDropTarget = receiver.itemWillFitAtLocation(this, x, y);
                return;
            }
            
            d_validDropTarget = false;
        }
        
        override protected function onDragDropTargetChanged(e:DragDropEventArgs):void
        {
            super.onDragDropTargetChanged(e);
            d_validDropTarget = (d_dropTarget as InventoryReceiver != null);
            invalidate();
        }
        
        override protected function populateGeometryBuffer():void
        {
            if (!isUserStringDefined("BlockImage"))
                return;
            
            const img:FlameImage = FlamePropertyHelper.stringToImage(getUserString("BlockImage"));
            
            if (!img)
                return;
            
            const square_size:Size = squarePixelSize();
            
            var col:uint = 0xFF00FF00;
            
            if (d_dragging && !currentDropTargetIsValid())
                col = 0xFFFF0000;
            
            var colour:Colour = Colour.fromUint(col);
            
            for (var y:int = 0; y < d_content.height(); ++y)
            {
                for (var x:int = 0; x < d_content.width(); ++x)
                {
                    if (d_content.elementAtLocation(x, y))
                        img.draw(d_geometry,
                            new Vector2(x * square_size.d_width + 1, y * square_size.d_height + 1),
                            new Size(square_size.d_width - 2, square_size.d_height - 2), null,
                            colour, colour, colour, colour);
                }
            }
        }
        
        protected function gridBasePixelRect():Rect
        {
            return getUnclippedOuterRect();
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
        
        // returns the pixel size of a single square in the content grid.
        public function squarePixelSize():Size
        {
            const area:Rect = gridBasePixelRect();
            return new Size(area.getWidth() / d_content.width(),
                area.getHeight() / d_content.height());
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
        

    }
}