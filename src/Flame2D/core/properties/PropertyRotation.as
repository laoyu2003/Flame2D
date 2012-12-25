/*!
\brief
Property to access the rotation factors of the window.

\par Usage:
- Name: Rotation
- Format: "x:[x_float] y:[y_float] z:[z_float]"

\par Where:
- [x_float] is a floating point value describing the rotation around the
x axis, in degrees.
- [y_float] is a floating point value describing the rotation around the
y axis, in degrees.
- [z_float] is a floating point value describing the rotation around the
z axis, in degrees.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyRotation extends FlameProperty
    {
        public function PropertyRotation()
        {
            super(
                "Rotation",
                "Property to get/set the windows rotation factors.  Value is " +
                "\"x:[x_float] y:[y_float] z:[z_float]\".",
                "x:0 y:0 z:0");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setRotation(FlamePropertyHelper.stringToVector3(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.vector3ToString(FlameWindow(win).getRotation());
        }
    }
}