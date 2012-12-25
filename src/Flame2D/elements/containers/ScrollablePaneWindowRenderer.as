

package Flame2D.elements.containers
{
    import Flame2D.core.system.FlameWindowRenderer;
    import Flame2D.core.utils.Rect;
    
    //! Base class for ScrollablePane window renderer objects.
    public class ScrollablePaneWindowRenderer extends FlameWindowRenderer
    {
        
        //! Constructor
        public function ScrollablePaneWindowRenderer(name:String)
        {
           super(name, FlameScrollablePane.EventNamespace)
        }
        
        /*!
        \brief
        Return a Rect that described the pane's viewable area, relative
        to this Window, in pixels.
        
        \return
        Rect object describing the ScrollablePane's viewable area.
        */
        public function getViewableArea():Rect
        {
            return null;
        }
    }
}