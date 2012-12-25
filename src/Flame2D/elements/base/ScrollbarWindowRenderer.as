
package Flame2D.elements.base
{
    import Flame2D.core.system.FlameWindowRenderer;
    import Flame2D.core.utils.Vector2;
    
    
    /*!
    \brief
    Base class for Scrollbar window renderer objects.
    */
    public class ScrollbarWindowRenderer extends FlameWindowRenderer
    {
        /*!
        \brief
        Constructor
        */
        public function ScrollbarWindowRenderer(name:String)
        {
            super(name, FlameScrollbar.EventNamespace);
        }
        
        /*!
        \brief
        update the size and location of the thumb to properly represent the
        current state of the scroll bar
        */
        public function updateThumb():void
        {
            
        }
        
        /*!
        \brief
        return value that best represents current scroll bar position given the
        current location of the thumb.
        
        \return
        float value that, given the thumb widget position, best represents the
        current position for the scroll bar.
        */
        public function getValueFromThumb():Number
        {
            return 0;
        }
        
        /*!
        \brief
        Given window location \a pt, return a value indicating what change
        should be made to the scroll bar.
        
        \param pt
        Point object describing a pixel position in window space.
        
        \return
        - -1 to indicate scroll bar position should be moved to a lower value.
        -  0 to indicate scroll bar position should not be changed.
        - +1 to indicate scroll bar position should be moved to a higher value.
        */
        public function getAdjustDirectionFromPoint(pt:Vector2):Number
        {
            return 0;
        }
    }
}