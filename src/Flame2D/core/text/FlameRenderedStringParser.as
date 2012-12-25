
package Flame2D.core.text
{
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.system.FlameFont;

    //! Specifies interface for classes that parse text into RenderedString objects.

    public class FlameRenderedStringParser
    {
        /*!
        \brief
        parse a text string and return a RenderedString representation.
        
        \param input_string
        String object holding the text that is to be parsed.
        
        \param initial_font
        Pointer to the initial font to be used for text (0 for system default).
        
        \param initial_colours
        Pointer to the initial colours to be used (0 for default).
        
        \return
        RenderedString object holding the result of the parse operation.
        */
        
        //virtual
        public function parse(input_string:String, initial_font:FlameFont, initial_colours:ColourRect):FlameRenderedString
        {
            return null;
        }
        
    }
}