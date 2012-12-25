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
    import Flame2D.core.data.MLineInfo;
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.events.KeyEventArgs;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.system.FlameEventManager;
    import Flame2D.core.system.FlameFont;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.CoordConverter;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.TextUtils;
    import Flame2D.core.utils.Vector2;
    import Flame2D.elements.base.FlameScrollbar;
    
    public class FlameMultiLineEditbox extends FlameWindow
    {
        public static const EventNamespace:String = "MultiLineEditbox";
        public static const WidgetTypeName:String = "CEGUI/MultiLineEditbox";
        
        /*************************************************************************
         Constants
         *************************************************************************/
        // event names
        /** Event fired when the read-only mode for the edit box has been changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the MultiLineEditbox whose read-only mode
         * was changed.
         */
        public static const EventReadOnlyModeChanged:String = "ReadOnlyChanged";
        /** Event fired when the word wrap mode of the edit box has been changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the MultiLineEditbox whose word wrap
         * mode was changed.
         */
        public static const EventWordWrapModeChanged:String = "WordWrapModeChanged";
        /** Event fired when the maximum allowable string length for the edit box
         * has been changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the MultiLineEditbox whose maximum string
         * length was changed.
         */
        public static const EventMaximumTextLengthChanged:String = "MaximumTextLengthChanged";
        /** Event fired when the text caret / current insertion position is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the MultiLineEditbox whose caret position
         * has changed.
         */
        public static const EventCaratMoved:String = "CaratMoved";
        /** Event fired when the current text selection for the edit box is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the MultiLineEditbox whose text selection
         * was changed.
         */
        public static const EventTextSelectionChanged:String = "TextSelectionChanged";
        /** Event fired when the number of characters in the edit box reaches the
         * current maximum length.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the MultiLineEditbox whose text length
         * has reached the set maximum allowable length for the edit box.
         */
        public static const EventEditboxFull:String = "EditboxFullEvent";
        /** Event fired when the mode setting that forces the display of the
         * vertical scroll bar for the edit box is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the MultiLineEditbox whose vertical
         * scrollbar mode has been changed.
         */
        public static const EventVertScrollbarModeChanged:String = "VertScrollbarModeChanged";
        /** Event fired when the mode setting that forces the display of the
         * horizontal scroll bar for the edit box is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the MultiLineEditbox whose horizontal
         * scrollbar mode has been changed.
         */
        public static const EventHorzScrollbarModeChanged:String = "HorzScrollbarModeChanged";
        
        /*************************************************************************
         Child Widget name suffix constants
         *************************************************************************/
        public static const VertScrollbarNameSuffix:String = "__auto_vscrollbar__";   //!< Widget name suffix for the vertical scrollbar component.
        public static const HorzScrollbarNameSuffix:String = "__auto_hscrollbar__";   //!< Widget name suffix for the horizontal scrollbar component.

        
        /*************************************************************************
         Static Properties for this class
         *************************************************************************/
        public static var d_readOnlyProperty:MultiLineEditboxPropertyReadOnly = new MultiLineEditboxPropertyReadOnly();
        public static var d_wordWrapProperty:MultiLineEditboxPropertyWordWrap = new MultiLineEditboxPropertyWordWrap();
        public static var d_caratIndexProperty:MultiLineEditboxPropertyCaratIndex = new MultiLineEditboxPropertyCaratIndex();
        public static var d_selectionStartProperty:MultiLineEditboxPropertySelectionStart = new MultiLineEditboxPropertySelectionStart();
        public static var d_selectionLengthProperty:MultiLineEditboxPropertySelectionLength = new MultiLineEditboxPropertySelectionLength();
        public static var d_maxTextLengthProperty:MultiLineEditboxPropertyMaxTextLength = new MultiLineEditboxPropertyMaxTextLength();
        public static var d_selectionBrushProperty:MultiLineEditboxPropertySelectionBrushImage = new MultiLineEditboxPropertySelectionBrushImage();
        public static var d_forceVertProperty:MultiLineEditboxPropertyForceVertScrollbar = new MultiLineEditboxPropertyForceVertScrollbar();

        protected static var d_lineBreakChars:String = "\n";	//!< Holds what we consider to be line break characters.
        
        /*************************************************************************
         Implementation data
         *************************************************************************/
        protected var d_readOnly:Boolean = false;			//!< true if the edit box is in read-only mode
        protected var d_maxTextLen:uint = uint.MAX_VALUE;		//!< Maximum number of characters for this Editbox.
        protected var d_caratPos:uint = 0;			//!< Position of the carat / insert-point.
        protected var d_selectionStart:uint = 0;	//!< Start of selection area.
        protected var d_selectionEnd:uint = 0;		//!< End of selection area.
        protected var d_dragging:Boolean = false;			//!< true when a selection is being dragged.
        protected var d_dragAnchorIdx:uint = 0;	//!< Selection index for drag selection anchor point.
        
        protected var d_wordWrap:Boolean = true;			//!< true when formatting uses word-wrapping.
        protected var d_lines:Vector.<MLineInfo> = new Vector.<MLineInfo>();			//!< Holds the lines for the current formatting.
        protected var d_widestExtent:Number = 0.0;		//!< Holds the extent of the widest line as calculated in the last formatting pass.
        
        // component widget settings
        protected var d_forceVertScroll:Boolean = false;		//!< true if vertical scrollbar should always be displayed
        protected var d_forceHorzScroll:Boolean = false;		//!< true if horizontal scrollbar should always be displayed
        
        // images
        protected var d_selectionBrush:FlameImage = null;	//!< Image to use as the selection brush (should be set by derived class).
        

        /*************************************************************************
         Construction and Destruction
         *************************************************************************/
        /*!
        \brief
        Constructor for the MultiLineEditbox base class.
        */
        public function FlameMultiLineEditbox(type:String, name:String)
        {
            super(type, name);
            
            addMultiLineEditboxProperties();
            
            // override default and disable text parsing
            d_textParsingEnabled = false;
        }
        
        
        
        /*************************************************************************
         Accessor Functions
         *************************************************************************/
        /*!
        \brief
        return true if the edit box has input focus.
        
        \return
        - true if the edit box has keyboard input focus.
        - false if the edit box does not have keyboard input focus.
        */
        public function hasInputFocus():Boolean
        {
            return isActive();
        }
        
        
        /*!
        \brief
        return true if the edit box is read-only.
        
        \return
        - true if the edit box is read only and can't be edited by the user.
        - false if the edit box is not read only and may be edited by the user.
        */
        public function isReadOnly():Boolean
        {
            return d_readOnly;
        }
        
        
        /*!
        \brief
        return the current position of the carat.
        
        \return
        Index of the insert carat relative to the start of the text.
        */
        public function getCaratIndex():uint
        {
            return d_caratPos;
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
            return (d_selectionStart != d_selectionEnd) ? d_selectionStart : d_caratPos;
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
            return (d_selectionStart != d_selectionEnd) ? d_selectionEnd : d_caratPos;
        }
        
        
        /*!
        \brief
        return the length of the current selection (in code points / characters).
        
        \return
        Number of code points (or characters) contained within the currently defined selection.
        */
        public function getSelectionLength():uint
        {
            return d_selectionEnd - d_selectionStart;
        }
        
        
        /*!
        \brief
        return the maximum text length set for this edit box.
        
        \return
        The maximum number of code points (characters) that can be entered into this edit box.
        */
        public function getMaxTextLength():uint
        {
            return d_maxTextLen;
        }
        
        
        /*!
        \brief
        Return whether the text in the edit box will be word-wrapped.
        
        \return
        - true if the text will be word-wrapped at the edges of the widget frame.
        - false if text will not be word-wrapped (a scroll bar will be used to access long text lines).
        */
        public function isWordWrapped():Boolean
        {
            return d_wordWrap;
        }
        
        
        /*!
        \brief
        Return a pointer to the vertical scrollbar component widget for this
        MultiLineEditbox.
        
        \return
        Pointer to a Scrollbar object.
        
        \exception UnknownObjectException
        Thrown if the vertical Scrollbar component does not exist.
        */
        public function getVertScrollbar():FlameScrollbar
        {
            return FlameWindowManager.getSingleton().getWindow(
                getName() + VertScrollbarNameSuffix) as FlameScrollbar;
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
            return d_forceVertScroll;
        }
        
        /*!
        \brief
        Return a pointer to the horizontal scrollbar component widget for this
        MultiLineEditbox.
        
        \return
        Pointer to a Scrollbar object.
        
        \exception UnknownObjectException
        Thrown if the horizontal Scrollbar component does not exist.
        */
        public function getHorzScrollbar():FlameScrollbar
        {
            return FlameWindowManager.getSingleton().getWindow(
                getName() + HorzScrollbarNameSuffix) as FlameScrollbar;
        }
        
        
        /*!
        \brief
        Return a Rect object describing, in un-clipped pixels, the window relative area
        that the text should be rendered in to.
        
        \return
        Rect object describing the area of the Window to be used for rendering text.
        */
        public function getTextRenderArea():Rect
        {
            if (d_windowRenderer != null)
            {
                var wr:MultiLineEditboxWindowRenderer = d_windowRenderer as MultiLineEditboxWindowRenderer;
                return wr.getTextRenderArea();
            }
            else
            {
                //return getTextRenderArea_impl();
                throw new Error("MultiLineEditbox::getTextRenderArea - This function must be implemented by the window renderer module");
            }
        }
        
        // get d_lines
        public function getFormattedLines():Vector.<MLineInfo>
        {
            return d_lines;
        }
        
        /*!
        \brief
        Return the line number a given index falls on with the current formatting.  Will return last line
        if index is out of range.
        */
        public function getLineNumberFromIndex(index:uint):uint
        {
            var lineCount:uint = d_lines.length;
            
            if (lineCount == 0)
            {
                return 0;
            }
            else if (index >= getText().length - 1)
            {
                return lineCount - 1;
            }
            else
            {
                var indexCount:uint = 0;
                var caratLine:uint = 0;
                
                for (; caratLine < lineCount; ++caratLine)
                {
                    indexCount += d_lines[caratLine].d_length;
                    
                    if (index < indexCount)
                    {
                        return caratLine;
                    }
                    
                }
                
            }
            
            throw new Error("MultiLineEditbox::getLineNumberFromIndex - Unable to identify a line from the given, invalid, index.");

        }
        
        /*************************************************************************
         Manipulators
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
            // create the component sub-widgets
            var vertScrollbar:FlameScrollbar = getVertScrollbar();
            var horzScrollbar:FlameScrollbar = getHorzScrollbar();
            
            vertScrollbar.subscribeEvent(FlameWindow.EventShown, new Subscriber(handle_vertScrollbarVisibilityChanged, this), FlameWindow.EventNamespace);
            
            vertScrollbar.subscribeEvent(FlameWindow.EventHidden, new Subscriber(handle_vertScrollbarVisibilityChanged, this), FlameWindow.EventNamespace);
            
            vertScrollbar.subscribeEvent(FlameScrollbar.EventScrollPositionChanged, new Subscriber(handle_scrollChange, this), FlameScrollbar.EventNamespace);
            horzScrollbar.subscribeEvent(FlameScrollbar.EventScrollPositionChanged, new Subscriber(handle_scrollChange, this), FlameScrollbar.EventNamespace);
            
            formatText(true);
            performChildWindowLayout();
        }
        
        
        /*!
        \brief
        Specify whether the edit box is read-only.
        
        \param setting
        - true if the edit box is read only and can't be edited by the user.
        - false if the edit box is not read only and may be edited by the user.
        
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
        Set the current position of the carat.
        
        \param carat_pos
        New index for the insert carat relative to the start of the text.  If the value specified is greater than the
        number of characters in the edit box, the carat is positioned at the end of the text.
        
        \return
        Nothing.
        */
        public function setCaratIndex(carat_pos:uint):void
        {
            // make sure new position is valid
            if (carat_pos > getText().length - 1)
            {
                carat_pos = getText().length - 1;
            }
            
            // if new position is different
            if (d_caratPos != carat_pos)
            {
                d_caratPos = carat_pos;
                ensureCaratIsVisible();
                
                // Trigger "carat moved" event
                var args:WindowEventArgs = new WindowEventArgs(this);
                onCaratMoved(args);
            }
        }
        
        
        /*!
        \brief
        Define the current selection for the edit box
        
        \param start_pos
        Index of the starting point for the selection.  If this value is greater than the number of characters in the edit box, the
        selection start will be set to the end of the text.
        
        \param end_pos
        Index of the ending point for the selection.  If this value is greater than the number of characters in the edit box, the
        selection start will be set to the end of the text.
        
        \return
        Nothing.
        */
        public function setSelection(start_pos:uint, end_pos:uint):void
        {
            // ensure selection start point is within the valid range
            if (start_pos > getText().length - 1)
            {
                start_pos = getText().length - 1;
            }
            
            // ensure selection end point is within the valid range
            if (end_pos > getText().length - 1)
            {
                end_pos = getText().length - 1;
            }
            
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
                d_selectionEnd	 = end_pos;
                
                // Trigger "selection changed" event
                var args:WindowEventArgs = new WindowEventArgs(this);
                onTextSelectionChanged(args);
            }
        }
        
        
        /*!
        \brief
        set the maximum text length for this edit box.
        
        \param max_len
        The maximum number of code points (characters) that can be entered into this Editbox.
        
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
                    var newText:String = getText().substr(0, d_maxTextLen);
                    //newText.resize(d_maxTextLen);
                    setText(newText);
                    
                    onTextChanged(args);
                }
                
            }
        }
        
        
        /*!
        \brief
        Scroll the view so that the current carat position is visible.
        */
        public function ensureCaratIsVisible():void
        {
            var vertScrollbar:FlameScrollbar = getVertScrollbar();
            var horzScrollbar:FlameScrollbar = getHorzScrollbar();
            
            // calculate the location of the carat
            var fnt:FlameFont = getFont();
            var caratLine:uint = getLineNumberFromIndex(d_caratPos);
            
            if (caratLine < d_lines.length)
            {
                var textArea:Rect = getTextRenderArea();
                
                var caratLineIdx:uint = d_caratPos - d_lines[caratLine].d_startIdx;
                
                var ypos:Number = caratLine * fnt.getLineSpacing();
                var xpos:Number = fnt.getTextExtent(getText().substr(d_lines[caratLine].d_startIdx, caratLineIdx));
                
                // adjust position for scroll bars
                xpos -= horzScrollbar.getScrollPosition();
                ypos -= vertScrollbar.getScrollPosition();
                
                // if carat is above window, scroll up
                if (ypos < 0)
                {
                    vertScrollbar.setScrollPosition(vertScrollbar.getScrollPosition() + ypos);
                }
                    // if carat is below the window, scroll down
                else if ((ypos += fnt.getLineSpacing()) > textArea.getHeight())
                {
                    vertScrollbar.setScrollPosition(vertScrollbar.getScrollPosition() + (ypos - textArea.getHeight()) + fnt.getLineSpacing());
                }
                
                // if carat is left of the window, scroll left
                if (xpos < 0)
                {
                    horzScrollbar.setScrollPosition(horzScrollbar.getScrollPosition() + xpos - 50);
                }
                    // if carat is right of the window, scroll right
                else if (xpos > textArea.getWidth())
                {
                    horzScrollbar.setScrollPosition(horzScrollbar.getScrollPosition() + (xpos - textArea.getWidth()) + 50);
                }
                
            }

        }
        
        
        /*!
        \brief
        Set whether the text will be word wrapped or not.
        
        \param setting
        - true if the text should word-wrap at the edges of the text box.
        - false if the text should not wrap, but a scroll bar should be used.
        
        \return
        Nothing.
        */
        public function setWordWrapping(setting:Boolean):void
        {
            if (setting != d_wordWrap)
            {
                d_wordWrap = setting;
                formatText(true);
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onWordWrapModeChanged(args);
            }

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
            if (d_forceVertScroll != setting)
            {
                d_forceVertScroll = setting;
                
                configureScrollbars();
                var args:WindowEventArgs = new WindowEventArgs(this);
                onVertScrollbarModeChanged(args);
            }
        }
            
        
        // selection brush image property support
        public function setSelectionBrushImage(image:FlameImage):void
        {
            d_selectionBrush = image;
            invalidate();
        }
        
        public function getSelectionBrushImage():FlameImage
        {
            return d_selectionBrush;
        }
        

        /*************************************************************************
         Implementation Methods (abstract)
         *************************************************************************/
        /*!
        \brief
        Return a Rect object describing, in un-clipped pixels, the window relative area
        that the text should be rendered in to.
        
        \return
        Rect object describing the area of the Window to be used for rendering text.
        */
        //virtual	Rect	getTextRenderArea_impl(void) const		= 0;
        
        
        /*************************************************************************
         Implementation Methods
         *************************************************************************/
        /*!
        \brief
        Format the text into lines as needed by the current formatting options.
        \deprecated
        This is deprecated in favour of the version taking a boolean.
        */
        protected function formatText(update_scrollbars:Boolean = true):void
        {
            // TODO: ASSAF - todo
            // clear old formatting data
            d_lines.length = 0;
            d_widestExtent = 0.0;
            
            var paraText:String;
            
            var fnt:FlameFont = getFont();
            
            if (fnt)
            {
                var areaWidth:Number = getTextRenderArea().getWidth();
                
                var currPos:uint = 0;
                var paraLen:uint = 0;
                var	line:MLineInfo;
                
                while (currPos < getText().length)
                {
                    paraLen = TextUtils.find_first_of(getText(), d_lineBreakChars, currPos);
                    if (paraLen == -1)
                    {
                        paraLen = getText().length - currPos;
                    }
                    else
                    {
                        ++paraLen;
                        paraLen-= currPos;
                    }
                    
                    paraText = getText().substr(currPos, paraLen);
                    
                    if (!d_wordWrap || (areaWidth <= 0.0))
                    {
                        // no word wrapping, so we are just one long line.
                        line = new MLineInfo();
                        line.d_startIdx = currPos;
                        line.d_length	= paraLen;
                        line.d_extent	= fnt.getTextExtent(paraText);
                        d_lines.push(line);
                        
                        // update widest, if needed.
                        if (line.d_extent > d_widestExtent)
                        {
                            d_widestExtent = line.d_extent;
                        }
                        
                    }
                    // must word-wrap the paragraph text
                    else
                    {
                        var lineIndex:uint = 0;
                        
                        // while there is text in the string
                        while (lineIndex < paraLen)
                        {
                            var lineLen:uint = 0;
                            var lineExtent:Number = 0.0;
                            
                            // loop while we have not reached the end of the paragraph string
                            while (lineLen < (paraLen - lineIndex))
                            {
                                // get cp / char count of next token
                                var nextTokenSize:uint = getNextTokenLength(paraText, lineIndex + lineLen);
                                
                                // get pixel width of the token
                                var tokenExtent:Number  = fnt.getTextExtent(paraText.substr(lineIndex + lineLen, nextTokenSize));
                                
                                // would adding this token would overflow the available width
                                if ((lineExtent + tokenExtent) > areaWidth)
                                {
                                    // Was this the first token?
                                    if (lineLen == 0)
                                    {
                                        // get point at which to break the token
                                        lineLen = fnt.getCharAtPixelAtBegining(paraText.substr(lineIndex, nextTokenSize), areaWidth);
                                    }
                                    
                                    // text wraps, exit loop early with line info up until wrap point
                                    break;
                                }
                                
                                // add this token to current line
                                lineLen    += nextTokenSize;
                                lineExtent += tokenExtent;
                            }
                            
                            // set up line info and add to collection
                            line = new MLineInfo()
                            line.d_startIdx = currPos + lineIndex;
                            line.d_length	= lineLen;
                            line.d_extent	= lineExtent;
                            d_lines.push(line);
                            
                            // update widest, if needed.
                            if (lineExtent > d_widestExtent)
                            {
                                d_widestExtent = lineExtent;
                            }
                            
                            // update position in string
                            lineIndex += lineLen;
                        }
                        
                    }
                    
                    // skip to next 'paragraph' in text
                    currPos += paraLen;
                }
                
            }
            
            if (update_scrollbars)
                configureScrollbars();
            
            invalidate();
        }
        
        /*!
        \brief
        Return the length of the next token in String \a text starting at index \a start_idx.
        
        \note
        Any single whitespace character is one token, any group of other characters is a token.
        
        \return
        The code point length of the token.
        */
        protected function getNextTokenLength(text:String, start_idx:uint) : uint
        {
            var pos:int = TextUtils.find_first_of(text, TextUtils.DefaultWrapDelimiters, start_idx);
            
            // handle case where no more whitespace exists (so this is last token)
            if (pos == -1)
            {
                return (text.length - start_idx);
            }
                // handle 'delimiter' token cases
            else if ((pos - start_idx) == 0)
            {
                return 1;
            }
            else
            {
                return (pos - start_idx);
            }
        }
        
        
        /*!
        \brief
        display required integrated scroll bars according to current state of the edit box and update their values.
        */
        protected function configureScrollbars():void
        {
            const vertScrollbar:FlameScrollbar = getVertScrollbar();
            const horzScrollbar:FlameScrollbar = getHorzScrollbar();
            const lspc:Number = getFont().getLineSpacing();
            
            //
            // First show or hide the scroll bars as needed (or requested)
            //
            // show or hide vertical scroll bar as required (or as specified by option)
            if (d_forceVertScroll ||
                (Number(d_lines.length) * lspc > getTextRenderArea().getHeight()))
            {
                vertScrollbar.show();
                
                // show or hide horizontal scroll bar as required (or as specified by option)
                horzScrollbar.setVisible(d_forceHorzScroll ||
                    (d_widestExtent > getTextRenderArea().getWidth()));
            }
                // show or hide horizontal scroll bar as required (or as specified by option)
            else if (d_forceHorzScroll ||
                (d_widestExtent > getTextRenderArea().getWidth()))
            {
                horzScrollbar.show();
                
                // show or hide vertical scroll bar as required (or as specified by option)
                vertScrollbar.setVisible(d_forceVertScroll ||
                    (Number(d_lines.length) * lspc > getTextRenderArea().getHeight()));
            }
            else
            {
                vertScrollbar.hide();
                horzScrollbar.hide();
            }
            
            //
            // Set up scroll bar values
            //
            var renderArea:Rect = getTextRenderArea();
            
            vertScrollbar.setDocumentSize(Number(d_lines.length) * lspc);
            vertScrollbar.setPageSize(renderArea.getHeight());
            vertScrollbar.setStepSize(Math.max(1.0, renderArea.getHeight() / 10.0));
            vertScrollbar.setScrollPosition(vertScrollbar.getScrollPosition());
            
            horzScrollbar.setDocumentSize(d_widestExtent);
            horzScrollbar.setPageSize(renderArea.getWidth());
            horzScrollbar.setStepSize(Math.max(1.0, renderArea.getWidth() / 10.0));
            horzScrollbar.setScrollPosition(horzScrollbar.getScrollPosition());
        }
        
        
        /*!
        \brief
        Return the text code point index that is rendered closest to screen position \a pt.
        
        \param pt
        Point object describing a position on the screen in pixels.
        
        \return
        Code point index into the text that is rendered closest to screen position \a pt.
        */
        protected function getTextIndexFromPosition(pt:Vector2) : uint
        {
            //
            // calculate final window position to be checked
            //
            var wndPt:Vector2 = CoordConverter.screenToWindowForVector2(this, pt);
            
            var textArea:Rect = getTextRenderArea();
            
            wndPt.d_x -= textArea.d_left;
            wndPt.d_y -= textArea.d_top;
            
            // factor in scroll bar values
            wndPt.d_x += getHorzScrollbar().getScrollPosition();
            wndPt.d_y += getVertScrollbar().getScrollPosition();
            
            var lineNumber:uint = (uint)(wndPt.d_y / getFont().getLineSpacing());
            
            if (lineNumber >= d_lines.length)
            {
                lineNumber = d_lines.length - 1;
            }
            
            var lineText:String = getText().substr(d_lines[lineNumber].d_startIdx, d_lines[lineNumber].d_length);
            
            var lineIdx:uint = getFont().getCharAtPixelAtBegining(lineText, wndPt.d_x);
            
            if (lineIdx >= lineText.length - 1)
            {
                lineIdx = lineText.length - 1;
            }
            
            return d_lines[lineNumber].d_startIdx + lineIdx;
        }
        
        
        /*!
        \brief
        Clear the current selection setting
        */
        protected function clearSelection():void
        {
            // perform action only if required.
            if (getSelectionLength() != 0)
            {
                setSelection(0, 0);
            }
        }
        
        
        /*!
        \brief
        Erase the currently selected text.
        
        \param modify_text
        when true, the actual text will be modified.  When false, everything is done except erasing the characters.
        */
        protected function eraseSelectedText(modify_text:Boolean = true):void
        {
            if (getSelectionLength() != 0)
            {
                // setup new carat position and remove selection highlight.
                setCaratIndex(getSelectionStartIndex());
                
                // erase the selected characters (if required)
                if (modify_text)
                {
                    var newText0:String = getText();
                    //newText.erase(getSelectionStartIndex(), getSelectionLength());
                    var newText:String = newText0.slice(0, getSelectionStartIndex())
                        + newText0.slice(getSelectionStartIndex() + getSelectionLength());
                    setText(newText);
                    
                    // trigger notification that text has changed.
                    var args:WindowEventArgs = new WindowEventArgs(this);
                    onTextChanged(args);
                }
                
                clearSelection();
            }
        }
        
        
        /*!
        \brief
        Processing for backspace key
        */
        protected function handleBackspace():void
        {
            if (!isReadOnly())
            {
                if (getSelectionLength() != 0)
                {
                    eraseSelectedText();
                }
                else if (d_caratPos > 0)
                {
                    var newText0:String = getText();
                    var newText:String = newText0.slice(0, d_caratPos-1) + newText0.slice(d_caratPos);
                    setCaratIndex(d_caratPos - 1);
                    setText(newText);
                    
                    var args:WindowEventArgs = new WindowEventArgs(this);
                    onTextChanged(args);
                }
                
            }
        }
        
        
        /*!
        \brief
        Processing for Delete key
        */
        public function handleDelete():void
        {
            if (!isReadOnly())
            {
                if (getSelectionLength() != 0)
                {
                    eraseSelectedText();
                }
                else if (getCaratIndex() < getText().length - 1)
                {
                    var newText0:String = getText();
                    var newText:String = newText0.slice(0, d_caratPos) + newText0.slice(d_caratPos + 1);
                    setText(newText);
                    
                    ensureCaratIsVisible();
                    
                    var args:WindowEventArgs = new WindowEventArgs(this);
                    onTextChanged(args);
                }
                
            }
        }
        
        
        /*!
        \brief
        Processing to move carat one character left
        */
        protected function handleCharLeft(sysKeys:uint):void
        {
            if (d_caratPos > 0)
            {
                setCaratIndex(d_caratPos - 1);
            }
            
            if (sysKeys & Consts.SystemKey_Shift)
            {
                setSelection(d_caratPos, d_dragAnchorIdx);
            }
            else
            {
                clearSelection();
            }
        }
        
        
        /*!
        \brief
        Processing to move carat one word left
        */
        protected function handleWordLeft(sysKeys:uint):void
        {
            if (d_caratPos > 0)
            {
                setCaratIndex(TextUtils.getWordStartIdx(getText(), getCaratIndex()));
            }
            
            if (sysKeys & Consts.SystemKey_Shift)
            {
                setSelection(d_caratPos, d_dragAnchorIdx);
            }
            else
            {
                clearSelection();
            }

        }
        
        
        /*!
        \brief
        Processing to move carat one character right
        */
        protected function handleCharRight(sysKeys:uint):void
        {
            if (d_caratPos < getText().length - 1)
            {
                setCaratIndex(d_caratPos + 1);
            }
            
            if (sysKeys & Consts.SystemKey_Shift)
            {
                setSelection(d_caratPos, d_dragAnchorIdx);
            }
            else
            {
                clearSelection();
            }
        }
        
        
        /*!
        \brief
        Processing to move carat one word right
        */
        protected function handleWordRight(sysKeys:uint):void
        {
            if (d_caratPos < getText().length - 1)
            {
                setCaratIndex(TextUtils.getNextWordStartIdx(getText(), getCaratIndex()));
            }
            
            if (sysKeys & Consts.SystemKey_Shift)
            {
                setSelection(d_caratPos, d_dragAnchorIdx);
            }
            else
            {
                clearSelection();
            }
        }
        
        
        /*!
        \brief
        Processing to move carat to the start of the text.
        */
        protected function handleDocHome(sysKeys:uint):void
        {
            if (d_caratPos > 0)
            {
                setCaratIndex(0);
            }
            
            if (sysKeys & Consts.SystemKey_Shift)
            {
                setSelection(d_caratPos, d_dragAnchorIdx);
            }
            else
            {
                clearSelection();
            }
        }
        
        
        /*!
        \brief
        Processing to move carat to the end of the text
        */
        protected function handleDocEnd(sysKeys:uint):void
        {
            if (d_caratPos < getText().length - 1)
            {
                setCaratIndex(getText().length - 1);
            }
            
            if (sysKeys & Consts.SystemKey_Shift)
            {
                setSelection(d_caratPos, d_dragAnchorIdx);
            }
            else
            {
                clearSelection();
            }

        }
        
        
        /*!
        \brief
        Processing to move carat to the start of the current line.
        */
        protected function handleLineHome(sysKeys:uint):void
        {
            var line:uint = getLineNumberFromIndex(d_caratPos);
            
            if (line < d_lines.length)
            {
                var lineStartIdx:uint = d_lines[line].d_startIdx;
                
                if (d_caratPos > lineStartIdx)
                {
                    setCaratIndex(lineStartIdx);
                }
                
                if (sysKeys & Consts.SystemKey_Shift)
                {
                    setSelection(d_caratPos, d_dragAnchorIdx);
                }
                else
                {
                    clearSelection();
                }
                
            }

        }
        
        
        /*!
        \brief
        Processing to move carat to the end of the current line
        */
        protected function handleLineEnd(sysKeys:uint):void
        {
            var line:uint = getLineNumberFromIndex(d_caratPos);
            
            if (line < d_lines.length)
            {
                var lineEndIdx:uint = d_lines[line].d_startIdx + d_lines[line].d_length - 1;
                
                if (d_caratPos < lineEndIdx)
                {
                    setCaratIndex(lineEndIdx);
                }
                
                if (sysKeys & Consts.SystemKey_Shift)
                {
                    setSelection(d_caratPos, d_dragAnchorIdx);
                }
                else
                {
                    clearSelection();
                }
                
            }
        }
        
        
        /*!
        \brief
        Processing to move carat up a line.
        */
        protected function handleLineUp(sysKeys:uint):void
        {
            var caratLine:uint = getLineNumberFromIndex(d_caratPos);
            
            if (caratLine > 0)
            {
                var caratPixelOffset:Number = getFont().getTextExtent(getText().substr(d_lines[caratLine].d_startIdx, d_caratPos - d_lines[caratLine].d_startIdx));
                
                --caratLine;
                
                var newLineIndex:uint = getFont().getCharAtPixelAtBegining(getText().substr(d_lines[caratLine].d_startIdx, d_lines[caratLine].d_length), caratPixelOffset);
                
                setCaratIndex(d_lines[caratLine].d_startIdx + newLineIndex);
            }
            
            if (sysKeys & Consts.SystemKey_Shift)
            {
                setSelection(d_caratPos, d_dragAnchorIdx);
            }
            else
            {
                clearSelection();
            }
        }
        
        
        /*!
        \brief
        Processing to move carat down a line.
        */
        protected function handleLineDown(sysKeys:uint):void
        {
            var caratLine:uint = getLineNumberFromIndex(d_caratPos);
            
            if ((d_lines.length > 1) && (caratLine < (d_lines.length - 1)))
            {
                var caratPixelOffset:Number = getFont().getTextExtent(getText().substr(d_lines[caratLine].d_startIdx, d_caratPos - d_lines[caratLine].d_startIdx));
                
                ++caratLine;
                
                var newLineIndex:uint = getFont().getCharAtPixelAtBegining(getText().substr(d_lines[caratLine].d_startIdx, d_lines[caratLine].d_length), caratPixelOffset);
                
                setCaratIndex(d_lines[caratLine].d_startIdx + newLineIndex);
            }
            
            if (sysKeys & Consts.SystemKey_Shift)
            {
                setSelection(d_caratPos, d_dragAnchorIdx);
            }
            else
            {
                clearSelection();
            }

        }
        
        
        /*!
        \brief
        Processing to insert a new line / paragraph.
        */
        protected function handleNewLine(sysKeys:uint):void
        {
            if (!isReadOnly())
            {
                // erase selected text
                eraseSelectedText();
                
                // if there is room
                if (getText().length - 1 < d_maxTextLen)
                {
                    var newText0:String = getText();
                    var newText:String = newText0.slice(0, getCaratIndex()) + "\n" + newText0.slice(getCaratIndex());
                    setText(newText);
                    
                    d_caratPos++;
                    
                    var args:WindowEventArgs = new WindowEventArgs(this);
                    onTextChanged(args);
                }
                
            }
        }
        
        
        /*!
        \brief
        Processing to move caret one page up
        */
        protected function handlePageUp(sysKeys:uint):void
        {
            var caratLine:uint = getLineNumberFromIndex(d_caratPos);
            var nbLine:uint = (uint)(getTextRenderArea().getHeight() / getFont().getLineSpacing());
            var newline:uint = 0;
            if (nbLine < caratLine)
            {
                newline = caratLine - nbLine;
            }
            setCaratIndex(d_lines[newline].d_startIdx);
            if (sysKeys & Consts.SystemKey_Shift)
            {
                setSelection(d_caratPos, d_selectionEnd);
            }
            else
            {
                clearSelection();
            }
            ensureCaratIsVisible();
        }
        
        
        /*!
        \brief
        Processing to move caret one page down
        */
        protected function handlePageDown(sysKeys:uint):void
        {
            var caratLine:uint = getLineNumberFromIndex(d_caratPos);
            var nbLine:uint =  (uint)(getTextRenderArea().getHeight() / getFont().getLineSpacing());
            var newline:uint = caratLine + nbLine;
            if (d_lines.length > 0)
            {
                newline = newline < d_lines.length- 1 ? newline : d_lines.length -1;
            }
            setCaratIndex(d_lines[newline].d_startIdx + d_lines[newline].d_length - 1);
            if (sysKeys & Consts.SystemKey_Shift)
            {
                setSelection(d_selectionStart, d_caratPos);
            }
            else
            {
                clearSelection();
            }
            ensureCaratIsVisible();
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
            if ((class_name=="MultiLineEditBox") ||
                (class_name=="MultiLineEditbox"))
            {
                return true;
            }
            
            return super.testClassName_impl(class_name);
        }
        
        /*!
        \brief
        Internal handler that is triggered when the user interacts with the scrollbars.
        */
        protected function handle_scrollChange(args:EventArgs):Boolean
        {
            // simply trigger a redraw of the Listbox.
            invalidate();
            return true;
        }
        
        // handler triggered when vertical scrollbar is shown or hidden
        protected function handle_vertScrollbarVisibilityChanged(e:EventArgs):Boolean
        {
            if (d_wordWrap)
                formatText(false);
            
            return true;
        }
        
        // validate window renderer
        protected function validateWindowRenderer(name:String):Boolean
        {
            return (name == EventNamespace);
        }
        
        /*************************************************************************
         New event handlers
         *************************************************************************/
        /*!
        \brief
        Handler called when the read-only state of the edit box changes
        */
        protected function onReadOnlyChanged(e:WindowEventArgs):void
        {
            fireEvent(EventReadOnlyModeChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the word wrap mode for the the edit box changes
        */
        protected function 	onWordWrapModeChanged(e:WindowEventArgs):void
        {
            fireEvent(EventWordWrapModeChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the maximum text length for the edit box changes
        */
        protected function 	onMaximumTextLengthChanged(e:WindowEventArgs):void
        {
            fireEvent(EventMaximumTextLengthChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the carat moves.
        */
        protected function 	onCaratMoved(e:WindowEventArgs):void
        {
            invalidate();
            fireEvent(EventCaratMoved, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the text selection changes
        */
        protected function 	onTextSelectionChanged(e:WindowEventArgs):void
        {
            invalidate();
            fireEvent(EventTextSelectionChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the edit box is full
        */
        protected function 	onEditboxFullEvent(e:WindowEventArgs):void
        {
            fireEvent(EventEditboxFull, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when the 'always show' setting for the vertical scroll bar changes.
        */
        protected function 	onVertScrollbarModeChanged(e:WindowEventArgs):void
        {
            invalidate();
            fireEvent(EventVertScrollbarModeChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        Handler called when 'always show' setting for the horizontal scroll bar changes.
        */
        protected function 	onHorzScrollbarModeChanged(e:WindowEventArgs):void
        {
            invalidate();
            fireEvent(EventHorzScrollbarModeChanged, e, EventNamespace);
        }
        
        
        /*************************************************************************
         Overridden event handlers
         *************************************************************************/
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
                d_dragAnchorIdx = TextUtils.getWordStartIdx(getText(), (d_caratPos == getText().length) ? d_caratPos : d_caratPos + 1);
                d_caratPos      = TextUtils.getNextWordStartIdx(getText(), d_caratPos);
                
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
                var caratLine:uint = getLineNumberFromIndex(d_caratPos);
                var lineStart:uint = d_lines[caratLine].d_startIdx;
                
                // find end of last paragraph
                var paraStart:int = getText().indexOf(d_lineBreakChars, lineStart);
                
                // if no previous paragraph, selection will start at the beginning.
                if (paraStart == -1)
                {
                    paraStart = 0;
                }
                
                // find end of this paragraph
                var paraEnd:int = getText().indexOf(d_lineBreakChars, lineStart);
                
                // if paragraph has no end, which actually should never happen, fix the
                // erroneous situation and select up to end at end of text.
                if (paraEnd == -1)
                {
                    var newText:String = getText() + "\n";
                    setText(newText);
                    
                    paraEnd = getText().length - 1;
                }
                
                // set up selection using new values.
                d_dragAnchorIdx = paraStart;
                setCaratIndex(paraEnd);
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
                setCaratIndex(getTextIndexFromPosition(e.position));
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
                getFont().isCodepointAvailableOnInput(e.codepoint))
            {
                // erase selected text
                eraseSelectedText();
                
                // if there is room
                if (getText().length - 1 < d_maxTextLen)
                {
                    var newText:String = TextUtils.insertCharcode(getText(), getCaratIndex(), e.codepoint);
                    setText(newText);
                    
                    d_caratPos++;
                    
                    var args:WindowEventArgs = new WindowEventArgs(this);
                    onTextChanged(args);
                    
                    ++e.handled;
                }
                else
                {
                    // Trigger text box full event
                    args = new WindowEventArgs(this);
                    onEditboxFullEvent(args);
                }
                
            }

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
                        {
                            d_dragAnchorIdx = getCaratIndex();
                        }
                        break;
                    
                    case Consts.Key_Backspace:
                        handleBackspace();
                        break;
                    
                    case Consts.Key_Delete:
                        handleDelete();
                        break;
                    
                    case Consts.Key_Return:
                    case Consts.Key_NumpadEnter:
                        handleNewLine(e.sysKeys);
                        break;
                    
                    case Consts.Key_ArrowLeft:
                        if (e.sysKeys & Consts.SystemKey_Control)
                        {
                            handleWordLeft(e.sysKeys);
                        }
                        else
                        {
                            handleCharLeft(e.sysKeys);
                        }
                        break;
                    
                    case Consts.Key_ArrowRight:
                        if (e.sysKeys & Consts.SystemKey_Control)
                        {
                            handleWordRight(e.sysKeys);
                        }
                        else
                        {
                            handleCharRight(e.sysKeys);
                        }
                        break;
                    
                    case Consts.Key_ArrowUp:
                        handleLineUp(e.sysKeys);
                        break;
                    
                    case Consts.Key_ArrowDown:
                        handleLineDown(e.sysKeys);
                        break;
                    
                    case Consts.Key_Home:
                        if (e.sysKeys & Consts.SystemKey_Control)
                        {
                            handleDocHome(e.sysKeys);
                        }
                        else
                        {
                            handleLineHome(e.sysKeys);
                        }
                        break;
                    
                    case Consts.Key_End:
                        if (e.sysKeys & Consts.SystemKey_Control)
                        {
                            handleDocEnd(e.sysKeys);
                        }
                        else
                        {
                            handleLineEnd(e.sysKeys);
                        }
                        break;
                    
                    case Consts.Key_PageUp:
                        handlePageUp(e.sysKeys);
                        break;
                    
                    case Consts.Key_PageDown:
                        handlePageDown(e.sysKeys);
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
            var str:String = getText();
            
            // ensure last character is a new line
            if ((str.length == 0) || (str.charAt(str.length - 1) != '\n'))
            {
                var newText:String = str + "\n";
                setText(newText);
            }
            
            
            // base class processing
            super.onTextChanged(e);
            
            // clear selection
            clearSelection();
            // layout new text
            formatText(true);
            // layout child windows (scrollbars) since text layout may have changed
            performChildWindowLayout();
            // ensure carat is still within the text
            setCaratIndex(getCaratIndex());
            // ensure carat is visible
            // NB: this will already have been called at least once, but since we
            // may have changed the formatting of the text, it needs to be called again.
            ensureCaratIsVisible();
            
            ++e.handled;
        }
        
        override protected function onSized(e:WindowEventArgs):void
        {
            formatText(true);
            
            // base class handling
            super.onSized(e);
            
            ++e.handled;
        }
        
        override public function onMouseWheel(e:MouseEventArgs):void
        {
            // base class processing.
            super.onMouseWheel(e);
            
            var vertScrollbar:FlameScrollbar = getVertScrollbar();
            var horzScrollbar:FlameScrollbar = getHorzScrollbar();
            
            if (vertScrollbar.isVisible() && (vertScrollbar.getDocumentSize() > vertScrollbar.getPageSize()))
            {
                vertScrollbar.setScrollPosition(vertScrollbar.getScrollPosition() + vertScrollbar.getStepSize() * -e.wheelChange);
            }
            else if (horzScrollbar.isVisible() && (horzScrollbar.getDocumentSize() > horzScrollbar.getPageSize()))
            {
                horzScrollbar.setScrollPosition(horzScrollbar.getScrollPosition() + horzScrollbar.getStepSize() * -e.wheelChange);
            }
            
            ++e.handled;
        }
        
        
        /*************************************************************************
         Private methods
         *************************************************************************/
        private function addMultiLineEditboxProperties():void
        {
            addProperty(d_readOnlyProperty);
            addProperty(d_wordWrapProperty);
            addProperty(d_caratIndexProperty);
            addProperty(d_selectionStartProperty);
            addProperty(d_selectionLengthProperty);
            addProperty(d_maxTextLengthProperty);
            addProperty(d_selectionBrushProperty);
            addProperty(d_forceVertProperty);
        }
    }
}