

package Flame2D.core.fonts
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameFont;
    
    public class FontPropertyNativeRes extends FlameProperty
    {
        public function FontPropertyNativeRes()
        {
            super(
                "NativeRes",
                "Native screen resolution for this font. Value uses the 'w:# h:#' " +
                "format.");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.sizeToString((receiver as FlameFont).getNativeResolution());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameFont).setNativeResolution(FlamePropertyHelper.stringToSize(value));
        }
    }
}