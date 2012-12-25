/*!
\brief
Property to access the z axis rotation factor of the window.

\par Usage:
- Name: ZRotation
- Format: "[float]"

\par Where:
- [float] is a floating point value describing the rotation around the
z axis, in degrees.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.utils.Vector3;
    
    public class PropertyZRotation extends FlameProperty
    {
        public function PropertyZRotation()
        {
            super(
                "ZRotation",
                "Property to get/set the window's z axis rotation factor.  Value is " +
                "\"[float]\".",
                "0");
        }
        
        override public function setValue(win:*, value:String):void
        {
            var r:Vector3 = new Vector3();
            var wr:Vector3 = FlameWindow(win).getRotation();
            r.x = wr.x;
            r.y = wr.y;
            r.z = FlamePropertyHelper.stringToFloat(value);
            FlameWindow(win).setRotation(r);
        }
        
        override public function getValue(win:*):String
        {
            var r:Vector3 = FlameWindow(win).getRotation();
            return FlamePropertyHelper.floatToString(r.z);
        }
    }
}