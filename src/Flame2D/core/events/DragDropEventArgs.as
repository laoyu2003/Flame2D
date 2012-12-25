
/*!
\brief
EventArgs based class used for certain drag/drop notifications
*/

package Flame2D.core.events
{
    import Flame2D.core.system.FlameWindow;
    import Flame2D.elements.dnd.FlameDragContainer;
    
    public class DragDropEventArgs extends WindowEventArgs
    {
        public var dragDropItem:FlameDragContainer = null; //<! pointer to the DragContainer window being dragged / dropped.
        
        public function DragDropEventArgs(win:FlameWindow)
        {
            super(win);
        }
    }
}
