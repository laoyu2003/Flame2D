/*!
\brief
Property to access the document size for the Scrollbar.

\par Usage:
- Name: DocumentSize
- Format: "[float]".

\par Where:
- [float] specifies the size of the document being scrolled (as defined by the client code).
*/
package Flame2D.elements.base
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ScrollbarPropertyDocumentSize extends FlameProperty
    {
        public function ScrollbarPropertyDocumentSize()
        {
            super(
                "DocumentSize",
                "Property to get/set the document size for the Scrollbar.  Value is a float.",
                "1.000000");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameScrollbar).getDocumentSize());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameScrollbar).setDocumentSize(FlamePropertyHelper.stringToFloat(value));
        }
    }
}