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
    import Flame2D.core.data.Consts;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.URect;
    import Flame2D.core.utils.UVector2;

    /*!
    \brief
    Class that encapsulates information regarding a sub-widget required for a widget.
    
    \todo
    This is not finished in the slightest!  There will be many changes here...
    */
    public class FalagardWidgetComponent
    {
        //typedef std::vector<PropertyInitialiser> PropertiesList;
        private var d_wl:String = "";
        
        private var d_area:FalagardComponentArea;              //!< Destination area for the widget (relative to it's parent).
        private var d_baseType:String;                 //!< Type of widget to be created.
        private var d_imageryName:String;              //!< Name of a WidgetLookFeel to be used for the widget.
        public var d_nameSuffix:String;               //!< Suffix to apply to the parent Window name to create this widgets unique name.
        private var d_rendererType:String;             //!< Name of the window renderer type to assign to the widget.
        private var d_vertAlign:uint = Consts.VerticalAlignment_VA_TOP;    //!< Vertical alignment to be used for this widget.
        private var d_horzAlign:uint = Consts.HorizontalAlignment_HA_LEFT;    //!< Horizontal alignment to be used for this widget.
        private var d_properties:Vector.<FalagardPropertyInitialiser> = new Vector.<FalagardPropertyInitialiser>();
                   //!< Collection of PropertyInitialisers to be applied the the widget upon creation.
        
        
        public function FalagardWidgetComponent(wl:String, type:String, look:String, suffix:String, renderer:String)
        {
            d_wl = wl;
            d_baseType = type;
            d_imageryName = look;
            d_nameSuffix = suffix;
            d_rendererType = renderer;
            
        }
        
        public function parseXML(xml:XML):void
        {
            parseAlignment(xml);
            parseArea(xml);
            parseProperties(xml);
        }
        
        private function parseAlignment(xml:XML):void
        {
            var vType:String;
            var hType:String;
            
            var node:XML;
            
            node = xml.HorzAlignment[0];
            if(node){
                hType = node.@type.toString();
                d_horzAlign = FalagardXMLHelper.stringToHorzAlignment(hType);
            }
            node = xml.VertAlignment[0];
            if(node){
                vType = node.@type.toString();
                d_vertAlign = FalagardXMLHelper.stringToVertAlignment(vType);
            }
            
        }
        
        private function parseArea(xml:XML):void
        {
            d_area = new FalagardComponentArea(d_wl);
            d_area.parseXML(xml.Area[0]);
            
        }
        
        private function parseProperties(xml:XML):void
        {
            var node:XML;
            var nodes:XMLList = xml.Property;

            for each(node in nodes)
            {
                var name:String = node.@name.toString();
                var value:String = node.@value.toString();
                
                var property:FalagardPropertyInitialiser = new FalagardPropertyInitialiser(name, value);
                d_properties.push(property);
            }
        }
        
        /*!
        \brief
        Create an instance of this widget component adding it as a child to the given Window.
        */
        public function create(parent:FlameWindow):void
        {
            // build final name and create widget.
            var widgetName:String = parent.getName() + d_nameSuffix;
            var widget:FlameWindow = FlameWindowManager.getSingleton().createWindow(d_baseType, widgetName);
            
            // set the window renderer
            if (d_rendererType.length != 0)
                widget.setWindowRenderer(d_rendererType);
            
            // set the widget look
            if (d_imageryName.length != 0)
                widget.setLookNFeel(d_imageryName);
            
            // add the new widget to its parent
            parent.addChildWindow(widget);
            
            // set alignment options
            widget.setVerticalAlignment(d_vertAlign);
            widget.setHorizontalAlignment(d_horzAlign);
            
            // TODO: We still need code to specify position and size.  Due to the advanced
            // TODO: possibilities, this is better handled via a 'layout' method instead of
            // TODO: setting this once and forgetting about it.
            
            // initialise properties.  This is done last so that these properties can
            // override properties specified in the look assigned to the created widget.
            for(var i:uint=0; i<d_properties.length; i++)
            {
                d_properties[i].applyWindow(widget as FlameWindow);
                //widget.setProperty(d_properties[i].d_propertyName, d_properties[i].d_propertyValue);
            }
        }
        
        public function getComponentArea():FalagardComponentArea
        {
            return d_area;
        }
        public function setComponentArea(area:FalagardComponentArea):void
        {
            d_area = area;
        }
        
        public function getBaseWidgetType():String
        {
            return d_baseType;
        }
        public function setBaseWidgetType(type:String):void
        {
            d_baseType = type;
        }
        
        public function getWidgetLookName():String
        {
            return d_imageryName;
        }
        public function setWidgetLookName(look:String):void
        {
            d_imageryName = look;
        }
        
        public function getWidgetNameSuffix():String
        {
            return d_nameSuffix;
        }
        public function setWidgetNameSuffix(suffix:String):void
        {
            d_nameSuffix = suffix;
        }
        
        public function getWindowRendererType():String
        {
            return d_rendererType;
        }
        public function setWindowRendererType(type:String):void
        {
            d_rendererType = type;
        }
        
        public function getVerticalWidgetAlignment():uint
        {
            return d_vertAlign;
        }
        public function setVerticalWidgetAlignment(alignment:uint):void
        {
            d_vertAlign = alignment;
        }
        
        public function getHorizontalWidgetAlignment():uint
        {
            return d_horzAlign;
        }
        public function setHorizontalWidgetAlignment(alignment:uint):void
        {
            d_horzAlign = alignment;
        }
        
        public function addPropertyInitialiser(initialiser:FalagardPropertyInitialiser):void
        {
            d_properties.push(initialiser);
        }
        public function clearPropertyInitialisers():void
        {
            d_properties.length = 0;
        }
        
        public function layout(owner:FlameWindow):void
        {
//            try
//            {
                var pixelArea:Rect = d_area.getPixelRect(owner);
                var window_area:URect = new URect(
                    new UVector2(Misc.cegui_absdim(pixelArea.d_left),Misc.cegui_absdim(pixelArea.d_top)),
                    new UVector2(Misc.cegui_absdim(pixelArea.d_right), Misc.cegui_absdim(pixelArea.d_bottom))
                    );
                
                var wnd:FlameWindow = FlameWindowManager.getSingleton().getWindow(owner.getName() + d_nameSuffix);
                wnd.setAreaByURect(window_area);
                wnd.notifyScreenAreaChanged();
//            }
//            catch (error:Error)
//            {
//                throw new Error("Unknown error.");
//            }
        }
        
        /*!
        \brief
        Writes an xml representation of this WidgetComponent to \a out_stream.
        
        \param xml_stream
        Stream where xml data should be output.
        
        
        \return
        Nothing.
        */
        //void writeXMLToStream(XMLSerializer& xml_stream) const;
        
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
        
      
    }
}