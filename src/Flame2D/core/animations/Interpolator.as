
package Flame2D.core.animations
{
    public class Interpolator
    {
        
        //! returns type string of this interpolator
        public function getType():String
        {
            return "";
        }
        
        // interpolate methods aren't const, because the interpolator could provide
        // some sort of caching mechanism if converting properties is too expensive
        // that it is worth it
        
        /** this is used when Affector is set to apply values in absolute mode
         * (application method == AM_Absolute)
         */
        public function interpolateAbsolute(value1:String, value2:String, position:Number):String
        {
            return "";
        }
        
        /** this is used when Affector is set to apply values in relative mode
         * (application method == AM_Relative)
         */
        public function interpolateRelative(base:String, value1:String, value2:String, position:Number):String
        {
            return "";
        }
        
        /** this is used when Affector is set to apply values in relative multiply
         * mode (application method == AM_RelativeMultiply)
         */
        public function interpolateRelativeMultiply(base:String, value1:String, value2:String, position:Number):String
        {
            return "";
        }
        
        
    }
}