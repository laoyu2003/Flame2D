
/*!
\brief
Property to access the NE-SW diagonal sizing cursor image

\par Usage:
- Name: NESWSizingCursorImage
- Format: "set:<imageset> image:<imagename>".

*/
package Flame2D.elements.window
{
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class FrameWindowPropertyNESWSizingCursorImage extends FlameProperty
    {
        public function FrameWindowPropertyNESWSizingCursorImage()
        {
            super(
                "NESWSizingCursorImage",
                "Property to get/set the NE-SW diagonal sizing cursor image for the FramwWindow.  Value should be \"set:[imageset name] image:[image name]\".",
                "");
        }
        
        override public function getValue(receiver:*):String
        {
            const img:FlameImage = (receiver as FlameFrameWindow).getNESWSizingCursorImage();
            return img ? FlamePropertyHelper.imageToString(img) : "";
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameFrameWindow).setNESWSizingCursorImage(FlamePropertyHelper.stringToImage(value));
        }

    }
}