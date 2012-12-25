/*!
\brief
Property to access the unified position y-coordinate of the window.

\par Usage:
- Name: UnifiedYPosition
- Format: "{[s],[o]}"

\par Where:
- [s] is a floating point value describing the relative scale value for the position y-coordinate.
- [o] is a floating point value describing the absolute offset value for the position y-coordinate.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyUnifiedYPosition extends FlameProperty
    {
        public function PropertyUnifiedYPosition()
        {
            super(
                "UnifiedYPosition",
                "Property to get/set the windows unified position y-coordinate.  Value is a \"UDim\".",
                "{0,0}");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setYPosition(FlamePropertyHelper.stringToUDim(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.udimToString(FlameWindow(win).getYPosition());
        }
    }
}