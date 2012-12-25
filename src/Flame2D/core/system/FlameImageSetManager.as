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
    import Flame2D.core.imagesets.FlameImageSet;
    import Flame2D.core.utils.Size;
    import Flame2D.renderer.FlameTexture;
    
    import flash.utils.Dictionary;
    
    public class FlameImageSetManager
    {
        private var d_objects:Dictionary = new Dictionary();
        
        private static var d_singleton:FlameImageSetManager = new FlameImageSetManager();
        
        public function FlameImageSetManager()
        {
            if(d_singleton){
                throw new Error("FlameImageSetManager: init only once");
            }
        }
        
        public function dispose():void
        {
            for each(var imageSet:FlameImageSet in d_objects)
            {
                imageSet.dispose();
            }
            
            d_objects = null;
            
            trace("CEGUI::ImagesetManager singleton destroyed.");
        }
        
        public static function getSingleton():FlameImageSetManager
        {
            return d_singleton;
        }
        /*!
        \brief
        Create a Imageset object with the given name and Texture
        
        The created Imageset will be of limited use, and will require one or
        more images to be defined for the set.
        
        \param name
        String object containing the unique name for the Imageset being created.
        
        \param texture
        Texture object to be associated with the Imageset
        
        \param action
        One of the XMLResourceExistsAction enumerated values indicating what
        action should be taken when an Imageset with the specified name
        already exists.
        
        \return
        Reference to the newly created Imageset object
        
        \exception AlreadyExistsException
        thrown if an Imageset named \a name is already present in the system.
        */
        public function create(name:String, fileName:String, resourceGroup:String = "", callback:Function = null):void
        {
            //load image set
            var imageSet:FlameImageSet = new FlameImageSet(name, fileName, resourceGroup, callback);
            imageSet.loadImageSet();
            //d_objects[name] = imageSet;
            //trace("Ok");
        }
        
        
        public function createFontTexture(name:String, texture:FlameTexture):FlameImageSet
        {
            var imageSet:FlameImageSet = new FlameImageSet(name, "");
            imageSet.setFontTexture(texture);//also set native resolution
            
            d_objects[name] = imageSet;
            
            return imageSet;
        }
        
        
        //called from imageset
        public function addImageSet(name:String, imageset:FlameImageSet):void
        {
            d_objects[name] = imageset;
        }
        
        
        public function destroy(obj:*):void
        {
            
        }
        
        /*!
        \brief
        Create an Imageset object from the specified image file.  The Imageset
        will initially have a single image defined named "full_image" which is
        an image that represents the entire area of the loaded image.
        
        \param name
        String object containing the unique name for the Imageset being created.
        
        \param filename
        String object holding the name of the image file to be loaded.
        
        \param resourceGroup
        Resource group identifier to be passed to the resource manager when
        loading the image file.
        
        \param action
        One of the XMLResourceExistsAction enumerated values indicating what
        action should be taken when an Imageset with the specified name
        already exists.
        
        \return
        Reference to the newly created Imageset object
        
        \exception AlreadyExistsException
        thrown if an Imageset named \a name is already present in the system.
        
        \exception FileIOException
        thrown if something goes wrong while reading the image file \a filename.
        */
        public function createFromImageFile(imageset:String, fileName:String, resourceGroup:String = "", callback:Function = null):void
        {
            //load from file
            var fset:FlameImageSet = new FlameImageSet(imageset, fileName, resourceGroup, callback);
            fset.loadImageSetSingleFile();
            
        }
        
        public function getImageSet(name:String):FlameImageSet
        {
            if(d_objects.hasOwnProperty(name)){
                return d_objects[name];
            }
            
            return null;
        }
        
        public function isDefined(name:String):Boolean
        {
            return d_objects.hasOwnProperty(name);
        }
        
        public function isLoaded(name:String):Boolean
        {
            if(d_objects.hasOwnProperty(name)){
                return (d_objects[name] as FlameImageSet).isLoaded();
            }
            
            return false;
        }
        
        //----------------------------------------------------------------------------//
        public function notifyDisplaySizeChanged(size:Size):void
        {
            // notify all attached Imageset objects of the change in resolution
            //ObjectRegistry::iterator pos = d_objects.begin(), end = d_objects.end();
            for(var name:String in d_objects)
            {
                (d_objects[name] as FlameImageSet).notifyDisplaySizeChanged(size);
            }
        }

    }
}