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
    import Flame2D.core.data.RenderingContext;
    import Flame2D.core.falagard.FalagardWidgetLookFeel;
    import Flame2D.core.falagard.FalagardWidgetLookManager;
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.utils.Rect;
    
    import flash.events.EventDispatcher;

    public class FlameWindowRenderer
    {
        
        public var d_window:FlameWindow;
        private var d_name:String;
        private var d_class:String;
        
        private var d_properties:Vector.<FlameProperty> = new Vector.<FlameProperty>();
        
        
        
        /*************************************************************************
         Constructor / Destructor
         **************************************************************************/
        /*!
        \brief
        Constructor
        
        \param name
        Factory type name
        
        \param class_name
        The name of a widget class that is to be the minimum requirement for
        this window renderer.
        */
        public function FlameWindowRenderer(name:String, class_name:String = "Window")
        {
            this.d_name = name;
            this.d_class = class_name;
            this.d_window = null;
        }
       
        
        /*************************************************************************
         Public interface
         **************************************************************************/
        /*!
        \brief
        Populate render cache.
        
        This method must be implemented by all window renderers and should
        perform the rendering operations needed for this widget.
        Normally using the Falagard API...
        */
        public function render():void
        {
            throw new Error("FlameWindowRenderer, render() should be override.");
        }
        
        /*!
        \brief
        Returns the factory type name of this window renderer.
        */
        public function getName():String
        {
            return d_name;
        }
        
        /*!
        \brief
        Get the window this windowrenderer is attached to.
        */
        public function getWindow():FlameWindow
        {
            return d_window;
        }
        
        /*!
        \brief
        Get the "minimum" Window class this renderer requires
        */
        public function getClass():String
        {
            return d_class;
        }
        
        /*!
        \brief
        Get the Look'N'Feel assigned to our window
        */
        public function getLookNFeel():FalagardWidgetLookFeel
        {
            return FalagardWidgetLookManager.getSingleton().getWidgetLook(d_window.getLookNFeel());
        }
        
        /*!
        \brief
        Get unclipped inner rectangle that our window should return from its
        member function with the same name.
        */
        public function getUnclippedInnerRect():Rect
        {
            const lf:FalagardWidgetLookFeel = getLookNFeel();
            
            if (lf.isNamedAreaDefined("inner_rect"))
                return lf.getNamedArea("inner_rect").getArea().
                    getPixelRect2(d_window, d_window.getUnclippedOuterRect());
            else
                return d_window.getUnclippedOuterRect();
        }
        
        /*!
        \brief
        Method called to perform extended laying out of the window's attached
        child windows.
        */
        public function performChildWindowLayout():void
        {
        }
        
        /*!
        \brief
        update the RenderingContext as needed for our window.  This is normally
        invoked via our window's member function with the same name.
        */
        public function getRenderingContext():RenderingContext
        {
            // default just calls back to the window implementation version.
            return d_window.getRenderingContext_impl();
        }
        
        //! perform any time based updates for this WindowRenderer.
        public function update( elapsed:Number = 0):void
        {
        }
        
        /*************************************************************************
         Implementation methods
         **************************************************************************/
        /*!
        \brief
        Register a property class that will be properly managed by this window
        renderer.
        
        \param property
        Pointer to a static Property object that will be added to the target
        window.
        
        \param ban_from_xml
        - true if this property should be added to the 'ban' list so that it is
        not written in XML output.
        - false if this property is not banned and should appear in XML output.
        */
        protected function registerPropertyWithBan(property:FlameProperty, ban_from_xml:Boolean):void
        {
            d_properties.push(property);
        }
        
        /*!
        \brief
        Register a property class that will be properly managed by this window
        renderer.
        
        \param property
        Pointer to a static Property object that will be added to the target
        window.
        */
        protected function registerProperty(property:FlameProperty):void
       {
           registerPropertyWithBan(property, false);
       }
        
        /*!
        \brief
        Handler called when this windowrenderer is attached to a window
        */
        public function onAttach():void
        {
            for(var i:uint=0; i<d_properties.length; i++)
            {
                d_window.addProperty(d_properties[i]);
                // ban from xml if neccessary
//                if ((*i).second)
//                    d_window->banPropertyFromXML((*i).first);
//                
            }
        }
        
        /*!
        \brief
        Handler called when this windowrenderer is detached from its window
        */
        public function onDetach():void
        {
            for(var i:uint=0; i< d_properties.length; i++)
            {
//                // unban from xml if neccessary
//                if ((*i).second)
//                    d_window->unbanPropertyFromXML((*i).first);
                
                d_window.removeProperty(d_properties[i].getName());
            }
        }
        
        /*!
        \brief
        Handler called when a Look'N'Feel is assigned to our window.
        */
        public function onLookNFeelAssigned():void
        {
        }
        
        /*!
        \brief
        Handler called when a Look'N'Feel is removed/unassigned from our window.
        */
        public function onLookNFeelUnassigned():void
        {
        }
        
        //void operator=(const WindowRenderer&) {}
    }
}