
package Flame2D.elements.editbox
{
    import Flame2D.core.system.FlameWindowRenderer;
    import Flame2D.core.utils.Vector2;
    
    public class EditboxWindowRenderer extends FlameWindowRenderer
    {
        //! Constructor
        public function EditboxWindowRenderer(name:String)
        {
            super(name, FlameEditbox.EventNamespace)
        }
        
        /*!
        \brief
        Return the text code point index that is rendered closest to screen
        position \a pt.
        
        \param pt
        Point object describing a position on the screen in pixels.
        
        \return
        Code point index into the text that is rendered closest to screen
        position \a pt.
        */
        //virtual
        public function getTextIndexFromPosition(pt:Vector2):uint
        {
            return 0;
        }
    }
}