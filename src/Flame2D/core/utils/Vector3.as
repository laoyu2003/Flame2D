
package Flame2D.core.utils
{
    import Flame2D.core.properties.FlamePropertyHelper;
    
    import flash.geom.Vector3D;

    public class Vector3 extends Vector3D
    {
        public function Vector3(x:Number = 0, y:Number = 0, z:Number = 0)
        {
            super(x, y, z);
        }
        
        public function add_(other:Vector3):Vector3
        {
            return new Vector3(x+other.x, y+other.y, z+other.z);
        }
        
        public function addTo(other:Vector3):void
        {
            x += other.x;
            y += other.y;
            z += other.z;
        }
        
        public function multiply(factor:Number):Vector3
        {
            return new Vector3(x*factor, y*factor, z*factor);
        }
        
        public function multiplyTo(factor:Number):void
        {
            x *= factor;
            y *= factor;
            z *= factor;
        }
        
        
        override public function toString():String
        {
            return FlamePropertyHelper.vector3ToString(this);
        }
    }
}