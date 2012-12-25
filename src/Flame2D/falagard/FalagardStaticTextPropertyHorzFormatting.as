
package Flame2D.falagard
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.data.Consts;
    
    
    /*!
    \brief
    Property to access the horizontal formatting mode setting.
    
    \par Usage:
    - Name: HorzFormatting
    - Format: "[text]".
    
    \par Where [text] is one of:
    - "LeftAligned"
    - "RightAligned"
    - "HorzCentred"
    - "HorzJustified"
    - "WordWrapLeftAligned"
    - "WordWrapRightAligned"
    - "WordWrapCentred"
    - "WordWrapJustified"
    */
    public class FalagardStaticTextPropertyHorzFormatting extends FlameProperty
    {
        public function FalagardStaticTextPropertyHorzFormatting()
        {
            super(
                "HorzFormatting",
                "Property to get/set the horizontal formatting mode.  Value is one of the HorzFormatting strings.",
                "LeftAligned");
        }
        
        
        override public function getValue(receiver:*):String
        {
            var wr:FalagardStaticText = (receiver as FlameWindow).getWindowRenderer() as FalagardStaticText;
            
            switch(wr.getHorizontalFormatting())
            {
                case Consts.HorizontalTextFormatting_HTF_RIGHT_ALIGNED:
                    return "RightAligned";
                    break;
                
                case Consts.HorizontalTextFormatting_HTF_CENTRE_ALIGNED:
                    return "HorzCentred";
                    break;
                
                case Consts.HorizontalTextFormatting_HTF_JUSTIFIED:
                    return "HorzJustified";
                    break;
                
                case Consts.HorizontalTextFormatting_HTF_WORDWRAP_LEFT_ALIGNED:
                    return "WordWrapLeftAligned";
                    break;
                
                case Consts.HorizontalTextFormatting_HTF_WORDWRAP_RIGHT_ALIGNED:
                    return "WordWrapRightAligned";
                    break;
                
                case Consts.HorizontalTextFormatting_HTF_WORDWRAP_CENTRE_ALIGNED:
                    return "WordWrapCentred";
                    break;
                
                case Consts.HorizontalTextFormatting_HTF_WORDWRAP_JUSTIFIED:
                    return "WordWrapJustified";
                    break;
                
                default:
                    return "LeftAligned";
                    break;
            }
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            var fmt:uint;
            
            if (value == "RightAligned")
            {
                fmt = Consts.HorizontalTextFormatting_HTF_RIGHT_ALIGNED;
            }
            else if (value == "HorzCentred")
            {
                fmt = Consts.HorizontalTextFormatting_HTF_CENTRE_ALIGNED;
            }
            else if (value == "HorzJustified")
            {
                fmt = Consts.HorizontalTextFormatting_HTF_JUSTIFIED;
            }
            else if (value == "WordWrapLeftAligned")
            {
                fmt = Consts.HorizontalTextFormatting_HTF_WORDWRAP_LEFT_ALIGNED;
            }
            else if (value == "WordWrapRightAligned")
            {
                fmt = Consts.HorizontalTextFormatting_HTF_WORDWRAP_RIGHT_ALIGNED;
            }
            else if (value == "WordWrapCentred")
            {
                fmt = Consts.HorizontalTextFormatting_HTF_WORDWRAP_CENTRE_ALIGNED;
            }
            else if (value == "WordWrapJustified")
            {
                fmt = Consts.HorizontalTextFormatting_HTF_WORDWRAP_JUSTIFIED;
            }
            else
            {
                fmt = Consts.HorizontalTextFormatting_HTF_LEFT_ALIGNED;
            }
            
            var wr:FalagardStaticText = (receiver as FlameWindow).getWindowRenderer() as FalagardStaticText;
            wr.setHorizontalFormatting(fmt);
        }

    }
}