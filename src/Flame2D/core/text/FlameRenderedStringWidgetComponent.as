
package Flame2D.core.text
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.UDim;
    import Flame2D.core.utils.UVector2;
    import Flame2D.core.utils.Vector2;
    import Flame2D.renderer.FlameGeometryBuffer;
    
    public class FlameRenderedStringWidgetComponent extends FlameRenderedStringComponent
    {
        
        protected var d_window:FlameWindow;
        
        
        //! Constructor

        public function FlameRenderedStringWidgetComponent(widget:FlameWindow)
        {
            d_window = widget;
        }
        
        //! Set the window to be controlled by this component.
        public function setWindowByName(widget_name:String):void
        {
            d_window = FlameWindowManager.getSingleton().getWindow(widget_name);
        }
        
        //! Set the window to be controlled by this component.
        public function setWindow(widget:FlameWindow):void
        {
            d_window = widget;
        }
        
        //! return the window currently controlled by this component
        public function getWindow():FlameWindow
        {
            return d_window;
        }
        
        // implementation of abstract base interface
        override public function draw(buffer:FlameGeometryBuffer, position:Vector2,
            mod_colours:ColourRect, clip_rect:Rect,
            vertical_space:Number, space_extra:Number):void
        {
            if (!d_window)
                return;
            
            // HACK: re-adjust for inner-rect of parent
            var x_adj:Number = 0, y_adj:Number = 0;
            var parent:FlameWindow = d_window.getParent();
            
            if (parent)
            {
                var outer:Rect = parent.getUnclippedOuterRect();
                var inner:Rect = parent.getUnclippedInnerRect();
                x_adj = inner.d_left - outer.d_left;
                y_adj = inner.d_top - outer.d_top;
            }
            // HACK: re-adjust for inner-rect of parent (Ends)
            
            var final_pos:Vector2 = position.clone();
            // handle formatting options
            switch (d_verticalFormatting)
            {
                case Consts.VerticalFormatting_VF_BOTTOM_ALIGNED:
                    final_pos.d_y += vertical_space - getPixelSize().d_height;
                    break;
                
                case Consts.VerticalFormatting_VF_STRETCHED:
                    trace("RenderedStringWidgetComponent::draw: " +
                        "VF_STRETCHED specified but is unsupported for Widget types; " +
                        "defaulting to VF_CENTRE_ALIGNED instead.");
                    
                    // intentional fall-through.
                    
                case Consts.VerticalFormatting_VF_CENTRE_ALIGNED:
                    final_pos.d_y += (vertical_space - getPixelSize().d_height) / 2 ;
                    break;
                
                
                case Consts.VerticalFormatting_VF_TOP_ALIGNED:
                    // nothing additional to do for this formatting option.
                    break;
                
                default:
                    throw new Error("RenderedStringTextComponent::draw: " +
                        "unknown VerticalFormatting option specified.");
            }
            
            // we do not actually draw the widget, we just move it into position.
            var wpos:UVector2 = new UVector2(new UDim(0, final_pos.d_x + d_padding.d_left - x_adj),
                new UDim(0, final_pos.d_y + d_padding.d_top - y_adj));
            
            d_window.setPosition(wpos);
        }
        
        override public function getPixelSize():Size
        {
            var sz:Size = new Size(0, 0);
            
            if (d_window)
            {
                sz = d_window.getPixelSize();
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
            throw new Error(
                "RenderedStringWidgetComponent::split: this " +
                "component does not support being split.");
        }
        
        override public function clone():FlameRenderedStringComponent
        {
            return new FlameRenderedStringWidgetComponent(d_window);
        }
        
        override public function getSpaceCount():uint
        {
            return 0;
        }
    }
}