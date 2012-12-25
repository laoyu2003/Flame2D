/*!
\brief
Property to access the state of the sizable setting for the FrameWindow.

\par Usage:
- Name: SizingEnabled
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate the window will be user re-sizable.
- "False" to indicate the window will not be re-sizable by the user.
*/
package Flame2D.elements.window
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class FrameWindowPropertySizingEnabled extends FlameProperty
    {
        public function FrameWindowPropertySizingEnabled()
        {
            super(
                "SizingEnabled",
                "Property to get/set the state of the sizable setting for the FrameWindow.  Value is either \"True\" or \"False\".",
                "True");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameFrameWindow).isSizingEnabled());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameFrameWindow).setSizingEnabled(FlamePropertyHelper.stringToBool(value));
        }

    }
}