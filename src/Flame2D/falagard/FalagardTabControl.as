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
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.elements.tab.FlameTabButton;
    import Flame2D.elements.tab.TabControlWindowRenderer;
    import Flame2D.core.falagard.FalagardStateImagery;
    import Flame2D.core.falagard.FalagardWidgetLookFeel;

    /*!
    \brief
    TabControl class for the FalagardBase module.
    
    This class requires LookNFeel to be assigned.  The LookNFeel should provide the following:
    
    States:
    - Enabled
    - Disabled
    
    Child Widgets:
    TabPane based widget with name suffix "__auto_TabPane__"
    optional: DefaultWindow to contain tab buttons with name suffix "__auto_TabPane__Buttons"
    
    Property initialiser definitions:
    - TabButtonType - specifies a TabButton based widget type to be
    created each time a new tab button is required.
    
    \note
    The current TabControl base class enforces a strict layout, so while
    imagery can be customised as desired, the general layout of the
    component widgets is, at least for the time being, fixed.
    */
    public class FalagardTabControl extends TabControlWindowRenderer
    {
        
        public static const TypeName:String = "Falagard/TabControl";
        
        // data fields
        protected var d_tabButtonType:String;
        
        // properties
        protected static var d_tabButtonTypeProperty:FalagardTabControlPropertyTabButtonType = new FalagardTabControlPropertyTabButtonType();
        
        
        public function FalagardTabControl(type:String)
        {
            super(type);
            
            registerProperty(d_tabButtonTypeProperty);
        }
        
        override public function render():void
        {
            var imagery:FalagardStateImagery;
            // get WidgetLookFeel for the assigned look.
            const wlf:FalagardWidgetLookFeel = getLookNFeel();
            // render basic imagery
            imagery = wlf.getStateImagery(d_window.isDisabled() ? "Disabled" : "Enabled");
            imagery.render(d_window);
        }
        
        
        public function getTabButtonType():String
        {
            return d_tabButtonType;
        }
        
        public function setTabButtonType(type:String):void
        {
            d_tabButtonType = type;
        }
        
        // overridden from TabControl base class.
        override public function createTabButton(name:String):FlameTabButton
        {
            if (d_tabButtonType.length == 0)
            {
                throw new Error("FalagardTabControl::createTabButton - d_tabButtonType has not been set!");
            }
            
            return FlameWindowManager.getSingleton().createWindow(d_tabButtonType, name) as FlameTabButton;
        }
        

    }
}