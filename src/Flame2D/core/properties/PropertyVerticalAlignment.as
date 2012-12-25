/*!
\brief
Property to access the vertical alignment setting for the window.

\par Usage:
- Name: VerticalAlignment
- Format: "[text]".

\par Where [Text] is:
- "Top" to indicate the windows position is an offset of its top edge from its parents top edge.
- "Centre" to indicate the windows position is an offset of its centre point from its parents centre point.
- "Bottom" to indicate the windows position is an offset of its bottom edge from its parents bottom edge.
*/

package Flame2D.core.properties
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyVerticalAlignment extends FlameProperty
    {
        public function PropertyVerticalAlignment()
        {
            super(
                "VerticalAlignment",
                "Property to get/set the windows vertical alignment.  Value is one of \"Top\", \"Centre\" or \"Bottom\".",
                "Top");
        }
        
        override public function setValue(win:*, value:String):void
        {
            var align:uint;
            if(value ==  "Centre"){
                align = Consts.VerticalAlignment_VA_CENTRE;
            } else if(value == "Bottom"){
                align = Consts.VerticalAlignment_VA_BOTTOM;
            } else {
                align = Consts.VerticalAlignment_VA_TOP
            }
            
            FlameWindow(win).setVerticalAlignment(align);
        }
        
        override public function getValue(win:*):String
        {
            var align:uint = FlameWindow(win).getVerticalAlignment();
            switch(align){
                case Consts.VerticalAlignment_VA_CENTRE:
                    return "Centre";
                case Consts.VerticalAlignment_VA_BOTTOM:
                    return "Bottom";
                default:
                    return "Top";
            }
        }
    }
}