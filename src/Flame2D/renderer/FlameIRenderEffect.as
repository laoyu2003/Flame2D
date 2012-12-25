

package Flame2D.renderer
{
    import Flame2D.core.system.FlameRenderingWindow;

    /*!
    \brief
    Interface for objects that hook into RenderingWindow to affect the rendering
    process, thus allowing various effects to be achieved.
    */
    public interface FlameIRenderEffect
    {
        /*!
        \brief
        Return the number of passes required by this effect.
        
        \return
        integer value indicating the number of rendering passes required to
        fully render this effect.
        */
        function getPassCount():int;
        
        /*!
        \brief
        Function called prior to RenderingWindow::draw being called.  This is
        intended to be used for any required setup / state initialisation and is
        called once for each pass in the effect.
        
        \param pass
        Indicates the pass number to be initialised (starting at pass 0).
        
        \note
        Note that this function is called \e after any standard state
        initialisation that might be peformed by the Renderer module.
        */
        function performPreRenderFunctions(pass:int):void;
        
        /*!
        \brief
        Function called after RenderingWindow::draw is called.  This is intended
        to be used for any required cleanup / state restoration.  This function
        is called <em>once only</em>, unlike performPreRenderFunctions which may
        be called multiple times; once for each pass in the effect.
        \note
        Note that this function is called \e before any standard state
        cleanup that might be peformed by the Renderer module.
        */
        function performPostRenderFunctions():void;
        
        /*!
        \brief
        Function called to generate geometry for the RenderingWindow.
        
        The geometry generated should be fully unclipped and window local.  The
        origin for the geometry is located at the top-left corner.
        
        \param window
        The RenderingWindow object that is being processed.
        
        \param geometry
        GeometryBuffer object where the generated geometry should be added.
        This object will be cleared before this function is invoked.
        
        \return
        boolean value indicating whether the RenderingWindow should generate
        it's own geometry.
        - true if the RenderingWindow should generate it's own geometry.  You
        will usually only return true if you do not need to use custom geometry.
        - false if you have added any required geometry needed to represent the
        RenderingWindow.
        */
        function realiseGeometry(window:FlameRenderingWindow, geometry:FlameGeometryBuffer):void;
        
        /*!
        \brief
        Function called to perform any time based updates on the RenderEffect
        state.
        
        \note
        This function should only affect the internal state of the RenderEffect
        object.  This function should definitely \e not be used to directly
        affect any render states of the underlying rendering API or engine.
        
        \param elapsed
        The number of seconds that have elapsed since the last time this
        function was called.
        
        \param window
        RenderingWindow object that the RenderEffect is being applied to.
        
        \return
        boolean that indicates whether the window geometry will still be valid
        after the update.
        */
        function update(elapsed:Number, window:FlameRenderingWindow):Boolean;
    }
}