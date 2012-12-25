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
package Flame2D.elements.editbox
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.events.KeyEventArgs;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.system.FlameEventManager;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.text.FlameRegexpMatcher;
    import Flame2D.core.utils.TextUtils;
    import Flame2D.core.utils.Vector2;

    //! Base class for an Editbox widget
    public class FlameEditbox extends FlameWindow
    {
        public static const EventNamespace:String = "Editbox";
        public static const WidgetTypeName:String = "CEGUI/Editbox";
        
         /** Event fired when the read-only mode for the edit box is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Editbox whose read only setting
         * has been changed.
         */       
        public static const EventReadOnlyModeChanged:String = "ReadOnlyChanged";
        /** Event fired when the masked rendering mode (password mode) is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Editbox that has been put into or
         * taken out of masked text (password) mode.
         */
        public static const EventMaskedRenderingModeChanged:String = "MaskRenderChanged";
        /** Event fired whrn the code point (character) used for masked text is
         * changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Editbox whose text masking codepoint
         * has been changed.
         */
        public static const EventMaskCodePointChanged:String = "MaskCPChanged";
        /** Event fired when the validation string is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Editbox whose validation string has
         * been changed.
         */
        public static const EventValidationStringChanged:String = "ValidatorChanged";
        /** Event fired when the maximum allowable string length is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Editbox whose maximum string length
         * has been changed.
         */
        public static const EventMaximumTextLengthChanged:String = "MaxTextLenChanged";
        /** Event fired when the current text has become invalid as regards to the
         * validation string.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Editbox whose text has become invalid.
         */
        public static const EventTextInvalidated:String = "TextInvalidated";
        /** Event fired when the user attempts to chage the text in a way that would
         * make it invalid as regards to the validation string.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Editbox in which the users input would
         * have invalidated the text.
         */
        public static const EventInvalidEntryAttempted:String = "InvalidInputAttempt";
        /** Event fired when the text caret position / insertion point is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Editbox whose current insertion point
         * has changed.
         */
        public static const EventCaratMoved:String = "TextCaratMoved";
        /** Event fired when the current text selection is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Editbox whose current text selection
         * was changed.
         */
        public static const EventTextSelectionChanged:String = "TextSelectChanged";
         /** Event fired when the number of characters in the edit box reaches the
         * currently set maximum.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Editbox that has become full.
         */
        public static const EventEditboxFull:String = "EditboxFull";
        /** Event fired when the user accepts the current text by pressing Return,
         * Enter, or Tab.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Editbox in which the user has accepted
         * the current text.
         */
        public static const EventTextAccepted:String = "TextAccepted";

        
        private static var d_readOnlyProperty:EditboxPropertyReadOnly               = new EditboxPropertyReadOnly();
        private static var d_maskTextProperty:EditboxPropertyMaskText               = new EditboxPropertyMaskText();
        private static var d_maskCodepointProperty:EditboxPropertyMaskCodepoint     = new EditboxPropertyMaskCodepoint();
        private static var d_validationStringProperty:EditboxPropertyValidationString = new EditboxPropertyValidationString();
        private static var d_caratIndexProperty:EditboxPropertyCaratIndex           = new EditboxPropertyCaratIndex();
        private static var d_selectionStartProperty:EditboxPropertySelectionStart   = new EditboxPropertySelectionStart();
        private static var d_selectionLengthProperty:EditboxPropertySelectionLength = new EditboxPropertySelectionLength();
        private static var d_maxTextLengthProperty:EditboxPropertyMaxTextLength     = new EditboxPropertyMaxTextLength();
        
        
        
        //! True if the editbox is in read-only mode
        protected var d_readOnly:Boolean = false;
        //! True if the editbox text should be rendered masked.
        protected var d_maskText:Boolean = false;
        //! Code point to use when rendering masked text.
        //utf32 d_maskCodePoint;
        protected var d_maskCodePoint:uint = String("*").charCodeAt(0);
        //! Maximum number of characters for this Editbox.
        protected var d_maxTextLen:uint = 1024;//uint.MAX_VALUE; //??
        //! Position of the carat / insert-point.
        protected var d_caratPos:uint = 0;
        //! Start of selection area.
        protected var d_selectionStart:uint = 0;
        //! End of selection area.
        protected var d_selectionEnd:uint = 0;
        //! Copy of validation reg-ex string.
        protected var d_validationString:String = ".*";
        //! Pointer to class used for validation of text.
        protected var d_validator:FlameRegexpMatcher = null;
        //! true when a selection is being dragged.
        protected var d_dragging:Boolean = false;
        //! Selection index for drag selection anchor point.
        protected var d_dragAnchorIdx:uint;

        
        
        
        public function FlameEditbox(type:String, name:String)
        {
            super(type, name);  
            
            addEditboxProperties();
            
            d_validator = new FlameRegexpMatcher();
            // default to accepting all characters
            setValidationString(".*");
        }
        
        
        
        
        
        
        /*!
        \brief
        return true if the Editbox has input focus.
        
        \return
        - true if the Editbox has keyboard input focus.
        - false if the Editbox does not have keyboard input focus.
        */
        public function hasInputFocus():Boolean
        {
            return isActive();
        }
        
        /*!
        \brief
        return true if the Editbox is read-only.
        
        \return
        true if the Editbox is read only and can't be edited by the user, false
        if the Editbox is not read only and may be edited by the user.
        */
        public function isReadOnly():Boolean
        {
            return d_readOnly;
        }
        
        /*!
        \brief
        return true if the text for the Editbox will be rendered masked.
        
        \return
        true if the Editbox text will be rendered masked using the currently set
        mask code point, false if the Editbox text will be rendered as ordinary
        text.
        */
        public function isTextMasked():Boolean
        {
            return d_maskText;
        }
        
        /*!
        \brief
        return true if the Editbox text is valid given the currently set
        validation string.
        
        \note
        It is possible to programmatically set 'invalid' text for the Editbox by
        calling setText.  This has certain implications since if invalid text is
        set, whatever the user types into the box will be rejected when the
        input is validated.
        
        \note
        Validation is performed by means of a regular expression.  If the text
        matches the regex, the text is said to have passed validation.  If the
        text does not match with the regex then the text fails validation.
        
        \return
        - true if the current Editbox text passes validation.
        - false if the text does not pass validation.
        */
        public function isTextValid():Boolean
        {
            return isStringValid(getText());
        }
        
        /*!
        \brief
        return the currently set validation string
        
        \note
        Validation is performed by means of a regular expression.  If the text
        matches the regex, the text is said to have passed validation.  If the
        text does not match with the regex then the text fails validation.
        
        \return
        String object containing the current validation regex data
        */
        public function getValidationString():String
        {
            return d_validationString;
        }
        
        /*!
        \brief
        return the current position of the carat.
        
        \return
        Index of the insert carat relative to the start of the text.
        */
        public function getCaratIndex():uint
        {
            //do not support bidi
            return d_caratPos;
        }
        
        /*!
        \brief
        return the current selection start point.
        
        \return
        Index of the selection start point relative to the start of the text.
        If no selection is defined this function returns the position of the
        carat.
        */
        public function getSelectionStartIndex():uint
        {
            return (d_selectionStart != d_selectionEnd) ? d_selectionStart : d_caratPos;
        }
        
        /*!
        \brief
        return the current selection end point.
        
        \return
        Index of the selection end point relative to the start of the text.  If
        no selection is defined this function returns the position of the carat.
        */
        public function getSelectionEndIndex():uint
        {
            return (d_selectionStart != d_selectionEnd) ? d_selectionEnd : d_caratPos;
        }
        
        /*!
        \brief
        return the length of the current selection (in code points /
        characters).
        
        \return
        Number of code points (or characters) contained within the currently
        defined selection.
        */
        public function getSelectionLength():uint
        {
            return d_selectionEnd - d_selectionStart;
        }
        
        /*!
        \brief
        return the utf32 code point used when rendering masked text.
        
        \return
        utf32 code point value representing the Unicode code point that will be
        rendered instead of the Editbox text when rendering in masked mode.
        */
        public function getMaskCodePoint():uint
        {
            //to do, a charcode
            return d_maskCodePoint;
        }
        
        /*!
        \brief
        return the maximum text length set for this Editbox.
        
        \return
        The maximum number of code points (characters) that can be entered into
        this Editbox.
        
        \note
        Depending on the validation string set, the actual length of text that
        can be entered may be less than the value returned here
        (it will never be more).
        */
        public function getMaxTextLength():uint
        {
            return d_maxTextLen;
        }
        
        /*!
        \brief
        Specify whether the Editbox is read-only.
        
        \param setting
        true if the Editbox is read only and can't be edited by the user, false
        if the Editbox is not read only and may be edited by the user.
        
        \return
        Nothing.
        */
        public function setReadOnly(setting:Boolean):void
        {
            // if setting is changed
            if (d_readOnly != setting)
            {
                d_readOnly = setting;
                var args:WindowEventArgs = new WindowEventArgs(this);
                onReadOnlyChanged(args);
            }
 
        }
        
        /*!
        \brief
        Specify whether the text for the Editbox will be rendered masked.
        
        \param setting
        - true if the Editbox text should be rendered masked using the currently
        set mask code point.
        - false if the Editbox text should be rendered as ordinary text.
        
        \return
        Nothing.
        */
        public function setTextMasked(setting:Boolean):void
        {
            // if setting is changed
            if (d_maskText != setting)
            {
                d_maskText = setting;
                var args:WindowEventArgs = new WindowEventArgs(this);
                onMaskedRenderingModeChanged(args);
            }
        }
        
        /*!
        \brief
        Set the text validation string.
        
        \note
        Validation is performed by means of a regular expression.  If the text
        matches the regex, the text is said to have passed validation.  If the
        text does not match with the regex then the text fails validation.
        
        \param validation_string
        String object containing the validation regex data to be used.
        
        \return
        Nothing.
        */
        public function setValidationString(str:String):void
        {
            d_validationString = str;
            d_validator.setRegexString(str);
            
            // notification
            var args:WindowEventArgs = new WindowEventArgs(this);
            onValidationStringChanged(args);
            
            // also notify if text is now invalid.
            if (!isTextValid())
            {
                args.handled = 0;
                onTextInvalidatedEvent(args);
            }
        }
        
        /*!
        \brief
        Set the current position of the carat.
        
        \param carat_pos
        New index for the insert carat relative to the start of the text.  If
        the value specified is greater than the number of characters in the
        Editbox, the carat is positioned at the end of the text.
        
        \return
        Nothing.
        */
        public function setCaratIndex(carat_pos:uint):void
        {
            // make sure new position is valid
            if (carat_pos > getText().length)
                carat_pos = getText().length;
            
            // if new position is different
            if (d_caratPos != carat_pos)
            {
                d_caratPos = carat_pos;
                
                // Trigger "carat moved" event
                var args:WindowEventArgs = new WindowEventArgs(this);
                onCaratMoved(args);
            }
        }
        
        /*!
        \brief
        Define the current selection for the Editbox
        
        \param start_pos
        Index of the starting point for the selection.  If this value is greater
        than the number of characters in the Editbox, the selection start will
        be set to the end of the text.
        
        \param end_pos
        Index of the ending point for the selection.  If this value is greater
        than the number of characters in the Editbox, the selection end will be
        set to the end of the text.
        
        \return
        Nothing.
        */
        public function setSelection(start_pos:uint, end_pos:uint):void
        {
            // ensure selection start point is within the valid range
            if (start_pos > getText().length)
                start_pos = getText().length;
            
            // ensure selection end point is within the valid range
            if (end_pos > getText().length)
                end_pos = getText().length;
            
            // ensure start is before end
            if (start_pos > end_pos)
            {
                var tmp:uint = end_pos;
                end_pos = start_pos;
                start_pos = tmp;
            }
            
            // only change state if values are different.
            if ((start_pos != d_selectionStart) || (end_pos != d_selectionEnd))
            {
                // setup selection
                d_selectionStart = start_pos;
                d_selectionEnd  = end_pos;
                
                // Trigger "selection changed" event
                var args:WindowEventArgs = new WindowEventArgs(this);
                onTextSelectionChanged(args);
            }
        }
        
        /*!
        \brief
        set the utf32 code point used when rendering masked text.
        
        \param code_point
        utf32 code point value representing the Unicode code point that should
        be rendered instead of the Editbox text when rendering in masked mode.
        
        \return
        Nothing.
        */
        public function setMaskCodePoint(code_point:uint):void
        {
            if (code_point != d_maskCodePoint)
            {
                d_maskCodePoint = code_point;
                
                // Trigger "mask code point changed" event
                var args:WindowEventArgs = new WindowEventArgs(this);
                onMaskCodePointChanged(args);
            }
        }
        
        /*!
        \brief
        set the maximum text length for this Editbox.
        
        \param max_len
        The maximum number of code points (characters) that can be entered into
        this Editbox.
        
        \note
        Depending on the validation string set, the actual length of text that
        can be entered may be less than the value set here
        (it will never be more).
        
        \return
        Nothing.
        */
        public function setMaxTextLength(max_len:uint):void
        {
            if (d_maxTextLen != max_len)
            {
                d_maxTextLen = max_len;
                
                // Trigger max length changed event
                var args:WindowEventArgs = new WindowEventArgs(this);
                onMaximumTextLengthChanged(args);
                
                // trim string
                if (getText().length > d_maxTextLen)
                {
                    var newText:String = getText();
                    //newText.resize(d_maxTextLen);
                    setText(newText);
                    onTextChanged(args);
                    
                    // see if new text is valid
                    if (!isTextValid())
                    {
                        // Trigger Text is invalid event.
                        onTextInvalidatedEvent(args);
                    }
                    
                }
                
            }
        }
        
        /*!
        \brief
        Return the text code point index that is rendered closest to screen
        position \a pt.
        
        \param pt
        Point object describing a position on the screen in pixels.
        
        \return
        Code point index into the text that is rendered closest to screen
        position \a pt.
        */
        protected function getTextIndexFromPosition(pt:Vector2):uint
        {
            if (d_windowRenderer != null)
            {
                var wr:EditboxWindowRenderer = d_windowRenderer as EditboxWindowRenderer;
                return wr.getTextIndexFromPosition(pt);
            }
            else
            {
                throw new Error("Editbox::getTextIndexFromPosition: " +
                    "This function must be implemented by the window renderer");
            }
        }
        
        //! Clear the currently defined selection (just the region, not the text).
        protected function clearSelection():void
        {
            // perform action only if required.
            if (getSelectionLength() != 0)
                setSelection(0, 0);
        }
        
        /*!
        \brief
        Erase the currently selected text.
        
        \param modify_text
        when true, the actual text will be modified.  When false, everything is
        done except erasing the characters.
        */
        protected function eraseSelectedText(modify_text:Boolean = true):void
        {
            if (getSelectionLength() != 0)
            {
                // setup new carat position and remove selection highlight.
                setCaratIndex(d_selectionStart);
                clearSelection();
                
                // erase the selected characters (if required)
                if (modify_text)
                {
                    var newText:String = getText();
                    //newText.erase(getSelectionStartIndex(), getSelectionLength());
                    setText(newText);
                    
                    // trigger notification that text has changed.
                    var args:WindowEventArgs = new WindowEventArgs(this);
                    onTextChanged(args);
                }
                
            }
        }
        
        /*!
        \brief
        return true if the given string matches the validation regular
        expression.
        */
        protected function isStringValid(str:String):Boolean
        {
            return d_validator ? d_validator.matchRegex(str) : true;
        }
        
        //! Processing for backspace key
        protected function handleBackspace():void
        {
            if (!isReadOnly())
            {
                var orig:String = getText();
                var tmp:String;
                
                if (getSelectionLength() != 0)
                {
                    tmp = orig.substring(0, getSelectionStartIndex()) + orig.substring(getSelectionEndIndex());
                    
                    if (isStringValid(tmp))
                    {
                        // erase selection using mode that does not modify getText()
                        // (we just want to update state)
                        eraseSelectedText(false);
                        
                        // set text to the newly modified string
                        setText(tmp);
                    }
                    else
                    {
                        // Trigger invalid modification attempted event.
                        var args:WindowEventArgs = new WindowEventArgs(this);
                        onInvalidEntryAttempted(args);
                    }
                    
                }
                else if (getCaratIndex() > 0)
                {
                    tmp = orig.substring(0, d_caratPos-1) + orig.substring(d_caratPos);
                    
                    if (isStringValid(tmp))
                    {
                        setCaratIndex(d_caratPos - 1);
                        
                        // set text to the newly modified string
                        setText(tmp);
                    }
                    else
                    {
                        // Trigger invalid modification attempted event.
                        args = new WindowEventArgs(this);
                        onInvalidEntryAttempted(args);
                    }
                    
                }
                
            }
        }
        
        //! Processing for Delete key
        protected function handleDelete():void
        {
            if (!isReadOnly())
            {
                var orig:String = getText();
                var tmp:String;
                
                if (getSelectionLength() != 0)
                {
                    tmp = orig.substring(0, getSelectionStartIndex()) + orig.substring(getSelectionEndIndex());
                    
                    if (isStringValid(tmp))
                    {
                        // erase selection using mode that does not modify getText()
                        // (we just want to update state)
                        eraseSelectedText(false);
                        
                        // set text to the newly modified string
                        setText(tmp);
                    }
                    else
                    {
                        // Trigger invalid modification attempted event.
                        var args:WindowEventArgs = new WindowEventArgs(this);
                        onInvalidEntryAttempted(args);
                    }
                    
                }
                else if (getCaratIndex() < orig.length)
                {
                    tmp = orig.substring(0, d_caratPos) + orig.substring(d_caratPos+1);
                    
                    if (isStringValid(tmp))
                    {
                        // set text to the newly modified string
                        setText(tmp);
                    }
                    else
                    {
                        // Trigger invalid modification attempted event.
                        args = new WindowEventArgs(this);
                        onInvalidEntryAttempted(args);
                    }
                    
                }
                
            }
        }
        
        //! Processing to move carat one character left
        protected function handleCharLeft(sysKeys:uint):void
        {
            if (d_caratPos > 0)
                setCaratIndex(d_caratPos - 1);
            
            if (sysKeys & Consts.SystemKey_Shift)
                setSelection(d_caratPos, d_dragAnchorIdx);
            else
                clearSelection();
        }
        
        //! Processing to move carat one word left
        protected function handleWordLeft(sysKeys:uint):void
        {
            if (d_caratPos > 0)
                setCaratIndex(TextUtils.getWordStartIdx(getText(), d_caratPos));
            
            if (sysKeys & Consts.SystemKey_Shift)
                setSelection(d_caratPos, d_dragAnchorIdx);
            else
                clearSelection();
        }
        
        //! Processing to move carat one character right
        protected function handleCharRight(sysKeys:uint):void
        {
            if (d_caratPos < getText().length)
                setCaratIndex(d_caratPos + 1);
            
            if (sysKeys & Consts.SystemKey_Shift)
                setSelection(d_caratPos, d_dragAnchorIdx);
            else
                clearSelection();
        }
        
        //! Processing to move carat one word right
        protected function handleWordRight(sysKeys:uint):void
        {
            if (d_caratPos < getText().length)
                setCaratIndex(TextUtils.getNextWordStartIdx(getText(), d_caratPos));
            
            if (sysKeys & Consts.SystemKey_Shift)
                setSelection(d_caratPos, d_dragAnchorIdx);
            else
                clearSelection();
        }
        
        //! Processing to move carat to the start of the text.
        protected function handleHome(sysKeys:uint):void
        {
            if (d_caratPos > 0)
                setCaratIndex(0);
            
            if (sysKeys & Consts.SystemKey_Shift)
                setSelection(d_caratPos, d_dragAnchorIdx);
            else
                clearSelection();
        }
        
        //! Processing to move carat to the end of the text
        protected function handleEnd(sysKeys:uint):void
        {
            if (d_caratPos < getText().length)
                setCaratIndex(getText().length);
            
            if (sysKeys & Consts.SystemKey_Shift)
                setSelection(d_caratPos, d_dragAnchorIdx);
            else
                clearSelection();
        }
        
        /*!
        \brief
        Return whether this window was inherited from the given class name at
        some point in the inheritance hierarchy.
        
        \param class_name
        The class name that is to be checked.
        
        \return
        - true if this window was inherited from \a class_name.
        - false if not.
        */
        override protected function testClassName_impl(class_name:String):Boolean
        {
            if (class_name=="Editbox")	return true;
            return super.testClassName_impl(class_name);
        }
        
        //! validate window renderer
        protected function validateWindowRenderer(name:String):Boolean
        {
            return (name == "Editbox");
        }
        
        /*!
        \brief
        Handler called when the read only state of the Editbox has been changed.
        */
        protected function onReadOnlyChanged(e:WindowEventArgs):void
        {
            invalidate();
            fireEvent(EventReadOnlyModeChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the masked rendering mode (password mode) has been
        changed.
        */
        protected function onMaskedRenderingModeChanged(e:WindowEventArgs):void
        {
            invalidate();
            fireEvent(EventMaskedRenderingModeChanged , e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the code point to use for masked rendering has been
        changed.
        */
        protected function onMaskCodePointChanged(e:WindowEventArgs):void
        {
            // if we are in masked mode, trigger a GUI redraw.
            if (isTextMasked())
                invalidate();
            
            fireEvent(EventMaskCodePointChanged , e, EventNamespace);
        }
        
        /*!
        \brief
        Event fired internally when the validation string is changed.
        */
        protected function onValidationStringChanged(e:WindowEventArgs):void
        {
            fireEvent(EventValidationStringChanged , e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the maximum text length for the edit box is changed.
        */
        protected function onMaximumTextLengthChanged(e:WindowEventArgs):void
        {
            fireEvent(EventMaximumTextLengthChanged , e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when something has caused the current text to now fail
        validation.
        
        This can be caused by changing the validation string or setting a
        maximum length that causes the current text to be truncated.
        */
        protected function onTextInvalidatedEvent(e:WindowEventArgs):void
        {
            fireEvent(EventTextInvalidated, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the user attempted to make a change to the edit box
        that would have caused it to fail validation.
        */
        protected function onInvalidEntryAttempted(e:WindowEventArgs):void
        {
            fireEvent(EventInvalidEntryAttempted , e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the carat (insert point) position changes.
        */
        protected function onCaratMoved(e:WindowEventArgs):void
        {
            invalidate();
            fireEvent(EventCaratMoved , e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the current text selection changes.
        */
        protected function onTextSelectionChanged(e:WindowEventArgs):void
        {
            invalidate();
            fireEvent(EventTextSelectionChanged , e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the edit box text has reached the set maximum
        length.
        */
        protected function onEditboxFullEvent(e:WindowEventArgs):void
        {
            fireEvent(EventEditboxFull, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the user accepts the edit box text by pressing
        Return, Enter, or Tab.
        */
        protected function onTextAcceptedEvent(e:WindowEventArgs):void
        {
            fireEvent(EventTextAccepted, e, EventNamespace);
        }
        
        // Overridden event handlers
        override public function onMouseButtonDown(e:MouseEventArgs):void
        {
            // base class handling
            super.onMouseButtonDown(e);
            
            if (e.button == Consts.MouseButton_LeftButton)
            {
                // grab inputs
                if (captureInput())
                {
                    // handle mouse down
                    clearSelection();
                    d_dragging = true;
                    d_dragAnchorIdx = getTextIndexFromPosition(e.position);
                    setCaratIndex(d_dragAnchorIdx);
                    
                    //move the input textfield below the editbox
                    var pos:Vector2 = getUnclippedOuterRect().getPosition();
                    FlameEventManager.getSingleton().moveIMEWindowTo(pos.d_x, pos.d_y);
                    FlameEventManager.getSingleton().enableInput(true);
                }
                
                ++e.handled;
            }
        }
        
        override public function onMouseButtonUp(e:MouseEventArgs):void
        {
            // base class processing
            super.onMouseButtonUp(e);
            
            if (e.button == Consts.MouseButton_LeftButton)
            {
                releaseInput();
                ++e.handled;
            }
        }
        
        override public function onMouseDoubleClicked(e:MouseEventArgs):void
        {
            // base class processing
            super.onMouseDoubleClicked(e);
            
            if (e.button == Consts.MouseButton_LeftButton)
            {
                // if masked, set up to select all
                if (isTextMasked())
                {
                    d_dragAnchorIdx = 0;
                    setCaratIndex(getText().length);
                }
                    // not masked, so select the word that was double-clicked.
                else
                {
                    d_dragAnchorIdx = TextUtils.getWordStartIdx(getText(),
                        (d_caratPos == getText().length) ? d_caratPos :
                        d_caratPos + 1);
                    d_caratPos = TextUtils::getNextWordStartIdx(getText(), d_caratPos);
                }
                
                // perform actual selection operation.
                setSelection(d_dragAnchorIdx, d_caratPos);
                
                ++e.handled;
            }
        }
        override public function onMouseTripleClicked(e:MouseEventArgs):void
        {
            // base class processing
            super.onMouseTripleClicked(e);
            
            if (e.button == Consts.MouseButton_LeftButton)
            {
                d_dragAnchorIdx = 0;
                setCaratIndex(getText().length);
                setSelection(d_dragAnchorIdx, d_caratPos);
                ++e.handled;
            }
        }
        
        override public function onMouseMove(e:MouseEventArgs):void
        {
            // base class processing
            super.onMouseMove(e);
            
            if (d_dragging)
            {
                var anchorIdx:uint = getTextIndexFromPosition(e.position);
                setCaratIndex(anchorIdx);
                
                setSelection(d_caratPos, d_dragAnchorIdx);
            }
            
            ++e.handled;
        }
        
        override protected function onCaptureLost(e:WindowEventArgs):void
        {
            d_dragging = false;
            
            // base class processing
            super.onCaptureLost(e);
            
            ++e.handled;
        }
        
        override public function onCharacter(e:KeyEventArgs):void
        {
            // NB: We are not calling the base class handler here because it propogates
            // inputs back up the window hierarchy, whereas, as a consumer of key
            // events, we want such propogation to cease with us regardless of whether
            // we actually handle the event.
            
            // fire event.
            fireEvent(EventCharacterKey, e, FlameWindow.EventNamespace);
            
            // only need to take notice if we have focus
            if (e.handled == 0 && hasInputFocus() && !isReadOnly() &&
                //check codepoint available, and create charcode if not exist, so it always return true
                getFont().isCodepointAvailableOnInput(e.codepoint))
            {
                // backup current text
                var tmp:String = TextUtils.erase(getText(), getSelectionStartIndex(), getSelectionLength());
                
                // if there is room
                if (tmp.length < d_maxTextLen)
                {
                    tmp = TextUtils.insertCharcode(tmp, getSelectionStartIndex(), e.codepoint);
                    
                    if (isStringValid(tmp))
                    {
                        // erase selection using mode that does not modify getText()
                        // (we just want to update state)
                        eraseSelectedText(false);
                        
                        // advance carat (done first so we can "do stuff" in event
                        // handlers!)
                        d_caratPos++;
                        
                        // set text to the newly modified string
                        setText(tmp);
                        
                        // char was accepted into the Editbox - mark event as handled.
                        ++e.handled;
                    }
                    else
                    {
                        // Trigger invalid modification attempted event.
                        var args:WindowEventArgs = new WindowEventArgs(this);
                        onInvalidEntryAttempted(args);
                    }
                    
                }
                else
                {
                    // Trigger text box full event
                    var args2:WindowEventArgs = new WindowEventArgs(this);
                    onEditboxFullEvent(args2);
                }
                
            }
            
            // event was (possibly) not handled
        }

        override public function onKeyDown(e:KeyEventArgs):void
        {
            // NB: We are not calling the base class handler here because it propogates
            // inputs back up the window hierarchy, whereas, as a consumer of key
            // events, we want such propogation to cease with us regardless of whether
            // we actually handle the event.
            
            // fire event.
            fireEvent(EventKeyDown, e, FlameWindow.EventNamespace);
            
            if (e.handled == 0 && hasInputFocus() && !isReadOnly())
            {
                var args:WindowEventArgs = new WindowEventArgs(this);
                switch (e.scancode)
                {
                    case Consts.Key_LeftShift:
                    case Consts.Key_RightShift:
                        if (getSelectionLength() == 0)
                            d_dragAnchorIdx = d_caratPos;
                        break;
                    
                    case Consts.Key_Backspace:
                        handleBackspace();
                        break;
                    
                    case Consts.Key_Delete:
                        handleDelete();
                        break;
                    
                    case Consts.Key_Tab:
                    case Consts.Key_Return:
                    case Consts.Key_NumpadEnter:
                        // Fire 'input accepted' event
                        onTextAcceptedEvent(args);
                        break;
                    
                    case Consts.Key_ArrowLeft:
                        if (e.sysKeys & Consts.SystemKey_Control)
                            handleWordLeft(e.sysKeys);
                        else
                            handleCharLeft(e.sysKeys);
                        break;
                    
                    case Consts.Key_ArrowRight:
                        if (e.sysKeys & Consts.SystemKey_Control)
                            handleWordRight(e.sysKeys);
                        else
                            handleCharRight(e.sysKeys);
                        break;
                    
                    case Consts.Key_Home:
                        handleHome(e.sysKeys);
                        break;
                    
                    case Consts.Key_End:
                        handleEnd(e.sysKeys);
                        break;
                    
                    // default case is now to leave event as (possibly) unhandled.
                    default:
                        return;
                }
                
                ++e.handled;
            }
        }
        
        override protected function onTextChanged(e:WindowEventArgs):void
        {
            // base class processing
            super.onTextChanged(e);
            
            // clear selection
            clearSelection();
            
            // make sure carat is within the text
            if (d_caratPos > getText().length)
                setCaratIndex(getText().length);
            
            ++e.handled;
        }
    
        
        
        
        
        private function addEditboxProperties():void
        {
            addProperty(d_readOnlyProperty);
            addProperty(d_maskTextProperty);
            addProperty(d_maskCodepointProperty);
            addProperty(d_validationStringProperty);
            addProperty(d_caratIndexProperty);
            addProperty(d_selectionStartProperty);
            addProperty(d_selectionLengthProperty);
            addProperty(d_maxTextLengthProperty);
        }
        
        
        
    }
}