

package Flame2D.core.text
{
    import Flame2D.renderer.FlameGeometryBuffer;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.Vector2;
    
    public class FlameRightAlignedRenderedString extends FlameFormattedRenderedString
    {
        
        protected var d_offsets:Vector.<Number> = new Vector.<Number>();
        
        
        //! Constructor.
        public function FlameRightAlignedRenderedString(rs:FlameRenderedString)
        {
            super(rs);
        }
        
        // implementation of base interface
        override public function format(area_size:Size):void
        {
            d_offsets.length = 0;
            
            for (var i:uint = 0; i < d_renderedString.getLineCount(); ++i)
                d_offsets.push(area_size.d_width - d_renderedString.getPixelSize(i).d_width);
        }
        
        
        override public function draw(buffer:FlameGeometryBuffer, position:Vector2,
                        mod_colours:ColourRect, clip_rect:Rect):void
        {
            var draw_pos:Vector2 = new Vector2();
            draw_pos.d_y = position.d_y;
            
            for (var i:uint = 0; i < d_renderedString.getLineCount(); ++i)
            {
                draw_pos.d_x = position.d_x + d_offsets[i];
                d_renderedString.draw(i, buffer, draw_pos, mod_colours, clip_rect, 0.0);
                draw_pos.d_y += d_renderedString.getPixelSize(i).d_height;
            }
        }
        
        override public function getFormattedLineCount():uint
        {
            return d_renderedString.getLineCount();
        }
        
        override public function getHorizontalExtent():Number
        {
            var w:Number = 0.0;
            for (var i:uint = 0; i < d_renderedString.getLineCount(); ++i)
            {
                const this_width:Number = d_renderedString.getPixelSize(i).d_width;
                if (this_width > w)
                    w = this_width;
            }
            
            return w;
        }
        
        
        override public function getVerticalExtent():Number
        {
            var h:Number = 0.0;
            for (var i:uint = 0; i < d_renderedString.getLineCount(); ++i)
                h += d_renderedString.getPixelSize(i).d_height;
            
            return h;
        }
      
    }
}