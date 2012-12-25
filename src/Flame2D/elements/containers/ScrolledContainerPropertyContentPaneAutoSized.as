/*!
\brief
Property to access the setting which controls whether the content pane is automatically
resized according to the size and position of attached content.

\par Usage:
- Name: ContentPaneAutoSized
- Format: "[text]"

\par Where [Text] is:
- "True" to indicate the pane should automatically resize itself.
- "False" to indicate the pane should not automatically resize itself.
*/
package Flame2D.elements.containers
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.data.Consts;
    
    public class ScrolledContainerPropertyContentPaneAutoSized extends FlameProperty
    {
        public function ScrolledContainerPropertyContentPaneAutoSized()
        {
            super(
                "ContentPaneAutoSized",
                "Property to get/set the setting which controls whether the content pane will auto-size itself.  Value is either \"True\" or \"False\".",
                "True");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameScrolledContainer).isContentPaneAutoSized());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameScrolledContainer).setContentPaneAutoSized(FlamePropertyHelper.stringToBool(value));
        }
    }
}