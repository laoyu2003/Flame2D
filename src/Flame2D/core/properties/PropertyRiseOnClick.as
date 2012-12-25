/*!
\brief
Property to access whether the window rises to the top of the z order when clicked.

\par Usage:
- Name: RiseOnClick
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate the Window will rise to the surface when clicked.
- "False" to indicate the Window will not change z position when clicked.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyRiseOnClick extends FlameProperty
    {
        public function PropertyRiseOnClick()
        {
            super(
                "RiseOnClick",
                "Property to get/set whether the window will come tot he top of the z order hwn clicked.  Value is either \"True\" or \"False\".",
                "True");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setRiseOnClickEnabled(FlamePropertyHelper.stringToBool(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.boolToString(FlameWindow(win).isRiseOnClickEnabled());
        }
    }
}