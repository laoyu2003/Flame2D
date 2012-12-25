/***************************************************************************
 *   Copyright (C) 2004 - 2010 Paul D Turner & The CEGUI Development Team
 *
 *   Porting to Flash Stage3D
 *   Copyright (C) 2012 Mingjian Yu(laoyu20032003@hotmail.com)
 *
 *   Permission is hereby granted, free of charge, to any person obtaining
 *   a copy of this software and associated documentation files (the
 *   "Software"), to deal in the Software without restriction, including
 *   without limitation the rights to use, copy, modify, merge, publish,
 *   distribute, sublicense, and/or sell copies of the Software, and to
 *   permit persons to whom the Software is furnished to do so, subject to
 *   the following conditions:
 *
 *   The above copyright notice and this permission notice shall be
 *   included in all copies or substantial portions of the Software.
 *
 *   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 *   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 *   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 *   IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 *   OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 *   ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 *   OTHER DEALINGS IN THE SOFTWARE.
 ***************************************************************************/
package Flame2D.core.system
{
    import Flame2D.core.events.MouseCursorEventArgs;
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.URect;
    import Flame2D.core.utils.Vector2;
    import Flame2D.core.utils.Vector3;
    import Flame2D.renderer.FlameGeometryBuffer;
    import Flame2D.renderer.FlameRenderer;
    
    import flash.ui.Mouse;
    

    /*!
    \brief
    Class that allows access to the GUI system mouse cursor.
    
    The MouseCursor provides functionality to access the position and imagery of the mouse cursor / pointer
    */
    public class FlameMouseCursor extends FlameEventSet
    {
        public static const EventNamespace:String = "MouseCursor";				//!< Namespace for global events
        
        /*************************************************************************
         Event name constants
         *************************************************************************/
        // generated internally by MouseCursor
        /** Event fired when the mouse cursor image is changed.
         * Handlers are passed a const MouseCursorEventArgs reference with
         * MouseCursorEventArgs::mouseCursor set to the MouseCursor that has
         * had it's image changed, and MouseCursorEventArgs::image set to the
         * Image that is now set for the MouseCursor (may be 0).
         */
        public static const EventImageChanged:String = "ImageChanged";
        
        /*************************************************************************
         Implementation Data
         *************************************************************************/
        private var d_cursorImage:FlameImage = null;		//!< Image that is currently set as the mouse cursor.
        private var d_position:Vector2 = new Vector2(0,0);					//!< Current location of the cursor
        private var d_visible:Boolean = true;					//!< true if the cursor will be drawn, else false.
        private var d_constraints:URect = new URect();				//!< Specifies the area (in screen pixels) that the mouse can move around in.
        //! buffer to hold geometry for mouse cursor imagery.
        private var d_geometry:FlameGeometryBuffer = null;//FlameRenderer.getSingleton().createGeometryBuffer();
        //! custom explicit size to render the cursor image at
        private var d_customSize:Size = new Size(0,0);
        //! correctly scaled offset used when using custom image size.
        private var d_customOffset:Vector2 = new Vector2(0,0);
        //! true if the mouse initial position has been pre-set
        private static var s_initialPositionSet:Boolean = false;
        //! value set as initial position (if any)
        private static var s_initialPosition:Vector2 = new Vector2(0, 0);
        //! boolean indicating whether cached pointer geometry is valid.
        private var d_cachedGeometryValid:Boolean = false;
        
        
        
        private static var d_singleton:FlameMouseCursor = new FlameMouseCursor();

        public function FlameMouseCursor()
        {
            if(d_singleton){
                throw new Error("FlameMouseCursor: only via singleton");
            }
        }
        
        public static function getSingleton():FlameMouseCursor
        {
            return d_singleton;
        }
        
        public function initialize():void
        {
            d_geometry = FlameSystem.getSingleton().getRenderer().createGeometryBuffer();
            
            const screenArea:Rect = new Rect(0, 0,
                FlameSystem.getSingleton().getRenderer().getDisplayWidth(),
                FlameSystem.getSingleton().getRenderer().getDisplayHeight());
            d_geometry.setClippingRegion(screenArea);
            
            // default constraint is to whole screen
            setConstraintArea(screenArea);
            
            if (s_initialPositionSet)
                setPosition(s_initialPosition);
            else
                // mouse defaults to middle of the constrained area
                setPosition(new Vector2(screenArea.getWidth() / 2,
                    screenArea.getHeight() / 2));
            
            trace("CEGUI::MouseCursor singleton created. ");
        }

        /*!
        \brief
        Set the current mouse cursor image
        
        \param imageset
        String object holding the name of the Imageset that contains the desired Image.
        
        \param image_name
        String object holding the name of the desired Image on Imageset \a imageset.
        
        \return
        Nothing.
        
        \exception UnknownObjectException	thrown if \a imageset is not known, or if \a imageset contains no Image named \a image_name.
        */
        public function setImage(image:FlameImage):void
        {
            if (image == d_cursorImage)
                return;
            
            Mouse.hide();
            
            d_cursorImage = image;
            d_cachedGeometryValid = false;
            
            var args:MouseCursorEventArgs = new MouseCursorEventArgs(this);
            args.image = image;
            onImageChanged(args);
        }
        
        
        /*!
        \brief
        Set the current mouse cursor image
        */
        public function setImageByImageSet(imageset:String, image_name:String):void
        {
            setImage(FlameImageSetManager.getSingleton().getImageSet(imageset).getImage(image_name));
        }
        
        
        /*!
        \brief
        Get the current mouse cursor image
        \return
        The current image used to draw mouse cursor.
        */
        public function getImage():FlameImage
        {
            return d_cursorImage;
        }
        
        
        /*!
        \brief
        Makes the cursor draw itself
        
        \return
        Nothing
        */
        public function draw():void
        {
            if (!d_visible || !d_cursorImage)
                return;
            
            if (!d_cachedGeometryValid)
                cacheGeometry();
            
            d_geometry.draw();
        }
        
        
        /*!
        \brief
        Set the current mouse cursor position
        
        \param position
        Point object describing the new location for the mouse.  This will be clipped to within the renderer screen area.
        */
        public function setPosition(position:Vector2):void
        {
            if(d_geometry == null) return;
            
            d_position = position;
            constrainPosition();
            
            d_geometry.setTranslation(new Vector3(d_position.d_x, d_position.d_y, 0));
        }
        
        
        /*!
        \brief
        Offset the mouse cursor position by the deltas specified in \a offset.
        
        \param offset
        Point object which describes the amount to move the cursor in each axis.
        
        \return
        Nothing.
        */
        public function offsetPosition(offset:Vector2):void
        {
            if(d_geometry == null) return;
            
            d_position.d_x += offset.d_x;
            d_position.d_y += offset.d_y;
            constrainPosition();
            
            d_geometry.setTranslation(new Vector3(d_position.d_x, d_position.d_y, 0));
        }
        
        
        /*!
        \brief
        Set the area that the mouse cursor is constrained to.
        
        \param area
        Pointer to a Rect object that describes the area of the display that the mouse is allowed to occupy.  The given area will be clipped to
        the current Renderer screen area - it is never possible for the mouse to leave this area.  If this parameter is NULL, the
        constraint is set to the size of the current Renderer screen area.
        
        \return
        Nothing.
        */
        public function setConstraintArea(area:Rect):void
        {
            const renderer_area:Rect = new Rect(0, 0,
                FlameSystem.getSingleton().getRenderer().getDisplayWidth(),
                FlameSystem.getSingleton().getRenderer().getDisplayHeight());
            
            if (!area)
            {
                d_constraints.d_min.d_x = Misc.cegui_reldim(renderer_area.d_left / renderer_area.getWidth());
                d_constraints.d_min.d_y = Misc.cegui_reldim(renderer_area.d_top / renderer_area.getHeight());
                d_constraints.d_max.d_x = Misc.cegui_reldim(renderer_area.d_right / renderer_area.getWidth());
                d_constraints.d_max.d_y = Misc.cegui_reldim(renderer_area.d_bottom / renderer_area.getHeight());
            }
            else
            {
                var finalArea:Rect = area.getIntersection(renderer_area);
                d_constraints.d_min.d_x = Misc.cegui_reldim(finalArea.d_left / renderer_area.getWidth());
                d_constraints.d_min.d_y = Misc.cegui_reldim(finalArea.d_top / renderer_area.getHeight());
                d_constraints.d_max.d_x = Misc.cegui_reldim(finalArea.d_right / renderer_area.getWidth());
                d_constraints.d_max.d_y = Misc.cegui_reldim(finalArea.d_bottom / renderer_area.getHeight());
            }
            
            constrainPosition();
        }
        
        
        /*!
        \brief
        Set the area that the mouse cursor is constrained to.
        
        \param area
        Pointer to a URect object that describes the area of the display that the mouse is allowed to occupy.  The given area will be clipped to
        the current Renderer screen area - it is never possible for the mouse to leave this area.  If this parameter is NULL, the
        constraint is set to the size of the current Renderer screen area.
        
        \return
        Nothing.
        */
        public function setUnifiedConstraintArea(area:URect):void
        {
            var renderer_area:Rect = new Rect(0, 0,
                FlameSystem.getSingleton().getRenderer().getDisplayWidth(),
                FlameSystem.getSingleton().getRenderer().getDisplayHeight());
            
            if (area)
            {
                d_constraints = area;
            }
            else
            {
                d_constraints.d_min.d_x = Misc.cegui_reldim(renderer_area.d_left / renderer_area.getWidth());
                d_constraints.d_min.d_y = Misc.cegui_reldim(renderer_area.d_top / renderer_area.getHeight());
                d_constraints.d_max.d_x = Misc.cegui_reldim(renderer_area.d_right / renderer_area.getWidth());
                d_constraints.d_max.d_y = Misc.cegui_reldim(renderer_area.d_bottom / renderer_area.getHeight());
            }
            
            constrainPosition();
        }
        
        
        /*!
        \brief
        Hides the mouse cursor.
        
        \return
        Nothing.
        */
        public function hide():void
        {
            d_visible = false;
        }
        
        
        /*!
        \brief
        Shows the mouse cursor.
        
        \return
        Nothing.
        */
        public function show():void
        {
            d_visible = true;
        }
        
        
        /*!
        \brief
        Set the visibility of the mouse cursor.
        
        \param visible
        'true' to show the mouse cursor, 'false' to hide it.
        
        \return
        Nothing.
        */
        public function setVisible(visible:Boolean):void
        {
            d_visible = visible;
        }
        
        
        /*!
        \brief
        return whether the mouse cursor is visible.
        
        \return
        true if the mouse cursor is visible, false if the mouse cursor is hidden.
        */
        public function isVisible():Boolean
        {
            return d_visible;
        }
        
        
        /*!
        \brief
        Return the current mouse cursor position as a pixel offset from the top-left corner of the display.
        
        \return
        Point object describing the mouse cursor position in screen pixels.
        */
        public function getPosition():Vector2
        {
            return d_position.clone();
        }
        
        
        /*!
        \brief
        return the current constraint area of the mouse cursor.
        
        \return
        Rect object describing the active area that the mouse cursor is constrained to.
        */
        public function getConstraintArea():Rect
        {
            return d_constraints.asAbsolute(FlameSystem.getSingleton().getRenderer().getDisplaySize());
        }
        
        
        /*!
        \brief
        return the current constraint area of the mouse cursor.
        
        \return
        URect object describing the active area that the mouse cursor is constrained to.
        */
        public function getUnifiedConstraintArea():URect
        {
            return d_constraints;
        }
        
        
        /*!
        \brief
        Return the current mouse cursor position as display resolution independant values.
        
        \return
        Point object describing the current mouse cursor position as resolution independant values that
        range from 0.0f to 1.0f, where 0.0f represents the left-most and top-most positions, and 1.0f
        represents the right-most and bottom-most positions.
        */
        public function getDisplayIndependantPosition():Vector2
        {
            var dsz:Size = FlameSystem.getSingleton().getRenderer().getDisplaySize();
            
            return new Vector2(d_position.d_x / (dsz.d_width - 1.0),
                d_position.d_y / (dsz.d_height - 1.0));
        }
        
        /*!
        \brief
        Function used to notify the MouseCursor of changes in the display size.
        
        You normally would not call this directly; rather you would call the
        function System::notifyDisplaySizeChanged and that will then call this
        function for you.
        
        \param new_size
        Size object describing the new display size in pixels.
        */
        public function notifyDisplaySizeChanged(new_size:Size):void
        {
            if(!d_geometry) return;
            
            const screenArea:Rect = new Rect(0, 0, new_size.d_width, new_size.d_height);
            d_geometry.setClippingRegion(screenArea);
            
            // invalidate to regenerate geometry at (maybe) new size
            d_cachedGeometryValid = false;
        }
        
        /*!
        \brief
        Set an explicit size for the mouse cursor image to be drawn at.
        
        This will override the size that is usually obtained directly from the
        mouse cursor image and will stay in effect across changes to the mouse
        cursor image.
        
        Setting this size to (0, 0) will revert back to using the size as
        obtained from the Image itself.
        
        \param size
        Reference to a Size object that describes the size at which the cursor
        image should be drawn in pixels.
        */
        public function setExplicitRenderSize(size:Size):void
        {
            d_customSize = size;
            d_cachedGeometryValid = false;
        }
        
        /*!
        \brief
        Return the explicit render size currently set.  A return size of (0, 0)
        indicates that the real image size will be used.
        */
        public function getExplicitRenderSize():Size
        {
            return d_customSize;
        }
        
        /*!
        \brief
        Static function to pre-initialise the mouse cursor position (prior to
        MouseCursor instantiation).
        
        Calling this function prior to instantiating MouseCursor will prevent
        the mouse having it's position set to the middle of the initial view.
        Calling this function after the MouseCursor is instantiated will have
        no effect.
        
        \param position
        Reference to a point object describing the initial pixel position to
        be used for the mouse cursor.
        */
        public static function setInitialMousePosition(position:Vector2):void
        {
            s_initialPosition = position; 
            s_initialPositionSet = true;
        }
        
        /*!
        \brief
        Mark the cached geometry as invalid so it will be recached next time the
        mouse cursor is drawn.
        */
        public function invalidate():void
        {
            d_cachedGeometryValid = false;
        }
        
        
        
        /*************************************************************************
         New event handlers
         *************************************************************************/
        /*!
        \brief
        event triggered internally when image of mouse cursor changes
        */
        protected function onImageChanged(e:MouseCursorEventArgs):void
        {
            fireEvent(EventImageChanged, e, EventNamespace);
        }
        
        /*************************************************************************
         Implementation Methods
         *************************************************************************/
        /*!
        \brief
        Checks the mouse cursor position is within the current 'constrain' Rect and adjusts as required.
        */
        private function constrainPosition():void
        {
            var absarea:Rect = getConstraintArea();
            
            if (d_position.d_x >= absarea.d_right)
                d_position.d_x = absarea.d_right -1;
            
            if (d_position.d_y >= absarea.d_bottom)
                d_position.d_y = absarea.d_bottom -1;
            
            if (d_position.d_y < absarea.d_top)
                d_position.d_y = absarea.d_top;
            
            if (d_position.d_x < absarea.d_left)
                d_position.d_x = absarea.d_left;
        }
        
        //! updates the cached geometry.
        private function cacheGeometry():void
        {
            d_cachedGeometryValid = true;
            d_geometry.reset();
            
            // if no image, nothing more to do.
            if (!d_cursorImage)
                return;
            
            if (d_customSize.d_width != 0.0 || d_customSize.d_height != 0.0)
            {
                calculateCustomOffset();
                d_cursorImage.draw(d_geometry, d_customOffset, d_customSize, null);
            }
            else
            {
               d_cursorImage.draw(d_geometry, new Vector2(0, 0), new Size(16,16), null);
            }
            
        }
        
        //! calculate offset for custom image size so 'hot spot' is maintained.
        private function calculateCustomOffset():void
        {
            const sz:Size = d_cursorImage.getSize();
            const offset:Vector2 = d_cursorImage.getOffsets();
            
            d_customOffset.d_x =
                d_customSize.d_width / sz.d_width * offset.d_x - offset.d_x;
            d_customOffset.d_y =
                d_customSize.d_height / sz.d_height * offset.d_y - offset.d_y;
        }

        
        
    }
}