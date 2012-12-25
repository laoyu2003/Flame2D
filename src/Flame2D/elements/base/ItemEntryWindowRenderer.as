
package Flame2D.elements.base
{
    import Flame2D.core.system.FlameWindowRenderer;
    import Flame2D.core.utils.Size;

    /*!
    \brief
    Base class for ItemEntry window renderer objects.
    */
    public class ItemEntryWindowRenderer extends FlameWindowRenderer
    {
        /*!
        \brief
        Constructor
        */
        public function ItemEntryWindowRenderer(name:String)
        {
            super(name, "ItemEntry");
        }
        
        /*!
        \brief
        Return the "optimal" size for the item
        
        \return
        Size describing the size in pixel that this ItemEntry's content requires
        for non-clipped rendering
        */
        public function getItemPixelSize():Size
        {
            return new Size();
        }
    }
}