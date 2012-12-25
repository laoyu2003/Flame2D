
/*!
\brief
Property to control whether the window will receive double/triple-click events.

This property offers access to the setting that controls whether a window will receive double-click and
triple-click events, or whether the window will receive multiple single mouse button down events instead.

\par Usage:
- Name: WantsMultiClickEvents
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate the Window wants double-click and triple-click events.
- "False" to indicate the Window wants multiple single mouse button down events.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyWantsMultiClickEvents extends FlameProperty
    {
        public function PropertyWantsMultiClickEvents()
        {
            super(
                "WantsMultiClickEvents",
                "Property to get/set whether the window will receive double-click and triple-click events.  Value is either \"True\" or \"False\".",
                "True");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setWantsMultiClickEvents(FlamePropertyHelper.stringToBool(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.boolToString(FlameWindow(win).wantsMultiClickEvents());
        }
            
    }
}