
/*!
\brief
Property to access window "Inherits Alpha" setting.

This property offers access to the inherits alpha setting for the window.

\par Usage:
- Name: InheritsAlpha
- Format: "[text]".

\par Where [Text] is:
- "True" to indicate the Window inherits alpha blend values from it's ancestors.
- "False" to indicate the Window does not inherit alpha blend values from it's ancestors.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyInheritsAlpha extends FlameProperty
    {
        public function PropertyInheritsAlpha()
        {
            super(
                "InheritsAlpha",
                "Property to get/set the 'inherits alpha' setting for the Window.  Value is either \"True\" or \"False\".",
                "True");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setInheritsAlpha(FlamePropertyHelper.stringToBool(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.boolToString(FlameWindow(win).inheritsAlpha());
        }
    }
}