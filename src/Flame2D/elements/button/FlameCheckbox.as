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
    
    public class FlameCheckbox extends FlameButtonBase
    {
        
        public static const EventNamespace:String = "Checkbox";
        public static const WidgetTypeName:String = "CEGUI/Checkbox";

        /*************************************************************************
         Event name constants
         *************************************************************************/
        /** Event fired when then checked state of the Checkbox changes.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Checkbox whose state has changed.
         */
        public static const EventCheckStateChanged:String = "CheckStateChanged";
        
        /*************************************************************************
         Static Properties for this class
         *************************************************************************/
        private static var d_selectedProperty:CheckboxPropertySelected = new CheckboxPropertySelected();
        


        
        private var d_selected:Boolean = false;					//!< true if check-box is selected (has checkmark)
        
        
        public function FlameCheckbox(type:String, name:String)
        {
            super(type, name);
            addCheckboxProperties();
        }
        
        
        /*************************************************************************
         Accessor Functions
         *************************************************************************/
        /*!
        \brief
        return true if the check-box is selected (has the checkmark)
        
        \return
        true if the widget is selected and has the check-mark, false if the widget
        is not selected and does not have the check-mark.
        */
        public function isSelected():Boolean
        {
            return d_selected;
        }
        
        
        /*************************************************************************
         Manipulator Functions
         *************************************************************************/
        /*!
        \brief
        set whether the check-box is selected or not
        
        \param select
        true to select the widget and give it the check-mark.  false to de-select the widget and
        remove the check-mark.
        
        \return
        Nothing.
        */
        public function setSelected(select:Boolean):void
        {
            if (select != d_selected)
            {
                d_selected = select;
                invalidate();
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onSelectStateChange(args);
            }
        }
        
        /*************************************************************************
         New event handlers
         *************************************************************************/
        /*!
        \brief
        event triggered internally when state of check-box changes
        */
        protected function onSelectStateChange(e:WindowEventArgs):void
        {
            fireEvent(EventCheckStateChanged, e, EventNamespace);
        }
        
        
        /*************************************************************************
         Overridden event handlers
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
                        // toggle selected state
                        setSelected(!d_selected);
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
            if (class_name=="Checkbox")	return true;
            return super.testClassName_impl(class_name);
        }
        
        
        
        /*************************************************************************
         Private methods
         *************************************************************************/
        private function addCheckboxProperties():void
        {
            addProperty(d_selectedProperty);
        }
    }
}