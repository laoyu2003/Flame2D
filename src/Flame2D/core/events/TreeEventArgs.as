
package Flame2D.core.events
{
    import Flame2D.core.system.FlameWindow;
    import Flame2D.elements.tree.FlameTreeItem;

    public class TreeEventArgs extends WindowEventArgs
    {
        public var treeItem:FlameTreeItem = null;

        public function TreeEventArgs(wnd:FlameWindow)
        {
            super(wnd);
        }
        
    }
}