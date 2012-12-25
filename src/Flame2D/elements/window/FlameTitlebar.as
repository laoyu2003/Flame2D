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
package Flame2D.elements.window
{
    import Flame2D.core.system.FlameMouseCursor;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.data.Consts;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.renderer.FlameRenderer;
    import Flame2D.core.utils.CoordConverter;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Vector2;

    /*!
    \brief
    Class representing the title bar for Frame Windows.
    
    */
    public class FlameTitlebar extends FlameWindow
    {
        public static const EventNamespace:String = "Titlebar";
        public static const WidgetTypeName:String = "CEGUI/Titlebar";
        
        
        /*************************************************************************
         Static Properties for this class
         *************************************************************************/
        private static var d_dragEnabledProperty:TitlebarPropertyDraggingEnabled = new TitlebarPropertyDraggingEnabled();
        
        
        /*************************************************************************
         Implementation Data
         *************************************************************************/
        protected var d_dragging:Boolean = false;			//!< set to true when the window is being dragged.
        protected var d_dragPoint:Vector2;		//!< Point at which we are being dragged.
        protected var d_dragEnabled:Boolean = true;		//!< true when dragging for the widget is enabled.
        
        protected var d_oldCursorArea:Rect;	//!< Used to backup cursor restraint area.

        public function FlameTitlebar(type:String, name:String)
        {
            super(type, name);
            
            addTitlebarProperties();
            setAlwaysOnTop(true);
        }
        
        /*!
        \brief
        Return whether this title bar will respond to dragging.
        
        \return
        true if the title bar will respond to dragging, false if the title bar will not respond.
        */
        public function isDraggingEnabled():Boolean
        {
            return d_dragEnabled;
        }
        
        
        /*!
        \brief
        Set whether this title bar widget will respond to dragging.
        
        \param setting
        true if the title bar should respond to being dragged, false if it should not respond.
        
        \return
        Nothing.
        */
        public function setDraggingEnabled(setting:Boolean):void
        {
            if (d_dragEnabled != setting)
            {
                d_dragEnabled = setting;
                
                // stop dragging now if the setting has been disabled.
                if ((!d_dragEnabled) && d_dragging)
                {
                    releaseInput();
                }
                
                // call event handler.
                var args:WindowEventArgs = new WindowEventArgs(this);
                onDraggingModeChanged(args);
            }
        }
        
        
        /*************************************************************************
         Overridden event handler functions
         *************************************************************************/
        override public function onMouseMove(e:MouseEventArgs):void
        {
            // Base class processing.
            super.onMouseMove(e);
            
            if (d_dragging && (d_parent != null))
            {
                var delta:Vector2 = CoordConverter.screenToWindowForVector2(this, e.position);
                
                // calculate amount that window has been moved
                delta = delta.subtract(d_dragPoint);
                
                // move the window.  *** Again: Titlebar objects should only be attached to FrameWindow derived classes. ***
                (d_parent as FlameFrameWindow).offsetPixelPosition(delta);
                
                ++e.handled;
            }
        }
        
        override public function onMouseButtonDown(e:MouseEventArgs):void
        {
            // Base class processing
            super.onMouseButtonDown(e);
            
            if (e.button == Consts.MouseButton_LeftButton)
            {
                if ((d_parent != null) && d_dragEnabled)
                {
                    // we want all mouse inputs from now on
                    if (captureInput())
                    {
                        // initialise the dragging state
                        d_dragging = true;
                        d_dragPoint = CoordConverter.screenToWindowForVector2(this, e.position);
                        
                        // store old constraint area
                        d_oldCursorArea = FlameMouseCursor.getSingleton().getConstraintArea();
                        
                        // setup new constraint area to be the intersection of the old area and our grand-parent's clipped inner-area
                        var constrainArea:Rect;
                        
                        if ((d_parent == null) || (d_parent.getParent() == null))
                        {
                            var screen:Rect = new Rect(0, 0,
                                FlameSystem.getSingleton().getRenderer().getDisplayWidth(),
                                FlameSystem.getSingleton().getRenderer().getDisplayHeight());
                            constrainArea = screen.getIntersection(d_oldCursorArea);
                        }
                        else 
                        {
                            constrainArea = d_parent.getParent().getInnerRectClipper().getIntersection(d_oldCursorArea);
                        }
                        
                        FlameMouseCursor.getSingleton().setConstraintArea(constrainArea);
                    }
                    
                }
                
                ++e.handled;
            }
        }
            
        override public function onMouseButtonUp(e:MouseEventArgs):void
        {
            // Base class processing
            super.onMouseButtonUp(e);
            
            if (e.button == Consts.MouseButton_LeftButton)
            {
                releaseInput();
                ++e.handled;
            }
        }
        
        override public function onMouseDoubleClicked(e:MouseEventArgs):void
        {
            // Base class processing
            super.onMouseDoubleClicked(e);
            
            if (e.button == Consts.MouseButton_LeftButton)
            {
                // if we do not have a parent window, then obviously nothing should happen.
                if (d_parent)
                {
                    // we should only ever be attached to a FrameWindow (or derived) class
                    (d_parent as FlameFrameWindow).toggleRollup();
                }
                
                ++e.handled;
            }
        }
        
        override protected function onCaptureLost(e:WindowEventArgs):void
        {
            // Base class processing
            super.onCaptureLost(e);
            
            // when we lose out hold on the mouse inputs, we are no longer dragging.
            d_dragging = false;
            
            // restore old constraint area
            FlameMouseCursor.getSingleton().setConstraintArea(d_oldCursorArea);
        }
        
        override protected function onFontChanged(e:WindowEventArgs):void
        {
            super.onFontChanged(e);
            
            if (d_parent)
            {
                d_parent.performChildWindowLayout();
            }
        }
        
        
        /*************************************************************************
         New event handlers for title bar
         *************************************************************************/
        /*!
        \brief
        Event handler called when the 'draggable' state for the title bar is changed.
        
        Note that this is for 'internal' use at the moment and as such does not add or
        fire a public Event that can be subscribed to.
        */
        protected function onDraggingModeChanged(e:WindowEventArgs):void
        {
        }
        
        
        /*************************************************************************
         Implementation Functions
         *************************************************************************/
        /*!
        \brief
        Return whether this window was inherited from the given class name at some point in the inheritance hierarchy.
        
        \param class_name
        The class name that is to be checked.
        
        \return
        true if this window was inherited from \a class_name. false if not.
        */
        override protected function testClassName_impl(class_name:String):Boolean
        {
            if (class_name=="Titlebar")	return true;
            return super.testClassName_impl(class_name);
        }


        
        /*************************************************************************
         Private methods
         *************************************************************************/
        private function addTitlebarProperties():void
        {
            addProperty(d_dragEnabledProperty);
        }
    }
}