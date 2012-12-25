/*!
\brief
Property to access the TextInputMode setting.

This property offers access the text display and input mode for the spinner.

\par Usage:
- Name: TextInputMode
- Format: "[text]".

\par Where [text] is:
- "FloatingPoint" for floating point decimal numbers.
- "Integer" for integer decimal numbers.
- "Hexadecimal" for hexadecimal numbers.
- "Octal" for octal numbers.
*/
package Flame2D.elements.spinner
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.data.Consts;
    
    public class SpinnerPropertyTextInputMode extends FlameProperty
    {
        public function SpinnerPropertyTextInputMode()
        {
            super(
                "TextInputMode",
                "Property to get/set the TextInputMode setting for the spinner.  Value is \"FloatingPoint\", \"Integer\", \"Hexadecimal\", or \"Octal\".",
                "Integer");
        }
        
        override public function getValue(receiver:*):String
        {
            switch((receiver as FlameSpinner).getTextInputMode())
            {
                case Consts.TextInputMode_FloatingPoint:
                    return String("FloatingPoint");
                    break;
                case Consts.TextInputMode_Hexadecimal:
                    return String("Hexadecimal");
                    break;
                case Consts.TextInputMode_Octal:
                    return String("Octal");
                    break;
                default:
                    return String("Integer");
            }
        }
        
        override public function setValue(receiver:*, value:String):void
        {
            var mode:int;
            
            if (value == "FloatingPoint")
            {
                mode = Consts.TextInputMode_FloatingPoint;
            }
            else if (value == "Hexadecimal")
            {
                mode = Consts.TextInputMode_Hexadecimal;
            }
            else if (value == "Octal")
            {
                mode = Consts.TextInputMode_Octal;
            }
            else
            {
                mode = Consts.TextInputMode_Integer;
            }
            
            (receiver as FlameSpinner).setTextInputMode(mode);
        }

    }
}