

package Flame2D.elements.slider
{
    import Flame2D.core.system.FlameWindowRenderer;
    import Flame2D.core.utils.Vector2;

    public class SliderWindowRenderer extends FlameWindowRenderer
    {
        /*!
        \brief
        Constructor
        */
        public function SliderWindowRenderer(name:String)
        {
            super(name, FlameSlider.EventNamespace);
        }
        
        /*!
        \brief
        update the size and location of the thumb to properly represent the current state of the slider
        */
        public function updateThumb():void
        {
            
        }
        
        /*!
        \brief
        return value that best represents current slider value given the current location of the thumb.
        
        \return
        float value that, given the thumb widget position, best represents the current value for the slider.
        */
        public function getValueFromThumb():Number
        {
            return 0;
        }
        
        /*!
        \brief
        Given window location \a pt, return a value indicating what change should be 
        made to the slider.
        
        \param pt
        Point object describing a pixel position in window space.
        
        \return
        - -1 to indicate slider should be moved to a lower setting.
        -  0 to indicate slider should not be moved.
        - +1 to indicate slider should be moved to a higher setting.
        */
        public function getAdjustDirectionFromPoint(pt:Vector2):Number
        {
            return 0;
        }
    }
}