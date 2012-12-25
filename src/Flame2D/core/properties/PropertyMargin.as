/*!
\brief
Property to access window margin.

This property offers access to the margin property. This property controls
the margins of the window when it's inserted into a layout container.
When the window isn't in a layout container, margin doesn't have any effect.

\par Usage:
- Name: Margin
- Format: "{top:{[tops],[topo]},left:{[lefts],[lefto]},bottom:{[bottoms],[bottomo]},right:{[rights],[righto]}}".

\par Where [Text] is:
- [tops] is top scale
- [topo] is top offset
- [lefts] is left scale
- [lefto] is left offset
- [bottoms] is bottom scale
- [bottomo] is bottom offset
- [rights] is right scale
- [righto] is right offset
*/

package Flame2D.core.properties
{
    import Flame2D.core.system.FlameWindow;
    
    public class PropertyMargin extends FlameProperty
    {
        public function PropertyMargin()
        {
            super(
                "Margin",
                "Property to get/set margin for the Window. Value format:" +
                "{top:{[tops],[topo]},left:{[lefts],[lefto]},bottom:{[bottoms],[bottomo]},right:{[rights],[righto]}}.",
                "{top:{0,0},left:{0,0},bottom:{0,0},right:{0,0}}");
        }
        
        override public function setValue(win:*, value:String):void
        {
            FlameWindow(win).setMargin(FlamePropertyHelper.stringToUBox(value));
        }
        
        override public function getValue(win:*):String
        {
            return FlamePropertyHelper.uboxToString(FlameWindow(win).getMargin());
        }
    }
}