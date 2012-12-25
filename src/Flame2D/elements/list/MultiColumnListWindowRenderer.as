
package Flame2D.elements.list
{
    import Flame2D.core.system.FlameWindowRenderer;
    import Flame2D.core.utils.Rect;
    
    public class MultiColumnListWindowRenderer extends FlameWindowRenderer
    {
        
        /*!
        \brief
        Constructor
        */
        public function MultiColumnListWindowRenderer(name:String)
        {
            super(name, FlameMultiColumnList.EventNamespace);
        }
        
        /*!
        \brief
        Return a Rect object describing, in un-clipped pixels, the window relative area
        that is to be used for rendering list items.
        
        \return
        Rect object describing the area of the Window to be used for rendering
        list box items.
        */
        //virtual
        public function getListRenderArea():Rect
        {
            return new Rect();
        }
        
        
    }
}