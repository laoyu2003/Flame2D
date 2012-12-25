
package Flame2D.core.sound
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.system.FlameWindow;
    
    public class PropertySoundRClick extends FlameProperty
    {
        public function PropertySoundRClick()
        {
            super(
                "SoundRClick",
                "Property to get/set the right click sound.  Value is a \"String\".",
                "");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlameWindow(receiver).getRClickSound();
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            FlameWindow(receiver).setRClickSound(value);
        }
    }
}