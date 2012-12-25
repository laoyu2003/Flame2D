
/*!
\brief
Property to access window mouse cursor setting.

This property offers access to the current mouse cursor image for the window.

\par Usage:
- Name: MouseCursorImage
- Format: "set:[text] image:[text]".

\par Where:
- set:[text] is the name of the Imageset containing the image.  The Imageset name should not contain spaces.  The Imageset specified must already be loaded.
- image:[text] is the name of the Image on the specified Imageset.  The Image name should not contain spaces.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyMouseCursorImage extends FlameProperty
    {
        public function PropertyMouseCursorImage()
        {
            super(
                "MouseCursorImage",
                "Property to get/set the mouse cursor image for the Window.  Value should be \"set:<imageset name> image:<image name>\".",
                "");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setMouseCursor(FlamePropertyHelper.stringToImage(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.imageToString(FlameWindow(win).getMouseCursor());
        }
        
        override public function isDefault(win:*):Boolean
        {
            return win.getMouseCursor() == null;
        }
    }
}