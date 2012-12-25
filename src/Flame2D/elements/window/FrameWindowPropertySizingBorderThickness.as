/*!
\brief
Property to access the setting for the sizing border thickness.

\par Usage:
- Name: SizingBorderThickness
- Format: "[float]".

\par Where:
- [float] is the size of the invisible sizing border in screen pixels.
*/
package Flame2D.elements.window
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class FrameWindowPropertySizingBorderThickness extends FlameProperty
    {
        public function FrameWindowPropertySizingBorderThickness()
        {
            super(
                "SizingBorderThickness",
                "Property to get/set the setting for the sizing border thickness.  Value is a float specifying the border thickness in pixels.",
                "8");
        }
        
        
        override public function getValue(receiver:*):String
        {
            return FlamePropertyHelper.floatToString((receiver as FlameFrameWindow).getSizingBorderThickness());
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            (receiver as FlameFrameWindow).setSizingBorderThickness(FlamePropertyHelper.stringToFloat(value));
        }

    }
}