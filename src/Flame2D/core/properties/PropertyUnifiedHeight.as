
/*!
\brief
Property to access the unified height of the window.

\par Usage:
- Name: UnifiedHeight
- Format: "{[s],[o]}"

\par Where:
- [s] is a floating point value describing the relative scale value for the height.
- [o] is a floating point value describing the absolute offset value for the height.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyUnifiedHeight extends FlameProperty
    {
        public function PropertyUnifiedHeight()
        {
            super(
                "UnifiedHeight",
                "Property to get/set the windows unified height.  Value is a \"UDim\".",
                "{0,0}");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setHeight(FlamePropertyHelper.stringToUDim(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.udimToString(FlameWindow(win).getHeight());
        }
    }
}