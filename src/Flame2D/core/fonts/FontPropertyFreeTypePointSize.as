

package Flame2D.core.fonts
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameWindow;
    
    public class FontPropertyFreeTypePointSize extends FlameProperty
    {
        public function FontPropertyFreeTypePointSize()
        {
            super(
                "PointSize",
                "This is the point size of the font.");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameTrueTypeFont).getPointSize());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameTrueTypeFont).setPointSize(FlamePropertyHelper.stringToFloat (value));
        }
        
    }
}