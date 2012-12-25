
package Flame2D.falagard
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameWindow;
    
    /*!
    \brief
    Property to access the state of the frame background setting for the FalagardStatic widget.
    
    \par Usage:
    - Name: BackgroundEnabled
    - Format: "[text]".
    
    \par Where [Text] is:
    - "True" to indicate that the background is enabled.
    - "False" to indicate that the background is disabled.
    */
    public class FalagardStaticPropertyBackgroundEnabled extends FlameProperty
    {
        public function FalagardStaticPropertyBackgroundEnabled()
        {
            super(
                "BackgroundEnabled",
                "Property to get/set the state of the frame background setting for the FalagardStatic widget.  Value is either \"True\" or \"False\".",
                "True");
        }
        
        override public function getValue(receiver:*):String
        {
            var wr:FalagardStatic = (receiver as FlameWindow).getWindowRenderer() as FalagardStatic;
            return FlamePropertyHelper.boolToString(wr.isBackgroundEnabled());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            var wr:FalagardStatic = (receiver as FlameWindow).getWindowRenderer() as FalagardStatic;
            wr.setBackgroundEnabled(FlamePropertyHelper.stringToBool(value));
        }
    }
}