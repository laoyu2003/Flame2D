
package Flame2D.renderer
{
    import Flame2D.core.utils.Size;
    
    /*!
    \brief
    Specialisation of RenderTarget interface that should be used as the base
    class for RenderTargets that are implemented using textures.
    */
    public interface FlameITextureTarget
    {
        /*!
        \brief
        Clear the surface of the underlying texture.
        */
        function clear():void;
        
        /*!
        \brief
        Return a pointer to the CEGUI::Texture that the TextureTarget is using.
        
        \return
        Texture object that the TextureTarget uses when rendering imagery.
        */
        function getTexture():FlameTexture;
        
        /*!
        \brief
        Used to declare to the TextureTarget the largest size, in pixels, of the
        next set of incoming rendering operations.
        
        \note
        The main purpose of this is to allow for the implemenatation to resize
        the underlying texture so that it can hold the imagery that will be
        drawn.
        
        \param sz
        Size object describing the largest area that will be rendererd in the
        next batch of rendering operations.
        
        \exception InvalidRequestException
        May be thrown if the TextureTarget would not be able to handle the
        operations rendering content of the given size.
        */
        function declareRenderSize(sz:Size):void;
        
        /*!
        \brief
        Return whether rendering done on the target texture is inverted in
        relation to regular textures.
        
        This is intended to be used when generating geometry for rendering the
        TextureTarget onto another surface.
        
        \return
        - true if the texture content should be considered as inverted
        vertically in comparison with other regular textures.
        - false if the texture content has the same orientation as regular
        textures.
        */
        function isRenderingInverted():Boolean;
    }
}