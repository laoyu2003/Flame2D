

package Flame2D.core.fonts
{
    import Flame2D.core.properties.FlameProperty;
    
    public class FontPropertyPixmapMapping extends FlameProperty
    {
        public function FontPropertyPixmapMapping()
        {
            super(
                "Mapping",
                "This is the glyph-to-image mapping font property. It cannot be read. " +
                "Format is: codepoint,advance,imagename")
        }
        
        override public function getValue(receiver:*):String
        {
            return "";
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            //" %u , %g , %32s"
            var ts:String = value.replace(/ /g, "");
            var arr:Array = ts.split(",");
            var codepoint:uint = parseInt("0x" + arr[0], 16);
            var adv:Number = Number(arr[1]);
            var img:String = arr[2];
            
            (receiver as FlamePixmapFont).defineMapping(codepoint, img, adv);
        }
    }
}