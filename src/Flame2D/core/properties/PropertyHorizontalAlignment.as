/*!
\brief
Property to access the horizontal alignment setting for the window.

\par Usage:
- Name: HorizontalAlignment
- Format: "[text]".

\par Where [Text] is:
- "Left" to indicate the windows position is an offset of its left edge from its parents left edge.
- "Centre" to indicate the windows position is an offset of its centre point from its parents centre point.
- "Right" to indicate the windows position is an offset of its right edge from its parents right edge.
*/

package Flame2D.core.properties
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyHorizontalAlignment extends FlameProperty
    {
        public function PropertyHorizontalAlignment()
        {
            super(
                "HorizontalAlignment",
                "Property to get/set the windows horizontal alignment.  Value is one of \"Left\", \"Centre\" or \"Right\".",
                "Left");
        }
        
        override public function setValue(win:*, value:String):void
        {
            var align:uint;
            if(value == "Centre"){
                align = Consts.HorizontalAlignment_HA_CENTRE;
            } else if(value == "Right"){
                align = Consts.HorizontalAlignment_HA_RIGHT;
            } else {
                align = Consts.HorizontalAlignment_HA_LEFT;
            }
            
            FlameWindow(win).setHorizontalAlignment(align);
        }
        
        override public function getValue(win:*):String
        {
            var align:uint = FlameWindow(win).getHorizontalAlignment();
            switch(align){
                case Consts.HorizontalAlignment_HA_CENTRE:
                    return "Centre";
                case Consts.HorizontalAlignment_HA_RIGHT:
                    return "Right";
                default:
                    return "Left";
            }
        }
    }
}