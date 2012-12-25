
package Flame2D.elements.tab
{
    import Flame2D.core.system.FlameWindowRenderer;

    public class TabControlWindowRenderer extends FlameWindowRenderer
    {
        /*!
        \brief
        Constructor
        */
        public function TabControlWindowRenderer(name:String)
        {
            super(name, FlameTabControl.EventNamespace);
        }
        
        /*!
        \brief
        create and return a pointer to a TabButton widget for use as a clickable tab header
        \param name
        Button name
        \return
        Pointer to a TabButton to be used for changing tabs.
        */
        public function createTabButton(name:String):FlameTabButton
        {
            return null;
        }
        
    }
}