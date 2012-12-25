
package Flame2D.core.sound
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.system.FlameWindow;
    
    public class PropertySoundHide extends FlameProperty
    {
        public function PropertySoundHide()
        {
            super(
                "SoundHide",
                "Property to get/set the hide sound.  Value is a \"String\".",
                "");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlameWindow(receiver).getHideSound();
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            FlameWindow(receiver).setHideSound(value);
        }
    }
}