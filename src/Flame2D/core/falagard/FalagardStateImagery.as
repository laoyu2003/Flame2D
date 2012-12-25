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
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;

    /*!
    \brief
    Class the encapsulates imagery for a given widget state.
    */
    public class FalagardStateImagery
    {
        private var d_lookName:String = "";
        //typedef std::multiset<LayerSpecification> LayersList;
        
        private var d_stateName:String;    //!< Name of this state.
        private var d_layers:Vector.<FalagardLayerSpecification> = new Vector.<FalagardLayerSpecification>();//!< Collection of LayerSpecification objects to be drawn for this state.
        private var d_clipToDisplay:Boolean; //!< true if Imagery for this state should be clipped to the display instead of winodw (effectively, not clipped).
        
        /*!
        \brief
        Constructor
        
        \param name
        Name of the state
        */
        public function FalagardStateImagery(look:String, name:String, clipped:Boolean = true)
        {
            d_lookName = look;  //cached
            
            
            d_stateName = name;
            d_clipToDisplay = clipped;
        }
        
        public function parseXML(xml:XML):void
        {
            //parse layer
            var node:XML;
            var nodes:XMLList = xml.Layer;
            for each(node in nodes)
            {
                var priority:uint = Misc.getAttributeAsUint(node.@priority.toString(), 0);
                var layer:FalagardLayerSpecification = new FalagardLayerSpecification(d_lookName, priority);
                layer.parseXML(node);
                d_layers.push(layer);
            }
        }
        
        
        
        /*!
        \brief
        Render imagery for this state.
        
        \param srcWindow
        Window to use when convering BaseDim values to pixels.
        
        \return
        Nothing.
        */
        public function render(srcWindow:FlameWindow, modcols:ColourRect = null, clipper:Rect = null):void
        {
            // TODO: Fix layer priority handling
            
            // render all layers defined for this state
            for(var i:uint = 0; i < d_layers.length; i++)
            {
                d_layers[i].render(srcWindow, modcols, clipper, d_clipToDisplay);
            }
        }
        
        /*!
        \brief
        Render imagery for this state.
        
        \param srcWindow
        Window to use when convering BaseDim values to pixels.
        
        \param baseRect
        Rect to use when convering BaseDim values to pixels.
        
        \return
        Nothing.
        */
        public function render2(srcWindow:FlameWindow, baseRect:Rect, modcols:ColourRect = null, clipper:Rect = null):void
        {
            
            // TODO: Fix layer priority handling
            
            // render all layers defined for this state
            for(var i:uint = 0; i < d_layers.length; i++)
            {
                d_layers[i].render2(srcWindow, baseRect, modcols, clipper, d_clipToDisplay);
            }
        }
        
        /*!
        \brief
        Add an imagery LayerSpecification to this state.
        
        \param layer
        LayerSpecification to be added to this state (will be copied)
        
        \return
        Nothing.
        */
        public function addLayer(layer:FalagardLayerSpecification):void
        {
            d_layers.push(layer);
        }
        
        /*!
        \brief
        Removed all LayerSpecifications from this state.
        
        \return
        Nothing.
        */
        public function clearLayers():void
        {
            d_layers.length = 0;
        }
        
        /*!
        \brief
        Return the name of this state.
        
        \return
        String object holding the name of the StateImagery object.
        */
        public function getName():String
        {
            return d_stateName;
        }
        
        /*!
        \brief
        Return whether this state imagery should be clipped to the display rather than the target window.
        
        Clipping to the display effectively implies that the imagery should be rendered unclipped.
        
        /return
        - true if the imagery will be clipped to the display area.
        - false if the imagery will be clipped to the target window area.
        */
        public function isClippedToDisplay():Boolean
        {
            return d_clipToDisplay;
        }
        
        /*!
        \brief
        Set whether this state imagery should be clipped to the display rather than the target window.
        
        Clipping to the display effectively implies that the imagery should be rendered unclipped.
        
        \param setting
        - true if the imagery should be clipped to the display area.
        - false if the imagery should be clipped to the target window area.
        
        \return
        Nothing.
        */
        public function setClippedToDisplay(setting:Boolean):void
        {
            d_clipToDisplay = setting;
        }
        
        /*!
        \brief
        Writes an xml representation of this StateImagery to \a out_stream.
        
        \param xml_stream
        Stream where xml data should be output.
        
        
        \return
        Nothing.
        */
        //void writeXMLToStream(XMLSerializer& xml_stream) const;
        
    }
}