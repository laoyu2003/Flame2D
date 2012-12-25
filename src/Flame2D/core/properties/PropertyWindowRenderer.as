/*!
\brief
Property to access/change the assigned window renderer object.

\par Usage:
- Name: WindowRenderer
- Format: "[windowRendererName]"

\par Where [windowRendererName] is the factory name of the window renderer type you wish to assign.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyWindowRenderer extends FlameProperty
    {
        public function PropertyWindowRenderer()
        {
            super(
                "WindowRenderer",
                "Property to get/set the windows assigned window renderer objects name.  Value is a string.",
                "");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setWindowRenderer(value);
        }
        
        override public function getValue(win:*):String
        {
            return FlameWindow(win).getWindowRendererName();
        }
    }
}