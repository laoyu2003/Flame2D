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
package Flame2D.core.imagesets
{
    import Flame2D.core.data.VertexData;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameImageSetManager;
    import Flame2D.core.system.FlameResourceProvider;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.Vector2;
    import Flame2D.loaders.ImageFileLoader;
    import Flame2D.loaders.TextFileLoader;
    import Flame2D.renderer.FlameGeometryBuffer;
    import Flame2D.renderer.FlameRenderer;
    import Flame2D.renderer.FlameTexture;
    
    import flash.display.BitmapData;
    import flash.geom.Vector3D;
    import flash.utils.Dictionary;

    /*!
    \brief
    Offers functions to define, access, and draw, a set of image components on a single graphical surface or Texture.
    
    Imageset objects are a means by which a single graphical image (file, Texture, etc), can be split into a number
    of 'components' which can later be accessed via name.  The components of an Imageset can queried for
    various details, and sent to the Renderer object for drawing.
    */
    public class FlameImageSet
    {
        //private var _flame:Flame;
        
        //basic info
        private var d_name:String = "";
        private var d_fileName:String = "";
        private var d_resourceGroup:String = "";
        
        //loaded info
        private var d_textureFileName:String = "";
        private var d_nativeHorzRes:uint = 256;
        private var d_nativeVertRes:uint = 256;
        private var d_horzScaling:Number = 1.0;
        private var d_vertScaling:Number = 1.0;
        //set auto scale
        private var d_autoScale:Boolean = true;
        
        //private var d_imagesInfo:Vector.<ImageInfo> = new Vector.<ImageInfo>();
        
        //texture
        private var d_texture:FlameTexture = null;
        
        //images
        //private var _images:Vector.<FlameImage> = new Vector.<FlameImage>();
        private var d_images:Dictionary = new Dictionary();
        
        
        private var d_loaded:Boolean = false;
        private var d_callback:Function = null;
        
        
        /*!
        \brief
        Construct a new Imageset using the specified image file and imageset name.  The created
        imageset will, by default, have a single Image defined named "full_image" which represents
        the entire area of the loaded image file.
        
        \note
        Under certain renderers it may be required that the source image dimensions be some
        power of 2, if this condition is not met then stretching and other undesired side-effects
        may be experienced.  To be safe from such effects it is generally recommended that all
        images that you load have dimensions that are some power of 2.
        
        \param name
        String object holding the name to be assigned to the created imageset.
        
        \param filename
        String object holding the filename of the image that is to be loaded.  The image should be
        of some format that is supported by the Renderer that is in use.
        
        \param resourceGroup
        Resource group identifier to be passed to the resource manager, which may specify a group
        from which the image file is to be loaded.
        
        \exception FileIOException thrown if something goes wrong while loading the image.
        */
        public function FlameImageSet(name:String, fileName:String, resourceGroup:String = "", callback:Function = null)
        {
            d_name = name;
            d_fileName = fileName;
            if(resourceGroup.length == 0){
                d_resourceGroup = "(Default)";
            } else {
                d_resourceGroup = resourceGroup;
            }
            d_callback = callback;
        }
        
        public function dispose():void
        {
            unload();
        }
        
        public function loadImageSet():void
        {
            var url:String = FlameResourceProvider.getSingleton().getResourceDir() + 
                             FlameResourceProvider.getSingleton().getImageSetDir() + 
                             d_fileName;
            
            new TextFileLoader({imageset:d_fileName}, url, onImageSetLoaded);

        }
        
        
        private function onImageSetLoaded(tag:Object, str:String):void
        {
            var xml:XML;
            try {
                //trace(str);
                xml = new XML(str);
            } catch(e:Error) {
                throw new Error("Cannot parse imageset file " + d_fileName);
            }
            if(xml){
                //parse data
                parseImageSet(xml);
                
                //load texture from URL
                loadTexture();
            }
            
        }
        
        private function parseImageSet(xml:XML):void
        {
            var node:XML;
            var nodes:XMLList;
            
            d_name = xml.@Name.toString();
            d_textureFileName = xml.@Imagefile.toString();
            d_resourceGroup = xml.@ResourceGroup.toString();

            nodes = xml.Image;
            if(nodes){
                for each(node in nodes){
                    var name:String = node.@Name.toString();
                    var xPos:Number = Number(node.@XPos.toString());
                    var yPos:Number = Number(node.@YPos.toString());
                    var width:Number = Number(node.@Width.toString());
                    var height:Number = Number(node.@Height.toString());
                    var xOffset:Number = Misc.getAttributeAsNumber(node.@XOffset.toString(), 0);
                    var yOffset:Number = Misc.getAttributeAsNumber(node.@YOffset.toString(), 0);
                    
                    //define image
                    var rect:Rect = new Rect();
                    rect.d_left = xPos;
                    rect.d_top = yPos;
                    rect.setWidth(width);
                    rect.setHeight(height);
                    
                    var offset:Vector2 = new Vector2(xOffset, yOffset);
                    defineImage(name, rect, offset);
                }
            }
            
            //trace("imageset:" + _name + " --- " + _imageFileName);
            var native_hres:Number = Number(xml.@NativeHorzRes.toString());
            var native_vres:Number = Number(xml.@NativeVertRes.toString());
            
            setNativeResolution(new Size(native_hres, native_vres));
            
            var autoScale:Boolean = FlamePropertyHelper.stringToBool(xml.@AutoScaled.toString());
            setAutoScalingEnabled(autoScale);
            
            //add to imageset manager, with real name
            FlameImageSetManager.getSingleton().addImageSet(d_name, this);
            
        }
        
        private function loadTexture():void
        {
            if(d_texture != null) return;
            
            var url:String = FlameResourceProvider.getSingleton().getResourceDir() + 
                             FlameResourceProvider.getSingleton().getImageDir() + 
                             d_textureFileName;
            
            new ImageFileLoader({image:d_textureFileName}, url, onTextureLoaded);
        }
        
        private function onTextureLoaded(tag:Object, bitmapData:BitmapData):void
        {
            //trace("bitmapdata:" + bitmapData.width + "," + bitmapData.height);
            
            //should be upload on necessary
            
            d_texture = new FlameTexture(FlameSystem.getSingleton().getRenderer());
            d_texture.setTextureFromBitmapData(bitmapData);
            
            //set native resolution
            d_nativeHorzRes = bitmapData.width;
            d_nativeVertRes = bitmapData.height;
            
            defineImage("full_image", new Rect(0, 0, bitmapData.width, bitmapData.height), new Vector2(0,0));
            
            //dispatch event
            //todo
            
            //assume this image set is loaded
            if(d_callback != null)
            {
                d_callback({name:d_name});
            }
            

            d_loaded = true;
            
        }

        
        public function loadImageSetSingleFile():void
        {
            var url:String = FlameResourceProvider.getSingleton().getResourceDir() + 
                             FlameResourceProvider.getSingleton().getImageSetDir() + d_fileName;
            
            d_textureFileName = d_fileName;
            
            new ImageFileLoader({image:d_textureFileName}, url, onTextureLoaded2);
        }

        private function onTextureLoaded2(tag:Object, bitmapData:BitmapData):void
        {
            //trace("bitmapdata:" + bitmapData.width + "," + bitmapData.height);
            
            //should be upload on necessary
            
            d_texture = new FlameTexture(FlameSystem.getSingleton().getRenderer());
            d_texture.setTextureFromBitmapData(bitmapData);
            
            //set native resolution
            d_nativeHorzRes = bitmapData.width;
            d_nativeVertRes = bitmapData.height;
            
            defineImage("full_image", new Rect(0, 0, bitmapData.width, bitmapData.height), new Vector2(0,0));
            

            FlameImageSetManager.getSingleton().addImageSet(d_name, this);
            
            if(d_callback != null)
            {
                d_callback({name:d_fileName});
            }
            
            d_loaded = true;
            
        }
        
        
        
        /*!
        \brief
        set the Texture object to be used by this Imageset.  Changing textures on an Imageset that is in use is not a good idea!
        
        \param texture
        Texture object to be used by the Imageset.  The old texture is NOT disposed of, that is the clients responsibility.
        
        \return
        Nothing
        
        \exception	NullObjectException		thrown if \a texture is NULL
        */
        public function setFontTexture(texture:FlameTexture):void
        {
            if (!texture)
            {
                throw new Error("Imageset::setTexture - Texture object supplied for Imageset creation must be valid.");
            }
            
            d_autoScale = false;
            d_horzScaling = 1.0;
            d_vertScaling = 1.0;
            d_texture = texture;
            d_nativeHorzRes = texture.getSize().d_width;
            d_nativeVertRes = texture.getSize().d_height;
        }
        
        /*!
        \brief
        Define a new Image for this Imageset
        
        \param name
        String object holding the name that will be assigned to the new Image, which must be unique within the Imageset.
        
        \param image_rect
        Rect object describing the area on the image file / texture associated with this Imageset that will be used for the Image.
        
        \param render_offset
        Point object describing the offsets, in pixels, that are to be applied to the Image when it is drawn.
        
        \return
        Nothing
        
        \exception AlreadyExistsException	thrown if an Image named \a name is already defined for this Imageset
        */
        public function defineImage(name:String, image_rect:Rect, render_offset:Vector2):FlameImage
        {
            //check repeated name... 
            if(isImageDefined(name)){
                throw new Error("found duplicated name:" + name + " in imageset.");
            }
            
            var hscale:Number = d_autoScale ? d_horzScaling : 1.0;
            var vscale:Number = d_autoScale ? d_vertScaling : 1.0;

            
            var fi:FlameImage = new FlameImage(this, name, image_rect, render_offset, hscale, vscale);
            d_images[name] = fi;

            return fi;
        }

        
        public function isLoaded():Boolean
        {
            return d_loaded == true;
        }
        
        
        
        /*!
        \brief
        Queues an area of the associated Texture the be drawn on the screen.
        Low-level routine to be used carefully!
        
        \param buffer
        GeometryBuffer object where the geometry for the area to be drawn will
        be queued.
        
        \param source_rect
        Rect object describing the area of the image file / texture that is to
        be queued for drawing
        
        \param dest_rect
        Rect describing the area of the screen that will be filled with the
        imagery from \a source_rect.
        
        \param clip_rect
        Rect object describing a 'clipping rectangle' that will be applied when
        drawing the requested imagery
        
        \param colours
        ColourRect object holding the ARGB colours to be applied to the four
        corners of the rendered imagery.
        
        \param quad_split_mode
        One of the QuadSplitMode values specifying the way the quad geometry for
        the image is to be split into triangles.
        
        \return
        Nothing
        */
        public function draw(buffer:FlameGeometryBuffer, 
                             source_rect:Rect, 
                             dest_rect:Rect,
                             clip_rect:Rect, 
                             colours:ColourRect, 
                             quad_split_mode:uint = 0):void
        {
            
            //trace("draw image from imageset:" + d_name);
            
            var final_rect:Rect = (clip_rect ? dest_rect.getIntersection(clip_rect) : dest_rect.clone());
            
            //check if rect was totally clipped
            if(final_rect.getWidth() == 0 || final_rect.getHeight() == 0) {
                //throw new Error("image clipped");
                return;
            }
            
            //obtain correct scale values from the texture
            //todo...we do not consider texture scaling for now
            const x_scale:Number = 1.0 / d_nativeHorzRes;
            const y_scale:Number = 1.0 / d_nativeVertRes;
            
            var tex_per_pix_x:Number = source_rect.getWidth() / dest_rect.getWidth();
            var tex_per_pix_y:Number = source_rect.getHeight() / dest_rect.getHeight();
            
            //calculate final, clipped texture co-ordinates
            var tex_rect:Rect = new Rect(
                (source_rect.d_left + ((final_rect.d_left - dest_rect.d_left) * tex_per_pix_x)) * x_scale,
                (source_rect.d_top + ((final_rect.d_top - dest_rect.d_top) * tex_per_pix_y)) * y_scale,
                (source_rect.d_right + ((final_rect.d_right - dest_rect.d_right) * tex_per_pix_x)) * x_scale,
                (source_rect.d_bottom + ((final_rect.d_bottom - dest_rect.d_bottom) * tex_per_pix_y)) * y_scale);
            
            //we do not consider pixel alignment for now
            
            //array of VertexData
            var vbuffer:Vector.<VertexData> = new Vector.<VertexData>();
            
            //now modified to push 4 vertices.
            
            //vertex 0
            var vd:VertexData;
            vd = new VertexData();
            vd.position = new Vector3D(final_rect.d_left, final_rect.d_top, 0);
            vd.colour_val = colours.d_top_left.getARGB();
            vd.tex_coords = new Vector2(tex_rect.d_left, tex_rect.d_top);
            vbuffer.push(vd);
            
            //vertex 1
            vd = new VertexData();
            vd.position = new Vector3D(final_rect.d_left, final_rect.d_bottom, 0);
            vd.colour_val = colours.d_bottom_left.getARGB();
            vd.tex_coords = new Vector2(tex_rect.d_left, tex_rect.d_bottom);
            vbuffer.push(vd);
            
            //vertex 2
            vd = new VertexData();
            vd.position = new Vector3D(final_rect.d_right, final_rect.d_bottom, 0);
            vd.colour_val = colours.d_bottom_right.getARGB();
            vd.tex_coords = new Vector2(tex_rect.d_right, tex_rect.d_bottom);
            vbuffer.push(vd);
            
            //vertex 3
            vd = new VertexData();
            vd.position = new Vector3D(final_rect.d_right, final_rect.d_top, 0);
            vd.colour_val = colours.d_top_right.getARGB();
            vd.tex_coords = new Vector2(tex_rect.d_right, tex_rect.d_top);
            vbuffer.push(vd);
            
            
            //add to geometry buffer
            buffer.setActiveTexture(d_texture);
            buffer.appendGeometry(vbuffer);
        }
        
        
        
        
        public function getTexture():FlameTexture
        {
            return d_texture;
        }
        
        public function getName():String
        {
            return d_name;
        }
        
        //total images contains in this imageset
        public function getImageCount():uint
        {
            var count:uint=0;
            for each (var key:* in d_images)
            {
                count++;
            }
            
            return count;
        }
        
        /*!
        \brief
        return true if an Image with the specified name exists.
        
        \param name
        String object holding the name of the Image to look for.
        
        \return
        true if an Image object named \a name is defined for this Imageset, else false.
        */
        public function isImageDefined(imageName:String):Boolean
        {
            return d_images.hasOwnProperty(imageName);
        }
        /*!
        \brief
        return a copy of the Image object for the named image
        
        \param name
        String object holding the name of the Image object to be returned
        
        \return
        constant Image object that has the requested name.
        
        \exception UnknownObjectException	thrown if no Image named \a name is defined for the Imageset
        */
        public function getImage(name:String):FlameImage
        {
            if(d_images.hasOwnProperty(name)){
                return d_images[name];
            }
            
            return null;
        }
        
        
        /*!
        \brief
        remove the definition for the Image with the specified name.  If no such Image exists, nothing happens.
        
        \param name
        String object holding the name of the Image object to be removed from the Imageset,
        \return
        Nothing.
        */
        public function undefineImage(name:String):void
        {
            if (isImageDefined(name))
            {
                delete d_images[name];
            }
        }
        
        /*!
        \brief
        Removes the definitions for all Image objects currently defined in the Imageset
        
        \return
        Nothing
        */
        public function undefineAllImages():void
        {
            d_images = new Dictionary();
        }

        /*!
        \brief
        return a Size object describing the dimensions of the named image.
        
        \param name
        String object holding the name of the Image.
        
        \return
        Size object holding the dimensions of the requested Image.
        
        \exception UnknownObjectException	thrown if no Image named \a name is defined for the Imageset
        */
        public function getImageSize(name:String):Size
        {
            return getImage(name).getSize();
        }
        
        
        /*!
        \brief
        return the width of the named image.
        
        \param name
        String object holding the name of the Image.
        
        \return
        float value equalling the width of the requested Image.
        
        \exception UnknownObjectException	thrown if no Image named \a name is defined for the Imageset
        */
        public function getImageWidth(name:String):Number
        {
            return getImage(name).getWidth();
        }
        
        /*!
        \brief
        return the height of the named image.
        
        \param name
        String object holding the name of the Image.
        
        \return
        float value equalling the height of the requested Image.
        
        \exception UnknownObjectException	thrown if no Image named \a name is defined for the Imageset
        */
        public function getImageHeight(name:String):Number
        {
            return getImage(name).getHeight();
        }
        
        
        /*!
        \brief
        return the rendering offsets applied to the named image.
        
        \param name
        String object holding the name of the Image.
        
        \return
        Point object that holds the rendering offsets for the requested Image.
        
        \exception UnknownObjectException	thrown if no Image named \a name is defined for the Imageset
        */
        public function getImageOffset(name:String):Vector2
        {
            return getImage(name).getOffsets();
        }
        
        
        /*!
        \brief
        return the x rendering offset for the named image.
        
        \param name
        String object holding the name of the Image.
        
        \return
        float value equal to the x rendering offset applied when drawing the requested Image.
        
        \exception UnknownObjectException	thrown if no Image named \a name is defined for the Imageset
        */
        public function getImageOffsetX(name:String):Number
        {
            return getImage(name).getOffsetX();
        }
        
        
        /*!
        \brief
        return the y rendering offset for the named image.
        
        \param name
        String object holding the name of the Image.
        
        \return
        float value equal to the y rendering offset applied when drawing the requested Image.
        
        \exception UnknownObjectException	thrown if no Image named \a name is defined for the Imageset
        */
        public function getImageOffsetY(name:String):Number
        {
            return getImage(name).getOffsetY();
        }

        /*!
        \brief
        Return whether this Imageset is auto-scaled.
        
        \return
        true if Imageset is auto-scaled, false if not.
        */
        public function isAutoScaled():Boolean
        {
            return d_autoScale;
        }
        
        
        /*!
        \brief
        Return the native display size for this Imageset.  This is only relevant if the Imageset is being auto-scaled.
        
        \return
        Size object describing the native display size for this Imageset.
        */
        public function getNativeResolution():Size
        {
            return new Size(d_nativeHorzRes, d_nativeVertRes);
        }
        
        /*************************************************************************
         Implementation Functions
         *************************************************************************/
        /*!
        \brief
        Unloads all loaded data and leaves the Imageset in a clean (but un-usable) state.  This should be called for cleanup purposes only.
        */
        public function unload():void
        {
            undefineAllImages();
            
            // cleanup texture
            FlameSystem.getSingleton().getRenderer().destroyTexture(d_texture);
            d_texture = null;
        }
        
        /*!
        \brief
        Sets the scaling factor for all Images that are a part of this Imageset.
        
        \return
        Nothing.
        */
        private function updateImageScalingFactors():void
        {
            var hscale:Number;
            var vscale:Number;
            
            if(d_autoScale){
                hscale = d_horzScaling;
                vscale = d_vertScaling;
            } else {
                hscale = 1.0;
                vscale = 1.0;
            }
            
            for(var key:String in d_images){
                var image:FlameImage = d_images[key] as FlameImage;
                image.setHorzScaling(hscale);
                image.setVertScaling(vscale);
            }
        }
        /*!
        \brief
        Set the native resolution for this Imageset
        
        \param size
        Size object describing the new native screen resolution for this Imageset.
        
        \return
        Nothing
        */
        public function setNativeResolution(size:Size):void
        {
            d_nativeHorzRes = size.d_width;
            d_nativeVertRes = size.d_height;
            
            //re-calculate scaling factors and notify images as required
            notifyDisplaySizeChanged(FlameSystem.getSingleton().getRenderer().getDisplaySize());
        }
        
        /*!
        \brief
        Enable or disable auto-scaling for this Imageset.
        
        \param setting
        true to enable auto-scaling, false to disable auto-scaling.
        
        \return
        Nothing.
        */
        public function setAutoScalingEnabled(setting:Boolean):void
        {
            if(setting != d_autoScale){
                d_autoScale = setting;
                updateImageScalingFactors();
            }
        }
        
        /*!
        \brief
        Notify the Imageset that the display size may have changed.
        
        \param size
        Size object describing the display resolution
        */
        public function notifyDisplaySizeChanged(size:Size):void
        {
            d_horzScaling = size.d_width / d_nativeHorzRes;
            d_vertScaling = size.d_height / d_nativeVertRes;
            
            if(d_autoScale){
                updateImageScalingFactors();
            }
        }
    }
    
}