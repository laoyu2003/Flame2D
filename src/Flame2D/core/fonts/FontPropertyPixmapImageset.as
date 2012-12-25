

package Flame2D.core.fonts
{
    import Flame2D.core.properties.FlameProperty;
    
    public class FontPropertyPixmapImageset extends FlameProperty
    {
        public function FontPropertyPixmapImageset()
        {
            super(
                "Imageset",
                "This is the name of the imageset which contains the glyph images for " +
                "this font.");
        }
        
        override public function getValue(receiver:*):String
        {
            return (receiver as FlamePixmapFont).getImageset();
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlamePixmapFont).setImageset(value);
        }
    }
}