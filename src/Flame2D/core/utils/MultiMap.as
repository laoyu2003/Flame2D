/*
The MIT License

Copyright (c) 2011 Jackson Dunstan

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
package Flame2D.core.utils
{
    import flash.utils.Dictionary;
    
    /**
     *   A collection that maps keys to one or more values
     *   @author Jackson Dunstan, http://JacksonDunstan.com
     */
    public class MultiMap
    {
        /** If the keys of the map are weakly-referenced */
        private var __weakKeys:Boolean;
        
        /** Mapping of keys to Dictionaries of values */
        private var __keys:Dictionary;
        
        /**
         *   Make the map
         *   @param weakKeys If the keys of the map are weakly-referenced.
         *                   Defaults to false.
         */
        public function MultiMap(weakKeys:Boolean=false)
        {
            __keys = new Dictionary(weakKeys);
            __weakKeys = weakKeys;
        }
        
        /**
         *   If the keys of the map are weakly-referenced
         */
        public function get weakKeys(): Boolean
        {
            return __weakKeys;
        }
        
        /**
         *   Mapping of keys to Dictionaries of values. Beware changing this.
         */
        public function get keys(): Dictionary
        {
            return __keys;
        }
        
        /**
         *   If the map has no keys (or values)
         */
        public function get isEmpty(): Boolean
        {
            for (var key:* in __keys)
            {
                return false;
            }
            return true;
        }
        
        /**
         *   Map a key to a value. Overwrites any previous mapping of the given
         *   key and value.
         *   @param key Key to map to the given value
         *   @param val Value to map to the given key
         */
        public function insertVal(key:*, val:*): void
        {
            var vals:Dictionary = __keys[key];
            if (!vals)
            {
                vals = __keys[key] = new Dictionary();
            }
            vals[val] = true;
        }
        
        /**
         *   Map a key to many values. Overwrites any previous mapping of the
         *   given and values.
         *   @param key Key to map to the given values
         *   @param vals Values to map to the given key
         */
        public function insertVals(key:*, ...vals): void
        {
            var valsDict:Dictionary = __keys[key];
            if (!valsDict)
            {
                valsDict = __keys[key] = new Dictionary();
            }
            for each (var val:* in vals)
            {
                valsDict[val] = true;
            }
        }
        
        /**
         *   Map the keys of the given object to their values. For example,
         *   {first:"Jackson", last:"Dunstan"} maps "first" to "Jackson" and
         *   "last" to "Dunstan". Overwrites any previous mapping of the given
         *   object's keys and values.
         *   @param obj Object whose properties should be mapped
         */
        public function insertProperties(obj:*): void
        {
            for (var key:* in obj)
            {
                var vals:Dictionary = __keys[key];
                if (!vals)
                {
                    vals = __keys[key] = new Dictionary();
                }
                vals[obj[key]] = true;
            }
        }
        
        /**
         *   Get the values mapped to a given key. Beware changing this.
         *   @param key Key to get values for
         *   @return The values mapped to the given key or null if no values are
         *           mapped to the given key.
         */
        public function getVals(key:*): Dictionary
        {
            return __keys[key];
        }
        
        /**
         *   Check if a key has had values mapped to it
         *   @param key Key to check
         *   @return If the given key has had values mapped to it
         */
        public function hasKey(key:*): Boolean
        {
            return key in __keys;
        }
        
        /**
         *   Check if any key has been mapped to a given value
         *   @param val Value to check
         *   @return If any key has been mapped to a given value
         */
        public function hasVal(val:*): Boolean
        {
            var keys:Dictionary = __keys;
            for (var key:* in keys)
            {
                if (val in keys[key])
                {
                    return true;
                }
            }
            return false;
        }
        
        /**
         *   Check if the given key has been mapped to the given value
         *   @param key Key to check
         *   @param val Value to check
         *   @return If the given key has been mapped to the given value
         */
        public function hasPair(key:*, val:*): Boolean
        {
            var vals:Dictionary = __keys[key];
            if (!vals)
            {
                return false;
            }
            return val in vals;
        }
        
        /**
         *   Unmap the given key and all values mapped to it
         *   @param key Key to unmap
         */
        public function removeKey(key:*): void
        {
            delete __keys[key];
        }
        
        /**
         *   Unmap the given value from all keys
         *   @param val Value to unmap
         */
        public function removeVal(val:*): void
        {
            var keys:Dictionary = __keys;
            for (var key:* in keys)
            {
                var vals:Dictionary = keys[key];
                delete vals[val];
                
                // If the key is no longer mapped to any vals, remove it
                var empty:Boolean = true;
                for (var value:* in vals)
                {
                    empty = false;
                }
                if (empty)
                {
                    delete keys[key];
                }
            }
        }
        
        /**
         *   Unmap the given key-value pair
         *   @param key Key to unmap
         *   @param val Value to unmap
         */
        public function removePair(key:*, val:*): void
        {
            var vals:Dictionary = __keys[key];
            if (vals)
            {
                delete vals[val];
                
                // If the key is no longer mapped to any vals, remove it
                var empty:Boolean = true;
                for (var value:* in vals)
                {
                    empty = false;
                }
                if (empty)
                {
                    delete keys[key];
                }
            }
        }
        
        /**
         *   Unmap all keys and values
         *   @param key Key to unmap
         *   @param val Value to unmap
         */
        public function removeAll(): void
        {
            var keys:Dictionary = __keys;
            for (var key:* in keys)
            {
                delete keys[key];
            }
        }
        
        /**
         *   Count the number of keys in the map
         *   @return The number of keys in the map
         */
        public function countKeys(): uint
        {
            var count:uint;
            for (var key:* in __keys)
            {
                count++;
            }
            return count;
        }
        
        /**
         *   Count the number of values in the map for the given key
         *   @param key Key whose values should be counted
         *   @return The number of keys in the map for the given key or zero if
         *           the given key is not mapped
         */
        public function countVals(key:*): uint
        {
            var count:uint;
            for (var key:* in __keys[key])
            {
                count++;
            }
            return count;
        }
        
        /**
         *   Count the number of values in the map for all keys
         *   @return The number of keys in the map for all keys
         */
        public function countAllVals(): uint
        {
            var count:uint;
            for (var key:* in __keys)
            {
                var vals:Dictionary = keys[key];
                for (var val:* in vals)
                {
                    count++;
                }
            }
            return count;
        }
        
        /**
         *   Make a new map that has the same mappings and key strength
         *   (i.e. weak keys, strong keys) as this map
         *   @return A new map that has the same mappings and key strength as
         *           this map
         */
        public function clone(): MultiMap
        {
            var ret:MultiMap = new MultiMap(__weakKeys);
            var keys:Dictionary = __keys;
            for (var key:* in keys)
            {
                var vals:Dictionary = keys[key];
                for (var val:* in vals)
                {
                    ret.insertVal(key, val);
                }
            }
            return ret;
        }
        
        /**
         *   Get a new String that shows the mappings
         *   @return A new String that shows the mappings
         */
        public function toMapString(): String
        {
            var ret:String = "";
            var keys:Dictionary = __keys;
            for (var key:* in keys)
            {
                ret += key + "\n";
                var vals:Dictionary = keys[key];
                for (var val:* in vals)
                {
                    ret += "\t-> " + val + "\n";
                }
            }
            return ret;
        }
    }
}