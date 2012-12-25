
/*!
\brief
Property to access window Destroyed by Parent setting.

This property offers access to the destryed by parent setting for the window.

\par Usage:
- Name: DestroyedByParent
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate the Window should be automatically destroyed when it's parent Window is destroyed.
- "False" to indicate the Window should not be destroyed when it's parent Window is destroyed.
*/
package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyDestroyedByParent extends FlameProperty
    {
        public function PropertyDestroyedByParent()
        {
            super(
                "DestroyedByParent",
                "Property to get/set the 'destroyed by parent' setting for the Window.  Value is either \"True\" or \"False\".",
                "True");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setDestroyedByParent(FlamePropertyHelper.stringToBool(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.boolToString(FlameWindow(win).isDestroyedByParent());
        }
    }
}