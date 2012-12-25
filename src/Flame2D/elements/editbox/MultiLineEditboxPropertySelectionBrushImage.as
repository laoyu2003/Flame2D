
/*!
\brief
Property to access the selection brush image

\par Usage:
- Name: SelectionBrushImage
- Format: "set:<imageset> image:<imagename>".

*/
package Flame2D.elements.editbox
{
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class MultiLineEditboxPropertySelectionBrushImage extends FlameProperty
    {
        public function MultiLineEditboxPropertySelectionBrushImage()
        {
            super(
                "SelectionBrushImage",
                "Property to get/set the selection brush image for the editbox.  Value should be \"set:[imageset name] image:[image name]\".",
                "");
        }
        
        override public function getValue(receiver:*):String
        {
            const img:FlameImage = (receiver as FlameMultiLineEditbox).getSelectionBrushImage();
            return img ? FlamePropertyHelper.imageToString(img) : "";
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameMultiLineEditbox).setSelectionBrushImage(FlamePropertyHelper.stringToImage(value));
        }
    }
}