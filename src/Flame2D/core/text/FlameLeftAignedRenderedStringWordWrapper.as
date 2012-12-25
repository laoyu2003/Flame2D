

package Flame2D.core.text
{
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.Vector2;
    import Flame2D.renderer.FlameGeometryBuffer;
    
    /*!
    \brief
    FormattedRenderedString implementation that renders the RenderedString with
    left aligned formatting.
    */
    public class FlameLeftAignedRenderedStringWordWrapper extends FlameFormattedRenderedString
    {
     
        //! type of collection used to track the formatted lines.
        //typedef std::vector<FormattedRenderedString*> LineList;
        //! collection of lines.
        //LineList d_lines;
        protected var d_lines:Vector.<FlameFormattedRenderedString> = new Vector.<FlameFormattedRenderedString>();
        
        //! Constructor.
        public function FlameLeftAignedRenderedStringWordWrapper(rs:FlameRenderedString)
        {
            super(rs);
        }
        
        // implementation of base interface
        override public function format(area_size:Size):void
        {
            deleteFormatters();
            
            var rstring:FlameRenderedString = d_renderedString;
            var rs_width:Number;
            
            var frs:FlameLeftAlignedRenderedString;
            
            for (var line:uint = 0; line < rstring.getLineCount(); ++line)
            {
                while ((rs_width = rstring.getPixelSize(line).d_width) > 0)
                {
                    // skip line if no wrapping occurs
                    if (rs_width <= area_size.d_width)
                        break;

                    // split rstring at width into lstring and remaining rstring
                    var lstring:FlameRenderedString = new FlameRenderedString();
                    rstring.split(line, area_size.d_width, lstring);
                    frs = new FlameLeftAlignedRenderedString(lstring);
                    frs.format(area_size);
                    d_lines.push(frs);
                    line = 0;
                }
            }
            
            // last line.
            frs = new FlameLeftAlignedRenderedString(rstring);
            frs.format(area_size);
            d_lines.push(frs);
        }
        
        override public function draw(buffer:FlameGeometryBuffer, position:Vector2,
                                      mod_colours:ColourRect, clip_rect:Rect):void
        {
//            var draw_pos:Vector2 = position.clone();
//            
//            for (var i:uint = 0; i < d_renderedString.getLineCount(); ++i)
//            {
//                d_renderedString.draw(i, buffer, draw_pos, mod_colours, clip_rect, 0.0);
//                draw_pos.d_y += d_renderedString.getPixelSize(i).d_height;
//            }
            
            var line_pos:Vector2 = position.clone();
            for (var i:uint=0; i < d_lines.length; i++)
            {
                d_lines[i].draw(buffer, line_pos, mod_colours, clip_rect);
                line_pos.d_y += d_lines[i].getVerticalExtent();
            }
        }
        
        override public function getFormattedLineCount():uint
        {
//            return d_renderedString.getLineCount();
            return d_lines.length;
        }
        
        override public function getHorizontalExtent():Number
        {
//            var w:Number = 0.0;
//            for (var i:uint = 0; i < d_renderedString.getLineCount(); ++i)
//            {
//                const this_width:Number = d_renderedString.getPixelSize(i).d_width;
//                if (this_width > w)
//                    w = this_width;
//            }
//            
//            return w;
            
            var w:Number = 0;
            for (var i:uint=0; i < d_lines.length; i++)
            {
                const cur_width:Number = d_lines[i].getHorizontalExtent();
                if (cur_width > w)
                    w = cur_width;
            }
            
            return w;
        }
        
        override public function getVerticalExtent():Number
        {
//            var h:Number = 0.0;
//            for (var i:uint = 0; i < d_renderedString.getLineCount(); ++i)
//                h += d_renderedString.getPixelSize(i).d_height;
//            
//            return h;
            var h:Number = 0;
            for (var i:uint=0; i < d_lines.length; i++)
                h += d_lines[i].getVerticalExtent();
            
            return h;
        }
        
        protected function deleteFormatters():void
        {
            for (var i:uint = 0; i < d_lines.length; ++i)
            {
                // get the rendered string back from rthe formatter
                var rs:FlameRenderedString = d_lines[i].getRenderedString();
                // delete the formatter
                d_lines[i] = null;
                // delete the rendered string.
                rs = null;
            }
            
            d_lines.length = 0;
        }
    }
}