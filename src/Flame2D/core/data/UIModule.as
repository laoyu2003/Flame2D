
package Flame2D.core.data
{
    import Flame2D.core.system.FlameFactoryModule;
    
    public class UIModule
    {
        public var name:String;
        public var module:FlameFactoryModule;
        //public var factories:Vector.<UIElementFactory>;
        public var factories:Vector.<String> = new Vector.<String>();
    }
}