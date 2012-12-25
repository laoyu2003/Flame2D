/*!
\brief
Property to access the unified area rectangle of the window.

\par Usage:
- Name: UnifiedAreaRect
- Format: "{{[ls],[lo]},{[ts],[to]},{[rs],[ro]},{[bs],[bo]}}"

\par Where:
- [ls] is a floating point value describing the relative scale value for the left edge.
- [lo] is a floating point value describing the absolute offset value for the left edge.
- [ts] is a floating point value describing the relative scale value for the top edge.
- [to] is a floating point value describing the absolute offset value for the top edge.
- [rs] is a floating point value describing the relative scale value for the right edge.
- [ro] is a floating point value describing the absolute offset value for the right edge.
- [bs] is a floating point value describing the relative scale value for the bottom edge.
- [bo] is a floating point value describing the absolute offset value for the bottom edge.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyUnifiedAreaRect extends FlameProperty
    {
        public function PropertyUnifiedAreaRect()
        {
            super(
                "UnifiedAreaRect",
                "Property to get/set the windows unified area rectangle.  Value is a \"URect\".",
                "{{0,0},{0,0},{0,0},{0,0}}");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setAreaByURect(FlamePropertyHelper.stringToURect(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.urectToString(FlameWindow(win).getArea());
        }
    }
}