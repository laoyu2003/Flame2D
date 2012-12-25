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
package Flame2D.elements.combobox
{
    import Flame2D.core.system.FlameEventManager;
    import Flame2D.core.data.Consts;
    import Flame2D.elements.listbox.FlameListbox;
    import Flame2D.elements.listbox.FlameListboxItem;
    import Flame2D.core.events.ActivationEventArgs;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.WindowEventArgs;

    /*!
    \brief
    Base class for the combo box drop down list.  This is a specialisation of the Listbox class.
    */
    public class FlameComboDropList extends FlameListbox
    {
        public static const EventNamespace:String = "ComboDropList";
        public static const WidgetTypeName:String = "CEGUI/ComboDropList";

        /*************************************************************************
         Implementation Data
         *************************************************************************/
        protected var d_autoArm:Boolean = false;		//!< true if the box auto-arms when the mouse enters it.
        protected var d_armed:Boolean = false;		//!< true when item selection has been armed.
        //ListboxItem* d_lastClickSelected; //!< Item last accepted by user.
        protected var d_lastClickSelected:FlameListboxItem = null;
        
        

        
        /*************************************************************************
         Constants
         *************************************************************************/
        // Event names
        /** Event fired when the user confirms the selection by clicking the mouse.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ComboDropList whose selection has been
         * confirmed by the user.
         */
        public static const EventListSelectionAccepted:String = "ListSelectionAccepted";
        
        /*************************************************************************
         Constructor & Destructor
         *************************************************************************/
        /*!
        \brief
        Constructor for ComboDropList base class
        */
        public function FlameComboDropList(type:String, name:String)
        {
            super(type, name);
            
            
            hide();
            
            // pass captured inputs to children to enable scrollbars
            setDistributesCapturedInputs(true);
        }
         
        
        
        /*!
        \brief
        Initialise the Window based object ready for use.
        
        \note
        This must be called for every window created.  Normally this is handled automatically by the WindowFactory for each Window type.
        
        \return
        Nothing
        */
        public function itialiseComponents():void
        {
            super.initialiseComponents();
            
            // set-up scroll bars so they return capture to us.
            getVertScrollbar().setRestoreCapture(true);
            getHorzScrollbar().setRestoreCapture(true);
        }
        
        
        /*!
        \brief
        Set whether the drop-list is 'armed' for selection.
        
        \note
        This setting is not exclusively under client control; the ComboDropList will auto-arm in
        response to certain left mouse button events.  This is also dependant upon the autoArm
        setting of the ComboDropList.
        
        \param setting
        - true to arm the box; items will be highlighted and the next left button up event
        will cause dismissal and possible item selection.
        
        - false to disarm the box; items will not be highlighted or selected until the box is armed.
        
        \return
        Nothing.
        */
        public function setArmed(setting:Boolean):void
        {
            d_armed = setting;
        }
        
        
        /*!
        \brief
        Return the 'armed' state of the ComboDropList.
        
        \return
        - true if the box is armed; items will be highlighted and the next left button up event
        will cause dismissal and possible item selection.
        
        - false if the box is not armed; items will not be highlighted or selected until the box is armed.
        */
        public function isArmed():Boolean
        {
            return d_armed;
        }
        
        
        /*!
        \brief
        Set the mode of operation for the ComboDropList.
        
        \param setting
        - true if the ComboDropList auto-arms when the mouse enters the box.
        - false if the user must click to arm the box.
        
        \return
        Nothing.
        */
        public function setAutoArmEnabled(setting:Boolean):void
        {
            d_autoArm = setting; 
        }
        
        
        /*!
        \brief
        returns the mode of operation for the drop-list
        
        \return
        - true if the ComboDropList auto-arms when the mouse enters the box.
        - false if the user must click to arm the box.
        */
        public function isAutoArmEnabled():Boolean
        {
            return d_autoArm;
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
            if (class_name=="ComboDropList")	return true;
            return super.testClassName_impl(class_name);
        }
        
        /*************************************************************************
         New event handlers
         *************************************************************************/
        /*!
        \brief
        Handler for when list selection is confirmed.
        */
        protected function onListSelectionAccepted(e:WindowEventArgs):void
        {
            d_lastClickSelected = getFirstSelectedItem();
            fireEvent(EventListSelectionAccepted, e, EventNamespace);
        }
        
        
        /*************************************************************************
         Overridden Event handling
         *************************************************************************/
        override public function onMouseMove(e:MouseEventArgs):void
        {
            super.onMouseMove(e);
            
            // if mouse is within our area (but not our children)
            if (isHit(e.position))
            {
                if (!getChildAtPosition(e.position))
                {
                    // handle auto-arm
                    if (d_autoArm)
                    {
                        d_armed = true;
                    }
                    
                    if (d_armed)
                    {
                        // check for an item under the mouse
                        var selItem:FlameListboxItem = getItemAtPoint(e.position);
                        
                        // if an item is under mouse, select it
                        if (selItem)
                        {
                            setItemSelectState(selItem, true);
                        }
                        else
                        {
                            clearAllSelections();
                        }
                        
                    }
                }
                
                ++e.handled;
            }
                // not within the list area
            else
            {
                // if left mouse button is down, clear any selection
                if (e.sysKeys & Consts.MouseButton_LeftButton)
                {
                    clearAllSelections();
                }
                
            }
        }
        
        override public function onMouseButtonDown(e:MouseEventArgs):void
        {
            super.onMouseButtonDown(e);
            
            if (e.button == Consts.MouseButton_LeftButton)
            {
                if (!isHit(e.position))
                {
                    clearAllSelections();
                    releaseInput();
                }
                else
                {
                    d_armed = true;
                }
                
                ++e.handled;
            }
        }
        
        override public function onMouseButtonUp(e:MouseEventArgs):void
        {
            super.onMouseButtonUp(e);
            
            if (e.button == Consts.MouseButton_LeftButton)
            {
                if (d_armed && (getChildAtPosition(e.position) == null))
                {
                    // if something was selected, confirm that selection.
                    if (getSelectedCount() > 0)
                    {
                        var args:WindowEventArgs = new WindowEventArgs(this);
                        onListSelectionAccepted(args);
                    }
                    
                    releaseInput();
                }
                    // if we are not already armed, in response to a left button up event, we auto-arm.
                else
                {
                    d_armed = true;
                }
                
                ++e.handled;
            }
        }
        
        override protected function onCaptureLost(e:WindowEventArgs):void
        {
            super.onCaptureLost(e);
            d_armed = false;
            hide();
            ++e.handled;
            
            // ensure 'sticky' selection remains.
            if ((d_lastClickSelected) && !d_lastClickSelected.isSelected())
            {
                clearAllSelections_impl();
                setItemSelectState(d_lastClickSelected, true);
            }
        }
        
        override protected function onActivated(e:ActivationEventArgs):void
        {
            super.onActivated(e);
        }
        
        override protected function onListContentsChanged(e:WindowEventArgs):void
        {
            // basically see if our 'sticky' selection was removed
            if ((d_lastClickSelected) && !isListboxItemInList(d_lastClickSelected))
                d_lastClickSelected = null;
            
            // base class processing
            super.onListContentsChanged(e);
        }
        
        override protected function onSelectionChanged(e:WindowEventArgs):void
        {
            if (!isActive())
                d_lastClickSelected = getFirstSelectedItem();
            
            super.onSelectionChanged(e);
        }
        

    }
}