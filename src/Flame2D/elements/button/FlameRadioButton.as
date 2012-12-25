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
    
    public class FlameRadioButton extends FlameButtonBase
    {
        public static const EventNamespace:String = "RadioButton";
        public static const WidgetTypeName:String = "CEGUI/RadioButton";

        
        /*************************************************************************
         Event name constants
         *************************************************************************/
        // generated internally by Window
        /** Event fired when the selected state of the radio button changes.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the RadioButton whose selected state has
         * changed.
         */
        public static const EventSelectStateChanged:String = "SelectStateChanged";
        
        /*************************************************************************
         Static Properties for this class
         *************************************************************************/
        private static var d_selectedProperty:RadioButtonPropertySelected = new RadioButtonPropertySelected();
        private static var d_groupIDProperty:RadioButtonPropertyGroupID = new RadioButtonPropertyGroupID();
        
        
        /*************************************************************************
         Implementation Data
         *************************************************************************/
        protected var d_selected:Boolean = false;				// true when radio button is selected (has checkmark)
        protected var d_groupID:uint = 0;				// radio button group ID
        
        
        public function FlameRadioButton(type:String, name:String)
        {
            super(type, name);
            
            addRadioButtonProperties();
        }
        
        
        /*************************************************************************
         Accessor Functions
         *************************************************************************/ 
        /*!
        \brief
        return true if the radio button is selected (has the checkmark)
        
        \return
        true if this widget is selected, false if the widget is not selected.
        */
        public function isSelected():Boolean
        {
            return d_selected;
        }
        
        
        /*!
        \brief
        return the groupID assigned to this radio button
        
        \return
        ulong value that identifies the Radio Button group this widget belongs to.
        */
        public function getGroupID():uint
        {
            return d_groupID;
        }
        
        
        /*!
        \brief
        Return a pointer to the RadioButton object within the same group as this RadioButton, that
        is currently selected.
        
        \return
        Pointer to the RadioButton object that is the RadioButton within the same group as this RadioButton,
        and is attached to the same parent window as this RadioButton, that is currently selected.
        Returns NULL if no button within the group is selected, or if 'this' is not attached to a parent window.
        */
        public function getSelectedButtonInGroup():FlameRadioButton
        {
            // Only search we we are a child window
            if (d_parent)
            {
                var child_count:uint = d_parent.getChildCount();
                
                // scan all children
                for (var child:uint = 0; child < child_count; ++child)
                {
                    // is this child same type as we are?
                    if (d_parent.getChildAt(child).getType() == getType())
                    {
                        var rb:FlameRadioButton = d_parent.getChildAt(child) as FlameRadioButton;
                        
                        // is child same group and selected?
                        if (rb.isSelected() && (rb.getGroupID() == d_groupID))
                        {
                            // return the matching RadioButton pointer (may even be 'this').
                            return rb;
                        }
                    }
                }
            }
            
            // no selected button attached to this window is in same group
            return null;
        }
        
        /*************************************************************************
         Manipulator Functions
         *************************************************************************/
        /*!
        \brief
        set whether the radio button is selected or not
        
        \param select
        true to put the radio button in the selected state, false to put the radio button in the
        deselected state.  If changing to the selected state, any previously selected radio button
        within the same group is automatically deselected.
        
        \return
        Nothing.
        */
        public function setSelected(select:Boolean):void
        {
            if (select != d_selected)
            {
                d_selected = select;
                invalidate();
                
                // if new state is 'selected', we must de-select any selected radio buttons within our group.
                if (d_selected)
                {
                    deselectOtherButtonsInGroup();
                }
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onSelectStateChanged(args);
            }
        }
        
        
        /*!
        \brief
        set the groupID for this radio button
        
        \param group
        ulong value specifying the radio button group that this widget belongs to.
        
        \return	
        Nothing.
        */
        public function setGroupID(group:uint):void
        {
            d_groupID = group;
            
            if (d_selected)
            {
                deselectOtherButtonsInGroup();
            }

        }
        
        
        
        /*************************************************************************
         Implementation Functions
         *************************************************************************/
        /*!
        \brief
        Deselect any selected radio buttons attached to the same parent within the same group
        (but not do not deselect 'this').
        */
        protected function deselectOtherButtonsInGroup():void
        {
            // nothing to do unless we are attached to another window.
            if (d_parent)
            {
                var child_count:uint = d_parent.getChildCount();
                
                // scan all children
                for (var child:uint = 0; child < child_count; ++child)
                {
                    // is this child same type as we are?
                    if (d_parent.getChildAt(child).getType() == getType())
                    {
                        var rb:FlameRadioButton = d_parent.getChildAt(child) as FlameRadioButton;
                        
                        // is child same group, selected, but not 'this'?
                        if (rb.isSelected() && (rb != this) && (rb.getGroupID() == d_groupID))
                        {
                            // deselect the radio button.
                            rb.setSelected(false);
                        }
                    }
                }
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
            if (class_name=="RadioButton")	return true;
            return super.testClassName_impl(class_name);
        }
        
        
        /*************************************************************************
         New Radio Button Events
         *************************************************************************/
        /*!
        \brief
        event triggered internally when the select state of the button changes.
        */
        protected function onSelectStateChanged(e:WindowEventArgs):void
        {
            fireEvent(EventSelectStateChanged, e, EventNamespace);
        }
        
        
        /*************************************************************************
         Overridden Event handlers
         *************************************************************************/
        override public function onMouseButtonUp(e:MouseEventArgs):void
        {
            if ((e.button == Consts.MouseButton_LeftButton) && isPushed())
            {
                var sheet:FlameWindow = FlameSystem.getSingleton().getGUISheet();
                
                if (sheet)
                {
                    // if mouse was released over this widget
                    // (use mouse position, since e.position has been unprojected)
                    if (this == sheet.getTargetChildAtPosition(
                        FlameMouseCursor.getSingleton().getPosition()))
                    {
                        // select this button & deselect all others in the same group.
                        setSelected(true);
                    }
                    
                }
                
                ++e.handled;
            }
            
            // default handling
            super.onMouseButtonUp(e);
        }

        

        
        /*************************************************************************
         Private methods
         *************************************************************************/
        private function addRadioButtonProperties():void
        {
            addProperty(d_selectedProperty);
            addProperty(d_groupIDProperty);
        }
    }
}