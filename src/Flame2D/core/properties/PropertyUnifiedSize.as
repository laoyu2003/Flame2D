/*!
\brief
Property to access the unified position of the window.

\par Usage:
- Name: UnifiedSize
- Format: "{{[ws],[wo]},{[hs],[ho]}}"

\par Where:
- [ws] is a floating point value describing the relative scale value for the width.
- [wo] is a floating point value describing the absolute offset value for the width.
- [hs] is a floating point value describing the relative scale value for the height.
- [ho] is a floating point value describing the absolute offset value for the height.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyUnifiedSize extends FlameProperty
    {
        public function PropertyUnifiedSize()
        {
            super(
                "UnifiedSize",
                "Property to get/set the windows unified size.  Value is a \"UVector2\".",
                "{{0,0},{0,0}}");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setSize(FlamePropertyHelper.stringToUVector2(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.uvector2ToString(FlameWindow(win).getSize());
        }
    }
}