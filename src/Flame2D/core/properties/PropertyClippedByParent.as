/*!
\brief
Property to access window "clipped by parent" setting.

This property offers access to the clipped by parent setting for the window.

\par Usage:
- Name: ClippedByParent
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate the Window is clipped by it's parent.
- "False" to indicate the Window is not clipped by it's parent.
*/
package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyClippedByParent extends FlameProperty
    {
        public function PropertyClippedByParent()
        {
            super(
                "ClippedByParent",
                "Property to get/set the 'clipped by parent' setting for the Window.  Value is either \"True\" or \"False\".",
                "True");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setClippedByParent(FlamePropertyHelper.stringToBool(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.boolToString(FlameWindow(win).isClippedByParent());
        }
    }
}