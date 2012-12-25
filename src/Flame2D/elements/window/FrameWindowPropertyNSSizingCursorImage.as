/*!
\brief
Property to access the N-S (up-down) sizing cursor image

\par Usage:
- Name: NSSizingCursorImage
- Format: "set:<imageset> image:<imagename>".

*/
package Flame2D.elements.window
{
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class FrameWindowPropertyNSSizingCursorImage extends FlameProperty
    {
        public function FrameWindowPropertyNSSizingCursorImage()
        {
            super(
                "NSSizingCursorImage",
                "Property to get/set the N-S (up-down) sizing cursor image for the FramwWindow.  Value should be \"set:[imageset name] image:[image name]\".",
                "");
        }
        
        override public function getValue(receiver:*):String
        {
            const img:FlameImage = (receiver as FlameFrameWindow).getNSSizingCursorImage();
            return img ? FlamePropertyHelper.imageToString(img) : "";
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameFrameWindow).setNSSizingCursorImage(FlamePropertyHelper.stringToImage(value));
        }
    }
}