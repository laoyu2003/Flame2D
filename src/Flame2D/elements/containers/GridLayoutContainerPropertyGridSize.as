/*!
\brief
Namespace containing all classes that make up the properties interface for
the GridLayoutContainer class
*/
package Flame2D.elements.containers
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.utils.Size;
    
    public class GridLayoutContainerPropertyGridSize extends FlameProperty
    {
        public function GridLayoutContainerPropertyGridSize()
        {
            super(
                "GridSize",
                "Size of the grid of this layout container. " +
                "Value uses the 'w:# h:#' format and will be rounded up because " +
                "only integer values are valid as grid size.");
        }
        
        override public function getValue(receiver:*):String
        {
            const grid:FlameGridLayoutContainer = (receiver as FlameGridLayoutContainer);
            
            const size:Size = new Size(grid.getGridWidth(),grid.getGridHeight());
            
            return FlamePropertyHelper.sizeToString(size);
        }
        
        //----------------------------------------------------------------------------//
        override public function setValue(receiver:*, value:String):void
        {
            const grid:FlameGridLayoutContainer = (receiver as FlameGridLayoutContainer);
            var size:Size = FlamePropertyHelper.stringToSize(value);
            size.d_width = Math.max(0.0, size.d_width);
            size.d_height = Math.max(0.0, size.d_height);
            
            grid.setGridDimensions(Math.ceil(size.d_width), Math.ceil(size.d_height));
        }
        
    }
}