/*!
\brief
Property to access the x axis rotation factor of the window.

\par Usage:
- Name: XRotation
- Format: "[float]"

\par Where:
- [float] is a floating point value describing the rotation around the
x axis, in degrees.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.utils.Vector3;
    
    public class PropertyXRotation extends FlameProperty
    {
        public function PropertyXRotation()
        {
            super(
                "XRotation",
                "Property to get/set the window's x axis rotation factor.  Value is " +
                "\"[float]\".",
                "0");
        }
        
        override public function setValue(win:*, value:String):void
        {
            var r:Vector3 = new Vector3();
            var wr:Vector3 = win.getRotation();
            r.x = FlamePropertyHelper.stringToFloat(value);
            r.y = wr.y;
            r.z = wr.z;
            FlameWindow(win).setRotation(r);
        }
        
        override public function getValue(win:*):String
        {
            var r:Vector3 = FlameWindow(win).getRotation();
            return FlamePropertyHelper.floatToString(r.x);
        }
    }
}