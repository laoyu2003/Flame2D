

package Flame2D.renderer
{
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Vector2;
    import Flame2D.core.system.FlameRenderQueue;

    public interface FlameIRenderTarget
    {
        /*!
        \brief
        Draw geometry from the given GeometryBuffer onto the surface that
        this RenderTarget represents.
        
        \param buffer
        GeometryBuffer object holding the geometry that should be drawn to the
        RenderTarget.
        */
        function draw(buffer:FlameGeometryBuffer):void;
        
        /*!
        \brief
        Draw geometry from the given RenderQueue onto the surface that
        this RenderTarget represents.
        
        \param queue
        RenderQueue object holding the geometry that should be drawn to the
        RenderTarget.
        */
        function drawQueue(queue:FlameRenderQueue):void;
        
        /*!
        \brief
        Set the area for this RenderTarget.  The exact action this function
        will take depends upon what the concrete class is representing.  For
        example, with a 'view port' style RenderTarget, this should set the area
        that the view port occupies on the display (or rendering window).
        
        \param area
        Rect object describing the new area to be assigned to the RenderTarget.
        
        \exception InvalidRequestException
        May be thrown if the RenderTarget does not support setting or changing
        its area, or if the area change can not be satisfied for some reason.
        */
        function setArea(area:Rect):void;
        
        /*!
        \brief
        Return the area defined for this RenderTarget.
        
        \return
        Rect object describing the currently defined area for this RenderTarget.
        */
        function getArea():Rect;
        
        /*!
        \brief
        Return whether the RenderTarget is an implementation that caches
        actual rendered imagery.
        
        Typically it is expected that texture based RenderTargets would return
        true in response to this call.  Other types of RenderTarget, like
        view port based targets, will more likely return false.
        
        \return
        - true if the RenderTarget does cache rendered imagery.
        - false if the RenderTarget does not cache rendered imagery.
        */
        function isImageryCache():Boolean;
        
        /*!
        \brief
        Activate the render target and put it in a state ready to be drawn to.
        
        \note
        You MUST call this before doing any rendering - if you do not call this,
        in the unlikely event that your application actually works, it will
        likely stop working in some future version.
        */
        function activate():void;
        
        /*!
        \brief
        Deactivate the render target after having completed rendering.
        
        \note
        You MUST call this after you finish rendering to the target - if you do
        not call this, in the unlikely event that your application actually
        works, it will likely stop working in some future version.
        */
        function deactivate():void;
        
        /*!
        \brief
        Take point \a p_in unproject it and put the result in \a p_out.
        Resulting point is local to GeometryBuffer \a buff.
        */
        function unprojectPoint(buff:FlameGeometryBuffer, p_in:Vector2, p_out:Vector2):void;
    }
}