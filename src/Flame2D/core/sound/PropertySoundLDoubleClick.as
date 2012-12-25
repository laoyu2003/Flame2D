

package Flame2D.core.sound
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.system.FlameWindow;
    
    public class PropertySoundLDoubleClick extends FlameProperty
    {
        public function PropertySoundLDoubleClick()
        {
            super(
                "SoundLDoubleClick",
                "Property to get/set the right click sound.  Value is a \"String\".",
                "");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlameWindow(receiver).getLDoubleClickSound();
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            FlameWindow(receiver).setLDoubleClickSound(value);
        }
    }
}