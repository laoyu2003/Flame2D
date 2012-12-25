
package Flame2D.elements.base
{
    import Flame2D.core.system.FlameWindowRenderer;
    import Flame2D.core.utils.Rect;

    public class ItemListBaseWindowRenderer extends FlameWindowRenderer
    {
        /*!
        \brief
        Constructor
        */
        public function ItemListBaseWindowRenderer(name:String)
        {
            super(name, "ItemListBase");
        }
        
        /*!
        \brief
        Return a Rect object describing, in un-clipped pixels, the window relative area
        that is to be used for rendering list items.
        
        \return
        Rect object describing the window relative area of the that is to be used for rendering
        the items.
        */
        public function getItemRenderArea():Rect
        {
            return new Rect();
        }
    }
}