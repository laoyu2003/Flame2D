/*!
\brief
Namespace containing all classes that make up the properties interface for
the GridLayoutContainer class
*/
package Flame2D.elements.containers
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.data.Consts;
    
    public class GridLayoutContainerPropertyAutoPositioning extends FlameProperty
    {
        public function GridLayoutContainerPropertyAutoPositioning()
        {
            super(
                "AutoPositioning",
                "Sets the method used for auto positioning. " +
                "Possible values: 'Disabled', 'Left to Right', 'Top to Bottom'.");
        }
        
        
        //----------------------------------------------------------------------------//
        override public function getValue(receiver:*):String
        {
            const grid:FlameGridLayoutContainer = receiver as FlameGridLayoutContainer;
            
            if (grid.getAutoPositioning() == Consts.AutoPositioning_AP_Disabled)
            {
                return "Disabled";
            }
            else if (grid.getAutoPositioning() == Consts.AutoPositioning_AP_LeftToRight)
            {
                return "Left to Right";
            }
            else if (grid.getAutoPositioning() == Consts.AutoPositioning_AP_TopToBottom)
            {
                return "Top to Bottom";
            }
            else
            {
                //assert(0);
                return "";
            }
        }
        
        //----------------------------------------------------------------------------//
        override public function setValue(receiver:*, value:String):void
        {
            var grid:FlameGridLayoutContainer = receiver as FlameGridLayoutContainer;
            
            if (value == "Disabled")
            {
                grid.setAutoPositioning(Consts.AutoPositioning_AP_Disabled);
            }
            else if (value == "Left to Right")
            {
                grid.setAutoPositioning(Consts.AutoPositioning_AP_LeftToRight);
            }
            else if (value == "Top to Bottom")
            {
                grid.setAutoPositioning(Consts.AutoPositioning_AP_TopToBottom);
            }
            else
            {
                // sensible default
                grid.setAutoPositioning(Consts.AutoPositioning_AP_LeftToRight);
            }
        }

    }
}