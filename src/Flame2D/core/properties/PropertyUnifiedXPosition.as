/*!
\brief
Property to access the unified position x-coordinate of the window.

\par Usage:
- Name: UnifiedXPosition
- Format: "{[s],[o]}"

\par Where:
- [s] is a floating point value describing the relative scale value for the position x-coordinate.
- [o] is a floating point value describing the absolute offset value for the position x-coordinate.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyUnifiedXPosition extends FlameProperty
    {
        public function PropertyUnifiedXPosition()
        {
            super(
                "UnifiedXPosition",
                "Property to get/set the windows unified position x-coordinate.  Value is a \"UDim\".",
                "{0,0}");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setXPosition(FlamePropertyHelper.stringToUDim(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.udimToString(FlameWindow(win).getXPosition());
        }
    }
}