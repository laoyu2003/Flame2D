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
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.Colour;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    
    /*!
    \brief
    Class that represents a simple 'link' to an ImagerySection.
    
    This class enables sections to be easily re-used, by different states and/or layers, by allowing
    sections to be specified by name rather than having mutiple copies of the same thing all over the place.
    */
    
    public class FalagardSectionSpecification
    {
        
        private static const S_parentIdentifier:String = "__parent__";

        
        private var d_owner:String;                //!< Name of the WidgetLookFeel containing the required section.
        private var d_sectionName:String = "";          //!< Name of the required section within the specified WidgetLookFeel.
        private var d_coloursOverride:ColourRect = null;      //!< Colours to use when override is enabled.
        private var d_usingColourOverride:Boolean = false;  //!< true if colour override is enabled.
        private var d_colourPropertyName:String = "";   //!< name of property to fetch colours from.
        private var d_colourProperyIsRect:Boolean = false;  //!< true if the colour property will fetch a full ColourRect.
        //! Name of a property to control whether to draw this section.
        private var d_renderControlProperty:String = "";
        //! Comparison value to test against d_renderControlProperty.
        private var d_renderControlValue:String = "";
        //! Widget upon which d_renderControlProperty is to be accessed.
        private var d_renderControlWidget:String = "";

        /*!
        \brief
        Constructor
        
        \param owner
        String holding the name of the WidgetLookFeel object that contains the target section.
        
        \param sectionName
        String holding the name of the target section.
        
        \param controlPropertySource
        String holding the name of a property that will control whether
        rendering for this secion will actually occur or not.
        
        \param controlPropertyValue
        String holding the value to be tested for from the property named in
        controlPropertySource.  If this is empty, then controlPropertySource
        will be accessed as a boolean property, otherwise rendering will
        only occur when the value returned via controlPropertySource matches
        the value specified here.
        
        \param controlPropertyWidget
        String holding either a widget name suffix or the special value of
        '__parent__' indicating the window upon which the property named
        in controlPropertySource should be accessed.  If this is empty then
        the window itself is used as the source, rather than a child or the
        parent.
        */
        public function FalagardSectionSpecification(owner:String, sectionName:String,
                        controlPropertySource:String,
                        controlPropertyValue:String,
                        controlPropertyWidget:String,
                        colourRect:ColourRect = null)
        {
            d_owner = owner;
            d_sectionName = sectionName;
            d_renderControlProperty = controlPropertySource;
            d_renderControlValue = controlPropertyValue;
            d_renderControlWidget = controlPropertyWidget;
            if(colourRect)
            {
                d_colourProperyIsRect = true;
            }
            d_coloursOverride = colourRect;
        }

        
        public function parseXML(xml:XML):void
        {
            //parse colours
            var node:XML;
            
            
            //<Colour colour="#FFFFFF"/>
            node = xml.Colour[0];
            if(node)
            {
                var colour:uint = Misc.getAttributeHexAsUint(node.@colour.toString());
                var cols:ColourRect = new ColourRect(
                    Colour.getColour(colour),
                    Colour.getColour(colour),
                    Colour.getColour(colour),
                    Colour.getColour(colour));
                setOverrideColours(cols);
                setUsingOverrideColours(true);
            }
            
            //Colours
            //<Colours topLeft="FFA7C7FF" topRight="FFA7C7FF" bottomLeft="FFA7C7FF" bottomRight="FFA7C7FF" />
            node = xml.Colours[0];
            if(node)
            {
                var topLeft:uint = Misc.getAttributeHexAsUint(node.@topLeft.toString());
                var topRight:uint = Misc.getAttributeHexAsUint(node.@topRight.toString());
                var bottomLeft:uint = Misc.getAttributeHexAsUint(node.@bottomLeft.toString());
                var bottomRight:uint = Misc.getAttributeHexAsUint(node.@bottomRight.toString());
                cols = new ColourRect(
                    Colour.getColour(topLeft),
                    Colour.getColour(topRight),
                    Colour.getColour(bottomLeft),
                    Colour.getColour(bottomRight));
                setOverrideColours(cols);
                setUsingOverrideColours(true);
            }
 
            
            //ColourProperty
            node = xml.ColourProperty[0];
            if(node)
            {
                var cname:String = node.@name.toString();
                setOverrideColoursPropertySource(cname);
                setOverrideColoursPropertyIsColourRect(false);
                setUsingOverrideColours(true);
            }
            
            //ColourRectProperty
            node = xml.ColourRectProperty[0];
            if(node)
            {
                var name:String = node.@name.toString();
                setOverrideColoursPropertySource(name);
                setOverrideColoursPropertyIsColourRect(true);
                setUsingOverrideColours(true);
            }
            
        }
        
        /*!
        \brief
        Render the section specified by this SectionSpecification.
        
        \param srcWindow
        Window object to be used when calculating pixel values from BaseDim values.
        
        \return
        Nothing.
        */
        public function render(srcWindow:FlameWindow, modcols:ColourRect = null, 
                               clipper:Rect = null, clipToDisplay:Boolean = false):void
        {
            // see if we need to bother rendering
            if (!shouldBeDrawn(srcWindow))
                return;
            
//            try
//            {
                
                // get the imagery section object with the name we're set up to use
                const sect:FalagardImagerySection =
                    FalagardWidgetLookManager.getSingleton().getWidgetLook(d_owner).getImagerySection(d_sectionName);
                
                // decide what colours are to be used
                var finalColours:ColourRect = initColourRectForOverride(srcWindow);
                finalColours.modulateAlpha(srcWindow.getEffectiveAlpha());
                
                if (modcols)
                    finalColours = finalColours.multiplyColourRect(modcols);
                
                // render the imagery section
                sect.render(srcWindow, finalColours, clipper, clipToDisplay);
//            }
//            // do nothing here, errors are non-faltal and are logged for debugging purposes.
//            catch (error:Error)
//            {
//                throw new Error("Unknow error.");
//            }
        }
        
        /*!
        \brief
        Render the section specified by this SectionSpecification.
        
        \param srcWindow
        Window object to be used when calculating pixel values from BaseDim values.
        
        \param baseRect
        Rect object to be used when calculating pixel values from BaseDim values.
        
        \return
        Nothing.
        */
        public function render2(srcWindow:FlameWindow, baseRect:Rect, modcols:ColourRect = null, 
                                clipper:Rect = null, clipToDisplay:Boolean = false):void
        {
            // see if we need to bother rendering
            if (!shouldBeDrawn(srcWindow))
                return;
            
            try
            {
                // get the imagery section object with the name we're set up to use
                const sect:FalagardImagerySection =
                    FalagardWidgetLookManager.getSingleton().getWidgetLook(d_owner).getImagerySection(d_sectionName);
                
                // decide what colours are to be used
                var finalColours:ColourRect = initColourRectForOverride(srcWindow);
                finalColours.modulateAlpha(srcWindow.getEffectiveAlpha());
                
                if (modcols)
                    finalColours = finalColours.multiplyColourRect(modcols);
                
                // render the imagery section
                sect.render2(srcWindow, baseRect, finalColours, clipper, clipToDisplay);
            }
            // do nothing here, errors are non-faltal and are logged for debugging purposes.
            catch (error:Error)
            {}
        }
        
        /*!
        \brief
        Return the name of the WidgetLookFeel object containing the target section.
        
        \return
        String object holding the name of the WidgetLookFeel that contains the target ImagerySection.
        */
        public function getOwnerWidgetLookFeel():String
        {
            return d_owner;
        }
        
        /*!
        \brief
        Return the name of the target ImagerySection.
        
        \return
        String object holding the name of the target ImagerySection.
        */
        public function getSectionName():String
        {
            return d_sectionName;
        }
        
        /*!
        \brief
        Return the current override colours.
        
        \return
        ColourRect holding the colours that will be modulated with the sections master colours if
        colour override is enabled on this SectionSpecification.
        */
        public function getOverrideColours():ColourRect
        {
            return d_coloursOverride;
        }
        
        /*!
        \brief
        Set the override colours to be used by this SectionSpecification.
        
        \param cols
        ColourRect describing the override colours to set for this SectionSpecification.
        
        \return
        Nothing.
        */
        public function setOverrideColours(cols:ColourRect):void
        {
            d_coloursOverride = cols;
        }
        
        /*!
        \brief
        return whether the use of override colours is enabled on this SectionSpecification.
        
        \return
        - true if override colours will be used for this SectionSpecification.
        - false if override colours will not be used for this SectionSpecification.
        */
        public function isUsingOverrideColours():Boolean
        {
            return d_usingColourOverride;
        }
        
        /*!
        \brief
        Enable or disable the use of override colours for this section.
        
        \param setting
        - true if override colours should be used for this SectionSpecification.
        - false if override colours should not be used for this SectionSpecification.
        
        \return
        Nothing.
        */
        public function setUsingOverrideColours(setting:Boolean = true):void
        {
            d_usingColourOverride = setting;
        }
        
        /*!
        \brief
        Set the name of the property where override colour values can be obtained.
        
        \param property
        String containing the name of the property.
        
        \return
        Nothing.
        */
        public function setOverrideColoursPropertySource(property:String):void
        {
            d_colourPropertyName = property;
        }
        
        /*!
        \brief
        Set whether the override colours property source represents a full ColourRect.
        
        \param setting
        - true if the override colours property will access a ColourRect object.
        - false if the override colours property will access a colour object.
        
        \return
        Nothing.
        */
        public function setOverrideColoursPropertyIsColourRect(setting:Boolean = true):void
        {
            d_colourProperyIsRect = setting;
        }
        

        
        
        /*!
        \brief
        Set the name of the property that controls whether to actually
        render this section.
        
        \param property
        String containing the name of the property.
        
        \return
        Nothing.
        */
        public function setRenderControlPropertySource(property:String):void
        {
            d_renderControlProperty = property;
        }
        
        /*!
        \brief
        Set the test value used when determining whether to render this
        section.
        
        The value set here will be compared to the current value of the
        property named as the render control property, if they match the
        secion will be drawn, otherwise the section will not be drawn.  If
        this value is set to the empty string, the control property will
        instead be treated as a boolean property.
        */
        public function setRenderControlValue(value:String):void
        {
            d_renderControlValue = value;
        }
        
        /*!
        \brief
        Set the widget what will be used as the source of the property
        named as the control property.
        
        The value of this setting will be interpreted as follows:
        - empty string: The target widget being drawn will be the source of
        the property value.
        - '__parent__': The parent of the widget being drawn will be the
        source of the property value.
        - any other value: The value will be taken as a name suffix and
        a window with the name of the widget being drawn with the
        specified suffix will be the source of the property value.
        */
        public function setRenderControlWidget(widget:String):void
        {
            d_renderControlWidget = widget;
        }
        
        /*!
        \brief
        Writes an xml representation of this SectionSpecification to \a out_stream.
        
        \param xml_stream
        Stream where xml data should be output.
        
        
        \return
        Nothing.
        */
        //void writeXMLToStream(XMLSerializer& xml_stream) const;
        
        /*!
        \brief
        Helper method to initialise a ColourRect with appropriate values according to the way the
        section sepcification is set up.
        
        This will try and get values from multiple places:
        - a property attached to \a wnd
        - the integral d_coloursOverride values.
        - or default to colour(1,1,1,1);
        */
        protected function initColourRectForOverride(wnd:FlameWindow):ColourRect
        {
            var cr:ColourRect = new ColourRect();
            
            // if no override set
            if (!d_usingColourOverride)
            {
                var val:Colour = new Colour();
                cr.d_top_left     = val;
                cr.d_top_right    = val;
                cr.d_bottom_left  = val;
                cr.d_bottom_right = val;
            }
                // if override comes via a colour property
            else if (d_colourPropertyName.length != 0)
            {
                // if property accesses a ColourRect
                if (d_colourProperyIsRect)
                {
                    cr = FlamePropertyHelper.stringToColourRect(wnd.getProperty(d_colourPropertyName));
                }
                    // property accesses a colour
                else
                {
                    if(wnd.isPropertyPresent(d_colourPropertyName))
                    {
                        val = FlamePropertyHelper.stringToColour(wnd.getProperty(d_colourPropertyName));
                    }
                    else
                    {
                        trace("there must be some error in property set");
                        val = new Colour();
                    }
                    cr.d_top_left     = val.clone();
                    cr.d_top_right    = val.clone();
                    cr.d_bottom_left  = val.clone();
                    cr.d_bottom_right = val.clone();
                }
            }
                // override is an explicitly defined ColourRect.
            else
            {
                cr = d_coloursOverride;
            }
            
            return cr;
        }
        
        /** return whether the section should be drawn, based upon the
         * render control property and associated items.
         */
        protected function shouldBeDrawn(wnd:FlameWindow):Boolean
        {
            // test the simple case first.
            if (d_renderControlProperty.length == 0)
                return true;
            
            var property_source:FlameWindow;
            
            // work out which window the property should be accessed for.
            if (d_renderControlWidget.length == 0)
                property_source = wnd;
            else if (d_renderControlWidget == S_parentIdentifier)
                property_source = wnd.getParent();
            else
                property_source = FlameWindowManager.getSingleton().getWindow(
                    wnd.getName() + d_renderControlWidget);
            
            // if no source window, we can't access the property, so never draw
            if (!property_source)
                return false;
            
            // return whether to draw based on property value.
            if (d_renderControlValue.length == 0)
                return FlamePropertyHelper.stringToBool(
                    property_source.getProperty(d_renderControlProperty));
            else
                return property_source.
                    getProperty(d_renderControlProperty) == d_renderControlValue;
        }
    }
}