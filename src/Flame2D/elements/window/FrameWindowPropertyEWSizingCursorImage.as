/*!
\brief
Property to access the E-W (left/right) sizing cursor image

\par Usage:
- Name: EWSizingCursorImage
- Format: "set:<imageset> image:<imagename>".

*/
package Flame2D.elements.window
{
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class FrameWindowPropertyEWSizingCursorImage extends FlameProperty
    {
        public function FrameWindowPropertyEWSizingCursorImage()
        {
            super(
                "EWSizingCursorImage",
                "Property to get/set the E-W (left-right) sizing cursor image for the FramwWindow.  Value should be \"set:[imageset name] image:[image name]\".",
                "");
        }
        
        override public function getValue(receiver:*):String
        {
            const img:FlameImage = (receiver as FlameFrameWindow).getEWSizingCursorImage();
            return img ? FlamePropertyHelper.imageToString(img) : "";
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameFrameWindow).setEWSizingCursorImage(FlamePropertyHelper.stringToImage(value));
        }
    }
}