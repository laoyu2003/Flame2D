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
    import Flame2D.core.utils.Colour;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Rect;

    /*!
    \brief
    Common base class used for renderable components within an ImagerySection.
    */
    public class FalagardComponentBase
    {
        // data fields
        protected var d_area:FalagardComponentArea;                 //!< Destination area for this component.
        protected var d_colours:ColourRect;              //!< base colours to be applied when rendering the image component.
        protected var d_colourPropertyName:String = "";   //!< name of property to fetch colours from.
        protected var d_colourProperyIsRect:Boolean;  //!< true if the colour property will fetch a full ColourRect.
        protected var d_vertFormatPropertyName:String = "";   //!< name of property to fetch vertical formatting setting from.
        protected var d_horzFormatPropertyName:String = "";   //!< name of property to fetch horizontal formatting setting from.

        
        public function FalagardComponentBase()
        {
            this.d_colours = new ColourRect();
            this.d_colourProperyIsRect = false;
        }
        
        
        
        /*!
        \brief
        Render this component.  More correctly, the component is cached for rendering.
        
        \param srcWindow
        Window to use as the base for translating the component's ComponentArea into pixel values.
        
        \param modColours
        ColourRect describing colours that are to be modulated with the component's stored colour values
        to calculate a set of 'final' colour values to be used.  May be 0.
        
        \return
        Nothing.
        */
        public function render(srcWindow:FlameWindow, modColours:ColourRect = null, 
            clipper:Rect = null, clipToDisplay:Boolean = false):void
        {
            throw new Error("must be realized");

        }
        
        /*!
        \brief
        Render this component.  More correctly, the component is cached for rendering.
        
        \param srcWindow
        Window to use as the base for translating the component's ComponentArea into pixel values.
        
        \param baseRect
        Rect to use as the base for translating the component's ComponentArea into pixel values.
        
        \param modColours
        ColourRect describing colours that are to be modulated with the component's stored colour values
        to calculate a set of 'final' colour values to be used.  May be 0.
        
        \return
        Nothing.
        */
        public function render2(srcWindow:FlameWindow, baseRect:Rect, 
                                modColours:ColourRect = null, clipper:Rect = null, clipToDisplay:Boolean = false):void
        {
            throw new Error("must be realized");

        }
        
        /*!
        \brief
        Return the ComponentArea of this ImageryComponent.
        
        \return
        ComponentArea object describing the ImageryComponent's current target area.
        */
        public function getComponentArea(): FalagardComponentArea
        {
            return d_area;
        }
        
        /*!
        \brief
        Set the ImageryComponent's ComponentArea.
        
        \param area
        ComponentArea object describing a new target area for the ImageryComponent.
        
        \return
        Nothing.
        */
        public function setComponentArea(area:FalagardComponentArea):void
        {
            d_area = area;
        }
        
        /*!
        \brief
        Return the ColourRect set for use by this ImageryComponent.
        
        \return
        ColourRect object holding the colours currently in use by this ImageryComponent.
        */
        public function getColours():ColourRect
        {
            return d_colours;
        }
        
        /*!
        \brief
        Set the colours to be used by this ImageryComponent.
        
        \param cols
        ColourRect object describing the colours to be used by this ImageryComponent.
        */
        public function setColours(cols:ColourRect):void
        {
            d_colours = cols;
        }
        
        /*!
        \brief
        Set the name of the property where colour values can be obtained.
        
        \param property
        String containing the name of the property.
        
        \return
        Nothing.
        */
        public function setColoursPropertySource(property:String):void
        {
            d_colourPropertyName = property;
        }
        
        /*!
        \brief
        Set whether the colours property source represents a full ColourRect.
        
        \param setting
        - true if the colours property will access a ColourRect object.
        - false if the colours property will access a colour object.
        
        \return
        Nothing.
        */
        public function setColoursPropertyIsColourRect(setting:Boolean = true):void
        {
            d_colourProperyIsRect = setting;
        }
        
        /*!
        \brief
        Set the name of the property where vertical formatting option can be obtained.
        
        \param property
        String containing the name of the property.
        
        \return
        Nothing.
        */
        public function setVertFormattingPropertySource(property:String):void
        {
            d_vertFormatPropertyName = property;
        }
        
        /*!
        \brief
        Set the name of the property where horizontal formatting option can be obtained.
        
        \param property
        String containing the name of the property.
        
        \return
        Nothing.
        */
        public function setHorzFormattingPropertySource(property:String):void
        {
            d_horzFormatPropertyName = property;
        }
        
        /*!
        \brief
        Helper method to initialise a ColourRect with appropriate values according to the way the
        ImageryComponent is set up.
        
        This will try and get values from multiple places:
        - a property attached to \a wnd
        - or the integral d_colours value.
        */
        protected function initColoursRect(wnd:FlameWindow, modCols:ColourRect):ColourRect
        {
            var cr:ColourRect = new ColourRect();
            
            // if colours come via a colour property
            if (d_colourPropertyName.length != 0)
            {
                // if property accesses a ColourRect
                if (d_colourProperyIsRect)
                {
                    cr = FlamePropertyHelper.stringToColourRect(wnd.getProperty(d_colourPropertyName));
                }
                    // property accesses a colour
                else
                {
                    var val:Colour = FlamePropertyHelper.stringToColour(wnd.getProperty(d_colourPropertyName));
                    cr.d_top_left     = val;
                    cr.d_top_right    = val;
                    cr.d_bottom_left  = val;
                    cr.d_bottom_right = val;
                }
            }
                // use explicit ColourRect.
            else
            {
                cr = d_colours;
            }
            
            if (modCols)
            {
                cr = cr.multiplyColourRect(modCols);
            }
            
            return cr;
        }
        
        /*!
        \brief
        Method to do main render caching work.
        */
//        protected function render_impl(WsrcWindow:FlameWindow, destRect:Rect, 
//                                       modColours:ColourRect, clipper:Rect, clipToDisplay:Boolean):void
//        {
//            
//        }
        
        protected function render_impl(srcWindow:FlameWindow, destRect:Rect, modColours:ColourRect, 
                                              clipper:Rect, clipToDisplay:Boolean):void
        {
            throw new Error("must be realized");
        }
        
        /*!
        \brief
        Writes xml for the colours to a OutStream.  Will prefer property colours before explicit.
        
        \note
        This is intended as a helper method for sub-classes when outputting xml to a stream.
        
        
        \return
        - true if xml element was written.
        - false if nothing was output due to the formatting not being set (sub-class may then choose to do something else.)
        */
        //bool writeColoursXML(XMLSerializer& xml_stream) const;
        
        /*!
        \brief
        Writes xml for the vertical formatting to a OutStream if such a property is defined.
        
        \note
        This is intended as a helper method for sub-classes when outputting xml to a stream.
        
        
        \return
        - true if xml element was written.
        - false if nothing was output due to the formatting not being set (sub-class may then choose to do something else.)
        */
        //bool writeVertFormatXML(XMLSerializer& xml_stream) const;
        
        /*!
        \brief
        Writes xml for the horizontal formatting to a OutStream if such a property is defined.
        
        \note
        This is intended as a helper method for sub-classes when outputting xml to a stream.
        
        
        \return
        - true if xml element was written.
        - false if nothing was output due to the formatting not being set (sub-class may then choose to do something else.)
        */
        //bool writeHorzFormatXML(XMLSerializer& xml_stream) const;

        
        

    }
}