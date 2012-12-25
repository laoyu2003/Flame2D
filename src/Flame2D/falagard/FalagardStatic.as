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
    import Flame2D.core.system.FlameWindowRenderer;
    import Flame2D.core.falagard.FalagardStateImagery;
    import Flame2D.core.falagard.FalagardWidgetLookFeel;

    /*!
    \brief
    Static class for the FalagardBase module.
    
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
    */
    public class FalagardStatic extends FlameWindowRenderer
    {
        
        public static const TypeName:String = "Falagard/Static";
        
        // static properties
        protected static var d_frameEnabledProperty:FalagardStaticPropertyFrameEnabled = new FalagardStaticPropertyFrameEnabled();
        protected static var d_backgroundEnabledProperty:FalagardStaticPropertyBackgroundEnabled = new FalagardStaticPropertyBackgroundEnabled();
        
        // implementation data
        protected var d_frameEnabled:Boolean = false;        //!< True when the frame is enabled.
        protected var d_backgroundEnabled:Boolean = false;   //!< true when the background is enabled.
        
        
        public function FalagardStatic(type:String)
        {
            super(type);
            
            registerProperty(d_frameEnabledProperty);
            registerProperty(d_backgroundEnabledProperty);
        }
        
        override public function render():void
        {
            // get WidgetLookFeel for the assigned look.
            const wlf:FalagardWidgetLookFeel = getLookNFeel();
            
            var is_enabled:Boolean = !d_window.isDisabled();
            
            // render frame section
            if (d_frameEnabled)
            {
                wlf.getStateImagery(is_enabled ? "EnabledFrame" : "DisabledFrame").render(d_window);
            }
            
            // render background section
            if (d_backgroundEnabled)
            {
                var imagery:FalagardStateImagery;
                if (d_frameEnabled)
                {
                    imagery = wlf.getStateImagery(is_enabled ? "WithFrameEnabledBackground" : "WithFrameDisabledBackground");
                }
                else
                {
                    imagery = wlf.getStateImagery(is_enabled ? "NoFrameEnabledBackground" : "NoFrameDisabledBackground");
                }
                // peform the rendering operation.
                imagery.render(d_window);
            }
            
            // render basic imagery
            wlf.getStateImagery(is_enabled ? "Enabled" : "Disabled").render(d_window);
        }
        
        
        
        /*!
        \brief
        Return whether the frame for this static widget is enabled or disabled.
        
        \return
        true if the frame is enabled and will be rendered.  false is the frame is disabled and will not be rendered.
        */
        public function isFrameEnabled():Boolean
        {
            return d_frameEnabled;
        }
        
        /*!
        \brief
        Return whether the background for this static widget is enabled to disabled.
        
        \return
        true if the background is enabled and will be rendered.  false if the background is disabled and will not be rendered.
        */
        public function isBackgroundEnabled():Boolean
        {
            return d_backgroundEnabled;
        }
        
        /*!
        \brief
        Enable or disable rendering of the frame for this static widget.
        
        \param setting
        true to enable rendering of a frame.  false to disable rendering of a frame.
        */
        public function setFrameEnabled(setting:Boolean):void
        {
            if (d_frameEnabled != setting)
            {
                d_frameEnabled = setting;
                d_window.invalidate();
            }
        }
        
        /*!
        \brief
        Enable or disable rendering of the background for this static widget.
        
        \param setting
        true to enable rendering of the background.  false to disable rendering of the background.
        */
        public function setBackgroundEnabled(setting:Boolean):void
        {
            if (d_backgroundEnabled != setting)
            {
                d_backgroundEnabled = setting;
                d_window.invalidate();
            }
        }
        


    }
}