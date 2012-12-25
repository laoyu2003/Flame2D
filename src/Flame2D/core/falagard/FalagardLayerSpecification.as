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
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Rect;

    /*!
    \brief
    Class that encapsulates a single layer of imagery.
    */
    public class FalagardLayerSpecification
    {
        private var d_lookName:String = "";
        //typedef std::vector<SectionSpecification> SectionList;
        
        private var d_sections:Vector.<FalagardSectionSpecification> = new Vector.<FalagardSectionSpecification>();       //!< Collection of SectionSpecification objects descibing the sections to be drawn for this layer.
        private var d_layerPriority:uint;    //!< Priority of the layer.

        /*!
        \brief
        Constructor.
        
        \param priority
        Specifies the priority of the layer.  Layers with higher priorities will be drawn on top
        of layers with lower priorities.
        */
        public function FalagardLayerSpecification(look:String, priority:uint)
        {
            d_lookName = look;
            d_layerPriority = priority;            
        }
        
        public function parseXML(xml:XML):void
        {
            var node:XML;
            var nodes:XMLList = xml.Section;
            
            for each(node in nodes)
            {
                parseSection(node);
            }
           
        }
        

        private function parseSection(xml:XML):void
        {
            //colours
            
            //look
            var look:String = xml.@look.toString();

            //section
            var section:String = xml.@section.toString();
            
            //controlProperty
            var controlProperty:String = xml.@controlProperty.toString();
            
            //controlValue
            var controlValue:String = xml.@controlValue.toString();
            
            //controlWidget
            var controlWidget:String = xml.@controlWidget.toString();

            var owner:String = (look.length == 0) ?  d_lookName : look;
            var ss:FalagardSectionSpecification = new FalagardSectionSpecification(owner, section, controlProperty, controlValue, controlWidget);
            
            ss.parseXML(xml);

            d_sections.push(ss);
        }

        
        /*!
        \brief
        Render this layer.
        
        \param srcWindow
        Window to use when calculating pixel values from BaseDim values.
        
        \return
        Nothing.
        */
        public function render(srcWindow:FlameWindow, modcols:ColourRect = null, 
                               clipper:Rect = null, clipToDisplay:Boolean = false):void
        {
            for(var i:uint=0; i< d_sections.length; i++)
            {
                d_sections[i].render(srcWindow, modcols, clipper, clipToDisplay);
            }
        }
        
        /*!
        \brief
        Render this layer.
        
        \param srcWindow
        Window to use when calculating pixel values from BaseDim values.
        
        \param baseRect
        Rect to use when calculating pixel values from BaseDim values.
        
        \return
        Nothing.
        */
        public function render2(srcWindow:FlameWindow, baseRect:Rect, 
                                modcols:ColourRect = null, clipper:Rect = null, clipToDisplay:Boolean = false):void
        {
            // render all sections in this layer
            for(var i:uint=0; i< d_sections.length; i++)
            {
                d_sections[i].render2(srcWindow, baseRect, modcols, clipper, clipToDisplay);
            }
        }
        
        /*!
        \brief
        Add a section specification to the layer.
        
        A section specification is a reference to a named ImagerySection within the WidgetLook.
        
        \param section
        SectionSpecification object descibing the section that should be added to this layer.
        
        \return
        Nothing,
        */
        public function addSectionSpecification(section:FalagardSectionSpecification):void
        {
            d_sections.push(section);
        }
        
        /*!
        \brief
        Clear all section specifications from this layer,
        
        \return
        Nothing.
        */
        public function clearSectionSpecifications():void
        {
            d_sections.length = 0;
        }
        
        /*!
        \brief
        Return the priority of this layer.
        
        \return
        uint value descibing the priority of this LayerSpecification.
        */
        public function getLayerPriority():uint
        {
            return d_layerPriority;
        }
        
        // required to sort layers according to priority
        ///bool operator<(const LayerSpecification& other) const;
        
        /*!
        \brief
        Writes an xml representation of this Layer to \a out_stream.
        
        \param xml_stream
        Stream where xml data should be output.
        
        
        \return
        Nothing.
        */
        //void writeXMLToStream(XMLSerializer& xml_stream) const;
    }
}