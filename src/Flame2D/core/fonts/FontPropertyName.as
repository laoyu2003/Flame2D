

package Flame2D.core.fonts
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameFont;
    
    public class FontPropertyName extends FlameProperty
    {
        public function FontPropertyName()
        {
            super(
                "Name",
                "This is font name.  Value is a string.");
        }
        
        override public function getValue(receiver:*):String
        {
            return (receiver as FlameFont).getName();
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            // Font can not be renamed
            trace("FontProperties::Name::set: " +
                "Attempt to set read-only propery 'Name' on Font '" +
                (receiver as FlameFont).getName() + "'- ignoring.");
        }
        
    }
}