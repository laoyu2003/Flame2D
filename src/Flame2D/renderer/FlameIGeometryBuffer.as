
package Flame2D.renderer
{
    import Flame2D.core.data.VertexData;
    import Flame2D.core.utils.Rect;
    
    import flash.geom.Vector3D;

    /*!
    \brief
    Abstract class defining the interface for objects that buffer geometry for
    later rendering.
    */
    public interface FlameIGeometryBuffer
    {
        /*!
        \brief
        Draw the geometry buffered within this GeometryBuffer object.
        */
        function draw():void;
        
        /*!
        \brief
        Set the translation to be applied to the geometry in the buffer when it
        is subsequently rendered.
        
        \param v
        Vector3 describing the three axis translation vector to be used.
        */
        function setTranslation(v:Vector3D):void;
        
        /*!
        \brief
        Set the rotations to be applied to the geometry in the buffer when it is
        subsequently rendered.
        
        \param r
        Vector3 describing the rotation factors to be used.
        */
        function setRotation(r:Vector3D):void;
        
        /*!
        \brief
        Set the pivot point to be used when applying the rotations.
        
        \param p
        Vector3 describing the location of the pivot point to be used when
        applying the rotation to the geometry.
        */
        function setPivot(p:Vector3D):void;
        
        /*!
        \brief
        Set the clipping region to be used when rendering this buffer.
        */
        function setClippingRegion(region:Rect):void;
        
        /*!
        \brief
        Append a single vertex to the buffer.
        
        \param vertex
        Vertex object describing the vertex to be added to the GeometryBuffer.
        */
       function appendVertex(vertex:VertexData):void;
        
        /*!
        \brief
        Append a number of vertices from an array to the GeometryBuffer.
        
        \param vbuff
        Pointer to an array of Vertex objects that describe the vertices that
        are to be added to the GeometryBuffer.
        
        \param vertex_count
        The number of Vertex objects from the array \a vbuff that are to be
        added to the GeometryBuffer.
        */
        function appendGeometry(vbuff:Vector.<VertexData>):void;
        
        /*!
        \brief
        Set the active texture to be used with all subsequently added vertices.
        
        \param texture
        Pointer to a Texture object that shall be used for subsequently added
        vertices.  This may be 0, in which case texturing will be disabled for
        subsequently added vertices.
        */
        function setActiveTexture(texture:FlameTexture):void;
        
        /*!
        \brief
        Clear all buffered data and reset the GeometryBuffer to the default
        state.
        */
        function reset():void;
        
        /*!
        \brief
        Return a pointer to the currently active Texture object.  This may
        return 0 if no texture is set.
        
        \return
        Pointer the Texture object that is currently active, or 0 if texturing
        is not being used.
        */
        function getActiveTexture():FlameTexture;
        
        /*!
        \brief
        Return the total number of vertices currently held by this
        GeometryBuffer object.
        
        \return
        The number of vertices that have been appended to this GeometryBuffer.
        */
        function getVertexCount():uint;
        
        /*!
        \brief
        Return the number of batches of geometry that this GeometryBuffer has
        split the vertices into.
        
        \note
        How batching is done will be largely implementation specific, although
        it would be reasonable to expect that you will have <em>at least</em>
        one batch of geometry per texture switch.
        
        \return
        The number of batches of geometry held by the GeometryBuffer.
        */
        function getBatchCount():uint;
        
        /*!
        \brief
        Set the RenderEffect to be used by this GeometryBuffer.
        
        \param effect
        Pointer to the RenderEffect to be used during renderng of the
        GeometryBuffer.  May be 0 to remove a previously added RenderEffect.
        
        \note
        When adding a RenderEffect, the GeometryBuffer <em>does not</em> take
        ownership of, nor make a copy of, the passed RenderEffect - this means
        you need to be careful not to delete the RenderEffect if it might still
        be in use!
        */
        function setRenderEffect(effect:FlameRenderEffect):void;
        
        /*!
        \brief
        Return the RenderEffect object that is assigned to this GeometryBuffer
        or 0 if none.
        */
        function getRenderEffect():FlameRenderEffect;
        
        /*!
        \brief
        Set the blend mode option to use when rendering this GeometryBuffer.
        
        \note
        The blend mode setting is not a 'state' setting, but is used for \e all
        geometry added to the buffer regardless of when the blend mode is set.
        
        \param mode
        One of the BlendMode enumerated values indicating the blending mode to
        be used.
        */
        function setBlendMode(mode:String):void;
        
        /*!
        \brief
        Return the blend mode that is set to be used for this GeometryBuffer.
        
        \return
        One of the BlendMode enumerated values indicating the blending mode
        that will be used when rendering all geometry added to this
        GeometryBuffer object.
        */
        function getBlendMode():String;
    }
}