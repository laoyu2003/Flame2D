/***************************************************************************
 *   Copyright (C) 2004 - 2010 Paul D Turner & The CEGUI Development Team
 *
 *   Porting to Flash Stage3D
 *   Copyright (C) 2012 Mingjian Yu(laoyu20032003@hotmail.com)
 *
 *   Permission is hereby granted, free of charge, to any person obtaining
 *   a copy of this software and associated documentation files (the
 *   "Software"), to deal in the Software without restriction, including
 *   without limitation the rights to use, copy, modify, merge, publish,
 *   distribute, sublicense, and/or sell copies of the Software, and to
 *   permit persons to whom the Software is furnished to do so, subject to
 *   the following conditions:
 *
 *   The above copyright notice and this permission notice shall be
 *   included in all copies or substantial portions of the Software.
 *
 *   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 *   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 *   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 *   IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 *   OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 *   ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 *   OTHER DEALINGS IN THE SOFTWARE.
 ***************************************************************************/
package Flame2D.core.system
{
    import flash.utils.Dictionary;

    /*!
    \brief
    A class that manages the creation of, access to, and destruction of GUI
    Scheme objects
    */
    public class FlameSchemeManager
    {
        //parsed contents
//        private var _windowSetFileName:String;
//        private var _windowRendererSet:String;
//        private var _windowAlias:Dictionary = new Dictionary();
//        private var _lookNFeelsInfo:Vector.<LookNFeelInfo> = new Vector.<LookNFeelInfo>();
//        private var _fontsInfo:Vector.<FontInfo> = new Vector.<FontInfo>();
//        private var _falagardMappingsInfo:Vector.<FalagardMappingInfo> = new Vector.<FalagardMappingInfo>();
//        private var _imageSetsInfo:Vector.<ImageSetInfo> = new Vector.<ImageSetInfo>();
        
        
        //d_objects[name] = FlameScheme
        private var d_objects:Dictionary = new Dictionary();
        

        private static var d_singleton:FlameSchemeManager = new FlameSchemeManager();
        
        public function FlameSchemeManager()
        {
            if(d_singleton){
                throw new Error("FlameSchemeManager: init only once");
            }
        }
        
        public static function getSingleton():FlameSchemeManager
        {
            return d_singleton;
        }
        
        public function create(name:String, callback:Function):void
        {
            var scheme:FlameScheme = new FlameScheme(name, "", callback);
            scheme.loadResources();
            
            //add for management
            d_objects[name] = scheme;
        }
        
        
        // override from base
        public function doPostObjectAdditionAction(obj:FlameScheme):void
        {
            
        }
    }
}



