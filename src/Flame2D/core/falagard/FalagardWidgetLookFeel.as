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
    import Flame2D.core.utils.Misc;
    
    import flash.utils.Dictionary;
    
    public class FalagardWidgetLookFeel
    {
        private var d_lookName:String;
        
//        typedef std::map<String, StateImagery, String::FastLessCompare>    StateList;
//        typedef std::map<String, ImagerySection, String::FastLessCompare>  ImageryList;
//        typedef std::map<String, NamedArea, String::FastLessCompare>       NamedAreaList;
//        typedef std::vector<WidgetComponent>      WidgetList;
//        typedef std::vector<String> AnimationList;
//        typedef std::multimap<Window*, AnimationInstance*> AnimationInstanceMap;
//        typedef std::vector<PropertyInitialiser>  PropertyList;
//        typedef std::vector<PropertyDefinition>   PropertyDefinitionList;
//        typedef std::vector<PropertyLinkDefinition> PropertyLinkDefinitionList;

        //!< Collection of ImagerySection objects.
        private var d_imagerySections:Dictionary = new Dictionary();
        //!< Collection of WidgetComponent objects.
        private var d_childWidgets:Vector.<FalagardWidgetComponent> = new Vector.<FalagardWidgetComponent>();
        //!< Collection of StateImagery objects.
        private var d_stateImagery:Dictionary = new Dictionary();
        //!< Collection of PropertyInitialser objects.
        private var d_properties:Vector.<FalagardPropertyInitialiser> = new Vector.<FalagardPropertyInitialiser>();
        //!< Collection of NamedArea objects.
        private var d_namedAreas:Dictionary = new Dictionary();
        //!< Collection of PropertyDefinition objects.
        private var d_propertyDefinitions:Vector.<FalagardPropertyDefinition> = new Vector.<FalagardPropertyDefinition>();
        //!< Collection of PropertyLinkDefinition objects.
        private var d_propertyLinkDefinitions:Vector.<FalagardPropertyLinkDefinition> = new Vector.<FalagardPropertyLinkDefinition>();
        //! Collection of animation names associated with this WidgetLookFeel.
        private var d_animations:Vector.<String> = new Vector.<String>();
        //! map of windows and their associated animation instances
        private var d_animationInstances:Dictionary = new Dictionary();

        public function FalagardWidgetLookFeel(name:String)
        {
            d_lookName = name;
        }
        
        public function parseXML(xml:XML):void
        {
            parsePropertyDefinitions(xml);
            parsePropertyLinkDefinitions(xml);
            parseProperties(xml);
            parseNamedArea(xml);
            parseChild(xml);
            parseImagerySection(xml);
            parseStateImagery(xml);
            parseAnimationDefinitions(xml);
        }
        
        private function parsePropertyDefinitions(xml:XML):void
        {
            var node:XML;
            var nodes:XMLList;
            
            nodes = xml.PropertyDefinition;
            for each(node in nodes){
                var name:String = node.@name.toString();
                var type:String = Misc.getAttributeAsString(node.@type.toString(), "Generic");
                var initialValue:String = Misc.getAttributeAsString(node.@initialValue.toString(), "");
                var redrawOnWrite:Boolean = Misc.getAttributeAsBoolean(node.@redrawOnWrite.toString(), false);
                var layoutOnWrite:Boolean = Misc.getAttributeAsBoolean(node.@layoutOnWrite.toString(), false);
                var help:String = node.@help.toString();
                var pd:FalagardPropertyDefinition = new FalagardPropertyDefinition(name, initialValue, help, redrawOnWrite, layoutOnWrite);
                
                d_propertyDefinitions.push(pd);
            }
        }

        private function parsePropertyLinkDefinitions(xml:XML):void
        {
            var node:XML;
            var nodes:XMLList;
            
            nodes = xml.PropertyLinkDefinition;
            for each(node in nodes){
                var name:String = node.@name.toString();
                var type:String = Misc.getAttributeAsString(node.@type.toString(), "Generic");
                var widget:String = Misc.getAttributeAsString(node.@widget.toString(), "");
                var targetProperty:String = Misc.getAttributeAsString(node.@targetProperty.toString(), "");
                var initialValue:String = Misc.getAttributeAsString(node.@initialValue.toString(), "");
                var redrawOnWrite:Boolean = Misc.getAttributeAsBoolean(node.@redrawOnWrite.toString(), false);
                var layoutOnWrite:Boolean = Misc.getAttributeAsBoolean(node.@layoutOnWrite.toString(), false);
                var help:String = node.@help.toString();
                var pld:FalagardPropertyLinkDefinition = new FalagardPropertyLinkDefinition(
                    name, widget, targetProperty, initialValue, redrawOnWrite, layoutOnWrite);
                
                //parse PropertyLinkTarget sub element???
                
                d_propertyLinkDefinitions.push(pld);
            }

        }
        
        private function parseProperties(xml:XML):void
        {
            var node:XML;
            var nodes:XMLList;
            
            //parse property part
            nodes = xml.Property;
            for each(node in nodes){
                var name:String = node.@name.toString();
                var value:String = node.@value.toString();
                var prop:FalagardPropertyInitialiser = new FalagardPropertyInitialiser(name, value);
                
                this.d_properties.push(prop);
            }
        }
        
        
        private function parseNamedArea(xml:XML):void
        {
            var node:XML;
            var nodes:XMLList;
            
            nodes = xml.NamedArea;
            for each(node in nodes){
                var name:String = node.@name.toString();
                var namedArea:FalagardNamedArea = new FalagardNamedArea(d_lookName, name);
                namedArea.parseXML(node);
                this.d_namedAreas[name] = namedArea;
                
                //trace("Named Area:" + name);
            }
        }
        
        private function parseImagerySection(xml:XML):void
        {
            var node:XML;
            var nodes:XMLList;
            
            nodes = xml.ImagerySection;
            for each(node in nodes){
                var name:String = node.@name.toString();
                var imagerySection:FalagardImagerySection = new FalagardImagerySection(d_lookName, name);
                imagerySection.parseXML(node);
                
                this.d_imagerySections[name] = imagerySection;
            }
        }
        
        private function parseStateImagery(xml:XML):void
        {
            var node:XML;
            var nodes:XMLList;
            
            nodes = xml.StateImagery;
            for each(node in nodes){
                var name:String = node.@name.toString();
                var clipped:Boolean = Misc.getAttributeAsBoolean(node.@clipped.toString(), true);
                var stateImagery:FalagardStateImagery = new FalagardStateImagery(d_lookName, name, clipped);
                stateImagery.parseXML(node);
                
                d_stateImagery[name] = stateImagery;
            }
        }
        
        private function parseChild(xml:XML):void
        {
            var node:XML;
            var nodes:XMLList;
            
            nodes = xml.Child;
            for each(node in nodes)
            {
                var type:String = node.@type.toString();
                var suffix:String = node.@nameSuffix.toString();
                var look:String = node.@look.toString();
                var renderer:String = node.@renderer.toString();
                
                var widget:FalagardWidgetComponent = new FalagardWidgetComponent(d_lookName, type, look, suffix, renderer);
                widget.parseXML(node);
                
                d_childWidgets.push(widget);
            }
        }
        
        private function parseAnimationDefinitions(xml:XML):void
        {
            
        }
        
        /*!
        \brief
        Return a const reference to the StateImagery object for the specified state.
        
        \return
        StateImagery object for the requested state.
        */
        public function getStateImagery(state:String):FalagardStateImagery
        {
            //StateList::const_iterator imagery = d_stateImagery.find(state);
            if(! d_stateImagery.hasOwnProperty(state))
            {
                throw new Error("WidgetLookFeel::getStateImagery - unknown state '" + state + "' in look '" + d_lookName + "'.");
            }
            
            return d_stateImagery[state];
        }
        
        /*!
        \brief
        Return a const reference to the ImagerySection object with the specified name.
        
        \return
        ImagerySection object with the specified name.
        */
        public function getImagerySection(section:String):FalagardImagerySection
        {
            //ImageryList::const_iterator imgSect = d_imagerySections.find(section);
            if(! d_imagerySections.hasOwnProperty(section))
            {
                throw new Error("WidgetLookFeel::getImagerySection - unknown imagery section '" + section +  "' in look '" + d_lookName + "'.");
            }
            
            return d_imagerySections[section];
        }
        
        /*!
        \brief
        Return the name of the widget look.
        
        \return
        String object holding the name of the WidgetLookFeel.
        */
        public function getName():String
        {
            return d_lookName;
        }
        
        /*!
        \brief
        Add an ImagerySection to the WidgetLookFeel.
        
        \param section
        ImagerySection object to be added.
       
        \return Nothing.
        */
        public function addImagerySection(section:FalagardImagerySection):void
        {
            if(d_imagerySections.hasOwnProperty(section.getName()))
            {
                trace("WidgetLookFeel::addImagerySection - Defintion for imagery section '" + section.getName() + "' already exists.  Replacing previous definition.");
            }
            
            d_imagerySections[section.getName()] = section;
        }
        
        /*!
        \brief
        Add a WidgetComponent to the WidgetLookFeel.
        
        \param widget
        WidgetComponent object to be added.
        
        \return Nothing.
        */
        public function addWidgetComponent(widget:FalagardWidgetComponent):void
        {
            d_childWidgets.push(widget);
        }
        
        /*!
        \brief
        Add a state specification (StateImagery object) to the WidgetLookFeel.
        
        \param section
        StateImagery object to be added.
        
        \return Nothing.
        */
        public function addStateSpecification(state:FalagardStateImagery):void
        {
            if(d_stateImagery.hasOwnProperty(state.getName()))
            {
                trace(
                    "WidgetLookFeel::addStateSpecification - Defintion for state '" + state.getName() + "' already exists.  Replacing previous definition.");
            }
            
            d_stateImagery[state.getName()] = state;
        }
        
        /*!
        \brief
        Add a property initialiser to the WidgetLookFeel.
        
        \param initialiser
        PropertyInitialiser object to be added.
        
        \return Nothing.
        */
        public function addPropertyInitialiser(initialiser:FalagardPropertyInitialiser):void
        {
            d_properties.push(initialiser);
        }
        
        /*!
        \brief
        Clear all ImagerySections from the WidgetLookFeel.
        
        \return
        Nothing.
        */
        public function clearImagerySections():void
        {
            d_imagerySections = new Dictionary();
        }
        
        /*!
        \brief
        Clear all WidgetComponents from the WidgetLookFeel.
        
        \return
        Nothing.
        */
        public function clearWidgetComponents():void
        {
            d_childWidgets.length = 0;
        }
        
        /*!
        \brief
        Clear all StateImagery objects from the WidgetLookFeel.
        
        \return
        Nothing.
        */
        public function clearStateSpecifications():void
        {
            d_stateImagery = new Dictionary();
        }
        
        /*!
        \brief
        Clear all PropertyInitialiser objects from the WidgetLookFeel.
        
        \return
        Nothing.
        */
        public function clearPropertyInitialisers():void
        {
            d_properties.length = 0;
        }
        
        /*!
        \brief
        Initialise the given window using PropertyInitialsers and component widgets
        specified for this WidgetLookFeel.
        
        \param widget
        Window based object to be initialised.
        
        \return
        Nothing.
        */
        public function initialiseWidget(widget:FlameWindow):void
        {
            // add new property definitions
            for(var i:uint=0; i<d_propertyDefinitions.length; i++)
            {
                // add the property to the window
                widget.addProperty(d_propertyDefinitions[i]);
            }
            
            // add required child widgets
            for(i=0; i<d_childWidgets.length; i++)
            {
                d_childWidgets[i].create(widget);
            }
            
            // add new property link definitions
            for(i=0; i<d_propertyLinkDefinitions.length; i++)
            {
                // add the property to the window
                widget.addProperty(d_propertyLinkDefinitions[i]);
            }
            
            // apply properties to the parent window
            for(i=0; i<d_properties.length; i++)
            {
                //d_properties[i].apply(widget);
                widget.setProperty(d_properties[i].d_propertyName, d_properties[i].d_propertyValue);
            }
            
            // create animation instances
//            for(i=0; i<d_animations.length; i++)
//            {
//                var instance:AnimationInstance =
//                    AnimationManager::getSingleton().instantiateAnimation(*anim);
//                
//                d_animationInstances.insert(std::make_pair(&widget, instance));
//                instance->setTargetWindow(&widget);
//            }

        }
        
        /*!
        \brief
        Clean up the given window from all properties and component widgets created by this WidgetLookFeel
        
        \param widget
        Window based object to be cleaned up.
        
        \return
        Nothing.
        */
        public function cleanUpWidget(widget:FlameWindow):void
        {
            if (widget.getLookNFeel() != getName())
            {
                throw new Error(
                    "WidgetLookFeel::cleanUpWidget - The window '"
                    + widget.getName() +
                    "' does not have this look'n'feel assigned");
            }
            
            // remove added child widgets
            for(var i:uint=0; i<d_childWidgets.length; i++)
            {
                FlameWindowManager.getSingleton().destroyWindowByName(widget.getName() + d_childWidgets[i].getWidgetNameSuffix());
            }
            
            // remove added property definitions
            for(i=0; i<d_propertyDefinitions.length; i++)
            {
                // remove the property from the window
                widget.removeProperty(d_propertyDefinitions[i].getName());
            }
            
            // remove added property link definitions
            for(i=0; i<d_propertyLinkDefinitions.length; i++)
            {
                // remove the property from the window
                widget.removeProperty(d_propertyLinkDefinitions[i].getName());
            }
            
            // clean up animation instances assoicated wit the window.
//            AnimationInstanceMap::iterator anim;
//            while ((anim = d_animationInstances.find(&widget)) != d_animationInstances.end())
//            {
//                AnimationManager::getSingleton().destroyAnimationInstance(anim->second);
//                d_animationInstances.erase(anim);
//            }
        }
        
        /*!
        \brief
        Return whether imagery is defined for the given state.
        
        \param state
        String object containing name of state to look for.
        
        \return
        - true if imagery exists for the specified state,
        - false if no imagery exists for the specified state.
        */
        public function isStateImageryPresent(state:String):Boolean
        {
            return d_stateImagery.hasOwnProperty(state);
        }
        /*!
        \brief
        Adds a named area to the WidgetLookFeel.
        
        \param area
        NamedArea to be added.
        
        \return
        Nothing.
        */
        public function addNamedArea(area:FalagardNamedArea):void
        {
            if(d_namedAreas.hasOwnProperty(area.getName()))
            {
                trace("WidgetLookFeel::addNamedArea - Defintion for area '" + area.getName() + "' already exists.  Replacing previous definition.");
            }
            
            d_namedAreas[area.getName()] = area;   
        }
        
        /*!
        \brief
        Clear all defined named areas from the WidgetLookFeel
        
        \return
        Nothing.
        */
        public function clearNamedAreas():void
        {
            d_namedAreas = new Dictionary();
        }
        
        /*!
        \brief
        Return the NamedArea with the specified name.
        
        \param name
        String object holding the name of the NamedArea to be returned.
        
        \return
        The requested NamedArea object.
        */
        public function getNamedArea(name:String):FalagardNamedArea
        {
            if(! d_namedAreas.hasOwnProperty(name))
            {
                throw new Error("WidgetLookFeel::getNamedArea - unknown named area: '" + name +  "' in look '" + d_lookName + "'.");
            }
            
            return d_namedAreas[name];
        }
        
        /*!
        \brief
        return whether a NamedArea object with the specified name exists for this WidgetLookFeel.
        
        \param name
        String holding the name of the NamedArea to check for.
        
        \return
        - true if a named area with the requested name is defined for this WidgetLookFeel.
        - false if no such named area is defined for this WidgetLookFeel.
        */
        public function isNamedAreaDefined(name:String):Boolean
        {
            return d_namedAreas.hasOwnProperty(name);
        }
        
        /*!
        \brief
        Layout the child widgets defined for this WidgetLookFeel which are attached to the given window.
        
        \param owner
        Window object that has the child widgets that require laying out.
        
        \return
        Nothing.
        */
        public function layoutChildWidgets(owner:FlameWindow):void
        {
            // apply properties to the parent window
            for(var i:uint=0; i<d_childWidgets.length; i++)
            {
                d_childWidgets[i].layout(owner);
            }
        }
        
        /*!
        \brief
        Adds a property definition to the WidgetLookFeel.
        
        \param propdef
        PropertyDefinition object to be added.
        
        \return
        Nothing.
        */
        public function addPropertyDefinition(propdef:FalagardPropertyDefinition):void
        {
            d_propertyDefinitions.push(propdef);
        }
        
        /*!
        \brief
        Adds a property link definition to the WidgetLookFeel.
        
        \param propdef
        PropertyLinkDefinition object to be added.
        
        \return
        Nothing.
        */
        public function addPropertyLinkDefinition(propdef:FalagardPropertyLinkDefinition):void
        {
            d_propertyLinkDefinitions.push(propdef);
        }
        
        /*!
        \brief
        Clear all defined property definitions from the WidgetLookFeel
        
        \return
        Nothing.
        */
        public function clearPropertyDefinitions():void
        {
            d_propertyDefinitions.length = 0;
        }
        
        /*!
        \brief
        Clear all defined property link definitions from the WidgetLookFeel
        
        \return
        Nothing.
        */
        public function clearPropertyLinkDefinitions():void
        {
            d_propertyLinkDefinitions.length = 0;
        }
        
        /*!
        \brief
        Add the name of an animation that is associated with the
        WidgetLookFeel.
        
        \param anim_name
        Reference to a String object that contains the name of the animation
        to be associated with this WidgetLookFeel.
        */
        //void addAnimationName(const String& anim_name);
        

        
        /*!
        \brief
        Uses the WindowManager to rename the child windows that are
        created for this WidgetLookFeel.
        
        \param widget
        The target Window containing the child windows that are to be
        renamed.
        
        \param newBaseName
        String object holding the new base name that will be used when
        constructing new names for the child windows.
        */
        public function renameChildren(widget:FlameWindow, newBaseName:String):void
        {
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            
            for(var i:uint=0; i<d_childWidgets.length; i++){
                winMgr.renameWindow(widget.getName() + d_childWidgets[i].getWidgetNameSuffix(),
                    newBaseName + d_childWidgets[i].getWidgetNameSuffix());
            }
        }
        
        /*!
        \brief
        Takes the name of a property and returns a pointer to the last
        PropertyInitialiser for this property or 0 if the is no
        PropertyInitialiser for this property in the WidgetLookFeel
        
        \param propertyName
        The name of the property to look for.
        */
        public function findPropertyInitialiser(propertyName:String):FalagardPropertyInitialiser
        {
            for(var i:int = d_properties.length-1; i>=0; i--)
            {
                if (d_properties[i].getTargetPropertyName() == propertyName)
                    return d_properties[i];
            }
            return null;
        }
        /*!
        \brief
        Takes the namesuffix for a widget component and returns a pointer to
        it if it exists or 0 if it does'nt.
        
        \param nameSuffix
        The name suffix of the Child component to look for.
        */
        public function findWidgetComponent(nameSuffix:String):FalagardWidgetComponent
        {
            for(var i:uint=0; i<d_childWidgets.length; i++)
            {
                if (d_childWidgets[i].getWidgetNameSuffix() == nameSuffix)
                    return d_childWidgets[i];
            }
            return null;
        }
        
        
        
        
        /** Obtains list of properties definitions.
         * @access public 
         * @return CEGUI::WidgetLookFeel::PropertyDefinitionList List of properties definitions
         */
        public function getPropertyDefinitions():Vector.<FalagardPropertyDefinition>
        {
            return d_propertyDefinitions;
        }
        
        /** Obtains list of properties link definitions.
         * @access public 
         * @return CEGUI::WidgetLookFeel::PropertyLinkDefinitionList List of properties link definitions
         */
        public function getPropertyLinkDefinitions():Vector.<FalagardPropertyLinkDefinition>
        {
            return d_propertyLinkDefinitions;
        } 
        
        /** Obtains list of properties.
         * @access public 
         * @return CEGUI::WidgetLookFeel::PropertyList List of properties
         */
        public function getProperties():Vector.<FalagardPropertyInitialiser>
        {
            return d_properties;
        } 
        
        
        
     }
}