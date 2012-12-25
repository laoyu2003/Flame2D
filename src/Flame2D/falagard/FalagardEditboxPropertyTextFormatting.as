
package Flame2D.falagard
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.data.Consts;
    
    /*!
    \brief
    Property to access the horizontal formatting mode setting.
    
    \par Usage:
    - Name: TextFormatting
    - Format: "[text]".
    
    \par Where [text] is one of:
    - "LeftAligned"
    - "RightAligned"
    - "HorzCentred"
    */
    public class FalagardEditboxPropertyTextFormatting extends FlameProperty
    {
        public function FalagardEditboxPropertyTextFormatting()
        {
            super(
                "TextFormatting",
                "Property to get/set the horizontal formatting mode. " +
                "Value is one of: LeftAligned, RightAligned or HorzCentred",
                "LeftAligned");
        }
        
        //----------------------------------------------------------------------------//
        override public function getValue(receiver:*):String
        {
            var wr:FalagardEditbox = (receiver as FlameWindow).getWindowRenderer() as FalagardEditbox;
            
            switch(wr.getTextFormatting())
            {
                case Consts.HorizontalTextFormatting_HTF_RIGHT_ALIGNED:
                    return "RightAligned";
                    break;
                
                case Consts.HorizontalTextFormatting_HTF_CENTRE_ALIGNED:
                    return "HorzCentred";
                    break;
                
                default:
                    return "LeftAligned";
                    break;
            }
        }
        
        //----------------------------------------------------------------------------//
        override public function setValue(receiver:*, value:String):void
        {
            var fmt:uint;
            
            if (value == "RightAligned")
                fmt = Consts.HorizontalTextFormatting_HTF_RIGHT_ALIGNED;
            else if (value == "HorzCentred")
                fmt = Consts.HorizontalTextFormatting_HTF_CENTRE_ALIGNED;
            else
                fmt = Consts.HorizontalTextFormatting_HTF_LEFT_ALIGNED;
            
            var wr:FalagardEditbox = (receiver as FlameWindow).getWindowRenderer() as FalagardEditbox;
            wr.setTextFormatting(fmt);
        }

    }
}