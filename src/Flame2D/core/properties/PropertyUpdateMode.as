/*!
\brief
Property to access the update mode setting for the window.

\par Usage:
- Name: UpdateMode
- Format: "[text]".

\par Where [Text] is:
- "Always" to indicate the update function should always be called.
- "Never" to indicate the update function should never be called.
- "Visible" to indicate the update function should only be called when
the window is visible (i.e. State of Visible property set to True).
*/

package Flame2D.core.properties
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyUpdateMode extends FlameProperty
    {
        public function PropertyUpdateMode()
        {
            super(
                "UpdateMode",
                "Property to get/set the window update mode setting.  " +
                "Value is one of \"Always\", \"Never\" or \"Visible\".",
                "Visible");
        }
        
        override public function setValue(win:*, value:String):void
        {
            var mode:uint;
            if(value == "Always"){
                mode = Consts.WindowUpdateMode_ALWAYS;
            } else if(value == "Never"){
                mode = Consts.WindowUpdateMode_NEVER;
            } else {
                mode = Consts.WindowUpdateMode_VISIBLE;
            }
            
            FlameWindow(win).setUpdateMode(mode);
        }
        
        override public function getValue(win:*):String
        {
            var mode:uint = FlameWindow(win).getUpdateMode();
            switch(mode){
                case Consts.WindowUpdateMode_ALWAYS:
                    return "Always";
                case Consts.WindowUpdateMode_NEVER:
                    return "Never";
                default:
                    return "Visible";
            }
        }
    }
}