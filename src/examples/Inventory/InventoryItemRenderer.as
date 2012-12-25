package examples.Inventory
{
    import Flame2D.core.falagard.FalagardWidgetLookFeel;
    import Flame2D.core.system.FlameWindowRenderer;

    public class InventoryItemRenderer extends FlameWindowRenderer
    {
        public static const TypeName:String = "InventoryItemRenderer";
        
        public function InventoryItemRenderer(type:String)
        {
            super(type);
        }
        
        override public function render():void
        {
            const wlf:FalagardWidgetLookFeel = getLookNFeel();
            
            var item:InventoryItem = InventoryItem(d_window);
            
            if (!item)
                // render basic imagery
                wlf.getStateImagery(d_window.isDisabled() ? "Disabled" : "Enabled").render(d_window);
            
            if (item.isBeingDragged())
                wlf.getStateImagery(item.currentDropTargetIsValid() ? "DraggingValidTarget" : "DraggingInvalidTarget").render(item);
            else
                wlf.getStateImagery("Normal").render(item);
        }
    }
        
}