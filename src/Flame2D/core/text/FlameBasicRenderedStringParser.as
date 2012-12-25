
package Flame2D.core.text
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameFont;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.TextUtils;
    
    import flash.utils.Dictionary;

    /*!
    \brief
    Basic RenderedStringParser class that offers support for the following tags:
    - 'colour' value is a CEGUI colour property value.
    - 'font' value is the name of a font.
    - 'image' value is a CEGUI image property value.
    - 'window' value is the name of a window.
    - 'vert-alignment' value is either top, bottom, centre or stretch.
    - 'padding' value is a CEGUI Rect property value.
    - 'top-padding' value is a float.
    - 'bottom-padding' value is a float.
    - 'left-padding' value is a float.
    - 'right-padding' value is a float.
    - 'image-size' value is a CEGUI size property value.
    - 'image-width' value is a float.
    - 'image-height' value is a float.
    - 'aspect-lock' value is a boolean (NB: this currently has no effect).
    */
    public class FlameBasicRenderedStringParser extends FlameRenderedStringParser
    {
        
        private static const ColourTagName:String = "colour";
        private static const FontTagName:String = "font";
        private static const ImageTagName:String = "image";
        private static const WindowTagName:String = "window";
        private static const VertAlignmentTagName:String = "vert-alignment";
        private static const PaddingTagName:String = "padding";
        private static const TopPaddingTagName:String = "top-padding";
        private static const BottomPaddingTagName:String = "bottom-padding";
        private static const LeftPaddingTagName:String = "left-padding";
        private static const RightPaddingTagName:String = "right-padding";
        private static const AspectLockTagName:String = "aspect-lock";
        private static const ImageSizeTagName:String = "image-size";
        private static const ImageWidthTagName:String = "image-width";
        private static const ImageHeightTagName:String = "image-height";
        private static const TopAlignedValueName:String = "top";
        private static const BottomAlignedValueName:String = "bottom";
        private static const CentreAlignedValueName:String = "centre";
        private static const StretchAlignedValueName:String = "stretch";
        
        
        //! initial font name
        protected var d_initialFontName:String = "";
        //! initial colours
        protected var d_initialColours:ColourRect;
        //! active padding values.
        protected var d_padding:Rect;
        //! active colour values.
        protected var d_colours:ColourRect;
        //! active font.
        protected var d_fontName:String = "";
        //! active vertical alignment
        protected var d_vertAlignment:uint;
        //! active image size
        protected var d_imageSize:Size;
        //! active 'aspect lock' state
        protected var d_aspectLock:Boolean;
        
        //! true if handlers have been registered
        protected var d_initialised:Boolean;
        //! definition of type used for handler functions
        //typedef void (BasicRenderedStringParser::*TagHandler)(RenderedString&,const String&);
        //! definition of type used to despatch tag handler functions
        //typedef std::map<String, TagHandler, String::FastLessCompare> TagHandlerMap;
        //! Collection to map tag names to their handler functions.
        //TagHandlerMap d_tagHandlers;
        protected var d_tagHandlers:Dictionary = new Dictionary();
        
        /*!
        \brief
        Initialising constructor.
        
        \param initial_font
        Reference to a String holding the name of the initial font to be used.
        
        \param initial_colours
        Reference to a ColourRect describing the initial colours to be used.
        */
        public function FlameBasicRenderedStringParser(initial_font:String = "", initial_colours:ColourRect = null)
        {
            d_initialFontName = initial_font;
            d_initialColours = initial_colours;
            if(!d_initialColours) d_initialColours = new ColourRect();
            d_vertAlignment = Consts.VerticalFormatting_VF_BOTTOM_ALIGNED;
            d_imageSize = new Size(0,0);
            d_aspectLock = false;
            d_initialised = false;

            initialiseDefaultState();
        }

        
        
        
        /*!
        \brief
        set the initial font name to be used on subsequent calls to parse.
        
        \param font_name
        String object holding the name of the font.
        */
        public function setInitialFontName(font_name:String):void
        {
            d_initialFontName = font_name;
        }
        
        /*!
        \brief
        Set the initial colours to be used on subsequent calls to parse.
        
        \param colours
        ColourRect object holding the colours.
        */
        public function setInitialColours(colours:ColourRect):void
        {
            d_initialColours = colours;
        }
        
        /*!
        \brief
        Return the name of the initial font used in each parse.
        */
        public function getInitialFontName():String
        {
            return d_initialFontName;
        }
        
        /*!
        \brief
        Return a ColourRect describing the initial colours used in each parse.
        */
        public function getInitialColours():ColourRect
        {
            return d_initialColours;
        }
        
        // implement required interface from RenderedStringParser
        override public function parse(input_string:String, initial_font:FlameFont, 
                                      initial_colours:ColourRect):FlameRenderedString
        {
            // first-time initialisation (due to issues with static creation order)
            if (!d_initialised)
                initialiseTagHandlers();
            
            initialiseDefaultState();
            
            // maybe override initial font.
            if (initial_font)
                d_fontName = initial_font.getName();
            
            // maybe override initial colours.
            if (initial_colours)
                d_colours = initial_colours.clone();
            
            var rs:FlameRenderedString = new FlameRenderedString();
            var curr_section:String = "";
            
            var curr_pos:uint = 0;
            
            while (curr_pos < input_string.length)
            {
                var cstart_pos:int = TextUtils.find_first_of(input_string, '[', curr_pos);
                
                // if no control sequence start char, add remaining text verbatim.
                if (cstart_pos == -1)
                {
                    curr_section += input_string.substr(curr_pos);
                    curr_pos = input_string.length;
                }
                else if (cstart_pos == curr_pos || input_string.charAt(cstart_pos - 1) != '\\')
                {
                    // append everything up to the control start to curr_section.
                    curr_section += input_string.substr(curr_pos, cstart_pos - curr_pos);
                    
                    // scan forward for end of control sequence
                    var cend_pos:int = TextUtils.find_first_of(input_string, ']', cstart_pos);
                    // if not found, treat as plain text
                    if (cend_pos == -1)
                    {
                        curr_section += input_string.substr(curr_pos);
                        curr_pos = input_string.length;
                    }
                        // extract control string
                    else
                    {
                        appendRenderedText(rs, curr_section);
                        curr_section = "";
                        
                        var ctrl_string:String = 
                            input_string.substr(cstart_pos + 1,
                                cend_pos - cstart_pos - 1);
                        curr_pos = cend_pos + 1;
                        
                        processControlString(rs, ctrl_string);
                        continue;
                    }
                }
                else
                {
                    curr_section += input_string.substr(curr_pos,
                        cstart_pos - curr_pos - 1);
                    curr_section += '[';
                    curr_pos = cstart_pos + 1;
                    continue;
                }
                
                appendRenderedText(rs, curr_section);
                curr_section = "";
            }
            
            return rs;
        }
        
        //! append the text string \a text to the RenderedString \a rs.
        protected function appendRenderedText(rs:FlameRenderedString, text:String):void
        {
            var cpos:int = 0;
            // split the given string into lines based upon the newline character
            while (text.length > cpos)
            {
                // find next newline
                const nlpos:int = text.indexOf('\n', cpos);
                // calculate length of this substring
                const len:int =
                    ((nlpos != -1) ? nlpos : text.length) - cpos;
                
                // construct new text component and append it.
                if (len > 0)
                {
                    var rtc:FlameRenderedStringTextComponent = new FlameRenderedStringTextComponent(text.substr(cpos, len), d_fontName);
                    rtc.setPadding(d_padding.clone());
                    rtc.setColours(d_colours.clone());
                    rtc.setVerticalFormatting(d_vertAlignment);
                    rtc.setAspectLock(d_aspectLock);
                    rs.appendComponent(rtc);
                }
                
                // break line if needed
                if (nlpos != -1)
                    rs.appendLineBreak();
                
                // advance current position.  +1 to skip the \n char
                cpos += len + 1;
            }
        }
        
        //! Process the control string \a ctrl_str.
        protected function processControlString(rs:FlameRenderedString, ctrl_str:String):void
        {
            // all our default strings are of the form <var> = <val>
            // so do a quick check for the = char and abort if it's not there.
            if (ctrl_str.indexOf('=') == -1)
            {
                trace(
                    "BasicRenderedStringParser::processControlString: unable to make " +
                    "sense of control string '" + ctrl_str + "'.  Ignoring!");
                
                return;
            }
            
//            char var_buf[128];
//            char val_buf[128];
//            sscanf(ctrl_str.c_str(), " %127[^ =] = '%127[^']", var_buf, val_buf);
//            
//            const String var_str(var_buf);
//            const String val_str(val_buf);
//            
            var arr:Array = ctrl_str.split('=');
            Misc.assert(arr.length == 2);
            var var_str:String = arr[0];
            var val_str:String = (arr[1] as String).replace(/^'|'$/g, "");
//            // look up handler function
//            TagHandlerMap::iterator i = d_tagHandlers.find(var_str);
//            // despatch handler, or log error
//            if (i != d_tagHandlers.end())
//                (this->*(*i).second)(rs, val_str);
//            else
//            Logger::getSingleton().logEvent(
//                "BasicRenderedStringParser::processControlString: unknown "
//                "control variable '" + var_str + "'.  Ignoring!");
            if(d_tagHandlers.hasOwnProperty(var_str))
            {
                (d_tagHandlers[var_str] as Function)(rs, val_str);
            }
            else
            {
                trace("BasicRenderedStringParser::processControlString: unknown " +
                    "control variable '" + var_str + "'.  Ignoring!");
            }
        }
        
        //! initialise the default state
        protected function initialiseDefaultState():void
        {
            d_padding = new Rect();
            d_colours = d_initialColours;
            d_fontName = d_initialFontName;
            d_imageSize.d_width = d_imageSize.d_height = 0.0;
            d_vertAlignment = Consts.VerticalFormatting_VF_BOTTOM_ALIGNED;
            d_aspectLock = false;
        }
        
        //! initialise tag handlers
        protected function initialiseTagHandlers():void
        {
            d_tagHandlers[ColourTagName] = handleColour;
            d_tagHandlers[FontTagName] = handleFont;
            d_tagHandlers[ImageTagName] = handleImage;
            d_tagHandlers[WindowTagName] = handleWindow;
            d_tagHandlers[VertAlignmentTagName] = handleVertAlignment;
            d_tagHandlers[PaddingTagName] = handlePadding;
            d_tagHandlers[TopPaddingTagName] = handleTopPadding;
            d_tagHandlers[BottomPaddingTagName] = handleBottomPadding;
            d_tagHandlers[LeftPaddingTagName] = handleLeftPadding;
            d_tagHandlers[RightPaddingTagName] = handleRightPadding;
            d_tagHandlers[AspectLockTagName] = handleAspectLock;
            d_tagHandlers[ImageSizeTagName] = handleImageSize;
            d_tagHandlers[ImageWidthTagName] = handleImageWidth;
            d_tagHandlers[ImageHeightTagName] = handleImageHeight;
            
            d_initialised = true;
        }
        
        //! handlers for the various tags supported
        protected function handleColour(rs:FlameRenderedString, value:String):void
        {
            d_colours.setColours(FlamePropertyHelper.stringToColour(value));
        }
        
        protected function handleFont(rs:FlameRenderedString, value:String):void
        {
            d_fontName = value;
        }
        
        protected function handleImage(rs:FlameRenderedString, value:String):void
        {
            var ric:FlameRenderedStringImageComponent = new FlameRenderedStringImageComponent(FlamePropertyHelper.stringToImage(value));
            ric.setPadding(d_padding.clone());
            ric.setColours(d_colours.clone());
            ric.setVerticalFormatting(d_vertAlignment);
            ric.setSize(d_imageSize.clone());
            ric.setAspectLock(d_aspectLock);
            rs.appendComponent(ric);
        }
        
        protected function handleWindow(rs:FlameRenderedString, value:String):void
        {
            var rwc:FlameRenderedStringWidgetComponent = new FlameRenderedStringWidgetComponent(FlameWindowManager.getSingleton().getWindow(value));
            rwc.setPadding(d_padding.clone());
            rwc.setVerticalFormatting(d_vertAlignment);
            rwc.setAspectLock(d_aspectLock);
            rs.appendComponent(rwc);
        }
        
        protected function handleVertAlignment(rs:FlameRenderedString, value:String):void
        {
            if (value == TopAlignedValueName)
                d_vertAlignment = Consts.VerticalFormatting_VF_TOP_ALIGNED;
            else if (value == BottomAlignedValueName)
                d_vertAlignment = Consts.VerticalFormatting_VF_BOTTOM_ALIGNED;
            else if (value == CentreAlignedValueName)
                d_vertAlignment = Consts.VerticalFormatting_VF_CENTRE_ALIGNED;
            else if (value == StretchAlignedValueName)
                d_vertAlignment = Consts.VerticalFormatting_VF_STRETCHED;
            else
                trace("BasicRenderedStringParser::handleVertAlignment: unknown " +
                    "vertical alignment '" + value + "'.  Ignoring!");
        }
        
        protected function handlePadding(rs:FlameRenderedString, value:String):void
        {
            d_padding = FlamePropertyHelper.stringToRect(value);
        }
        
        protected function handleTopPadding(rs:FlameRenderedString, value:String):void
        {
            d_padding.d_top = FlamePropertyHelper.stringToFloat(value);    
        }
        
        protected function handleBottomPadding(rs:FlameRenderedString, value:String):void
        {
            d_padding.d_bottom = FlamePropertyHelper.stringToFloat(value);
        }
        
        protected function handleLeftPadding(rs:FlameRenderedString, value:String):void
        {
            d_padding.d_left = FlamePropertyHelper.stringToFloat(value);
        }
        
        protected function handleRightPadding(rs:FlameRenderedString, value:String):void
        {
            d_padding.d_right = FlamePropertyHelper.stringToFloat(value);
        }
        
        protected function handleAspectLock(rs:FlameRenderedString, value:String):void
        {
            d_aspectLock = FlamePropertyHelper.stringToBool(value);
        }
        
        protected function handleImageSize(rs:FlameRenderedString, value:String):void
        {
            d_imageSize = FlamePropertyHelper.stringToSize(value);
        }
        
        protected function handleImageWidth(rs:FlameRenderedString, value:String):void
        {
            d_imageSize.d_width = FlamePropertyHelper.stringToFloat(value);
        }
        
        protected function handleImageHeight(rs:FlameRenderedString, value:String):void
        {
            d_imageSize.d_height = FlamePropertyHelper.stringToFloat(value);
        }
        

        
    }
}