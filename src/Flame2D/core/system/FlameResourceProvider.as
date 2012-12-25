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
    
    public class FlameResourceProvider
    {
        
        //resource directory for GUI
        private var RESOURCE_DIR:String     = "../Assets/";
        
        //subdirectories for scheme, imageset, etc....
//        private var SCHEME_DIR:String       = "Scheme/";
//        private var IMAGESET_DIR:String     = "ImageSet/";
//        private var IMAGE_DIR:String        = "Image/";
//        private var LAYOUT_DIR:String       = "Layout/";
//        private var LOOKNFEEL_DIR:String    = "LookNFeel/";
//        private var ANIMATE_DIR:String      = "Animate/";
        
        private var SCHEME_DIR:String       = "schemes/";
        private var IMAGESET_DIR:String     = "imagesets/";
        private var IMAGE_DIR:String        = "imagesets/";
        private var FONT_DIR:String         = "fonts/";
        private var LAYOUT_DIR:String       = "layouts/";
        private var LOOKNFEEL_DIR:String    = "looknfeel/";
        private var ANIMATE_DIR:String      = "animations/";
        private var SOUNDS_DIR:String        = "sounds/";
        //bootstrap file
        //public var SCHEME_FILE:String      = "KGameSkin.scheme.xml";

        private static var _singleton:FlameResourceProvider = null;
        
        public function FlameResourceProvider()
        {
            
        }
        
        public static function getSingleton():FlameResourceProvider
        {
            if(!_singleton){
                _singleton = new FlameResourceProvider();
            }
            
            return _singleton;
        }
        
        public function initialize():void
        {
            //to do
        }
        
        public function setResourceDir(val:String):void
        {
            RESOURCE_DIR = val;
        }
        public function getResourceDir():String
        {
            return RESOURCE_DIR;
        }
        
        public function setSchemeDir(val:String):void
        {
            SCHEME_DIR = val;
        }
        public function getSchemeDir():String
        {
            return SCHEME_DIR;
        }
        
        //------------------------------
        public function setImageSetDir(val:String):void
        {
            IMAGESET_DIR = val;
        }
        public function getImageSetDir():String
        {
            return IMAGESET_DIR;
        }
        
        public function setImageDir(val:String):void
        {
            IMAGE_DIR = val;
        }
        public function getImageDir():String
        {
            return IMAGE_DIR;
        }
        
        public function setFontDir(val:String):void
        {
            FONT_DIR = val;
        }
        public function getFontDir():String
        {
            return FONT_DIR;
        }
        
        
        
        public function setLayoutDir(val:String):void
        {
            LAYOUT_DIR = val;
        }
        public function getLayoutDir():String
        {
            return LAYOUT_DIR;
        }
        
        public function setLookNFeelDir(val:String):void
        {
            LOOKNFEEL_DIR = val;
        }
        public function getLookNFeelDir():String
        {
            return LOOKNFEEL_DIR;
        }
        
        public function setAnimateDir(val:String):void
        {
            ANIMATE_DIR = val;
        }
        public function getAnimateDir():String
        {
            return ANIMATE_DIR;
        }
        
        public function setSoundsDir(val:String):void
        {
            SOUNDS_DIR = val;
        }
        
        public function getSoundsDir():String
        {
            return SOUNDS_DIR;
        }
    }
        
}