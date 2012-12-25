
package Flame2D.falagard
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.data.Consts;
    
    
    /*!
    \brief
    Property to access the vertical formatting mode setting.
    
    \par Usage:
    - Name: VertFormatting
    - Format: "[text]".
    
    \par Where [text] is one of:
    - "TopAligned"
    - "BottomAligned"
    - "VertCentred"
    */
    public class FalagardStaticTextPropertyVertFormatting extends FlameProperty
    {
        public function FalagardStaticTextPropertyVertFormatting()
        {
            super(
                "VertFormatting",
                "Property to get/set the vertical formatting mode.  Value is one of the VertFormatting strings.",
                "VertCentred");
        }
        
        
        override public function getValue(receiver:*):String
        {
            var wr:FalagardStaticText = (receiver as FlameWindow).getWindowRenderer() as FalagardStaticText;
            
            switch(wr.getVerticalFormatting())
            {
                case Consts.VerticalTextFormatting_VTF_BOTTOM_ALIGNED:
                    return "BottomAligned";
                    break;
                
                case Consts.VerticalTextFormatting_VTF_CENTRE_ALIGNED:
                    return "VertCentred";
                    break;
                
                default:
                    return "TopAligned";
                    break;
            }
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            var fmt:uint;
            
            if (value == "BottomAligned")
            {
                fmt = Consts.VerticalTextFormatting_VTF_BOTTOM_ALIGNED;
            }
            else if (value == "VertCentred")
            {
                fmt = Consts.VerticalTextFormatting_VTF_CENTRE_ALIGNED;
            }
            else
            {
                fmt = Consts.VerticalTextFormatting_VTF_TOP_ALIGNED;
            }
            
            var wr:FalagardStaticText = (receiver as FlameWindow).getWindowRenderer() as FalagardStaticText;
            wr.setVerticalFormatting(fmt);
        }

    }
}