/*!
\brief
Property to get/set whether the Window will automatically attempt to use a
full imagery caching RenderingSurface (if supported by the renderer).  Here,
"full imagery caching" usually will mean caching a window's representation
onto a texture (although no such implementation requirement is specified.)

\par Usage:
- Name: AutoRenderingSurface
- Format: "[text]".

\par Where [Text] is:
- "True" if Window should automatically use a full imagery caching
RenderingSurface (aka a RenderingWindow).
- "False" if Window should not automatically use a full imagery caching
RenderingSurface.
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyAutoRenderingSurface extends FlameProperty
    {
        public function PropertyAutoRenderingSurface()
        {
            super(
                "AutoRenderingSurface",
                "Property to get/set whether the Window will automatically attempt to " +
                "use a full imagery caching RenderingSurface (if supported by the " +
                "renderer).  Here, full imagery caching usually will mean caching a " +
                "window's representation onto a texture (although no such " +
                "implementation requirement is specified.)" +
                "  Value is either \"True\" or \"False\".",
                "False");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setUsingAutoRenderingSurface(FlamePropertyHelper.stringToBool(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.boolToString(FlameWindow(win).isUsingAutoRenderingSurface());
        }
    }
}