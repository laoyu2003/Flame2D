
/*!
\brief
Property to access the dragging mouse cursor setting.

This property offers access to the mouse cursor image used when dragging the DragContainer.

\par Usage:
- Name: DragCursorImage
- Format: "set:[text] image:[text]".

\par Where:
- set:[text] is the name of the Imageset containing the image.  The Imageset name should not contain spaces.  The Imageset specified must already be loaded.
- image:[text] is the name of the Image on the specified Imageset.  The Image name should not contain spaces.
*/
package Flame2D.elements.dnd
{
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class DragContainerPropertyDragCursorImage extends FlameProperty
    {
        public function DragContainerPropertyDragCursorImage()
        {
            super(
                "DragCursorImage",
                "Property to get/set the mouse cursor image used when dragging.  Value should be \"set:<imageset name> image:<image name>\".",
                "");
        }
        
        override public function getValue(receiver:*):String
        {
            const img:FlameImage = (receiver as FlameDragContainer).getDragCursorImage();
            return img ? FlamePropertyHelper.imageToString(img) : "";
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            if (value.length != 0)
            {
                (receiver as FlameDragContainer).setDragCursorImage(FlamePropertyHelper.stringToImage(value));
            }
        }
    }
}