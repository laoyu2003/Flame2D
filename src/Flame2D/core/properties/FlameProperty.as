
package Flame2D.core.properties
{

    public class FlameProperty
    {
        public var d_name:String;
        public var d_help:String;
        public var d_default:String = "";
        public var d_value:String = "";
        
        
        public function FlameProperty(name:String, help:String, defaultValue:String = "")
        {
            this.d_name = name;
            this.d_help = help;
            this.d_default = defaultValue;
        }
        
//        public function initialisePropertyReceiver(win:FlameWindow):void
//        {
//        }
        
        public function getName():String
        {
            return this.d_name;
        }
        
        public function getHelp():String
        {
            return this.d_help;
        }

        
        //interface
        public function getValue(receiver:*):String
        {
            return "";
        }
        
        public function getDefaultValue():String
        {
            return this.d_default;
        }
        
        public function setDefaultValue(receiver:*):void
        {
            
        }
        
        public function isDefault(receiver:*):Boolean
        {
            return true;
        }

        //interface
        public function setValue(receiver:*, value:String):void
        {
            this.d_value = value;
        }
        
        //virtual
        public function initialisePropertyReceiver(receiver:*):void
        {
        }
    }
}