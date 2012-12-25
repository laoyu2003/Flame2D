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
package Flame2D.core.system
{
    import Flame2D.core.data.AliasMapping;
    import Flame2D.core.data.FalagardMapping;
    import Flame2D.core.data.FalagardWindowMapping;
    import Flame2D.core.data.LoadableUIElement;
    import Flame2D.core.data.UIModule;
    import Flame2D.core.data.WRModule;
    import Flame2D.core.falagard.FalagardWidgetLookManager;
    import Flame2D.elements.button.FlameCheckbox;
    import Flame2D.loaders.TextFileLoader;
    import Flame2D.renderer.FlameGeometryBuffer;
    import Flame2D.falagard.FalagardWRModule;
    
    /*!
    \brief
    A class that groups a set of GUI elements and initialises the system to access those elements.
    
    A GUI Scheme is a high-level construct that loads and initialises various lower-level objects
    and registers them within the system for usage.  So, for example, a Scheme might create some
    Imageset objects, some Font objects, and register a collection of WindowFactory objects within
    the system which would then be in a state to serve those elements to client code.
    */
    public class FlameScheme
    {
        /*************************************************************************
         Implementation Data
         *************************************************************************/
        private var d_name:String;			//!< the name of this scheme.
        private static var d_defaultResourceGroup:String;
       
        private var d_wrModule:FalagardWRModule = null;
        
        
        private var d_imagesets:Vector.<LoadableUIElement> = new Vector.<LoadableUIElement>();
        private var d_imagesetsFromImages:Vector.<LoadableUIElement> = new Vector.<LoadableUIElement>();
        private var d_fonts:Vector.<LoadableUIElement> = new Vector.<LoadableUIElement>();
        private var d_widgetModules:Vector.<UIModule> = new Vector.<UIModule>();
        private var d_windowRendererModules:Vector.<WRModule> = new Vector.<WRModule>();
        private var d_aliasMappings:Vector.<AliasMapping> = new Vector.<AliasMapping>();
        private var d_looknfeels:Vector.<LoadableUIElement> = new Vector.<LoadableUIElement>();
        private var d_falagardMapping:Vector.<FalagardMapping> = new Vector.<FalagardMapping>();
        
        
        private var d_imagesetRemained:uint = 0;
        private var d_imagefileRemained:uint = 0;
        private var d_fontsRemained:uint = 0;
        private var d_looknfeelRemained:uint = 0;
        
        //async load scheme
        private var d_count:uint;
        private var d_jobs:uint;
        private var d_callback:Function = null;        //called from others
        
        /*************************************************************************
         Construction and Destruction
         *************************************************************************/
        /*!
        \brief
        Constructs an empty scheme object with the specified name.
        
        \param name
        String object holding the name of the Scheme object.
        */
        public function FlameScheme(name:String, resourceGroup:String = "", callback:Function = null)
        {
            d_name = name;
            d_callback = callback
            d_defaultResourceGroup = resourceGroup;
        }
        
        /*!
        \brief
        Loads all resources for this scheme.
        
        \return
        Nothing.
        */
        public function loadResources():void
        {
            var url:String = FlameResourceProvider.getSingleton().getResourceDir() + 
                             FlameResourceProvider.getSingleton().getSchemeDir() + 
                             d_name;
            
            new TextFileLoader({scheme:url}, url, onSchemeLoaded);
        }
        
        private function onSchemeLoaded(tag:Object, str:String):void
        {
            var xml:XML;
            try {
                //trace(str);
                xml = new XML(str);
            } catch(e:Error) {
                throw new Error("Cannot parse looknfeel xml.");
            }
            if(xml){
                //parse data
                parseWindowAlias(xml);
                parseFalagardMapping(xml);
                parseWindowSets(xml);
                parseImageSets(xml);            //need external file
                parseImageSetsFromImage(xml);   //need external file
                parseFonts(xml);                //need external file
                parseLookNFeel(xml);            //need external file
                
                
                //real load resources
                loadWindowRendererFactories();
                loadWindowFactories();
                loadFactoryAliases();
                loadFalagardMappings();
                //need loading imagesets/imagefile/fonts before looknfeel
                loadXMLImagesets();
//                loadImageFileImagesets();
//                loadFonts();
//                loadLookNFeels();
            }
        }
        
        private function parseWindowSets(xml:XML):void
        {
            //window set
            var node:XML;
            var nodes:XMLList;
            
            //window set
            nodes = xml.WindowSet;
            for each(node in nodes){
                var module:UIModule = new UIModule();
                module.name = node.@Filename.toString();
                module.module = null;
                
                //clear the vector
                module.factories.length = 0;
                
                d_widgetModules.push(module);
            }
        }
            
            
        private function parseImageSets(xml:XML):void
        {
            //imageset
            var node:XML;
            var nodes:XMLList;

            nodes = xml.Imageset;
            for each(node in nodes){
                var imageset:LoadableUIElement = new LoadableUIElement();
                imageset.name = node.@Name.toString();
                imageset.filename = node.@Filename.toString();
                imageset.resourceGroup = node.@ResourceGroup.toString();
                
                d_imagesets.push(imageset);
                
            }
        }
        
        private function parseImageSetsFromImage(xml:XML):void
        {
            //imageset from file
            var node:XML;
            var nodes:XMLList;

            nodes = xml.ImagesetFromImage;
            for each(node in nodes){
                var imagesetf:LoadableUIElement = new LoadableUIElement();
                imagesetf.filename = node.@Filename.toString();
                imagesetf.name = node.@Name.toString();
                imagesetf.resourceGroup = node.@ResourceGroup.toString();
                
                d_imagesetsFromImages.push(imagesetf);
            }
            
        }
        
        private function parseFonts(xml:XML):void
        {
            //fonts
            var node:XML;
            var nodes:XMLList;

            nodes = xml.Font;
            for each(node in nodes){
                var font:LoadableUIElement = new LoadableUIElement();
                font.name = node.@Name.toString();
                font.filename = node.@Filename.toString();
                font.resourceGroup = node.@ResourceGroup.toString();
                d_fonts.push(font);
            }
        }
        
        private function parseLookNFeel(xml:XML):void
        {
            //look n feel
            var node:XML;
            var nodes:XMLList;

            nodes = xml.LookNFeel;
            for each(node in nodes){
                var lnf:LoadableUIElement = new LoadableUIElement();
                lnf.filename = node.@Filename.toString();
                lnf.resourceGroup = node.@ResourceGroup.toString();
                
                d_looknfeels.push(lnf);
            }
            
        }
        
        private function parseWindowAlias(xml:XML):void
        {
            //window alias
            var node:XML;
            var nodes:XMLList;

            nodes = xml.WindowAlias;
            for each(node in nodes){
                var alias:AliasMapping = new AliasMapping();
                alias.aliasName = node.@Alias.toString();
                alias.targetName = node.@Target.toString();
                
                d_aliasMappings.push(alias);
            }
        }
        
        private function parseFalagardMapping(xml:XML):void
        {
            //falagard mapping
            var node:XML;
            var nodes:XMLList;

            nodes = xml.FalagardMapping;
            for each(node in nodes){
                var fmap:FalagardMapping = new FalagardMapping();
                fmap.windowName = node.@WindowType.toString();
                fmap.targetName = node.@TargetType.toString();
                fmap.lookName = node.@LookNFeel.toString();
                fmap.rendererName = node.@Renderer.toString();
                fmap.effectName = node.@RenderEffect.toString();
                
                d_falagardMapping.push(fmap);
            }
        }
                
        /*!
        \brief
        Unloads all resources for this scheme.  This should be used very carefully.
        
        \return
        Nothing.
        */
        //void	unloadResources(void);
        
        
        /*!
        \brief
        Return whether the resources for this Scheme are all loaded.
        
        \return
        true if all resources for the Scheme are loaded and available, or false of one or more resource is not currently loaded.
        */
        public function resourcesLoaded():Boolean
        {
            // test state of all loadable resources for this scheme.
            if (areXMLImagesetsLoaded() &&
                areImageFileImagesetsLoaded() &&
                areFontsLoaded() &&
                areWindowRendererFactoriesLoaded() &&
                areWindowFactoriesLoaded() &&
                areFactoryAliasesLoaded() &&
                areFalagardMappingsLoaded())
            {
                return true;
            }
            
            return false;
        }
        
        /*!
        \brief
        Return the name of this Scheme.
        
        \return
        String object containing the name of this Scheme.
        */
        public function getName():String
        {
            return d_name;
        }
        
        /*!
        \brief
        Returns the default resource group currently set for Schemes.
        
        \return
        String describing the default resource group identifier that will be
        used when loading Scheme xml file data.
        */
        public static function getDefaultResourceGroup():String
        {
            return d_defaultResourceGroup;
        }
        
        /*!
        \brief
        Sets the default resource group to be used when loading scheme xml data
        
        \param resourceGroup
        String describing the default resource group identifier to be used.
        
        \return
        Nothing.
        */
        public static function setDefaultResourceGroup(resourceGroup:String):void
        {
            d_defaultResourceGroup = resourceGroup;
        }

        
        
        /*************************************************************************
         Load all xml imagesets specified.
         *************************************************************************/
        private function loadXMLImagesets():void
        {
            //count and wait all imageset loaded
            d_imagesetRemained = d_imagesets.length;
            if(d_imagesetRemained == 0)
            {
                loadImageFileImagesets();
                return;
            }
            
            var ismgr:FlameImageSetManager = FlameImageSetManager.getSingleton();
            // check all imagesets
            for(var i:uint=0; i<d_imagesets.length; i++)
            {
                var imageset:LoadableUIElement = d_imagesets[i];

                // skip if the imageset already exists
                if(imageset.name.length != 0 && ismgr.isDefined(imageset.name))
                {
                    continue;
                }

                // create imageset from specified file.
                ismgr.create(imageset.name, imageset.filename, imageset.resourceGroup, onImageSetLoaded);
                
                trace("load image set:" + imageset.name + " -----> file:" + imageset.filename);
            }
        }
        
        private function onImageSetLoaded(tag:Object):void
        {
            d_imagesetRemained --;
            
            if(d_imagesetRemained == 0)
            {
                loadImageFileImagesets()
            }
        }
            
        
        /*************************************************************************
         Load all image file based imagesets specified.
         *************************************************************************/
        private function loadImageFileImagesets():void
        {
            d_imagefileRemained = d_imagesetsFromImages.length;
            if(d_imagefileRemained == 0)
            {
                loadLookNFeels();
            }
            
            var ismgr:FlameImageSetManager = FlameImageSetManager.getSingleton();
            
            // check imagesets that are created directly from image files
            for(var i:uint=0; i<d_imagesetsFromImages.length; i++)
            {
                var imageset:LoadableUIElement = d_imagesets[i];
                
                // if name is empty use the name of the image file.
                if(imageset.name.length == 0)
                {
                    imageset.name = imageset.filename;
                }
                // see if imageset is present, and create it if not.
                if (! ismgr.isDefined(imageset.name))
                {
                    ismgr.createFromImageFile(imageset.name, imageset.filename, imageset.resourceGroup, onImageFileLoaded);
                }
            }
        }
        
        private function onImageFileLoaded(tag:Object):void
        {
            d_imagefileRemained --;
            
            if(d_imagefileRemained == 0)
            {
                loadLookNFeels();
            }
        }

        
        //skip font for Flash for now
            
        /*************************************************************************
         Load all xml based fonts specified.
         *************************************************************************/
        private function loadFonts():void
        {
            var fntmgr:FlameFontManager = FlameFontManager.getSingleton();
            
            d_fontsRemained = d_fonts.length;
//            if(d_fontsRemained == 0)
//            {
//                loadLookNFeels();
//            }
//            
            // check fonts
//            for(var i:uint=0; i<d_fonts.length; i++)
//            {
//                var f:LoadableUIElement = d_fonts[i];
//                
//                // skip if a font with this name is already loaded
//                if (f.name.length !=0 && fntmgr.isDefined(f.name))
//                    continue;
//                
//                // create font using specified xml file.
//                fntmgr.create(f.filename, f.resourceGroup, onFontsLoaded);
                
//                const String realname(font.getName());
//                
//                // if name was not in scheme, set it now and proceed to next font
//                if ((*pos).name.empty())
//                {
//                    (*pos).name = realname;
//                    continue;
//                }
//                
//                // confirm the font loaded has same name specified in scheme
//                if (realname != (*pos).name)
//                {
//                    fntmgr.destroy(font);
//                    CEGUI_THROW(InvalidRequestException("Scheme::loadResources: "
//                        "The Font created by file '" + (*pos).filename +
//                        "' is named '" + realname + "', not '" + (*pos).name +
//                        "' as required by Scheme '" + d_name + "'."));
//                }
//            }
        }
        
        private function onFontsLoaded(tag:Object):void
        {
            d_fontsRemained --;
//            
//            if(d_fontsRemained == 0)
//            {
//                loadLookNFeels();
//            }
        }
        
        /*************************************************************************
         Load all xml LookNFeel files specified.
         *************************************************************************/
        private function loadLookNFeels():void
        {
            d_looknfeelRemained = d_looknfeels.length;
            if(d_looknfeelRemained == 0)
            {
                if(d_callback != null) 
                {
                    d_callback();
                }
            }
            
            var wlfmgr:FalagardWidgetLookManager = FalagardWidgetLookManager.getSingleton();
            
            // load look'n'feels
            // (we can't actually check these, at the moment, so we just re-parse data;
            // it does no harm except maybe waste a bit of time)
            for(var i:uint=0; i<d_looknfeels.length; i++)
            {
                var lnf:LoadableUIElement = d_looknfeels[i];
                
                wlfmgr.parseLookNFeelSpecification(lnf.filename, lnf.resourceGroup, onLookNFeelsLoaded);
                
                trace("load look n feel:" + lnf.filename);
            }
        }
        
        private function onLookNFeelsLoaded():void
        {
            d_looknfeelRemained --;
            
            if(d_looknfeelRemained == 0)
            {
                if(d_callback != null)
                {
                    d_callback();
                }
            }
        }
 
        /*************************************************************************
         Create all window factory aliases
         *************************************************************************/
        public function loadFactoryAliases():void
        {
            var wfmgr:FlameWindowFactoryManager = FlameWindowFactoryManager.getSingleton();
            
            // check aliases
            for(var i:uint=0; i<d_aliasMappings.length; i++)
            {
                var alias:AliasMapping = d_aliasMappings[i];
                
                if(wfmgr.hasWindowTypeAlias(alias.aliasName))
                {
                    //to do...
                    continue;
                }
                
                // create a new alias entry
                wfmgr.addWindowTypeAlias(alias.aliasName, alias.targetName);
                
                trace("load factory alias:" + alias.aliasName);
            }
        }
        
        /*************************************************************************
         Load all windowrendererset modules specified.and register factories.
         *************************************************************************/
        private function loadWindowRendererFactories():void
        {
            FlameWindowRendererManager.getSingleton().initialize();
            /*
            // check factories
            std::vector<WRModule>::iterator cmod = d_windowRendererModules.begin();
            for (;cmod != d_windowRendererModules.end(); ++cmod)
            {
                if (!(*cmod).wrModule)
                {
                    #if !defined(CEGUI_STATIC)
                    // load dynamic module as required
                    if (!(*cmod).dynamicModule)
                        (*cmod).dynamicModule = new DynamicModule((*cmod).name);
                    
                    WindowRendererModule& (*getWRModuleFunc)() =
                        reinterpret_cast<WindowRendererModule&(*)()>(
                            (*cmod).dynamicModule->
                            getSymbolAddress("getWindowRendererModule"));
                    
                    if (!getWRModuleFunc)
                        CEGUI_THROW(InvalidRequestException(
                            "Scheme::loadWindowRendererFactories: Required function "
                            "export 'WindowRendererModule& getWindowRendererModule()' "
                            "was not found in module '" + (*cmod).name + "'."));
                    
                    // get the WindowRendererModule object for this module.
                    (*cmod).wrModule = &getWRModuleFunc();
                    #else
                    (*cmod).wrModule = &getWindowRendererModule();
                    #endif
                }
                
                // see if we should just register all factories available in the module
                // (i.e. No factories explicitly specified)
                if ((*cmod).wrTypes.size() == 0)
                {
                    Logger::getSingleton().logEvent("No window renderer factories "
                        "specified for module '" +
                        (*cmod).name + "' - adding all "
                        "available factories...");
                    (*cmod).wrModule->registerAllFactories();
                }
                    // some names were explicitly given, so only register those.
                else
                {
                    std::vector<String>::const_iterator elem = (*cmod).wrTypes.begin();
                    for (; elem != (*cmod).wrTypes.end(); ++elem)
                        (*cmod).wrModule->registerFactory(*elem);
                }
            }
            */
        }
        
        /*************************************************************************
         Load all windowset modules specified.and register factories.
         *************************************************************************/
        public function loadWindowFactories():void
        {
            /*
            WindowFactoryManager& wfmgr = WindowFactoryManager::getSingleton();
            
            // check factories
            std::vector<UIModule>::iterator cmod = d_widgetModules.begin();
            for (;cmod != d_widgetModules.end(); ++cmod)
            {
                // create and load dynamic module as required
                if (!(*cmod).module)
                {
                    (*cmod).module = new FactoryModule((*cmod).name);
                }
                
                // see if we should just register all factories available in the module (i.e. No factories explicitly specified)
                if ((*cmod).factories.size() == 0)
                {
                    Logger::getSingleton().logEvent("No window factories specified for module '" + (*cmod).name + "' - adding all available factories...");
                    (*cmod).module->registerAllFactories();
                }
                    // some names were explicitly given, so only register those.
                else
                {
                    std::vector<UIElementFactory>::const_iterator   elem = (*cmod).factories.begin();
                    for (; elem != (*cmod).factories.end(); ++elem)
                    {
                        if (!wfmgr.isFactoryPresent((*elem).name))
                        {
                            (*cmod).module->registerFactory((*elem).name);
                        }
                    }
                }
            }
            */
        }

        
        /*************************************************************************
         Create all required falagard mappings
         *************************************************************************/
        private function loadFalagardMappings():void
        {
            var wfmgr:FlameWindowFactoryManager = FlameWindowFactoryManager.getSingleton();
            
            // check falagard window mappings.
            for(var i:uint=0; i<d_falagardMapping.length; i++)
            {
                var fm:FalagardMapping = d_falagardMapping[i];
                
                // if the mapping exists
                if(wfmgr.isFalagardMappedType(fm.windowName))
                {
                    // check if the current target and looks and window renderer match
                    var fwm:FalagardWindowMapping = wfmgr.getFalagardMappingForType(fm.windowName);
                    if(fwm.d_baseType == fm.targetName &&
                        fwm.d_rendererType == fm.rendererName &&
                        fwm.d_lookName == fm.lookName)
                    {
                        // assume this mapping is ours and skip to next
                        continue;
                    }
                }
                
                // create a new mapping entry
                wfmgr.addFalagardWindowMapping(fm.windowName, fm.targetName, fm.lookName, fm.rendererName, fm.effectName);
                
                trace("Load falagardmapping:" + fm.windowName + "----> " + fm.targetName + "," + 
                    fm.lookName + "," + fm.rendererName + "," + fm.effectName);
            }
        }

        
        
        
        /*!
        \brief
        Check state of all XML based imagesets created by the scheme.
        */
        public function areXMLImagesetsLoaded():Boolean
        {
            var ismgr:FlameImageSetManager = FlameImageSetManager.getSingleton();
            
            // check imagesets
            for(var i:uint=0; i<d_imagesets.length; i++){
                var iset:LoadableUIElement = d_imagesets[i];
                if(!ismgr.isLoaded(iset.name)){
                    return false;
                }
            }
            
            return true;
        }
        
        /*!
        \brief
        Check state of all image file based imagesets created by the scheme.
        */
        public function areImageFileImagesetsLoaded():Boolean
        {
            var ismgr:FlameImageSetManager = FlameImageSetManager.getSingleton();
            
            // check imagesets
            for(var i:uint=0; i<d_imagesetsFromImages.length; i++){
                var iset:LoadableUIElement = d_imagesetsFromImages[i];
                if(!ismgr.isLoaded(iset.name)){
                    return false;
                }
            }
            
            return true;
            
        }
        
        /*!
        \brief
        Check state of all xml based fonts created by the scheme.
        */
        public function areFontsLoaded():Boolean
        {
            
            //todo
            
            return true;
        }
        
        /*!
        \brief
        Check state of all looknfeel files loaded by the scheme.
        */
        public function areLookNFeelsLoaded():Boolean
        {
            return true;
        }
        
        /*!
        \brief
        Check state of all window factories registered by the scheme.
        */
        public function areWindowFactoriesLoaded():Boolean
        {
            //to be checked
            return true;
        }
        
        /*!
        \brief
        Check state of all window renderer factories registered by the scheme.
        */
        public function areWindowRendererFactoriesLoaded():Boolean
        {
            //to be checked
            return true;
        }
        
        /*!
        \brief
        Check state of all factory aliases created by the scheme.
        */
        public function areFactoryAliasesLoaded():Boolean
        {
            //to be checked 
            return true;
        }
        
        /*!
        \brief
        Check state of all falagard mappings created by the scheme.
        */
        public function areFalagardMappingsLoaded():Boolean
        {
            var wfmgr:FlameWindowFactoryManager = FlameWindowFactoryManager.getSingleton();
            
            for(var i:uint=0; i<d_falagardMapping.length; i++)
            {
                
                var fm:FalagardMapping = d_falagardMapping[i];
                
                // if the mapping exists
                if(wfmgr.isFalagardMappedType(fm.windowName))
                {
                    // check if the current target and looks and window renderer match
                    var fwm:FalagardWindowMapping = wfmgr.getFalagardMappingForType(fm.windowName);
                    if(fwm.d_baseType == fm.targetName &&
                        fwm.d_rendererType == fm.rendererName &&
                        fwm.d_effectName == fm.effectName &&
                        fwm.d_lookName == fm.lookName)
                    {
                        // assume this mapping is ours and skip to next
                        continue;
                    }
                }
                
                return false;
            }
            
            return true;
        }

        
        

    }
}