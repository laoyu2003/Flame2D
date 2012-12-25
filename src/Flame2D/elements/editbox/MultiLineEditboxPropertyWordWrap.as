/*!
\brief
Property to access the word-wrap setting of the edit box.

\par Usage:
- Name: WordWrap
- Format: "[text]"

\par Where [Text] is:
- "True" to indicate the text should be word-wrapped.
- "False" to indicate the text should not be word-wrapped.
*/
package Flame2D.elements.editbox
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class MultiLineEditboxPropertyWordWrap extends FlameProperty
    {
        public function MultiLineEditboxPropertyWordWrap()
        {
            super(
                "WordWrap",
                "Property to get/set the word-wrap setting of the edit box.  Value is either \"True\" or \"False\".",
                "True");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameMultiLineEditbox).isWordWrapped());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameMultiLineEditbox).setWordWrapping(FlamePropertyHelper.stringToBool(value));
        }

    }
}