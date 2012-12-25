
package Flame2D.core.utils
{
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.data.Consts;
    import Flame2D.renderer.FlameRenderer;

    /*!
    \brief
    Utility class that helps in converting various types of co-ordinate between
    absolute screen positions and positions offset from the top-left corner of
    a given Window object.
    */
    public class CoordConverter
    {
        
        /*!
        \brief
        Convert a window pixel co-ordinate value, specified as a float, to a
        screen pixel co-ordinate.
        
        \param window
        Window object to use as a base for the conversion.
        
        \param x
        float x co-ordinate value to be converted.
        
        \return
        float value describing a pixel screen co-ordinate that is equivalent to
        window co-ordinate \a x.
        */
        public static function windowToScreenX(window:FlameWindow, x:Number):Number
        {
            return getBaseXValue(window) + x;
        }
        
        /*!
        \brief
        Convert a window pixel co-ordinate value, specified as a float, to a
        screen pixel co-ordinate.
        
        \param window
        Window object to use as a base for the conversion.
        
        \param y
        float y co-ordinate value to be converted.
        
        \return
        float value describing a screen co-ordinate that is equivalent to
        window co-ordinate \a y.
        */
        public static function windowToScreenY(window:FlameWindow, y:Number):Number
        {
            return getBaseYValue(window) + y;
        }
        
        /*!
        \brief
        Convert a window co-ordinate value, specified as a UDim, to a screen
        relative pixel co-ordinate.
        
        \param window
        Window object to use as a base for the conversion.
        
        \param x
        UDim x co-ordinate value to be converted
        
        \return
        float value describing a pixel screen co-ordinate that is equivalent to
        window UDim co-ordinate \a x.
        */
        public static function windowToScreenXForUDim(window:FlameWindow, x:UDim):Number
        {
            return getBaseXValue(window) + x.asAbsolute(window.getPixelSize().d_width);
        }
   
        /*!
        \brief
        Convert a window co-ordinate value, specified as a UDim, to a screen
        relative pixel co-ordinate.
        
        \param window
        Window object to use as a base for the conversion.
        
        \param y
        UDim y co-ordinate value to be converted
        
        \return
        float value describing a screen co-ordinate that is equivalent to
        window UDim co-ordinate \a y.
        */
        public static function windowToScreenYForUDim(window:FlameWindow, y:UDim):Number
        {
            return getBaseYValue(window) + y.asAbsolute(window.getPixelSize().d_height);
        }
        

        
        /*!
        \brief
        Convert a window co-ordinate point, specified as a UVector2, to a
        screen relative pixel co-ordinate point.
        
        \param window
        Window object to use as a base for the conversion.
        
        \param vec
        UVector2 object describing the point to be converted
        
        \return
        Vector2 object describing a screen co-ordinate position that is
        equivalent to window based UVector2 \a vec.
        */
        public static function windowToScreenForUVector2(window:FlameWindow, vec:UVector2):Vector2
        {
            return getBaseValue(window).add(vec.asAbsolute(window.getPixelSize()));
        }
        
        /*!
        \brief
        Convert a window pixel co-ordinate point, specified as a Vector2, to a
        screen pixel co-ordinate point.
        
        \param window
        Window object to use as a base for the conversion.
        
        \param vec
        Vector2 object describing the point to be converted.
        
        \return
        Vector2 object describing a screen co-ordinate position that is
        equivalent to window based Vector2 \a vec.
        */
        public static function windowToScreenForVector2(window:FlameWindow, vec:Vector2):Vector2
        {
            return getBaseValue(window).add(vec);
        }
        
        /*!
        \brief
        Convert a window area, specified as a URect, to a screen area.
        
        \param rect
        URect object describing the area to be converted
        
        \return
        Rect object describing a screen area that is equivalent to window
        area \a rect.
        */
        public static function windowToScreenForURect(window:FlameWindow, rect:URect):Rect
        {
            var base:Vector2  = getBaseValue(window);
            var pixel:Rect = rect.asAbsolute(FlameSystem.getSingleton().getRenderer().getDisplaySize());
            
            // negate base position
            base.d_x = -base.d_x;
            base.d_y = -base.d_y;
            
            pixel.offset2(base);
            
            return pixel; 
        }
        
        /*!
        \brief
        Convert a pixel window area, specified as a Rect, to a screen area.
        
        \param window
        Window object to use as a base for the conversion.
        
        \param rect
        Rect object describing the area to be converted.
        
        \return
        Rect object describing a screen area that is equivalent to window
        area \a rect.
        */
        public static function windowToScreenForRect(window:FlameWindow, rect:Rect):Rect
        {
            return rect.offset(getBaseValue(window));
        }
        
        
        
        
        //=====================================================================================
        
        /*!
        \brief
        Convert a screen pixel co-ordinate value to a window co-ordinate
        value, specified in pixels.
        
        \param window
        Window object to use as a target for the conversion.
        
        \param x
        float x co-ordinate value to be converted.
        
        \return
        float value describing a window co-ordinate value that is equivalent to
        screen co-ordinate \a x.
        */
        public static function screenToWindowX(window:FlameWindow, x:Number):Number
        {
            return x - getBaseXValue(window);
        }
        
        
        
        /*!
        \brief
        Convert a screen pixel co-ordinate value to a window co-ordinate
        value, specified in pixels.
        
        \param window
        Window object to use as a target for the conversion.
        
        \param y
        UDim y co-ordinate value to be converted.
        
        \return
        float value describing a window co-ordinate value that is equivalent to
        screen co-ordinate \a y.
        */
        public static function screenToWindowY(window:FlameWindow, y:Number):Number
        {
            return y - getBaseYValue(window);
        }
        
        /*!
        \brief
        Convert a screen relative UDim co-ordinate value to a window co-ordinate
        value, specified in pixels.
        
        \param window
        Window object to use as a target for the conversion.
        
        \param x
        UDim x co-ordinate value to be converted
        
        \return
        float value describing a window co-ordinate value that is equivalent to
        screen UDim co-ordinate \a x.
        */
        public static function screenToWindowXForUDim(window:FlameWindow, x:UDim):Number
        {
            return x.asAbsolute(
                FlameSystem.getSingleton().getRenderer().getDisplayWidth()) -
                getBaseXValue(window);   
        }
        

        /*!
        \brief
        Convert a screen relative UDim co-ordinate value to a window co-ordinate
        value, specified in pixels.
        
        \param window
        Window object to use as a target for the conversion.
        
        \param y
        UDim y co-ordinate value to be converted
        
        \return
        float value describing a window co-ordinate value that is equivalent to
        screen UDim co-ordinate \a y.
        */
        public static function screenToWindowYForUDim(window:FlameWindow, y:UDim):Number
        {
            return y.asAbsolute(
                FlameSystem.getSingleton().getRenderer().getDisplayHeight()) -
                getBaseYValue(window);
        }

        /*!
        \brief
        Convert a screen relative UVector2 point to a window co-ordinate point,
        specified in pixels.
        
        \param window
        Window object to use as a target for the conversion.
        
        \param vec
        UVector2 object describing the point to be converted
        
        \return
        Vector2 object describing a window co-ordinate point that is equivalent
        to screen based UVector2 point \a vec.
        */
        public static function screenToWindowForUVector2(window:FlameWindow, vec:UVector2):Vector2
        {
            return vec.asAbsolute(
                FlameSystem.getSingleton().getRenderer().getDisplaySize()).subtract(
                getBaseValue(window));
        }
        /*!
        \brief
        Convert a screen Vector2 pixel point to a window co-ordinate point,
        specified in pixels.
        
        \param window
        Window object to use as a target for the conversion.
        
        \param vec
        Vector2 object describing the point to be converted.
        
        \return
        Vector2 object describing a window co-ordinate point that is equivalent
        to screen based Vector2 point \a vec.
        */
        public static function screenToWindowForVector2(window:FlameWindow, vec:Vector2):Vector2
        {
            return vec.subtract(getBaseValue(window));   
        }
        
        /*!
        \brief
        Convert a URect screen area to a window area, specified in pixels.
        
        \param window
        Window object to use as a target for the conversion.
        
        \param rect
        URect object describing the area to be converted
        
        \return
        Rect object describing a window area that is equivalent to URect screen
        area \a rect.
        */
        public static function screenToWindowForURect(window:FlameWindow, rect:URect):Rect
        {
            var base:Vector2 = getBaseValue(window);
            var pixel:Rect = rect.asAbsolute(FlameSystem.getSingleton().getRenderer().getDisplaySize());
            
            // negate base position
            base.d_x = -base.d_x;
            base.d_y = -base.d_y;
            
            pixel.offset2(base);

            return pixel;
        }
        /*!
        \brief
        Convert a Rect screen pixel area to a window area, specified in pixels.
        
        \param window
        Window object to use as a target for the conversion.
        
        \param rect
        Rect object describing the area to be converted.
        
        \return
        Rect object describing a window area that is equivalent to Rect screen
        area \a rect.
        */
        public static function screenToWindowForRect(window:FlameWindow, rect:Rect):Rect
        {
            var base:Vector2 = getBaseValue(window);
            
            // negate base position
            base.d_x = -base.d_x;
            base.d_y = -base.d_y;
            
            return rect.offset(base);
        }
        /*!
        \brief
        Return the base X co-ordinate of the given Window object.
        
        \param window
        Window object to return base position for.
        
        \return
        float value indicating the base on-screen pixel location of the window
        on the x axis (i.e. The screen co-ord of the window's left edge).
        */
        private static function getBaseXValue(window:FlameWindow):Number
        {
            const parent:FlameWindow = window.getParent();
            
            var parent_rect:Rect = (parent ?
                    parent.getChildWindowContentArea(window.isNonClientWindow()) :
                    new Rect(0, 0, 
                        FlameSystem.getSingleton().getRenderer().getDisplayWidth(), 
                        FlameSystem.getSingleton().getRenderer().getDisplayHeight())
            );
            
            var parent_width:Number = parent_rect.getWidth();
            var baseX:Number = parent_rect.d_left;
            
            baseX += window.getArea().d_min.d_x.asAbsolute(parent_width);
            
            switch(window.getHorizontalAlignment())
            {
                case Consts.HorizontalAlignment_HA_CENTRE:
                    baseX += (parent_width - window.getPixelSize().d_width) * 0.5;
                    break;
                case Consts.HorizontalAlignment_HA_RIGHT:
                    baseX += parent_width - window.getPixelSize().d_width;
                    break;
                default:
                    break;
            }
            
            return Misc.PixelAligned(baseX);
        }
        
        /*!
        \brief
        Return the base Y co-ordinate of the given Window object.
        
        \param window
        Window object to return base position for.
        
        \return
        float value indicating the base on-screen pixel location of the window
        on the y axis (i.e. The screen co-ord of the window's top edge).
        */
        private static function getBaseYValue(window:FlameWindow):Number
        {
            const parent:FlameWindow = window.getParent();
            
            var parent_rect:Rect = (parent ?
                    parent.getChildWindowContentArea(window.isNonClientWindow()) :
                    new Rect(0, 0,
                        FlameSystem.getSingleton().getRenderer().getDisplayWidth(),
                        FlameSystem.getSingleton().getRenderer().getDisplayHeight()
                    )
            );
            
            const parent_height:Number = parent_rect.getHeight();
            var baseY:Number = parent_rect.d_top;
            
            baseY += window.getArea().d_min.d_y.asAbsolute(parent_height);
            
            switch(window.getVerticalAlignment())
            {
                case Consts.VerticalAlignment_VA_CENTRE:
                    baseY += (parent_height - window.getPixelSize().d_height) * 0.5;
                    break;
                case Consts.VerticalAlignment_VA_BOTTOM:
                    baseY += parent_height - window.getPixelSize().d_height;
                    break;
                default:
                    break;
            }
            
            return Misc.PixelAligned(baseY);
        }
        
        /*!
        \brief
        Return the base position of the given Window object.
        
        \param window
        Window object to return base position for.
        
        \return
        Vector2 value indicating the base on-screen pixel location of the window
        object. (i.e. The screen co-ord of the window's top-left corner).
        */
        private static function getBaseValue(window:FlameWindow):Vector2
        {
            return new Vector2(getBaseXValue(window), getBaseYValue(window));
        }
    }
}