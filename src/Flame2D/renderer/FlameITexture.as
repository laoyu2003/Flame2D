

package Flame2D.renderer
{
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.Vector2;
    
    import flash.display.BitmapData;
    import flash.display3D.textures.Texture;

    public interface FlameITexture
    {
        /*!
        \brief
        Returns the current pixel size of the texture.
        
        \return
        Reference to a Size object that describes the size of the texture in
        pixels.
        */
        function getSize():Size;
        
        /*!
        \brief
        Returns the original pixel size of the data loaded into the texture.
        
        \return
        reference to a Size object that describes the original size, in pixels,
        of the data loaded into the texture.
        */
        function getOriginalDataSize():Size;
        
        /*!
        \brief
        Returns pixel to texel scale values that should be used for converting
        pixel values to texture co-ords.
        
        \return
        Reference to a Vector2 object that describes the scaling values required
        to accurately map pixel positions to texture co-ordinates.
        */
        function getTexelScaling():Vector2;
        
        /*!
        \brief
        Loads the specified image file into the texture.  The texture is resized
        as required to hold the image.
        
        \param filename
        The filename of the image file that is to be loaded into the texture
        
        \param resourceGroup
        Resource group identifier to be passed to the resource provider when
        loading the image file.
        
        \return
        Nothing.
        */
        function loadFromFile(filename:String, resourceGroup:String):void;
        
        /*!
        \brief
        Loads (copies) an image in memory into the texture.  The texture is
        resized as required to hold the image.
        
        \param buffer
        Pointer to the buffer containing the image data.
        
        \param buffer_size
        Size of the buffer (in pixels as specified by \a pixelFormat)
        
        \param pixel_format
        PixelFormat value describing the format contained in \a buffPtr.
        
        \return
        Nothing.
        */
        //function loadFromMemory(buffer:*, buffer_size:Size, pixel_format:uint);
        
        /*!
        \brief
        Save / dump the content of the texture to a memory buffer.  The dumped
        pixel format is always RGBA (4 bytes per pixel).
        
        \param buffer
        Pointer to the buffer that is to receive the image data.  You must make
        sure that this buffer is large enough to hold the dumped texture data,
        the required pixel dimensions can be established by calling getSize.
        */
        //function saveToMemory(buffer:*);
        
        function setTexture(tex:Texture, width:Number, height:Number):void;
        
        function cleanupTexture():void;
        
    }
}