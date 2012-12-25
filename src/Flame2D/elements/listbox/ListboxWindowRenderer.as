
package Flame2D.elements.listbox
{
    import Flame2D.core.system.FlameWindowRenderer;
    import Flame2D.core.utils.Rect;

    /*!
    \brief
    Base class for Listbox window renderer.
    */
    public class ListboxWindowRenderer extends FlameWindowRenderer
    {
        /*!
        \brief
        Constructor
        */
        public function ListboxWindowRenderer(name:String)
        {
            super(name, FlameListbox.EventNamespace);
        }
        
        /*!
        \brief
        Return a Rect object describing, in un-clipped pixels, the window relative area
        that is to be used for rendering list items.
        
        \return
        Rect object describing the area of the Window to be used for rendering
        list box items.
        */
        public function getListRenderArea():Rect
        {
            return new Rect();
        }
    }
}