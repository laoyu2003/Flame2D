
package Flame2D.core.sound
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.system.FlameWindow;
    
    public class PropertySoundHover extends FlameProperty
    {
        public function PropertySoundHover()
        {
            super(
                "SoundHover",
                "Property to get/set the hover sound.  Value is a \"String\".",
                "");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlameWindow(receiver).getHoverSound();
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            FlameWindow(receiver).setHoverSound(value);
        }
    }
}