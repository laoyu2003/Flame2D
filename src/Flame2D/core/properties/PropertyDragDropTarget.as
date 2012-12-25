/*!
\brief
Property to get/set whether the Window will receive drag and drop related
notifications.

\par Usage:
- Name: DragDropTarget
- Format: "[text]".

\par Where [Text] is:
- "True" if Window is will receive drag & drop notifications.
- "False" if Window is will not receive drag & drop notifications.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyDragDropTarget extends FlameProperty
    {
        public function PropertyDragDropTarget()
        {
            super(
                "DragTarget",
                "Property to get/set whether the Window will receive drag and drop related notifications.  Value is either \"True\" or \"False\".",
                "True");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setDragDropTarget(FlamePropertyHelper.stringToBool(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.boolToString(FlameWindow(win).isDragDropTarget());
        }
    }
}