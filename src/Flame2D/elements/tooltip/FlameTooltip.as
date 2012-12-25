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
package Flame2D.elements.tooltip
{
    import Flame2D.core.system.FlameEventManager;
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.system.FlameMouseCursor;
    import Flame2D.core.text.FlameRenderedString;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.data.Consts;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.renderer.FlameRenderer;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.UVector2;
    import Flame2D.core.utils.Vector2;

    /*!
    \brief
    Base class for Tooltip widgets.
    
    The Tooltip class shows a simple pop-up window around the mouse position
    with some text information.  The tool-tip fades in when the user hovers
    with the mouse over a window which has tool-tip text set, and then fades
    out after some pre-set time.
    
    \note
    For Tooltip to work properly, you must specify a default tool-tip widget
    type via System::setTooltip, or by setting a custom tool-tip object for
    your Window(s).  Additionally, you need to ensure that time pulses are
    properly passed to the system via System::injectTimePulse.
    */
    public class FlameTooltip extends FlameWindow
    {
        public static const EventNamespace:String = "Tooltip";
        public static const WidgetTypeName:String = "CEGUI/Tooltip";
        
        /** Event fired when the hover timeout for the tool tip gets changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Tooltip whose hover timeout has
         * been changed.
         */
        public static const EventHoverTimeChanged:String = "HoverTimeChanged";
        /** Event fired when the display timeout for the tool tip gets changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Tooltip whose display timeout has
         * been changed.
         */
        public static const EventDisplayTimeChanged:String  = "DisplayTimeChanged";
        /** Event fired when the fade timeout for the tooltip gets changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Tooltip whose fade timeout has
         * been changed.
         */
        public static const EventFadeTimeChanged:String = "FadeTimeChanged";
        /** Event fired when the tooltip is about to get activated.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Tooltip that is about to become
         * active.
         */
        public static const EventTooltipActive:String = "TooltipActive";
        /** Event fired when the tooltip has been deactivated.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Tooltip that has become inactive.
         */
        public static const EventTooltipInactive:String = "TooltipInactive";
        
        /*************************************************************************
         Static Properties for this class
         *************************************************************************/
        private static var d_hoverTimeProperty:TooltipPropertyHoverTime = new TooltipPropertyHoverTime();
        private static var d_displayTimeProperty:TooltipPropertyDisplayTime = new TooltipPropertyDisplayTime();
        private static var d_fadeTimeProperty:TooltipPropertyFadeTime = new TooltipPropertyFadeTime();

        
        /************************************************************************
         Data fields
         ************************************************************************/
        protected var d_state:uint;        //!< Current tooltip state.
        protected var d_elapsed:Number;      //!< Used to track state change timings
        protected var d_target:FlameWindow;     //!< Current target Window for this Tooltip.
        protected var d_hoverTime:Number = 0.4;    //!< tool-tip hover time (seconds mouse must stay stationary before tip shows).
        protected var d_displayTime:Number = 7.5;  //!< tool-tip display time (seconds that tip is showsn for).
        protected var d_fadeTime:Number = 0.33;     //!< tool-tip fade time (seconds it takes for tip to fade in and/or out).
        //! are in positionSelf function? (to avoid infinite recursion issues)
        protected var d_inPositionSelf:Boolean = false;
        
        


        public function FlameTooltip(type:String, name:String)
        {
            super(type, name);
            
            addTooltipProperties();
            
            setClippedByParent(false);
            setDestroyedByParent(false);
            setAlwaysOnTop(true);
            
            // we need updates even when not visible
            setUpdateMode(Consts.WindowUpdateMode_ALWAYS);
            
            switchToInactiveState();
        }
        
        
        
        /************************************************************************
         Public interface
         ************************************************************************/
        /*!
        \brief
        Sets the target window for the tooltip.  This used internally to manage tooltips, you
        should not have to call this yourself.
        
        \param wnd
        Window object that the tooltip should be associated with (for now).
        
        \return
        Nothing.
        */
        public function setTargetWindow(wnd:FlameWindow):void
        {
            if (!wnd)
            {
                d_target = wnd;
            }
            else if (wnd != this)
            {
                if (d_target != wnd)
                {
                    FlameSystem.getSingleton().getGUISheet().addChildWindow(this);
                    d_target = wnd;
                }
                
                // set text to that of the tooltip text of the target
                setText(wnd.getTooltipText());
                
                // set size and potition of the tooltip window.
                sizeSelf();
                positionSelf();
            }
            
            resetTimer(); 
        }
        
        /*!
        \brief
        return the current target window for this Tooltip.
        
        \return
        Pointer to the target window for this Tooltip or 0 for none.
        */
        public function getTargetWindow():FlameWindow
        {
            return d_target;
        }
        
        /*!
        \brief
        Resets the timer on the tooltip when in the Active / Inactive states.  This is used internally
        to control the tooltip, it is not normally necessary to call this method yourself.
        
        \return
        Nothing.
        */
        public function resetTimer():void
        {
            // only do the reset in active / inactive states, this is so that
            // the fades are not messed up by having the timer reset on them.
            if (d_state == Consts.TipState_Active || d_state == Consts.TipState_Inactive)
            {
                d_elapsed = 0;
            }
        }
        
        /*!
        \brief
        Return the number of seconds the mouse should hover stationary over the target window before
        the tooltip gets activated.
        
        \return
        float value representing a number of seconds.
        */
        public function getHoverTime():Number
        {
            return d_hoverTime;
        }
        
        /*!
        \brief
        Set the number of seconds the tooltip should be displayed for before it automatically
        de-activates itself.  0 indicates that the tooltip should never timesout and auto-deactivate.
        
        \param seconds
        float value representing a number of seconds.
        
        \return
        Nothing.
        */
        public function setDisplayTime(seconds:Number):void
        {
            if (d_displayTime != seconds)
            {
                d_displayTime = seconds;
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onDisplayTimeChanged(args);
            }
        }
        
        /*!
        \brief
        Return the number of seconds that should be taken to fade the tooltip into and out of
        visibility.
        
        \return
        float value representing a number of seconds.
        */
        public function getFadeTime():Number
        {
            return d_fadeTime;
        }
        
        /*!
        \brief
        Set the number of seconds the mouse should hover stationary over the target window before
        the tooltip gets activated.
        
        \param seconds
        float value representing a number of seconds.
        
        \return
        Nothing.
        */
        public function setHoverTime(seconds:Number):void
        {
            if (d_hoverTime != seconds)
            {
                d_hoverTime = seconds;
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onHoverTimeChanged(args);
            }
        }
        
        /*!
        \brief
        Return the number of seconds the tooltip should be displayed for before it automatically
        de-activates itself.  0 indicates that the tooltip never timesout and auto-deactivates.
        
        \return
        float value representing a number of seconds.
        */
        public function getDisplayTime():Number
        {
            return d_displayTime;
        }
        
        /*!
        \brief
        Set the number of seconds that should be taken to fade the tooltip into and out of
        visibility.
        
        \param seconds
        float value representing a number of seconds.
        
        \return
        Nothing.
        */
        public function setFadeTime(seconds:Number):void
        {
            if (d_fadeTime != seconds)
            {
                d_fadeTime = seconds;
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onFadeTimeChanged(args);
            }
        }
        
        /*!
        \brief
        Causes the tooltip to position itself appropriately.
        
        \return
        Nothing.
        */
        public function positionSelf():void
        {
            // no recusion allowed for this function!
            if (d_inPositionSelf)
                return;
            
            d_inPositionSelf = true;
            
            var cursor:FlameMouseCursor = FlameMouseCursor.getSingleton();
            var screen:Rect = new Rect(0, 0, 
                FlameSystem.getSingleton().getRenderer().getDisplayWidth(),
                FlameSystem.getSingleton().getRenderer().getDisplayHeight());
            var tipRect:Rect = getUnclippedOuterRect();
            const mouseImage:FlameImage = cursor.getImage();
            
            var mousePos:Vector2 = cursor.getPosition();
            var mouseSz:Size = new Size(0,0);
            
            if (mouseImage)
            {
                mouseSz = mouseImage.getSize();
            }
            
            var tmpPos:Vector2 = new Vector2(mousePos.d_x + mouseSz.d_width, mousePos.d_y + mouseSz.d_height);
            tipRect.setPosition(tmpPos);
            
            // if tooltip would be off the right of the screen,
            // reposition to the other side of the mouse cursor.
            if (screen.d_right < tipRect.d_right)
            {
                tmpPos.d_x = mousePos.d_x - tipRect.getWidth() - 5;
            }
            
            // if tooltip would be off the bottom of the screen,
            // reposition to the other side of the mouse cursor.
            if (screen.d_bottom < tipRect.d_bottom)
            {
                tmpPos.d_y = mousePos.d_y - tipRect.getHeight() - 5;
            }
            
            // set final position of tooltip window.
            setPosition(
                new UVector2(Misc.cegui_absdim(tmpPos.d_x),
                    Misc.cegui_absdim(tmpPos.d_y)));
            
            d_inPositionSelf = false;
        }
        
        /*!
        \brief
        Causes the tooltip to resize itself appropriately.
        
        \return
        Nothing.
        */
        public function sizeSelf():void
        {
            var textSize:Size = getTextSize();
            
            setSize(
                new UVector2(Misc.cegui_absdim(textSize.d_width),
                    Misc.cegui_absdim(textSize.d_height)));
        }
        
        /*!
        \brief
        Return the size of the area that will be occupied by the tooltip text, given
        any current formatting options.
        
        \return
        Size object describing the size of the rendered tooltip text in pixels.
        */
        public function getTextSize():Size
        {
            if (d_windowRenderer != null)
            {
                var wr:TooltipWindowRenderer = d_windowRenderer as TooltipWindowRenderer;
                return wr.getTextSize();
            }
            else
            {
                return getTextSize_impl();
            }
        }
        
        /*!
        \brief
        Return the size of the area that will be occupied by the tooltip text, given
        any current formatting options.
        
        \return
        Size object describing the size of the rendered tooltip text in pixels.
        */
        public function getTextSize_impl():Size
        {
            const rs:FlameRenderedString = getRenderedString();
            var sz:Size = new Size(0.0, 0.0);
           
            for (var i:uint = 0; i < rs.getLineCount(); ++i)
            {
                const line_sz:Size = rs.getPixelSize(i);
                sz.d_height += line_sz.d_height;
                
                if (line_sz.d_width > sz.d_width)
                    sz.d_width = line_sz.d_width;
            }
            
            return sz;
        }
        
        
        
        /*************************************************************************
         Implementation Methods
         *************************************************************************/
        // methods to perform processing for each of the widget states
        protected function doActiveState(elapsed:Number):void
        {
            // if no target, switch immediately to inactive state.
            if (!d_target || d_target.getTooltipText().length == 0)
            {
                switchToInactiveState();
            }
                // else see if display timeout has been reached
            else if ((d_displayTime > 0) && ((d_elapsed += elapsed) >= d_displayTime))
            {
                // display time is up, switch states
                switchToFadeOutState();
            }
        }
        
        protected function doInactiveState(elapsed:Number):void
        {
            if (d_target && !d_target.getTooltipText().length == 0 && ((d_elapsed += elapsed) >= d_hoverTime))
            {
                switchToFadeInState();
            }
        }
        
        protected function doFadeInState(elapsed:Number):void
        {
            // if no target, switch immediately to inactive state.
            if (!d_target || d_target.getTooltipText().length == 0)
            {
                switchToInactiveState();
            }
            else
            {
                if ((d_elapsed += elapsed) >= d_fadeTime)
                {
                    setAlpha(1.0);
                    switchToActiveState();
                }
                else
                {
                    setAlpha((1.0 / d_fadeTime) * d_elapsed);
                }
            }
        }
        
        protected function doFadeOutState(elapsed:Number):void
        {
            // if no target, switch immediately to inactive state.
            if (!d_target || d_target.getTooltipText().length == 0)
            {
                switchToInactiveState();
            }
            else
            {
                if ((d_elapsed += elapsed) >= d_fadeTime)
                {
                    setAlpha(0.0);
                    switchToInactiveState();
                }
                else
                {
                    setAlpha(1.0 - (1.0 / d_fadeTime) * d_elapsed);
                }
            }
        }
        
        // methods to switch widget states
        protected function switchToInactiveState():void
        {
            setAlpha(0.0);
            d_state = Consts.TipState_Inactive;
            d_elapsed = 0;
            
            if (d_parent)
                d_parent.removeChildWindow(this);
            
            // fire event before target gets reset in case that information is required in handler.
            var args:WindowEventArgs = new WindowEventArgs(this);
            onTooltipInactive(args);
            
            d_target = null;
            hide();
        }
        
        
        protected function switchToActiveState():void
        {
            d_state = Consts.TipState_Active;
            d_elapsed = 0;
        }
        
        protected function switchToFadeInState():void
        {
            positionSelf();
            d_state = Consts.TipState_FadeIn;
            d_elapsed = 0;
            show();
            
            // fire event.  Not really active at the moment, but this is the "right" time
            // for this event (just prior to anything getting displayed).
            var args:WindowEventArgs = new WindowEventArgs(this);
            onTooltipActive(args);
        }
        
        protected function switchToFadeOutState():void
        {
            d_state = Consts.TipState_FadeOut;
            d_elapsed = 0;
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
            if (class_name=="Tooltip")	return true;
            return super.testClassName_impl(class_name);
        }
        
        // validate window renderer
        protected function validateWindowRenderer(name:String):Boolean
        {
            return (name == "Tooltip");
        }
        
        /*************************************************************************
         Event triggers
         *************************************************************************/
        /*!
        \brief
        Event trigger method called when the hover timeout gets changed.
        
        \param e
        WindowEventArgs object.
        
        \return
        Nothing.
        */
        protected function onHoverTimeChanged(e:WindowEventArgs):void
        {
            fireEvent(EventHoverTimeChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Event trigger method called when the display timeout gets changed.
        
        \param e
        WindowEventArgs object.
        
        \return
        Nothing.
        */
        protected function onDisplayTimeChanged(e:WindowEventArgs):void
        {
            fireEvent(EventDisplayTimeChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Event trigger method called when the fade timeout gets changed.
        
        \param e
        WindowEventArgs object.
        
        \return
        Nothing.
        */
        protected function onFadeTimeChanged(e:WindowEventArgs):void
        {
            fireEvent(EventFadeTimeChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Event trigger method called just before the tooltip becomes active.
        
        \param e
        WindowEventArgs object.
        
        \return
        Nothing.
        */
        protected function onTooltipActive(e:WindowEventArgs):void
        {
            fireEvent(EventTooltipActive, e, EventNamespace);
        }
        
        /*!
        \brief
        Event trigger method called just after the tooltip is deactivated.
        
        \param e
        WindowEventArgs object.
        
        \return
        Nothing.
        */
        protected function onTooltipInactive(e:WindowEventArgs):void
        {
            fireEvent(EventTooltipInactive, e, EventNamespace);
        }
        
        
        /************************************************************************
         Overridden from Window.
         ************************************************************************/
        override protected function updateSelf(elapsed:Number):void
        {
            // base class processing.
            super.updateSelf(elapsed);
            
            // do something based upon current Tooltip state.
            switch (d_state)
            {
                case Consts.TipState_Inactive:
                    doInactiveState(elapsed);
                    break;
                
                case Consts.TipState_Active:
                    doActiveState(elapsed);
                    break;
                
                case Consts.TipState_FadeIn:
                    doFadeInState(elapsed);
                    break;
                
                case Consts.TipState_FadeOut:
                    doFadeOutState(elapsed);
                    break;
                
                default:
                    // This should never happen.
                    trace("Tooltip (Name: " + getName() + "of Class: " + getType() + ") is in an unknown state.  Switching to Inactive state.");
                    switchToInactiveState();
            }
        }
        
        override public function onMouseEnters(e:MouseEventArgs):void
        {
            positionSelf();
            
            super.onMouseEnters(e);
        }
        
        override protected function onTextChanged(e:WindowEventArgs):void
        {
            // base class processing
            super.onTextChanged(e);
            
            // set size and potition of the tooltip window to consider new text
            sizeSelf();
            positionSelf();
            
            // we do not signal we handled it, in case user wants to hear
            // about text changes too.
        }

        /*************************************************************************
         Private methods
         *************************************************************************/
        private function addTooltipProperties():void
        {
            addProperty(d_hoverTimeProperty);
            addProperty(d_displayTimeProperty);
            addProperty(d_fadeTimeProperty);
        }
    }
}