
package Flame2D.core.text
{
    import Flame2D.renderer.FlameGeometryBuffer;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.Vector2;
    
    public class FlameJustifiedRenderedString extends FlameFormattedRenderedString
    {
        //! space extra size for each line to achieve justified formatting.
        protected var d_spaceExtras:Vector.<Number> = new Vector.<Number>();

        //! Constructor.
        public function FlameJustifiedRenderedString(rs:FlameRenderedString)
        {
            super(rs);
        }
        
        // implementation of base interface
        override public function format(area_size:Size):void
        {
            d_spaceExtras.length = 0;
            
            for (var i:uint = 0; i < d_renderedString.getLineCount(); ++i)
            {
                const space_count:uint = d_renderedString.getSpaceCount(i);
                const string_width:Number = d_renderedString.getPixelSize(i).d_width;
                
                if ((space_count == 0) || (string_width >= area_size.d_width))
                    d_spaceExtras.push(0.0);
                else
                    d_spaceExtras.push(
                        (area_size.d_width - string_width) / space_count);
            }
        }
        
        
        override public function draw(buffer:FlameGeometryBuffer, position:Vector2,
                            mod_colours:ColourRect, clip_rect:Rect):void
        {
            var draw_pos:Vector2 = position.clone();
            
            for (var i:uint = 0; i < d_renderedString.getLineCount(); ++i)
            {
                d_renderedString.draw(i, buffer, draw_pos, mod_colours, clip_rect,
                    d_spaceExtras[i]);
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
                const this_width:Number = d_renderedString.getPixelSize(i).d_width +
                    d_renderedString.getSpaceCount(i) * d_spaceExtras[i];
                
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