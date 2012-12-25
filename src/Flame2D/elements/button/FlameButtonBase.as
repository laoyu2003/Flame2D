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

package Flame2D.elements.button
{
    import Flame2D.core.system.FlameMouseCursor;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.data.Consts;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.utils.Vector2;
    
    /*!
    \brief
    Base class for all the 'button' type widgets (push button, radio button, check-box, etc)
    */
    public class FlameButtonBase extends FlameWindow
    {
        /*************************************************************************
         Implementation Data
         *************************************************************************/
        protected var d_pushed:Boolean = false;			//!< true when widget is pushed
        protected var d_hovering:Boolean = false;			//!< true when the button is in 'hover' state and requires the hover rendering.

        /*************************************************************************
         Construction and Destruction
         *************************************************************************/
        /*!
        \brief
        Constructor for ButtonBase objects
        */
        public function FlameButtonBase(type:String, name:String)
        {
            super(type, name);
        }

        
        /*************************************************************************
         Accessor type functions
         *************************************************************************/
        /*!
        \brief
        return true if user is hovering over this widget (or it's pushed and user is not over it for highlight)
        
        \return
        true if the user is hovering or if the button is pushed and the mouse is not over the button.  Otherwise return false.
        */
        public function isHovering():Boolean
        {
            return d_hovering;
        }
        
        
        /*!
        \brief
        Return true if the button widget is in the pushed state.
        
        \return
        true if the button-type widget is pushed, false if the widget is not pushed.
        */
        public function isPushed():Boolean
        {
            return d_pushed;
        }
        
        /** Internal function to set button's pushed state.  Normally you would
         * not call this, except perhaps when building compound widgets.
         */
        public function setPushedState(pushed:Boolean):void
        {
            d_pushed = pushed;

            if (!pushed)
                updateInternalState(getUnprojectedPosition(
                    FlameMouseCursor.getSingleton().getPosition()));
            else
                d_hovering = true;
            
            invalidate();
        }
        
        
        
        /*************************************************************************
         Overridden event handlers
         *************************************************************************/
        override public function onMouseMove(e:MouseEventArgs):void
        {
            // this is needed to discover whether mouse is in the widget area or not.
            // The same thing used to be done each frame in the rendering method,
            // but in this version the rendering method may not be called every frame
            // so we must discover the internal widget state here - which is actually
            // more efficient anyway.
            
            // base class processing
            super.onMouseMove(e);
            
            updateInternalState(e.position);
            ++e.handled;
        }
       
        override public function onMouseButtonDown(e:MouseEventArgs):void
        {
            // default processing
            super.onMouseButtonDown(e);
            
            if (e.button == Consts.MouseButton_LeftButton)
            {
                if (captureInput())
                {
                    d_pushed = true;
                    updateInternalState(e.position);
                    invalidate();
                }
                
                // event was handled by us.
                ++e.handled;
            }
        }
        
        override public function onMouseButtonUp(e:MouseEventArgs):void
        {
            // default processing
            super.onMouseButtonUp(e);
            
            if (e.button == Consts.MouseButton_LeftButton)
            {
                releaseInput();
                
                // event was handled by us.
                ++e.handled;
            }
        }
        
        override protected function onCaptureLost(e:WindowEventArgs):void
        {
            // Default processing
            super.onCaptureLost(e);
            
            d_pushed = false;
            updateInternalState(
                getUnprojectedPosition(FlameMouseCursor.getSingleton().getPosition()));
            invalidate();
            
            // event was handled by us.
            ++e.handled;
        }
        
        override public function onMouseLeaves(e:MouseEventArgs):void
        {
            // deafult processing
            super.onMouseLeaves(e);
            
            d_hovering = false;
            invalidate();
            
            ++e.handled;
        }
        
        
        /*************************************************************************
         Implementation Functions
         *************************************************************************/
        /*!
        \brief
        Update the internal state of the widget with the mouse at the given position.
        
        \param mouse_pos
        Point object describing, in screen pixel co-ordinates, the location of the mouse cursor.
        
        \return
        Nothing
        */
        private function updateInternalState(mouse_pos:Vector2):void
        {
            // This code is rewritten and has a slightly different behaviour
            // it is no longer fully "correct", as overlapping windows will not be
            // considered if the widget is currently captured.
            // On the other hand it's alot faster, so I believe it's a worthy
            // tradeoff
            
            var oldstate:Boolean = d_hovering;
            
            // assume not hovering 
            d_hovering = false;
            
            // if input is captured, but not by 'this', then we never hover highlight
            var capture_wnd:FlameWindow = getCaptureWindow();
            if (capture_wnd == null)
            {
                if (FlameSystem.getSingleton().getWindowContainingMouse() == this && isHit(mouse_pos))
                {
                    d_hovering = true;
                }
            }
            else if (capture_wnd == this && isHit(mouse_pos))
            {
                d_hovering = true;
            }
            
            // if state has changed, trigger a re-draw
            if (oldstate != d_hovering)
            {
                invalidate();
            }
        }
        
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
            if (class_name=="ButtonBase")	return true;
            return super.testClassName_impl(class_name);
        }
    }
}