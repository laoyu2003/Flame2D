/*!
\brief
Property to access the horizontal movement range for the thumb.

\par Usage:
- Name: HorzRange
- Format: "min:[float] max:[float]".

\par Where:
- min:[float] specifies the minimum horizontal setting (position) for the thumb, specified using the active metrics system for the window.
- max:[float] specifies the maximum horizontal setting (position) for the thumb, specified using the active metrics system for the window.
*/
package Flame2D.elements.thumb
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.utils.Vector2;
    
    public class ThumbPropertyHorzRange extends FlameProperty
    {
        public function ThumbPropertyHorzRange()
        {
            super(
                "HorzRange",
                "Property to get/set the horizontal movement range for the thumb.  Value is \"min:[float] max:[float]\".",
                "min:0.000000 max:1.000000");
        }
        
        override public function getValue(receiver:*):String
        {
            var range:Vector2 = (receiver as FlameThumb).getHorzRange();
            return "min:" + range.d_x + " max:" + range.d_y;
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            //min:%f max:%f
            var ts:String = value.replace(/min:/g, "").replace(/max:/g, "");
            var arr:Array = ts.split(" ");
            var rangeMin:Number = Number(arr[0]);
            var rangeMax:Number = Number(arr[1]);
            
            (receiver as FlameThumb).setHorzRange(rangeMin, rangeMax);
        }
    }
}