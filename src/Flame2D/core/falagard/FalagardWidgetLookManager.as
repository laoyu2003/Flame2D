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
    import Flame2D.core.system.FlameResourceProvider;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.loaders.TextFileLoader;
    
    import flash.utils.Dictionary;

    /*!
    \brief
    Manager class that gives top-level access to widget data based "look and feel" specifications loaded into the system.
    */
    public class FalagardWidgetLookManager
    {
        //public static const FalagardSchemaName:String;     //!< Name of schema file used for XML validation.
        
        //typedef std::map<String, WidgetLookFeel, String::FastLessCompare> WidgetLookList;
        private var d_widgetLooks:Dictionary = new Dictionary();
        
        private static var d_defaultResourceGroup:String;   //!< holds default resource group

        private static var d_callbackMap:Dictionary = new Dictionary();
        
        private static var d_singleton:FalagardWidgetLookManager = new FalagardWidgetLookManager();
        
        
        public function FalagardWidgetLookManager()
        {
            if(d_singleton){
                throw new Error("FalagardWidgtLookManager: init only once");
            }
        }
        
        public static function getSingleton():FalagardWidgetLookManager
        {
            return d_singleton;
        }
        
        /*!
        \brief
        Parses a file containing window look & feel specifications (in the form of XML).
        
        \note
        If the new file contains specifications for widget types that are already specified, it is not an error;
        the previous definitions are overwritten by the new data.  An entry will appear in the log each time any
        look & feel component is overwritten.
        
        \param filename
        String object containing the filename of a file containing the widget look & feel data
        
        \param resourceGroup
        Resource group identifier to pass to the resource provider when loading the file.
        
        \return
        Nothing.
        
        \exception	FileIOException				thrown if there was some problem accessing or parsing the file \a filename
        \exception	InvalidRequestException		thrown if an invalid filename was provided.
        */
        public function parseLookNFeelSpecification(fileName:String, resourceGroup:String = "", callback:Function = null):void
        {
            d_callbackMap[fileName] = callback;
            
            //to be checked
            d_defaultResourceGroup = resourceGroup;
            
            
            var url:String = FlameResourceProvider.getSingleton().getResourceDir() + 
                             FlameResourceProvider.getSingleton().getLookNFeelDir() + fileName;
            
            new TextFileLoader({looknfeel:url, fileName:fileName}, url, onLookNFeelLoaded);
        }
        
        private function onLookNFeelLoaded(tag:Object, str:String):void
        {
            var xml:XML;
            try {
                //trace(str);
                xml = new XML(str);
            } catch(e:Error) {
                throw new Error("Cannot parse scheme xml.");
            }

            //parse xml
            var nodes:XMLList = xml.WidgetLook;
            for each(var node:XML in nodes){
                parseWidgetLook(node);
            }
            
            var callback:Function = d_callbackMap[tag.fileName];
            if(callback != null)
            {
                callback();
            }
        }

        private function parseWidgetLook(node:XML):void
        {
            var name:String = node.@name.toString();
            
            trace("widgtlook:" + name);

            var wlf:FalagardWidgetLookFeel = new FalagardWidgetLookFeel(name);
            wlf.parseXML(node);
            d_widgetLooks[name] = wlf;
        }
        
        
        
        /*!
        \brief
        Return whether a WidgetLookFeel has been created with the specified name.
        
        \param widget
        String object holding the name of a widget look to test for.
        
        \return
        - true if a WidgetLookFeel named \a widget is available.
        - false if so such WidgetLookFeel is currently available.
        */
        public function isWidgetLookAvailable(widget:String):Boolean
        {
            return d_widgetLooks.hasOwnProperty(widget);
        }
        
        
        /*!
        \brief
        Return a const reference to a WidgetLookFeel object which has the specified name.
        
        \param widget
        String object holding the name of a widget look that is to be returned.
        
        \return
        const reference to the requested WidgetLookFeel object.
        
        \exception UnknownObjectException   thrown if no WidgetLookFeel is available with the requested name.
        */
        public function getWidgetLook(widget:String):FalagardWidgetLookFeel
        {
            if(d_widgetLooks.hasOwnProperty(widget)){
                return d_widgetLooks[widget];
            }
            
            throw new Error("WidgetLookManager::getWidgetLook - Widget look and feel '" + widget + "' does not exist.");
        }
        
        
        /*!
        \brief
        Erase the WidgetLookFeel that has the specified name.
        
        \param widget
        String object holding the name of a widget look to be erased.  If no such WidgetLookFeel exists, nothing
        happens.
        
        \return
        Nothing.
        */
        public function eraseWidgetLook(widget:String):void
        {
            if(d_widgetLooks.hasOwnProperty(widget)){
                delete d_widgetLooks[widget];
            } else {
                trace("WidgetLookManager::eraseWidgetLook - Widget look and feel '" + widget + "' did not exist.");
            }
        }
        
        
        /*!
        \brief
        Add the given WidgetLookFeel.
        
        \note
        If the WidgetLookFeel specification uses a name that already exists within the system, it is not an error;
        the previous definition is overwritten by the new data.  An entry will appear in the log each time any
        look & feel component is overwritten.
        
        \param look
        WidgetLookFeel object to be added to the system.  NB: The WidgetLookFeel is copied, no change of ownership of the
        input object occurrs.
        
        \return
        Nothing.
        */
        public function addWidgetLook(look:FalagardWidgetLookFeel):void
        {
            if (isWidgetLookAvailable(look.getName()))
            {
                trace("WidgetLookManager::addWidgetLook - Widget look and feel '" + 
                    look.getName() + "' already exists.  Replacing previous definition.");
            }
            
            d_widgetLooks[look.getName()] = look;
        }
        
        
        /*!
        \brief
        Returns the default resource group currently set for LookNFeels.
        
        \return
        String describing the default resource group identifier that will be
        used when loading LookNFeel data.
        */
        public static function getDefaultResourceGroup():String
        { 
            return d_defaultResourceGroup; 
        }
        
        /*!
        \brief
        Sets the default resource group to be used when loading LookNFeel data
        
        \param resourceGroup
        String describing the default resource group identifier to be used.
        
        \return
        Nothing.
        */
        public static function setDefaultResourceGroup(resourceGroup:String):void
        { 
            d_defaultResourceGroup = resourceGroup; 
        }
    }
    
}