/*!
\brief
Property to access the segment moving cursor image

\par Usage:
- Name: MovingCursorImage
- Format: "set:<imageset> image:<imagename>".

*/
package Flame2D.elements.list
{
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class ListHeaderSegmentPropertyMovingCursorImage extends FlameProperty
    {
        public function ListHeaderSegmentPropertyMovingCursorImage()
        {
            super(
                "MovingCursorImage",
                "Property to get/set the moving cursor image for the List Header Segment.  Value should be \"set:[imageset name] image:[image name]\".",
                "");
        }
        
        override public function getValue(receiver:*):String
        {
            const img:FlameImage = (receiver as FlameListHeaderSegment).getMovingCursorImage();
            return img ? FlamePropertyHelper.imageToString(img) : "";
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameListHeaderSegment).setMovingCursorImage(FlamePropertyHelper.stringToImage(value));
        }
    }
}