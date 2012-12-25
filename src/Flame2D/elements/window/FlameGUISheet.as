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
package Flame2D.elements.window
{
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.UVector2;
    
    /*!
    \brief
    Window class intended to be used as a simple, generic Window.
    
    This class does no rendering and so appears totally transparent.  This window defaults
    to position 0.0f, 0.0f with a size of 1.0f x 1.0f.
    
    /note
    The C++ name of this class has been retained for backward compatibility reasons.  The intended usage of
    this window type has now been extended beyond that of a gui-sheet or root window.
    */
    public class FlameGUISheet extends FlameWindow
    {
        /*************************************************************************
         Constants
         *************************************************************************/
        // type name for this widget
        public static const WidgetTypeName:String = "DefaultWindow";             //!< The unique typename of this widget
        
        public function FlameGUISheet(type:String, name:String)
        {
            super(type, name);
            
            var sz:UVector2 = new UVector2(Misc.cegui_reldim(1.0), Misc.cegui_reldim(1.0));
            setMaxSize(sz);
            setSize(sz);
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
            if (class_name=="DefaultWindow" || class_name=="GUISheet")	return true;
            return super.testClassName_impl(class_name);
        }
        
        //! helper to update mouse input handled state
        protected  function updateMouseEventHandled(e:MouseEventArgs):void
        {
            // by default, if we are a root window (no parent) with pass-though enabled
            // we do /not/ mark mouse events as handled.
            if (!d_parent && e.handled && d_mousePassThroughEnabled)
                --e.handled;
        }
        
        // overridden functions from Window base class
        override protected function moveToFront_impl(wasClicked:Boolean):Boolean
        {
            var took_action:Boolean = super.moveToFront_impl(wasClicked);
            
            if (!d_parent && d_mousePassThroughEnabled)
                return false;
            else
                return took_action;
        }
        
        // override the mouse event handlers
        override public function onMouseMove(e:MouseEventArgs):void
        {
            // always call the base class handler
            super.onMouseMove(e);
            updateMouseEventHandled(e);
        }
        
        
        override public function onMouseWheel(e:MouseEventArgs):void
        {
            // always call the base class handler
            super.onMouseWheel(e);
            updateMouseEventHandled(e);
        }
        
        override public function onMouseButtonDown(e:MouseEventArgs):void
        {
            // always call the base class handler
            super.onMouseButtonDown(e);
            updateMouseEventHandled(e);
        }
        
        override public function onMouseButtonUp(e:MouseEventArgs):void
        {
            // always call the base class handler
            super.onMouseButtonUp(e);
            updateMouseEventHandled(e);
        }
        
        override public function onMouseClicked(e:MouseEventArgs):void
        {
            // always call the base class handler
            super.onMouseClicked(e);
            // only adjust the handled state if event was directly injected
            if (!FlameSystem.getSingleton().isMouseClickEventGenerationEnabled())
                updateMouseEventHandled(e);
        }
        
        override public function onMouseDoubleClicked(e:MouseEventArgs):void
        {
            // always call the base class handler
            super.onMouseDoubleClicked(e);
            updateMouseEventHandled(e);
        }
        
        override public function onMouseTripleClicked(e:MouseEventArgs):void
        {
            // always call the base class handler
            super.onMouseTripleClicked(e);
            updateMouseEventHandled(e);
        }
    }
}