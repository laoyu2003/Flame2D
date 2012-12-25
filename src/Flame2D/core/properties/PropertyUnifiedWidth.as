/*!
\brief
Property to access the unified width of the window.

\par Usage:
- Name: UnifiedWidth
- Format: "{[s],[o]}"

\par Where:
- [s] is a floating point value describing the relative scale value for the width.
- [o] is a floating point value describing the absolute offset value for the width.
*/


package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyUnifiedWidth extends FlameProperty
    {
        public function PropertyUnifiedWidth()
        {
            super(
                "UnifiedWidth",
                "Property to get/set the windows unified width.  Value is a \"UDim\".",
                "{0,0}");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setWidth(FlamePropertyHelper.stringToUDim(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.udimToString(FlameWindow(win).getWidth());
        }
    }
}