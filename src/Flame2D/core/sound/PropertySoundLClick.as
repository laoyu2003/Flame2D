

package Flame2D.core.sound
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.system.FlameWindow;
    
    public class PropertySoundLClick extends FlameProperty
    {
        public function PropertySoundLClick()
        {
            super(
                "SoundLClick",
                "Property to get/set the left click sound.  Value is a \"String\".",
                "");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlameWindow(receiver).getLClickSound();
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            FlameWindow(receiver).setLClickSound(value);
        }
    }
}