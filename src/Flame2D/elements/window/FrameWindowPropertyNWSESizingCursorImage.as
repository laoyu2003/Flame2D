/*!
\brief
Property to access the NW-SE diagonal sizing cursor image

\par Usage:
- Name: NWSESizingCursorImage
- Format: "set:<imageset> image:<imagename>".

*/
package Flame2D.elements.window
{
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class FrameWindowPropertyNWSESizingCursorImage extends FlameProperty
    {
        public function FrameWindowPropertyNWSESizingCursorImage()
        {
            super(
                "NWSESizingCursorImage",
                "Property to get/set the NW-SE diagonal sizing cursor image for the FramwWindow.  Value should be \"set:[imageset name] image:[image name]\".",
                "");
        }
        
        override public function getValue(receiver:*):String
        {
            const img:FlameImage = (receiver as FlameFrameWindow).getNWSESizingCursorImage();
            return img ? FlamePropertyHelper.imageToString(img) : "";
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameFrameWindow).setNWSESizingCursorImage(FlamePropertyHelper.stringToImage(value));
        }
    }
}