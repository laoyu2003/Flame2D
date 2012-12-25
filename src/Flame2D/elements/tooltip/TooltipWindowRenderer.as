
package Flame2D.elements.tooltip
{
    import Flame2D.core.system.FlameWindowRenderer;
    import Flame2D.core.utils.Size;
    
    public class TooltipWindowRenderer extends FlameWindowRenderer
    {
        /*!
        \brief
        Constructor
        */
        public function TooltipWindowRenderer(name:String)
        {
            super(name, FlameTooltip.EventNamespace);
        }
        
        /*!
        \brief
        Return the size of the area that will be occupied by the tooltip text, given
        any current formatting options.
        
        \return
        Size object describing the size of the rendered tooltip text in pixels.
        */
        public function getTextSize():Size
        {
            return new Size();
        }
    }
}