
package Flame2D.core.text
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.imagesets.FlameImageSet;
    import Flame2D.core.system.FlameImageSetManager;
    import Flame2D.core.utils.Colour;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.Vector2;
    import Flame2D.renderer.FlameGeometryBuffer;

    public class FlameRenderedStringImageComponent extends FlameRenderedStringComponent
    {
        //! pointer to the image drawn by the component.
        protected var d_image:FlameImage;
        //! ColourRect object describing the colours to use when rendering.
        protected var d_colours:ColourRect;
        //! target size to render the image at (0s mean natural size)
        protected var d_size:Size;
        
        
        //! Constructor
        public function FlameRenderedStringImageComponent(image:FlameImage)
        {
            d_image = image;
            d_colours = new ColourRect();
            d_size = new Size();
        }
        
        //! Set the image to be drawn by this component.
        public function setImageByImageSet(imageset:String, image:String):void
        {
            if (imageset.length != 0 && image.length != 0)
            {
                var iset:FlameImageSet = FlameImageSetManager.getSingleton().getImageSet(imageset);
                d_image = iset.getImage(image);
            }
            else
            {
                d_image = null;
            }
        }
        
        //! Set the image to be drawn by this component.
        public function setImage(image:FlameImage):void
        {
            d_image = image;
        }
        
        //! return the current set image that will be drawn by this component
        public function getImage():FlameImage
        {
            return d_image;
        }
        
        //! Set the colour values used when rendering this component.
        public function setColours(cr:ColourRect):void
        {
            d_colours = cr;
        }
        
        //! Set the colour values used when rendering this component.
        public function setColours1(c:Colour):void
        {
            d_colours.setColours(c);
        }
        
        //! return the ColourRect object used when drawing this component.
        public function getColours():ColourRect
        {
            return d_colours;
        }
        
        //! set the size for rendering the image (0s mean 'normal' size)
        public function setSize(sz:Size):void
        {
            d_size = sz;
        }
        
        //! return the size for rendering the image (0s mean 'normal' size)
        public function getSize():Size
        {
            return d_size;
        }
        
        // implementation of abstract base interface
        override public function draw(buffer:FlameGeometryBuffer, position:Vector2,
            mod_colours:ColourRect, clip_rect:Rect,
            vertical_space:Number, space_extra:Number):void
        {
            if (!d_image)
                return;
            
            var dest:Rect = new Rect(position.d_x, position.d_y, 0, 0);
            var y_scale:Number = 1.0;
            
            // handle formatting options
            switch (d_verticalFormatting)
            {
                case Consts.VerticalFormatting_VF_BOTTOM_ALIGNED:
                    dest.d_top += vertical_space - getPixelSize().d_height;
                    break;
                
                case Consts.VerticalFormatting_VF_CENTRE_ALIGNED:
                    dest.d_top += (vertical_space - getPixelSize().d_height) / 2 ;
                    break;
                
                case Consts.VerticalFormatting_VF_STRETCHED:
                    y_scale = vertical_space / getPixelSize().d_height;
                    break;
                
                case Consts.VerticalFormatting_VF_TOP_ALIGNED:
                    // nothing additional to do for this formatting option.
                    break;
                
                default:
                    throw new Error("RenderedStringImageComponent::draw: unknown VerticalFormatting option specified.");
            }
            
            var sz:Size = d_image.getSize();
            if (d_size.d_width != 0.0)
                sz.d_width = d_size.d_width;
            if (d_size.d_height != 0.0)
                sz.d_height = d_size.d_height;
            
            sz.d_height *= y_scale;
            dest.setSize(sz);
            
            // apply padding to position
            dest.offset2(d_padding.getPosition());
            
            // apply modulative colours if needed.
            var final_cols:ColourRect = d_colours.clone();
            if (mod_colours)
                final_cols.multiplyColourRect2(mod_colours);
            
            // draw the image.
            d_image.draw2(buffer, dest, clip_rect, final_cols);
        }
        
        override public function getPixelSize():Size
        {
            var sz:Size = new Size();
            
            if (d_image)
            {
                sz = d_image.getSize();
                if (d_size.d_width != 0.0)
                    sz.d_width = d_size.d_width;
                if (d_size.d_height != 0.0)
                    sz.d_height = d_size.d_height;
                sz.d_width += (d_padding.d_left + d_padding.d_right);
                sz.d_height += (d_padding.d_top + d_padding.d_bottom);
            }
            
            return sz;
        }
        
        override public function canSplit():Boolean
        {
            return false;
        }
        
        override public function split(split_point:uint, first_component:Boolean):FlameRenderedStringComponent
        {
            throw new Error("RenderedStringImageComponent::split: this component does not support being split.");
        }
        
        override public function clone():FlameRenderedStringComponent
        {
            return new FlameRenderedStringImageComponent(d_image);
        }
        
        override public function getSpaceCount():uint
        {
            return 0;
        }
        
        
    }
    
    
}