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
    import Flame2D.core.data.Consts;
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.ActivationEventArgs;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.Vector2;
    import Flame2D.elements.button.FlamePushButton;
    import Flame2D.elements.editbox.FlameEditbox;
    import Flame2D.elements.listbox.FlameListbox;
    import Flame2D.elements.listbox.FlameListboxItem;
    
    public class FlameCombobox extends FlameWindow
    {
        public static const EventNamespace:String = "Combobox";
        public static const WidgetTypeName:String = "CEGUI/Combobox";
        
        /*************************************************************************
         Constants
         *************************************************************************/
        // event names from edit box
        /** Event fired when the read-only mode for the edit box is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Combobox whose read only mode
         * has been changed.
         */
        public static const EventReadOnlyModeChanged:String = "ReadOnlyChanged";
        /** Event fired when the edix box validation string is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Combobox whose validation
         * string was changed.
         */
        public static const EventValidationStringChanged:String = "ValidationStringChanged";
        /** Event fired when the maximum string length is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Combobox whose maximum edit box
         * string length has been changed.
         */
        public static const EventMaximumTextLengthChanged:String = "MaximumTextLengthChanged";
        /** Event fired when an operation has made the current edit box text invalid
         * as regards to the current validation string.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Combobox whose edit box text has
         * become invalid.
         */
        public static const EventTextInvalidated:String = "TextInvalidatedEvent";
        /** Event fired when the user attempts to modify the edit box text in a way
         * that would make it invalid.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Combobox in which the user's input
         * would have invalidated the text.
         */
        public static const EventInvalidEntryAttempted:String = "InvalidEntryAttempted";
        /** Event fired when the edit box text insertion position is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Combobox whose caret position has
         * been changed.
         */
        public static const EventCaratMoved:String = "CaratMoved";
        /** Event fired when the current edit box text selection is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Combobox whose edit box text selection
         * has been changed.
         */
        public static const EventTextSelectionChanged:String = "TextSelectionChanged";
        /** Event fired when the number of characters in the edit box has reached
         * the currently set maximum.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Combobox whose edit box has become
         * full.
         */
        public static const EventEditboxFull:String = "EditboxFullEvent";
        /** Event fired when the user accepts the current edit box text by pressing
         * Return, Enter, or Tab.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Combobox whose edit box text has been
         * accepted / confirmed by the user.
         */
        public static const EventTextAccepted:String = "TextAcceptedEvent";
        
        // event names from list box
        /** Event fired when the contents of the list is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Combobox whose list content has
         * changed.
         */
        public static const EventListContentsChanged:String = "ListContentsChanged";
        /** Event fired when there is a change to the currently selected item in the
         * list.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Combobox whose currently selected list
         * item has changed.
         */
        public static const EventListSelectionChanged:String = "ListSelectionChanged";
        /** Event fired when the sort mode setting of the list is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Combobox whose list sorting mode has
         * been changed.
         */
        public static const EventSortModeChanged:String = "SortModeChanged";
        /** Event fired when the vertical scroll bar 'force' setting for the list is
         * changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Combobox whose vertical scroll bar
         * setting is changed.
         */
        public static const EventVertScrollbarModeChanged:String = "VertScrollbarModeChanged";
        /** Event fired when the horizontal scroll bar 'force' setting for the list
         * is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Combobox whose horizontal scroll bar
         * setting has been changed.
         */
        public static const EventHorzScrollbarModeChanged:String = "HorzScrollbarModeChanged";
        
        // events we produce / generate ourselves
        /** Event fired when the drop-down list is displayed
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Combobox whose drop down list has
         * been displayed.
         */
        public static const EventDropListDisplayed:String = "DropListDisplayed";
        /** Event fired when the drop-down list is removed / hidden.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Combobox whose drop down list has
         * been hidden.
         */
        public static const EventDropListRemoved:String = "DropListRemoved";
        /** Event fired when the user accepts a selection from the drop-down list
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Combobox in which the user has
         * confirmed a selection from the drop down list.
         */
        public static const EventListSelectionAccepted:String = "ListSelectionAccepted";
        
        /*************************************************************************
         Child Widget name suffix constants
         *************************************************************************/
        public static const EditboxNameSuffix:String = "__auto_editbox__";          //!< Widget name suffix for the editbox component.
        public static const DropListNameSuffix:String = "__auto_droplist__";   //!< Widget name suffix for the drop list component.
        public static const ButtonNameSuffix:String = "__auto_button__";           //!< Widget name suffix for the button component.

        
        /*************************************************************************
         Static Properties for this class
         *************************************************************************/
        private static var d_readOnlyProperty:ComboboxPropertyReadOnly                  = new ComboboxPropertyReadOnly();
        private static var d_validationStringProperty:ComboboxPropertyValidationString  = new ComboboxPropertyValidationString();
        private static var d_caratIndexProperty:ComboboxPropertyCaratIndex              = new ComboboxPropertyCaratIndex();
        private static var d_selStartProperty:ComboboxPropertyEditSelectionStart        = new ComboboxPropertyEditSelectionStart();
        private static var d_selLengthProperty:ComboboxPropertyEditSelectionLength      = new ComboboxPropertyEditSelectionLength();
        private static var d_maxTextLengthProperty:ComboboxPropertyMaxEditTextLength    = new ComboboxPropertyMaxEditTextLength();
        private static var d_sortProperty:ComboboxPropertySortList                      = new ComboboxPropertySortList();
        private static var d_forceVertProperty:ComboboxPropertyForceVertScrollbar       = new ComboboxPropertyForceVertScrollbar();
        private static var d_forceHorzProperty:ComboboxPropertyForceHorzScrollbar       = new ComboboxPropertyForceHorzScrollbar();
        private static var d_singleClickOperationProperty:ComboboxPropertySingleClickMode = new ComboboxPropertySingleClickMode();

        
        /*************************************************************************
         Implementation Data
         *************************************************************************/
        private var d_singleClickOperation:Boolean = false;		//!< true if user can show and select from list in a single click.
        
        
        
        
        
        public function FlameCombobox(type:String, name:String)
        {
            super(type, name);
            
            addComboboxProperties();
        }
        
        // override from Window class
        override protected function isHit(position:Vector2, allow_disabled:Boolean = false):Boolean
        {
            return false;
        }
        
        /*!
        \brief
        returns the mode of operation for the combo box.
        
        \return
        - true if the user can show the list and select an item with a single mouse click.
        - false if the user must click to show the list and then click again to select an item.
        */
        public function getSingleClickEnabled():Boolean
        {
            return d_singleClickOperation;
        }
        
        
        /*!
        \brief
        returns true if the drop down list is visible.
        
        \return
        true if the drop down list is visible, false otherwise.
        */
        public function isDropDownListVisible():Boolean
        {
            return getDropList().isVisible();
        }
        
        
        /*!
        \brief
        Return a pointer to the Editbox component widget for this Combobox.
        
        \return
        Pointer to an Editbox object.
        
        \exception UnknownObjectException
        Thrown if the Editbox component does not exist.
        */
        public function getEditbox():FlameEditbox
        {
            return FlameWindowManager.getSingleton().getWindow(getName() + EditboxNameSuffix) as FlameEditbox;
        }
        
        /*!
        \brief
        Return a pointer to the PushButton component widget for this Combobox.
        
        \return
        Pointer to a PushButton object.
        
        \exception UnknownObjectException
        Thrown if the PushButton component does not exist.
        */
        public function getPushButton():FlamePushButton
        {
            return FlameWindowManager.getSingleton().getWindow(getName() + ButtonNameSuffix) as FlamePushButton;
        }
        
        /*!
        \brief
        Return a pointer to the ComboDropList component widget for this
        Combobox.
        
        \return
        Pointer to an ComboDropList object.
        
        \exception UnknownObjectException
        Thrown if the ComboDropList component does not exist.
        */
        public function getDropList():FlameComboDropList
        {
            return FlameWindowManager.getSingleton().getWindow(
                getName() + DropListNameSuffix) as FlameComboDropList;
        }
        
        
        /*************************************************************************
         Editbox Accessors
         *************************************************************************/
        /*!
        \brief
        return true if the Editbox has input focus.
        
        \return
        true if the Editbox has keyboard input focus, false if the Editbox does not have keyboard input focus.
        */
        public function hasInputFocus():Boolean
        {
            return getEditbox().hasInputFocus();
        }
        
        
        /*!
        \brief
        return true if the Editbox is read-only.
        
        \return
        true if the Editbox is read only and can't be edited by the user, false if the Editbox is not
        read only and may be edited by the user.
        */
        public function isReadOnly():Boolean
        {
            return getEditbox().isReadOnly();
        }
        
        
        /*!
        \brief
        return true if the Editbox text is valid given the currently set validation string.
        
        \note
        It is possible to programmatically set 'invalid' text for the Editbox by calling setText.  This has certain
        implications since if invalid text is set, whatever the user types into the box will be rejected when the input
        is validated.
        
        \note
        Validation is performed by means of a regular expression.  If the text matches the regex, the text is said to have passed
        validation.  If the text does not match with the regex then the text fails validation.
        
        \return
        true if the current Editbox text passes validation, false if the text does not pass validation.
        */
        public function isTextValid():Boolean
        {
            return getEditbox().isTextValid();
        }
        
        
        /*!
        \brief
        return the currently set validation string
        
        \note
        Validation is performed by means of a regular expression.  If the text matches the regex, the text is said to have passed
        validation.  If the text does not match with the regex then the text fails validation.
        
        \return
        String object containing the current validation regex data
        */
        public function getValidationString():String
        {
            return getEditbox().getValidationString();
        }
        
        
        /*!
        \brief
        return the current position of the carat.
        
        \return
        Index of the insert carat relative to the start of the text.
        */
        public function getCaratIndex():uint
        {
            return getEditbox().getCaratIndex();
        }
        
        
        /*!
        \brief
        return the current selection start point.
        
        \return
        Index of the selection start point relative to the start of the text.  If no selection is defined this function returns
        the position of the carat.
        */
        public function getSelectionStartIndex():uint
        {
            return getEditbox().getSelectionStartIndex();
        }
        
        
        /*!
        \brief
        return the current selection end point.
        
        \return
        Index of the selection end point relative to the start of the text.  If no selection is defined this function returns
        the position of the carat.
        */
        public function getSelectionEndIndex():uint
        {
            return getEditbox().getSelectionEndIndex();
        }
        
        
        /*!
        \brief
        return the length of the current selection (in code points / characters).
        
        \return
        Number of code points (or characters) contained within the currently defined selection.
        */
        public function getSelectionLength():uint
        {
            return getEditbox().getSelectionLength();
        }
        
        
        /*!
        \brief
        return the maximum text length set for this Editbox.
        
        \return
        The maximum number of code points (characters) that can be entered into this Editbox.
        
        \note
        Depending on the validation string set, the actual length of text that can be entered may be less than the value
        returned here (it will never be more).
        */
        public function getMaxTextLength():uint
        {
            return getEditbox().getMaxTextLength();
        }
        
        
        /*************************************************************************
         List Accessors
         *************************************************************************/
        /*!
        \brief
        Return number of items attached to the list box
        
        \return
        the number of items currently attached to this list box.
        */
        public function getItemCount():uint
        {
            return getDropList().getItemCount();
        }
        
        
        /*!
        \brief
        Return a pointer to the currently selected item.
        
        \return
        Pointer to a ListboxItem based object that is the selected item in the list.  will return NULL if
        no item is selected.
        */
        public function getSelectedItem():FlameListboxItem
        {
            return getDropList().getFirstSelectedItem();
        }
        
        
        /*!
        \brief
        Return the item at index position \a index.
        
        \param index
        Zero based index of the item to be returned.
        
        \return
        Pointer to the ListboxItem at index position \a index in the list box.
        
        \exception	InvalidRequestException	thrown if \a index is out of range.
        */
        public function getListboxItemFromIndex(index:uint):FlameListboxItem
        {
            return getDropList().getListboxItemFromIndex(index);
        }
        
        
        /*!
        \brief
        Return the index of ListboxItem \a item
        
        \param item
        Pointer to a ListboxItem whos zero based index is to be returned.
        
        \return
        Zero based index indicating the position of ListboxItem \a item in the list box.
        
        \exception	InvalidRequestException	thrown if \a item is not attached to this list box.
        */
        public function getItemIndex(item:FlameListboxItem):uint
        {
            return getDropList().getItemIndex(item);
        }
        
        
        /*!
        \brief
        return whether list sorting is enabled
        
        \return
        true if the list is sorted, false if the list is not sorted
        */
        public function isSortEnabled():Boolean
        {
            return getDropList().isSortEnabled();
        }
        
        
        /*!
        \brief
        return whether the string at index position \a index is selected
        
        \param index
        Zero based index of the item to be examined.
        
        \return
        true if the item at \a index is selected, false if the item at \a index is not selected.
        
        \exception	InvalidRequestException	thrown if \a index is out of range.
        */
        public function isItemSelected(index:uint):Boolean
        {
            return getDropList().isItemSelected(index);
        }
        
        
        /*!
        \brief
        Search the list for an item with the specified text
        
        \param text
        String object containing the text to be searched for.
        
        \param start_item
        ListboxItem where the search is to begin, the search will not include \a item.  If \a item is
        NULL, the search will begin from the first item in the list.
        
        \return
        Pointer to the first ListboxItem in the list after \a item that has text matching \a text.  If
        no item matches the criteria NULL is returned.
        
        \exception	InvalidRequestException	thrown if \a item is not attached to this list box.
        */
        public function findItemWithText(text:String, start_item:FlameListboxItem):FlameListboxItem
        {
            return getDropList().findItemWithText(text, start_item);
        }
        
        
        /*!
        \brief
        Return whether the specified ListboxItem is in the List
        
        \return
        true if ListboxItem \a item is in the list, false if ListboxItem \a item is not in the list.
        */
        public function isListboxItemInList(item:FlameListboxItem):Boolean
        {
            return getDropList().isListboxItemInList(item);
        }
        
        
        /*!
        \brief
        Return whether the vertical scroll bar is always shown.
        
        \return
        - true if the scroll bar will always be shown even if it is not required.
        - false if the scroll bar will only be shown when it is required.
        */
        public function isVertScrollbarAlwaysShown():Boolean
        {
            return getDropList().isVertScrollbarAlwaysShown();
        }
        
        
        /*!
        \brief
        Return whether the horizontal scroll bar is always shown.
        
        \return
        - true if the scroll bar will always be shown even if it is not required.
        - false if the scroll bar will only be shown when it is required.
        */
        public function isHorzScrollbarAlwaysShown():Boolean
        {
            return getDropList().isHorzScrollbarAlwaysShown();
        }
        
        
        /*************************************************************************
         Combobox Manipulators
         *************************************************************************/
        /*!
        \brief
        Initialise the Window based object ready for use.
        
        \note
        This must be called for every window created.  Normally this is handled automatically by the WindowFactory for each Window type.
        
        \return
        Nothing
        */
        override public function initialiseComponents():void
        {
            var editbox:FlameEditbox  = getEditbox();
            var droplist:FlameComboDropList = getDropList();
            var button:FlamePushButton  = getPushButton();
            droplist.setFont(getFont());
            editbox.setFont(getFont());
            
            // internal event wiring
            button.subscribeEvent(FlameWindow.EventMouseButtonDown, new Subscriber(button_PressHandler, this), FlameWindow.EventNamespace);
            droplist.subscribeEvent(FlameComboDropList.EventListSelectionAccepted, new Subscriber(droplist_SelectionAcceptedHandler, this), FlameComboDropList.EventNamespace);
            droplist.subscribeEvent(FlameWindow.EventHidden, new Subscriber(droplist_HiddenHandler, this), FlameWindow.EventNamespace);
            editbox.subscribeEvent(FlameWindow.EventMouseButtonDown, new Subscriber(editbox_MouseDownHandler, this), FlameWindow.EventNamespace);
            
            // event forwarding setup
            editbox.subscribeEvent(FlameEditbox.EventReadOnlyModeChanged,       new Subscriber(editbox_ReadOnlyChangedHandler, this), FlameEditbox.EventNamespace);
            editbox.subscribeEvent(FlameEditbox.EventValidationStringChanged,   new Subscriber(editbox_ValidationStringChangedHandler, this), FlameEditbox.EventNamespace);
            editbox.subscribeEvent(FlameEditbox.EventMaximumTextLengthChanged,  new Subscriber(editbox_MaximumTextLengthChangedHandler, this), FlameEditbox.EventNamespace);
            editbox.subscribeEvent(FlameEditbox.EventTextInvalidated,           new Subscriber(editbox_TextInvalidatedEventHandler, this), FlameEditbox.EventNamespace);
            editbox.subscribeEvent(FlameEditbox.EventInvalidEntryAttempted,     new Subscriber(editbox_InvalidEntryAttemptedHandler, this), FlameEditbox.EventNamespace);
            editbox.subscribeEvent(FlameEditbox.EventCaratMoved,                new Subscriber(editbox_CaratMovedHandler, this), FlameEditbox.EventNamespace);
            editbox.subscribeEvent(FlameEditbox.EventTextSelectionChanged,      new Subscriber(editbox_TextSelectionChangedHandler, this), FlameEditbox.EventNamespace);
            editbox.subscribeEvent(FlameEditbox.EventEditboxFull,               new Subscriber(editbox_EditboxFullEventHandler, this), FlameEditbox.EventNamespace);
            editbox.subscribeEvent(FlameEditbox.EventTextAccepted,              new Subscriber(editbox_TextAcceptedEventHandler, this), FlameEditbox.EventNamespace);
            editbox.subscribeEvent(FlameWindow.EventTextChanged,                new Subscriber(editbox_TextChangedEventHandler, this), FlameWindow.EventNamespace);
            droplist.subscribeEvent(FlameListbox.EventListContentsChanged,      new Subscriber(listbox_ListContentsChangedHandler, this), FlameListbox.EventNamespace);
            droplist.subscribeEvent(FlameListbox.EventSelectionChanged,         new Subscriber(listbox_ListSelectionChangedHandler, this), FlameListbox.EventNamespace);
            droplist.subscribeEvent(FlameListbox.EventSortModeChanged,          new Subscriber(listbox_SortModeChangedHandler, this), FlameListbox.EventNamespace);
            droplist.subscribeEvent(FlameListbox.EventVertScrollbarModeChanged, new Subscriber(listbox_VertScrollModeChangedHandler, this), FlameListbox.EventNamespace);
            droplist.subscribeEvent(FlameListbox.EventHorzScrollbarModeChanged, new Subscriber(listbox_HorzScrollModeChangedHandler, this), FlameListbox.EventNamespace);
            
            // put components in their initial positions
            performChildWindowLayout();
        }
        
        
        /*!
        \brief
        Show the drop-down list
        
        \return
        Nothing
        */
        public function showDropList():void
        {
            // Display the box
            var droplist:FlameComboDropList = getDropList();
            droplist.show();
            droplist.activate();
            droplist.captureInput();
            
            // Fire off event
            var args:WindowEventArgs = new WindowEventArgs(this);
            onDropListDisplayed(args);
        }
            
        
        
        /*!
        \brief
        Hide the drop-down list
        
        \return
        Nothing.
        */
        public function hideDropList():void
        {
            // the natural order of things when this happens will ensure the list is
            // hidden and events are fired.
            getDropList().releaseInput();
        }
        
        
        /*!
        \brief
        Set the mode of operation for the combo box.
        
        \param setting
        - true if the user should be able to show the list and select an item with a single mouse click.
        - false if the user must click to show the list and then click again to select an item.
        
        \return
        Nothing.
        */
        public function setSingleClickEnabled(setting:Boolean):void
        {
            d_singleClickOperation = setting;
            getDropList().setAutoArmEnabled(setting);
        }
        
        
        /*************************************************************************
         Editbox Manipulators
         *************************************************************************/
        /*!
        \brief
        Specify whether the Editbox is read-only.
        
        \param setting
        true if the Editbox is read only and can't be edited by the user, false if the Editbox is not
        read only and may be edited by the user.
        
        \return
        Nothing.
        */
        public function setReadOnly(setting:Boolean):void
        {
            getEditbox().setReadOnly(setting);
        }
        
        
        /*!
        \brief
        Set the text validation string.
        
        \note
        Validation is performed by means of a regular expression.  If the text matches the regex, the text is said to have passed
        validation.  If the text does not match with the regex then the text fails validation.
        
        \param validation_string
        String object containing the validation regex data to be used.
        
        \return
        Nothing.
        */
        public function setValidationString(str:String):void
        {
            getEditbox().setValidationString(str);
        }
        
        
        
        /*!
        \brief
        Set the current position of the carat.
        
        \param carat_pos
        New index for the insert carat relative to the start of the text.  If the value specified is greater than the
        number of characters in the Editbox, the carat is positioned at the end of the text.
        
        \return
        Nothing.
        */
        public function setCaratIndex(carat_pos:uint):void
        {
            getEditbox().setCaratIndex(carat_pos);
        }
        
        
        /*!
        \brief
        Define the current selection for the Editbox
        
        \param start_pos
        Index of the starting point for the selection.  If this value is greater than the number of characters in the Editbox, the
        selection start will be set to the end of the text.
        
        \param end_pos
        Index of the ending point for the selection.  If this value is greater than the number of characters in the Editbox, the
        selection start will be set to the end of the text.
        
        \return
        Nothing.
        */
        public function setSelection(start_pos:uint, end_pos:uint):void
        {
            getEditbox().setSelection(start_pos, end_pos);
        }
        
        
        /*!
        \brief
        set the maximum text length for this Editbox.
        
        \param max_len
        The maximum number of code points (characters) that can be entered into this Editbox.
        
        \note
        Depending on the validation string set, the actual length of text that can be entered may be less than the value
        set here (it will never be more).
        
        \return
        Nothing.
        */
        public function setMaxTextLength(max_len:uint):void
        {
            getEditbox().setMaxTextLength(max_len);
        }
        
        
        /*!
        \brief
        Activate the edit box component of the Combobox.
        
        \return
        Nothing.
        */
        public function activateEditbox():void
        {
            var editbox:FlameEditbox = getEditbox();
            
            if (!editbox.isActive())
            {
                editbox.activate();
            }
        }
        
        
        /*************************************************************************
         List Manipulators
         *************************************************************************/
        /*!
        \brief
        Remove all items from the list.
        
        Note that this will cause 'AutoDelete' items to be deleted.
        */
        public function resetList():void
        {
            getDropList().resetList();
        }
        
        
        /*!
        \brief
        Add the given ListboxItem to the list.
        
        \param item
        Pointer to the ListboxItem to be added to the list.  Note that it is the passed object that is added to the
        list, a copy is not made.  If this parameter is NULL, nothing happens.
        
        \return
        Nothing.
        */
        public function addItem(item:FlameListboxItem):void
        {
            getDropList().addItem(item);
        }
        
        
        /*!
        \brief
        Insert an item into the list box after a specified item already in the list.
        
        Note that if the list is sorted, the item may not end up in the requested position.
        
        \param item
        Pointer to the ListboxItem to be inserted.  Note that it is the passed object that is added to the
        list, a copy is not made.  If this parameter is NULL, nothing happens.
        
        \param position
        Pointer to a ListboxItem that \a item is to be inserted after.  If this parameter is NULL, the item is
        inserted at the start of the list.
        
        \return
        Nothing.
        */
        public function insertItem(item:FlameListboxItem, position:FlameListboxItem):void
        {
            getDropList().insertItem(item, position);
        }
        
        
        /*!
        \brief
        Removes the given item from the list box.
        
        \param item
        Pointer to the ListboxItem that is to be removed.  If \a item is not attached to this list box then nothing
        will happen.
        
        \return
        Nothing.
        */
        public function removeItem(item:FlameListboxItem):void
        {
            getDropList().removeItem(item);
        }
        
        
        /*!
        \brief
        Clear the selected state for all items.
        
        \return
        Nothing.
        */
        public function clearAllSelections():void
        {
            getDropList().clearAllSelections();
        }
        
        
        /*!
        \brief
        Set whether the list should be sorted.
        
        \param setting
        true if the list should be sorted, false if the list should not be sorted.
        
        \return
        Nothing.
        */
        public function setSortingEnabled(setting:Boolean):void
        {
            getDropList().setSortingEnabled(setting);
        }
        
        
        /*!
        \brief
        Set whether the vertical scroll bar should always be shown.
        
        \param setting
        true if the vertical scroll bar should be shown even when it is not required.  false if the vertical
        scroll bar should only be shown when it is required.
        
        \return
        Nothing.
        */
        public function setShowVertScrollbar(setting:Boolean):void
        {
            getDropList().setShowVertScrollbar(setting);
        }
        
        
        /*!
        \brief
        Set whether the horizontal scroll bar should always be shown.
        
        \param setting
        true if the horizontal scroll bar should be shown even when it is not required.  false if the horizontal
        scroll bar should only be shown when it is required.
        
        \return
        Nothing.
        */
        public function setShowHorzScrollbar(setting:Boolean):void
        {
            getDropList().setShowHorzScrollbar(setting);
        }
        
        
        /*!
        \brief
        Set the select state of an attached ListboxItem.
        
        This is the recommended way of selecting and deselecting items attached to a list box as it respects the
        multi-select mode setting.  It is possible to modify the setting on ListboxItems directly, but that approach
        does not respect the settings of the list box.
        
        \param item
        The ListboxItem to be affected.  This item must be attached to the list box.
        
        \param state
        true to select the item, false to de-select the item.
        
        \return
        Nothing.
        
        \exception	InvalidRequestException	thrown if \a item is not attached to this list box.
        */
        public function setItemSelectState(item:FlameListboxItem, state:Boolean):void
        {
            var was_selected:Boolean = (item && item.isSelected());
            
            getDropList().setItemSelectState(item, state);
            
            itemSelectChangeTextUpdate(item, state, was_selected);
        }
        
        
        /*!
        \brief
        Set the select state of an attached ListboxItem.
        
        This is the recommended way of selecting and deselecting items attached to a list box as it respects the
        multi-select mode setting.  It is possible to modify the setting on ListboxItems directly, but that approach
        does not respect the settings of the list box.
        
        \param item_index
        The zero based index of the ListboxItem to be affected.  This must be a valid index (0 <= index < getItemCount())
        
        \param state
        true to select the item, false to de-select the item.
        
        \return
        Nothing.
        
        \exception	InvalidRequestException	thrown if \a item_index is out of range for the list box
        */
        public function setItemSelectStateByIndex(item_index:uint, state:Boolean):void
        {
            var droplist:FlameComboDropList = getDropList();
            
            var item:FlameListboxItem = (droplist.getItemCount() > item_index) ?
                    droplist.getListboxItemFromIndex(item_index) :
                    null;
            
            var was_selected:Boolean = (item && item.isSelected());
            
            droplist.setItemSelectStateByIndex(item_index, state);
            
            itemSelectChangeTextUpdate(item, state, was_selected);
        }
        
        
        /*!
        \brief
        Causes the list box to update it's internal state after changes have been made to one or more
        attached ListboxItem objects.
        
        Client code must call this whenever it has made any changes to ListboxItem objects already attached to the
        list box.  If you are just adding items, or removed items to update them prior to re-adding them, there is
        no need to call this method.
        
        \return
        Nothing.
        */
        public function handleUpdatedListItemData():void
        {
            getDropList().handleUpdatedItemData();
        }
        
        
        
        /*************************************************************************
         Implementation Methods
         *************************************************************************/
        /*!
        \brief
        Handler function for button clicks.
        */
        protected function button_PressHandler(e:EventArgs):Boolean
        {
            var droplist:FlameComboDropList = getDropList();
            
            // if there is an item with the same text as the edit box, pre-select it
            var item:FlameListboxItem = droplist.findItemWithText(getEditbox().getText(), null);
            
            if (item)
            {
                droplist.setItemSelectState(item, true);
                droplist.ensureItemIsVisible(item);
            }
                // no matching item, so select nothing
            else
            {
                droplist.clearAllSelections();
            }
            
            showDropList();
            
            return true;
        }
        
        
        /*!
        \brief
        Handler for selections made in the drop-list
        */
        protected function droplist_SelectionAcceptedHandler(e:EventArgs):Boolean
        {
            // copy the text from the selected item into the edit box
            var item:FlameListboxItem = ((e as WindowEventArgs).window as FlameComboDropList).getFirstSelectedItem();
            
            if (item)
            {
                var editbox:FlameEditbox = getEditbox();
                // Put the text from the list item into the edit box
                editbox.setText(item.getText());
                
                // select text if it's editable, and move carat to end
                if (!isReadOnly())
                {
                    editbox.setSelection(0, item.getText().length);
                    editbox.setCaratIndex(item.getText().length);
                }
                
                editbox.setCaratIndex(0);
                editbox.activate();
                
                // fire off an event of our own
                var args:WindowEventArgs = new WindowEventArgs(this);
                onListSelectionAccepted(args);
            }
            
            return true;
        }
        
        
        /*!
        \brief
        Handler for when drop-list hides itself
        */
        protected function droplist_HiddenHandler(e:EventArgs):Boolean
        {
            var args:WindowEventArgs = new WindowEventArgs(this);
            onDroplistRemoved(args);
            
            return true;
        }
        
        
        /*!
        \brief
        Mouse button down handler attached to edit box
        */
        protected function editbox_MouseDownHandler(e:EventArgs):Boolean
        {
            // only interested in left button
            if ((e as MouseEventArgs).button == Consts.MouseButton_LeftButton)
            {
                var editbox:FlameEditbox = getEditbox();
                
                // if edit box is read-only, show list
                if (editbox.isReadOnly())
                {
                    var droplist:FlameComboDropList = getDropList();
                    
                    // if there is an item with the same text as the edit box, pre-select it
                    var item:FlameListboxItem = droplist.findItemWithText(editbox.getText(), null);
                    
                    if (item)
                    {
                        droplist.setItemSelectState(item, true);
                        droplist.ensureItemIsVisible(item);
                    }
                        // no matching item, so select nothing
                    else
                    {
                        droplist.clearAllSelections();
                    }
                    
                    showDropList();
                    
                    return true;
                }
            }
            
            return false;
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
            if (class_name=="Combobox")	return true;
            return super.testClassName_impl(class_name);
        }
        
        /*!
        \brief
        Update the Combobox text to reflect programmatically made changes to
        selected list item.
        */
        protected function itemSelectChangeTextUpdate(item:FlameListboxItem,
            new_state:Boolean, old_state:Boolean):void
        {
            
            if (!new_state)
            {
                if (getText() == item.getText())
                    setText("");
            }
            else
            {
                if (!old_state)
                    setText(item.getText());
            }
        }
        
        /*************************************************************************
         Handlers to relay child widget events so they appear to come from us
         *************************************************************************/
        protected function editbox_ReadOnlyChangedHandler(e:EventArgs):Boolean
        {
            var args:WindowEventArgs = new WindowEventArgs(this);
            onReadOnlyChanged(args);
            
            return true;
        }
        
        protected function editbox_ValidationStringChangedHandler(e:EventArgs):Boolean
        {
            var args:WindowEventArgs = new WindowEventArgs(this);
            onValidationStringChanged(args);
            
            return true;
        }
        
        protected function editbox_MaximumTextLengthChangedHandler(e:EventArgs):Boolean
        {
            var args:WindowEventArgs = new WindowEventArgs(this);
            onMaximumTextLengthChanged(args);
            
            return true;
        }
        
        protected function editbox_TextInvalidatedEventHandler(e:EventArgs):Boolean
        {
            var args:WindowEventArgs = new WindowEventArgs(this);
            onTextInvalidatedEvent(args);
            
            return true;
        }
        
        protected function editbox_InvalidEntryAttemptedHandler(e:EventArgs):Boolean
        {
            var args:WindowEventArgs = new WindowEventArgs(this);
            onInvalidEntryAttempted(args);
            
            return true;
        }
        
        protected function editbox_CaratMovedHandler(e:EventArgs):Boolean
        {
            var args:WindowEventArgs = new WindowEventArgs(this);
            onCaratMoved(args);
            
            return true;
        }
        
        protected function editbox_TextSelectionChangedHandler(e:EventArgs):Boolean
        {
            var args:WindowEventArgs = new WindowEventArgs(this);
            onTextSelectionChanged(args);
            
            return true;
        }
        
        protected function editbox_EditboxFullEventHandler(e:EventArgs):Boolean
        {
            var args:WindowEventArgs = new WindowEventArgs(this);
            onEditboxFullEvent(args);
            
            return true;
        }
        protected function editbox_TextAcceptedEventHandler(e:EventArgs):Boolean
        {
            var args:WindowEventArgs = new WindowEventArgs(this);
            onTextAcceptedEvent(args);
            
            return true;
        }
        protected function editbox_TextChangedEventHandler(e:EventArgs):Boolean
        {
            // set this windows text to match
            setText(((e as WindowEventArgs).window).getText());
            
            return true;
        }
        
        protected function listbox_ListContentsChangedHandler(e:EventArgs):Boolean
        {
            var args:WindowEventArgs = new WindowEventArgs(this);
            onListContentsChanged(args);
            
            return true;
        }
        
        protected function listbox_ListSelectionChangedHandler(e:EventArgs):Boolean
        {
            var args:WindowEventArgs = new WindowEventArgs(this);
            onListSelectionChanged(args);
            
            return true;
        }
        protected function listbox_SortModeChangedHandler(e:EventArgs):Boolean
        {
            var args:WindowEventArgs = new WindowEventArgs(this);
            onSortModeChanged(args);
            
            return true;
        }
        protected function listbox_VertScrollModeChangedHandler(e:EventArgs):Boolean
        {
            var args:WindowEventArgs = new WindowEventArgs(this);
            onVertScrollbarModeChanged(args);
            
            return true;
        }
        protected function listbox_HorzScrollModeChangedHandler(e:EventArgs):Boolean
        {
            var args:WindowEventArgs = new WindowEventArgs(this);
            onHorzScrollbarModeChanged(args);
            
            return true;
        }
        
        
        /*************************************************************************
         New Events for Combobox
         *************************************************************************/
        /*!
        \brief
        Handler called internally when the read only state of the Combobox's Editbox has been changed.
        */
        protected function onReadOnlyChanged(e:WindowEventArgs):void
        {
            fireEvent(EventReadOnlyModeChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called internally when the Combobox's Editbox validation string has been changed.
        */
        protected function onValidationStringChanged(e:WindowEventArgs):void
        {
            fireEvent(EventValidationStringChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called internally when the Combobox's Editbox maximum text length is changed.
        */
        protected function onMaximumTextLengthChanged(e:WindowEventArgs):void
        {
            fireEvent(EventMaximumTextLengthChanged, e, EventNamespace);
        }
        
        
        
        /*!
        \brief
        Handler called internally when the Combobox's Editbox text has been invalidated.
        */
        protected function onTextInvalidatedEvent(e:WindowEventArgs):void
        {
            fireEvent(EventTextInvalidated, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called internally when an invalid entry was attempted in the Combobox's Editbox.
        */
        protected function onInvalidEntryAttempted(e:WindowEventArgs):void
        {
            fireEvent(EventInvalidEntryAttempted, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called internally when the carat in the Comboxbox's Editbox moves.
        */
        protected function onCaratMoved(e:WindowEventArgs):void
        {
            fireEvent(EventCaratMoved, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called internally when the selection within the Combobox's Editbox changes.
        */
        protected function onTextSelectionChanged(e:WindowEventArgs):void
        {
            fireEvent(EventTextSelectionChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called internally when the maximum length is reached for text in the Combobox's Editbox.
        */
        protected function onEditboxFullEvent(e:WindowEventArgs):void
        {
            fireEvent(EventEditboxFull, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called internally when the text in the Combobox's Editbox is accepted (by various means).
        */
        protected function onTextAcceptedEvent(e:WindowEventArgs):void
        {
            fireEvent(EventTextAccepted, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called internally when the Combobox's Drop-down list contents are changed.
        */
        protected function onListContentsChanged(e:WindowEventArgs):void
        {
            fireEvent(EventListContentsChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called internally when the selection within the Combobox's drop-down list changes
        (this is not the 'final' accepted selection, just the currently highlighted item).
        */
        protected function onListSelectionChanged(e:WindowEventArgs):void
        {
            fireEvent(EventListSelectionChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called  fired internally when the sort mode for the Combobox's drop-down list is changed.
        */
        protected function onSortModeChanged(e:WindowEventArgs):void
        {
            fireEvent(EventSortModeChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called internally when the 'force' setting for the vertical scrollbar within the Combobox's
        drop-down list is changed.
        */
        protected function onVertScrollbarModeChanged(e:WindowEventArgs):void
        {
            fireEvent(EventVertScrollbarModeChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called internally when the 'force' setting for the horizontal scrollbar within the Combobox's
        drop-down list is changed.
        */
        protected function onHorzScrollbarModeChanged(e:WindowEventArgs):void
        {
            fireEvent(EventHorzScrollbarModeChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called internally when the Combobox's drop-down list has been displayed.
        */
        protected function onDropListDisplayed(e:WindowEventArgs):void
        {
            FlameSystem.getSingleton().updateWindowContainingMouse();
            getPushButton().setPushedState(true);
            fireEvent(EventDropListDisplayed, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called internally when the Combobox's drop-down list has been hidden.
        */
        protected function onDroplistRemoved(e:WindowEventArgs):void
        {
            FlameSystem.getSingleton().updateWindowContainingMouse();
            getPushButton().setPushedState(false);
            fireEvent(EventDropListRemoved, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called internally when the user has confirmed a selection within the Combobox's drop-down list.
        */
        protected function onListSelectionAccepted(e:WindowEventArgs):void
        {
            fireEvent(EventListSelectionAccepted, e, EventNamespace);
        }
        
        
        /*************************************************************************
         Overridden Event handlers
         *************************************************************************/
        override protected function onFontChanged(e:WindowEventArgs):void
        {
            // Propagate to children
            getEditbox().setFont(getFont());
            getDropList().setFont(getFont());
            
            // Call base class handler
            super.onFontChanged(e);
        }
        
        override protected function onTextChanged(e:WindowEventArgs):void
        {
            var editbox:FlameEditbox = getEditbox();
            
            // update ourselves only if needed (prevents perpetual event loop & stack overflow)
            if (editbox.getText() != getText())
            {
                // done before doing base class processing so event subscribers see 'updated' version of this.
                editbox.setText(getText());
                ++e.handled;
                
                super.onTextChanged(e);
            }
        }
        
        override protected function onActivated(e:ActivationEventArgs):void
        {
            if (!isActive())
            {
                super.onActivated(e);
                activateEditbox();
            }
        }

        
        
        /*************************************************************************
         Private methods
         *************************************************************************/
        private function addComboboxProperties():void
        {
            addProperty(d_sortProperty);
            addProperty(d_forceHorzProperty);
            addProperty(d_forceVertProperty);
            addProperty(d_readOnlyProperty);
            addProperty(d_validationStringProperty);
            addProperty(d_maxTextLengthProperty);
            addProperty(d_selStartProperty);
            addProperty(d_selLengthProperty);
            addProperty(d_caratIndexProperty);
            addProperty(d_singleClickOperationProperty);   
        }
    }
}
