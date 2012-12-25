/*!
\brief
Property to access window alpha setting.

This property offers access to the alpha-blend setting for the window.

\par Usage:
- Name: Alpha
- Format: "[float]".

\par Where:
- [float] is a floating point number between 0.0 and 1.0.
*/
package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyAlpha extends FlameProperty
    {
        public function PropertyAlpha()
        {
            super(
                "Alpha",
                "Property to get/set the alpha value of the Window.  Value is floating point number.",
                "1");
        }
        
        override public function setDefaultValue(win:*):void
        {
            setValue(win, d_default);
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setAlpha(FlamePropertyHelper.stringToFloat(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.floatToString(FlameWindow(win).getAlpha());
        }
    }
}