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
package Flame2D.elements.tab
{
    import Flame2D.core.system.FlameMouseCursor;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.data.Consts;
    import Flame2D.elements.button.FlameButtonBase;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.WindowEventArgs;

    /*!
    \brief
    Base class for TabButtons.  A TabButton based class is used internally as
    the button that appears at the top of a TabControl widget to select the
    active tab pane.
    */
    public class FlameTabButton extends FlameButtonBase
    {
        public static const EventNamespace:String = "TabButton";
        public static const WidgetTypeName:String = "CEGUI/TabButton";
        
        /*************************************************************************
         Event name constants
         *************************************************************************/
        // generated internally by Window
        /** Event fired when the button is clicked.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the TabButton that was clicked.
         */
        public static const EventClicked:String = "Clicked";
        /** Event fired when use user attempts to drag the button with middle mouse
         * button.
         * Handlers are passed a const MouseEventArgs reference with all fields
         * valid.
         */
        public static const EventDragged:String = "Dragged";
        /** Event fired when the scroll wheel is used on top of the button.
         * Handlers are passed a const MouseEventArgs reference with all fields
         * valid.
         */
        public static const EventScrolled:String = "Scrolled";
        
        
        /*************************************************************************
         Implementation Data
         *************************************************************************/
        protected var d_selected:Boolean = false;             //!< Is this button selected?
        protected var d_dragging:Boolean = false;             //!< In drag mode or not
        protected var d_targetWindow:FlameWindow = null;         //!< The target window which this button is representing
        
        

        /*************************************************************************
         Construction and Destruction
         *************************************************************************/
        /*!
        \brief
        Constructor for base TabButton class
        */
        public function FlameTabButton(type:String, name:String)
        {
            super(type, name);
            
        }
        
        
   
        /*!
        \brief
        Set whether this tab button is selected or not
        */
        public function setSelected(selected:Boolean):void
        {
            d_selected = selected;
            invalidate();
        }
        
        /*!
        \brief
        Return whether this tab button is selected or not
        */
        public function isSelected():Boolean
        {
            return d_selected;
        }
        
        
        /*!
        \brief
        Set the target window which is the content pane which this button is
        covering.
        */
        public function setTargetWindow(wnd:FlameWindow):void
        {
            d_targetWindow = wnd;
            // Copy initial text
            setText(wnd.getText());
            // Parent control will keep text up to date, since changes affect layout
        }
        /*!
        \brief
        Get the target window which is the content pane which this button is
        covering.
        */
        public function getTargetWindow():FlameWindow
        {
            return d_targetWindow;
        }
            

        /*************************************************************************
         New Event Handlers
         *************************************************************************/
        /*!
        \brief
        handler invoked internally when the button is clicked.
        */
        protected function	onClicked(e:WindowEventArgs):void
        {
            fireEvent(EventClicked, e, EventNamespace);
        }
        
        
        /*************************************************************************
         Overridden Event Handlers
         *************************************************************************/
        override public function onMouseButtonUp(e:MouseEventArgs):void
        {
            if ((e.button == Consts.MouseButton_LeftButton) && isPushed())
            {
                var sheet:FlameWindow = FlameSystem.getSingleton().getGUISheet();
                
                if (sheet)
                {
                    // if mouse was released over this widget
                    // (use mouse position, as e.position has been unprojected)
                    if (this == sheet.getTargetChildAtPosition(
                        FlameMouseCursor.getSingleton().getPosition()))
                    {
                        // fire event
                        var args:WindowEventArgs = new WindowEventArgs(this);
                        onClicked(args);
                    }
                }
                
                ++e.handled;
            }
            else if (e.button == Consts.MouseButton_MiddleButton)
            {
                d_dragging = false;
                releaseInput ();
                ++e.handled;
            }
            
            // default handling
            super.onMouseButtonUp(e);
        }
        
        
        override public function onMouseButtonDown(e:MouseEventArgs):void
        {
            if (e.button == Consts.MouseButton_MiddleButton)
            {
                captureInput ();
                ++e.handled;
                d_dragging = true;
                
                fireEvent(EventDragged, e, EventNamespace);
            }
            
            // default handling
            super.onMouseButtonDown(e);
        }
        
        
        override public function onMouseWheel(e:MouseEventArgs):void
        {
            fireEvent(EventScrolled, e, EventNamespace);
            
            // default handling
            super.onMouseMove(e);
        }
        
        
        override public function onMouseMove(e:MouseEventArgs):void
        {
            if (d_dragging)
            {
                fireEvent(EventDragged, e, EventNamespace);
                ++e.handled;
            }
            
            // default handling
            super.onMouseMove(e);
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
            if (class_name=="TabButton")	return true;
            return super.testClassName_impl(class_name);
        }
    }
}