/*!
\brief
Property to access/change the assigned look'n'feel.

\par Usage:
- Name: LookNFeel
- Format: "[LookNFeelName]"

\par Where [LookNFeelName] is the name of the look'n'feel you wish to assign.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyLookNFeel extends FlameProperty
    {
        public function PropertyLookNFeel()
        {
            super(
                "LookNFeel",
                "Property to get/set the windows assigned look'n'feel.  Value is a string.",
                "")
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setLookNFeel(value);
        }
        
        override public function getValue(win:*):String
        {
            return FlameWindow(win).getLookNFeel();
        }
    }
}