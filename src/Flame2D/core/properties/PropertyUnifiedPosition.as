/*!
\brief
Property to access the unified position of the window.

\par Usage:
- Name: UnifiedPosition
- Format: "{{[xs],[xo]},{[ys],[yo]}}"

\par Where:
- [xs] is a floating point value describing the relative scale value for the position x-coordinate.
- [xo] is a floating point value describing the absolute offset value for the position x-coordinate.
- [ys] is a floating point value describing the relative scale value for the position y-coordinate.
- [yo] is a floating point value describing the absolute offset value for the position y-coordinate.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyUnifiedPosition extends FlameProperty
    {
        public function PropertyUnifiedPosition()
        {
            super(
                "UnifiedPosition",
                "Property to get/set the windows unified position.  Value is a \"UVector2\".",
                "{{0,0},{0,0}}");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setPosition(FlamePropertyHelper.stringToUVector2(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.uvector2ToString(FlameWindow(win).getPosition());
        }
    }
}