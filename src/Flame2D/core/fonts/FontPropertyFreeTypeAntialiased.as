

package Flame2D.core.fonts
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameWindow;
    
    public class FontPropertyFreeTypeAntialiased extends FlameProperty
    {
        public function FontPropertyFreeTypeAntialiased()
        {
            super(
                "Antialiased",
                "This is a flag indicating whenever to render antialiased font or not. " +
                "Value is either true or false.");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.boolToString((receiver as FlameTrueTypeFont).isAntiAliased());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameTrueTypeFont).setAntiAliased(FlamePropertyHelper.stringToBool(value));
        }
    }
}