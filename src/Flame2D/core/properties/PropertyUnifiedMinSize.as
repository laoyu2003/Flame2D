/*!
\brief
Property to access the unified minimum size of the window.

\par Usage:
- Name: UnifiedMinSize
- Format: "{{[ws],[wo]},{[hs],[ho]}}"

\par Where:
- [ws] is a floating point value describing the relative scale value for the minimum width.
- [wo] is a floating point value describing the absolute offset value for the minimum width.
- [hs] is a floating point value describing the relative scale value for the minimum height.
- [ho] is a floating point value describing the absolute offset value for the minimum height.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyUnifiedMinSize extends FlameProperty
    {
        public function PropertyUnifiedMinSize()
        {
            super(
                "UnifiedMinSize",
                "Property to get/set the windows unified minimum size.  Value is a \"UVector2\".",
                "{{0,0},{0,0}}");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setMinSize(FlamePropertyHelper.stringToUVector2(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.uvector2ToString(FlameWindow(win).getMinSize());
        }
    }
}