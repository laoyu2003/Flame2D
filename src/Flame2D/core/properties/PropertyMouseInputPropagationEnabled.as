/*!
\brief
Property to access the setting that controls whether mouse input not handled
directly by the window will be propagated back to the parent window.

\par Usage:
- Name: MouseInputPropagationEnabled
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate that unhandled mouse input should be propagated to
the Window's parent.
- "False" to indicate that unhandled mouse input should not be
propagated to the window's parent.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyMouseInputPropagationEnabled extends FlameProperty
    {
        public function PropertyMouseInputPropagationEnabled()
        {
            super(
                "MouseInputPropagationEnabled",
                "Property to get/set whether unhandled mouse inputs should be " +
                "propagated back to the Window's parent.  " +
                "Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setMouseInputPropagationEnabled(FlamePropertyHelper.stringToBool(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.boolToString(FlameWindow(win).isMouseInputPropagationEnabled());
        }
    }
}