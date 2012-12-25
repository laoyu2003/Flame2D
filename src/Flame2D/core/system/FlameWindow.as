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
package Flame2D.core.system
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.data.RenderingContext;
    import Flame2D.core.events.ActivationEventArgs;
    import Flame2D.core.events.DragDropEventArgs;
    import Flame2D.core.events.KeyEventArgs;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.UpdateEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.falagard.FalagardPropertyInitialiser;
    import Flame2D.core.falagard.FalagardWidgetComponent;
    import Flame2D.core.falagard.FalagardWidgetLookFeel;
    import Flame2D.core.falagard.FalagardWidgetLookManager;
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.properties.PropertyAbsoluteHeight;
    import Flame2D.core.properties.PropertyAbsoluteMaxSize;
    import Flame2D.core.properties.PropertyAbsoluteMinSize;
    import Flame2D.core.properties.PropertyAbsolutePosition;
    import Flame2D.core.properties.PropertyAbsoluteRect;
    import Flame2D.core.properties.PropertyAbsoluteSize;
    import Flame2D.core.properties.PropertyAbsoluteWidth;
    import Flame2D.core.properties.PropertyAbsoluteXPosition;
    import Flame2D.core.properties.PropertyAbsoluteYPosition;
    import Flame2D.core.properties.PropertyAlpha;
    import Flame2D.core.properties.PropertyAlwaysOnTop;
    import Flame2D.core.properties.PropertyAutoRenderingSurface;
    import Flame2D.core.properties.PropertyAutoRepeatDelay;
    import Flame2D.core.properties.PropertyAutoRepeatRate;
    import Flame2D.core.properties.PropertyClippedByParent;
    import Flame2D.core.properties.PropertyCustomTooltipType;
    import Flame2D.core.properties.PropertyDestroyedByParent;
    import Flame2D.core.properties.PropertyDisabled;
    import Flame2D.core.properties.PropertyDistributeCapturedInputs;
    import Flame2D.core.properties.PropertyDragDropTarget;
    import Flame2D.core.properties.PropertyFont;
    import Flame2D.core.properties.PropertyHeight;
    import Flame2D.core.properties.PropertyHookMode;
    import Flame2D.core.properties.PropertyHookPosition;
    import Flame2D.core.properties.PropertyHorizontalAlignment;
    import Flame2D.core.properties.PropertyID;
    import Flame2D.core.properties.PropertyInheritsAlpha;
    import Flame2D.core.properties.PropertyInheritsTooltipText;
    import Flame2D.core.properties.PropertyLookNFeel;
    import Flame2D.core.properties.PropertyMargin;
    import Flame2D.core.properties.PropertyMaskImage;
    import Flame2D.core.properties.PropertyMetricsMode;
    import Flame2D.core.properties.PropertyMouseButtonDownAutoRepeat;
    import Flame2D.core.properties.PropertyMouseCursorImage;
    import Flame2D.core.properties.PropertyMouseHollow;
    import Flame2D.core.properties.PropertyMouseInputPropagationEnabled;
    import Flame2D.core.properties.PropertyMouseLButtonHollow;
    import Flame2D.core.properties.PropertyMouseMoveHollow;
    import Flame2D.core.properties.PropertyMousePassThroughEnabled;
    import Flame2D.core.properties.PropertyMouseRButtonHollow;
    import Flame2D.core.properties.PropertyNonClient;
    import Flame2D.core.properties.PropertyPosition;
    import Flame2D.core.properties.PropertyRect;
    import Flame2D.core.properties.PropertyRelativeHeight;
    import Flame2D.core.properties.PropertyRelativeMaxSize;
    import Flame2D.core.properties.PropertyRelativeMinSize;
    import Flame2D.core.properties.PropertyRelativePosition;
    import Flame2D.core.properties.PropertyRelativeRect;
    import Flame2D.core.properties.PropertyRelativeSize;
    import Flame2D.core.properties.PropertyRelativeWidth;
    import Flame2D.core.properties.PropertyRelativeXPosition;
    import Flame2D.core.properties.PropertyRelativeYPosition;
    import Flame2D.core.properties.PropertyRestoreOldCapture;
    import Flame2D.core.properties.PropertyRiseOnClick;
    import Flame2D.core.properties.PropertyRotation;
    import Flame2D.core.properties.PropertySize;
    import Flame2D.core.properties.PropertyText;
    import Flame2D.core.properties.PropertyTextOriginal;
    import Flame2D.core.properties.PropertyTextParsingEnabled;
    import Flame2D.core.properties.PropertyTooltip;
    import Flame2D.core.properties.PropertyUnifiedAreaRect;
    import Flame2D.core.properties.PropertyUnifiedHeight;
    import Flame2D.core.properties.PropertyUnifiedMaxSize;
    import Flame2D.core.properties.PropertyUnifiedMinSize;
    import Flame2D.core.properties.PropertyUnifiedPosition;
    import Flame2D.core.properties.PropertyUnifiedSize;
    import Flame2D.core.properties.PropertyUnifiedWidth;
    import Flame2D.core.properties.PropertyUnifiedXPosition;
    import Flame2D.core.properties.PropertyUnifiedYPosition;
    import Flame2D.core.properties.PropertyUpdateMode;
    import Flame2D.core.properties.PropertyVerticalAlignment;
    import Flame2D.core.properties.PropertyVisible;
    import Flame2D.core.properties.PropertyWantsMultiClickEvents;
    import Flame2D.core.properties.PropertyWidth;
    import Flame2D.core.properties.PropertyWindowRenderer;
    import Flame2D.core.properties.PropertyXPosition;
    import Flame2D.core.properties.PropertyXRotation;
    import Flame2D.core.properties.PropertyYPosition;
    import Flame2D.core.properties.PropertyYRotation;
    import Flame2D.core.properties.PropertyZOrderChangeEnabled;
    import Flame2D.core.properties.PropertyZRotation;
    import Flame2D.core.properties.PropertyZoomMode;
    import Flame2D.core.sound.FlameSoundManager;
    import Flame2D.core.sound.PropertySoundHide;
    import Flame2D.core.sound.PropertySoundHover;
    import Flame2D.core.sound.PropertySoundLClick;
    import Flame2D.core.sound.PropertySoundLDoubleClick;
    import Flame2D.core.sound.PropertySoundRClick;
    import Flame2D.core.sound.PropertySoundShow;
    import Flame2D.core.text.FlameBasicRenderedStringParser;
    import Flame2D.core.text.FlameDefaultRenderedStringParser;
    import Flame2D.core.text.FlameRenderedString;
    import Flame2D.core.text.FlameRenderedStringParser;
    import Flame2D.core.utils.CoordConverter;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.UBox;
    import Flame2D.core.utils.UDim;
    import Flame2D.core.utils.URect;
    import Flame2D.core.utils.UVector2;
    import Flame2D.core.utils.Vector2;
    import Flame2D.core.utils.Vector3;
    import Flame2D.elements.button.FlameCheckbox;
    import Flame2D.elements.dnd.FlameDragContainer;
    import Flame2D.elements.tooltip.FlameTooltip;
    import Flame2D.renderer.FlameGeometryBuffer;
    import Flame2D.renderer.FlameRenderer;
    import Flame2D.renderer.FlameTextureTarget;
    
    import flash.events.EventDispatcher;
    import flash.geom.Vector3D;
    import flash.utils.Dictionary;
    
    public class FlameWindow extends FlameEventSet
    {
        public static const TooltipNameSuffix:String            = "__auto_tooltip__";
        public static const AutoWidgetNameSuffix:String         = "__auto_";
        

        public static const EventNamespace:String				= "Window";
        // generated internally by Window
        /** Event fired as part of the time based update of the window.
         * Handlers are passed a const UpdateEventArgs reference.
         */
        public static const EventWindowUpdated :String			= "WindowUpdate";
        /** Event fired when the parent of this Window has been re-sized.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window pointing to the <em>parent window</em> that
         * was resized, not the window whose parent was resized.
         */
        public static const EventParentSized:String				= "ParentSized";
        /** Event fired when the Window size has changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Window whose size was changed.
         */
        public static const EventSized:String					= "Sized";
        /** Event fired when the Window position has changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Window whose position was changed.
         */
        public static const EventMoved:String					= "Moved";
        /** Event fired when the text string for the Window has changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Window whose text was changed.
         */
        public static const EventTextChanged:String				= "TextChanged";
        /** Event fired when the Font object for the Window has been changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Window whose font was changed.
         */
        public static const EventFontChanged:String				= "FontChanged";
        /** Event fired when the Alpha blend value for the Window has changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Window whose alpha value was changed.
         */
        public static const EventAlphaChanged:String			= "AlphaChanged";
        /** Event fired when the client assigned ID for the Window has changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Window whose ID was changed.
         */
        public static const EventIDChanged:String				= "IDChanged";
        /** Event fired when the Window has been activated and has input focus.
         * Handlers are passed a const ActivationEventArgs reference with
         * WindowEventArgs::window set to the Window that is gaining activation and
         * ActivationEventArgs::otherWindow set to the Window that is losing
         * activation (may be 0).
         */
        public static const EventActivated:String				= "Activated";
        /** Event fired when the Window has been deactivated, losing input focus.
         * Handlers are passed a const ActivationEventArgs reference with
         * WindowEventArgs::window set to the Window that is losing activation and
         * ActivationEventArgs::otherWindow set to the Window that is gaining
         * activation (may be 0).
         */
        public static const EventDeactivated:String				= "Deactivated";
        /** Event fired when the Window is shown (made visible).
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Window that was shown.
         */
        public static const EventShown:String					= "Shown";
        /** Event fired when the Window is made hidden.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Window that was hidden.
         */
        public static const EventHidden:String					= "Hidden";
        /** Event fired when the Window is enabled so interaction is possible.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Window that was enabled.
         */
        public static const EventEnabled:String					= "Enabled";
        /** Event fired when the Window is disabled and interaction is no longer
         * possible.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Window that was disabled.
         */
        public static const EventDisabled:String				= "Disabled";
        /** Event fired when the Window clipping mode is modified.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Window whose clipping mode was
         * changed.
         */
        public static const EventClippedByParentChanged:String	= "ClippingChanged";
        /** Event fired when the Window destruction mode is modified.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Window whose destruction mode was
         * changed.
         */
        public static const EventDestroyedByParentChanged:String= "DestroyedByParentChanged";
        /** Event fired when the Window mode controlling inherited alpha is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Window whose alpha inheritence mode
         * was changed.
         */
        public static const EventInheritsAlphaChanged:String	= "InheritAlphaChanged";
        /** Event fired when the always on top setting for the Window is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Window whose always on top setting
         * was changed.
         */
        public static const EventAlwaysOnTopChanged:String		= "AlwaysOnTopChanged";
        /** Event fired when the Window gains capture of mouse inputs.
         * Handlers are passed a cont WindowEventArgs reference with
         * WindowEventArgs::window set to the Window that has captured mouse inputs.
         */
        public static const EventInputCaptureGained:String		= "CaptureGained";
        /** Event fired when rendering of the Window has started.  In this context
         * 'rendering' is the population of the GeometryBuffer with geometry for the
         * window, not the actual rendering of that GeometryBuffer content to the 
         * display.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Window whose rendering has started.
         */
        public static const EventInputCaptureLost:String		= "CaptureLost";
        /** Event fired when rendering of the Window has started.  In this context
         * 'rendering' is the population of the GeometryBuffer with geometry for the
         * window, not the actual rendering of that GeometryBuffer content to the 
         * display.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Window whose rendering has started.
         */
        public static const EventRenderingStarted:String		= "StartRender";
        /** Event fired when rendering of the Window has ended.  In this context
         * 'rendering' is the population of the GeometryBuffer with geometry for the
         * window, not the actual rendering of that GeometryBuffer content to the 
         * display.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Window whose rendering has ended.
         */
        public static const EventRenderingEnded:String			= "EndRender";
        /** Event fired when a child Window has been added.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the child window that was added.
         */
        public static const EventChildAdded:String				= "AddedChild";
        /** Event fired when a child window has been removed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the child window that was removed.
         */
        public static const EventChildRemoved:String			= "RemovedChild";
        /** Event fired when destruction of the Window is about to begin.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Window that is about to be destroyed.
         */
        public static const EventDestructionStarted:String		= "DestructStart";
        /** Event fired when the z-order of the window has changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Window whose z order position has
         * changed.
         */
        public static const EventZOrderChanged:String			= "ZChanged";
        /** Event fired when a DragContainer is dragged in to the window's area.
         * Handlers are passed a const DragDropEventArgs reference with
         * WindowEventArgs::window set to the window over which a DragContainer has
         * been dragged (the receiving window) and DragDropEventArgs::dragDropItem
         * set to the DragContainer that was dragged in to the receiving window's
         * area.
         */
        public static const EventDragDropItemEnters:String		= "DragDropItemEnters";
        /** Event fired when a DragContainer is dragged out of the window's area.
         * Handlers are passed a const DragDropEventArgs reference with
         * WindowEventArgs::window set to the window over which a DragContainer has
         * been dragged out of (the receiving window) and
         * DragDropEventArgs::dragDropItem set to the DragContainer that was dragged
         * out of the receiving window's area.
         */
        public static const EventDragDropItemLeaves:String		= "DragDropItemLeaves";
        /** Event fired when a DragContainer is dropped within the window's area.
         * Handlers are passed a const DragDropEventArgs reference with
         * WindowEventArgs::window set to the window over which a DragContainer was
         * dropped (the receiving window) and DragDropEventArgs::dragDropItem set to
         * the DragContainer that was dropped within the receiving window's area.
         */
        public static const EventDragDropItemDropped:String		= "DragDropItemDropped";
        /** Event fired when the vertical alignment for the window is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the window whose vertical alignment
         * setting was changed.
         */
        public static const EventVerticalAlignmentChanged:String= "VerticalAlignmentChanged";
        /** Event fired when the horizontal alignment for the window is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the window whose horizontal alignment
         * setting was changed.
         */
        public static const EventHorizontalAlignmentChanged:String	= "HorizontalAlignmentChanged";
        /** Event fired when a WindowRenderer object is attached to the window.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the window that had the WindowRenderer
         * attached to it.
         */
        public static const EventWindowRendererAttached:String	= "WindowRendererAttached";
        /** Event fired when a WindowRenderer object is detached from the window.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the window that had the WindowRenderer
         * detached from it.
         */
        public static const EventWindowRendererDetached:String	= "WindowRendererDetached";
        /** Event fired whrn the rotation factor(s) for the window are changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Window whose rotation was changed.
         */
        public static const EventRotated:String					= "Rotated";
        /** Event fired when the non-client setting for the Window is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Window whose non-client setting was
         * changed.
         */
        public static const EventNonClientChanged:String		= "NonClientChanged";
        /** Event fired when the Window's setting controlling parsing of it's text
         * string is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Window whose text parsing setting was
         * changed.
         */
        public static const EventTextParsingChanged:String		= "TextParsingChanged";
        /** Event fired when the Window's margin has changed (any of the four margins)
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Window whose margin was
         * changed.
         */
        public static const EventMarginChanged:String			= "MarginChanged";
        // generated externally (inputs)
        /** Event fired when the mouse cursor has entered the Window's area.
         * Handlers are passed a const MouseEventArgs reference with all fields
         * valid.
         */
        public static const EventMouseEntersArea:String			= "MouseEntersArea";
        /** Event fired when themouse cursor has left the Window's area.
         * Handlers are passed a const MouseEventArgs reference with all fields
         * valid.
         */
        public static const EventMouseLeavesArea:String			= "MouseLeavesArea";
        /** Event fired when the mouse cursor enters the Window's area.
         * Handlers are passed a const MouseEventArgs reference with all fields
         * valid.
         *\note This event is fired if - and only if - the mouse cursor is actually
         * over some part of this Window's surface area, and will not fire for
         * example if the location of the mouse is over some child window (even
         * though the mouse is technically also within the area of this Window).
         * For an alternative version of this event see the
         * Window::EventMouseEntersArea event.
         */
        public static const EventMouseEnters:String				= "MouseEnter";
        /** Event fired when the mouse cursor is no longer over the Window's surface
         * area.
         * Handlers are passed a const MouseEventArgs reference with all fields
         * valid.
         *\note This event will fire whenever the mouse is no longer actually over
         * some part of this Window's surface area, for example if the mouse is
         * moved over some child window (even though technically the mouse has not
         * actually 'left' this Window's area).  For an alternative version of this
         * event see the Window::EventMouseLeavesArea event.
         */
        public static const EventMouseLeaves:String				= "MouseLeave";
        /** Event fired when the mouse cursor moves within the area of the Window.
         * Handlers are passed a const MouseEventArgs reference with all fields
         * valid.
         */
        public static const EventMouseMove:String				= "MouseMove";
        /** Event fired when the mouse wheel is scrolled when the mouse cursor is
         * within the Window's area.
         * Handlers are passed a const MouseEventArgs reference with all fields
         * valid.
         */
        public static const EventMouseWheel:String				= "MouseWheel";
        /** Event fired when a mouse button is pressed down within the Window.
         * Handlers are passed a const MouseEventArgs reference with all fields
         * valid.
         */
        public static const EventMouseButtonDown:String			= "MouseButtonDown";
        /** Event fired when a mouse button is released within the Window.
         * Handlers are passed a const MouseEventArgs reference with all fields
         * valid.
         */
        public static const EventMouseButtonUp:String			= "MouseButtonUp";
        /** Event fired when a mouse button is clicked - that is, pressed down and
         * released within a specific time interval - while the mouse cursor is
         * within the Window's area.
         * Handlers are passed a const MouseEventArgs reference with all fields
         * valid.
         */
        public static const EventMouseClick:String				= "MouseClick";
        /** Event fired when a mouse button is double-clicked while the mouse cursor
         * is within the Window's area.
         * Handlers are passed a const MouseEventArgs reference with all fields
         * valid.
         */
        public static const EventMouseDoubleClick:String		= "MouseDoubleClick";
        /** Event fired when a mouse button is triple-clicked while the mouse cursor
         * is within the Window's area.
         * Handlers are passed a const MouseEventArgs reference with all fields
         * valid.
         */
        public static const EventMouseTripleClick:String		= "MouseTripleClick";
        /** Event fired when a key on the keyboard was pressed down while the window
         * had input focus.
         * Handlers are passed a const KeyEventArgs reference with
         * WindowEventArgs::window set to the Window receiving the key press,
         * KeyEventArgs::scancode set to the Key::Scan value of the key that was
         * pressed, and KeyEventArgs::sysKeys set to the combination of ::SystemKey
         * values active when the key was pressed.
         */
        public static const EventKeyDown:String					= "KeyDown";
        /** Event fired when a key on the keyboard was released while the window
         * had input focus.
         * Handlers are passed a const KeyEventArgs reference with
         * WindowEventArgs::window set to the Window receiving the key release,
         * KeyEventArgs::scancode set to the Key::Scan value of the key that was
         * released, and KeyEventArgs::sysKeys set to the combination of ::SystemKey
         * values active when the key was released.
         */
        public static const EventKeyUp:String					= "KeyUp";
        /** Event fired when the Window receives a character key input event.
         * Handlers are passed a const KeyEventArgs reference with
         * WindowEventArgs::window set to the Window receiving the character input,
         * KeyEventArgs::codepoint set to the Unicode UTF32 / UCS-4 value for the
         * input, and KeyEventArgs::sysKeys set to the combination of ::SystemKey
         * values active when the character input was received.
         */
        public static const EventCharacterKey:String			= "CharacterKey";
        
        

        //properties
        protected static var d_absHeightProperty:PropertyAbsoluteHeight          = new PropertyAbsoluteHeight();
        protected static var d_absMaxSizeProperty:PropertyAbsoluteMaxSize        = new PropertyAbsoluteMaxSize();
        protected static var d_absMinSizeProperty:PropertyAbsoluteMinSize        = new PropertyAbsoluteMinSize();
        protected static var d_absPositionProperty:PropertyAbsolutePosition      = new PropertyAbsolutePosition();
        protected static var d_absRectProperty:PropertyAbsoluteRect              = new PropertyAbsoluteRect();
        protected static var d_absSizeProperty:PropertyAbsoluteSize              = new PropertyAbsoluteSize();
        protected static var d_absWidthProperty:PropertyAbsoluteWidth            = new PropertyAbsoluteWidth();
        protected static var d_absXPosProperty:PropertyAbsoluteXPosition         = new PropertyAbsoluteXPosition();
        protected static var d_absYPosProperty:PropertyAbsoluteYPosition         = new PropertyAbsoluteYPosition();
        protected static var d_alphaProperty:PropertyAlpha                       = new PropertyAlpha();
        protected static var d_alwaysOnTopProperty:PropertyAlwaysOnTop           = new PropertyAlwaysOnTop();
        protected static var d_clippedByParentProperty:PropertyClippedByParent   = new PropertyClippedByParent();
        protected static var d_destroyedByParentProperty:PropertyDestroyedByParent = new PropertyDestroyedByParent();
        protected static var d_disabledProperty:PropertyDisabled                 = new PropertyDisabled();
        protected static var d_fontProperty:PropertyFont                         = new PropertyFont();
        protected static var d_heightProperty:PropertyHeight                     = new PropertyHeight();
        protected static var d_IDProperty:PropertyID                             = new PropertyID();
        protected static var d_inheritsAlphaProperty:PropertyInheritsAlpha       = new PropertyInheritsAlpha();
        protected static var d_metricsModeProperty:PropertyMetricsMode           = new PropertyMetricsMode();
        protected static var d_mouseCursorProperty:PropertyMouseCursorImage      = new PropertyMouseCursorImage();
        protected static var d_positionProperty:PropertyPosition                 = new PropertyPosition();
        protected static var d_rectProperty:PropertyRect                         = new PropertyRect();
        protected static var d_relHeightProperty:PropertyRelativeHeight          = new PropertyRelativeHeight();
        protected static var d_relMaxSizeProperty:PropertyRelativeMaxSize        = new PropertyRelativeMaxSize();
        protected static var d_relMinSizeProperty:PropertyRelativeMinSize        = new PropertyRelativeMinSize();
        protected static var d_relPositionProperty:PropertyRelativePosition      = new PropertyRelativePosition();
        protected static var d_relRectProperty:PropertyRelativeRect              = new PropertyRelativeRect();
        protected static var d_relSizeProperty:PropertyRelativeSize              = new PropertyRelativeSize();
        protected static var d_relWidthProperty:PropertyRelativeWidth            = new PropertyRelativeWidth();
        protected static var d_relXPosProperty:PropertyRelativeXPosition         = new PropertyRelativeXPosition();
        protected static var d_relYPosProperty:PropertyRelativeYPosition         = new PropertyRelativeYPosition();
        protected static var d_restoreOldCaptureProperty:PropertyRestoreOldCapture = new PropertyRestoreOldCapture();
        protected static var d_sizeProperty:PropertySize                         = new PropertySize();
        protected static var d_textOriginalProperty:PropertyTextOriginal         = new PropertyTextOriginal();
        protected static var d_textProperty:PropertyText                         = new PropertyText();
        protected static var d_visibleProperty:PropertyVisible                   = new PropertyVisible();
        protected static var d_widthProperty:PropertyWidth                       = new PropertyWidth();
        protected static var d_xPosProperty:PropertyXPosition                    = new PropertyXPosition();
        protected static var d_yPosProperty:PropertyYPosition                    = new PropertyYPosition();
        protected static var d_zOrderChangeProperty:PropertyZOrderChangeEnabled  = new PropertyZOrderChangeEnabled();
        protected static var d_wantsMultiClicksProperty:PropertyWantsMultiClickEvents = new PropertyWantsMultiClickEvents();
        protected static var d_autoRepeatProperty:PropertyMouseButtonDownAutoRepeat = new PropertyMouseButtonDownAutoRepeat();
        protected static var d_autoRepeatDelayProperty:PropertyAutoRepeatDelay   = new PropertyAutoRepeatDelay();
        protected static var d_autoRepeatRateProperty:PropertyAutoRepeatRate     = new PropertyAutoRepeatRate();
        protected static var d_distInputsProperty:PropertyDistributeCapturedInputs = new PropertyDistributeCapturedInputs();
        protected static var d_tooltipTypeProperty:PropertyCustomTooltipType     = new PropertyCustomTooltipType();
        protected static var d_tooltipProperty:PropertyTooltip                   = new PropertyTooltip();
        protected static var d_inheritsTooltipProperty:PropertyInheritsTooltipText = new PropertyInheritsTooltipText();
        protected static var d_riseOnClickProperty:PropertyRiseOnClick           = new PropertyRiseOnClick();
        protected static var d_vertAlignProperty:PropertyVerticalAlignment       = new PropertyVerticalAlignment();
        protected static var d_horzAlignProperty:PropertyHorizontalAlignment     = new PropertyHorizontalAlignment();
        protected static var d_unifiedAreaRectProperty:PropertyUnifiedAreaRect   = new PropertyUnifiedAreaRect();
        protected static var d_unifiedPositionProperty:PropertyUnifiedPosition   = new PropertyUnifiedPosition();
        protected static var d_unifiedXPositionProperty:PropertyUnifiedXPosition = new PropertyUnifiedXPosition();
        protected static var d_unifiedYPositionProperty:PropertyUnifiedYPosition = new PropertyUnifiedYPosition();
        protected static var d_unifiedSizeProperty:PropertyUnifiedSize           = new PropertyUnifiedSize();
        protected static var d_unifiedWidthProperty:PropertyUnifiedWidth         = new PropertyUnifiedWidth();
        protected static var d_unifiedHeightProperty:PropertyUnifiedHeight       = new PropertyUnifiedHeight();
        protected static var d_unifiedMinSizeProperty:PropertyUnifiedMinSize     = new PropertyUnifiedMinSize();
        protected static var d_unifiedMaxSizeProperty:PropertyUnifiedMaxSize     = new PropertyUnifiedMaxSize();
        protected static var d_zoomModeProperty:PropertyZoomMode                 = new PropertyZoomMode();
        protected static var d_hookPositionProperty:PropertyHookPosition         = new PropertyHookPosition();
        protected static var d_hookModeProperty:PropertyHookMode                 = new PropertyHookMode();
        protected static var d_maskImageProperty:PropertyMaskImage               = new PropertyMaskImage();
        protected static var d_mousePassThroughEnabledProperty:PropertyMousePassThroughEnabled = new PropertyMousePassThroughEnabled();
        protected static var d_windowRendererProperty:PropertyWindowRenderer     = new PropertyWindowRenderer();
        protected static var d_lookNFeelProperty:PropertyLookNFeel               = new PropertyLookNFeel();
        protected static var d_dragDropTargetProperty:PropertyDragDropTarget     = new PropertyDragDropTarget();
        protected static var d_autoRenderingSurfaceProperty:PropertyAutoRenderingSurface = new PropertyAutoRenderingSurface();
        protected static var d_rotationProperty:PropertyRotation                 = new PropertyRotation();
        protected static var d_xRotationProperty:PropertyXRotation               = new PropertyXRotation();
        protected static var d_yRotationProperty:PropertyYRotation               = new PropertyYRotation();
        protected static var d_zRotationProperty:PropertyZRotation               = new PropertyZRotation();
        protected static var d_nonClientProperty:PropertyNonClient               = new PropertyNonClient();
        protected static var d_textParsingEnabledProperty:PropertyTextParsingEnabled = new PropertyTextParsingEnabled();
        protected static var d_marginProperty:PropertyMargin                     = new PropertyMargin();
        protected static var d_updateModeProperty:PropertyUpdateMode             = new PropertyUpdateMode();
        protected static var d_mouseInputPropagationProperty:PropertyMouseInputPropagationEnabled = new PropertyMouseInputPropagationEnabled();
        

        //sound extension
        protected static var d_showSoundProperty:PropertySoundShow               = new PropertySoundShow();
        protected static var d_hideSoundProperty:PropertySoundHide               = new PropertySoundHide();
        protected static var d_lclickSoundProperty:PropertySoundLClick           = new PropertySoundLClick();
        protected static var d_rclickSoundProperty:PropertySoundRClick           = new PropertySoundRClick();
        protected static var d_ldoubleClickSoundProperty:PropertySoundLDoubleClick = new PropertySoundLDoubleClick();
        protected static var d_hoverSoundProperty:PropertySoundHover             = new PropertySoundHover();

        //mouse event pass throw properties
//        protected static var d_mouseHollowProperty:PropertyMouseHollow           = new PropertyMouseHollow();
//        protected static var d_mouseMoveHollowProperty:PropertyMouseMoveHollow   = new PropertyMouseMoveHollow();
//        protected static var d_mouseLButtonHollowProperty:PropertyMouseLButtonHollow = new PropertyMouseLButtonHollow();
//        protected static var d_mouseRButtonHollowProperty:PropertyMouseRButtonHollow = new PropertyMouseRButtonHollow();


        //members
        //type of window
        protected var d_type:String;
        //name of window
        protected var d_name:String;
        //type name of the window as defined in a Falagard mapping
        public var d_falagardType:String = "";
        //auto window
        protected var d_autoWindow:Boolean = false;
        
        //is the window being initialized
        protected var d_initialising:Boolean = false;
        //is the window being destroyed
        protected var d_destructionStarted:Boolean = false;
        //is the window enabled
        protected var d_enabled:Boolean = true;
        //is window visible
        protected var d_visible:Boolean = true;
        //is window active(receiving input)
        protected var d_active:Boolean = false;
        
        //list of children
        protected var d_children:Vector.<FlameWindow> = new Vector.<FlameWindow>();
        //child winow objects arranged in rendering order
        protected var d_drawList:Vector.<FlameWindow> = new Vector.<FlameWindow>();
        //metrics mode
        //protected var d_metricsMode:uint;		//!< Holds the active metrics mode for this window
        //parent window
        protected var d_parent:FlameWindow = null;
        //if the window be auto-destroyed by parent
        protected var d_destroyedByParent:Boolean = true;
        
        //if the window clipped by parent window area rect
        protected var d_clippedByParent:Boolean = true;
        //if the window is non-client(outside InnerRect) area of parent
        protected var d_nonClientContent:Boolean = false;
        
        //name of look assigned to this window(if any)
        protected var d_lookName:String = "";
        //window renderer module that implements the lookNFeel specification
        protected var d_windowRenderer:FlameWindowRenderer = null;
        //object which acts as a cache of geometry drawn by this window
        protected var d_geometry:FlameGeometryBuffer = null;//FlameRenderer.getSingleton().createGeometry();
        //render surface
        protected var d_surface:FlameRenderingSurface = null;
        //if window geometry cache needs to be regenerated
        protected var d_needsRedraw:Boolean = true;
        //holds setting for automatic creation of surface
        protected var d_autoRenderingWindow:Boolean = false;
        
        //holds pointer to the window objects current mouse cursor image
        protected var d_mouseCursor:FlameImage = null;
        
        //alpha transparency setting for the window
        protected var d_alpha:Number = 1.0;
        //if the window inherits alpha from the parent window
        protected var d_inheritsAlpha:Boolean = true;
 
        //------------------------------------------------------
        //window that has captured inputs
        protected static var d_captureWindow:FlameWindow = null;
        
        //the window that previously had capture
        protected var d_oldCapture:FlameWindow = null;
        //restore capture to the previous capture window when releasing capture
        protected var d_restoreOldCapture:Boolean = false;
        //whether to distribute captured inputs to child windows
        protected var d_distCapturedInputs:Boolean = false;
        
        //holds pointer to the window objects current font
        protected var d_font:FlameFont = null;
        //hods the text/lable/caption for this window
        protected var d_textLogical:String = "";
        //! RenderedString representation of text string as ouput from a parser.
        protected var d_renderedString:FlameRenderedString = new FlameRenderedString();
        //! true if d_renderedString is valid, false if needs re-parse.
        protected var d_renderedStringValid:Boolean = true;
        
        //! Shared instance of a parser to be used in most instances.
        protected static var d_basicStringParser:FlameBasicRenderedStringParser = new FlameBasicRenderedStringParser();
        //! Shared instance of a parser to be used when rendering text verbatim.
        protected static var d_defaultStringParser:FlameDefaultRenderedStringParser = new FlameDefaultRenderedStringParser();
        //! Pointer to a custom (user assigned) RenderedStringParser object.
        protected var d_customStringParser:FlameRenderedStringParser = null;
        //! true if use of parser other than d_defaultStringParser is enabled
        protected var d_textParsingEnabled:Boolean = false;
        
        //margin
        protected var d_margin:UBox = new UBox();
        
        //id
        protected var d_ID:uint = 0;
        //holds pointer to some user assigned data
        protected var d_userData:* = null;
        //! Holds a collection of named user string values.
        protected var d_userStrings:Dictionary = new Dictionary();
        
        //if window always on top of all other windows
        protected var d_alwaysOnTop:Boolean = false;
        //whether window should rise in the z order when left clicked
        protected var d_riseOnClick:Boolean = true;
        //if the window responds to z-order change requests
        protected var d_zOrderingEnabled:Boolean = true;
        
        //if the window wishes to hear about multi-click mouse events
        protected var d_wantsMultiClicks:Boolean = true;
        //whether (most) mouse events pass through this window
        protected var d_mousePassThroughEnabled:Boolean = false;
        //whether pressed mouse button will auto repeat the down event
        protected var d_autoRepeat:Boolean = false;
        //seconds before first repeat event is fired
        protected var d_repeatDelay:Number = 0.3;
        //seconds between further repeats after delay has expired
        protected var d_repeatRate:Number = 0.06;
        //button we're tracking for auto-repeat purposes
        protected var d_repeatButton:uint = Consts.MouseButton_NoButton;
        //implements repeating
        protected var d_repeating:Boolean = false;
        //implements repeating
        protected var d_repeatElapsed:Number = 0.0;
        
        //can be drag/drop
        protected var d_dragDropTarget:Boolean = true;
        
        //text string used as tip for this window
        protected var d_tooltipText:String = "";
        //! Possible custom Tooltip for this window.
        protected var d_customTip:FlameTooltip = null;
        //! true if this Window created the custom Tooltip.
        protected var d_weOwnTip:Boolean = false;
        //whether tooltip text maybe inherited from parent
        protected var d_inheritsTipText:Boolean = true;
        
        //if window is allowed to write XML
        protected var d_allowWriteXML:Boolean = false;
        //banned properties list
        //todo
        
        //this window objects area as defined by a rect
        protected var d_area:URect = new URect();
        //current constrained pixel size of the window
        protected var d_pixelSize:Size = new Size(0,0);
        //current minimum size for the window
        protected var d_minSize:UVector2 = new UVector2(Misc.cegui_reldim(0), Misc.cegui_reldim(0));
        //! current maximum size for the window.
        protected var d_maxSize:UVector2 = new UVector2(Misc.cegui_reldim(1), Misc.cegui_reldim(1));
        //! Specifies the base for horizontal alignment.
        protected var d_horzAlign:uint = Consts.HorizontalAlignment_HA_LEFT;
        //! Specifies the base for vertical alignment.
        protected var d_vertAlign:uint = Consts.VerticalAlignment_VA_TOP;
        //rotation angles for this window
        protected var d_rotation:Vector3 = new Vector3();
        
        //outer area rect in screen pixels
        protected var d_outerUnclippedRect:Rect = new Rect();
        //inner area rect in screen pixels
        protected var d_innerUnclippedRect:Rect = new Rect();
        //outer area clipping rect in screen pixels
        protected var d_outerRectClipper:Rect = new Rect();
        //inner area clipping rect in screen pixels
        protected var d_innerRectClipper:Rect = new Rect();
        //area rect used for hit-testing agains this window
        protected var d_hitTestRect:Rect = new Rect();
        
        protected var d_outerUnclippedRectValid:Boolean = false;
        protected var d_innerUnclippedRectValid:Boolean = false;
        protected var d_outerRectClipperValid:Boolean = false;
        protected var d_innerRectClipperValid:Boolean = false;
        protected var d_hitTestRectValid:Boolean = false;
        
        //the mode to use for calling window::update
        protected var d_updateMode:uint = Consts.WindowUpdateMode_VISIBLE;
        //specifies whether mouse inputs should be propagated to parent(s)
        protected var d_propagateMouseInputs:Boolean = false;
        

        protected var d_showSound:String = "";
        protected var d_hideSound:String = "";
        protected var d_lclickSound:String = "";
        protected var d_rclickSound:String = "";
        protected var d_ldoubleClickSound:String = "";
        protected var d_hoverSound:String = "";

        protected var d_mouseHollow:Boolean = false;
        protected var d_mouseMoveHollow:Boolean = false;
        protected var d_mouseLButtonHollow:Boolean = false;
        protected var d_mouseRButtonHollow:Boolean = false;
        
        //property set
        private var d_properties:Dictionary = new Dictionary();
       
        //constuction
        /*!
        \brief
        Constructor for Window base class
        
        \param type
        String object holding Window type (usually provided by WindowFactory).
        
        \param name
        String object holding unique name for the Window.
        */
        public function FlameWindow(type:String, name:String)
        {
            d_type = type;
            d_name = name;
            
            //check if has __auto_ ... to be checked
            d_autoWindow = (d_name.indexOf(AutoWidgetNameSuffix) != -1);
            
            //create geometry buffer
            this.d_geometry = FlameSystem.getSingleton().getRenderer().createGeometryBuffer();
            
            
            addStandardProperties();
        }
        

        public function dispose():void
        {
            FlameSystem.getSingleton().getRenderer().destroyGeometryBuffer(d_geometry);
        }
        
        
        
        /*******************************************************************
        * Property operation
        * ******************************************************************/
        public function getPropertySet():Dictionary
        {
            return d_properties;
        }
        
        public function addProperty(property:FlameProperty):void
        {
            if (!property) {
                throw new Error("The given Property object pointer is invalid.");
            }
            
            if (d_properties.hasOwnProperty(property.getName())) {
                throw("A Property named '" + property.getName() + "' already exists in the PropertySet.");
            }
            
            d_properties[property.getName()] = property;
            
            //property->initialisePropertyReceiver(this);
            (property as FlameProperty).setDefaultValue(this);

        }
        
        public function removeProperty(name:String):void
        {
            if(d_properties.hasOwnProperty(name)){
                delete d_properties[name];
            }
        }
        
        //set a new value for existing property
        public function setProperty(name:String, value:String):void
        {
//            if(value == ""){
//                trace("Empty value for property:" + name);
//                return;
//            }
            
            if(! this.d_properties.hasOwnProperty(name)){
                trace("There is no Property named '" + name + "' available in the set.");
                return;
            }
            
            //(this.d_properties[name] as FlameProperty).setValue(value);
            d_properties[name].setValue(this, value);
        }
        

        
        /*!
        \brief
        Removes all Property objects from the PropertySet.
        
        \return
        Nothing.
        */
        public function clearProperties():void
        {
            d_properties = new Dictionary();
        }
        
        
        /*!
        \brief
        Checks to see if a Property with the given name is in the PropertySet
        
        \param name
        String containing the name of the Property to check for.
        
        \return
        true if a Property named \a name is in the PropertySet.  false if no Property named \a name is in the PropertySet.
        */
        public function isPropertyPresent(name:String):Boolean
        {
            return d_properties.hasOwnProperty(name);
        }
        
        
        /*!
        \brief
        Return the help text for the specified Property.
        
        \param name
        String holding the name of the Property who's help text is to be returned.
        
        \return
        String object containing the help text for the Property \a name.
        
        \exception UnknownObjectException	Thrown if no Property named \a name is in the PropertySet.
        */
        public function getPropertyHelp(name:String):String
        {
            if(d_properties.hasOwnProperty(name))
            {
                return (d_properties[name] as FlameProperty).getHelp();
            }
            
            return "";
        }
        
        
        /*!
        \brief
        Gets the current value of the specified Property.
        
        \param name
        String containing the name of the Property who's value is to be returned.
        
        \return
        String object containing a textual representation of the requested Property.
        
        \exception UnknownObjectException	Thrown if no Property named \a name is in the PropertySet.
        */
        public function getProperty(name:String):String
        {
            if(! d_properties.hasOwnProperty(name)){
                trace("break");
                throw new Error("There is no Property named '" + name + "' available in the set.");
            }
            
            return d_properties[name].getValue(this);
        }
        
//        /*************************************************************************
//         Return whether the EventSet is muted or not.	
//         *************************************************************************/
//        public function isMuted():Boolean
//        {
//            return d_muted;
//        }
//        
//        /*************************************************************************
//         Set the mute state for this EventSet.	
//         *************************************************************************/
//        public function setMutedState(setting:Boolean):void
//        {
//            d_muted = setting;
//        }

        /***************************************************************
        * Event operation
        * **************************************************************/
        //event part, from xml parser
        public function setEvent(name:String, value:String):void
        {
            
            //get function name and args from value
            
            //record
            this.d_events[name] = value;

            //should connect to script module, todo....
            //add event listener
            
            //add a callback when listen
        }
        
        
        
        
        
        
        
        
        
        /*************************************************************************
         Accessor functions
         *************************************************************************/
        /*!
        \brief
        return a String object holding the type name for this Window.
        
        \return
        String object holding the Window type.
        */
        public function getType():String
        {
            return (this.d_falagardType == "") ? this.d_type : this.d_falagardType;
        }
        
        /*!
        \brief
        return a String object holding the name of this Window.
        
        \return
        String object holding the unique Window name.
        */
        public function getName():String
        {
            return this.d_name;
        }
        
        /*!
        \brief
        returns whether or not this Window is set to be destroyed when its
        parent window is destroyed.
        
        \return
        - true if the Window will be destroyed when its parent is destroyed.
        - false if the Window will remain when its parent is destroyed.
        */
        public function isDestroyedByParent():Boolean
        {
            return this.d_destroyedByParent;
        }
        
        /*!
        \brief
        returns whether or not this Window is an always on top Window.  Also
        known as a top-most window.
        
        \return
        - true if this Window is always drawn on top of other normal windows.
        - false if the Window has normal z-order behaviour.
        */
        public function isAlwaysOnTop():Boolean
        {
            return this.d_alwaysOnTop;
        }
        
     
        /*!
        \brief
        return true if the Window is currently disabled
        
        \param localOnly
        States whether to only return the state set for this window, and so not factor in
        inherited state from ancestor windows.
        
        \return
        true if the window is disabled, false if the window is enabled.
        */
        public function isDisabled(localOnly:Boolean = false):Boolean
        {
            var parent_disabled:Boolean = ((!d_parent) || localOnly) ? false : d_parent.isDisabled();
            
            return !d_enabled || parent_disabled;
        }

        /*!
        \brief
        return true if the Window is currently visible.
        
        A true return from this function does not mean that the window is not completely obscured by other windows, just that the window
        is processed when rendering and is not hidden.
        
        \param localOnly
        States whether to only return the state set for this window, and so not factor in
        inherited state from ancestor windows.
        
        \return
        true if the window is drawn, false if the window is hidden and therefore ignored when rendering.
        */
        public function isVisible(localOnly:Boolean = false):Boolean
        {
            var parent_visible:Boolean = ((d_parent == null) || localOnly) ? true : d_parent.isVisible();
            
            return d_visible && parent_visible;
        }
        
        
        /*!
        \brief
        return true if this is the active Window (the window that receives inputs)
        
        Mouse events are always sent to the window containing the mouse cursor regardless of what this reports (unless the window has captured
        inputs).  This mainly refers to where other (keyboard) inputs are sent.
        
        \return
        true if this window has input focus, or false if it does not.
        */
        public function isActive():Boolean
        {
            var parent_active:Boolean = (d_parent == null) ? true : d_parent.isActive();
            
            return d_active && parent_active;
        }
        
        
        /*!
        \brief
        return true if this Window is clipped so that its rendering does not pass outside its parent windows area.
        
        \return
        true if the window will be clipped by its parent window, or false if this windows rendering may pass outside its parents area
        */
        public function isClippedByParent():Boolean
        {
            return d_clippedByParent;
        }
        /*!
        \brief
        return the ID code currently assigned to this Window by client code.
        
        \return
        UINT value equal to the currently assigned ID code for this Window.
        */
        public function getID():uint
        {
            return this.d_ID;
        }
        
        /*!
        \brief
        return the number of child Window objects currently attached to this Window.
        
        \return
        UINT value equal to the number of Window objects directly attached to this Window as children.
        */
        public function getChildCount():uint
        {
            return d_children.length;
        }
        
        /*!
        \brief
        returns whether a Window with the specified name is currently attached to this Window as a child.
        
        \param name
        String object containing the name of the Window to look for.
        
        \return
        true if a Window named \a name is currently attached to this Window as a child, else false.
        */
        public function isChildForName(name:String):Boolean
        {
            var child_count:uint = getChildCount();
            
            for (var i:uint = 0; i < child_count; ++i) {
                if (d_children[i].getName() == name) {
                    return true;
                }
            }
            
            return false;
        }
        /*!
        \brief
        returns whether at least one window with the given ID code is attached as a child.
        
        \note
        ID codes are client assigned and may or may not be unique, and as such, the return from this function
        will only have meaning to the client code.
        
        \param ID
        UINT ID code to look for.
        
        \return
        true if a child window was found with the ID code \a ID, or false if no child window was found with the ID \a ID.
        */
        public function isChildForID(ID:uint):Boolean
        {
            var child_count:uint = getChildCount();
            
            for (var i:uint = 0; i < child_count; ++i) {
                if (d_children[i].getID() == ID) {
                    return true;
                }
            }
            
            return false;
        }

  
        /*!
        \brief
        returns whether at least one window with the given ID code is attached
        to this Window or any of it's children as a child.
        
        \note
        ID codes are client assigned and may or may not be unique, and as such,
        the return from this function will only have meaning to the client code.
        
        WARNING! This function can be very expensive and should only be used
        when you have no other option available. If you decide to use it anyway,
        make sure the window hierarchy from the entry point is small.
        
        \param ID
        uint ID code to look for.
        
        \return
        - true if at least one child window was found with the ID code \a ID
        - false if no child window was found with the ID code \a ID.
        */
        public function isChildRecursive(ID:uint):Boolean
        {
            const child_count:uint = getChildCount();
            
            for (var i:uint = 0; i < child_count; ++i) {
                if (d_children[i].getID() == ID || d_children[i].isChildRecursive(ID))
                    return true;
            }
            
            return false;
        }

        /*!
        \brief
        return true if the given Window is a child of this window.
        
        \param window
        Pointer to the Window object to look for.
        
        \return
        true if Window object \a window is attached to this window as a child.
        */
        public function isChild(window:FlameWindow):Boolean
        {
            var child_count:uint = getChildCount();
            
            for (var i:uint = 0; i < child_count; ++i) {
                if (d_children[i] == window) {
                    return true;
                }
            }
            
            return false;
        }
        
        
        /*!
        \brief
        return a pointer to the child window with the specified name.
        
        This function will throw an exception if no child object with the given name is attached.  This decision
        was made (over returning NULL if no window was found) so that client code can assume that if the call
        returns it has a valid window pointer.  We provide the isChild() functions for checking if a given window
        is attached.
        
        \param name
        String object holding the name of the child window to return a pointer to.
        
        \return
        Pointer to the Window object attached to this window that has the name \a name.
        
        \exception UnknownObjectException	thrown if no window named \a name is attached to this Window.
        */
        public function getChildByName(name:String):FlameWindow
        {
            var child_count:uint = getChildCount();
            
            for (var i:uint = 0; i < child_count; ++i) {
                if (d_children[i].getName() == name)
                {
                    return d_children[i];
                }
            }
            
            throw new Error("Window::getChild - The Window object named '" + name +"' is not attached to Window '" + d_name + "'.");
        }
        
        
        /*!
        \brief
        return a pointer to the first attached child window with the specified ID.
        
        This function will throw an exception if no child object with the given ID is attached.  This decision
        was made (over returning NULL if no window was found) so that client code can assume that if the call
        returns it has a valid window pointer.  We provide the isChild() functions for checking if a given window
        is attached.
        
        \param ID
        UINT value specifying the ID code of the window to return a pointer to.
        
        \return
        Pointer to the (first) Window object attached to this window that has the ID code \a ID.
        
        \exception UnknownObjectException	thrown if no window with the ID code \a ID is attached to this Window.
        */
        public function getChildByID(ID:uint):FlameWindow
        {
            var child_count:uint = getChildCount();
            
            for (var i:uint = 0; i < child_count; ++i) {
                if (d_children[i].getID() == ID)
                {
                    return d_children[i];
                }
            }
            
            throw new Error("Window::getChild - The Window with ID: '" + ID + "' is not attached to Window '" + d_name + "'.");
            
        }
        

        /*!
        \brief
        return a pointer to the first attached child window with the specified
        name. Children are traversed recursively.
        
        Contrary to the non recursive version of this function, this one will
        not throw an exception, but return 0 in case no child was found.
        
        \note
        WARNING! This function can be very expensive and should only be used
        when you have no other option available. If you decide to use it anyway,
        make sure the window hierarchy from the entry point is small.
        
        \param name
        String object holding the name of the child window for which a pointer
        is to be returned.
        
        \return
        Pointer to the Window object attached to this window that has the name
        \a name.
        
        If no child is found with the name \a name, 0 is returned.
        */
        public function getChildRecursiveByName(name:String):FlameWindow
        {
            const child_count:uint = getChildCount();
            
            for (var i:uint = 0; i < child_count; ++i)
            {
                const childName:String = d_children[i].getName();
                if (childName == name)
                    return d_children[i];
                
                var tmp:FlameWindow = d_children[i].getChildRecursiveByName(name);
                if (tmp)
                    return tmp;
            }
            
            return null;
        }

        /*!
        \brief
        return a pointer to the first attached child window with the specified
        ID value. Children are traversed recursively.
        
        Contrary to the non recursive version of this function, this one will
        not throw an exception, but return 0 in case no child was found.
        
        \note
        WARNING! This function can be very expensive and should only be used
        when you have no other option available. If you decide to use it anyway,
        make sure the window hierarchy from the entry point is small.
        
        \param ID
        uint value specifying the ID code of the window to return a pointer to.
        
        \return
        Pointer to the (first) Window object attached to this window that has
        the ID code \a ID.
        If no child is found with the ID code \a ID, 0 is returned.
        */
        public function getChildRecursiveByID(ID:uint):FlameWindow
        {
            var child_count:uint = getChildCount();
            
            for(var i:uint=0; i < child_count; ++i)
            {
                if(d_children[i].getID() == ID)
                    return d_children[i];
                
                var tmp:FlameWindow = d_children[i].getChildRecursiveByID(ID);
                if(tmp)
                    return tmp;
            }
            
            return null;
        }
        
        
        
        /*!
        \brief
        return a pointer to the child window that is attached to 'this' at the given index.
        
        \param idx
        Index of the child window whos pointer should be returned.  This value is not bounds checked,
        client code should ensure that this is less than the value returned by getChildCount().
        
        \return
        Pointer to the child window currently attached at index position \a idx
        */
        public function getChildAt(idx:uint):FlameWindow
        {
            //check idx .... to do??
            return d_children[idx];
        }
        
        

        /*!
        \brief
        return a pointer to the Window that currently has input focus starting with this Window.
        
        \return
        Pointer to the window that is active (has input focus) starting at 'this.  Will return 'this' if this Window is active
        and either no children are attached or if none of the attached children are active.  Returns NULL if this Window (and
        therefore all children) are not active.
        */
        public function getActiveChild():FlameWindow
        {
            // are children can't be active if we are not
            if (!isActive())
            {
                return null;
            }
            
            var pos:int = getChildCount();
            
            while (pos-- > 0)
            {
                // don't need full backward scan for activeness as we already know 'this' is active
                // NB: This uses the draw-ordered child list, as that should be quicker in most cases.
                if (d_drawList[pos].d_active)
                    return d_drawList[pos].getActiveChild();
            }
            
            // no child was active, therefore we are the topmost active window
            return this;
        }

        
        /*!
        \brief
        return true if the specified Window is some ancestor of this Window
        
        \param name
        String object holding the name of the Window to check for.
        
        \return
        true if a Window named \a name is an ancestor (parent, or parent of parent, etc) of this Window, or false if not.
        */
        public function isAncestorForName(name:String):Boolean
        {
            // if we have no ancestor then 'name' can't be ancestor
            if (d_parent == null)
            {
                return false;
            }
            
            // check our immediate parent
            if (d_parent.getName() == name)
            {
                return true;
            }
            
            // not out parent, check back up the family line
            return d_parent.isAncestorForName(name);
        }
        /*!
        \brief
        return true if any Window with the given ID is some ancestor of this Window.
        
        \param ID
        UINT value specifying the ID to look for.
        
        \return
        true if an ancestor (parent, or parent of parent, etc) was found with the ID code \a ID, else false.
        */
        public function isAncestorForID(ID:uint):Boolean
        {
            // return false if we have no ancestor
            if (d_parent == null)
            {
                return false;
            }
            
            // check our immediate parent
            if (d_parent.getID() == ID)
            {
                return true;
            }
            
            // not our parent, check back up the family line
            return d_parent.isAncestorForID(ID);
        }
        
        /*!
        \brief
        return true if the specified Window is some ancestor of this Window.
        
        \param window
        Pointer to the Window object to look for.
        
        \return
        true if \a window was found to be an ancestor (parent, or parent of parent, etc) of this Window, otherwise false.
        */
        public function isAncestorForWindow(window:FlameWindow):Boolean
        {
            // if we have no parent, then return false
            if (d_parent == null)
            {
                return false;
            }
            
            // check our immediate parent
            if (d_parent == window)
            {
                return true;
            }
            
            // not our parent, check back up the family line
            return d_parent.isAncestorForWindow(window);
        }

        /*!
        \brief
        return the Font object active for the Window.
        
        \param useDefault
        Sepcifies whether to return the default font if Window has no preference set.
        
        \return
        Pointer to the Font being used by this Window.  If the window has no assigned font, the default font is returned.
        */
        public function getFont(useDefault:Boolean = true):FlameFont
        {
            if (d_font == null)
            {
                return useDefault ? FlameSystem.getSingleton().getDefaultFont() : null;
            }
            
            return d_font;
        }
        
        
        
        /*!
        \brief
        return the current text for the Window
        
        \return
        The String object that holds the current text for this Window.
        */
        public function getText():String
        {
            return d_textLogical;
        }

        
        //! return text string with \e visual ordering of glyphs.
        public function getTextVisual():String
        {
//            // no bidi support
//            if (!d_bidiVisualMapping)
//                return d_textLogical;
//            
//            if (!d_bidiDataValid)
//            {
//                d_bidiVisualMapping->updateVisual(d_textLogical);
//                d_bidiDataValid = true;
//            }
//            
//            return d_bidiVisualMapping->getTextVisual();
            
            return d_textLogical;
        }

        
        /*!
        \brief
        return true if the Window inherits alpha from its parent(s).
        
        \return
        true if the Window inherits alpha from its parent(s), false if the alpha for this Window is independant.
        */
        public function inheritsAlpha():Boolean
        {
            return d_inheritsAlpha;
        }
        
        /*!
        \brief
        return the current alpha value set for this Window
        
        \note
        The alpha value set for any given window may or may not be the final alpha value that is used when rendering.  All window
        objects, by default, inherit alpha from thier parent window(s) - this will blend child windows, relatively, down the line of
        inheritance.  This behaviour can be overridden via the setInheritsAlpha() method.  To return the true alpha value that will be
        applied when rendering, use the getEffectiveAlpha() method.
        
        \return
        the currently set alpha value for this Window.  Will be between 0.0f and 1.0f.
        */
        public function getAlpha():Number
        {
            return d_alpha;
        }
        
        /*!
        \brief
        return the effective alpha value that will be used when rendering this window, taking into account inheritance of parent
        window(s) alpha.
        
        \return
        the effective alpha that will be applied to this Window when rendering.  Will be between 0.0f and 1.0f.
        */
        public function getEffectiveAlpha():Number
        {
            if ((d_parent == null) || (!inheritsAlpha()))
            {
                return d_alpha;
            }
            
            return d_alpha * d_parent.getEffectiveAlpha();
        }

        /*!
        \brief
        Return a Rect that describes the unclipped outer rect area of the Window
        in screen pixels.
        */
        public function getUnclippedOuterRect():Rect
        {
            if (!d_outerUnclippedRectValid)
            {
                d_outerUnclippedRect = getUnclippedOuterRect_impl();
                d_outerUnclippedRectValid = true;
            }
        
            return d_outerUnclippedRect;
        }
        
        
        /*!
        \brief
        Return a Rect that describes the unclipped inner rect area of the Window
        in screen pixels.
        */
        
        public function getUnclippedInnerRect():Rect
        {
            if (!d_innerUnclippedRectValid)
            {
                d_innerUnclippedRect = getUnclippedInnerRect_impl();
                d_innerUnclippedRectValid = true;
            }
            
            return d_innerUnclippedRect;
        }
        
        
        /*!
        \brief
        Return a Rect that describes the unclipped area covered by the Window.
        
        This function can return either the inner or outer area dependant upon
        the boolean values passed in.
        
        \param inner
        - true if the inner rect area should be returned.
        - false if the outer rect area should be returned.
        */
        
        public function getUnclippedRect(inner:Boolean):Rect
        {
            return inner ? getUnclippedInnerRect() : getUnclippedOuterRect();
        }
        
        
        /*!
        \brief
        Return a Rect that describes the rendering clipping rect based upon the
        outer rect area of the window.
        
        \note
        The area returned by this function gives you the correct clipping rect
        for rendering within the Window's outer rect area.  The area described
        may or may not correspond to the final visual clipping actually seen on
        the display; this is intentional and neccessary due to the way that
        imagery is cached under some configurations.
        */
        
        public function getOuterRectClipper():Rect
        {
            if (!d_outerRectClipperValid)
            {
                d_outerRectClipper = getOuterRectClipper_impl();
                d_outerRectClipperValid = true;
            }
            
            return d_outerRectClipper;
        }
        
        /*!
        \brief
        Return a Rect that describes the rendering clipping rect based upon the
        inner rect area of the window.
        
        \note
        The area returned by this function gives you the correct clipping rect
        for rendering within the Window's inner rect area.  The area described
        may or may not correspond to the final visual clipping actually seen on
        the display; this is intentional and neccessary due to the way that
        imagery is cached under some configurations.
        */
        
        public function getInnerRectClipper():Rect
        {
            if (!d_innerRectClipperValid)
            {
                d_innerRectClipper = getInnerRectClipper_impl();
                d_innerRectClipperValid = true;
            }
            
            return d_innerRectClipper;
        }
        
        /*!
        \brief
        Return a Rect that describes the rendering clipping rect for the Window.
        
        This function can return the clipping rect for either the inner or outer
        area dependant upon the boolean values passed in.
        
        \note
        The areas returned by this function gives you the correct clipping rects
        for rendering within the Window's areas.  The area described may or may
        not correspond to the final visual clipping actually seen on the
        display; this is intentional and neccessary due to the way that imagery
        is cached under some configurations.
        
        \param non_client
        - true to return the non-client clipping area (based on outer rect).
        - false to return the client clipping area (based on inner rect).
        */
        
        public function getClipRect(non_client:Boolean = false):Rect
        {
            return non_client ? getOuterRectClipper() : getInnerRectClipper();
        }
        
        /*!
        \brief
        Return the Rect that descibes the clipped screen area that is used for
        determining whether this window has been hit by a certain point.
        
        The area returned by this function may also be useful for certain
        calculations that require the clipped Window area as seen on the display
        as opposed to what is used for rendering (since the actual rendering
        clipper rects should not to be used if reliable results are desired).
        */
        
        public function getHitTestRect():Rect
        {
            if (!d_hitTestRectValid)
            {
                d_hitTestRect = getHitTestRect_impl();
                d_hitTestRectValid = true;
            }
            
            return d_hitTestRect;
        }
        
        //----------------------------------------------------------------------------//
        /*!
        \brief
        Return a Rect that describes the area that is used to position
        and - for scale values - size child content attached to this Window.
        
        By and large the area returned here will be the same as the unclipped
        inner rect (for client content) or the unclipped outer rect (for non
        client content), although certain advanced uses will require
        alternative Rects to be returned.
        
        \note
        The behaviour of this function is modified by overriding the
        protected Window::getClientChildWindowContentArea_impl and/or
        Window::getNonClientChildWindowContentArea_impl functions.
        
        \param non_client
        - true to return the non-client child content area.
        - false to return the client child content area (default).
        */
        
        public function getChildWindowContentArea(non_client:Boolean = false):Rect
        {
            return non_client ?
                getNonClientChildWindowContentArea_impl() :
                getClientChildWindowContentArea_impl();
        }
        
        
        
        /*!
        \brief
        Return a Rect object that describes, unclipped, the inner rectangle for
        this window.  The inner rectangle is typically an area that excludes
        some frame or other rendering that should not be touched by subsequent
        rendering.
        
        \return
        Rect object that describes, in unclipped screen pixel co-ordinates, the
        window object's inner rect area.
        
        \note
        This function is going to change from public visibility to pretected.
        All code accessing the area rects via external code should be using the
        regular getUnclippedInnerRect function.
        */
        protected function getUnclippedInnerRect_impl():Rect
        {
            return d_windowRenderer ? d_windowRenderer.getUnclippedInnerRect() :
                getUnclippedOuterRect();
        }
        
        
        /*!
        \brief
        return the Window that currently has inputs captured.
        
        \return
        Pointer to the Window object that currently has inputs captured, or NULL if no Window has captured input.
        */
        public static function getCaptureWindow():FlameWindow
        {
            return d_captureWindow;
        }
        
        
        
        /*!
        \brief
        return true if this Window has input captured.
        
        \return
        true if this Window has captured inputs, or false if some other Window, or no Window, has captured inputs.
        */
        public function isCapturedByThis():Boolean
        {
            return getCaptureWindow() == this;
        }

        
        /*!
        \brief
        return true if a child window has captured inputs.
        
        \return
        true if inputs are captured by a Window that is attached as a child of this Window, else false.
        */
        public function isCapturedByAncestor():Boolean
        {
            return isAncestorForWindow(getCaptureWindow());
        }
        
        /*!
        \brief
        return true if an ancestor window has captured inputs.
        
        \return
        true if inputs are captured by a Window that is some ancestor (parent, parent of parent, etc) of this Window, else false.
        */
        public function isCapturedByChild():Boolean
        {
            return isChild(getCaptureWindow());
        }
        

        
        /*!
        \brief
        check if the given position would hit this window.
        
        \param position
        Point object describing the position to check in screen pixels
        
        \return
        true if \a position 'hits' this Window, else false.
        */
        
        protected function isHit(position:Vector2, allow_disabled:Boolean = false):Boolean
        {
            // cannot be hit if we are disabled.
            if(!allow_disabled && isDisabled())
            {
                return false;
            }
            
            var test_area:Rect = getHitTestRect();
            
            if (test_area.getWidth() == 0 || test_area.getHeight() == 0)
            {
                return false;
            }
            
            return test_area.isPointInRect(position);
            
        }
        
        /*!
        \brief
        return the child Window that is 'hit' by the given position
        
        \param position
        Point object that describes the position to check in screen pixels
        
        \return
        Pointer to the child Window that was hit according to the Point \a position, or NULL if no child window was hit.
        */
        public function getChildAtPosition(position:Vector2):FlameWindow
        {
            var p:Vector2;
            
            // if the window has RenderingWindow backing
            if (d_surface && d_surface.isRenderingWindow())
                (d_surface as FlameRenderingWindow).unprojectPoint(position, p);
            else
                p = position;
            
            for(var i:int = d_drawList.length-1; i>=0; i--)
            {
                if (d_drawList[i].isVisible())
                {
                    // recursively scan children of this child windows...
                    const wnd:FlameWindow = d_drawList[i].getChildAtPosition(p);
                    
                    // return window pointer if we found a hit down the chain somewhere
                    if (wnd)
                        return wnd;
                        // see if this child is hit and return it's pointer if it is
                    else if (d_drawList[i].isHit(p))
                        return d_drawList[i];
                }
            }
            
            // nothing hit
            return null;
            
        }
        
        
        /*!
        \brief
        return the child Window that is 'hit' by the given position, and is
        allowed to handle mouse events.
        
        \param position
        Vector2 object describing the position to check.  The position
        describes a pixel offset from the top-left corner of the display.
        
        \param allow_disabled
        - true specifies that a disabled window may be returned as the target.
        - false specifies that only enabled windows may be returned.
        
        \return
        Pointer to the child Window that was hit according to the location
        \a position, or 0 if no child of this window was hit.
        */
        
        public function getTargetChildAtPosition(position:Vector2, allow_disabled:Boolean = false) : FlameWindow
        {
            //const ChildList::const_reverse_iterator end = d_drawList.rend();
            
            var p:Vector2 = new Vector2();
            // if the window has RenderingWindow backing
            if (d_surface && d_surface.isRenderingWindow())
                (d_surface as FlameRenderingWindow).unprojectPoint(position, p);
            else
                p = position;

            //trace("checking begin -------------------------, children: " + d_drawList.length);

            //ChildList::const_reverse_iterator child;
            var length:uint = d_drawList.length;
            for(var i:int = length-1; i>=0; i--)
            {
                if (d_drawList[i].isVisible())
                {
                    //trace("checking window:" + d_drawList[i].getName());
                    // recursively scan children of this child windows...
                    const wnd:FlameWindow =
                        d_drawList[i].getTargetChildAtPosition(p, allow_disabled);
                    
                    // return window pointer if we found a 'hit' down the chain somewhere
                    if (wnd)
                        return wnd;
                        // see if this child is hit and return it's pointer if it is
                    else if (!d_drawList[i].isMousePassThroughEnabled() &&
                        d_drawList[i].isHit(p, allow_disabled))
                        return d_drawList[i];
                }
            }
            
            // nothing hit
            return null;
        }
        
        
        /*!
        \brief
        return the parent of this Window.
        
        \return
        Pointer to the Window object that is the parent of this Window.  This value can be NULL, in which case the Window is a GUI
        Sheet / Root.
        */
        public function getParent():FlameWindow
        {
            return d_parent;
        }
        
        
        /*!
        \brief
        Return a pointer to the mouse cursor image to use when the mouse is within this window.
        
        \param useDefault
        Sepcifies whether to return the default font if Window has no preference set.
        
        \return
        Pointer to the mouse cursor image that will be used when the mouse enters this window.  May return NULL indicating no cursor.
        */
        public function getMouseCursor(useDefault:Boolean = true):FlameImage
        {
            
            if(d_mouseCursor != null)
                return d_mouseCursor;
            else
                return useDefault ? FlameSystem.getSingleton().getDefaultMouseCursor() : null;
        }
        
        /*!
        \brief
        Return the window size in pixels.
        
        \return
        Size object describing this windows size in pixels.
        */
        public function getPixelSize():Size
        {
            return d_pixelSize.clone();
        }
        
        /*!
        \brief
        Return the user data set for this Window.
        
        Each Window can have some client assigned data attached to it, this data is not used by the GUI system
        in any way.  Interpretation of the data is entirely application specific.
        
        \return
        pointer to the user data that is currently set for this window.
        */
        public function getUserData():*
        {
            return d_userData;
        }
        
        
        /*!
        \brief
        Return whether this window is set to restore old input capture when it loses input capture.
        
        This is only really useful for certain sub-components for widget writers.
        
        \return
        - true if the window will restore the previous capture window when it loses input capture.
        - false if the window will set the capture window to NULL when it loses input capture (this is the default behaviour).
        */
        public function restoresOldCapture():Boolean
        {
            return d_restoreOldCapture;
        }
        
        
        /*!
        \brief
        Return whether z-order changes are enabled or disabled for this Window.
        
        \return
        - true if z-order changes are enabled for this window.  moveToFront/moveToBack work normally as expected.
        - false: z-order changes are disabled for this window.  moveToFront/moveToBack are ignored for this window.
        */
        public function isZOrderingEnabled():Boolean
        {
            return d_zOrderingEnabled;
        }
        
        
        
        /*!
        \brief
        Return whether this window will receive multi-click events or multiple 'down' events instead.
        
        \return
        - true if the Window will receive double-click and triple-click events.
        - false if the Window will receive multiple mouse button down events instead of double/triple click events.
        */
        public function wantsMultiClickEvents():Boolean
        {
            return d_wantsMultiClicks;
        }
        
        /*!
        \brief
        Return whether mouse button down event autorepeat is enabled for this window.
        
        \return
        - true if autorepeat of mouse button down events is enabled for this window.
        - false if autorepeat of mouse button down events is not enabled for this window.
        */
        public function isMouseAutoRepeatEnabled():Boolean
        {
            return d_autoRepeat;
        }
        
        /*!
        \brief
        Return the current auto-repeat delay setting for this window.
        
        \return
        float value indicating the delay, in seconds, defore the first repeat mouse button down event will be triggered when autorepeat is enabled.
        */
        public function getAutoRepeatDelay():Number
        {
            return d_repeatDelay;
        }
        
        
        
        /*!
        \brief
        Return the current auto-repeat rate setting for this window.
        
        \return
        float value indicating the rate, in seconds, at which repeat mouse button down events will be generated after the initial delay has expired.
        */
        public function getAutoRepeatRate():Number
        {
            return d_repeatRate;
        }
        
        
        /*!
        \brief
        Return whether the window wants inputs passed to its attached
        child windows when the window has inputs captured.
        
        \return
        - true if System should pass captured input events to child windows.
        - false if System should pass captured input events to this window only.
        */
        public function distributesCapturedInputs():Boolean
        {
            return d_distCapturedInputs;
        }
        
        /*!
        \brief
        Return whether this Window is using the system default Tooltip for its Tooltip window.
        
        \return
        - true if the Window will use the system default tooltip.
        - false if the window has a custom Tooltip object.
        */
        public function isUsingDefaultTooltip():Boolean
        {
            return d_customTip == null;
            
        }
        
        /*!
        \brief
        Return a pointer to the Tooltip object used by this Window.  The value returned may
        point to the system default Tooltip, a custom Window specific Tooltip, or be NULL.
        
        \return
        Pointer to a Tooltip based object, or NULL.
        */
        public function getTooltip():FlameTooltip
        {
            return isUsingDefaultTooltip() ? FlameSystem.getSingleton().getDefaultTooltip() :
                d_customTip;
        }
        
        /*!
        \brief
        Return the custom tooltip type.
        
        \return
        String object holding the current custom tooltip window type, or an empty string if no custom tooltip is set.
        */
        public function getTooltipType():String
        {
            return isUsingDefaultTooltip() ? "" : d_customTip.getType();
        }
        
        /*!
        \brief
        Return the current tooltip text set for this Window.
        
        \return
        String object holding the current tooltip text set for this window.
        */
        public function getTooltipText():String
        {
            if (d_inheritsTipText && d_parent && d_tooltipText.length == 0)
                return d_parent.getTooltipText();
            else
                return d_tooltipText;
        }
        
        /*!
        \brief
        Return whether this window inherits Tooltip text from its parent when its own tooltip text is not set.
        
        \return
        - true if the window inherits tooltip text from its parent when its own text is not set.
        - false if the window does not inherit tooltip text from its parent (and shows no tooltip when no text is set).
        */
        public function inheritsTooltipText():Boolean
        {
            return d_inheritsTipText;
        }
        
        
        
        /*!
        \brief
        Return whether this window will rise to the top of the z-order when clicked with the left mouse button.
        
        \return
        - true if the window will come to the top of other windows when the left mouse button is pushed within its area.
        - false if the window does not change z-order position when the left mouse button is pushed within its area.
        */
        public function isRiseOnClickEnabled():Boolean
        {
            return d_riseOnClick; 
        }
        
        /*!
        \brief
        Return whether this window was inherited from the given class name at some point in the inheritance heirarchy.
        
        \param class_name
        The class name that is to be checked.
        
        \return
        true if this window was inherited from \a class_name. false if not.
        */
        public function testClassName(class_name:String):Boolean
        {
            return testClassName_impl(class_name);
        }
        
        /*!
        \brief
        Get the vertical alignment.
        
        Returns the vertical alignment for the window.  This setting affects how the windows position is
        interpreted relative to its parent.
        
        \return
        One of the VerticalAlignment enumerated values.
        */
        public function getVerticalAlignment():uint
        {
            return d_vertAlign;
        }
        
        /*!
        \brief
        Get the horizontal alignment.
        
        Returns the horizontal alignment for the window.  This setting affects how the windows position is
        interpreted relative to its parent.
        
        \return
        One of the HorizontalAlignment enumerated values.
        */
        public function getHorizontalAlignment():uint
        {
            return d_horzAlign;
        }
        
        
        /*!
        \brief
        Return the GeometryBuffer object for this Window.
        
        \return
        Reference to the GeometryBuffer object for this Window.
        */
        public function getGeometryBuffer():FlameGeometryBuffer
        {
            return d_geometry;
        }
        
        
        /*!
        \brief
        Get the name of the LookNFeel assigned to this window.
        
        \return
        String object holding the name of the look assigned to this window.
        Returns the empty string if no look is assigned.
        */
        public function getLookNFeel():String
        {
            return d_lookName;
        }
        
        /*!
        \brief
        Get whether or not this Window is the modal target.
        
        \return
        Returns true if this Window is the modal target, otherwise false.
        */
        private function getModalState():Boolean
        {
            return FlameSystem.getSingleton().getModalTarget() == this;
        }
        
        
        /*!
        \brief
        Returns a named user string.
        
        \param name
        String object holding the name of the string to be returned.
        
        \return
        String object holding the data stored for the requested user string.
        
        \exception UnknownObjectException thrown if a user string named \a name does not exist.
        */
        public function getUserString(name:String):String
        {
            if(d_userStrings.hasOwnProperty(name))
            {
                return d_userStrings[name];   
            }
            
            throw new Error("Window::getUserString: a user string named '" + name +
                "' is not defined for Window '" + d_name + "'.");
        }
        
        /*!
        \brief
        Return whether a user string with the specified name exists.
        
        \param name
        String object holding the name of the string to be checked.
        
        \return
        - true if a user string named \a name exists.
        - false if no such user string exists.
        */
        public function isUserStringDefined(name:String):Boolean
        {
            return d_userStrings.hasOwnProperty(name);
        }
        
        
        /*!
        \brief
        Returns the active sibling window.
        
        This searches the immediate children of this window's parent, and returns a pointer
        to the active window.  The method will return this if we are the immediate child of our
        parent that is active.  If our parent is not active, or if no immediate child of our
        parent is active then 0 is returned.  If this window has no parent, and this window is
        not active then 0 is returned, else this is returned.
        
        \return
        A pointer to the immediate child window attached to our parent that is currently active,
        or 0 if no immediate child of our parent is active.
        */
        
        public function getActiveSibling():FlameWindow
        {
            // initialise with this if we are active, else 0
            var activeWnd:FlameWindow = isActive() ? this : null;
            
            // if active window not already known, and we have a parent window
            if (!activeWnd && d_parent)
            {
                // scan backwards through the draw list, as this will
                // usually result in the fastest result.
                var idx:int = d_parent.getChildCount();
                while (idx-- > 0)
                {
                    // if this child is active
                    if (d_parent.d_drawList[idx].isActive())
                    {
                        // set the return value
                        activeWnd = d_parent.d_drawList[idx];
                        // exit loop early, as we have found what we needed
                        break;
                    }
                }
            }
            
            // return whatever we discovered
            return activeWnd;
        }

        /*!
        \brief
        Return the pixel size of the parent element.  This always returns a
        valid object.
        
        \return
        Size object that describes the pixel dimensions of this Window objects
        parent
        */
        public function getParentPixelSize():Size
        {
            return getSize_impl(d_parent);
        }
        
        
        /*!
        \brief
        Return the pixel Width of the parent element.  This always returns a
        valid number.
        
        \return
        float value that is equal to the pixel width of this Window objects
        parent
        */
        protected function getParentPixelWidth():Number
        {
            return d_parent ?
                d_parent.d_pixelSize.d_width :
                FlameSystem.getSingleton().getRenderer().getDisplayWidth();
        }
        
        /*!
        \brief
        Return the pixel Height of the parent element.  This always returns a
        valid number.
        
        \return
        float value that is equal to the pixel height of this Window objects
        parent
        */
        protected function getParentPixelHeight():Number
        {
            return d_parent ?
                d_parent.d_pixelSize.d_height:
                FlameSystem.getSingleton().getRenderer().getDisplayHeight();
        }
        
        /*!
        \brief
        Returns whether this window should ignore mouse event and pass them
        through to and other windows behind it. In effect making the window
        transparent to the mouse.
        
        \return
        true if mouse pass through is enabled.
        false if mouse pass through is not enabled.
        */
        public function isMousePassThroughEnabled():Boolean
        {
            return d_mousePassThroughEnabled;
        }
        
        /*!
        \brief
        Returns whether this window is an auto-child window.
        All auto-child windows have "__auto_" in their name, but this is faster.
        */
        public function isAutoWindow():Boolean
        {
            return d_autoWindow;
        }
        
        /*!
        \brief
        Returns whether this Window object will receive events generated by
        the drag and drop support in the system.
        
        \return
        - true if the Window is enabled as a drag and drop target.
        - false if the window is not enabled as a drag and drop target.
        */
        public function isDragDropTarget():Boolean
        {
            return d_dragDropTarget;
        }
        
        /*!
        \brief
        Fill in the RenderingContext \a ctx with details of the RenderingSurface
        where this Window object should normally do it's rendering.
        */
        public function getRenderingContext():RenderingContext
        {
            if (d_windowRenderer)
                return d_windowRenderer.getRenderingContext();
            else
                return getRenderingContext_impl();
        }
            
        
        //! implementation of the default getRenderingContext logic.
        public function getRenderingContext_impl():RenderingContext
        {
            var ctx:RenderingContext = new RenderingContext();
            
            if (d_surface)
            {
                ctx.surface = d_surface;
                ctx.owner = this;
                ctx.offset = getUnclippedOuterRect().getPosition();
                ctx.queue = Consts.RenderQueueID_RQ_BASE;
            }
            else if (d_parent)
            {
                ctx = d_parent.getRenderingContext();
            }
            else
            {
                ctx.surface =
                    FlameSystem.getSingleton().getRenderer().getDefaultRenderingRoot();
                ctx.owner = null;
                ctx.offset = new Vector2(0, 0);
                ctx.queue = Consts.RenderQueueID_RQ_BASE;
            }
            
            return ctx;
        }
        
        
        /*!
        \brief
        return the RenderingSurface currently set for this window.  May return
        0.
        */
        public function getRenderingSurface():FlameRenderingSurface
        {
            return d_surface;
        }
        
        /*!
        \brief
        return the RenderingSurface that will be used by this window as the
        target for rendering.
        */
        public function getTargetRenderingSurface():FlameRenderingSurface
        {
            if (d_surface)
                return d_surface;
            else if (d_parent)
                return d_parent.getTargetRenderingSurface();
            else
                return FlameSystem.getSingleton().getRenderer().getDefaultRenderingRoot();
        }
        
        /*!
        \brief
        Returns whether \e automatic use of an imagery caching RenderingSurface
        (i.e. a RenderingWindow) is enabled for this window.  The reason we
        emphasise 'automatic' is because the client may manually set a
        RenderingSurface that does exactly the same job.
        
        \return
        - true if automatic use of a caching RenderingSurface is enabled.
        - false if automatic use of a caching RenderTarget is not enabled.
        */
        public function isUsingAutoRenderingSurface():Boolean
        {
            return d_autoRenderingWindow;
        }
        
        
        /*!
        \brief
        Returns the window at the root of the hierarchy starting at this
        Window.  The root window is defined as the first window back up the
        hierarchy that has no parent window.
        
        \return
        A pointer to the root window of the hierarchy that this window is
        attched to.
        */
        public function getRootWindow():FlameWindow
        {
            return d_parent ? d_parent.getRootWindow() : this;
        }
        
        
        //! return the rotations set for this window.
        public function getRotation():Vector3
        {
            return d_rotation;
        }

        /*!
        \brief
        Return whether the Window is a non-client window.
        
        A non-client window is clipped, positioned and sized according to the
        parent window's full area as opposed to just the inner rect area used
        for normal client windows.
        
        \return
        - true if the window should is clipped, positioned and sized according
        to the full area rectangle of it's parent.
        - false if the window is be clipped, positioned and sized according
        to the inner rect area of it's parent.
        */
        public function isNonClientWindow():Boolean
        {
            return d_nonClientContent;
        }
        
        /*!
        \brief
        Renames the window.
        
        \param new_name
        String object holding the new name for the window.
        
        \exception AlreadyExistsException
        thrown if a Window named \a new_name already exists in the system.
        */
        public function rename(new_name:String):void
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            /*
            * Client code should never call this, but again, since we know people do
            * not read and stick to the API reference, here is some built-in protection
            * which ensures that things are handled via the WindowManager anyway.
            */
            if (winMgr.isWindowPresent(d_name))
            {
                winMgr.renameWindowByWindow(this, new_name);
                // now we return, since the work was already done when WindowManager
                // re-called this function in the proper manner.
                return;
            }
            
            if (winMgr.isWindowPresent(new_name))
                throw new Error("Window::rename - Failed to rename " +
                    "Window: " + d_name + " as: " + new_name + ".  A Window named:" +
                    new_name + "' already exists within the system.");
            
            // rename Falagard created child windows
            if (d_lookName.length != 0)
            {
                const wlf:FalagardWidgetLookFeel =
                    FalagardWidgetLookManager.getSingleton().getWidgetLook(d_lookName);
                
                // get WidgetLookFeel to rename the children it created
                wlf.renameChildren(this, new_name);
            }
            
            // how to detect other auto created windows.
            const autoPrefix:String = d_name + AutoWidgetNameSuffix;
            // length of current name
            const oldNameLength:uint = d_name.length;
            
            // now rename all remaining auto-created windows attached
            for (var i:uint = 0; i < getChildCount(); ++i)
            {
                // is this an auto created window that we created?
                //if (!d_children[i].d_name.compare(0, autoPrefix.length(), autoPrefix))
                if (d_children[i].d_name.substr(0, autoPrefix.length) == autoPrefix)
                {
                    winMgr.renameWindowByWindow(d_children[i],
                        new_name + d_children[i].d_name.substr(oldNameLength));
                }
            }
            
            // log this under informative level
            trace("Renamed window: " + d_name + " as: " + new_name);
            
            // finally, set our new name
            d_name = new_name;
        }
        
        /*!
        \brief
        Initialises the Window based object ready for use.
        
        \note
        This must be called for every window created.  Normally this is handled
        automatically by the WindowManager.
        
        \return
        Nothing
        */
        public function initialiseComponents():void
        {
        }
        
        
        /*!
        \brief
        Set whether or not this Window will automatically be destroyed when its parent Window is destroyed.
        
        \param setting
        set to true to have the Window auto-destroyed when its parent is destroyed (default), or false to have the Window
        remain after its parent is destroyed.
        
        \return
        Nothing
        */
        public function setDestroyedByParent(setting:Boolean):void
        {
            if (d_destroyedByParent == setting)
                return;
            
            d_destroyedByParent = setting;
            
            var args:WindowEventArgs = new WindowEventArgs(this);
            onParentDestroyChanged(args);
        }
        
        
        /*!
        \brief
        Set whether this window is always on top, or not.
        
        \param setting
        true to have the Window appear on top of all other non always on top windows, or false to allow the window to be covered by other windows.
        
        \return
        Nothing
        */
        public function setAlwaysOnTop(setting:Boolean):void
        {
            // only react to an actual change
            if (isAlwaysOnTop() != setting)
            {
                d_alwaysOnTop = setting;
                
                // move us in front of sibling windows with the same 'always-on-top' setting as we have.
                if (d_parent != null)
                {
                    var org_parent:FlameWindow = d_parent;
                    
                    org_parent.removeChild_impl(this);
                    org_parent.addChild_impl(this);
                    
                    onZChange_impl();
                }
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onAlwaysOnTopChanged(args);
                
            }
        }
        
        
        /*!
        \brief
        Set whether this window is enabled or disabled.  A disabled window normally can not be interacted with, and may have different rendering.
        
        \param setting
        true to enable the Window, and false to disable the Window.
        
        \return
        Nothing
        */
        public function setEnabled(setting:Boolean):void
        {
            // only react if setting has changed
            if (d_enabled == setting)
                return;
            
            d_enabled = setting;
            var args:WindowEventArgs = new WindowEventArgs(this);
            
            if (d_enabled)
            {
                // check to see if the window is actually enabled (which depends upon all ancestor windows being enabled)
                // we do this so that events we fire give an accurate indication of the state of a window.
                if ((d_parent && !d_parent.isDisabled()) || !d_parent){
                    onEnabled(args);
                }
            }
            else
            {
                onDisabled(args);
            }
            FlameSystem.getSingleton().updateWindowContainingMouse();
            
        }
        
        
        /*!
        \brief
        enable the Window to allow interaction.
        
        \return
        Nothing
        */
        public function enable():void
        {
            setEnabled(true);
        }
        
        /*!
        \brief
        disable the Window to prevent interaction.
        
        \return
        Nothing
        */
        public function disable():void
        {
            setEnabled(false);
        }
        
        
        
        /*!
        \brief
        Set whether the Window is visible or hidden.
        
        \param setting
        true to make the Window visible, or false to make the Window hidden
        
        \return
        Nothing
        */
        public function setVisible(setting:Boolean):void
        {
            // only react if setting has changed
            if (d_visible == setting)
                return;
            
            d_visible = setting;
            
            var args:WindowEventArgs = new WindowEventArgs(this);
            if(d_visible)
            {
                onShown(args)
            } 
            else
            {
                onHidden(args);
            }
            
            FlameSystem.getSingleton().updateWindowContainingMouse();
        }
        
        /*!
        \brief
        show the Window.
        
        \note
        Showing a window does not automatically activate the window.  If you
        want the window to also become active you will need to call the
        Window::activate member also.
        
        \return
        Nothing
        */
        public function show():void
        {
            setVisible(true);
        }
        
        /*!
        \brief
        hide the Window.
        \note
        If the window is the active window, it will become deactivated as a
        result of being hidden.
        
        \return
        Nothing
        */
        public function hide():void
        {
            setVisible(false);
        }
        
        /*!
        \brief
        Activate the Window giving it input focus and bringing it to the top of all non always-on-top Windows.
        
        \return
        Nothing
        */
        public function activate():void
        { 
            // exit if the window is not visible, since a hidden window may not be the
            // active window.
            if (!isVisible())
                return;
            
            // force complete release of input capture.
            // NB: This is not done via releaseCapture() because that has
            // different behaviour depending on the restoreOldCapture setting.
            if (d_captureWindow && d_captureWindow != this)
            {
                var tmpCapture:FlameWindow = d_captureWindow;
                d_captureWindow = null;
                
                var args:WindowEventArgs = new WindowEventArgs(null);
                tmpCapture.onCaptureLost(args);
            }
            
            moveToFront();
        }
        
        
        /*!
        \brief
        Deactivate the window.  No further inputs will be received by the window until it is re-activated either programmatically or
        by the user interacting with the gui.
        
        \return
        Nothing.
        */
        public function deactivate():void
        {
            var args:ActivationEventArgs = new ActivationEventArgs(this);
            args.otherWindow = null;
            onDeactivated(args);
        }
        
        /*!
        \brief
        Set whether this Window will be clipped by its parent window(s).
        
        \param setting
        true to have the Window clipped so that rendering is constrained to within the area of its parent(s), or false to have rendering constrained
        to the screen only.
        
        \return
        Nothing
        */
        public function setClippedByParent(setting:Boolean):void
        {
            // only react if setting has changed
            if (d_clippedByParent == setting)
                return;

            d_clippedByParent = setting;
            var args:WindowEventArgs = new WindowEventArgs(this);
            onClippingChanged(args);
        }
        
        
        /*!
        \brief
        Set the current ID for the Window.
        
        \param ID
        Client assigned ID code for this Window.  The GUI system assigns no meaning to any IDs, they are a device purely for client code usage.
        
        \return
        Nothing
        */
        public function setID(ID:uint):void
        {
            if (d_ID != ID)
            {
                d_ID = ID;
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onIDChanged(args);
            }
        }

        public function setText(text:String):void
        {
            d_textLogical = text;
            d_renderedStringValid = false;
            //d_bidiDataValid = false;
            
            var args:WindowEventArgs = new WindowEventArgs(this);
            onTextChanged(args);
        }
        
        /*!
        \brief
        Insert the text string \a text into the current text string for the
        Window object at the position specified by \a position.
        
        \param text
        String object holding the text that is to be inserted into the Window
        object's current text string.
        
        \param position
        The characted index position where the string \a text should be
        inserted.
        */
        public function insertText(text:String, position:uint):void
        {
            var tmp:String = d_textLogical.slice(0, position) + text + d_textLogical.slice(position);
            d_textLogical = tmp;
            d_renderedStringValid = false;
            //d_bidiDataValid = false;
            
            var args:WindowEventArgs = new WindowEventArgs(this);
            onTextChanged(args);
        }
        
        /*!
        \brief
        Append the string \a text to the currect text string for the Window
        object.
        
        \param text
        String object holding the text that is to be appended to the Window
        object's current text string.
        */
        public function appendText(text:String):void
        {
            d_textLogical += text;
            d_renderedStringValid = false;
            //d_bidiDataValid = false;
            
            var args:WindowEventArgs = new WindowEventArgs(this);
            onTextChanged(args);
        }
        
        /*!
        \brief
        Set the font used by this Window.
        
        \param font
        Pointer to the Font object to be used by this Window.  If \a font is NULL, the default font will be used.
        
        \return
        Nothing
        */
        public function setFont(font:FlameFont):void
        {
            d_font = font;
            d_renderedStringValid = false;
            var args:WindowEventArgs = new WindowEventArgs(this);
            onFontChanged(args);
        }
        
        
        
        /*!
        \brief
        Set the font used by this Window.
        
        \param name
        String object holding the name of the Font object to be used by this Window.  If \a name == "", the default font will be used.
        
        \return
        Nothing
        
        \exception UnknownObjectException	thrown if the specified Font is unknown within the system.
        */
        public function setFontName(name:String):void
        {
            if (name == "")
            {
                setFont(null);
            }
            else
            {
                setFont(FlameFontManager.getSingleton().getFont(name));
            }
        }
        
        
        /*!
        \brief
        Add the named Window as a child of this Window.  If the Window \a name is already attached to a Window, it is detached before
        being added to this Window.
        
        \param name
        String object holding the name of the Window to be added.
        
        \return
        Nothing.
        
        \exception UnknownObjectException	thrown if no Window named \a name exists.
        \exception InvalidRequestException	thrown if Window \a name is an ancestor of this Window, to prevent cyclic Window structures.
        */
        public function addChildWindowByName(name:String):void
        {
            addChildWindow(FlameWindowManager.getSingleton().getWindow(name));
            
        }
        
        
        /*!
        \brief
        Add the specified Window as a child of this Window.  If the Window \a window is already attached to a Window, it is detached before
        being added to this Window.
        
        \param window
        Pointer to the Window object to be added.
        
        \return
        Nothing
        
        \exception InvalidRequestException	thrown if Window \a window is an ancestor of this Window, to prevent cyclic Window structures.
        */
        public function addChildWindow(window:FlameWindow):void
        {
            // don't add null window or ourself as a child
            if (!window || window == this)
                return;
            
            addChild_impl(window);
            var args:WindowEventArgs = new WindowEventArgs(window);
            onChildAdded(args);
            window.onZChange_impl();
        }
        
        
        /*!
        \brief
        Remove the named Window from this windows child list.
        
        \param name
        String object holding the name of the Window to be removed.  If the Window specified is not attached to this Window, nothing happens.
        
        \return
        Nothing.
        */
        
        public function removeChildWindowByName(name:String):void
        {
            var child_count:uint = getChildCount();
            
            for (var i:uint = 0; i < child_count; ++i)
            {
                if (d_children[i].getName() == name)
                {
                    removeChildWindow(d_children[i]);
                    return;
                }
                
            }
        }
        
        
        /*!
        \brief
        Remove the specified Window form this windows child list.
        
        \param window
        Pointer to the Window object to be removed.  If the \a window is not attached to this Window, then nothing happens.
        
        \return
        Nothing.
        */
        
        public function removeChildWindow(window:FlameWindow):void
        {
            removeChild_impl(window);
            var args:WindowEventArgs = new WindowEventArgs(window);
            onChildRemoved(args);
            window.onZChange_impl();
        }
        
        
        /*!
        \brief
        Remove the first child Window with the specified ID.  If there is more than one attached Window objects with the specified ID, only the fist
        one encountered will be removed.
        
        \param ID
        ID number assigned to the Window to be removed.  If no Window with ID code \a ID is attached, nothing happens.
        
        \return
        Nothing.
        */
        public function removeChildWindowByID(ID:uint):void
        {
            var child_count:uint = getChildCount();
            
            for (var i:uint = 0; i < child_count; ++i)
            {
                if (d_children[i].getID() == ID)
                {
                    removeChildWindow(d_children[i]);
                    return;
                }
                
            }
        }
        
        
        /*!
        \brief
        Move the Window to the top of the z order.
        
        - If the Window is a non always-on-top window it is moved the the top of all other non always-on-top sibling windows, and the process
        repeated for all ancestors.
        - If the Window is an always-on-top window it is moved to the of of all sibling Windows, and the process repeated for all ancestors.
        
        \return
        Nothing
        */
        
        public function moveToFront():void
        {
            moveToFront_impl(false);
        }
        
        
     
        /*!
        \brief
        Move the Window to the bottom of the Z order.
        
        - If the window is non always-on-top the Window is sent to the very bottom of its sibling windows and the process repeated for all ancestors.
        - If the window is always-on-top, the Window is sent to the bottom of all sibling always-on-top windows and the process repeated for all ancestors.
        
        \return
        Nothing
        */
        public function moveToBack():void
        {
            // if the window is active, de-activate it.
            if (isActive())
            {
                var args:ActivationEventArgs = new ActivationEventArgs(this);
                args.otherWindow = null;
                onDeactivated(args);
            }
            
            // we only need to proceed if we have a parent (otherwise we have no siblings)
            if (d_parent)
            {
                if (d_zOrderingEnabled)
                {
                    // remove us from our parent's draw list
                    d_parent.removeWindowFromDrawList(this);
                    // re-attach ourselves to our parent's draw list which will move us in behind
                    // sibling windows with the same 'always-on-top' setting as we have.
                    d_parent.addWindowToDrawList(this, true);
                    // notify relevant windows about the z-order change.
                    onZChange_impl();
                }
                
                d_parent.moveToBack();
            }
        }
        
        /*!
        \brief
        Move this window immediately above it's sibling \a window in the z order.
        
        No action will be taken under the following conditions:
        - \a window is 0.
        - \a window is not a sibling of this window.
        - \a window and this window have different AlwaysOnTop settings.
        - z ordering is disabled for this window.
        
        \param window
        The sibling window that this window will be moved in front of.
        */
        public function moveInFront(window:FlameWindow):void
        {
            if (!window || !window.d_parent || window.d_parent != d_parent ||
                window == this || window.d_alwaysOnTop != d_alwaysOnTop ||
                !d_zOrderingEnabled)
                return;
            
//            // find our position in the parent child draw list
//            const ChildList::iterator p(std::find(d_parent->d_drawList.begin(),
//                d_parent->d_drawList.end(),
//                this));
//            // sanity checK that we were attached to our parent.
//            assert(p != d_parent->d_drawList.end());
            
            var pos:int = d_parent.d_drawList.indexOf(this);
            Misc.assert(pos != -1);

            // erase us from our current position
            d_parent.d_drawList.splice(pos, 1);
            
//            // find window we're to be moved in front of in parent's draw list
//            ChildList::iterator i(std::find(d_parent->d_drawList.begin(),
//                d_parent->d_drawList.end(),
//                window));
//            // sanity check that target window was also attached to correct parent.
//            assert(i != d_parent->d_drawList.end());
            
            pos = d_parent.d_drawList.indexOf(window);
            Misc.assert(pos != -1);
            
            // reinsert ourselves at the right location
            d_parent.d_drawList.splice(pos+1, 0, this);// .insert(++i, this);
            
            // handle event notifications for affected windows.
            onZChange_impl();
        }
        
        /*!
        \brief
        Move this window immediately behind it's sibling \a window in the z
        order.
        
        No action will be taken under the following conditions:
        - \a window is 0.
        - \a window is not a sibling of this window.
        - \a window and this window have different AlwaysOnTop settings.
        - z ordering is disabled for this window.
        
        \param window
        The sibling window that this window will be moved behind.
        */
        public function moveBehind(window:FlameWindow):void
        {
            if (!window || !window.d_parent || window.d_parent != d_parent ||
                window == this || window.d_alwaysOnTop != d_alwaysOnTop ||
                !d_zOrderingEnabled)
                return;
            
//            // find our position in the parent child draw list
//            const ChildList::iterator p(std::find(d_parent->d_drawList.begin(),
//                d_parent->d_drawList.end(),
//                this));
//            // sanity checK that we were attached to our parent.
//            assert(p != d_parent->d_drawList.end());
            var pos:int = d_parent.d_drawList.indexOf(this);
            Misc.assert(pos != -1);
            
            // erase us from our current position
            d_parent.d_drawList.splice(pos, 1);
            
//            // find window we're to be moved in front of in parent's draw list
//            const ChildList::iterator i(std::find(d_parent->d_drawList.begin(),
//                d_parent->d_drawList.end(),
//                window));
//            // sanity check that target window was also attached to correct parent.
//            assert(i != d_parent->d_drawList.end());
            pos == d_parent.d_drawList.indexOf(window);
            Misc.assert(pos != -1);
            
            // reinsert ourselves at the right location
            d_parent.d_drawList.splice(pos, 0, this);
            
            // handle event notifications for affected windows.
            onZChange_impl();
        }
        
        
        /*!
        \brief
        Captures input to this window
        
        \return
        - true if input was successfully captured to this window.
        - false if input could not be captured to this window (maybe because the window is not active).
        */
        public function captureInput():Boolean
        {
            // we can only capture if we are the active window
            if (!isActive()) 
                return false;
            
            if(d_captureWindow != this)
            {
                
                var current_capture:FlameWindow = d_captureWindow;
                d_captureWindow = this;
                var args:WindowEventArgs = new WindowEventArgs(this);
                
                // inform any window which previously had capture that it doesn't anymore!
                if ((current_capture != null) && (current_capture != this) && (!d_restoreOldCapture)) {
                    current_capture.onCaptureLost(args);
                }
                
                if (d_restoreOldCapture) {
                    d_oldCapture = current_capture;
                }
                
                onCaptureGained(args);
            }
            
            return true;
        }
        
        /*!
        \brief
        Releases input capture from this Window.  If this Window does not have inputs captured, nothing happens.
        
        \return
        Nothing
        */
        public function releaseInput():void
        {
            // if we are not the window that has capture, do nothing
            if (!isCapturedByThis())
                return;
            
            // restore old captured window if that mode is set
            if (d_restoreOldCapture) {
                d_captureWindow = d_oldCapture;
                
                // check for case when there was no previously captured window
                if (d_oldCapture != null) {
                    d_oldCapture = null;
                    d_captureWindow.moveToFront();
                }
                
            }
            else {
                d_captureWindow = null;
            }
            
            var args:WindowEventArgs = new WindowEventArgs(this);
            onCaptureLost(args);
        }
        
        /*!
        \brief
        Set whether this window will remember and restore the previous window that had inputs captured.
        
        \param setting
        - true: The window will remember and restore the previous capture window.  The CaptureLost event is not fired
        on the previous window when this window steals input capture.  When this window releases capture, the old capture
        window is silently restored.
        
        - false: Input capture works as normal, each window losing capture is signalled via CaptureLost, and upon the final
        release of capture, no previous setting is restored (this is the default 'normal' behaviour).
        
        \return
        Nothing
        */
        public function setRestoreCapture(setting:Boolean):void
        {
            d_restoreOldCapture = setting;
            
            var child_count:uint = getChildCount();
            
            for (var i:uint = 0; i < child_count; ++i)
            {
                d_children[i].setRestoreCapture(setting);
            }
        }
        
        
        
        /*!
        \brief
        Set the current alpha value for this window.
        
        \note
        The alpha value set for any given window may or may not be the final alpha value that is used when rendering.  All window
        objects, by default, inherit alpha from thier parent window(s) - this will blend child windows, relatively, down the line of
        inheritance.  This behaviour can be overridden via the setInheritsAlpha() method.  To return the true alpha value that will be
        applied when rendering, use the getEffectiveAlpha() method.
        
        \param alpha
        The new alpha value for the window.  Value should be between 0.0f and 1.0f.
        
        \return
        Nothing
        */
        public function setAlpha(alpha:Number):void
        {
            // clamp this to the valid range [0.0, 1.0]
            d_alpha = Math.max(Math.min(alpha, 1), 0);
            var args:WindowEventArgs = new WindowEventArgs(this);
            onAlphaChanged(args);
        }
        
        /*!
        \brief
        Sets whether this Window will inherit alpha from its parent windows.
        
        \param setting
        true if the Window should use inherited alpha, or false if the Window should have an independant alpha value.
        
        \return
        Nothing
        */
        public function setInheritsAlpha(setting:Boolean):void
        {
            if (d_inheritsAlpha != setting)
            {
                // store old effective alpha so we can test if alpha value changes due to new setting.
                var oldAlpha:Number = getEffectiveAlpha();
                
                // notify about the setting change.
                d_inheritsAlpha = setting;
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onInheritsAlphaChanged(args);
                
                // if effective alpha has changed fire notification about that too
                if (oldAlpha != getEffectiveAlpha())
                {
                    var args2:WindowEventArgs = new WindowEventArgs(this);
                    args2.handled = 0;
                    onAlphaChanged(args2);
                }
            }
        }
        
        
        /*!
        \brief
        Invalidate this window causing at least this window to be redrawn during
        the next rendering pass.
        
        \return
        Nothing
        
        \deprecated
        This function is deprecated in favour of the version taking a boolean.
        */
        public function invalidate():void
        {
            invalidateRecursive(false);
        }
        
        /*!
        \brief
        Invalidate this window and - dependant upon \a recursive - all child
        content, causing affected windows to be redrawn during the next
        rendering pass.
        
        \param recursive
        Boolean value indicating whether attached child content should also be
        invalidated.
        - true will cause all child content to be invalidated also.
        - false will just invalidate this single window.
        
        \return
        Nothing
        */
        public function invalidateRecursive(recursive:Boolean):void
        {
            invalidate_impl(recursive);
            FlameSystem.getSingleton().signalRedraw();
        }
        
        
        /*!
        \brief
        Set the mouse cursor image to be used when the mouse enters this window.
        
        \param image
        Pointer to the Image object to use as the mouse cursor image when the mouse enters the area for this Window.
        
        \return
        Nothing.
        */
        public function setMouseCursor(image:FlameImage):void
        {
            d_mouseCursor = image;
            
            if (FlameSystem.getSingleton().getWindowContainingMouse() == this)
            {
//                const default_cursor:FlameImage =
//                    reinterpret_cast<const Image*>(DefaultMouseCursor);
//                
//                if (default_cursor == image)
//                    image = System::getSingleton().getDefaultMouseCursor();
//                
                FlameMouseCursor.getSingleton().setImage(image);
            }
        }
        
        
        /*!
        \brief
        Set the mouse cursor image to be used when the mouse enters this window.
        
        \param image
        One of the MouseCursorImage enumerated values.
        
        \return
        Nothing.
        */
//        public function setMouseCursor(image:uint):void
//        {
//            //d_mouseCursor = (const Image*)image;
//        }
        
        /*!
        \brief
        Set the mouse cursor image to be used when the mouse enters this window.
        
        \param imageset
        String object that contains the name of the Imageset that contains the image to be used.
        
        \param image_name
        String object that contains the name of the Image on \a imageset that is to be used.
        
        \return
        Nothing.
        
        \exception UnknownObjectException	thrown if \a imageset is not known, or if \a imageset contains no Image named \a image_name.
        */
        public function setMouseCursorFromImageSet(imageset:String, image_name:String):void
        {
            var img:FlameImage = FlameImageSetManager.getSingleton().getImageSet(imageset).getImage(image_name);
            this.setMouseCursor(img);
        }
        
        
        /*!
        \brief
        Set the user data set for this Window.
        
        Each Window can have some client assigned data attached to it, this data is not used by the GUI system
        in any way.  Interpretation of the data is entirely application specific.
        
        \param user_data
        pointer to the user data that is to be set for this window.
        
        \return
        Nothing.
        */
        public function setUserData(user_data:*):void
        {
            d_userData = user_data;
        }
        
        
        /*!
        \brief
        Set whether z-order changes are enabled or disabled for this Window.
        
        \param setting
        - true if z-order changes are enabled for this window.  moveToFront/moveToBack work normally as expected.
        - false: z-order changes are disabled for this window.  moveToFront/moveToBack are ignored for this window.
        
        \return
        Nothing.
        */
        public function setZOrderingEnabled(setting:Boolean):void
        {
            if (d_zOrderingEnabled != setting)
            {
                d_zOrderingEnabled = setting;
            }
        }
        
        
        /*!
        \brief
        Set whether this window will receive multi-click events or multiple 'down' events instead.
        
        \param setting
        - true if the Window will receive double-click and triple-click events.
        - false if the Window will receive multiple mouse button down events instead of double/triple click events.
        
        \return
        Nothing.
        */
        public function setWantsMultiClickEvents(setting:Boolean):void
        {
            if (d_wantsMultiClicks != setting)
            {
                d_wantsMultiClicks = setting;
                
                // TODO: Maybe add a 'setting changed' event for this?
            }
        }
        
        
        /*!
        \brief
        Set whether mouse button down event autorepeat is enabled for this window.
        
        \param setting
        - true to enable autorepeat of mouse button down events.
        - false to disable autorepeat of mouse button down events.
        
        \return
        Nothing.
        */
        public function setMouseAutoRepeatEnabled(setting:Boolean):void
        {
            if (d_autoRepeat == setting)
                return;
            
            d_autoRepeat = setting;
            d_repeatButton = Consts.MouseButton_NoButton;
            
            // FIXME: There is a potential issue here if this setting is
            // FIXME: changed _while_ the mouse is auto-repeating, and
            // FIXME: the 'captured' state of input could get messed up.
            // FIXME: The alternative is to always release here, but that
            // FIXME: has a load of side effects too - so for now nothing
            // FIXME: is done.  This whole aspect of the system needs a
            // FIXME: review an reworking - though such a change was
            // FIXME: beyond the scope of the bug-fix that originated this
            // FIXME: comment block.  PDT - 30/10/06
        }
        
        /*!
        \brief
        Set the current auto-repeat delay setting for this window.
        
        \param delay
        float value indicating the delay, in seconds, defore the first repeat mouse button down event should be triggered when autorepeat is enabled.
        
        \return
        Nothing.
        */
        public function setAutoRepeatDelay(delay:Number):void
        {
            d_repeatDelay = delay;
        }
        
        
        /*!
        \brief
        Set the current auto-repeat rate setting for this window.
        
        \param rate
        float value indicating the rate, in seconds, at which repeat mouse button down events should be generated after the initial delay has expired.
        
        \return
        Nothing.
        */
        public function setAutoRepeatRate(rate:Number):void
        {
            d_repeatRate = rate;
        }
        
        
        /*!
        \brief
        Set whether the window wants inputs passed to its attached
        child windows when the window has inputs captured.
        
        \param setting
        - true if System should pass captured input events to child windows.
        - false if System should pass captured input events to this window only.
        */
        public function setDistributesCapturedInputs(setting:Boolean):void
        {
            d_distCapturedInputs = setting;
        }
        

        
        
        /*!
        \brief
        Internal support method for drag & drop.  You do not normally call
        this directly from client code.  See the DragContainer class.
        */
        public function notifyDragDropItemEnters(item:FlameDragContainer):void
        {
            if (!item)
                return;
            
            var args:DragDropEventArgs = new DragDropEventArgs(this);
            args.dragDropItem = item;
            onDragDropItemEnters(args);
            
        }
        
        /*!
        \brief
        Internal support method for drag & drop.  You do not normally call
        this directly from client code.  See the DragContainer class.
        */
        public function notifyDragDropItemLeaves(item:FlameDragContainer):void
        {
            if (!item)
                return;
            
            var args:DragDropEventArgs = new DragDropEventArgs(this);
            args.dragDropItem = item;
            onDragDropItemLeaves(args);
        }
        
        /*!
        \brief
        Internal support method for drag & drop.  You do not normally call
        this directly from client code.  See the DragContainer class.
        */
        public function notifyDragDropItemDropped(item:FlameDragContainer):void
        {
            if (!item)
                return;
            
            var args:DragDropEventArgs = new DragDropEventArgs(this);
            args.dragDropItem = item;
            onDragDropItemDropped(args);
        }
        

        
        /*!
        \brief
        Internal destroy method which actually just adds the window and any 
        parent destructed child windows to the dead pool.
        
        This is virtual to allow for specialised cleanup which may be required
        in some advanced cases.  If you override this for the above reason, you
        MUST call this base class version.
        
        \note
        You never have to call this method yourself, use WindowManager to
        destroy your Window objects (which will call this for you).
        */
        public function destroy():void
        {
            // because we know that people do not read the API ref properly,
            // here is some protection to ensure that WindowManager does the
            // destruction and not anyone else.
            var wmgr:FlameWindowManager = FlameWindowManager.getSingleton();
            
            if (wmgr.isWindowPresent(getName()))
            {
                wmgr.destroyWindow(this);
                
                // now return, the rest of what we need to do will happen
                // once WindowManager re-calls this method.
                return;
            }
            
            // signal our imminent destruction
            var args:WindowEventArgs = new WindowEventArgs(this);
            onDestructionStarted(args);
            
            releaseInput();
            
            // let go of the tooltip if we have it
            const tip:FlameTooltip = getTooltip();
            if (tip && tip.getTargetWindow()==this)
                tip.setTargetWindow(null);
            
            // ensure custom tooltip is cleaned up
            setTooltip(null);
            
            // clean up looknfeel related things
            if (d_lookName.length != 0)
            {
                d_windowRenderer.onLookNFeelUnassigned();
                FalagardWidgetLookManager.getSingleton().getWidgetLook(d_lookName).
                    cleanUpWidget(this);
            }
            
            // free any assigned WindowRenderer
            if (d_windowRenderer != null)
            {
                d_windowRenderer.onDetach();
                FlameWindowRendererManager.getSingleton().
                    destroyWindowRenderer(d_windowRenderer);
                d_windowRenderer = null;
            }
            
            // double check we are detached from parent
            if (d_parent)
                d_parent.removeChildWindow(this);
            
            cleanupChildren();
            
            releaseRenderingWindow();
            invalidate();
        }
        
        /*!
        \brief
        Set the custom Tooltip object for this Window.  This value may be NULL to indicate that the
        Window should use the system default Tooltip object.
        
        \param tooltip
        Pointer to a valid Tooltip based object which should be used as the tooltip for this Window, or NULL to
        indicate that the Window should use the system default Tooltip object.  Note that when passing a pointer
        to a Tooltip object, ownership of the Tooltip does not pass to this Window object.
        
        \return
        Nothing.
        */
        
        public function setTooltip(tooltip:FlameTooltip):void
        {
            // destroy current custom tooltip if one exists and we created it
            if (d_customTip && d_weOwnTip){
                FlameWindowManager.getSingleton().destroyWindow(d_customTip);
            }
            
            // set new custom tooltip
            d_weOwnTip = false;
            d_customTip = tooltip;
        }
        
        
        /*!
        \brief
        Set the custom Tooltip to be used by this Window by specifying a Window type.
        
        The Window will internally attempt to create an instance of the specified window type (which must be
        derived from the base Tooltip class).  If the Tooltip creation fails, the error is logged and the
        Window will revert to using either the existing custom Tooltip or the system default Tooltip.
        
        \param tooltipType
        String object holding the name of the Tooltip based Window type which should be used as the Tooltip for
        this Window.
        
        \return
        Nothing.
        */
        public function setTooltipType(tooltipType:String):void
        {
            // destroy current custom tooltip if one exists and we created it
            if (d_customTip && d_weOwnTip)
                FlameWindowManager.getSingleton().destroyWindow(d_customTip);
            
            if (tooltipType.length == 0)
            {
                d_customTip = null;
                d_weOwnTip = false;
            }
            else
            {
                try
                {
                    d_customTip = FlameWindowManager.getSingleton().createWindow(
                        tooltipType, getName() + TooltipNameSuffix) as FlameTooltip;
                    d_weOwnTip = true;
                }
                catch(error:Error)
                {
                    d_customTip = null;
                    d_weOwnTip = false;
                }
            }
        }
        
        
        
        
        /*!
        \brief
        Set the tooltip text for this window.
        
        \param tip
        String object holding the text to be displayed in the tooltip for this Window.
        
        \return
        Nothing.
        */
        public function setTooltipText(tip:String):void
        {
            d_tooltipText = tip;
            
            var tooltip:FlameTooltip = getTooltip();
            
            if (tooltip && tooltip.getTargetWindow() == this)
                tooltip.setText(tip);
            
        }
        
        
        
        
        /*!
        \brief
        Set whether this window inherits Tooltip text from its parent when its own tooltip text is not set.
        
        \param setting
        - true if the window should inherit tooltip text from its parent when its own text is not set.
        - false if the window should not inherit tooltip text from its parent (and so show no tooltip when no text is set).
        
        \return
        Nothing.
        */
        public function setInheritsTooltipText(setting:Boolean):void
        {
            d_inheritsTipText = setting;
        }
        
        
        
        /*!
        \brief
        Set whether this window will rise to the top of the z-order when clicked with the left mouse button.
        
        \param setting
        - true if the window should come to the top of other windows when the left mouse button is pushed within its area.
        - false if the window should not change z-order position when the left mouse button is pushed within its area.
        
        \return
        Nothing.
        */
        public function setRiseOnClickEnabled(setting:Boolean):void
        {
            d_riseOnClick = setting;
        }
        
        
        /*!
        \brief
        Set the vertical alignment.
        
        Modifies the vertical alignment for the window.  This setting affects how the windows position is
        interpreted relative to its parent.
        
        \param alignment
        One of the VerticalAlignment enumerated values.
        
        \return
        Nothing.
        */
        public function setVerticalAlignment(alignment:uint):void
        {
            if (d_vertAlign == alignment)
                return;
            
            d_vertAlign = alignment;
            
            var args:WindowEventArgs = new WindowEventArgs(this);
            onVerticalAlignmentChanged(args);
        }
        
        /*!
        \brief
        Set the horizontal alignment.
        
        Modifies the horizontal alignment for the window.  This setting affects how the windows position is
        interpreted relative to its parent.
        
        \param alignment
        One of the HorizontalAlignment enumerated values.
        
        \return
        Nothing.
        */
        public function setHorizontalAlignment(alignment:uint):void
        {
            if (d_horzAlign == alignment)
                return;
            
            d_horzAlign = alignment;
            
            var args:WindowEventArgs = new WindowEventArgs(this);
            onHorizontalAlignmentChanged(args);
        }

        
        /*!
        \brief
        Set the LookNFeel that shoule be used for this window.
        
        \param falagardType
        String object holding the mapped falagard type name (since actual window type will be "Falagard/something")
        and not what was passed to WindowManager.  This will be returned from getType instead of the base type.
        
        \param look
        String object holding the name of the look to be assigned to the window.
        
        \return
        Nothing.
        
        \exception InvalidRequestException thrown if the window already has a look assigned to it.
        */
        public function setLookNFeel(look:String):void
        {
            if (!d_windowRenderer)
                throw new Error("Window::setLookNFeel: There must be a " +
                    "window renderer assigned to the window '" + d_name +
                    "' to set its look'n'feel");
            
            var wlMgr:FalagardWidgetLookManager = FalagardWidgetLookManager.getSingleton();
            if (d_lookName.length != 0)
            {
                d_windowRenderer.onLookNFeelUnassigned();
                var wlf:FalagardWidgetLookFeel = wlMgr.getWidgetLook(d_lookName);
                wlf.cleanUpWidget(this);
            }
            
            d_lookName = look;
            
            //trace("Assigning LookNFeel '" + look + "' to window '" + d_name + "'.");
            
            
            // Work to initialise the look and feel...
            wlf = wlMgr.getWidgetLook(look);
            // Get look and feel to initialise the widget as it needs.
            wlf.initialiseWidget(this);
            // do the necessary binding to the stuff added by the look and feel
            initialiseComponents();
            // let the window renderer know about this
            d_windowRenderer.onLookNFeelAssigned();
            
            invalidate();
            performChildWindowLayout();
        }
        
        
        /*!
        \brief
        Set the modal state for this Window.
        
        \param state
        Boolean value defining if this Window should be the modal target.
        If true, this Window will be activated and set as the modal target.
        If false, the modal target will be cleared if this Window is currently the modal target.
        
        \return
        Nothing.
        */
        
        public function setModalState(state:Boolean):void
        {
            if(getModalState() == state)
                return;
            
            // if going modal and not already the modal target
            if (state)
            {
                activate();
                FlameSystem.getSingleton().setModalTarget(this);
            }
                // clear the modal target if we were it
            else
            {
                FlameSystem.getSingleton().setModalTarget(null);
            }
            
        }
        
        /*!
        \brief
        method called to perform extended laying out of attached child windows.
        
        The system may call this at various times (like when it is resized for example), and it
        may be invoked directly where required.
        
        \return
        Nothing.
        */
        public function performChildWindowLayout():void
        {
            if (d_lookName.length == 0)
                return;
            
            // here we just grab the look and feel and get it to layout its defined children
//            try
//            {
                const wlf:FalagardWidgetLookFeel = FalagardWidgetLookManager.getSingleton().getWidgetLook(d_lookName);
                // get look'n'feel to layout any child windows it created.
                wlf.layoutChildWidgets(this);
//            }
//            catch(e:Error)
//            {
//                throw new Error("Window::performChildWindowLayout - assigned widget look was not found.");
//            }
        }
        
        
        /*!
        \brief
        Sets the value a named user string, creating it as required.
        
        \param name
        String object holding the name of the string to be returned.
        
        \param value
        String object holding the value to be assigned to the user string.
        
        \return
        Nothing.
        */
        public function setUserString(name:String, value:String):void
        {
            d_userStrings[name] = value;
        }
        
        /*!
        \brief
        Set the window area.
        
        Sets the area occupied by this window.  The defined area is offset from
        the top-left corner of this windows parent window or from the top-left
        corner of the display if this window has no parent (i.e. it is the root
        window).
        
        \note
        This method makes use of "Unified Dimensions".  These contain both
        parent relative and absolute pixel components, which are used in
        determining the final value used.
        
        \param pos
        UVector2 describing the new position (top-left corner) of the window
        area.
        
        \param size
        UVector2 describing the new size of the window area.
        */
        public function setArea(pos:UVector2, size:UVector2):void
        {
            // Limit the value we set to something that's within the constraints
            // specified via the min and max size settings.
            
            // get size of 'base' - i.e. the size of the parent region.
            var base_sz:Size = (d_parent && !d_nonClientContent) ?
                d_parent.getUnclippedInnerRect().getSize() :
                getParentPixelSize();
            
            var newsz:UVector2 = new UVector2(size.d_x.clone(), size.d_y.clone());
            constrainUVector2ToMinSize(base_sz, newsz);
            constrainUVector2ToMaxSize(base_sz, newsz);
            
            setArea_impl(pos, newsz);            
            
            //trace("area:" + d_area.toString());
        }
        
        /*!
        \brief
        Set the window area.
        
        Sets the area occupied by this window.  The defined area is offset from
        the top-left corner of this windows parent window or from the top-left
        corner of the display if this window has no parent (i.e. it is the root
        window).
        
        \note
        This method makes use of "Unified Dimensions".  These contain both
        parent relative and absolute pixel components, which are used in
        determining the final value used.
        
        \param area
        URect describing the new area rectangle of the window area.
        */
        public function setAreaByURect(area:URect):void
        {
            //setRectWithMetrics(getMetricsMode(), area);
            
            setArea(area.d_min, area.getSize());
        }
        
        
        /*!
        \brief
        Set the window area.
        
        Sets the area occupied by this window.  The defined area is offset from
        the top-left corner of this windows parent window or from the top-left
        corner of the display if this window has no parent (i.e. it is the root
        window).
        
        \note
        This method makes use of "Unified Dimensions".  These contain both
        parent relative and absolute pixel components, which are used in
        determining the final value used.
        
        \param xpos
        UDim describing the new x co-ordinate (left edge) of the window area.
        
        \param ypos
        UDim describing the new y co-ordinate (top-edge) of the window area.
        
        \param width
        UDim describing the new width of the window area.
        
        \param height
        UDim describing the new height of the window area.
        */
        public function setAreaByUDims(xpos:UDim, ypos:UDim, width:UDim, height:UDim):void
        {
            setArea(new UVector2(xpos, ypos), new UVector2(width, height));
        }
        
        
        
        /*!
        \brief
        Set the current position of the Window.  Interpretation of the input value \a position is dependant upon the current metrics system set for the Window.
        
        \param position
        Point object that describes the new postion of the Window, in units consistent with the current metrics mode.
        
        \return
        Nothing
        */
        public function setPosition(pos:UVector2):void
        {
            setArea_impl(pos, d_area.getSize());
        }
        
        
        /*!
        \brief
        Set the window's X position.
        
        Sets the x position (left edge) of the area occupied by this window.
        The position is offset from the left edge of this windows parent window
        or from the left edge of the display if this window has no parent
        (i.e. it is the root window).
        
        \note
        This method makes use of "Unified Dimensions".  These contain both
        parent relative and absolute pixel components, which are used in
        determining the final value used.
        
        \param x
        UDim describing the new x position of the window area.
        */
        public function setXPosition(x:UDim):void
        {
            setArea_impl(new UVector2(x, d_area.d_min.d_y), d_area.getSize());
        }
        
        /*!
        \brief
        Set the window's Y position.
        
        Sets the y position (top edge) of the area occupied by this window.
        The position is offset from the top edge of this windows parent window
        or from the top edge of the display if this window has no parent
        (i.e. it is the root window).
        
        \note
        This method makes use of "Unified Dimensions".  These contain both
        parent relative and absolute pixel components, which are used in
        determining the final value used.
        
        \param y
        UDim describing the new y position of the window area.
        */
        public function setYPosition(y:UDim):void
        {
            setArea_impl(new UVector2(d_area.d_min.d_x, y), d_area.getSize());
        }
        
        
        /*!
        \brief
        Set the window's size.
        
        Sets the size of the area occupied by this window.
        
        \note
        This method makes use of "Unified Dimensions".  These contain both
        parent relative and absolute pixel components, which are used in
        determining the final value used.
        
        \param size
        UVector2 describing the new size of the window area.
        */
        public function setSize(size:UVector2):void
        {
            // Limit the value we set to something that's within the constraints
            // specified via the min and max size settings.
            
            // get size of 'base' - i.e. the size of the parent region.
            var base_sz:Size = (d_parent && !d_nonClientContent) ?
                d_parent.getUnclippedInnerRect().getSize() :
                getParentPixelSize();
            
            var newsz:UVector2 = size.clone();
            constrainUVector2ToMinSize(base_sz, newsz);
            constrainUVector2ToMaxSize(base_sz, newsz);
            
            // set the new size.
            setArea_impl(d_area.getPosition(), newsz);
        }
        
        
        /*!
        \brief
        Set the window's width.
        
        Sets the width of the area occupied by this window.
        
        \note
        This method makes use of "Unified Dimensions".  These contain both
        parent relative and absolute pixel components, which are used in
        determining the final value used.
        
        \param width
        UDim describing the new width of the window area.
        */
        public function setWidth(width:UDim):void
        {
            setSize(new UVector2(width, d_area.getSize().d_y));
        }
        
        /*!
        \brief
        Set the window's height.
        
        Sets the height of the area occupied by this window.
        
        \note
        This method makes use of "Unified Dimensions".  These contain both
        parent relative and absolute pixel components, which are used in
        determining the final value used.
        
        \param height
        UDim describing the new height of the window area.
        */
        public function setHeight(height:UDim):void
        {
            setSize(new UVector2(d_area.getSize().d_x, height));
        }
        
        /*!
        \brief
        Set the window's maximum size.
        
        Sets the maximum size that this windows area may occupy (whether size
        changes occur by user interaction, general system operation, or by
        direct setting by client code).
        
        \note
        This method makes use of "Unified Dimensions".  These contain both
        parent relative and absolute pixel components, which are used in
        determining the final value used.
        
        \param size
        UVector2 describing the new maximum size of the window area.
        */
        public function setMaxSize(size:UVector2):void
        {
            
            d_maxSize = size;
            
            // Apply set maximum size to the windows set size.
            // We can't use code in setArea[_impl] to adjust the set size, because
            // that code has to ensure that it's possible for a size constrained
            // window to 'recover' it's original (scaled) sizing when the constraint
            // no longer needs to be applied.
            
            // get size of 'base' - i.e. the size of the parent region.
            var base_sz:Size = (d_parent && !d_nonClientContent) ?
                d_parent.getUnclippedInnerRect().getSize() :
                getParentPixelSize();
            
            var wnd_sz:UVector2 = getSize();
            
            if (constrainUVector2ToMaxSize(base_sz, wnd_sz))
                setSize(wnd_sz);
            
        }
        
        /*!
        \brief
        Set the window's minimum size.
        
        Sets the minimum size that this windows area may occupy (whether size
        changes occur by user interaction, general system operation, or by
        direct setting by client code).
        
        \note
        This method makes use of "Unified Dimensions".  These contain both
        parent relative and absolute pixel components, which are used in
        determining the final value used.
        
        \param size
        UVector2 describing the new minimum size of the window area.
        */
        public function setMinSize(size:UVector2):void
        {
            d_minSize = size;
            
            // Apply set minimum size to the windows set size.
            // We can't use code in setArea[_impl] to adjust the set size, because
            // that code has to ensure that it's possible for a size constrained
            // window to 'recover' it's original (scaled) sizing when the constraint
            // no longer needs to be applied.
            
            // get size of 'base' - i.e. the size of the parent region.
            var base_sz:Size = (d_parent && !d_nonClientContent) ?
                d_parent.getUnclippedInnerRect().getSize() :
                getParentPixelSize();
            
            var wnd_sz:UVector2 = getSize();
            
            if (constrainUVector2ToMinSize(base_sz, wnd_sz))
                setSize(wnd_sz);
            
        }
        
        
        /*!
        \brief
        Return the windows area.
        
        Returns the area occupied by this window.  The defined area is offset
        from the top-left corner of this windows parent window or from the
        top-left corner of the display if this window has no parent
        (i.e. it is the root window).
        
        \note
        This method makes use of "Unified Dimensions".  These contain both
        parent relative and absolute pixel components, which are used in
        determining the final value used.
        
        \return
        URect describing the rectangle of the window area.
        */
        public function getArea():URect
        {
            return d_area;
        }
        
        
        /*!
        \brief
        Get the window's position.
        
        Gets the position of the area occupied by this window.  The position is
        offset from the top-left corner of this windows parent window or from
        the top-left corner of the display if this window has no parent
        (i.e. it is the root window).
        
        \note
        This method makes use of "Unified Dimensions".  These contain both
        parent relative and absolute pixel components, which are used in
        determining the final value used.
        
        \return
        UVector2 describing the position (top-left corner) of the window area.
        */
        public function getPosition():UVector2
        {
            return d_area.d_min;
        }
        
        
        
        
        /*!
        \brief
        Get the window's X position.
        
        Gets the x position (left edge) of the area occupied by this window.
        The position is offset from the left edge of this windows parent window
        or from the left edge of the display if this window has no parent
        (i.e. it is the root window).
        
        \note
        This method makes use of "Unified Dimensions".  These contain both
        parent relative and absolute pixel components, which are used in
        determining the final value used.
        
        \return
        UDim describing the x position of the window area.
        */
        public function getXPosition():UDim
        {
            return d_area.d_min.d_x;
        }
        
        /*!
        \brief
        Get the window's Y position.
        
        Gets the y position (top edge) of the area occupied by this window.
        The position is offset from the top edge of this windows parent window
        or from the top edge of the display if this window has no parent
        (i.e. it is the root window).
        
        \note
        This method makes use of "Unified Dimensions".  These contain both
        parent relative and absolute pixel components, which are used in
        determining the final value used.
        
        \return
        UDim describing the y position of the window area.
        */
        public function getYPosition():UDim
        {
            return d_area.d_min.d_y;
        }
        

        /*!
        \brief
        Get the window's size.
        
        Gets the size of the area occupied by this window.
        
        \note
        This method makes use of "Unified Dimensions".  These contain both
        parent relative and absolute pixel components, which are used in
        determining the final value used.
        
        \return
        UVector2 describing the size of the window area.
        */
        public function getSize():UVector2
        {
            return d_area.getSize();
        }
        
        
        /*!
        \brief
        Get the window's width.
        
        Gets the width of the area occupied by this window.
        
        \note
        This method makes use of "Unified Dimensions".  These contain both
        parent relative and absolute pixel components, which are used in
        determining the final value used.
        
        \return
        UDim describing the width of the window area.
        */
        public function getWidth():UDim
        {
            return d_area.getSize().d_x;
        }
        
        /*!
        \brief
        Get the window's height.
        
        Gets the height of the area occupied by this window.
        
        \note
        This method makes use of "Unified Dimensions".  These contain both
        parent relative and absolute pixel components, which are used in
        determining the final value used.
        
        \return
        UDim describing the height of the window area.
        */
        public function getHeight():UDim
        {
            return d_area.getSize().d_y;
        }
        
        
        
        /*!
        \brief
        Get the window's maximum size.
        
        Gets the maximum size that this windows area may occupy (whether size
        changes occur by user interaction, general system operation, or by
        direct setting by client code).
        
        \note
        This method makes use of "Unified Dimensions".  These contain both
        parent relative and absolute pixel components, which are used in
        determining the final value used.
        
        \return
        UVector2 describing the maximum size of the window area.
        */
        public function getMaxSize():UVector2
        {
            return d_maxSize;
        }
        
        /*!
        \brief
        Get the window's minimum size.
        
        Gets the minimum size that this windows area may occupy (whether size
        changes occur by user interaction, general system operation, or by
        direct setting by client code).
        
        \note
        This method makes use of "Unified Dimensions".  These contain both
        parent relative and absolute pixel components, which are used in
        determining the final value used.
        
        \return
        UVector2 describing the minimum size of the window area.
        */
        public function getMinSize():UVector2
        {
            return d_minSize;
        }
        
        /*!
        \brief
        Called by logic to prepare texture and all of it's attached children
        
        \return
        Nothing
        */
        //void	renderPrepare(void);
        
        /*!
        \brief
        Causes the Window object to render itself and all of it's attached children
        
        \return
        Nothing
        */
        public function render():void
        {
            // don't do anything if window is not visible
            if (!isVisible())
                return;
            
            // get rendering context
            var ctx:RenderingContext = getRenderingContext();
            
            // clear geometry from surface if it's ours
            if (ctx.owner == this)
                ctx.surface.clearAllGeometry();
            
            // redraw if no surface set, or if surface is invalidated
            if (!d_surface || d_surface.isInvalidated())
            {
                // perform drawing for 'this' Window
               drawSelf(ctx);
                
                // render any child windows
                const child_count:uint = getChildCount();
                for (var i:uint = 0; i < child_count; ++i)
                    d_drawList[i].render();
            }
            
            // do final rendering for surface if it's ours
            if (ctx.owner == this)
                ctx.surface.drawAll();
        }
        
        /*!
        \brief
        Cause window to update itself and any attached children.  Client code does not need to call this method; to
        ensure full, and proper updates, call the injectTimePulse methodname method provided by the System class.
        
        \note
        The update order is such that 'this' window is updated prior to any child windows, this is so
        that child windows that access the parent in their update code get the correct updated state.
        
        \param elapsed
        float value indicating the number of seconds passed since the last update.
        
        \return
        Nothing.
        */
        public function update(elapsed:Number):void
        {
            // perform update for 'this' Window
            updateSelf(elapsed);
            // update underlying RenderingWinodw if needed
            if (d_surface && d_surface.isRenderingWindow())
                (d_surface as FlameRenderingWindow).update(elapsed);
            
            var e:UpdateEventArgs = new UpdateEventArgs(this,elapsed);
            fireEvent(EventWindowUpdated,e,EventNamespace);
            
            // update child windows
            for (var i:uint = 0; i < getChildCount(); ++i)
            {
                // update children based on their WindowUpdateMode setting.
                if (d_children[i].d_updateMode == Consts.WindowUpdateMode_ALWAYS ||
                    (d_children[i].d_updateMode == Consts.WindowUpdateMode_VISIBLE &&
                        d_children[i].isVisible(true)))
                {
                    d_children[i].update(elapsed);
                }
            }
        }
        
        /*!
        \brief
        Sets the internal 'initialising' flag to true.
        This can be use to optimize initialisation of some widgets, and is called
        automatically by the layout XML handler when it has created a window.
        That is just after the window has been created, but before any children or
        properties are read.
        */
        public function beginInitialisation():void
        {
            d_initialising = true;
        }
        
        /*!
        \brief
        Sets the internal 'initialising' flag to false.
        This is called automatically by the layout XML handler when it is done
        creating a window. That is after all properties and children have been
        loaded and just before the next sibling gets created.
        */
        public function endInitialisation():void
        {
            d_initialising = false;
        }
        
        
        /*!
        \brief
        Sets whether this window should ignore mouse events and pass them
        through to any windows behind it. In effect making the window
        transparent to the mouse.
        
        \param setting
        true if mouse pass through is enabled.
        false if mouse pass through is not enabled.
        */
        public function setMousePassThroughEnabled(setting:Boolean):void
        {
            d_mousePassThroughEnabled = setting;
        }
        
        
        /*!
        \brief
        Assign the WindowRenderer to specify the Look'N'Feel specification
        to be used.
        
        \param name
        The factory name of the WindowRenderer to use.
        
        \note
        Once a window renderer has been assigned it is locked - as in cannot be changed.
        */
        public function setWindowRenderer(name:String):void
        {
            var wrm:FlameWindowRendererManager = FlameWindowRendererManager.getSingleton();
            if (d_windowRenderer != null)
            {
                // Allow reset of renderer
                if (d_windowRenderer.getName() == name)
                    return;
                
                var e:WindowEventArgs = new WindowEventArgs(this);
                onWindowRendererDetached(e);
                wrm.destroyWindowRenderer(d_windowRenderer);
            }
            
            if (name.length != 0)
            {
                //                Logger::getSingleton().logEvent("Assigning the window renderer '" +
                //                    name + "' to the window '" + d_name + "'", Informative);
                d_windowRenderer = wrm.createWindowRenderer(name);
                var e2:WindowEventArgs = new WindowEventArgs(this);
                onWindowRendererAttached(e2);
            }
            else
                throw new Error(
                    "Window::setWindowRenderer: Attempt to " +
                    "assign a 'null' window renderer to window '" + d_name + "'.");
        }
        
        /*!
        \brief
        Get the currently assigned WindowRenderer. (Look'N'Feel specification).
        
        \return
        A pointer to the assigned window renderer object.
        0 if no window renderer is assigned.
        */
        public function  getWindowRenderer():FlameWindowRenderer
        {
            return d_windowRenderer;
        }
        
        /*!
        \brief
        Get the factory name of the currently assigned WindowRenderer.
        (Look'N'Feel specification).
        
        \return
        The factory name of the currently assigned WindowRenderer.
        If no WindowRenderer is assigned an empty string is returned.
        */
        public function getWindowRendererName():String
        {
            if (d_windowRenderer)
                return d_windowRenderer.getName();
            
            return "";
        }
        
        
        
        /*!
        \brief
        Inform the window, and optionally all children, that screen area
        rectangles have changed.
        
        \param recursive
        - true to recursively call notifyScreenAreaChanged on attached child
        Window objects.
        - false to just process \e this Window.
        */
        public function notifyScreenAreaChanged(recursive:Boolean = true):void
        {
            markAllCachedRectsInvalid();
            updateGeometryRenderSettings();
            
            // inform children that their screen area must be updated
            if (recursive)
            {
                var child_count:uint = getChildCount();
                for (var i:uint = 0; i < child_count; ++i)
                    d_children[i].notifyScreenAreaChanged();
            }
        }

        /*!
        \brief
        Changes the widget's falagard type, thus changing its look'n'feel and optionally its
        renderer in the process.
        
        \param type
        New look'n'feel of the widget
        
        \param type
        New renderer of the widget
        */
        public function setFalagardType(type:String, rendererType:String = ""):void
        {
            // Retrieve the new widget look
            const separator:String = "/";
            var pos:int = type.indexOf(separator);
            const newLook:String = type.substr(0, pos);
            
            // Check if old one is the same. If so, ignore since we don't need to do
            // anything (type is already assigned)
            pos = d_falagardType.indexOf(separator);
            var oldLook:String = d_falagardType.substr(0, pos);
            if(oldLook == newLook)
                return;
            
            // Obtain widget kind
            var widget:String = d_falagardType.substr(pos + 1);
            
            // Build new type (look/widget)
            d_falagardType = newLook + separator + widget;
            
            // Set new renderer
            if(rendererType.length > 0)
                setWindowRenderer(rendererType);
            
            // Apply the new look to the widget
            setLookNFeel(type);
        }
        
        
        /*!
        \brief
        Specifies whether this Window object will receive events generated by
        the drag and drop support in the system.
        
        \param setting
        - true to enable the Window as a drag and drop target.
        - false to disable the Window as a drag and drop target.
        */
        public function setDragDropTarget(setting:Boolean):void
        {
            d_dragDropTarget = setting;
        }
        
        
        /*!
        \brief
        Set the RenderingSurface to be associated with this Window, or 0 if
        none is required.
        \par
        If this function is called, and the option for automatic use of an
        imagery caching RenderingSurface is enabled, any automatically created
        RenderingSurface will be released, and the affore mentioned option will
        be disabled.
        \par
        If after having set a custom RenderingSurface you then subsequently
        enable the automatic use of an imagery caching RenderingSurface by
        calling setUsingAutoRenderingSurface, the previously set
        RenderingSurface will be disassociated from the Window.  Note that the
        previous RenderingSurface is not destroyed or cleaned up at all - this
        is the job of whoever created that object initially.
        
        \param target
        Pointer to the RenderingSurface object to be associated with the window.
        */
        public function setRenderingSurface(surface:FlameRenderingSurface):void
        {
            if (d_surface == surface)
                return;
            
            if (d_autoRenderingWindow)
                setUsingAutoRenderingSurface(false);
            
            d_surface = surface;
            
            // transfer child surfaces to this new surface
            if (d_surface)
            {
                transferChildSurfaces();
                notifyScreenAreaChanged();
            }
        }
        
        
        /*!
        \brief
        Invalidate the chain of rendering surfaces from this window backwards to
        ensure they get properly redrawn - but doing the minimum amount of work
        possibe - next render.
        */
        private function invalidateRenderingSurface():void
        {
            // invalidate our surface chain if we have one
            if (d_surface)
                d_surface.invalidate();
                // else look through the hierarchy for a surface chain to invalidate.
            else if (d_parent)
                d_parent.invalidateRenderingSurface();
        }
        
        
        /*!
        \brief
        Sets whether \e automatic use of an imagery caching RenderingSurface
        (i.e. a RenderingWindow) is enabled for this window.  The reason we
        emphasise 'atutomatic' is because the client may manually set a
        RenderingSurface that does exactlythe same job.
        \par
        Note that this setting really only controls whether the Window
        automatically creates and manages the RenderingSurface, as opposed to
        the \e use of the RenderingSurface.  If a RenderingSurfaceis set for the
        Window it will be used regardless of this setting.
        \par
        Enabling this option will cause the Window to attempt to create a
        suitable RenderingSurface (which will actually be a RenderingWindow).
        If there is an existing RenderingSurface assocated with this Window, it
        will be removed as the Window's RenderingSurface
        <em>but not destroyed</em>; whoever created the RenderingSurface in the
        first place should take care of its destruction.
        \par
        Disabling this option will cause any automatically created
        RenderingSurface to be released.
        \par
        It is possible that the renderer in use may not support facilities for
        RenderingSurfaces that are suitable for full imagery caching.  If this
        is the case, then calling getRenderingSurface after enabling this option
        will return 0.  In these cases this option will still show as being
        'enabled', this is because Window \e settings should not be influenced
        by capabilities the renderer in use; for example, this enables correct
        XML layouts to be written from a Window on a system that does not
        support such RenderingSurfaces, so that the layout will function as
        preferred on systems that do.
        \par
        If this option is enabled, and the client subsequently assigns a
        different RenderingSurface to the Window, the existing automatically
        created RenderingSurface will be released and this setting will be
        disabled.
        
        \param setting
        - true to enable automatic use of an imagery caching RenderingSurface.
        - false to disable automatic use of an imagery caching RenderingSurface.
        */
        public function setUsingAutoRenderingSurface(setting:Boolean):void
        {
            if (setting)
                allocateRenderingWindow();
            else
                releaseRenderingWindow();
            
            // while the actal area on screen may not have changed, the arrangement of
            // surfaces and geometry did...
            notifyScreenAreaChanged();
            
        }
        
        
        //! set the rotations for this window.
        public function setRotation(rotation:Vector3):void
        {
            if (rotation == d_rotation)
                return;
            
            d_rotation = rotation;
            
            var args:WindowEventArgs = new WindowEventArgs(this);
            onRotated(args);
        }
        
        
        /*!
        \brief
        Set whether the Window is a non-client window.
        
        A non-client window is clipped, positioned and sized according to the
        parent window's full area as opposed to just the inner rect area used
        for normal client windows.
        
        \param setting
        - true if the window should be clipped, positioned and sized according
        to the full area rectangle of it's parent.
        - false if the window should be clipped, positioned and sized according
        to the inner rect area of it's parent.
        */
        public function setNonClientWindow(setting:Boolean):void
        {
            if (setting == d_nonClientContent)
                return;
            
            d_nonClientContent = setting;
            
            var args:WindowEventArgs = new WindowEventArgs(this);
            onNonClientChanged(args);
        }
        
        
        
        //----------------------------------------------------------------------------//
        public function getRenderedString():FlameRenderedString
        {
            if (true)
            {
                d_renderedString = getRenderedStringParser().parse(
                    getTextVisual(), getFont(), null);
                d_renderedStringValid = true;
            }
//            if (!d_renderedStringValid)
//            {
//                d_renderedString = getRenderedStringParser().parse(
//                    getTextVisual(), getFont(), null);
//                d_renderedStringValid = true;
//            }
            
            return d_renderedString;
        }
        
        //! Return a pointer to any custom RenderedStringParser set, or 0 if none.
        public function getCustomRenderedStringParser():FlameRenderedStringParser
        {
            return d_customStringParser;
        }
        
        //! Set a custom RenderedStringParser, or 0 to remove an existing one.
        public function setCustomRenderedStringParser(parser:FlameRenderedStringParser):void
        {
            d_customStringParser = parser;
            d_renderedStringValid = false;
        }
        
        //! return the active RenderedStringParser to be used
        public function getRenderedStringParser():FlameRenderedStringParser
        {
            // if parsing is disabled, we use a DefaultRenderedStringParser that creates
            // a RenderedString to renderi the input text verbatim (i.e. no parsing).
            if (!d_textParsingEnabled)
                return d_defaultStringParser;
            
            // Next prefer a custom RenderedStringParser assigned to this Window.
            if (d_customStringParser)
                return d_customStringParser;
            
            // Next prefer any globally set RenderedStringParser.
            const global_parser:FlameRenderedStringParser =
                FlameSystem.getSingleton().getDefaultCustomRenderedStringParser();
            if (global_parser)
                return global_parser;
            
            // if parsing is enabled and no custom RenderedStringParser is set anywhere,
            // use the system's BasicRenderedStringParser to do the parsing.
            return d_basicStringParser;
        }
        
        //! return whether text parsing is enabled for this window.
        public function isTextParsingEnabled() :Boolean
        {
            return d_textParsingEnabled;
        }
        
        //! set whether text parsing is enabled for this window.
        public function setTextParsingEnabled(setting:Boolean):void
        {
            d_textParsingEnabled = setting;
            d_renderedStringValid = false;
            
            var args:WindowEventArgs = new WindowEventArgs(this);
            onTextParsingChanged(args);
        }
        
        
        //! set margin
        public function setMargin(margin:UBox):void
        {
            d_margin = margin;
            
            var args:WindowEventArgs = new WindowEventArgs(this);
            onMarginChanged(args);
        }
        
        
        //! retrieves currently set margin
        public function getMargin():UBox
        {
            return d_margin;
        }
        
        
        //----------------------------------------------------------------------------//
        public function getUnprojectedPosition(pos:Vector2):Vector2
        {
            var rs:FlameRenderingSurface = getTargetRenderingSurface();
            
            // if window is not backed by RenderingWindow, return same pos.
            if (!rs.isRenderingWindow())
                return pos;
            
            // get first target RenderingWindow
            var rw:FlameRenderingWindow = rs as FlameRenderingWindow;
            
            // setup for loop
            var out_pos:Vector2 = pos.clone();
            
            // while there are rendering windows
            while (rw)
            {
                // unproject the point for the current rw
                const in_pos:Vector2 = out_pos.clone();
                rw.unprojectPoint(in_pos, out_pos);
                
                // get next rendering window, if any
                rw = (rs = rw.getOwner()).isRenderingWindow() ? (rs as FlameRenderingWindow) : null;
            }
            
            return out_pos;
        }
        
        /*!
        \brief
        Set the window update mode.  This mode controls the behaviour of the
        Window::update member function such that updates are processed for
        this window (and therefore it's child content) according to the set
        mode.
        
        \note
        Disabling updates can have negative effects on the behaviour of CEGUI
        windows and widgets; updates should be disabled selectively and
        cautiously - if you are unsure of what you are doing, leave the mode
        set to WUM_ALWAYS.
        
        \param mode
        One of the WindowUpdateMode enumerated values indicating the mode to
        set for this Window.
        */
        public function setUpdateMode(mode:uint):void
        {
            d_updateMode = mode;
        }
        
        /*!
        \brief
        Return the current window update mode that is set for this Window.
        This mode controls the behaviour of the Window::update member function
        such that updates are processed for this window (and therefore it's
        child content) according to the set mode.
        
        \note
        Disabling updates can have negative effects on the behaviour of CEGUI
        windows and widgets; updates should be disabled selectively and
        cautiously - if you are unsure of what you are doing, leave the mode
        set to WUM_ALWAYS.
        
        \return
        One of the WindowUpdateMode enumerated values indicating the current
        mode set for this Window.
        */
        public function getUpdateMode():uint
        {
            return d_updateMode;
        }
        
        
        
        /*!
        \brief
        Set whether mouse input that is not directly handled by this Window
        (including it's event subscribers) should be propagated back to the
        Window's parent.
        
        \param enabled
        - true if unhandled mouse input should be propagated to the parent.
        - false if unhandled mouse input should not be propagated.
        */
        public function setMouseInputPropagationEnabled(enabled:Boolean):void
        {
            d_propagateMouseInputs = enabled;
        }
        
        /*!
        \brief
        Return whether mouse input that is not directly handled by this Window
        (including it's event subscribers) should be propagated back to the
        Window's parent.
        
        \return
        - true if unhandled mouse input will be propagated to the parent.
        - false if unhandled mouse input will not be propagated.
        */
        public function isMouseInputPropagationEnabled():Boolean
        {
            return d_propagateMouseInputs;
        }

        
        /*!
        \brief
        Clones this Window and returns the result
        
        \param 
        newName new name of the cloned window
        
        \param
        deepCopy if true, even children are copied (the old name prefix will
        be replaced with new name prefix)
        
        \return
        the cloned Window
        */
        public function clone(newName:String, deepCopy:Boolean = true):FlameWindow
        {
            var ret:FlameWindow =
                FlameWindowManager.getSingleton().createWindow(getType(), newName);
            
            // always copy properties
            clonePropertiesTo(ret);
            
            // if user requested deep copy, we should copy children as well
            if (deepCopy)
                cloneChildWidgetsTo(ret);
            
            return ret;
        }

        //! copies this widget's properties to given target widget
        protected function clonePropertiesTo(target:FlameWindow):void
        {
//            PropertySet::Iterator propertyIt = getPropertyIterator();
//            
//            for (PropertySet::Iterator propertyIt = getPropertyIterator();
//                !propertyIt.isAtEnd();
//                ++propertyIt) 
            for(var propertyName:String in d_properties)
            {
                const propertyValue:String = getProperty(propertyName);
                
                // we never copy stuff that doesn't get written into XML
//                if (isPropertyBannedFromXML(propertyName))
//                    continue;
                
                // some cases when propertyValue is "" could lead to exception throws
                if (propertyValue.length == 0)
                {
                    // special case, this causes exception throw when no window renderer
                    // is assigned to the window
                    if (propertyName == "LookNFeel")
                        continue;
                    
                    // special case, this causes exception throw because we are setting
                    // 'null' window renderer
                    if (propertyName == "WindowRenderer")
                        continue;
                }
                
                target.setProperty(propertyName, getProperty(propertyName));
            }
        }
        
        //! copies this widget's child widgets to given target widget
        protected function cloneChildWidgetsTo(target:FlameWindow):void
        {
            const oldName:String = getName();
            const newName:String = target.getName();
            
            // todo: ChildWindowIterator?
            for (var childI:uint = 0; childI < getChildCount(); ++childI)
            {
                var child:FlameWindow = getChildAt(childI);
                if (child.isAutoWindow())
                {
                    // we skip auto windows, they are already created
                    // automatically
                    
                    // note: some windows store non auto windows inside auto windows,
                    //       standard solution is to copy these non-auto windows to
                    //       the parent window
                    //
                    //       If you need alternative behaviour, you have to override
                    //       this method!
                    
                    // so just copy it's child widgets
                    child.cloneChildWidgetsTo(target);
                    // and skip the auto widget
                    continue;
                }
                
                var newChildName:String = child.getName();
                var idxBegin:int = newChildName.indexOf(oldName + "/");
                if (idxBegin == -1)
                {
                    // not found, user is using non-standard naming
                    // use a pretty safe but long and non readable new name
                    newChildName = newChildName + "_clone_" + newName;
                }
                else
                {
                    // +1 because of the "/"
                    var idxEnd:int = idxBegin + oldName.length + 1;
                    
                    // we replace the first occurence of the old parent's name with the new name
                    // this works great in case user uses the default recommended naming scheme
                    // like this: "Parent/ChildWindow/ChildChildWindow"
                    //newChildName.replace(idxBegin, idxEnd, newName + "/");
                    var tmp:String = newChildName.slice(0, idxBegin) + newName + "/" 
                        + newChildName.slice(idxEnd);
                    newChildName = tmp;
                }
                
                var newChild:FlameWindow = child.clone(newChildName, true);
                target.addChildWindow(newChild);
            }
        }

        
        /*!
        \brief
        Return the (visual) z index of the window on it's parent.
        
        The z index is a number that indicates the order that windows will be
        drawn (but is not a 'z co-ordinate', as such).  Higher numbers are in
        front of lower numbers.
        
        The number returned will not be stable, and generally should be used to
        compare with the z index of sibling windows (and only sibling windows)
        to discover the current z ordering of those windows.
        */
        public function getZIndex():uint
        {
            if (!d_parent)
                return 0;
            
//            ChildList::iterator i = std::find(
//                d_parent->d_drawList.begin(),
//                d_parent->d_drawList.end(),
//                this);
            var pos:int = d_drawList.indexOf(this);
            
            if (pos == -1)
                throw new Error("Window::getZIndex: Window is not " +
                    "in its parent's draw list.");
            
            return pos;
        }
        
        
        /*!
        \brief
        Return whether /a this Window is in front of the given window.
        
        \note
        Here 'in front' just means that one window is drawn after the other, it
        is not meant to imply that the windows are overlapping nor that one
        window is obscured by the other.
        */
        public function isInFront(wnd:FlameWindow):Boolean
        {
            // children are always in front of their ancestors
            if (isAncestorForWindow(wnd))
                return true;
            
            // conversely, ancestors are always behind their children
            if (wnd.isAncestorForWindow(this))
                return false;
            
            const w1:FlameWindow = getWindowAttachedToCommonAncestor(wnd);
            
            // seems not to be in same window hierarchy
            if (!w1)
                return false;
            
            const w2:FlameWindow = wnd.getWindowAttachedToCommonAncestor(this);
            
            // at this point, w1 and w2 share the same parent.
            return w2.getZIndex() > w1.getZIndex();
        }
        
        /*!
        \brief
        Return whether /a this Window is behind the given window.
        
        \note
        Here 'behind' just means that one window is drawn before the other, it
        is not meant to imply that the windows are overlapping nor that one
        window is obscured by the other.
        */
        public function isBehind(wnd:FlameWindow):Boolean
        {
            return !isInFront(wnd);
        }


        
        /*************************************************************************
         Event trigger methods
         *************************************************************************/
        /*!
        \brief
        Handler called when the window's size changes.
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the window
        that triggered the event.  For this event the trigger window is always
        'this'.
        */
        protected function onSized(e:WindowEventArgs):void
        {
            // resize the underlying RenderingWindow if we're using such a thing
            if (d_surface && d_surface.isRenderingWindow())
                (d_surface as FlameRenderingWindow).setSize(getPixelSize());
            
            // screen area changes when we're resized.
            // NB: Called non-recursive since the onParentSized notifications will deal
            // more selectively with child Window cases.
            notifyScreenAreaChanged(false);
            
            // we need to layout loonfeel based content first, in case anything is
            // relying on that content for size or positioning info (i.e. some child
            // is used to establish inner-rect position or size).
            //
            // TODO: The subsequent onParentSized notification for those windows cause
            // additional - unneccessary - work; we should look to optimise that.
            performChildWindowLayout();
            
            // inform children their parent has been re-sized
            var child_count:uint = getChildCount();
            for (var i:uint = 0; i < child_count; ++i)
            {
                var args:WindowEventArgs = new WindowEventArgs(this);
                d_children[i].onParentSized(args);
            }
            
            invalidate();
            
            fireEvent(EventSized, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the window's position changes.
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the window
        that triggered the event.  For this event the trigger window is always
        'this'.
        */
        protected function onMoved(e:WindowEventArgs):void
        {
            notifyScreenAreaChanged();
            
            // handle invalidation of surfaces and trigger needed redraws
            if (d_parent)
            {
                d_parent.invalidateRenderingSurface();
                // need to redraw some geometry if parent uses a caching surface
                if (d_parent.getTargetRenderingSurface().isRenderingWindow())
                    FlameSystem.getSingleton().signalRedraw();
            }
            
           fireEvent(EventMoved, e, EventNamespace);
          
        }
        
        /*!
        \brief
        Handler called when the window's text is changed.
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the window
        that triggered the event.  For this event the trigger window is always
        'this'.
        */
        protected function onTextChanged(e:WindowEventArgs):void
        {
            invalidate();
            
            fireEvent(EventTextChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the window's font is changed.
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the window
        that triggered the event.  For this event the trigger window is always
        'this'.
        */
        protected function onFontChanged(e:WindowEventArgs):void
        {
            // This was added to enable the Falagard FontDim to work
            // properly.  A better, more selective, solution would
            // probably be to do something funky with events ;)
            performChildWindowLayout();
            
            invalidate();
            
            fireEvent(EventFontChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the window's alpha blend value is changed.
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the window
        that triggered the event.  For this event the trigger window is always
        'this'.
        */
        protected function onAlphaChanged(e:WindowEventArgs):void
        {
            // scan child list and call this method for all children that inherit alpha
            var child_count:uint = getChildCount();
            
            for (var i:uint = 0; i < child_count; ++i)
            {
                if (d_children[i].inheritsAlpha())
                {
                    var args:WindowEventArgs = new WindowEventArgs(d_children[i]);
                    d_children[i].onAlphaChanged(args);
                }
                
            }
            
            invalidate();
            
            fireEvent(EventAlphaChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the window's client assigned ID is changed.
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the window
        that triggered the event.  For this event the trigger window is always
        'this'.
        */
        protected function onIDChanged(e:WindowEventArgs):void
        {
            fireEvent(EventIDChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the window is shown (made visible).
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the window
        that triggered the event.  For this event the trigger window is always
        'this'.
        */
        protected function onShown(e:WindowEventArgs):void
        {
            invalidate();
            
            fireEvent(EventShown, e, EventNamespace);
            
            if (d_showSound.length != 0)
            {
                FlameSoundManager.getSingleton().playSound(d_showSound);
            }
        }
        
        /*!
        \brief
        Handler called when the window is hidden.
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the window
        that triggered the event.  For this event the trigger window is always
        'this'.
        */
        protected function onHidden(e:WindowEventArgs):void
        {
            // first deactivate window if it is the active window.
            if (isActive())
                deactivate();
            
            invalidate();
            fireEvent(EventHidden, e, EventNamespace);
            
            
            if (d_hideSound.length != 0)
            {
                FlameSoundManager.getSingleton().playSound(d_hideSound);
            }
        }
        
        /*!
        \brief
        Handler called when the window is enabled.
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the window
        that triggered the event.  For this event the trigger window is always
        'this'.
        */
        protected function onEnabled(e:WindowEventArgs):void
        {
            // signal all non-disabled children that they are now enabled
            // (via inherited state)
            var child_count:uint = getChildCount();
            for (var i:uint = 0; i < child_count; ++i)
            {
                if (d_children[i].d_enabled)
                {
                    var args:WindowEventArgs = new WindowEventArgs(d_children[i]);
                    d_children[i].onEnabled(args);
                }
            }
            
            invalidate();
            fireEvent(EventEnabled, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the window is disabled.
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the window
        that triggered the event.  For this event the trigger window is always
        'this'.
        */
        protected function onDisabled(e:WindowEventArgs):void
        {
            // signal all non-disabled children that they are now disabled
            // (via inherited state)
            var child_count:uint = getChildCount();
            for (var i:uint = 0; i < child_count; ++i)
            {
                if (d_children[i].d_enabled)
                {
                    var args:WindowEventArgs = new WindowEventArgs(d_children[i]);
                    d_children[i].onDisabled(args);
                }
            }
            
            invalidate();
            fireEvent(EventDisabled, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the window's setting for being clipped by it's
        parent is changed.
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the window
        that triggered the event.  For this event the trigger window is always
        'this'.
        */
        protected function onClippingChanged(e:WindowEventArgs):void
        {
            invalidate();
            notifyClippingChanged();
            fireEvent(EventClippedByParentChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the window's setting for being destroyed
        automatically be it's parent is changed.
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the window
        that triggered the event.  For this event the trigger window is always
        'this'.
        */
        protected function onParentDestroyChanged(e:WindowEventArgs):void
        {
            fireEvent(EventDestroyedByParentChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the window's setting for inheriting alpha-blending
        is changed.
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the window
        that triggered the event.  For this event the trigger window is always
        'this'.
        */
        protected function onInheritsAlphaChanged(e:WindowEventArgs):void
        {
            invalidate();
            fireEvent(EventInheritsAlphaChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the window's always-on-top setting is changed.
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the window
        that triggered the event.  For this event the trigger window is always
        'this'.
        */
        protected function onAlwaysOnTopChanged(e:WindowEventArgs):void
        {
            // we no longer want a total redraw here, instead we just get each window
            // to resubmit it's imagery to the Renderer.
            FlameSystem.getSingleton().signalRedraw();
            fireEvent(EventAlwaysOnTopChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when this window gains capture of mouse inputs.
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the window
        that triggered the event.  For this event the trigger window is always
        'this'.
        */
        protected function onCaptureGained(e:WindowEventArgs):void
       {
           fireEvent(EventInputCaptureGained, e, EventNamespace);
       }
        
        /*!
        \brief
        Handler called when this window loses capture of mouse inputs.
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the window
        that triggered the event.  For this event the trigger window is always
        'this'.
        */
       protected function onCaptureLost(e:WindowEventArgs):void
        {
            // reset auto-repeat state
            d_repeatButton = Consts.MouseButton_NoButton;
            
            // handle restore of previous capture window as required.
            if (d_restoreOldCapture && (d_oldCapture != null)) {
                d_oldCapture.onCaptureLost(e);
                d_oldCapture = null;
            }
            
            // handle case where mouse is now in a different window
            // (this is a bit of a hack that uses the mouse input injector to handle
            // this for us).
            FlameSystem.getSingleton().injectMouseMove(0, 0);
            
            fireEvent(EventInputCaptureLost, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when rendering for this window has started.
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the window
        that triggered the event.  For this event the trigger window is always
        'this'.
        */
        protected function onRenderingStarted(e:WindowEventArgs):void
        {
            fireEvent(EventRenderingStarted, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when rendering for this window has ended.
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the window
        that triggered the event.  For this event the trigger window is always
        'this'.
        */
        protected function onRenderingEnded(e:WindowEventArgs):void
        {
            fireEvent(EventRenderingEnded, e, EventNamespace);
        }
        /*!
        \brief
        Handler called when the z-order position of this window has changed.
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the window
        that triggered the event.  For this event the trigger window is always
        'this'.
        */
        protected function onZChanged(e:WindowEventArgs):void
        {
            // we no longer want a total redraw here, instead we just get each window
            // to resubmit it's imagery to the Renderer.
            FlameSystem.getSingleton().signalRedraw();
            fireEvent(EventZOrderChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when this window's destruction sequence has begun.
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the window
        that triggered the event.  For this event the trigger window is always
        'this'.
        */
        protected function onDestructionStarted(e:WindowEventArgs):void
        {
            d_destructionStarted = true;
            fireEvent(EventDestructionStarted, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when this window has become the active window.
        
        \param e
        ActivationEventArgs class whose 'otherWindow' field is set to the window
        that previously was active, or NULL for none.
        */
        protected function onActivated(e:ActivationEventArgs):void
        {
            if(d_active) return;
            
            d_active = true;
            invalidate();
            fireEvent(EventActivated, e, EventNamespace);
        }
        /*!
        \brief
        Handler called when this window has lost input focus and has been
        deactivated.
        
        \param e
        ActivationEventArgs object whose 'otherWindow' field is set to the
        window that has now become active, or NULL for none.
        */
        protected function onDeactivated(e:ActivationEventArgs):void
        {
            // first de-activate all children
            var child_count:uint = getChildCount();
            for (var i:uint = 0; i < child_count; ++i)
            {
                if (d_children[i].isActive())
                {
                    // make sure the child gets itself as the .window member
                    var child_e:ActivationEventArgs = new ActivationEventArgs(d_children[i]);
                    child_e.otherWindow = e.otherWindow;
                    d_children[i].onDeactivated(child_e);
                }
                
            }
            
            d_active = false;
            invalidate();
            fireEvent(EventDeactivated, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when this window's parent window has been resized.  If
        this window is the root / GUI Sheet window, this call will be made when
        the display size changes.
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set the the
        window that caused the event; this is typically either this window's
        parent window, or NULL to indicate the screen size has changed.
        */
        public function onParentSized(e:WindowEventArgs):void
        {
            markAllCachedRectsInvalid();
            
            var oldSize:Size = d_pixelSize.clone();
            calculatePixelSize();
            var sized:Boolean = (d_pixelSize != oldSize) || isInnerRectSizeChanged();
            
            var moved:Boolean =
                ((d_area.d_min.d_x.d_scale != 0) || (d_area.d_min.d_y.d_scale != 0) ||
                    (d_horzAlign != Consts.HorizontalAlignment_HA_LEFT) || 
                    (d_vertAlign != Consts.VerticalAlignment_VA_TOP));
            
            fireAreaChangeEvents(moved, sized);
            
            // if we were not moved or sized, do child layout anyway!
            if (!(moved || sized))
                performChildWindowLayout();
            
            fireEvent(EventParentSized, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when a child window is added to this window.
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the window
        that has been added.
        */
        protected function onChildAdded(e:WindowEventArgs):void
        {
            // we no longer want a total redraw here, instead we just get each window
            // to resubmit it's imagery to the Renderer.
            FlameSystem.getSingleton().signalRedraw();
            fireEvent(EventChildAdded, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when a child window is removed from this window.
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set the window
        that has been removed.
        */
        protected function onChildRemoved(e:WindowEventArgs):void
        {
            // we no longer want a total redraw here, instead we just get each window
            // to resubmit it's imagery to the Renderer.
            FlameSystem.getSingleton().signalRedraw();

            // Though we do need to invalidate the rendering surface!
            getTargetRenderingSurface().invalidate();
            fireEvent(EventChildRemoved, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the mouse cursor has entered this window's area.
        
        \param e
        MouseEventArgs object.  All fields are valid.
        */
        public function onMouseEntersArea(e:MouseEventArgs):void
        {
            fireEvent(EventMouseEntersArea, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the mouse cursor has left this window's area.
        
        \param e
        MouseEventArgs object.  All fields are valid.
        */
        public function onMouseLeavesArea(e:MouseEventArgs):void
        {
            fireEvent(EventMouseLeavesArea, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the mouse cursor has entered this window's area and
        is actually over some part of this windows surface and not, for
        instance over a child window - even though technically in those cases
        the mouse is also within this Window's area, the handler will not be
        called.
        
        \param e
        MouseEventArgs object.  All fields are valid.
        
        \see
        Window::onMouseEntersArea
        */
        public function onMouseEnters(e:MouseEventArgs):void
        {
            // set the mouse cursor
            FlameMouseCursor.getSingleton().setImage(getMouseCursor());
            
            // perform tooltip control
            var tip:FlameTooltip = getTooltip();
            if (tip && ! isAncestorForWindow(tip))
                tip.setTargetWindow(this);
            
            fireEvent(EventMouseEnters, e, EventNamespace);
            
            if(d_hoverSound.length != 0)
            {
                FlameSoundManager.getSingleton().playSound(d_hoverSound);
            }
        }
        
        /*!
        \brief
        Handler called when the mouse cursor is no longer over this window's
        surface area.  This will be called when the mouse is not over a part
        of this Window's actual surface - even though technically the mouse is
        still within the Window's area, for example if the mouse moves over a
        child window.
        
        \param e
        MouseEventArgs object.  All fields are valid.
        
        \see
        Window::onMouseLeavesArea
        */
        public function onMouseLeaves(e:MouseEventArgs):void
        {
            // perform tooltip control
            const mw:FlameWindow = FlameSystem.getSingleton().getWindowContainingMouse();
            const tip:FlameTooltip = getTooltip();
            if (tip && mw != tip && !(mw && mw.isAncestorForWindow(tip)))
                tip.setTargetWindow(null);
            
            fireEvent(EventMouseLeaves, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the mouse cursor has been moved within this window's
        area.
        
        \param e
        MouseEventArgs object.  All fields are valid.
        */
        public function onMouseMove(e:MouseEventArgs):void
        {
            // perform tooltip control
            const tip:FlameTooltip = getTooltip();
            if (tip)
                tip.resetTimer();
            
//            fireEvent(EventMouseMove, e, EventNamespace);
//            
//            // optionally propagate to parent
//            if (!e.handled && d_propagateMouseInputs &&
//                d_parent && this != FlameSystem.getSingleton().getModalTarget())
//            {
//                e.window = d_parent;
//                d_parent.onMouseMove(e);
//                
//                return;
//            }
            
            // by default we now mark mouse events as handled
            // (derived classes may override, of course!)
            ++e.handled;
        }
        
        /*!
        \brief
        Handler called when the mouse wheel (z-axis) position changes within
        this window's area.
        
        \param e
        MouseEventArgs object.  All fields are valid.
        */
        public function onMouseWheel(e:MouseEventArgs):void
        {
            fireEvent(EventMouseWheel, e, EventNamespace);
            
            // optionally propagate to parent
            if (!e.handled && d_propagateMouseInputs &&
                d_parent && this != FlameSystem.getSingleton().getModalTarget())
            {
                e.window = d_parent;
                d_parent.onMouseWheel(e);
                
                return;
            }
            
            // by default we now mark mouse events as handled
            // (derived classes may override, of course!)
            ++e.handled;
        }
        
        /*!
        \brief
        Handler called when a mouse button has been depressed within this
        window's area.
        
        \param e
        MouseEventArgs object.  All fields are valid.
        */
        public function onMouseButtonDown(e:MouseEventArgs):void
        {
            // perform tooltip control
            const tip:FlameTooltip = getTooltip();
            if (tip)
                tip.setTargetWindow(null);
            
            if ((e.button == Consts.MouseButton_LeftButton) && moveToFront_impl(true))
                ++e.handled;
            
            // if auto repeat is enabled and we are not currently tracking
            // the button that was just pushed (need this button check because
            // it could be us that generated this event via auto-repeat).
            if (d_autoRepeat)
            {
                if (d_repeatButton == Consts.MouseButton_NoButton)
                    captureInput();
                
                if ((d_repeatButton != e.button) && isCapturedByThis())
                {
                    d_repeatButton = e.button;
                    d_repeatElapsed = 0;
                    d_repeating = false;
                }
            }
            
            fireEvent(EventMouseButtonDown, e, EventNamespace);
            
            // optionally propagate to parent
            if (!e.handled && d_propagateMouseInputs &&
                d_parent && this != FlameSystem.getSingleton().getModalTarget())
            {
                e.window = d_parent;
                d_parent.onMouseButtonDown(e);
                
                return;
            }
            
            // by default we now mark mouse events as handled
            // (derived classes may override, of course!)
            ++e.handled;
        }
        
        /*!
        \brief
        Handler called when a mouse button has been released within this
        window's area.
        
        \param e
        MouseEventArgs object.  All fields are valid.
        */
        public function onMouseButtonUp(e:MouseEventArgs):void
        {
            // reset auto-repeat state
            if (d_autoRepeat && d_repeatButton != Consts.MouseButton_NoButton)
            {
                releaseInput();
                d_repeatButton = Consts.MouseButton_NoButton;
            }
            
            fireEvent(EventMouseButtonUp, e, EventNamespace);
            
            // optionally propagate to parent
            if (!e.handled && d_propagateMouseInputs &&
                d_parent && this != FlameSystem.getSingleton().getModalTarget())
            {
                e.window = d_parent;
                d_parent.onMouseButtonUp(e);
                
                return;
            }
            
            // by default we now mark mouse events as handled
            // (derived classes may override, of course!)
            ++e.handled;
        }
        
        /*!
        \brief
        Handler called when a mouse button has been clicked (that is depressed
        and then released, within a specified time) within this window's area.
        
        \param e
        MouseEventArgs object.  All fields are valid.
        */
        public function onMouseClicked(e:MouseEventArgs):void
        {
            fireEvent(EventMouseClick, e, EventNamespace);
            
            // optionally propagate to parent
            if (!e.handled && d_propagateMouseInputs &&
                d_parent && this != FlameSystem.getSingleton().getModalTarget())
            {
                e.window = d_parent;
                d_parent.onMouseClicked(e);
                
                return;
            }

            if(d_lclickSound.length != 0)
            {
                //if (this->getProperty("Checked").compare("False"))
                {
                    FlameSoundManager.getSingleton().playSound(d_lclickSound);
                }
            }
            // if event was directly injected, mark as handled to be consistent with
            // other mouse button injectors
            if (!FlameSystem.getSingleton().isMouseClickEventGenerationEnabled())
                ++e.handled;
        }
        
        /*!
        \brief
        Handler called when a mouse button has been double-clicked within this
        window's area.
        
        \param e
        MouseEventArgs object.  All fields are valid.
        */
        public function onMouseDoubleClicked(e:MouseEventArgs):void
        {
            fireEvent(EventMouseDoubleClick, e, EventNamespace);
            
            // optionally propagate to parent
            if (!e.handled && d_propagateMouseInputs &&
                d_parent && this != FlameSystem.getSingleton().getModalTarget())
            {
                e.window = d_parent;
                d_parent.onMouseDoubleClicked(e);
                
                return;
            }
            
            if(d_ldoubleClickSound.length != 0)
            {
                FlameSoundManager.getSingleton().playSound(d_ldoubleClickSound);
            }
            
            ++e.handled;
        }
        
        /*!
        \brief
        Handler called when a mouse button has been triple-clicked within this
        window's area.
        
        \param e
        MouseEventArgs object.  All fields are valid.
        */
        public function onMouseTripleClicked(e:MouseEventArgs):void
        {
            fireEvent(EventMouseTripleClick, e, EventNamespace);
            
            // optionally propagate to parent
            if (!e.handled && d_propagateMouseInputs &&
                d_parent && this != FlameSystem.getSingleton().getModalTarget())
            {
                e.window = d_parent;
                d_parent.onMouseTripleClicked(e);
                
                return;
            }
            
            ++e.handled;
        }
        
        /*!
        \brief
        Handler called when a key as been depressed while this window has input
        focus.
        
        \param e
        KeyEventArgs object whose 'scancode' field is set to the Key::Scan value
        representing the key that was pressed, and whose 'sysKeys' field
        represents the combination of SystemKey that were active when the event
        was generated.
        */
        public function onKeyDown(e:KeyEventArgs):void
        {
            fireEvent(EventKeyDown, e, EventNamespace);
            
            // As of 0.7.0 CEGUI::System no longer does input event propogation, so by
            // default we now do that here.  Generally speaking key handling widgets
            // may need to override this behaviour to halt further propogation.
            if (!e.handled && d_parent &&
                this != FlameSystem.getSingleton().getModalTarget())
            {
                e.window = d_parent;
                d_parent.onKeyDown(e);
            }
        }
        
        /*!
        \brief
        Handler called when a key as been released while this window has input
        focus.
        
        \param e
        KeyEventArgs object whose 'scancode' field is set to the Key::Scan value
        representing the key that was released, and whose 'sysKeys' field
        represents the combination of SystemKey that were active when the event
        was generated.  All other fields should be considered as 'junk'.
        */
        public function onKeyUp(e:KeyEventArgs):void
        {
            fireEvent(EventKeyUp, e, EventNamespace);
            
            // As of 0.7.0 CEGUI::System no longer does input event propogation, so by
            // default we now do that here.  Generally speaking key handling widgets
            // may need to override this behaviour to halt further propogation.
            if (!e.handled && d_parent &&
                this != FlameSystem.getSingleton().getModalTarget())
            {
                e.window = d_parent;
                d_parent.onKeyUp(e);
            }
        }
        
        /*!
        \brief
        Handler called when a character-key has been pressed while this window
        has input focus.
        
        \param e
        KeyEventArgs object whose 'codepoint' field is set to the Unicode code
        point (encoded as utf32) for the character typed, and whose 'sysKeys'
        field represents the combination of SystemKey that were active when the
        event was generated.  All other fields should be considered as 'junk'.
        */
        public function onCharacter(e:KeyEventArgs):void
        {
            fireEvent(EventCharacterKey, e, EventNamespace);
            
            // As of 0.7.0 CEGUI::System no longer does input event propogation, so by
            // default we now do that here.  Generally speaking key handling widgets
            // may need to override this behaviour to halt further propogation.
            if (!e.handled && d_parent &&
                this != FlameSystem.getSingleton().getModalTarget())
            {
                e.window = d_parent;
                d_parent.onCharacter(e);
            }
        }
        
        /*!
        \brief
        Handler called when a DragContainer is dragged over this window.
        
        \param e
        DragDropEventArgs object initialised as follows:
        - window field is normaly set to point to 'this' window.
        - dragDropItem is a pointer to a DragContainer window that triggered
        the event.
        */
        protected function onDragDropItemEnters(e:DragDropEventArgs):void
        {
            fireEvent(EventDragDropItemEnters, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when a DragContainer is dragged over this window.
        
        \param e
        DragDropEventArgs object initialised as follows:
        - window field is normaly set to point to 'this' window.
        - dragDropItem is a pointer to a DragContainer window that triggered
        the event.
        */
        protected function onDragDropItemLeaves(e:DragDropEventArgs):void
        {
            fireEvent(EventDragDropItemLeaves, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when a DragContainer is dragged over this window.
        
        \param e
        DragDropEventArgs object initialised as follows:
        - window field is normaly set to point to 'this' window.
        - dragDropItem is a pointer to a DragContainer window that triggered
        the event.
        */
        protected function onDragDropItemDropped(e:DragDropEventArgs):void
        {
            fireEvent(EventDragDropItemDropped, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the vertical alignment setting for the window is
        changed.
        
        \param e
        WindowEventArgs object initialised as follows:
        - window field is set to point to the Window object whos alignment has
        changed (typically 'this').
        */
        protected function onVerticalAlignmentChanged(e:WindowEventArgs):void
        {
            notifyScreenAreaChanged();
            
            fireEvent(EventVerticalAlignmentChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the horizontal alignment setting for the window is
        changed.
        
        \param e
        WindowEventArgs object initialised as follows:
        - window field is set to point to the Window object whos alignment has
        changed (typically 'this').
        */
        protected function onHorizontalAlignmentChanged(e:WindowEventArgs):void
        {
            notifyScreenAreaChanged();
            
            fireEvent(EventHorizontalAlignmentChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when a new window renderer object is attached.
        
        \param e
        WindowEventArgs object initialised as follows:
        - window field is set to point to the Window object that just got a new
        window renderer attached. (typically 'this').
        */
        protected function onWindowRendererAttached(e:WindowEventArgs):void
        {
            if (!validateWindowRenderer(d_windowRenderer.getClass()))
                throw new Error(
                    "Window::onWindowRendererAttached: The " +
                    "window renderer '" + d_windowRenderer.getName() + "' is not " +
                    "compatible with this widget type (" + getType() + ")");
            
            if (!testClassName(d_windowRenderer.getClass()))
                throw new Error(
                    "Window::onWindowRendererAttached: The " +
                    "window renderer '" + d_windowRenderer.getName() + "' is not " +
                    "compatible with this widget type (" + getType() + "). It requires " +
                    "a '" + d_windowRenderer.getClass() + "' based window type.");
            
            d_windowRenderer.d_window = this;
            d_windowRenderer.onAttach();
            fireEvent(EventWindowRendererAttached, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the currently attached window renderer object is detached.
        
        \param e
        WindowEventArgs object initialised as follows:
        - window field is set to point to the Window object that just got lost its
        window renderer. (typically 'this').
        */
        protected function onWindowRendererDetached(e:WindowEventArgs):void
        {
            d_windowRenderer.onDetach();
            d_windowRenderer.d_window = null;
            fireEvent(EventWindowRendererDetached, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the window's rotation factor is changed.
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the window
        that triggered the event.  For this event the trigger window is always
        'this'.
        */
        protected function onRotated(e:WindowEventArgs):void
        {
            // if we have no surface set, enable the auto surface
            if (!d_surface)
            {
                trace("Window::setRotation - " +
                    "Activating AutoRenderingSurface on Window '" + d_name +
                    "' to enable rotation support.");
                
                setUsingAutoRenderingSurface(true);
                
                // still no surface?  Renderer or HW must not support what we need :(
                if (!d_surface)
                {
                    trace("Window::setRotation - " +
                        "Failed to obtain a suitable ReneringWindow surface for " +
                        "Window '" + d_name + "'.  Rotation will not be available.");
                    
                    return;
                }
            }
            
            // ensure surface we have is the right type
            if (!d_surface.isRenderingWindow())
            {
                trace("Window::setRotation - " +
                    "Window '" + d_name + "' has a manual RenderingSurface that is not " +
                    "a RenderingWindow.  Rotation will not be available.");
                
                return;
            }
            
            // Checks / setup complete!  Now we can finally set the rotation.
            (d_surface as FlameRenderingWindow).setRotation(d_rotation);
            (d_surface as FlameRenderingWindow).setPivot(new Vector3(d_pixelSize.d_width / 2.0, d_pixelSize.d_height / 2.0, 0.0));
            
            fireEvent(EventRotated, e, EventNamespace);
        }
        
        /*!
        \brief
        Handler called when the window's non-client setting, affecting it's
        position and size relative to it's parent is changed.
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the window
        that triggered the event.  For this event the trigger window is always
        'this'.
        */
        protected function onNonClientChanged(e:WindowEventArgs):void
        {
            // TODO: Trigger update of size and position information if needed
            
            fireEvent(EventNonClientChanged, e, EventNamespace);
        }
        

        
        /*!
        \brief
        Handler called when the window's setting for whether text parsing is
        enabled is changed.
        
        \param e
        WindowEventArgs object whose 'window' pointer field is set to the window
        that triggered the event.  For this event the trigger window is always
        'this'.
        */
        protected function onTextParsingChanged(e:WindowEventArgs):void
        {
            fireEvent(EventTextParsingChanged, e, EventNamespace);
        }
        
        protected function onMarginChanged(e:WindowEventArgs):void
        {
            fireEvent(EventMarginChanged, e, EventNamespace);
        }
        

        /*!
        \brief
        Perform actual update processing for this Window.
        
        \param elapsed
        float value indicating the number of seconds elapsed since the last
        update call.
        
        \return
        Nothing.
        */
        protected function updateSelf(elapsed:Number):void
        {
            // Mouse button autorepeat processing.
            if (d_autoRepeat && d_repeatButton != Consts.MouseButton_NoButton)
            {
                d_repeatElapsed += elapsed;
                
                if (d_repeating)
                {
                    if (d_repeatElapsed > d_repeatRate)
                    {
                        d_repeatElapsed -= d_repeatRate;
                        // trigger the repeated event
                        generateAutoRepeatEvent(d_repeatButton);
                    }
                }
                else
                {
                    if (d_repeatElapsed > d_repeatDelay)
                    {
                        d_repeatElapsed = 0;
                        d_repeating = true;
                        // trigger the repeated event
                        generateAutoRepeatEvent(d_repeatButton);
                    }
                }
            }
            
            // allow for updates within an assigned WindowRenderer
            if (d_windowRenderer)
                d_windowRenderer.update(elapsed);
            
        }
        
        //----------------------------------------------------------------------------//
        protected function drawSelf(ctx:RenderingContext):void
        {
            bufferGeometry(ctx);
            queueGeometry(ctx);
        }
        
        //----------------------------------------------------------------------------//
        private function bufferGeometry(ctx:RenderingContext):void
        {
            if (d_needsRedraw)
            {
                // dispose of already cached geometry.
                d_geometry.reset();
                
                // signal rendering started
                var args:WindowEventArgs = new WindowEventArgs(this);
                onRenderingStarted(args);
                
                // HACK: ensure our rendered string content is up to date
                getRenderedString();
                
                // get derived class or WindowRenderer to re-populate geometry buffer.
                if (d_windowRenderer)
                    d_windowRenderer.render();
                else
                    populateGeometryBuffer();
                
                // signal rendering ended
                args.handled = 0;
                onRenderingEnded(args);
                
                // mark ourselves as no longer needed a redraw.
                d_needsRedraw = false;
            }
        }
        
        //----------------------------------------------------------------------------//
        private function queueGeometry(ctx:RenderingContext):void
        {
            // add geometry so that it gets drawn to the target surface.
            ctx.surface.addGeometryBuffer(ctx.queue, d_geometry);
        }
        
        /*!
        \brief
        Update the rendering cache.
        
        Populates the Window's GeometryBuffer ready for rendering.
        */
        //virtual function
        protected function populateGeometryBuffer():void
        {
        }
        
        
        /*!
        \brief
        Return whether this window was inherited from the given class name at
        some point in the inheritance hierarchy.
        
        \param class_name
        The class name that is to be checked.
        
        \return
        true if this window was inherited from \a class_name. false if not.
        */
        protected function testClassName_impl(class_name:String):Boolean
        {
            if (class_name == "Window")   return true;
            return false;
        }
        
        
        
        
        /*!
        \brief
        Set the parent window for this window object.
        
        \param parent
        Pointer to a Window object that is to be assigned as the parent to this
        Window.
        
        \return
        Nothing
        */
        public function setParent(parent:FlameWindow):void
        {
            d_parent = parent;
            
            // if we do not have a surface, xfer any surfaces from our children to
            // whatever our target surface now is.
            if (!d_surface)
            {
                transferChildSurfaces();
                // else, since we have a surface, child surfaces stay with us.  Though we
                // must now ensure /our/ surface is xferred if it is a RenderingWindow.
            }
            else if (d_surface.isRenderingWindow())
            {
                // target surface is eihter the parent's target, or the default root.
                var tgt:FlameRenderingSurface = d_parent ?
                    d_parent.getTargetRenderingSurface() :
                    FlameSystem.getSingleton().getRenderer().getDefaultRenderingRoot();
                
                tgt.transferRenderingWindow(d_surface as FlameRenderingWindow);
            }
        }
        
        
        //----------------------------------------------------------------------------//
        protected function getSize_impl(window:FlameWindow):Size
        {
            return window ?
                window.d_pixelSize.clone() :
                FlameSystem.getSingleton().getRenderer().getDisplaySize();
        }
        
        
        /*!
        \brief
        Fires off a repeated mouse button down event for this window.
        */
        public function generateAutoRepeatEvent(button:uint):void
        {
            var ma:MouseEventArgs = new MouseEventArgs(this);
            
            ma.position = getUnprojectedPosition(FlameMouseCursor.getSingleton().getPosition());
            ma.moveDelta = new Vector2(0.0, 0.0);
            ma.button = button;
            ma.sysKeys = FlameSystem.getSingleton().getSystemKeys();
            ma.wheelChange = 0;
            onMouseButtonDown(ma);
        }
        
        
        private function validateWindowRenderer(name:String):Boolean
        {
            return true;
        }
        
        
        /*!
        \brief
        Returns whether a property is at it's default value.
        This function is different from Property::isDefatult as it takes the assigned look'n'feel
        (if the is one) into account.
        */
        protected function isPropertyAtDefault(property:FlameProperty):Boolean
        {
            // if we have a looknfeel we examine it for defaults
            if (d_lookName.length != 0)
            {
                // if we're an autowindow, we check our parent's looknfeel's Child
                // section which we came from as we might be initialised there
                if (d_autoWindow && getParent() && getParent().getLookNFeel().length != 0)
                {
                    const wlf:FalagardWidgetLookFeel =
                        FalagardWidgetLookManager.getSingleton().
                        getWidgetLook(getParent().getLookNFeel());
                    
                    // find our name suffix
                    var suffix:String = "";
                    var pos:int = getName().indexOf(getParent().getName());
                    if(pos != -1)
                    {
                        suffix = getName().substr(pos);
                    }
                    
                    
                    // find the widget component if possible
                    const wc:FalagardWidgetComponent = wlf.findWidgetComponent(suffix);
                    if (wc)
                    {
                        const propinit:FalagardPropertyInitialiser  =
                            wc.findPropertyInitialiser(property.getName());
                        
                        if (propinit)
                            return (getProperty(property.getName()) ==
                                propinit.getInitialiserValue());
                    }
                }
                
                // if the looknfeel has a new default for this property we compare
                // against that
                const wlf2:FalagardWidgetLookFeel =
                    FalagardWidgetLookManager.getSingleton().getWidgetLook(d_lookName);
                const propinit2:FalagardPropertyInitialiser =
                    wlf2.findPropertyInitialiser(property.getName());
                
                if (propinit2)
                    return (getProperty(property.getName()) ==
                        propinit2.getInitialiserValue());
            }
            
            // we dont have a looknfeel with a new value for this property so we rely
            // on the hardcoded default
            return property.isDefault(this);
        }

        /*!
        \brief
        Recursively inform all children that the clipping has changed and screen rects
        needs to be recached.
        */
        //----------------------------------------------------------------------------//
        protected function notifyClippingChanged():void
        {
            d_outerRectClipperValid = false;
            d_innerRectClipperValid = false;
            d_hitTestRectValid = false;
            
            // inform children that their clipped screen areas must be updated
            var num:uint = d_children.length;
            for (var i:uint=0; i<num; ++i) {
                if (d_children[i].isClippedByParent())
                    d_children[i].notifyClippingChanged();
            }
        }

        
        //! helper to create and setup the auto RenderingWindow surface
        protected function allocateRenderingWindow():void
        {
            if (!d_autoRenderingWindow)
            {
                d_autoRenderingWindow = true;
                
                const t:FlameTextureTarget =
                    FlameSystem.getSingleton().getRenderer().createTextureTarget();
                
                // TextureTargets may not be available, so check that first.
                if (!t)
                {
                    trace("Window::allocateRenderingWindow - " +
                        "Failed to create a suitable TextureTarget for use by Window '"
                        + d_name + "'");
                    
                    d_surface = null;
                    return;
                }
                
                d_surface = getTargetRenderingSurface().createRenderingWindow(t);
                transferChildSurfaces();
                
                // set size and position of RenderingWindow
                (d_surface as FlameRenderingWindow).setSize(getPixelSize());
                (d_surface as FlameRenderingWindow).setPosition(getUnclippedOuterRect().getPosition());
                
                
                d_geometry.setTextureTarget(t);
                d_geometry.setSurface(d_surface);
                
                
                FlameSystem.getSingleton().signalRedraw();
            }
        }
        
        //! helper to clean up the auto RenderingWindow surface
        protected function releaseRenderingWindow():void
        {
            if (d_autoRenderingWindow && d_surface)
            {
                const old_surface:FlameRenderingWindow = d_surface as FlameRenderingWindow;
                d_autoRenderingWindow = false;
                d_surface = null;
                // detach child surfaces prior to destroying the owning surface
                transferChildSurfaces();
                // destroy surface and texture target it used
                var tt:FlameTextureTarget = old_surface.getTextureTarget();
                old_surface.getOwner().destroyRenderingWindow(old_surface);
                FlameSystem.getSingleton().getRenderer().destroyTextureTarget(tt);
                
                d_geometry.setSurface(null);
                d_geometry.setTextureTarget(null);
                
                FlameSystem.getSingleton().signalRedraw();
            }
        }
        
        //! Helper to intialise the needed clipping for geometry and render surface.
        protected function initialiseClippers(ctx:RenderingContext):void
        {
            if (ctx.surface.isRenderingWindow() && ctx.owner == this)
            {
                const rendering_window:FlameRenderingWindow =
                        ctx.surface as FlameRenderingWindow;
                
                if (d_clippedByParent && d_parent)
                    rendering_window.setClippingRegion(
                        d_parent.getInnerRectClipper());
                else
                    rendering_window.setClippingRegion(
                        new Rect(0, 0,
                            FlameSystem.getSingleton().getRenderer().getDisplayWidth(),
                            FlameSystem.getSingleton().getRenderer().getDisplayHeight()));
                
                d_geometry.setClippingRegion(new Rect(0, 0, d_pixelSize.d_width, d_pixelSize.d_height));
            }
            else
            {
                var geo_clip:Rect = getOuterRectClipper();
                
                if (geo_clip.getWidth() != 0.0 && geo_clip.getHeight() != 0.0)
                    geo_clip.offset2(new Vector2(-ctx.offset.d_x, -ctx.offset.d_y));
                
                d_geometry.setClippingRegion(geo_clip);
            }
        }
        
        /*!
        \brief
        Cleanup child windows
        */
        public function cleanupChildren():void
        {
            while(getChildCount() != 0)
            {
                var wnd:FlameWindow = d_children[0];
                
                // always remove child
                removeChildWindow(wnd);
                
                // destroy child if that is required
                if (wnd.isDestroyedByParent())
                    FlameWindowManager.getSingleton().destroyWindow(wnd);
            }
        }
        
        /*!
        \brief
        Add given window to child list at an appropriate position
        */
        protected function addChild_impl(wnd:FlameWindow):void
        {
            // if window is already attached, detach it first (will fire normal events)
            var old_parent:FlameWindow = wnd.getParent();
            if(old_parent){
                old_parent.removeChildWindow(wnd);
            }
            
            addWindowToDrawList(wnd);
            
            // add window to child list
            d_children.push(wnd);
            
            // set the parent window
            wnd.setParent(this);
            
            // update area rects and content for the added window
            wnd.notifyScreenAreaChanged(true);
            wnd.invalidate();
            
            // correctly call parent sized notification if needed.
            if (!old_parent || old_parent.getPixelSize() != getPixelSize())
            {
                var args:WindowEventArgs = new WindowEventArgs(this);
                wnd.onParentSized(args);
            }
        }
        
        /*!
        \brief
        Remove given window from child list
        */
        protected function removeChild_impl(wnd:FlameWindow):void
        {
            // remove from draw list
            removeWindowFromDrawList(wnd);
            
            // if window has no children, we can't remove 'wnd' from the child list
            if (d_children.length == 0)
                return;
            
            // find this window in the child list
            for(var i:uint=0; i<d_children.length; i++){
                if(d_children[i] == wnd){
                    // remove window from child list
                    d_children.splice(i, 1);
                    // reset windows parent so it's no longer this window.
                    wnd.setParent(null);
                    break;
                }
            }
        }
        
        
        /*!
        \brief
        Notify 'this' and all siblings of a ZOrder change event
        */
        protected function onZChange_impl():void
        {
            if (!d_parent)
            {
                var args:WindowEventArgs = new WindowEventArgs(this);
                onZChanged(args);
            }
            else
            {
                var child_count:uint = d_parent.getChildCount();
                
                for (var i:uint = 0; i < child_count; ++i)
                {
                    var sargs:WindowEventArgs = new WindowEventArgs(d_parent.d_children[i]);
                    d_parent.d_children[i].onZChanged(sargs);
                }
                
            }
            
            FlameSystem.getSingleton().updateWindowContainingMouse();
        }
        
        
        
        

        private function addStandardProperties():void
        {
            //ext
            addProperty(d_absHeightProperty);
            addProperty(d_absMaxSizeProperty);
            addProperty(d_absMinSizeProperty);
            addProperty(d_absPositionProperty);
            addProperty(d_absRectProperty);
            addProperty(d_absSizeProperty);
            addProperty(d_absWidthProperty);
            addProperty(d_absXPosProperty);
            addProperty(d_absYPosProperty);
            addProperty(d_alphaProperty);
            addProperty(d_alwaysOnTopProperty);
            addProperty(d_clippedByParentProperty);
            addProperty(d_destroyedByParentProperty);
            addProperty(d_disabledProperty);
            addProperty(d_fontProperty);
            addProperty(d_heightProperty );
            addProperty(d_IDProperty);
            addProperty(d_inheritsAlphaProperty);
            addProperty(d_metricsModeProperty );
            addProperty(d_mouseCursorProperty);
            addProperty(d_positionProperty );
            addProperty(d_rectProperty );
            addProperty(d_relHeightProperty );
            addProperty(d_relMaxSizeProperty );
            addProperty(d_relMinSizeProperty );
            addProperty(d_relPositionProperty );
            addProperty(d_relRectProperty );
            addProperty(d_relSizeProperty );
            addProperty(d_relWidthProperty );
            addProperty(d_relXPosProperty );
            addProperty(d_relYPosProperty );
            addProperty(d_restoreOldCaptureProperty);
            addProperty(d_sizeProperty );
            addProperty(d_textOriginalProperty );
            addProperty(d_textProperty);
            addProperty(d_visibleProperty);
            addProperty(d_widthProperty );
            addProperty(d_xPosProperty );
            addProperty(d_yPosProperty );
            addProperty(d_zOrderChangeProperty);
            addProperty(d_wantsMultiClicksProperty);
            addProperty(d_autoRepeatProperty);
            addProperty(d_autoRepeatDelayProperty);
            addProperty(d_autoRepeatRateProperty);
            addProperty(d_distInputsProperty);
            addProperty(d_tooltipTypeProperty);
            addProperty(d_tooltipProperty);
            addProperty(d_inheritsTooltipProperty);
            addProperty(d_riseOnClickProperty);
            addProperty(d_vertAlignProperty);
            addProperty(d_horzAlignProperty);
            addProperty(d_unifiedAreaRectProperty);
            addProperty(d_unifiedPositionProperty);
            addProperty(d_unifiedXPositionProperty);
            addProperty(d_unifiedYPositionProperty);
            addProperty(d_unifiedSizeProperty);
            addProperty(d_unifiedWidthProperty);
            addProperty(d_unifiedHeightProperty);
            addProperty(d_unifiedMinSizeProperty);
            addProperty(d_unifiedMaxSizeProperty);
            addProperty(d_zoomModeProperty );
            addProperty(d_hookPositionProperty);
            addProperty(d_hookModeProperty);
            addProperty(d_maskImageProperty);
            addProperty(d_mousePassThroughEnabledProperty);
            addProperty(d_windowRendererProperty);
            addProperty(d_lookNFeelProperty);
            addProperty(d_dragDropTargetProperty);
            addProperty(d_autoRenderingSurfaceProperty);
            addProperty(d_rotationProperty);
            addProperty(d_xRotationProperty);
            addProperty(d_yRotationProperty);
            addProperty(d_zRotationProperty);
            addProperty(d_nonClientProperty);
            addProperty(d_textParsingEnabledProperty);
            addProperty(d_marginProperty);
            addProperty(d_updateModeProperty);
            addProperty(d_mouseInputPropagationProperty);
            
            addProperty(d_showSoundProperty);
            addProperty(d_hideSoundProperty);
            addProperty(d_lclickSoundProperty);
            addProperty(d_rclickSoundProperty);
            addProperty(d_ldoubleClickSoundProperty);
            addProperty(d_hoverSoundProperty);
            
//            addProperty(d_mouseHollowProperty );
//            addProperty(d_mouseMoveHollowProperty );
//            addProperty(d_mouseLButtonHollowProperty );
//            addProperty(d_mouseRButtonHollowProperty );

            
            /*
            // we ban some of these properties from xml for auto windows by default
            if (isAutoWindow())
            {
            banPropertyFromXML(&d_destroyedByParentProperty);
            banPropertyFromXML(&d_vertAlignProperty);
            banPropertyFromXML(&d_horzAlignProperty);
            banPropertyFromXML(&d_unifiedAreaRectProperty);
            banPropertyFromXML(&d_unifiedPositionProperty);
            banPropertyFromXML(&d_unifiedXPositionProperty);
            banPropertyFromXML(&d_unifiedYPositionProperty);
            banPropertyFromXML(&d_unifiedSizeProperty);
            banPropertyFromXML(&d_unifiedWidthProperty);
            banPropertyFromXML(&d_unifiedHeightProperty);
            banPropertyFromXML(&d_unifiedMinSizeProperty);
            banPropertyFromXML(&d_unifiedMaxSizeProperty);
            banPropertyFromXML(&d_windowRendererProperty);
            banPropertyFromXML(&d_lookNFeelProperty);
            }
            */
        }
        
        
        /*!
        \brief
        Implements move to front behavior.
        
        \return
        Should return true if some action was taken, or false if there was
        nothing to be done.
        */
        protected function moveToFront_impl(wasClicked:Boolean):Boolean
        {
            var took_action:Boolean = false;
            
            // if the window has no parent then we can have no siblings
            if (d_parent == null)
            {
                // perform initial activation if required.
                if (!isActive())
                {
                    took_action = true;
                    var args:ActivationEventArgs = new ActivationEventArgs(this);
                    args.otherWindow = null;
                    onActivated(args);
                }
                
                return took_action;
            }
            
            // bring parent window to front of it's siblings
            took_action = d_parent.moveToFront_impl(wasClicked);
            
            // get immediate child of parent that is currently active (if any)
            const activeWnd:FlameWindow = getActiveSibling();
            
            // if a change in active window has occurred
            if (activeWnd != this)
            {
                took_action = true;
                
                var aargs:ActivationEventArgs = new ActivationEventArgs(this);
                aargs.otherWindow = activeWnd;
                onActivated(aargs);
                
                //to be checked.... this is only for editbox/multiline editbox
                //move the input textfield below the editbox
                var pos:Vector2 = getUnclippedOuterRect().getPosition();
                FlameEventManager.getSingleton().moveIMEWindowTo(pos.d_x, pos.d_y);
                FlameEventManager.getSingleton().enableInput(true);

                
                // notify any previously active window that it is no longer active
                if (activeWnd)
                {
                    var dargs:ActivationEventArgs = new ActivationEventArgs(this);
                    dargs.window = activeWnd;
                    dargs.otherWindow = this;
                    dargs.handled = 0;
                    activeWnd.onDeactivated(dargs);
                }
            }
            
            // bring us to the front of our siblings
            if (d_zOrderingEnabled &&
                (!wasClicked || d_riseOnClick) &&
                !isTopOfZOrder())
            {
                took_action = true;
                
                // remove us from our parent's draw list
                d_parent.removeWindowFromDrawList(this);
                // re-attach ourselves to our parent's draw list which will move us in
                // front of sibling windows with the same 'always-on-top' setting as we
                // have.
                d_parent.addWindowToDrawList(this);
                // notify relevant windows about the z-order change.
                onZChange_impl();
            }
            
            return took_action;
        }
        
        
        /*!
        \brief
        Implementation method to modify window area while correctly applying
        min / max size processing, and firing any appropriate events.
        
        /note
        This is the implementation function for setting size and position.
        In order to simplify area management, from this point on, all
        modifications to window size and position (area rect) should come
        through here.
        
        /param pos
        UVector2 object describing the new area position.
        
        /param size
        UVector2 object describing the new area size.
        
        /param topLeftSizing
        - true to indicate the the operation is a sizing operation on the top
        and/or left edges of the area, and so window movement should be
        inhibited if size is at max or min.
        - false to indicate the operation is not a strict sizing operation on
        the top and/or left edges and that the window position may change as
        required
        
        /param fireEvents
        - true if events should be fired as normal.
        - false to inhibit firing of events (required, for example, if you need
        to call this from the onSize/onMove handlers).
        */
        protected function setArea_impl(pos:UVector2, size:UVector2, 
                                        topLeftSizing:Boolean = false, fireEvents:Boolean = true):void
        {
            markAllCachedRectsInvalid();
            
            //trace("set window area impl:" + pos.d_x + "," + pos.d_y + " size:" + size.d_x, size.d_y);
            
            // save original size so we can work out how to behave later on
            var oldSize:Size = d_pixelSize.clone();
            
            d_area.setSize(size);
            calculatePixelSize();
            
            var sized:Boolean = ! d_pixelSize.isEqual(oldSize);
//            trace("===sized:" + sized);
//            trace("oldsize:" + oldSize.toString() + ", new size:" + size.toString());
            
            // If this is a top/left edge sizing op, only modify position if the size
            // actually changed.  If it is not a sizing op, then position may always
            // change.
            var moved:Boolean = (!topLeftSizing || sized) && !pos.isEqual(d_area.d_min);
            
            if (moved)
                d_area.setPosition(pos);
            
            if (fireEvents)
                fireAreaChangeEvents(moved, sized);
            
            if (moved || sized)
                FlameSystem.getSingleton().updateWindowContainingMouse();
            
            // update geometry position and clipping if nothing from above appears to
            // have done so already (NB: may be occasionally wasteful, but fixes bugs!)
            if (!d_outerUnclippedRectValid)
                updateGeometryRenderSettings();
        }
        
        
        
        /*!
        \brief
        Add the given window to the drawing list at an appropriate position for
        it's settings and the required direction.  Basically, when \a at_back
        is false, the window will appear in front of all other windows with the
        same 'always on top' setting.  When \a at_back is true, the window will
        appear behind all other windows wih the same 'always on top' setting.
        
        \param wnd
        Window object to be added to the drawing list.
        
        \param at_back
        Indicates whether the window should be placed at the back of other
        windows in the same group. If this is false, the window is placed in
        front of other windows in the group.
        
        \return
        Nothing.
        */
        public function addWindowToDrawList(wnd:FlameWindow, at_back:Boolean = false):void
        {
            if(wnd.isAlwaysOnTop())
            {
                d_drawList.push(wnd);
                return;
            }
                

            if(at_back)
            {
                d_drawList.splice(0,0,wnd);
            }
            else
            {
                d_drawList.push(wnd);
            }
            return;
            

            if(wnd.getName().indexOf("__auto_closebutton__") != -1)
            {
                trace("ok");
            }
            
            
            // add behind other windows in same group
            if (at_back)
            {
                var pos:uint = 0;
                // calculate position where window should be added for drawing
                if (wnd.isAlwaysOnTop())
                {
                    // find first topmost window
                    while(pos < d_drawList.length-1 && ! d_drawList[pos].isAlwaysOnTop())
                        pos++;
                }
                // add window to draw list
                d_drawList.splice(pos, 0, wnd);
            }
                // add in front of other windows in group
            else
            {
                var rpos:int = d_drawList.length-1;
                if (! wnd.isAlwaysOnTop())
                {
                    // calculate position where window should be added for drawing
                    // find last non-topmost window
                    while(rpos > 0 && d_drawList[rpos].isAlwaysOnTop())
                        rpos--;
                }
                // add window to draw list
                d_drawList.splice(rpos, 0, wnd);
            }
            
            //trace("add to draw list, now size is:" + d_drawList.length);
        }
        
        /*!
        \brief
        Removes the window from the drawing list.  If the window is not attached
        to the drawing list then nothing happens.
        
        \param wnd
        Window object to be removed from the drawing list.
        
        \return
        Nothing.
        */
        public function removeWindowFromDrawList(wnd:FlameWindow):void
        {
            // if draw list is not empty
            if (!d_drawList.length == 0)
            {
                // attempt to find the window in the draw list
                var pos:int = d_drawList.indexOf(wnd);
                
                Misc.assert(pos != -1);
                d_drawList.splice(pos, 1);
            }
        }

        /*!
        \brief
        Return whether the window is at the top of the Z-Order.  This will
        correctly take into account 'Always on top' windows as needed.
        
        \return
        - true if the Window is at the top of the z-order in relation to sibling
        windows with the same 'always on top' setting.
        - false if the Window is not at the top of the z-order in relation to
        sibling windows with the same 'always on top' setting.
        */
        private function isTopOfZOrder():Boolean
        {
            //to be checked, note by yumj
            
            
            // if not attached, then always on top!
            if (!d_parent)
                return true;
            
            var pos:uint = d_parent.d_drawList.length-1;
            
            // get position of window at top of z-order in same group as this window
            if (!d_alwaysOnTop)
            {
                // find last non-topmost window
                while(pos > 0 && d_parent.d_drawList[pos].isAlwaysOnTop())
                    --pos;
            }
            
            // return whether the window at the top of the z order is us
            return d_parent.d_drawList[pos] == this;
        }
        
        /*!
        \brief
        Update position and clip region on this Windows geometry / rendering
        surface.
        */
        private function updateGeometryRenderSettings():void
        {
            var ctx:RenderingContext = getRenderingContext();
            
            // move the underlying RenderingWindow if we're using such a thing
            if (ctx.owner == this && ctx.surface.isRenderingWindow())
            {
                (ctx.surface as FlameRenderingWindow).setPosition(getUnclippedOuterRect().getPosition());
                (d_surface as FlameRenderingWindow).setPivot(
                    new Vector3(d_pixelSize.d_width / 2.0,
                        d_pixelSize.d_height / 2.0,
                        0.0));
                d_geometry.setTranslation(new Vector3(0.0, 0.0, 0.0));
            }
                // if we're not texture backed, update geometry position.
            else
            {
                // position is the offset of the window on the dest surface.
                const ucrect:Rect = getUnclippedOuterRect();
                d_geometry.setTranslation(new Vector3(ucrect.d_left - ctx.offset.d_x,
                    ucrect.d_top - ctx.offset.d_y, 0.0));
            }
            initialiseClippers(ctx);
        }
        
        
        //! transfer RenderingSurfaces to be owned by our target RenderingSurface.
        private function transferChildSurfaces():void
        {
            var s:FlameRenderingSurface = getTargetRenderingSurface();
            
            const child_count:uint = getChildCount();
            for (var i:uint = 0; i < child_count; ++i)
            {
                const c:FlameWindow = d_children[i];
                
                if (c.d_surface && c.d_surface.isRenderingWindow())
                    s.transferRenderingWindow(
                        c.d_surface as FlameRenderingWindow);
                else
                    c.transferChildSurfaces();
            }
        }
        
        
        //! helper function for calculating clipping rectangles.
        //----------------------------------------------------------------------------//
        public function getParentElementClipIntersection(unclipped_area:Rect):Rect
        {
            return unclipped_area.getIntersection(
                (d_parent && d_clippedByParent) ?
                d_parent.getClipRect(d_nonClientContent) :
                new Rect(0, 0, 
                    FlameSystem.getSingleton().getRenderer().getDisplayWidth(),
                    FlameSystem.getSingleton().getRenderer().getDisplayHeight()
                ));
        }
        
        //! helper function to invalidate window and optionally child windows.
        private function invalidate_impl(recursive:Boolean):void
        {
            d_needsRedraw = true;
            invalidateRenderingSurface();
            
            if (recursive)
            {
                var child_count:uint = getChildCount();
                for (var i:uint = 0; i < child_count; ++i)
                {
                    d_children[i].invalidate_impl(true);
                }
            }
        }
        
        
        //----------------------------------------------------------------------------//
        private function isInnerRectSizeChanged():Boolean
        {
            const old_sz:Size = d_innerUnclippedRect.getSize();
            d_innerUnclippedRectValid = false;
            return old_sz != getUnclippedInnerRect().getSize();
        }
        
        /*!
        \brief
        Helper function to return the ancestor Window of /a wnd that is attached
        as a child to a window that is also an ancestor of /a this.  Returns 0
        if /a wnd and /a this are not part of the same hierachy.
        */
        protected function getWindowAttachedToCommonAncestor(wnd:FlameWindow):FlameWindow
        {
            var w:FlameWindow = wnd;
            var tmp:FlameWindow = w.d_parent;
            
            while (tmp)
            {
                if (isAncestorForWindow(tmp))
                    break;
                
                w = tmp;
                tmp = tmp.d_parent;
            }
            
            return tmp ? w : null;
        }

        
        //! Default implementation of function to return Window outer rect area.
        private function getUnclippedOuterRect_impl() : Rect
        {
            var local:Rect = new Rect(0, 0, d_pixelSize.d_width, d_pixelSize.d_height);
            return CoordConverter.windowToScreenForRect(this, local);
        }
        
        //! Default implementation of function to return Window outer clipper area.
        private function getOuterRectClipper_impl():Rect
        {
            return (d_surface && d_surface.isRenderingWindow()) ?
                getUnclippedOuterRect() :
                getParentElementClipIntersection(getUnclippedOuterRect());
        }
        
        
        
        //! Default implementation of function to return Window inner clipper area.
        protected function getInnerRectClipper_impl():Rect
        {
            return (d_surface && d_surface.isRenderingWindow()) ?
                getUnclippedInnerRect() :
                getParentElementClipIntersection(getUnclippedInnerRect());
        }
        
        
        protected function getHitTestRect_impl():Rect
        {
            // if clipped by parent wnd, hit test area is the intersection of our
            // outer rect with the parent's hit test area intersected with the
            // parent's clipper.
            if (d_parent && d_clippedByParent)
            {
                return getUnclippedOuterRect().getIntersection(
                    d_parent.getHitTestRect().getIntersection(
                        d_parent.getClipRect(d_nonClientContent)));
            }
                // not clipped to parent wnd, so get intersection with screen area.
            else
            {
                return getUnclippedOuterRect().getIntersection(
                    new Rect(0, 0,
                        FlameSystem.getSingleton().getRenderer().getDisplayWidth(),
                        FlameSystem.getSingleton().getRenderer().getDisplayHeight()
                    ));
            }
        }
        
        
        //! Default implementation of function to return non-client content area
        protected function getNonClientChildWindowContentArea_impl():Rect
        {
            return getUnclippedOuterRect_impl();
        }
        
        //! Default implementation of function to return client content area
        protected function getClientChildWindowContentArea_impl():Rect
        {
            return getUnclippedInnerRect_impl();
        }
        
        
        // constrain given UVector2 to window's min size, return if size changed.
        private function constrainUVector2ToMinSize(base_sz:Size, sz:UVector2):Boolean
        {
            const pixel_sz:Vector2 = sz.asAbsolute(base_sz);
            const min_sz:Vector2 = d_minSize.asAbsolute(
                FlameSystem.getSingleton().getRenderer().getDisplaySize());
            
            var size_changed:Boolean = false;
            
            // check width is not less than the minimum
            if (pixel_sz.d_x < min_sz.d_x)
            {
                sz.d_x.d_offset = Math.min(sz.d_x.d_offset, d_minSize.d_x.d_offset);
                
                sz.d_x.d_scale = (base_sz.d_width != 0.0) ?
                    (min_sz.d_x - sz.d_x.d_offset) / base_sz.d_width : 0.0;
                
                size_changed = true;
            }
            
            // check height is not less than the minimum
            if (pixel_sz.d_y < min_sz.d_y)
            {
                sz.d_y.d_offset = Math.min(sz.d_y.d_offset, d_minSize.d_y.d_offset);
                
                sz.d_y.d_scale = (base_sz.d_height != 0.0) ?
                    (min_sz.d_y - sz.d_y.d_offset) / base_sz.d_height : 0.0;
                
                size_changed = true;
            }
            
            return size_changed;
        }
        
        // constrain given UVector2 to window's max size, return if size changed.
        private function constrainUVector2ToMaxSize(base_sz:Size, sz:UVector2):Boolean
        {
            const pixel_sz:Vector2 = sz.asAbsolute(base_sz);
            const max_sz:Vector2 = d_maxSize.asAbsolute(
                FlameSystem.getSingleton().getRenderer().getDisplaySize());
            
            var size_changed:Boolean = false;
            
            // check width is not greater than the maximum
            if (pixel_sz.d_x > max_sz.d_x)
            {
                sz.d_x.d_offset = Math.max(sz.d_x.d_offset, d_maxSize.d_x.d_offset);
                
                sz.d_x.d_scale = (base_sz.d_width != 0.0) ?
                    (max_sz.d_x - sz.d_x.d_offset) / base_sz.d_width :  0.0;
                
                size_changed = true;
            }
            
            // check height is not greater than the maximum
            if (pixel_sz.d_y > max_sz.d_y)
            {
                sz.d_y.d_offset = Math.max(sz.d_y.d_offset, d_maxSize.d_y.d_offset);
                
                sz.d_y.d_scale = (base_sz.d_height != 0.0) ?
                    (max_sz.d_y - sz.d_y.d_offset) / base_sz.d_height :  0.0;
                
                size_changed = true;
            }
            
            return size_changed;
        }
        
        //----------------------------------------------------------------------------//
        private function markAllCachedRectsInvalid():void
        {
            d_outerUnclippedRectValid = false;
            d_innerUnclippedRectValid = false;
            d_outerRectClipperValid = false;
            d_innerRectClipperValid = false;
            d_hitTestRectValid = false;
        }
        
        //! calculate constrained pixel size of the window (outer rect)
        public function calculatePixelSize():void
        {
            // calculate pixel sizes for everything, so we have a common format for
            // comparisons.
            const absMax:Vector2 = d_maxSize.asAbsolute(
                FlameSystem.getSingleton().getRenderer().getDisplaySize());
            const absMin:Vector2 = d_minSize.asAbsolute(
                FlameSystem.getSingleton().getRenderer().getDisplaySize());
            
            const base_size:Size = d_parent ? 
                d_parent.getChildWindowContentArea(d_nonClientContent).getSize() :
                FlameSystem.getSingleton().getRenderer().getDisplaySize();
            
            d_pixelSize = d_area.getSize().asAbsolute(base_size).asSize();
            
            // limit new pixel size to: minSize <= newSize <= maxSize
            if (d_pixelSize.d_width < absMin.d_x)
                d_pixelSize.d_width = absMin.d_x;
            else if (d_pixelSize.d_width > absMax.d_x)
                d_pixelSize.d_width = absMax.d_x;
            if (d_pixelSize.d_height < absMin.d_y)
                d_pixelSize.d_height = absMin.d_y;
            else if (d_pixelSize.d_height > absMax.d_y)
                d_pixelSize.d_height = absMax.d_y;
        }
        
        
        //! helper to fire events based on changes to area rect
        private function fireAreaChangeEvents(moved:Boolean, sized:Boolean):void
        {
            if (moved)
            {
                var margs:WindowEventArgs = new WindowEventArgs(this);
                onMoved(margs);
            }
            
            if (sized)
            {
                var sargs:WindowEventArgs = new WindowEventArgs(this);
                onSized(sargs);
            }
        }
   
        //===========================================================================
        public function getSurface():FlameRenderingSurface
        {
            return d_surface;
        }

        
        
        //sound extension
        public function setShowSound(showSound:String):void
        {
            d_showSound = showSound;
        }
        
        public function getShowSound():String
        {
            return d_showSound;
        }
        
        public function setHideSound(hideSound:String):void
        {
            d_hideSound = hideSound;
        }
        public function getHideSound():String
        {
            return d_hideSound;
        }
        
        public function setLClickSound(clickSound:String):void
        {
            d_lclickSound = clickSound;
        }
        public function getLClickSound():String
        {
            return d_lclickSound;
        }
        
        public function setRClickSound(clickSound:String):void
        {
            d_rclickSound = clickSound;
        }
        public function getRClickSound():String
        {
            return d_rclickSound;
        }
        public function setLDoubleClickSound(clickSound:String):void
        {
            d_ldoubleClickSound = clickSound;
        }
        public function getLDoubleClickSound():String
        {
            return d_ldoubleClickSound;
        }
        
        public function setHoverSound(hoverSound:String):void
        {
            d_hoverSound = hoverSound;
        }
        public function getHoverSound():String
        {
            return d_hoverSound;
        }
        
        
        
    }
    
}