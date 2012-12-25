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
    import Flame2D.core.system.FlameWindowManager;

    /*!
    \brief
    Base class for standard GroupBox widget.
    */
    public class FlameGroupBox extends FlameWindow
    {
        public static const EventNamespace:String = "GroupBox";
        public static const WidgetTypeName:String = "CEGUI/GroupBox";
        
        
        public static const ContentPaneNameSuffix:String = "__auto_contentpane__";

        
        public function FlameGroupBox(type:String, name:String)
        {
            super(type, name);
            
            d_riseOnClick = false;
        }
        
        /*!
        \brief
        Draws the GroupBox around a widget. The size and position of the GroupBox are overriden.
        Once the window that is drawn around resizes, you'll have to call the function again. FIXME
        */
        public function drawAroundWidget(wnd:FlameWindow):Boolean
        {
            trace("TODO: GroupBox::drawAroundWidget");
            return true;
            /*if (!wnd)
            {
            return false;
            }
            UVector2 widgetSize = wnd->getSize();
            UVector2 widgetPosition = wnd->getPosition();
            UVector2 newSize = widgetSize;
            newSize.d_x.d_scale = widgetSize.d_x.d_scale + 0.04f;
            newSize.d_y.d_scale = widgetSize.d_y.d_scale + 0.06f;
            UVector2 newPos = widgetPosition;
            newPos.d_x.d_scale = widgetPosition.d_x.d_scale - 0.02f;
            newPos.d_y.d_scale = widgetPosition.d_y.d_scale - 0.04f;
            
            this->setSize(newSize);
            this->setPosition(newPos);
            
            return true;*/   
        }
        
        public function drawAroundWidgetByName(name:String):Boolean
        {
            return drawAroundWidget(FlameWindowManager.getSingleton().getWindow(name));
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
            if (class_name=="GroupBox") return true;
            return super.testClassName_impl(class_name);
        }
        
        /*!
        \brief
        Returns the content pane held by this GroupBox.
        
        \return
        Pointer to a Window instance.
        */
        public function getContentPane():FlameWindow
        {
            var paneName:String = d_name + ContentPaneNameSuffix;
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            if (winMgr.isWindowPresent(paneName))
            {
                return winMgr.getWindow(paneName);
            }
            return null;
        }
        
        
        /*!
        \brief
        Add given window to child list at an appropriate position.
        */
        override protected function addChild_impl(wnd:FlameWindow):void
        {
            if (wnd.isAutoWindow())
            {
                super.addChild_impl(wnd);
            } 
            else 
            {
                var pane:FlameWindow = getContentPane();
                if(pane)
                    pane.addChildWindow(wnd);
            }
        }
        
        /*!
        \brief
        Remove our child again when necessary.
        */
        override protected function removeChild_impl(wnd:FlameWindow):void
        {
            if (wnd.isAutoWindow())
            {
                super.removeChild_impl(wnd);
            }
            else
            {
                var pane:FlameWindow = getContentPane();
                if(pane)
                    pane.removeChildWindow(wnd);
            }
        }

    }
}