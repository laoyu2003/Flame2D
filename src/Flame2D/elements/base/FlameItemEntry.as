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

package Flame2D.elements.base
{
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.data.Consts;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.utils.Size;
    
    /*!
    \brief
    Base class for item type widgets.
    
    \todo
    Fire events on selection / deselection.
    (Maybe selectable mode changed as well?)
    */
    public class FlameItemEntry extends FlameWindow
    {
        /*************************************************************************
         Constants
         *************************************************************************/
        public static const WidgetTypeName:String = "CEGUI/ItemEntry";             //!< Window factory name
        /** Event fired when the item's selection state changes.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ItemEntry whose selection state has
         * changed.
         */
        public static const EventSelectionChanged:String = "SelectionChanged";
        
        /************************************************************************
         Static Properties for this class
         ************************************************************************/
        private static var d_selectableProperty:ItemEntryPropertySelectable = new ItemEntryPropertySelectable();
        private static var d_selectedProperty:ItemEntryPropertySelected = new ItemEntryPropertySelected();
        
        
        /*************************************************************************
         Implementation Data
         *************************************************************************/
        
        //!< pointer to the owner ItemListBase. 0 if there is none.
        protected var d_ownerList:FlameItemListBase = null;
        
        //!< 'true' when the item is in the selected state, 'false' if not.
        protected var d_selected:Boolean = false;
        
        //!< 'true' when the item is selectable.
        protected var d_selectable:Boolean = false;
        
        
        
        /*************************************************************************
         Construction and Destruction
         *************************************************************************/
        /*!
        \brief
        Constructor for ItemEntry objects
        */
        public function FlameItemEntry(type:String, name:String)
        {
            super(type, name);
            
            addItemEntryProperties();
        }
        

        /*************************************************************************
         Accessors
         *************************************************************************/
        /*!
        \brief
        Return the "optimal" size for the item
        
        \return
        Size describing the size in pixel that this ItemEntry's content requires
        for non-clipped rendering
        */
        public function getItemPixelSize():Size
        {
            if (d_windowRenderer != null)
            {
                return (d_windowRenderer as ItemEntryWindowRenderer).getItemPixelSize();
            }
            else
            {
                //return getItemPixelSize_impl();
                throw("ItemEntry::getItemPixelSize - " +
                    "This function must be implemented by the window renderer module");
            }
        }
        
        /*!
        \brief
        Returns a pointer to the owner ItemListBase.
        0 if there is none.
        */
        public function getOwnerList():FlameItemListBase
        {
            return d_ownerList;
        }
        
        public function setOwnerList(ol:FlameItemListBase):void
        {
            d_ownerList = ol;
        }
        /*!
        \brief
        Returns whether this item is selected or not.
        */
        public function isSelected():Boolean
        {
            return d_selected;
        }
        
        /*!
        \brief
        Returns whether this item is selectable or not.
        */
        public function isSelectable():Boolean
        {
            return d_selectable;
        }
        
        /*************************************************************************
         Set methods
         *************************************************************************/
        /*!
        \brief
        Sets the selection state of this item (on/off).
        If this item is not selectable this function does nothing.
        
        \param setting
        'true' to select the item.
        'false' to deselect the item.
        */
        public function setSelected(setting:Boolean):void
        {
            setSelected_impl(setting, true);
        }
        
        /*!
        \brief
        Selects the item.
        */
        public function select():void
        {
            setSelected_impl(true, true);
        }
        
        /*!
        \brief
        Deselects the item.
        */
        public function deselect():void
        {
            setSelected_impl(false, true);
        }
        
        /*!
        \brief
        Set the selection state for this ListItem.
        Internal version. Should NOT be used by client code.
        */
        public function setSelected_impl(setting:Boolean, notify:Boolean):void
        {
            if (d_selectable && setting != d_selected)
            {
                d_selected = setting;
                
                // notify the ItemListbox if there is one that we just got selected
                // to ensure selection scheme is not broken when setting selection from code
                if (d_ownerList && notify)
                {
                    d_ownerList.notifyItemSelectState(this, setting);
                }
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onSelectionChanged(args);
            }
        }
        
        /*!
        \brief
        Sets whether this item will be selectable.
        
        \param setting
        'true' to allow this item to be selected.
        'false' to disallow this item from ever being selected.
        
        \note
        If the item is currently selectable and selected, calling this
        function with \a setting as 'false' will first deselect the item
        and then disable selectability.
        */
        public function setSelectable(setting:Boolean):void
        {
            if (d_selectable != setting)
            {
                setSelected(false);
                d_selectable = setting;
            }
        }
        

        /*************************************************************************
         Abstract Implementation Functions
         *************************************************************************/
        /*!
        \brief
        Return the "optimal" size for the item
        
        \return
        Size describing the size in pixel that this ItemEntry's content requires
        for non-clipped rendering
        */
        //virtual Size getItemPixelSize_impl(void) const = 0;
        
        /*************************************************************************
         Implementation Functions
         *************************************************************************/
        /*!
        \brief
        Return whether this window was inherited from the given class name at
        some point in the inheritance hierarchy.
        
        \param class_name
        The class name that is to be checked.
        
        \return
        true if this window was inherited from \a class_name. false if not.
        */
        override protected function testClassName_impl(class_name:String):Boolean
        {
            if (class_name=="ItemEntry")	return true;
            return super.testClassName_impl(class_name);
        }
        
        // validate window renderer
        protected function validateWindowRenderer(name:String):Boolean
        {
            return (name == "ItemEntry");
        }
        
        /*************************************************************************
         New Event Handlers
         *************************************************************************/
        /*!
        \brief
        Handles selection state changes.
        */
        protected function onSelectionChanged(e:WindowEventArgs):void
        {
            invalidate();
            fireEvent(EventSelectionChanged, e, EventNamespace);
        }
        
        /*************************************************************************
         Overridden Event Handlers
         *************************************************************************/
        override public function onMouseClicked(e:MouseEventArgs):void
        {
            super.onMouseClicked(e);
            
            if (d_selectable && e.button == Consts.MouseButton_LeftButton)
            {
                if (d_ownerList)
                    d_ownerList.notifyItemClicked(this);
                else
                    setSelected(!isSelected());
                ++e.handled;
            }
        }
        

        

            
        
        private function addItemEntryProperties():void
        {
            addProperty(d_selectableProperty);
            addProperty(d_selectedProperty);
        }
    }
    
    
}