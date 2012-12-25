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
    import Flame2D.core.system.FlameEventManager;
    import Flame2D.core.system.FlameMouseCursor;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.data.Consts;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.WindowEventArgs;

    /*!
    \brief
    Base class to provide logic for push button type widgets.
    */
    public class FlamePushButton extends FlameButtonBase
    {
        public static const EventNamespace:String = "PushButton";
        public static const WidgetTypeName:String = "CEGUI/PushButton";

        /*************************************************************************
         Event name constants
         *************************************************************************/
        // generated internally by Window
        /** Event fired when the button is clicked.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the PushButton that was clicked.
         */
        public static const EventClicked:String = "Clicked";

        
        /*************************************************************************
         Construction and Destruction
         *************************************************************************/
        /*!
        \brief
        Constructor for base PushButton class
        */
        public function FlamePushButton(type:String, name:String)
        {
            super(type, name);
        }
        
        /*************************************************************************
         New Event Handlers
         *************************************************************************/
        /*!
        \brief
        handler invoked internally when the button is clicked.
        */
        protected function onClicked(e:WindowEventArgs):void
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
                    // (use position from mouse, as e.position has been unprojected)
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
            
            // default handling
            super.onMouseButtonUp(e);
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
            if (class_name=="PushButton")	return true;
            return super.testClassName_impl(class_name);
        }
    }
}