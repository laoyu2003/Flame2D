

package Flame2D.core.fonts
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameFont;
    
    public class FontPropertyAutoScaled extends FlameProperty
    {
        public function FontPropertyAutoScaled()
        {
            super(
                "AutoScaled",
                "This is a flag indicating whether to autoscale font depending on " +
                "resolution.  Value is either true or false.");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameFont).isAutoScaled());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameFont).setAutoScaled(FlamePropertyHelper.stringToBool(value));
        }
    }
}