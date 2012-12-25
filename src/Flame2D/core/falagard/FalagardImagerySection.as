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
    import Flame2D.core.system.FlameFont;
    import Flame2D.core.system.FlameFontManager;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.utils.Colour;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Vector2;

    public class FalagardImagerySection
    {
//        typedef std::vector<ImageryComponent> ImageryList;
//        typedef std::vector<TextComponent> TextList;
//        typedef std::vector<FrameComponent> FrameList;
        
        private var d_wl:String = "";
        
        private var d_name:String;//!< Holds the name of the ImagerySection.
        private var d_masterColours:ColourRect = new ColourRect(new Colour(), new Colour(), new Colour(), new Colour());    //!< Naster colours for the the ImagerySection (combined with colours of each ImageryComponent).
        private var d_frames:Vector.<FalagardFrameComponent> = new Vector.<FalagardFrameComponent>();           //!< Collection of FrameComponent objects to be drawn for this ImagerySection.
        private var d_images:Vector.<FalagardImageryComponent> = new Vector.<FalagardImageryComponent>();           //!< Collection of ImageryComponent objects to be drawn for this ImagerySection.
        private var d_texts:Vector.<FalagardTextComponent> = new Vector.<FalagardTextComponent>();            //!< Collection of TextComponent objects to be drawn for this ImagerySection.
        private var d_colourPropertyName:String = "";   //!< name of property to fetch colours from.
        private var d_colourProperyIsRect:Boolean = false;  //!< true if the colour property will fetch a full ColourRect.

        
        public function FalagardImagerySection(wl:String, name:String)
        {
            d_wl = wl;
            d_name = name;
        }
        
        
        public function parseXML(xml:XML):void
        {
            parseColours(xml);
            parseFrameComponent(xml);
            parseImageryComponent(xml);
            parseTextComponent(xml);
            
        }
        
        private function parseColours(xml:XML):void
        {
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
                setMasterColours(cols);
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
                setMasterColours(cols);
            }
            
            //ColourProperty
            node = xml.ColourProperty[0];
            if(node)
            {
                d_colourPropertyName = node.@name.toString();
                setMasterColoursPropertyIsColourRect(false);
            }
            
            //ColourRectProperty
            node = xml.ColourRectProperty[0];
            if(node)
            {
                d_colourPropertyName = node.@name.toString();
                d_colourProperyIsRect = true;
            }
                    
        }
        
        private function parseFrameComponent(xml:XML):void
        {
            var nodes:XMLList = xml.FrameComponent;
            for each(var node:XML in nodes){
                var fc:FalagardFrameComponent = new FalagardFrameComponent(d_wl);
                fc.parseXML(node);
                this.d_frames.push(fc);
            }
        }
        
        private function parseImageryComponent(xml:XML):void
        {
            var nodes:XMLList = xml.ImageryComponent;
            for each(var node:XML in nodes){
                var ic:FalagardImageryComponent = new FalagardImageryComponent(d_wl);
                ic.parseXML(node);
                this.d_images.push(ic);
            }
        }
        
        private function parseTextComponent(xml:XML):void
        {
            var nodes:XMLList = xml.TextComponent;
            for each(var node:XML in nodes){
                var tc:FalagardTextComponent = new FalagardTextComponent(d_wl);
                tc.parseXML(node);
                this.d_texts.push(tc);
            }
        }
        
        
        
        /*!
        \brief
        Render the ImagerySection.
        
        \param srcWindow
        Window object to be used when calculating pixel values from BaseDim values.
        
        \param modColours
        ColourRect specifying colours to be modulated with the ImagerySection's master colours.  May be 0.
        
        \return
        Nothing.
        */
        public function render(srcWindow:FlameWindow, modColours:ColourRect = null, 
                               clipper:Rect = null, clipToDisplay:Boolean = false):void
        {
            // decide what to do as far as colours go
            var finalCols:ColourRect = initMasterColourRect(srcWindow);
            
            if (modColours)
            {
                finalCols = finalCols.multiplyColourRect(modColours);
            }
            
            var finalColsPtr:ColourRect = (finalCols.isMonochromatic() && finalCols.d_top_left.getARGB() == 0xFFFFFFFF) ? 
                null : finalCols;
            
            // render all frame components in this section
            for(var i:uint=0; i<d_frames.length; i++)
            {
               d_frames[i].render(srcWindow, finalColsPtr, clipper, clipToDisplay);
            }
            // render all image components in this section
            for(i=0; i<d_images.length; i++)
            {
               d_images[i].render(srcWindow, finalColsPtr, clipper, clipToDisplay);
            }
            // render all text components in this section
            for(i=0; i<d_texts.length; i++)
            {
                d_texts[i].render(srcWindow, finalColsPtr, clipper, clipToDisplay);
            }
        }
        
        /*!
        \brief
        Render the ImagerySection.
        
        \param srcWindow
        Window object to be used when calculating pixel values from BaseDim values.
        
        \param baseRect
        Rect object to be used when calculating pixel values from BaseDim values.
        
        \param modColours
        ColourRect specifying colours to be modulated with the ImagerySection's master colours.  May be 0.
        
        \return
        Nothing.
        */
        public function render2(srcWindow:FlameWindow, baseRect:Rect, modColours:ColourRect = null, 
                                clipper:Rect = null, clipToDisplay:Boolean = false):void
        {
            // decide what to do as far as colours go
            var finalCols:ColourRect = initMasterColourRect(srcWindow);
            
            if (modColours)
                finalCols = finalCols.multiplyColourRect(modColours);
            
            var finalColsPtr:ColourRect = (finalCols.isMonochromatic() && finalCols.d_top_left.getARGB() == 0xFFFFFFFF) ? 
                null : finalCols;
            
            // render all frame components in this section
            for(var i:uint=0; i<d_frames.length; i++)
            {
                d_frames[i].render2(srcWindow, baseRect, finalColsPtr, clipper, clipToDisplay);
            }
            // render all image components in this section
            for(i=0; i<d_images.length; i++)
            {
                d_images[i].render2(srcWindow, baseRect, finalColsPtr, clipper, clipToDisplay);
            }
            // render all text components in this section
            for(i=0; i<d_texts.length; i++)
            {
                d_texts[i].render2(srcWindow, baseRect, finalColsPtr, clipper, clipToDisplay);
            }
            
        }
            
        
        /*!
        \brief
        Add an ImageryComponent to this ImagerySection.
        
        \param img
        ImageryComponent to be added to the section (a copy is made)
        
        \return
        Nothing
        */
        public function addImageryComponent(img:FalagardImageryComponent):void
        {
            d_images.push(img);
        }
        
        /*!
        \brief
        Clear all ImageryComponents from this ImagerySection.
        
        \return
        Nothing
        */
        public function clearImageryComponents():void
        {
            d_images.length = 0;
        }
        
        /*!
        \brief
        Add a TextComponent to this ImagerySection.
        
        \param text
        TextComponent to be added to the section (a copy is made)
        
        \return
        Nothing
        */
        public function addTextComponent(text:FalagardTextComponent):void
        {
            d_texts.push(text);
        }
        
        /*!
        \brief
        Clear all TextComponents from this ImagerySection.
        
        \return
        Nothing
        */
        public function clearTextComponents():void
        {
            d_texts.length = 0;
        }
        
        /*!
        \brief
        Clear all FrameComponents from this ImagerySection.
        
        \return
        Nothing
        */
        public function clearFrameComponents():void
        {
            d_frames.length = 0;
        }
        
        /*!
        \brief
        Add a FrameComponent to this ImagerySection.
        
        \param frame
        FrameComponent to be added to the section (a copy is made)
        
        \return
        Nothing
        */
        public function addFrameComponent(frame:FalagardFrameComponent):void
        {
            d_frames.push(frame);
        }
        
        /*!
        \brief
        Return the current master colours set for this ImagerySection.
        
        \return
        ColourRect describing the master colour values in use for this ImagerySection.
        */
        public function getMasterColours():ColourRect
        {
            return d_masterColours;
        }
        
        /*!
        \brief
        Set the master colours to be used for this ImagerySection.
        
        \param cols
        ColourRect describing the colours to be set as the master colours for this ImagerySection.
        
        \return
        Nothing.
        */
        public function setMasterColours(cols:ColourRect):void
        {
            d_masterColours = cols;
        }
        
        /*!
        \brief
        Return the name of this ImagerySection.
        
        \return
        String object holding the name of the ImagerySection.
        */
        public function getName():String
        {
            return d_name;
        }

        
        /*!
        \brief
        Set the name of the property where master colour values can be obtained.
        
        \param property
        String containing the name of the property.
        
        \return
        Nothing.
        */
        public function setMasterColoursPropertySource(property:String):void
        {
            d_colourPropertyName = property;
        }
        
        /*!
        \brief
        Set whether the master colours property source represents a full ColourRect.
        
        \param setting
        - true if the master colours property will access a ColourRect object.
        - false if the master colours property will access a colour object.
        
        \return
        Nothing.
        */
        public function setMasterColoursPropertyIsColourRect(setting:Boolean = true):void
        {
            d_colourProperyIsRect = setting;
        }
        
        /*!
        \brief
        Return smallest Rect that could contain all imagery within this section.
        */
        public function getBoundingRect(wnd:FlameWindow):Rect
        {
            var compRect:Rect;
            var bounds:Rect = new Rect(Number.MAX_VALUE, Number.MAX_VALUE, Number.MIN_VALUE, Number.MIN_VALUE);
            
            // measure all frame components
            for(var i:uint = 0; i<d_frames.length; i++)
            {
                compRect = d_frames[i].getComponentArea().getPixelRect(wnd);
                
                bounds.d_left   = Math.min(bounds.d_left, compRect.d_left);
                bounds.d_top    = Math.min(bounds.d_top, compRect.d_top);
                bounds.d_right  = Math.max(bounds.d_right, compRect.d_right);
                bounds.d_bottom = Math.max(bounds.d_bottom, compRect.d_bottom);
            }
            // measure all imagery components
            for(i=0; i<d_images.length; i++)
            {
                compRect = d_images[i].getComponentArea().getPixelRect(wnd);
                
                bounds.d_left   = Math.min(bounds.d_left, compRect.d_left);
                bounds.d_top    = Math.min(bounds.d_top, compRect.d_top);
                bounds.d_right  = Math.max(bounds.d_right, compRect.d_right);
                bounds.d_bottom = Math.max(bounds.d_bottom, compRect.d_bottom);
            }
            // measure all text components
            for(i=0; i<d_texts.length; i++)
            {
                compRect = d_texts[i].getComponentArea().getPixelRect(wnd);
                
                bounds.d_left   = Math.min(bounds.d_left, compRect.d_left);
                bounds.d_top    = Math.min(bounds.d_top, compRect.d_top);
                bounds.d_right  = Math.max(bounds.d_right, compRect.d_right);
                bounds.d_bottom = Math.max(bounds.d_bottom, compRect.d_bottom);
            }
            
            return bounds;
        }
        
        /*!
        \brief
        Return smallest Rect that could contain all imagery within this section.
        */
        public function getBoundingRectWithinRect(wnd:FlameWindow, rect:Rect):Rect
        {
            var compRect:Rect;
            var bounds:Rect = new Rect(Number.MAX_VALUE, Number.MAX_VALUE, Number.MIN_VALUE, Number.MIN_VALUE);
            
            // measure all frame components
            for(var i:uint=0; i<d_frames.length; i++)
            {
                compRect = d_frames[i].getComponentArea().getPixelRect2(wnd, rect);
                
                bounds.d_left   = Math.min(bounds.d_left, compRect.d_left);
                bounds.d_top    = Math.min(bounds.d_top, compRect.d_top);
                bounds.d_right  = Math.max(bounds.d_right, compRect.d_right);
                bounds.d_bottom = Math.max(bounds.d_bottom, compRect.d_bottom);
            }
            // measure all imagery components
            for(i=0; i<d_images.length; i++)
            {
                compRect = d_images[i].getComponentArea().getPixelRect2(wnd, rect);
                
                bounds.d_left   = Math.min(bounds.d_left, compRect.d_left);
                bounds.d_top    = Math.min(bounds.d_top, compRect.d_top);
                bounds.d_right  = Math.max(bounds.d_right, compRect.d_right);
                bounds.d_bottom = Math.max(bounds.d_bottom, compRect.d_bottom);
            }
            // measure all text components
            for(i=0; i<d_texts.length; i++)
            {
                compRect = d_texts[i].getComponentArea().getPixelRect2(wnd, rect);
                
                bounds.d_left   = Math.min(bounds.d_left, compRect.d_left);
                bounds.d_top    = Math.min(bounds.d_top, compRect.d_top);
                bounds.d_right  = Math.max(bounds.d_right, compRect.d_right);
                bounds.d_bottom = Math.max(bounds.d_bottom, compRect.d_bottom);
            }
            
            return bounds;
        }
        
        
        //! return number of TextComponents in the ImagerySection.
        public function getTextComponentCount():uint
        {
            return d_texts.length;
        }
        
        //! return a reference to a TextComponent (via index).
        public function getTextComponent(idx:uint):FalagardTextComponent
        {
            if (idx >= d_texts.length)
                throw new Error("ImagerySection::getTextComponent: index out of range.");
            
            return d_texts[idx];
        }
        
        /*!
        \brief
        Helper method to initialise a ColourRect with appropriate values according to the way the
        ImagerySection is set up.
        
        This will try and get values from multiple places:
        - a property attached to \a wnd
        - or the integral d_masterColours value.
        */
        protected function initMasterColourRect(wnd:FlameWindow):ColourRect
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
                cr = d_masterColours;
            }
            
            return cr;
        }

            
    }
}