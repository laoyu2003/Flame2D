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
    import Flame2D.core.data.Consts;
    import Flame2D.core.data.RenderingContext;
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.system.FlameFont;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.UDim;
    import Flame2D.elements.button.FlamePushButton;
    
    public class FlameTabControl extends FlameWindow
    {
        public static const EventNamespace:String = "TabControl";
        public static const WidgetTypeName:String = "CEGUI/TabControl";
        
        
        /*************************************************************************
         Constants
         *************************************************************************/
        // event names
        /** Event fired when a different tab is selected.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the TabControl that has a newly
         * selected tab.
         */
        public static const  EventSelectionChanged:String = "TabSelectionChanged";
        
        /*************************************************************************
         Child Widget name suffix constants
         *************************************************************************/
        public static const  ContentPaneNameSuffix:String = "__auto_TabPane__"; //!< Widget name suffix for the tab content pane component.
        public static const  TabButtonNameSuffix:String = "__auto_btn";   //!< Widget name suffix for the tab button components.
        public static const  TabButtonPaneNameSuffix:String = "__auto_TabPane__Buttons"; //!< Widget name suffix for the tab button pane component.
        public static const  ButtonScrollLeftSuffix:String = "__auto_TabPane__ScrollLeft";//!< Widget name suffix for the scroll tabs to right pane component.
        public static const  ButtonScrollRightSuffix:String = "__auto_TabPane__ScrollRight"; //!< Widget name suffix for the scroll tabs to left pane component.
        
        /*************************************************************************
         Miscelaneous private strings
         *************************************************************************/
        private static const EnableTop:String = "EnableTop";
        private static const EnableBottom:String = "EnableBottom";
        private static const n0:String = "0";
        private static const n1:String = "1";
        
        /*************************************************************************
         Static Properties for this class
         *************************************************************************/
        private static var d_tabHeightProperty:TabControlPropertyTabHeight = new TabControlPropertyTabHeight();
        private static var d_tabTextPaddingProperty:TabControlPropertyTabTextPadding = new TabControlPropertyTabTextPadding();
        private static var d_tabPanePosition:TabControlPropertyTabPanePosition = new TabControlPropertyTabPanePosition();

        /*************************************************************************
         Implementation Data
         *************************************************************************/
        protected var d_tabHeight:UDim = new UDim(0, -1);        //!< The height of the tabs in pixels
        protected var d_tabPadding:UDim = new UDim(0, 5);       //!< The padding of the tabs relative to parent
        //typedef std::vector<TabButton*> TabButtonVector;
        //TabButtonVector d_tabButtonVector;  //!< Sorting for tabs
        protected var d_tabButtonVector:Vector.<FlameTabButton> = new Vector.<FlameTabButton>();
        protected var d_firstTabOffset:Number = 0.0;   //!< The offset in pixels of the first tab
        protected var d_tabPanePos:uint = Consts.TabPanePosition_Top;   //!< The position of the tab pane
        protected var d_btGrabPos:Number;        //!< The position on the button tab where user grabbed
        //! Container used to track event subscriptions to added tab windows.
        //std::map<Window*, Event::ScopedConnection> d_eventConnections;
        

        
        /*************************************************************************
         Construction and Destruction
         *************************************************************************/
        /*!
        \brief
        Constructor for TabControl base class.
        */
        public function FlameTabControl(type:String, name:String)
        {
            super(type, name);
            
            addTabControlProperties();
        }
        
     
        /*************************************************************************
         Accessor Methods
         *************************************************************************/
        /*!
        \brief
        Return number of tabs
        
        \return
        the number of tabs currently present.
        */
        public function getTabCount():uint
        {
            return getTabPane().getChildCount();
        }
        
        /*!
        \brief
        Return the positioning of the tab pane.
        \return
        The positioning of the tab window within the tab control.
        */
        public function getTabPanePosition():uint
        {
            return d_tabPanePos;
        }
        
        /*!
        \brief
        Change the positioning of the tab button pane.
        \param pos
        The new positioning of the tab pane
        */
        public function setTabPanePosition(pos:uint):void
        {
            d_tabPanePos = pos;
            performChildWindowLayout();
        }
        
        /*!
        \brief
        Set the selected tab by the name of the root window within it.
        Also ensures that the tab is made visible (tab pane is scrolled if required).
        \exception	InvalidRequestException	thrown if there's no tab named \a name.
        */
        public function setSelectedTab(name:String):void
        {
            selectTab_impl(getTabPane().getChildByName(name));
        }
        
        /*!
        \brief
        Set the selected tab by the ID of the root window within it.
        Also ensures that the tab is made visible (tab pane is scrolled if required).
        \exception	InvalidRequestException	thrown if \a index is out of range.
        */
        public function setSelectedTabByID(ID:uint):void
        {
            selectTab_impl(getTabPane().getChildByID(ID));
        }
        
        /*!
        \brief
        Set the selected tab by the index position in the tab control.
        Also ensures that the tab is made visible (tab pane is scrolled if required).
        \exception	InvalidRequestException	thrown if \a index is out of range.
        */
        public function setSelectedTabAtIndex(index:uint):void
        {
            selectTab_impl(getTabContentsAtIndex(index));
        }
        
        /*!
        \brief
        Ensure that the tab by the name of the root window within it is visible.
        \exception	InvalidRequestException	thrown if there's no tab named \a name.
        */
        public function makeTabVisible(name:String):void
        {
            makeTabVisible_impl(getTabPane().getChildByName(name));
        }
        
        /*!
        \brief
        Ensure that the tab by the ID of the root window within it is visible.
        \exception	InvalidRequestException	thrown if \a index is out of range.
        */
        public function makeTabVisibleByID(ID:uint):void
        {
            makeTabVisible_impl(getTabPane().getChildByID(ID));
        }
        
        /*!
        \brief
        Ensure that the tab by the index position in the tab control is visible.
        \exception	InvalidRequestException	thrown if \a index is out of range.
        */
        public function makeTabVisibleAtIndex(index:uint):void
        {
            makeTabVisible_impl(getTabContentsAtIndex(index));
        }
        
        /*!
        \brief
        Return the Window which is the first child of the tab at index position \a index.
        
        \param index
        Zero based index of the item to be returned.
        
        \return
        Pointer to the Window at index position \a index in the tab control.
        
        \exception	InvalidRequestException	thrown if \a index is out of range.
        */
        public function getTabContentsAtIndex(index:uint):FlameWindow
        {
            if (index >= d_tabButtonVector.length)
                return null;
            return d_tabButtonVector [index].getTargetWindow();
        }
        
        /*!
        \brief
        Return the Window which is the tab content with the given name.
        
        \param name
        Name of the Window which was attached as a tab content.
        
        \return
        Pointer to the named Window in the tab control.
        
        \exception	InvalidRequestException	thrown if content is not found.
        */
        public function getTabContents(name:String):FlameWindow
        {
            return getTabPane().getChildByName(name);
        }
        
        /*!
        \brief
        Return the Window which is the tab content with the given ID.
        
        \param ID
        ID of the Window which was attached as a tab content.
        
        \return
        Pointer to the Window with the given ID in the tab control.
        
        \exception	InvalidRequestException	thrown if content is not found.
        */
        public function getTabContentsByID(ID:uint):FlameWindow
        {
            return getTabPane().getChildByID(ID);
        }
        
        /*!
        \brief
        Return whether the tab contents window is currently selected.
        
        \param wnd
        The tab contents window to query.
        
        \return
        true if the tab is currently selected, false otherwise.
        
        \exception	InvalidRequestException	thrown if \a wnd is not a valid tab contents window.
        */
        public function isTabContentsSelected(wnd:FlameWindow):Boolean
        {
            var button:FlameTabButton = getButtonForTabContents(wnd);
            return button.isSelected();
        }
        
        /*!
        \brief
        Return the index of the currently selected tab.
        
        \return
        index of the currently selected tab.
        */
        public function getSelectedTabIndex():uint
        {
            for (var i:uint = 0; i < d_tabButtonVector.length; ++i)
                if (d_tabButtonVector [i].isSelected ())
                    return i;
            
            throw new Error("TabControl::getSelectedTabIndex - Current tab not in list?");
        }
        
        /*!
        \brief
        Return the height of the tabs
        */
        public function getTabHeight():UDim
        {
            return d_tabHeight;
        }
        
        /*!
        \brief
        Return the amount of padding to add either side of the text in the tab
        */
        public function getTabTextPadding():UDim
        {
            return d_tabPadding;
        }
        
        
        /*************************************************************************
         Manipulator Methods
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
            performChildWindowLayout();
            
            var name:String = getName () + ButtonScrollLeftSuffix;
            if (FlameWindowManager.getSingleton().isWindowPresent (name))
            {
                FlameWindowManager.getSingleton().getWindow (name).subscribeEvent (
                    FlamePushButton.EventClicked, new Subscriber(handleScrollPane, this), FlamePushButton.EventNamespace);
            }
            
            name = getName() + ButtonScrollRightSuffix;
            if (FlameWindowManager.getSingleton().isWindowPresent (name))
            {
                FlameWindowManager.getSingleton().getWindow (name).subscribeEvent (
                    FlamePushButton.EventClicked, new Subscriber(handleScrollPane, this), FlamePushButton.EventNamespace);
            }
        }
        
        /*!
        \brief
        Set the height of the tabs
        */
        public function setTabHeight(height:UDim):void
        {
            d_tabHeight = height;
            
            performChildWindowLayout();
        }
        
        /*!
        \brief
        Set the amount of padding to add either side of the text in the tab
        */
        public function setTabTextPadding(padding:UDim):void
        {
            d_tabPadding = padding;
            
            performChildWindowLayout();
        }
        
        /*!
        \brief
        Add a new tab to the tab control.
        \par
        The new tab will be added with the same text as the window passed in.
        \param wnd
        The Window which will be placed in the content area of this new tab.
        */
        public function addTab(wnd:FlameWindow):void
        {
            // abort attempts to add null window pointers, but log it for tracking.
            if (!wnd)
            {
                trace("Attempt to add null window pointer as " +
                    "tab to TabControl '" + getName() + "'.  Ignoring!");
                
                return;
            }
            
            // Create a new TabButton
            addButtonForTabContent(wnd);
            // Add the window to the content pane
            getTabPane().addChildWindow(wnd);
            // Auto-select?
            if (getTabCount() == 1)
                setSelectedTab(wnd.getName());
            else
                // initialise invisible content
                wnd.setVisible(false);
            
            // when adding the 1st page, autosize tab pane height
            if (d_tabHeight.d_scale == 0 && d_tabHeight.d_offset == -1)
                d_tabHeight.d_offset = 8 + getFont().getFontHeight ();
            
            // Just request redraw
            performChildWindowLayout();
            invalidate();
            // Subscribe to text changed event so that we can resize as needed

            wnd.subscribeEvent(FlameWindow.EventTextChanged, new Subscriber(handleContentWindowTextChanged, this), FlameWindow.EventNamespace);
        }
        /*!
        \brief
        Remove the named tab from the tab control.
        \par
        The tab content will be destroyed.
        */
        public function removeTab(name:String):void
        {
            // do nothing if given window is not attached as a tab.
            if (getTabPane().isChildForName(name))
                removeTab_impl(getTabPane().getChildByName(name));
        }
        /*!
        \brief
        Remove the tab with the given ID from the tab control.
        \par
        The tab content will be destroyed.
        */
        public function removeTabByID(ID:uint):void
        {
            // do nothing if given window is not attached as a tab.
            if (getTabPane().isChildForID(ID))
                removeTab_impl(getTabPane().getChildByID(ID));
        }
        

        
        /*************************************************************************
         Implementation Functions
         *************************************************************************/
        /*!
        \brief
        Perform the actual rendering for this Window.
        
        \param z
        float value specifying the base Z co-ordinate that should be used when rendering
        
        \return
        Nothing
        */
        override protected function drawSelf(ctx:RenderingContext):void
        {
            /* do nothing; rendering handled by children */
        }
        
        /*!
        \brief
        Add a TabButton for the specified child Window.
        */
        protected function addButtonForTabContent(wnd:FlameWindow):void
        {
            // Create the button
            var tb:FlameTabButton = createTabButton(makeButtonName(wnd));
            // Copy font
            tb.setFont(getFont());
            // Set target window
            tb.setTargetWindow(wnd);
            // Instert into map
            d_tabButtonVector.push(tb);
            // add the button
            getTabButtonPane().addChildWindow(tb);
            // Subscribe to clicked event so that we can change tab
            tb.subscribeEvent(FlameTabButton.EventClicked, new Subscriber(handleTabButtonClicked, this), FlameTabButton.EventNamespace);
            tb.subscribeEvent(FlameTabButton.EventDragged, new Subscriber(handleDraggedPane, this), FlameTabButton.EventNamespace);
            tb.subscribeEvent(FlameTabButton.EventScrolled, new Subscriber(handleWheeledPane, this), FlameTabButton.EventNamespace);
        }
        /*!
        \brief
        Remove the TabButton for the specified child Window.
        */
        protected function removeButtonForTabContent(wnd:FlameWindow):void
        {
            // get
            var tb:FlameTabButton = getTabButtonPane().getChildByName(makeButtonName(wnd)) as FlameTabButton;
            // remove
            for(var i:uint = 0; i<d_tabButtonVector.length; i++)
            {
                if (d_tabButtonVector[i] == tb)
                {
                    d_tabButtonVector.splice(i, 1);
                    break;
                }
            }
            getTabButtonPane().removeChildWindow(tb);
            // destroy
            FlameWindowManager.getSingleton().destroyWindow(tb);
        }
    
        
        /*!
        \brief
        Return the TabButton associated with this Window.
        \exception	InvalidRequestException	thrown if content is not found.
        */
        protected function getButtonForTabContents(wnd:FlameWindow):FlameTabButton
        {
            for (var i:uint = 0; i < d_tabButtonVector.length; ++i)
            {
                if (d_tabButtonVector [i].getTargetWindow () == wnd)
                    return d_tabButtonVector [i];
            }
            throw new Error("TabControl::getButtonForTabContents - The Window object is not a tab contents.");
        }
        /*!
        \brief
        Construct a button name to handle a window.
        */
        protected function makeButtonName(wnd:FlameWindow):String
        {
            // Create the button name as "'auto' parent + 'auto' button + tab name"
            var buttonName:String = getTabButtonPane().getName();
            buttonName += TabButtonNameSuffix;
            buttonName += wnd.getName();
            return buttonName;
        }
        
        /*!
        \brief
        Internal implementation of select tab.
        \param wnd
        Pointer to a Window which is the root of the tab content to select
        */
        protected function selectTab_impl(wnd:FlameWindow):void
        {
            makeTabVisible_impl(wnd);
            
            var modified:Boolean = false;
            // Iterate in order of tab index
            for (var i:uint = 0; i < d_tabButtonVector.length; ++i)
            {
                // get corresponding tab button and content window
                var tb:FlameTabButton = d_tabButtonVector [i];
                var child:FlameWindow = tb.getTargetWindow();
                // Should we be selecting?
                var selectThis:Boolean = (child == wnd);
                // Are we modifying this tab?
                modified = modified || (tb.isSelected() != selectThis);
                // Select tab & set visible if this is the window, not otherwise
                tb.setSelected(selectThis);
                child.setVisible(selectThis);
            }

            // Trigger event?
            if (modified)
            {
                var args:WindowEventArgs = new WindowEventArgs(this);
                onSelectionChanged(args);
            }
        }
        
        
        /*!
        \brief
        Internal implementation of make tab visible.
        \param wnd
        Pointer to a Window which is the root of the tab content to make visible
        */
        protected function makeTabVisible_impl(wnd:FlameWindow):void
        {
            var tb:FlameTabButton = null;
            
            for (var i:uint = 0; i < d_tabButtonVector.length; ++i)
            {
                // get corresponding tab button and content window
                tb = d_tabButtonVector [i];
                var child:FlameWindow = tb.getTargetWindow();
                if (child == wnd)
                    break;
                tb = null;
            }
            
            if (!tb)
                return;
            
            var ww:Number = getPixelSize ().d_width;
            var x:Number = tb.getXPosition().asAbsolute (ww);
            var w:Number = tb.getPixelSize ().d_width;
            var lx:Number = 0, rx:Number = ww;
            
            var scrollLeftBtn:FlameWindow = null;
            var scrollRightBtn:FlameWindow = null;
            var name:String = getName() + ButtonScrollLeftSuffix;
            if (FlameWindowManager.getSingleton().isWindowPresent (name))
            {
                scrollLeftBtn = FlameWindowManager.getSingleton().getWindow (name);
                lx = scrollLeftBtn.getArea ().d_max.d_x.asAbsolute (ww);
                scrollLeftBtn.setWantsMultiClickEvents (false);
            }
            
            name = getName() + ButtonScrollRightSuffix;
            if (FlameWindowManager.getSingleton().isWindowPresent (name))
            {
                scrollRightBtn = FlameWindowManager.getSingleton().getWindow (name);
                rx = scrollRightBtn.getXPosition ().asAbsolute (ww);
                scrollRightBtn.setWantsMultiClickEvents (false);
            }
            
            if (x < lx)
                d_firstTabOffset += lx - x;
            else
            {
                if (x + w <= rx)
                    return; // nothing to do
                
                d_firstTabOffset += rx - (x + w);
            }
            
            performChildWindowLayout ();
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
            if (class_name=="TabControl")	return true;
            return super.testClassName_impl(class_name);
        }
        
        /*!
        \brief
        Return a pointer to the tab button pane (Window)for
        this TabControl.
        
        \return
        Pointer to a Window object.
        
        \exception UnknownObjectException
        Thrown if the component does not exist.
        */
        protected function getTabButtonPane():FlameWindow
        {
            return FlameWindowManager.getSingleton().getWindow(getName() +
                TabButtonPaneNameSuffix);
        }
        
        /*!
        \brief
        Return a pointer to the content component widget for
        this TabControl.
        
        \return
        Pointer to a Window object.
        
        \exception UnknownObjectException
        Thrown if the component does not exist.
        */
        protected function getTabPane():FlameWindow
        {
            return FlameWindowManager.getSingleton().getWindow(getName() + ContentPaneNameSuffix);
        }
        
        override public function performChildWindowLayout():void
        {
            var tabButtonPane:FlameWindow = getTabButtonPane();
            var tabContentPane:FlameWindow = getTabPane();
            
            // Enable top/bottom edges of the tabPane control,
            // if supported by looknfeel
            if (tabContentPane.isPropertyPresent (EnableTop))
                tabContentPane.setProperty (EnableTop, (d_tabPanePos == Consts.TabPanePosition_Top) ? n0 : n1);
            if (tabContentPane.isPropertyPresent (EnableBottom))
                tabContentPane.setProperty (EnableBottom, (d_tabPanePos == Consts.TabPanePosition_Top) ? n1 : n0);
            if (tabButtonPane.isPropertyPresent (EnableTop))
                tabButtonPane.setProperty (EnableTop, (d_tabPanePos == Consts.TabPanePosition_Top) ? n0 : n1);
            if (tabButtonPane.isPropertyPresent (EnableBottom))
                tabButtonPane.setProperty (EnableBottom, (d_tabPanePos == Consts.TabPanePosition_Top) ? n1 : n0);
            
            super.performChildWindowLayout();
            
            // Calculate the size & position of the tab scroll buttons
            var scrollLeftBtn:FlameWindow = null;
            var scrollRightBtn:FlameWindow = null;
            var name:String = getName() + ButtonScrollLeftSuffix;
            if (FlameWindowManager.getSingleton().isWindowPresent (name))
                scrollLeftBtn = FlameWindowManager.getSingleton().getWindow (name);
            
            name = getName() + ButtonScrollRightSuffix;
            if (FlameWindowManager.getSingleton().isWindowPresent (name))
                scrollRightBtn = FlameWindowManager.getSingleton().getWindow (name);
            
            // Calculate the positions and sizes of the tab buttons
            if (d_firstTabOffset > 0)
                d_firstTabOffset = 0;
            
            for (;;)
            {
                var i:uint;
                for (i = 0; i < d_tabButtonVector.length; ++i)
                    calculateTabButtonSizePosition (i);
                
                if (d_tabButtonVector.length == 0)
                {
                    if (scrollRightBtn)
                        scrollRightBtn.setVisible (false);
                    if (scrollLeftBtn)
                        scrollLeftBtn.setVisible (false);
                    break;
                }
                
                // Now check if tab pane wasn't scrolled too far
                --i;
                var xmax:Number = d_tabButtonVector [i].getXPosition().d_offset +
                    d_tabButtonVector [i].getPixelSize ().d_width;
                var width:Number = tabButtonPane.getPixelSize ().d_width;
                
                // If right button margin exceeds right window margin,
                // or leftmost button is at offset 0, finish
                if ((xmax > (width - 0.5)) || (d_firstTabOffset == 0))
                {
                    if (scrollLeftBtn)
                        scrollLeftBtn.setVisible (d_firstTabOffset < 0);
                    if (scrollRightBtn)
                        scrollRightBtn.setVisible (xmax > width);
                    break;
                }
                
                // Scroll the tab pane until the rightmost button
                // touches the right margin
                d_firstTabOffset += width - xmax;
                // If we scrolled it too far, set leftmost button offset to 0
                if (d_firstTabOffset > 0)
                    d_firstTabOffset = 0;
            }
        }
        
        
        
        // validate window renderer
        protected function validateWindowRenderer(name:String):Boolean
        {
            return (name == "TabControl");
        }
        
        /*!
        \brief
        create and return a pointer to a TabButton widget for use as a clickable tab header
        \param name
        Button name
        \return
        Pointer to a TabButton to be used for changing tabs.
        */
        protected function createTabButton(name:String):FlameTabButton
        {
            if (d_windowRenderer != null)
            {
                var wr:TabControlWindowRenderer = d_windowRenderer as TabControlWindowRenderer;
                return wr.createTabButton(name);
            }
            else
            {
                //return createTabButton_impl(name);
                throw new Error("TabControl::createTabButton - This function must be implemented by the window renderer module");
            }
        }
        
        //! Implementation function to do main work of removing a tab.
        protected function removeTab_impl(window:FlameWindow):void
        {
            // silently abort if window to be removed is 0.
            if (!window)
                return;
            
            // delete connection to event we subscribed earlier
            //d_eventConnections.erase(window);
            // Was this selected?
            var reselect:Boolean = window.isVisible();
            // Tab buttons are the 2nd onward children
            getTabPane().removeChildWindow(window);
            
            // remove button too
            removeButtonForTabContent(window);
            
            if (reselect && (getTabCount() > 0))
                // Select another tab
                setSelectedTab(getTabPane().getChildAt(0).getName());
            
            performChildWindowLayout();
            
            invalidate();
        }
        
        /*************************************************************************
         New event handlers
         *************************************************************************/
        
        /*!
        \brief
        Handler called internally when the currently selected item or items changes.
        */
        protected function onSelectionChanged(e:WindowEventArgs):void
        {
            invalidate();
            fireEvent(EventSelectionChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the window's font is changed.
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the window that triggered the event.  For this
        event the trigger window is always 'this'.
        */
        override protected function onFontChanged(e:WindowEventArgs):void
        {
            // Propagate font change to buttons
            for (var i:uint = 0; i < d_tabButtonVector.length; ++i)
                d_tabButtonVector [i].setFont (getFont ());
        }
        
        
        /*************************************************************************
         Abstract Implementation Functions (must be provided by derived class)
         *************************************************************************/
        /*!
        \brief
        create and return a pointer to a TabButton widget for use as a clickable tab header
        \param name
        Button name
        \return
        Pointer to a TabButton to be used for changing tabs.
        */
        //virtual TabButton*	createTabButton_impl(const String& name) const		= 0;
        
        /*!
        \brief
        Calculate the correct position and size of a tab button, based on the
        index it is due to be placed at.
        \param index
        The index of the tab button
        */
        protected function calculateTabButtonSizePosition(index:uint):void
        {
            var btn:FlameTabButton = d_tabButtonVector [index];
            // relative height is always 1.0 for buttons since they are embedded in a
            // panel of the correct height already
            btn.setHeight(Misc.cegui_reldim(1.0));
            btn.setYPosition(Misc.cegui_absdim(0.0));
            // x position is based on previous button
            if (!index)
                // First button
                btn.setXPosition(Misc.cegui_absdim(d_firstTabOffset));
            else
            {
                var prevButton:FlameWindow = d_tabButtonVector [index - 1];
                
                // position is prev pos + width
                btn.setXPosition(prevButton.getArea().d_max.d_x);
            }
            // Width is based on font size (expressed as absolute)
            var fnt:FlameFont = btn.getFont();
            btn.setWidth(Misc.cegui_absdim(fnt.getTextExtent(btn.getText())).add(getTabTextPadding()).add(getTabTextPadding()));
            
            var left_x:Number = btn.getXPosition ().d_offset;
            btn.setVisible ((left_x < getPixelSize ().d_width) &&
                (left_x + btn.getPixelSize ().d_width > 0));
            btn.invalidate();
        }
        
        /*************************************************************************
         Private methods
         *************************************************************************/
        private function addTabControlProperties():void
        {
            addProperty(d_tabHeightProperty);
            addProperty(d_tabTextPaddingProperty);
            addProperty(d_tabPanePosition);
        }
        
        override protected function addChild_impl(wnd:FlameWindow):void
        {
            // Look for __auto_TabPane__ in the name (hopefully no-one will use this!)
            if (wnd.getName().indexOf(ContentPaneNameSuffix) != -1)
            {
                // perform normal addChild
                super.addChild_impl(wnd);
            }
            else
            {
                // This is another control, therefore add as a tab
                addTab(wnd);
            }
        }
            
        override protected function removeChild_impl(wnd:FlameWindow):void
        {
            // protect against possible null pointers
            if (!wnd) return;
            
            // Look for __auto_TabPane__ in the name (hopefully no-one will use this!)
            if (wnd.getName().indexOf(ContentPaneNameSuffix) != -1)
            {
                // perform normal removeChild
                super.removeChild_impl(wnd);
            }
            else
            {
                // This is some user window, therefore remove as a tab
                removeTab(wnd.getName());
            }
        }
        
        /*************************************************************************
         Event handlers
         *************************************************************************/
        protected function handleContentWindowTextChanged(args:EventArgs):Boolean
        {
            // update text
            const wargs:WindowEventArgs = args as WindowEventArgs;
            var tabButton:FlameWindow = getTabButtonPane().getChildByName(
                makeButtonName(wargs.window));
            tabButton.setText(wargs.window.getText());
            // sort out the layout
            performChildWindowLayout();
            invalidate();
            
            return true;
        }
        
        
        protected function handleTabButtonClicked(args:EventArgs):Boolean
        {
            const wargs:WindowEventArgs = args as WindowEventArgs;
            var tabButton:FlameTabButton  = wargs.window as FlameTabButton;
            setSelectedTab(tabButton.getTargetWindow().getName());
            
            return true;
        }
        
        protected function handleScrollPane(e:EventArgs):Boolean
        {
            const wargs:WindowEventArgs = e as WindowEventArgs;
            
            var i:uint;
            var delta:Number = 0;
            // Find the leftmost visible button
            for (i = 0; i < d_tabButtonVector.length; ++i)
            {
                if (d_tabButtonVector [i].isVisible (true))
                    break;
                delta = d_tabButtonVector [i].getPixelSize ().d_width;
            }
            
            if (wargs.window.getName () == getName() + ButtonScrollLeftSuffix)
            {
                if (delta == 0.0 && i < d_tabButtonVector.length)
                    delta = d_tabButtonVector [i].getPixelSize ().d_width;
                
                // scroll button pane to the right
                d_firstTabOffset += delta;
            }
            else if (i < d_tabButtonVector.length)
                // scroll button pane to left
                d_firstTabOffset -= d_tabButtonVector [i].getPixelSize ().d_width;
            
            performChildWindowLayout();
            return true;
        }
        
        
        protected function handleDraggedPane(e:EventArgs):Boolean
        {
            const me:MouseEventArgs = e as MouseEventArgs;
            
            if (me.button == Consts.MouseButton_MiddleButton)
            {
                // This is the middle-mouse-click event, remember initial drag position
                var but_pane:FlameWindow = getTabButtonPane();
                d_btGrabPos = (me.position.d_x -
                    but_pane.getOuterRectClipper().d_left) -
                    d_firstTabOffset;
            }
            else if (me.button == Consts.MouseButton_NoButton)
            {
                // Regular mouse move event
                but_pane = getTabButtonPane();
                var new_to:Number = (me.position.d_x -
                    but_pane.getOuterRectClipper().d_left) -
                    d_btGrabPos;
                if ((new_to < d_firstTabOffset - 0.9) ||
                    (new_to > d_firstTabOffset + 0.9))
                {
                    d_firstTabOffset = new_to;
                    performChildWindowLayout();
                }
            }
            
            return true;
        }
        
        protected function handleWheeledPane(e:EventArgs):Boolean
        {
            const me:MouseEventArgs = e as MouseEventArgs;
            
            var but_pane:FlameWindow = getTabButtonPane();
            var delta:Number = but_pane.getOuterRectClipper().getWidth () / 20;
            
            d_firstTabOffset -= me.wheelChange * delta;
            performChildWindowLayout();
            
            return true;
        }
        
        
    }
}