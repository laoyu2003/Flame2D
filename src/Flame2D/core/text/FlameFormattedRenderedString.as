
package Flame2D.core.text
{
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.Vector2;
    import Flame2D.renderer.FlameGeometryBuffer;
    
    public class FlameFormattedRenderedString
    {
        
        //! RenderedString that we handle formatting for.
        protected var d_renderedString:FlameRenderedString;
        
        
        public function FlameFormattedRenderedString(rs:FlameRenderedString = null)
        {
            d_renderedString = rs;
        }

        public function format(area_size:Size):void
        {
            
        }
        
        public function draw(buffer:FlameGeometryBuffer, 
                             position:Vector2,
                             mod_colours:ColourRect,
                             clip_rect:Rect):void
        {
            throw new Error("could not be here");
        }
        public function getFormattedLineCount():uint
        {
            return 0;
        }
        
        public function getHorizontalExtent():Number
        {
            return 0;
        }
        public function getVerticalExtent():Number
        {
            return 0;
        }
        
        //! set the RenderedString.
        public function setRenderedString(str:FlameRenderedString):void
        {
            d_renderedString = str;
        }
            
        public function getRenderedString():FlameRenderedString
        {
            return d_renderedString;
        }
        
    }
}