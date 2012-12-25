/*!
\brief
Property to access window ID field.

This property offers access to the client specified ID for the window.

\par Usage:
- Name: ID
- Format: "[uint]".

\par Where:
- [uint] is any unsigned integer value.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyID extends FlameProperty
    {
        public function PropertyID()
        {
            super(
                "ID",
                "Property to get/set the ID value of the Window.  Value is an unsigned integer number.",
                "0");
        }
        override public function setDefaultValue(win:*):void
        {
            setValue(win, d_default);
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setID(FlamePropertyHelper.stringToUint(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.uintToString(FlameWindow(win).getID());
        }
    }
}