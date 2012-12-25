

package Flame2D.core.text
{
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.system.FlameFont;

    /*!
    \brief
    Effectively a 'null' parser that returns a RenderedString representation
    that will draw the input text verbatim.
    */
    public class FlameDefaultRenderedStringParser extends FlameRenderedStringParser
    {
        // implement required interface
        override public function parse(input_string:String, initial_font:FlameFont, initial_colours:ColourRect):FlameRenderedString
        {
            var rs:FlameRenderedString = new FlameRenderedString();
            
            var epos:int, spos:int = 0;
            
            while ((epos = input_string.indexOf('\n', spos)) != -1)
            {
                appendSubstring(rs, input_string.substr(spos, epos - spos),
                    initial_font, initial_colours);
                rs.appendLineBreak();
                
                // set new start position (skipping the previous \n we found)
                spos = epos + 1;
            }
            
            if (spos < input_string.length)
                appendSubstring(rs, input_string.substr(spos),
                    initial_font, initial_colours);
            
            return rs;
        }
        
        protected function appendSubstring(rs:FlameRenderedString,
            str:String,
            initial_font:FlameFont,
            initial_colours:ColourRect):void
        {
            var rstc:FlameRenderedStringTextComponent = new FlameRenderedStringTextComponent();
            rstc.setText(str);
            rstc.setFont(initial_font);
            
            if (initial_colours)
                rstc.setColours(initial_colours);
            
            rs.appendComponent(rstc);
        }
    }
}