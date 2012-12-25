
package Flame2D.core.sound
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.system.FlameWindow;
    
    public class PropertySoundShow extends FlameProperty
    {
        public function PropertySoundShow()
        {
            super(
                "SoundShow",
                "Property to get/set the show sound.  Value is a \"String\".",
                "");
        }
        
        override public function getValue(receiver:*):String
        {
            return FlameWindow(receiver).getShowSound();
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            FlameWindow(receiver).setShowSound(value);   
        }
    }
}