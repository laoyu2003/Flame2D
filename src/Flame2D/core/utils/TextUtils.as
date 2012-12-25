
package Flame2D.core.utils
{
    public class TextUtils
    {
        /*************************************************************************
         Constants
         *************************************************************************/
        public static const DefaultWhitespace:String = " \n\t\r";      //!< The default set of whitespace
        public static const DefaultAlphanumerical:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";  //!< default set of alphanumericals.
        public static const DefaultWrapDelimiters:String = " \n\t\r";  //!< The default set of word-wrap delimiters
        

        /*************************************************************************
         Data
         *************************************************************************/
        private static  var d_delimiters:String;           //!< Current set of delimiters.
        private static  var d_whitespace:String;           //!< Current set of whitespace.
        
        
        /*************************************************************************
         Methods
         *************************************************************************/
        /*!
        \brief
        return a String containing the the next word in a String.
        
        This method returns a String object containing the the word, starting at index \a start_idx, of String \a str
        as delimited by the code points specified in string \a delimiters (or the ends of the input string).
        
        \param str
        String object containing the input data.
        
        \param start_idx
        index into \a str where the search for the next word is to begin.  Defaults to start of \a str.
        
        \param delimiters
        String object containing the set of delimiter code points to be used when determining the start and end
        points of a word in string \a str.  Defaults to whitespace.
        
        \return
        String object containing the next \a delimiters delimited word from \a str, starting at index \a start_idx.
        */
        public static function getNextWord(str:String, start_idx:uint = 0, delimiters:String = DefaultWhitespace):String
        {
            
            var word_start:int = find_first_not_of(str, delimiters, start_idx);
            
            if (word_start == -1)
            {
                word_start = start_idx;
            }
            
            var word_end:int = find_first_of(str, delimiters, word_start);
            
            if (word_end == -1)
            {
                word_end = str.length;
            }
            
            return str.substr(start_idx, (word_end - start_idx));   
        }
        
        
        /*!
        \brief
        Return the index of the first character of the word at \a idx.
        
        /note
        This currently uses DefaultWhitespace and DefaultAlphanumerical to determine groupings for what constitutes a 'word'.
        
        \param str
        String containing text.
        
        \param idx
        Index into \a str where search for start of word is to begin.
        
        \return
        Index into \a str which marks the begining of the word at index \a idx.
        */
        public static function getWordStartIdx(str:String, idx:int):uint
        {
            var temp:String = str.substr(0, idx);
            
            temp = trimTrailingChars(temp, DefaultWhitespace);
            
            if (temp.length <= 1)
            {
                return 0;
            }
            
            // identify the type of character at 'pos'
            if (DefaultAlphanumerical.indexOf(temp.charAt(temp.length-1)) != -1)
            {
                idx = find_last_not_of(temp, DefaultAlphanumerical);
            }
                // since whitespace was stripped, character must be a symbol
            else
            {
                idx = find_last_of(temp, DefaultAlphanumerical + DefaultWhitespace);
            }
            
            // make sure we do not go past end of string (+1)
            if (idx == -1)
            {
                return 0;
            }
            else
            {
                return idx + 1;
            }
        }
        
        
        /*!
        \brief
        Return the index of the first character of the word after the word at \a idx.
        
        /note
        This currently uses DefaultWhitespace and DefaultAlphanumerical to determine groupings for what constitutes a 'word'.
        
        \param str
        String containing text.
        
        \param idx
        Index into \a str where search is to begin.
        
        \return
        Index into \a str which marks the begining of the word at after the word at index \a idx.
        If \a idx is within the last word, then the return is the last index in \a str.
        */
        public static function getNextWordStartIdx(str:String, idx:uint):uint
        {
            var str_len:uint = str.length;
            
            // do some checks for simple cases
            if ((idx >= str_len) || (str_len == 0))
            {
                return str_len;
            }
            
            // is character at 'idx' alphanumeric
            if (DefaultAlphanumerical.indexOf(str.charAt(idx)) != -1)
            {
                // find position of next character that is not alphanumeric
                idx = find_first_not_of(str, DefaultAlphanumerical, idx);
            }
                // is character also not whitespace (therefore a symbol)
            else if (DefaultWhitespace.indexOf(str.charAt(idx)) == -1)
            {
                // find index of next character that is either alphanumeric or whitespace
                idx = find_first_of(str, DefaultAlphanumerical + DefaultWhitespace, idx);
            }
            
            // check result at this stage.
            if (idx == -1)
            {
                idx = str_len;
            }
            else
            {
                // if character at 'idx' is whitespace
                if (DefaultWhitespace.indexOf(str.charAt(idx)) != -1)
                {
                    // find next character that is not whitespace
                    idx = find_first_not_of(str, DefaultWhitespace, idx);
                }
                
                if (idx == -1)
                {
                    idx = str_len;
                }
                
            }
            
            return idx;
        }
        
        
        /*!
        \brief
        Trim all characters from the set specified in \a chars from the begining of \a str.
        
        \param str
        String object to be trimmed.
        
        \param chars
        String object containing the set of code points to be trimmed.
        */
        public static  function trimLeadingChars(str:String, chars:String):String
        {
            var idx:int = find_first_not_of(str, chars);
            
            if(idx != -1)
            {
                return str.substr(idx);
            }
            else
            {
                return str;
            }
        }
        
        
        /*!
        \brief
        Trim all characters from the set specified in \a chars from the end of \a str.
        
        \param str
        String object to be trimmed.
        
        \param chars
        String object containing the set of code points to be trimmed.
        */
        public static function trimTrailingChars(str:String, chars:String):String
        {
            var idx:int = find_last_not_of(str, chars);
            
            if(idx != -1)
            {
                return str.substr(0, idx+1);
            }
            else 
            {
                return str;
            }
        }
        
        public static function find_first_not_of(str:String, delimiters:String, start:uint = 0):int
        {
            var len:uint = str.length;
            for(var i:uint=start; i < len; i++)
            {
                if(! inSet(str.charAt(i), delimiters))
                {
                    return i;
                }
            }
            
            return -1;
        }
        
        public static function find_last_not_of(str:String, delimiters:String):int
        {
            var len:uint = str.length;
            for(var i:int= len-1; i>=0; i--)
            {
                if(! inSet(str.charAt(i), delimiters))
                {
                    return i;
                }
            }
            
            return -1;
        }
        
        public static function find_first_of(str:String, delimeters:String, start:uint = 0):int
        {
            var len:uint = str.length;
            for(var i:uint = start; i<len; i++)
            {
                if(inSet(str.charAt(i), delimeters))
                {
                    return i;
                }
            }
        
            return -1;
        }
        
        public static function find_last_of(str:String, delimeters:String):int
        {
            var len:uint = str.length;
            for(var i:int = len-1; i>=0; i--)
            {
                if(inSet(str.charAt(i), delimeters))
                {
                    return i;
                }
            }
            
            return -1;
        }
        
        private static function inSet(char:String, chars:String):Boolean
        {
            var len:uint = chars.length;
            for(var i:uint=0; i<len; i++)
            {
                if(chars.charAt(i) == char)
                {
                    return true;
                }
            }
            
            return false;
        }
        
        public static function erase(str:String, start:int, length:int):String
        {
            return str.substring(0, start) + str.substring(start+length);
        }
        
        public static function insertCharcode(str:String, start:int, code:uint):String
        {
            return str.substring(0, start) + String.fromCharCode(code) + str.substring(start);
        }
    }
}