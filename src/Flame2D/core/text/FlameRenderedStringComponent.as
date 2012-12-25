
package Flame2D.core.text
{
    import Flame2D.core.data.Consts;
    import Flame2D.renderer.FlameGeometryBuffer;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.Vector2;
    
    public class FlameRenderedStringComponent
    {
        
        
        //! Rect object holding the padding values for this component.
        protected var d_padding:Rect = new Rect(0,0,0,0);
        //! Vertical formatting to be used for this component.
        //VerticalFormatting d_verticalFormatting;
        protected var d_verticalFormatting:uint = Consts.VerticalFormatting_VF_BOTTOM_ALIGNED;
        //! true if the aspect ratio should be maintained where possible.
        protected var d_aspectLock:Boolean = false;
        
        public function FlameRenderedStringComponent()
        {
            
        }
        //! Set the VerticalFormatting option for this component.
        public function setVerticalFormatting(fmt:uint):void
        {
            d_verticalFormatting = fmt;
        }
        
        //! return the current VerticalFormatting option.
        public function getVerticalFormatting():uint
        {
            return d_verticalFormatting;
        }
        
        //! set the padding values.
        public function setPadding(padding:Rect):void
        {
            d_padding = padding;
        }
        
        //! set the left padding value.
        public function setLeftPadding(padding:Number):void
        {
            d_padding.d_left = padding;
        }
        
        //! set the right padding value.
        public function setRightPadding(padding:Number):void
        {
            d_padding.d_right = padding;
        }
        
        //! set the top padding value.
        public function setTopPadding(padding:Number):void
        {
            d_padding.d_top = padding;
        }
        
        //! set the Bottom padding value.
        public function setBottomPadding(padding:Number):void
        {
            d_padding.d_bottom = padding;
        }
        
        //! return the current padding value Rect.
        public function getPadding():Rect
        {
            return d_padding;
        }
        
        //! return the left padding value.
        public function getLeftPadding():Number
        {
            return d_padding.d_left;
        }
        
        //! return the right padding value.
        public function getRightPadding():Number
        {
            return d_padding.d_right;
        }
        
        //! return the top padding value.
        public function getTopPadding():Number
        {
            return d_padding.d_top;
        }
        
        //! return the bottom padding value.
        public function getBottomPadding():Number
        {
            return d_padding.d_bottom;
        }
        
        //! set the aspect-lock state
        public function setAspectLock(setting:Boolean):void
        {
            d_aspectLock = setting;
        }
        
        //! return the aspect-lock state
        public function getAspectLock():Boolean
        {
            return d_aspectLock;
        }
        
        //! draw the component.
        public function draw(buffer:FlameGeometryBuffer, position:Vector2,
            mod_colours:ColourRect,
            clip_rect:Rect,
            vertical_space:Number,
            space_extra:Number):void
        {
            throw new Error("Cannot reach here");
        }
        
        //! return the pixel size of the rendered component.
        public function getPixelSize():Size
        {
            return new Size();
        }
        
        //! return whether the component can be split
        public function canSplit():Boolean
        {
            return true;
        }
        
        /*!
        \brief
        split the component as close to split_point as possible, returning a
        new RenderedStringComponent of the same type as '*this' holding the
        left side of the split, and leaving the right side of the split in
        this object.
        
        \exception InvalidRequestException
        thrown if the RenderedStringComponent does not support being split.
        */
        public function split(split_point:uint,
            first_component:Boolean):FlameRenderedStringComponent
        {
            return null;
        }
        
        //! clone this component.
        public function clone():FlameRenderedStringComponent
        {
            return null;
        }
        
        //! return the total number of spacing characters in the string.
        public function getSpaceCount():uint
        {
            return 0;
        }
    }
}