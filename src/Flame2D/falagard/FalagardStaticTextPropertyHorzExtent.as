
package Flame2D.falagard
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameWindow;
    
    /*!
    \brief
    Read-only property to access the current horizontal extent of the formatted
    StaticText string.
    
    \par Usage:
    - Name: HorzExtent
    - Format: float value indicating the pixel extent.
    */
    public class FalagardStaticTextPropertyHorzExtent extends FlameProperty
    {
        public function FalagardStaticTextPropertyHorzExtent()
        {
            super(
                "HorzExtent",
                "Property to get the current horizontal extent of the formatted text " +
                "string.  Value is a float indicating the pixel extent.",
                "0");
        }
        
        //----------------------------------------------------------------------------//
        override public function getValue(receiver:*):String
        {
            var wr:FalagardStaticText = (receiver as FlameWindow).getWindowRenderer() as FalagardStaticText;
            return FlamePropertyHelper.floatToString(wr.getHorizontalTextExtent());
        }
        
        //----------------------------------------------------------------------------//
        override public function setValue(receiver:*, value:String):void
        {
            trace("Attempt to set value of '" + value + "' " +
                " to read only property 'HorzExtent' on window: " +
                (receiver as FlameWindow).getName());
        }
    }
}