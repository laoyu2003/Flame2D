
/*!
\brief
Property to access the unified maximum size of the window.

\par Usage:
- Name: UnifiedMaxSize
- Format: "{{[ws],[wo]},{[hs],[ho]}}"

\par Where:
- [ws] is a floating point value describing the relative scale value for the maximum width.
- [wo] is a floating point value describing the absolute offset value for the maximum width.
- [hs] is a floating point value describing the relative scale value for the maximum height.
- [ho] is a floating point value describing the absolute offset value for the maximum height.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyUnifiedMaxSize extends FlameProperty
    {
        public function PropertyUnifiedMaxSize()
        {
            super(
                "UnifiedMaxSize",
                "Property to get/set the windows unified maximum size.  Value is a \"UVector2\".",
                "{{1,0},{1,0}}");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setMaxSize(FlamePropertyHelper.stringToUVector2(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.uvector2ToString(FlameWindow(win).getMaxSize());
        }
    }
}