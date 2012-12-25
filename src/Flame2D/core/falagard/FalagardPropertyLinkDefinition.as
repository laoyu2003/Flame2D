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
package Flame2D.core.falagard
{
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.data.LinkTarget;

    public class FalagardPropertyLinkDefinition extends FalagardPropertyDefinitionBase
    {

        private static const S_parentIdentifier:String = "__parent__";
        
        //! type used for the collection of targets.
        //typedef std::vector<LinkTarget> LinkTargetCollection;
        
        //! collection of targets for this PropertyLinkDefinition.
        //LinkTargetCollection d_targets;
        
        protected var d_targets:Vector.<LinkTarget> = new Vector.<LinkTarget>();
        
        
        public function FalagardPropertyLinkDefinition(propertyName:String, widgetNameSuffix:String, targetProperty:String, 
                                               initialValue:String, redrawOnWrite:Boolean, layoutOnWrite:Boolean)
        {
            super(propertyName, 
                "Falagard property link definition - links a " +
                "property on this window to properties " +
                "defined on one or more child windows, or " +
                 "the parent window.",
                initialValue, redrawOnWrite, layoutOnWrite);
            
            // add initial target if it was specified via constructor
            // (typically meaning it came via XML attributes)
            if (widgetNameSuffix.length != 0 || targetProperty.length != 0)
            {
                addLinkTarget(widgetNameSuffix, targetProperty);
            }
        }
        
        
        //! add a new link target to \a property on \a widget (name suffix).
        public function addLinkTarget(widget:String, property:String):void
        {
            var t:LinkTarget = new LinkTarget(widget, property);
            d_targets.push(t);
        }
        
        
        
        //! clear all link targets from this link definition.
        public function clearLinkTargets():void
        {
            d_targets.length = 0;
        }
        
        // override members from PropertyDefinitionBase
        override public function getValue(receiver:*) :String
        {
            const target_wnd:FlameWindow = getTargetWindowWithSuffix(receiver, d_targets[0].d_widgetNameSuffix);
            
            // if no target, or target (currently) invalid, return the default value
            if (d_targets.length == 0 || !target_wnd)
                return d_default;
            
            // otherwise return the value of the property for first target, since
            // this is considered the 'master' target for get operations.
            return target_wnd.getProperty(d_targets[0].d_targetProperty.length == 0 ?
                d_name : d_targets[0].d_targetProperty);
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            updateLinkTargets(receiver, value);
            
            // base handles things like ensuring redraws and such happen
            super.setValue(receiver, value);
        }
        
        
        // overrides
        override public function initialisePropertyReceiver(receiver:*):void
        {
            updateLinkTargets(receiver, d_default);
        }
        
        //void writeXMLElementType(XMLSerializer& xml_stream) const;
        //void writeXMLAttributes(XMLSerializer& xml_stream) const;
        
        /*!
        \brief
        return a pointer to the window containing the target property to
        be accessed.
        
        \exception UnknownObjectException
        thrown if no such target window exists within the system.
        
        \deprecated
        This will be removed in 0.8.x.  Use the version taking a suffix
        string instead!
        */
        protected function getTargetWindow(receiver:*):FlameWindow
        {
            if (d_targets.length == 0)
                return receiver as FlameWindow;
            
            return getTargetWindowWithSuffix(receiver, d_targets[0].d_widgetNameSuffix);
        }
        
        
        //! Return a pointer to the target window with the given suffix.
        protected function getTargetWindowWithSuffix(receiver:*, name_suffix:String):FlameWindow
        {
            if (name_suffix.length == 0)
                return receiver as FlameWindow;
            
            // handle link back to parent.  Return receiver if no parent.
            if (name_suffix == S_parentIdentifier)
                return (receiver as FlameWindow).getParent();
            
            return FlameWindowManager.getSingleton().getWindow(
                (receiver as FlameWindow).getName() + name_suffix);
        }
        
        
        //! Updates all linked properties to the given value.
        protected function updateLinkTargets(receiver:*, value:String):void
        {
            for(var i:uint=0; i< d_targets.length; i++)
            {
                var target_wnd:FlameWindow = getTargetWindowWithSuffix(receiver,
                    d_targets[i].d_widgetNameSuffix);
                
                // only try to set property if target is currently valid.
                if (target_wnd)
                    target_wnd.setProperty(d_targets[i].d_targetProperty.length == 0 ?
                        d_name : d_targets[i].d_targetProperty, value);
            }
        }


    }
}