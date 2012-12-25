

package Flame2D.renderer
{
    import Flame2D.core.system.FlameRenderingRoot;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.utils.Size;

    /*!
    \brief
    Abstract class defining the basic required interface for Renderer objects.
    
    Objects derived from Renderer are the means by which the GUI system
    interfaces with specific rendering technologies.  To use a rendering system
    or API to draw CEGUI imagery requires that an appropriate Renderer object be
    available.
    */
    public interface FlameIRenderer
    {
        /*!
        \brief
        Return the default rendering root for the renderer.  The default
        rendering root is typically a RenderingRoot that targets the entire
        screen (or rendering window).
        
        \return
        RenderingRoot object that is the default RenderingSurface provided by
        the Renderer.
        */
        function getDefaultRenderingRoot():FlameRenderingRoot;
        
        /*!
        \brief
        Create a new GeometryBuffer and return a reference to it.  You should
        remove the GeometryBuffer from any RenderQueues and call
        destroyGeometryBuffer when you want to destroy the GeometryBuffer.
        
        \return
        GeometryBuffer object.
        */
        function createGeometryBuffer():FlameGeometryBuffer;
        
        /*!
        \brief
        Destroy a GeometryBuffer that was returned when calling the
        createGeometryBuffer function.  Before destroying any GeometryBuffer
        you should ensure that it has been removed from any RenderQueue that
        was using it.
        
        \param buffer
        The GeometryBuffer object to be destroyed.
        */
        function destroyGeometryBuffer(buffer:FlameGeometryBuffer):void;
        
        /*!
        \brief
        Destroy all GeometryBuffer objects created by this Renderer.
        */
        function destroyAllGeometryBuffers():void;
        
        /*!
        \brief
        Create a TextureTarget that can be used to cache imagery; this is a
        RenderTarget that does not lose it's content from one frame to another.
        
        If the renderer is unable to offer such a thing, 0 should be returned.
        
        \return
        Pointer to a TextureTarget object that is suitable for caching imagery,
        or 0 if the renderer is unable to offer such a thing.
        */
        function createTextureTarget():FlameTextureTarget;
        
        /*!
        \brief
        Function that cleans up TextureTarget objects created with the
        createTextureTarget function.
        
        \param target
        A pointer to a TextureTarget object that was previously returned from a
        call to createTextureTarget.
        */
        function destroyTextureTarget(target:FlameTextureTarget):void
        
        /*!
        \brief
        Destory all TextureTarget objects created by this Renderer.
        */
        function destroyAllTextureTargets():void;
        
        /*!
        \brief
        Create a 'null' Texture object.
        
        \return
        A newly created Texture object.  The returned Texture object has no size
        or imagery associated with it.
        */
        function createTexture():FlameTexture;
        
        /*!
        \brief
        Create a Texture object using the given image file.
        
        \param filename
        String object that specifies the path and filename of the image file to
        use when creating the texture.
        
        \param resourceGroup
        String objet that specifies the resource group identifier to be passed
        to the resource provider when loading the texture file \a filename.
        
        \return
        A newly created Texture object.  The initial content of the texture
        memory is the requested image file.
        
        \note
        Due to possible limitations of the underlying hardware, API or engine,
        the final size of the texture may not match the size of the loaded file.
        You can check the ultimate sizes by querying the Texture object
        after creation.
        */
        function createTextureFromFile(filename:String, resourceGroup:String):FlameTexture;
        
        /*!
        \brief
        Create a Texture object with the given pixel dimensions as specified by
        \a size.
        
        \param size
        Size object that describes the desired texture size.
        
        \return
        A newly created Texture object.  The initial contents of the texture
        memory is undefined.
        
        \note
        Due to possible limitations of the underlying hardware, API or engine,
        the final size of the texture may not match the requested size.  You can
        check the ultimate sizes by querying the Texture object after creation.
        */
        //function createEmptyTexture(size:Size):void;
        
        /*!
        \brief
        Destroy a Texture object that was previously created by calling the
        createTexture functions.
        
        \param texture
        Texture object to be destroyed.
        */
        function destroyTexture(texture:FlameTexture):void;
        
        /*!
        \brief
        Destroy all Texture objects created by this Renderer.
        */
        function destroyAllTextures():void;
        
        /*!
        \brief
        Perform any operations required to put the system into a state ready
        for rendering operations to begin.
        */
        function beginRendering():void;
        
        /*!
        \brief
        Perform any operations required to finalise rendering.
        */
        function endRendering():void;
        
        /*!
        \brief
        Set the size of the display or host window in pixels for this Renderer
        object.
        
        This is intended to be called by the System as part of the notification
        process when display size changes are notified to it via the
        System::notifyDisplaySizeChanged function.
        
        \note
        The Renderer implementation should not use this function other than to
        perform internal state updates on the Renderer and related objects.
        
        \param size
        Size object describing the dimesions of the current or host window in
        pixels.
        */
        function setDisplaySize(size:Size):void;
        
        /*!
        \brief
        Return the size of the display or host window in pixels.
        
        \return
        Size object describing the pixel dimesntions of the current display or
        host window.
        */
        function getDisplaySize():Size;
        
        /*!
        \brief
        Return the resolution of the display or host window in dots per inch.
        
        \return
        Vector2 object that describes the resolution of the display or host
        window in DPI.
        */
        //virtual const Vector2& getDisplayDPI() const = 0;
        
        /*!
        \brief
        Return the pixel size of the maximum supported texture.
        
        \return
        Size of the maximum supported texture in pixels.
        */
        function getMaxTextureSize():Number;
        
        /*!
        \brief
        Return identification string for the renderer module.
        
        \return
        String object holding text that identifies the Renderer in use.
        */
        //virtual const String& getIdentifierString() const = 0;

    }
}