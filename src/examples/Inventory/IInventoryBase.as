
package examples.Inventory
{
    import Flame2D.core.utils.Size;

    public interface IInventoryBase
    {
        function squarePixelSize():Size;
        function setContentSize(width:int, height:int):void;
        function contentWidth():int;
        function contentHeight():int;
        function gridXLocationFromPixelPosition(x_pixel_location:Number):int;
        function gridYLocationFromPixelPosition(y_pixel_location:Number):int;
    }
}