
package Flame2D.core.text
{
    public class FlameRegexpMatcher
    {
        //! Copy of the regex string assigned.
        private var d_string:String = "";
        //! Pointer to PCRE compiled RegEx.
        private var d_regexp:RegExp = null;
        
        
        //! Constructor.
        public function FlameRegexpMatcher()
        {
            
        }
        
        // implement required interface
        
        
//        flags:String — The modifiers of the regular expression. These can include the following: 
//        • g — When using the replace() method of the String class, specify this modifier to replace all matches, rather than only the first one. This modifier corresponds to the global property of the RegExp instance.
//        • i — The regular expression is evaluated without case sensitivity. This modifier corresponds to the ignoreCase property of the RegExp instance.
//        • s — The dot (.) character matches new-line characters. Note This modifier corresponds to the dotall property of the RegExp instance.
//        • m — The caret (^) character and dollar sign ($) match before and after new-line characters. This modifier corresponds to the multiline property of the RegExp instance.
//        • x — White space characters in the re string are ignored, so that you can write more readable constructors. This modifier corresponds to the extended property of the RegExp instance.
                            
        public function setRegexString(str:String, flags:String = ""):void
        {
            d_string = str
            
            d_regexp = new RegExp(str, flags);
        }
        
        public function getRegexString():String
        {
            return d_string;
        }
        
        public function matchRegex(str:String):Boolean
        {
            if(d_regexp == null)
            {
                throw new Error("Please set regexp");
            }
            
            return d_regexp.test(str);
        }
        
        

    }
}