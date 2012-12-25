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
package Flame2D.falagard
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.falagard.FalagardWidgetLookFeel;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.text.FlameCentredRenderedString;
    import Flame2D.core.text.FlameCentredRenderedStringWordWrapper;
    import Flame2D.core.text.FlameFormattedRenderedString;
    import Flame2D.core.text.FlameJustifiedRenderedString;
    import Flame2D.core.text.FlameJustifiedRenderedStringWordWrapper;
    import Flame2D.core.text.FlameLeftAignedRenderedStringWordWrapper;
    import Flame2D.core.text.FlameLeftAlignedRenderedString;
    import Flame2D.core.text.FlameRenderedString;
    import Flame2D.core.text.FlameRightAlignedRenderedString;
    import Flame2D.core.text.FlameRightAlignedRenderedStringWordWrapper;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.Vector2;
    import Flame2D.elements.base.FlameScrollbar;

    /*!
    \brief
    StaticText class for the FalagardBase module.
    
    This class requires LookNFeel to be assigned.  The LookNFeel should provide the following:
    
    States:
    - Enabled                     - basic rendering for enabled state.
    - Disabled                    - basic rendering for disabled state.
    - EnabledFrame                - frame rendering for enabled state
    - DisabledFrame               - frame rendering for disabled state.
    - WithFrameEnabledBackground  - backdrop rendering for enabled state with frame enabled.
    - WithFrameDisabledBackground - backdrop rendering for disabled state with frame enabled.
    - NoFrameEnabledBackground    - backdrop rendering for enabled state with frame disabled.
    - NoFrameDisabledBackground   - backdrop rendering for disabled state with frame disabled.
    
    Named Areas (missing areas will default to 'WithFrameTextRenderArea'):
    WithFrameTextRenderArea
    WithFrameTextRenderAreaHScroll
    WithFrameTextRenderAreaVScroll
    WithFrameTextRenderAreaHVScroll
    NoFrameTextRenderArea
    NoFrameTextRenderAreaHScroll
    NoFrameTextRenderAreaVScroll
    NoFrameTextRenderAreaHVScroll
    */
    public class FalagardStaticText extends FalagardStatic
    {
        
        public static const TypeName:String = "Falagard/StaticText";
        
        
        /*************************************************************************
         Child Widget name suffix constants
         *************************************************************************/
        protected static const VertScrollbarNameSuffix:String = "__auto_vscrollbar__";   //!< Widget name suffix for the vertical scrollbar component.
        protected static const HorzScrollbarNameSuffix:String = "__auto_hscrollbar__";   //!< Widget name suffix for the horizontal scrollbar component.

        // properties
        protected static var d_textColoursProperty:FalagardStaticTextPropertyTextColours = new FalagardStaticTextPropertyTextColours();
        protected static var d_vertFormattingProperty:FalagardStaticTextPropertyVertFormatting = new FalagardStaticTextPropertyVertFormatting();
        protected static var d_horzFormattingProperty:FalagardStaticTextPropertyHorzFormatting = new FalagardStaticTextPropertyHorzFormatting();
        protected static var d_vertScrollbarProperty:FalagardStaticTextPropertyVertScrollbar = new FalagardStaticTextPropertyVertScrollbar();
        protected static var d_horzScrollbarProperty:FalagardStaticTextPropertyHorzScrollbar = new FalagardStaticTextPropertyHorzScrollbar();
        protected static var d_horzExtentProperty:FalagardStaticTextPropertyHorzExtent = new FalagardStaticTextPropertyHorzExtent();
        protected static var d_vertExtentProperty:FalagardStaticTextPropertyVertExtent = new FalagardStaticTextPropertyVertExtent();
        
        
        // implementation data
        //! Horizontal formatting to be applied to the text.
        protected var d_horzFormatting:uint = Consts.HorizontalTextFormatting_HTF_LEFT_ALIGNED;
        //! Vertical formatting to be applied to the text.
        protected var d_vertFormatting:uint = Consts.VerticalTextFormatting_VTF_CENTRE_ALIGNED;
        protected var d_textCols:ColourRect = new ColourRect();             //!< Colours used when rendering the text.
        protected var d_enableVertScrollbar:Boolean = false;  //!< true if vertical scroll bar is enabled.
        protected var d_enableHorzScrollbar:Boolean = false;  //!< true if horizontal scroll bar is enabled.
        
        //! Class that renders RenderedString with some formatting.
        protected var d_formattedRenderedString:FlameFormattedRenderedString = null;
        
//        typedef std::vector<Event::Connection> ConnectionList;
//        ConnectionList  d_connections;
        
        //! true when string formatting is up to date.
        protected var d_formatValid:Boolean = false;
        
        public function FalagardStaticText(type:String)
        {
            super(type);
            
            registerProperty(d_textColoursProperty);
            registerProperty(d_vertFormattingProperty);
            registerProperty(d_horzFormattingProperty);
            registerProperty(d_vertScrollbarProperty);
            registerProperty(d_horzScrollbarProperty);
            
            //to be checked
//            registerProperty(d_horzExtentProperty, true);
//            registerProperty(d_vertExtentProperty, true);
            registerProperty(d_horzExtentProperty);
            registerProperty(d_vertExtentProperty);
        }
        
        override public function render():void
        {
            // base class rendering
            super.render();
            
            // text rendering
            renderScrolledText();
        }
        
        
        /************************************************************************
         Scrolled text implementation
         *************************************************************************/
        /*!
        \brief
        Return a ColourRect object containing the colours used when rendering this widget.
        */
        public function getTextColours():ColourRect
        {
            return d_textCols;
        }
        
        /*!
        \brief
        Return the current horizontal formatting option set for this widget.
        */
        public function getHorizontalFormatting():uint
        {
            return    d_horzFormatting;
        }
        
        /*!
        \brief
        Return the current vertical formatting option set for this widget.
        */
        public function getVerticalFormatting():uint
        {
            return d_vertFormatting;
        }
        
        /*!
        \brief
        Sets the colours to be applied when rendering the text.
        */
        public function setTextColours(colours:ColourRect):void
        {
            d_textCols = colours;
            d_window.invalidate();
        }
        
        /*!
        \brief
        Set the vertical formatting required for the text.
        */
        public function setVerticalFormatting(v_fmt:uint):void
        {
            d_vertFormatting = v_fmt;
            configureScrollbars();
            d_window.invalidate();
        }
        
        /*!
        \brief
        Set the horizontal formatting required for the text.
        */
        public function setHorizontalFormatting(h_fmt:uint):void
        {
            if (h_fmt == d_horzFormatting)
                return;
            
            d_horzFormatting = h_fmt;
            setupStringFormatter();
            configureScrollbars();
            d_window.invalidate();
        }
        
        /*!
        \brief
        Return whether the vertical scroll bar is set to be shown if needed.
        */
        public function isVerticalScrollbarEnabled():Boolean
        {
            return d_enableVertScrollbar;
        }
        
        /*!
        \brief
        Return whether the horizontal scroll bar is set to be shown if needed.
        */
        public function isHorizontalScrollbarEnabled():Boolean
        {
            return d_enableHorzScrollbar;
        }
        
        /*!
        \brief
        Set whether the vertical scroll bar will be shown if needed.
        */
        public function setVerticalScrollbarEnabled(setting:Boolean):void
        {
            d_enableVertScrollbar = setting;
            configureScrollbars();
            d_window.performChildWindowLayout();
        }
        
        /*!
        \brief
        Set whether the horizontal scroll bar will be shown if needed.
        */
        public function setHorizontalScrollbarEnabled(setting:Boolean):void
        {
            d_enableHorzScrollbar = setting;
            configureScrollbars();
            d_window.performChildWindowLayout();
        }
        
        //! return the current horizontal formatted text extent in pixels.
        public function getHorizontalTextExtent():Number
        {
            if (!d_formatValid)
                updateFormatting();
            
            return d_formattedRenderedString ?
                d_formattedRenderedString.getHorizontalExtent() :
                0.0;
        }
        
        //! return the current vertical formatted text extent in pixels.
        public function getVerticalTextExtent():Number
        {
            if (!d_formatValid)
                updateFormatting();
            
            return d_formattedRenderedString ?
                d_formattedRenderedString.getVerticalExtent() :
                0.0;
        }
        
        //! update string formatting (gets area size to use from looknfeel)
        protected function updateFormatting():void
        {
            updateFormattingWithSize(getTextRenderArea().getSize());
        }
        
        //! update string formatting using given area size.
        protected function updateFormattingWithSize(sz:Size):void
        {
            if (!d_window)
                return;
            
//            if (!d_formattedRenderedString)
                setupStringFormatter();
            
            // 'touch' the window's rendered string to ensure it's re-parsed if needed.
            d_window.getRenderedString();
            
            d_formattedRenderedString.format(sz);
            d_formatValid = true;
        }
        
        // overridden from FalagardStatic base class
        override public function onLookNFeelAssigned():void
        {
            // do initial scrollbar setup
            var vertScrollbar:FlameScrollbar = getVertScrollbar();
            var horzScrollbar:FlameScrollbar = getHorzScrollbar();
            
            vertScrollbar.hide();
            horzScrollbar.hide();
            
            d_window.performChildWindowLayout();
            
            // scrollbar events
            vertScrollbar.subscribeEvent(FlameScrollbar.EventScrollPositionChanged,
                new Subscriber(handleScrollbarChange, this), FlameScrollbar.EventNamespace);
            horzScrollbar.subscribeEvent(FlameScrollbar.EventScrollPositionChanged,
                new Subscriber(handleScrollbarChange, this), FlameScrollbar.EventNamespace);
            
            // events that scrollbars should react to
            d_window.subscribeEvent(FlameWindow.EventTextChanged, new Subscriber(onTextChanged, this), FlameWindow.EventNamespace);
            d_window.subscribeEvent(FlameWindow.EventSized, new Subscriber(onSized, this), FlameWindow.EventNamespace);
            d_window.subscribeEvent(FlameWindow.EventFontChanged, new Subscriber(onFontChanged, this), FlameWindow.EventNamespace);
            d_window.subscribeEvent(FlameWindow.EventMouseWheel, new Subscriber(onMouseWheel, this), FlameWindow.EventNamespace);
                
        }
        
        override public function onLookNFeelUnassigned():void
        {
            // clean up connections that rely on widgets created by the look and feel
//            ConnectionList::iterator i = d_connections.begin();
//            while (i != d_connections.end())
//            {
//                (*i)->disconnect();
//                ++i;
//            }
//            d_connections.clear();
        }
        
        // text field with scrollbars methods
        protected function renderScrolledText():void
        {
            // get destination area for the text.
            const clipper:Rect = getTextRenderArea();
            var absarea:Rect = clipper.clone();
            
            if (!d_formatValid)
                updateFormattingWithSize(clipper.getSize());
            
            // see if we may need to adjust horizontal position
            const horzScrollbar:FlameScrollbar = getHorzScrollbar();
            if (horzScrollbar.isVisible())
            {
                switch(d_horzFormatting)
                {
                    case Consts.HorizontalTextFormatting_HTF_LEFT_ALIGNED:
                    case Consts.HorizontalTextFormatting_HTF_WORDWRAP_LEFT_ALIGNED:
                    case Consts.HorizontalTextFormatting_HTF_JUSTIFIED:
                    case Consts.HorizontalTextFormatting_HTF_WORDWRAP_JUSTIFIED:
                        absarea.offset2(new Vector2(-horzScrollbar.getScrollPosition(), 0));
                        break;
                    
                    case Consts.HorizontalTextFormatting_HTF_CENTRE_ALIGNED:
                    case Consts.HorizontalTextFormatting_HTF_WORDWRAP_CENTRE_ALIGNED:
                        absarea.setWidth(horzScrollbar.getDocumentSize());
                        absarea.offset2(new Vector2(-horzScrollbar.getScrollPosition(), 0));
                        break;
                    
                    case Consts.HorizontalTextFormatting_HTF_RIGHT_ALIGNED:
                    case Consts.HorizontalTextFormatting_HTF_WORDWRAP_RIGHT_ALIGNED:
                        absarea.offset2(new Vector2(horzScrollbar.getScrollPosition(), 0));
                        break;
                }
            }
            
            // adjust y positioning according to formatting option
            var textHeight:Number = d_formattedRenderedString.getVerticalExtent();
            const vertScrollbar:FlameScrollbar = getVertScrollbar();
            switch(d_vertFormatting)
            {
                case Consts.VerticalTextFormatting_VTF_TOP_ALIGNED:
                    absarea.d_top -= vertScrollbar.getScrollPosition();
                    break;
                
                case Consts.VerticalTextFormatting_VTF_CENTRE_ALIGNED:
                    // if scroll bar is in use, act like TopAligned
                    if (vertScrollbar.isVisible())
                        absarea.d_top -= vertScrollbar.getScrollPosition();
                        // no scroll bar, so centre text instead.
                    else
                        absarea.d_top += Misc.PixelAligned((absarea.getHeight() - textHeight) * 0.5);
                    
                    break;
                
                case Consts.VerticalTextFormatting_VTF_BOTTOM_ALIGNED:
                    absarea.d_top = absarea.d_bottom - textHeight;
                    absarea.d_top += vertScrollbar.getScrollPosition();
                    break;
            }
            
            // calculate final colours
            var final_cols:ColourRect = d_textCols;
            final_cols.modulateAlpha(d_window.getEffectiveAlpha());
            // cache the text for rendering.
            d_formattedRenderedString.draw(d_window.getGeometryBuffer(),
                absarea.getPosition(),
                final_cols, clipper);
        }
        
        
        protected function configureScrollbars():void
        {
            // get the scrollbars
            var vertScrollbar:FlameScrollbar = getVertScrollbar();
            var horzScrollbar:FlameScrollbar = getHorzScrollbar();
            
            // get the sizes we need
            var renderArea:Rect = getTextRenderArea();
            var renderAreaSize:Size = renderArea.getSize();
            var documentSize:Size = getDocumentSize(renderArea);
            
            // show or hide vertical scroll bar as required (or as specified by option)
            var showVert:Boolean = ((documentSize.d_height > renderAreaSize.d_height) && d_enableVertScrollbar);
            var showHorz:Boolean = ((documentSize.d_width > renderAreaSize.d_width) && d_enableHorzScrollbar);
            // show or hide vertical scroll bar
            if (showVert)
            {
                vertScrollbar.show();
            }
            else
            {
                vertScrollbar.hide();
            }
            
            // show or hide horizontal scroll bar
            if (showHorz)
            {
                horzScrollbar.show();
            }
            else
            {
                horzScrollbar.hide();
            }
            
            // if scrollbar visibility just changed we have might have a better TextRenderArea
            // if so we go with that instead
            var updatedRenderArea:Rect = getTextRenderArea();
            if (renderArea!=updatedRenderArea)
            {
                renderArea = updatedRenderArea;
                renderAreaSize = renderArea.getSize();
            }
            
            // Set up scroll bar values
            vertScrollbar.setDocumentSize(documentSize.d_height);
            vertScrollbar.setPageSize(renderAreaSize.d_height);
            vertScrollbar.setStepSize(Math.max(1.0, renderAreaSize.d_height / 10.0));
            
            horzScrollbar.setDocumentSize(documentSize.d_width);
            horzScrollbar.setPageSize(renderAreaSize.d_width);
            horzScrollbar.setStepSize(Math.max(1.0, renderAreaSize.d_width / 10.0));
        }
        
        protected function getVertScrollbar():FlameScrollbar
        {
            // return component created by look'n'feel assignment.
            return FlameWindowManager.getSingleton().getWindow(d_window.getName() + VertScrollbarNameSuffix)
                as FlameScrollbar;
        }
        
        protected function getHorzScrollbar():FlameScrollbar
        {
            // return component created by look'n'feel assignment.
            return FlameWindowManager.getSingleton().getWindow(d_window.getName() + HorzScrollbarNameSuffix)
                as FlameScrollbar;
        }
        
        protected function getTextRenderArea():Rect
        {
            var vertScrollbar:FlameScrollbar = getVertScrollbar();
            var horzScrollbar:FlameScrollbar = getHorzScrollbar();
            var v_visible:Boolean = vertScrollbar.isVisible(true);
            var h_visible:Boolean = horzScrollbar.isVisible(true);
            
            // get WidgetLookFeel for the assigned look.
            const wlf:FalagardWidgetLookFeel = getLookNFeel();
            
            var area_name:String = (d_frameEnabled ? "WithFrameTextRenderArea" : "NoFrameTextRenderArea");
            
            // if either of the scrollbars are visible, we might want to use a special rendering area
            if (v_visible || h_visible)
            {
                if (h_visible)
                {
                    area_name += "H";
                }
                if (v_visible)
                {
                    area_name += "V";
                }
                area_name += "Scroll";
            }
            
            if (wlf.isNamedAreaDefined(area_name))
            {
                return wlf.getNamedArea(area_name).getArea().getPixelRect(d_window);
            }
            
            // default to plain WithFrameTextRenderArea
            return wlf.getNamedArea("WithFrameTextRenderArea").getArea().getPixelRect(d_window);
        }
        
        
        protected function getDocumentSize(renderArea:Rect):Size
        {
            if (!d_formatValid)
                updateFormattingWithSize(renderArea.getSize());
            
            return new Size(d_formattedRenderedString.getHorizontalExtent(),
                d_formattedRenderedString.getVerticalExtent());
        }
        
        protected function setupStringFormatter():void
        {
            // delete any existing formatter
            //delete d_formattedRenderedString;
            d_formattedRenderedString = null;
            d_formatValid = false;
            
            // create new formatter of whichever type...
            switch(d_horzFormatting)
            {
                case Consts.HorizontalTextFormatting_HTF_LEFT_ALIGNED:
                    d_formattedRenderedString =
                    new FlameLeftAlignedRenderedString(d_window.getRenderedString());
                    break;
                
                case Consts.HorizontalTextFormatting_HTF_RIGHT_ALIGNED:
                    d_formattedRenderedString =
                    new FlameRightAlignedRenderedString(d_window.getRenderedString());
                    break;
                
                case Consts.HorizontalTextFormatting_HTF_CENTRE_ALIGNED:
                    d_formattedRenderedString =
                    new FlameCentredRenderedString(d_window.getRenderedString());
                    break;
                
                case Consts.HorizontalTextFormatting_HTF_JUSTIFIED:
                    d_formattedRenderedString =
                    new FlameJustifiedRenderedString(d_window.getRenderedString());
                    break;
                
                case Consts.HorizontalTextFormatting_HTF_WORDWRAP_LEFT_ALIGNED:
                    d_formattedRenderedString = new FlameLeftAignedRenderedStringWordWrapper(d_window.getRenderedString());
                    break;
                
                case Consts.HorizontalTextFormatting_HTF_WORDWRAP_RIGHT_ALIGNED:
                    d_formattedRenderedString = new FlameRightAlignedRenderedStringWordWrapper(d_window.getRenderedString());
                    break;
                
                case Consts.HorizontalTextFormatting_HTF_WORDWRAP_CENTRE_ALIGNED:
                    d_formattedRenderedString = new FlameCentredRenderedStringWordWrapper(d_window.getRenderedString());
                    break;
                
                case Consts.HorizontalTextFormatting_HTF_WORDWRAP_JUSTIFIED:
                    d_formattedRenderedString = new FlameJustifiedRenderedStringWordWrapper(d_window.getRenderedString());
                    break;
            }
        }
        
        // overridden event handlers
        protected function onTextChanged(e:EventArgs):Boolean
        {
            d_formatValid = false;
            configureScrollbars();
            d_window.invalidate();
            return true;
        }
        
        protected function onSized(e:EventArgs):Boolean
        {
            d_formatValid = false;
            configureScrollbars();
            return true;
        }
        
        protected function onFontChanged(e:EventArgs):Boolean
        {
            d_formatValid = false;
            configureScrollbars();
            d_window.invalidate();
            return true;
        }
        
        protected function onMouseWheel(event:EventArgs):Boolean
        {
            const e:MouseEventArgs = event as MouseEventArgs;
            
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
            
            return true;
        }
        
        // event subscribers
        protected function handleScrollbarChange(e:EventArgs):Boolean
        {
            d_window.invalidate();
            return true;
        }
        


    }
}