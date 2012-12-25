package Flame2D.core.sound
{
    import Flame2D.core.system.FlameResourceProvider;
    import Flame2D.loaders.DataFileLoader;
    
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    
    import org.as3wavsound.WavSound;
    import org.as3wavsound.sazameki.format.wav.Wav;
    
    public class FlameSoundManager
    {
        
        private static var d_singleton:FlameSoundManager = new FlameSoundManager();
        private var d_volumn:Number = 20;
        //a cache for sound
        private var d_sounds:Dictionary = new Dictionary();
        
        public function FlameSoundManager()
        {
            if(d_singleton != null)
            {
                throw new Error("Please use singleton");
            }
            
            initialize();
        }
            
        public static function getSingleton():FlameSoundManager
        {
            return d_singleton;
        }
        
        public function initialize():void
        {
            
        }
        
        
        public function playSound(name:String):void
        {
            if(d_sounds.hasOwnProperty(name))
            {
                (d_sounds[name] as WavSound).play(0, 0);
            }
            else
            {
                var url:String = FlameResourceProvider.getSingleton().getResourceDir() + 
                    FlameResourceProvider.getSingleton().getSoundsDir() + 
                    name;
                
                new DataFileLoader({name:name}, url, onSoundLoaded);
            }
        }
        
        private function onSoundLoaded(tag:Object, ba:ByteArray):void
        {
            var vs:WavSound = new WavSound(ba);
            vs.play(0,0);

            d_sounds[tag.name] = vs;
        }
        
        public function stopSound(sound:String):void
        {
            
        }
    }
    
    
}