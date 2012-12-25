
package Flame2D.falagard
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameWindow;
    
    /*!
    \brief
    Property to access the image for the FalagardStaticImage widget.
    
    \par Usage:
    - Name: Image
    - Format: "set:[text] image:[text]".
    
    \par Where:
    - set:[text] is the name of the Imageset containing the image.  The Imageset name should not contain spaces.  The Imageset specified must already be loaded.
    - image:[text] is the name of the Image on the specified Imageset.  The Image name should not contain spaces.
    */
    public class FalagardStaticImagePropertyImage extends FlameProperty
    {
        public function FalagardStaticImagePropertyImage()
        {
            super(
                "Image",
                "Property to get/set the image for the FalagardStaticImage widget.  Value should be \"set:[imageset name] image:[image name]\".",
                "");
        }
        
        override public function getValue(receiver:*):String
        {
            var wr:FalagardStaticImage = (receiver as FlameWindow).getWindowRenderer() as FalagardStaticImage;
            return FlamePropertyHelper.imageToString(wr.getImage());
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            var wr:FalagardStaticImage = (receiver as FlameWindow).getWindowRenderer() as FalagardStaticImage;
            wr.setImage(FlamePropertyHelper.stringToImage(value));
        }
    }
}