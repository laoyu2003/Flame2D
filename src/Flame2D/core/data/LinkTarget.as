
package Flame2D.core.data
{
    public class LinkTarget
    {
        //! name suffix of the target widget.
        public var d_widgetNameSuffix:String;
        //! the property to use on the target widget.
        public var d_targetProperty:String;
        
        public function LinkTarget(suffix:String, property:String):void
        {
            d_widgetNameSuffix = suffix;
            d_targetProperty = property;
        }
    }
}