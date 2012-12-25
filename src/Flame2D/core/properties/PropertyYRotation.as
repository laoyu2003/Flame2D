/*!
\brief
Property to access the y axis rotation factor of the window.

\par Usage:
- Name: YRotation
- Format: "[float]"

\par Where:
- [float] is a floating point value describing the rotation around the
y axis, in degrees.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.utils.Vector3;
    
    public class PropertyYRotation extends FlameProperty
    {
        public function PropertyYRotation()
        {
            super(
                "YRotation",
                "Property to get/set the window's y axis rotation factor.  Value is " +
                "\"[float]\".",
                "0");
        }
        
        override public function setValue(win:*, value:String):void
        {
            var r:Vector3 = new Vector3();
            var wr:Vector3 = FlameWindow(win).getRotation();
            r.x = wr.x;
            r.y = FlamePropertyHelper.stringToFloat(value);
            r.z = wr.z;
            FlameWindow(win).setRotation(r);
        }
        
        override public function getValue(win:*):String
        {
            var r:Vector3 = FlameWindow(win).getRotation();
            return FlamePropertyHelper.floatToString(r.y);
        }
    }
}