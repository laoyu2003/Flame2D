
package Flame2D.core.data
{
    import Flame2D.core.system.FlameRenderingSurface;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.utils.Vector2;
    
    public class RenderingContext
    {
        //! RenderingSurface to be used for drawing
        public var surface:FlameRenderingSurface;
        //! The Window object that owns the RenederingSurface (0 for default root)
        public var owner:FlameWindow;
        //! The offset of the owning window on the root RenderingSurface.
        public var offset:Vector2;
        //! The queue that rendering should be added to.
        //RenderQueueID queue;
        public var queue:uint;
    }
}