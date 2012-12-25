
package Flame2D.elements.list
{
    import Flame2D.core.system.FlameWindowRenderer;

    public class ListHeaderWindowRenderer extends FlameWindowRenderer
    {
        
        /*!
        \brief
        Constructor
        */
        public function ListHeaderWindowRenderer(name:String)
        {
            super(name, FlameListHeader.EventNamespace);
        }
        
        /*!
        \brief
        Create and return a pointer to a new ListHeaderSegment based object.
        
        \param name
        String object holding the name that should be given to the new Window.
        
        \return
        Pointer to an ListHeaderSegment based object of whatever type is appropriate for
        this ListHeader.
        */
        public function createNewSegment(name:String):FlameListHeaderSegment
        {
            return null;
        }
        
        /*!
        \brief
        Cleanup and destroy the given ListHeaderSegment that was created via the
        createNewSegment method.
        
        \param segment
        Pointer to a ListHeaderSegment based object to be destroyed.
        
        \return
        Nothing.
        */
        public function destroyListSegment(segment:FlameListHeaderSegment):void
        {
            
        }
    }
}