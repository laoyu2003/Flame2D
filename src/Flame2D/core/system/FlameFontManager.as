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
    import Flame2D.core.fonts.FlamePixmapFont;
    import Flame2D.core.fonts.FlameSystemFont;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.utils.Size;
    import Flame2D.loaders.TextFileLoader;
    
    import flash.utils.Dictionary;

    /*!
    \brief
    Class providing a shared library of Font objects to the system.
    
    The FontManager is used to create, access, and destroy Font objects.  The
    idea is that the FontManager will function as a central repository for Font
    objects used within the GUI system, and that those Font objects can be
    accessed, via a unique name, by any interested party within the system.
    */
    public class FlameFontManager
    {
        //! type of collection used to store and manage objects
        //typedef std::map<String, T*, String::FastLessCompare> ObjectRegistry;
        //! implementation of object destruction.
        //void destroyObject(typename ObjectRegistry::iterator ob);
        //! function to enforce XMLResourceExistsAction policy.
        //T& doExistingObjectAction(const String object_name, T* object,
          //  const XMLResourceExistsAction action);
        //! Function called each time a new object is added to the collection.
        //virtual void doPostObjectAdditionAction(T& object);
        //! String holding the text for the resource type managed.
        //const String d_resourceType;
        //! the collection of objects
        //ObjectRegistry d_objects;
        
        private var d_objects:Dictionary = new Dictionary();
        
        
        private static var d_singleton:FlameFontManager = new FlameFontManager();
        
        
        public function FlameFontManager()
        {
            if(d_singleton){
                throw new Error("FlameFontManager, only used by singleton");
            }
        }
        
        
        public static function getSingleton():FlameFontManager
        {
            return d_singleton;
        }
        
        public function isDefined(name:String):Boolean
        {
            return d_objects.hasOwnProperty(name);
        }
        
        public function getFonts():Dictionary
        {
            return d_objects;
        }
        
//        public function create(fileName:String, resourceGroup:String = "", callback:Function = null):void
//        {
//            //load ".font" file and TTF
//            var url:String = FlameResourceProvider.getSingleton().getResourceDir() + 
//                             FlameResourceProvider.getSingleton().getFontDir() + 
//                             fileName;
//            
//            new TextFileLoader({file:fileName}, url, onFontFileLoaded);
//        }
//        
//        private function onFontFileLoaded(tag:Object, str:String):void
//        {
//            var xml:XML = new XML(str);
//            var node:XML = xml.Font[0];
//            var type:String = node.@Type.toString();
//            if(type == "FreeType")
//            {
//                parseFreeTypeFont(node);
//            }
//            else if(type == "PixmapFont")
//            {
//                parsePixmapFont(node);
//            }
//            else if(type === "SystemFont")
//            {
//                parseSystemFont(node)
//            }
//        }
//        
//        private function parseFreeTypeFont(node:XML):void
//        {
//            var name:String = node.@Name.toString();
//            var fileName:String = node.@Filename.toString();
//            var resourceGroup:String = node.@ResourceGroup.toString();
//            
//            var size:Number = Number(node.@Size.toString());
//            var horzRes:Number = Number(node.@NativeHorzRes.toString());
//            var vertRes:Number = Number(node.@NativeVertRes.toString());
//            var autoScale:Boolean = FlamePropertyHelper.stringToBool(node.@AutoScaled.toString());
//            var antiAlias:Boolean = node.@AntiAlias.toString() == "" ? true :
//                FlamePropertyHelper.stringToBool(node.@AntiAlias.toString());
//
//            createFreeTypeFont(name, size, antiAlias, fileName, resourceGroup, autoScale, horzRes, vertRes);
//        }
//
//        private function parsePixmapFont(node:XML):void
//        {
//            var name:String = node.@Name.toString();
//            var fileName:String = node.@Filename.toString();
//            var resourceGroup:String = node.@ResourceGroup.toString();
//            
//            var horzRes:Number = Number(node.@NativeHorzRes.toString());
//            var vertRes:Number = Number(node.@NativeVertRes.toString());
//            var autoScale:Boolean = FlamePropertyHelper.stringToBool(node.@AutoScaled.toString());
//            
//            createPixmapFont(name, fileName, resourceGroup, autoScale, horzRes, vertRes);
//            
//        }
    
        
        
        //extended by flash
        private function parseSystemFont(node:XML):void
        {
            var name:String = node.@Name.toString();
            var fileName:String = node.@Filename.toString();
            var resourceGroup:String = node.@ResourceGroup.toString();
            
            //font weight
            //font posture
            
            var size:Number = Number(node.@Size.toString());
            var horzRes:Number = Number(node.@NativeHorzRes.toString());
            var vertRes:Number = Number(node.@NativeVertRes.toString());
            var autoScale:Boolean = FlamePropertyHelper.stringToBool(node.@AutoScaled.toString());
            
            createSystemFont(name, size, resourceGroup, autoScale, horzRes, vertRes);
        }
        
        
        public function getFont(name:String):FlameFont
        {
            if(d_objects.hasOwnProperty(name))
            {
                return d_objects[name];
            }

            return null;
        }
        
        
        /*!
        \brief
        Creates a FreeType type font.
        
        \param font_name
        The name that the font will use within the CEGUI system.
        
        \param point_size
        Specifies the point size that the font is to be rendered at.
        
        \param anti_aliased
        Specifies whether the font should be rendered using anti aliasing.
        
        \param resource_group
        The resource group identifier to use when loading the font file
        specified by \a font_filename.
        
        \param auto_scaled
        Specifies whether the font imagery should be automatically scaled to
        maintain the same physical size (which is calculated by using the
        native resolution setting).
        
        \param native_horz_res
        The horizontal native resolution value.  This is only significant when
        auto scaling is enabled.
        
        \param native_vert_res
        The vertical native resolution value.  This is only significant when
        auto scaling is enabled.
        
        \return
        Reference to the newly create Font object.
        */
        public function createSystemFont(
            font_name:String,
            point_size:Number,
            resource_group:String = "",
            auto_scaled:Boolean = false,
            native_horz_res:Number = 640.0,
            native_vert_res:Number = 480.0):FlameFont
        {
            
            // create new object ahead of time
            var object:FlameFont = new FlameSystemFont(font_name, point_size, resource_group,
                auto_scaled, native_horz_res, native_vert_res);
            
            d_objects[font_name] = object;
            
            return object;
        }
        
        
        
        
        /*!
        \brief
        Creates a FreeType type font.
        
        \param font_name
        The name that the font will use within the CEGUI system.
        
        \param point_size
        Specifies the point size that the font is to be rendered at.
        
        \param anti_aliased
        Specifies whether the font should be rendered using anti aliasing.
        
        \param font_filename
        The filename of an font file that will be used as the source for
        glyph images for this font.
        
        \param resource_group
        The resource group identifier to use when loading the font file
        specified by \a font_filename.
        
        \param auto_scaled
        Specifies whether the font imagery should be automatically scaled to
        maintain the same physical size (which is calculated by using the
        native resolution setting).
        
        \param native_horz_res
        The horizontal native resolution value.  This is only significant when
        auto scaling is enabled.
        
        \param native_vert_res
        The vertical native resolution value.  This is only significant when
        auto scaling is enabled.
        
        \param action
        One of the XMLResourceExistsAction enumerated values indicating what
        action should be taken when a Font with the specified name
        already exists.
        
        \return
        Reference to the newly create Font object.
        */
        public function createFreeTypeFont(
            font_name:String,
            point_size:Number,
            anti_aliased:Boolean,
            font_filename:String,
            resource_group:String = "",
            auto_scaled:Boolean = false,
            native_horz_res:Number = 640.0,
            native_vert_res:Number = 480.0):FlameFont
        {
            throw new Error("freetype is not supported yet");
        }
        
        /*!
        \brief
        Creates a Pixmap type font.
        
        \param font_name
        The name that the font will use within the CEGUI system.
        
        \param imageset_filename
        The filename of an imageset to load that will be used as the source for
        glyph images for this font.  If \a resource_group is the special value
        of "*", this parameter may instead refer to the name of an already
        loaded Imagset.
        
        \param resource_group
        The resource group identifier to use when loading the imageset file
        specified by \a imageset_filename.  If this group is set to the special
        value of "*", then \a imageset_filename instead will refer to the name
        of an existing Imageset.
        
        \param auto_scaled
        Specifies whether the font imagery should be automatically scaled to
        maintain the same physical size (which is calculated by using the
        native resolution setting).
        
        \param native_horz_res
        The horizontal native resolution value.  This is only significant when
        auto scaling is enabled.
        
        \param native_vert_res
        The vertical native resolution value.  This is only significant when
        auto scaling is enabled.
        
        \param action
        One of the XMLResourceExistsAction enumerated values indicating what
        action should be taken when a Font with the specified name
        already exists.
        
        \return
        Reference to the newly create Font object.
        */
        public function createPixmapFont(
            font_name:String,
            font_file:String,
            callback:Function = null,
            resource_group:String = "",
            auto_scaled:Boolean = false,
            native_horz_res:Number = 640.0,
            native_vert_res:Number = 480.0):FlameFont
        {
            trace("Attempting to create Pixmap font '" +
                font_name + "' using imageset file '" + font_file + "'.");
            
            // create new object ahead of time
            var object:FlameFont = new FlamePixmapFont(font_name, font_file, callback, resource_group,
                auto_scaled, native_horz_res, native_vert_res);
            
            d_objects[font_name] = object;
            
            return object;
            // return appropriate object instance (deleting any not required)
            //return doExistingObjectAction(font_name, object, action);;
        }
        /*!
        \brief
        Notify the FontManager that display size may have changed.
        
        \param size
        Size object describing the display resolution
        */
        public function notifyDisplaySizeChanged(size:Size):void
        {
            for(var key:String in d_objects)
            {
                (d_objects[key] as FlameFont).notifyDisplaySizeChanged(size);
            }
        }
                
        
        // override from base
        //void doPostObjectAdditionAction(Font& object);
        
    }
}