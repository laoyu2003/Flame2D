/*!
\brief
Property to access the segment sizing cursor image

\par Usage:
- Name: SizingCursorImage
- Format: "set:<imageset> image:<imagename>".

*/
package Flame2D.elements.list
{
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ListHeaderSegmentPropertySizingCursorImage extends FlameProperty
    {
        public function ListHeaderSegmentPropertySizingCursorImage()
        {
            super(
                "SizingCursorImage",
                "Property to get/set the sizing cursor image for the List Header Segment.  Value should be \"set:[imageset name] image:[image name]\".",
                "");
        }
        
        override public function getValue(receiver:*):String
        {
            const img:FlameImage = (receiver as FlameListHeaderSegment).getSizingCursorImage();
            return img ? FlamePropertyHelper.imageToString(img) : "";
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameListHeaderSegment).setSizingCursorImage(FlamePropertyHelper.stringToImage(value));
        }
    }
}