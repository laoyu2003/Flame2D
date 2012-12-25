
package Flame2D.falagard
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameWindow;
    
    /*!
    \brief
    Property to access the text colours for the FalagardStaticText widget.
    
    \par Usage:
    - Name: TextColours
    - Format: "tl:[aarrggbb] tr:[aarrggbb] bl:[aarrggbb] br:[aarrggbb]".
    
    \par Where:
    - tl:[aarrggbb] is the top-left colour value specified as ARGB (hex).
    - tr:[aarrggbb] is the top-right colour value specified as ARGB (hex).
    - bl:[aarrggbb] is the bottom-left colour value specified as ARGB (hex).
    - br:[aarrggbb] is the bottom-right colour value specified as ARGB (hex).
    */
    public class FalagardStaticTextPropertyTextColours extends FlameProperty
    {
        public function FalagardStaticTextPropertyTextColours()
        {
            super(
                "TextColours",
                "Property to get/set the text colours for the FalagardStaticText widget.  Value is \"tl:[aarrggbb] tr:[aarrggbb] bl:[aarrggbb] br:[aarrggbb]\".",
                "tl:FFFFFFFF tr:FFFFFFFF bl:FFFFFFFF br:FFFFFFFF");
        }
        
        override public function getValue(receiver:*):String
        {
            var wr:FalagardStaticText = (receiver as FlameWindow).getWindowRenderer() as FalagardStaticText;
            return FlamePropertyHelper.colourRectToString(wr.getTextColours());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            var wr:FalagardStaticText = (receiver as FlameWindow).getWindowRenderer() as FalagardStaticText;
            wr.setTextColours(FlamePropertyHelper.stringToColourRect(value));
        }
    }
}