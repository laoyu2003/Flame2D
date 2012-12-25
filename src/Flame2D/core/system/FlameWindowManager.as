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
    import Flame2D.core.data.FalagardWindowMapping;
    import Flame2D.core.effects.FlameRenderEffectManager;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.utils.Misc;
    import Flame2D.elements.button.FlameCheckbox;
    import Flame2D.loaders.TextFileLoader;
    
    import flash.utils.Dictionary;

    /*!
    \brief
    The WindowManager class describes an object that manages creation and lifetime of Window objects.
    
    The WindowManager is the means by which Window objects are created and destroyed.  For each sub-class
    of Window that is to be created, there must exist a WindowFactory object which is registered with the
    WindowFactoryManager.  Additionally, the WindowManager tracks every Window object created, and can be
    used to access those Window objects by name.
    */
    public class FlameWindowManager extends FlameEventSet
    {
        /*************************************************************************
         Public static data
         *************************************************************************/
        public static var d_defaultResourceGroup:String;
        public static var GeneratedWindowNameBase:String = "__cewin_uid_";      //!< Base name to use for generated window names.

        //! Namespace for global events.
        public static var EventNamespace:String = "WindowManager";
        
        /** Event fired when a new Window object is created.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Window that has just been created.
         */
        public static var EventWindowCreated:String = "WindowCreated";
        /** Event fired when a Window object is destroyed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Window that has been destroyed.
         */
        public static var EventWindowDestroyed:String = "WindowDestroyed";
        
        //typedef std::map<String, Window*, String::FastLessCompare>			WindowRegistry;				//!< Type used to implement registry of Window objects
        //typedef std::vector<Window*>    WindowVector;   //!< Type to use for a collection of Window pointers.
        
        //WindowRegistry			d_windowRegistry;			//!< The container that forms the Window registry
        //WindowVector    d_deathrow;     //!< Collection of 'destroyed' windows.
        
        private var d_windowRegistry:Dictionary = new Dictionary();
        private var d_deathrow:Vector.<FlameWindow> = new Vector.<FlameWindow>(); 
        
        private var d_uid_counter:uint = 0;  //!< Counter used to generate unique window names.
        private var d_lockCount:uint = 0;    //! count of times WM is locked against new window creation.
        
        
        //singleton
        private static var d_singleton:FlameWindowManager = new FlameWindowManager();
        
        //pool of layout window:name - window mapping
        private var _layoutPool:Dictionary = new Dictionary();
        
        
        
        
        /*************************************************************************
         Construction
         *************************************************************************/
        /*!
        \brief
        Constructs a new WindowManager object.
        
        NB: Client code should not create WindowManager objects - they are of limited use to you!  The
        intended pattern of access is to get a pointer to the GUI system's WindowManager via the System
        object, and use that.
        */
        public function FlameWindowManager()
        {
            if(d_singleton){
                throw new Error("FlameWindowManager: init only once");
            }
        }
        
        
        public function dispose():void
        {
            destroyAllWindows();
            cleanDeadPool();
            
            trace("CEGUI::WindowManager singleton destroyed.");
        }
        
        
        public static function getSingleton():FlameWindowManager
        {
            return d_singleton;
        }
        
        
        public function initialize():void
        {
            //to do
        }
        
        
        /*************************************************************************
         Window Related Methods
         *************************************************************************/
        /*!
        \brief
        Creates a new Window object of the specified type, and gives it the specified unique name.
        
        \param type
        String that describes the type of Window to be created.  A valid WindowFactory for the specified type must be registered.
        
        \param name
        String that holds a unique name that is to be given to the new window.  If this string is empty (""), a name
        will be generated for the window.
        
        \return
        Pointer to the newly created Window object.
        
        \exception  InvalidRequestException WindowManager is locked and no Windows
        may be created.
        \exception	AlreadyExistsException		A Window object with the name \a name already exists.
        \exception	UnknownObjectException		No WindowFactory is registered for \a type Window objects.
        \exception	GenericException			Some other error occurred (Exception message has details).
        */
        public function createWindow(type:String, name:String = ""):FlameWindow
        {
            // only allow creation of Window objects if we are in unlocked state
            if (isLocked()){
                throw new Error("WindowManager::createWindow - " +
                    "WindowManager is in the locked state.");
            }
            
            var finalName:String = (name.length == 0 ? generateUniqueWindowName() : name);
            
            if (isWindowPresent(finalName))
            {
                throw new Error("WindowManager::createWindow - A Window object with the name '" + 
                    finalName +"' already exists within the system.");
            }
            
            var wfMgr:FlameWindowFactoryManager = FlameWindowFactoryManager.getSingleton();
            var factory:FlameWindowFactory = wfMgr.getFactory(type);
            
            var newWindow:FlameWindow = factory.createWindow(finalName) as FlameWindow;
            
            
            d_windowRegistry[finalName] = newWindow;

            // see if we need to assign a look to this window
            if (wfMgr.isFalagardMappedType(type))
            {
                var fwm:FalagardWindowMapping = wfMgr.getFalagardMappingForType(type);
                // this was a mapped type, so assign a look to the window so it can finalise
                // its initialisation
                newWindow.d_falagardType = type;
                newWindow.setWindowRenderer(fwm.d_rendererType);
                newWindow.setLookNFeel(fwm.d_lookName);
                
                //initialiseRenderEffect(newWindow, fwm.d_effectName);
            }
            
            // fire event to notify interested parites about the new window.
            var args:WindowEventArgs = new WindowEventArgs(newWindow);
            fireEvent(EventWindowCreated, args, EventNamespace);
            
            
            //trace("Window '" + finalName +"' of type '" + type + "' has been created. ");
            return newWindow;
        }
        
        
        /*!
        \brief
        Destroy the specified Window object.
        
        \param window
        Pointer to the Window object to be destroyed.  If the \a window is null, or is not recognised, nothing happens.
        
        \return
        Nothing
        
        \exception	InvalidRequestException		Can be thrown if the WindowFactory for \a window's object type was removed.
        */
        public function destroyWindow(window:FlameWindow):void
        {
            if (window)
            {
                // this is done because the name is used for the log after the window is destroyed,
                // if we just did getName() we would get a const ref to the Window's internal name
                // string which is destroyed along with the window so wouldn't exist when the log tried
                // to use it (as I soon discovered).
                var name:String = window.getName();
                
                destroyWindowByName(name);
            }
        }
        
        
        
        /*!
        \brief
        Destroy the specified Window object.
        
        \param
        window	String containing the name of the Window object to be destroyed.  If \a window is not recognised, nothing happens.
        
        \return
        Nothing.
        
        \exception	InvalidRequestException		Can be thrown if the WindowFactory for \a window's object type was removed.
        */
        public function destroyWindowByName(window:String):void
        {
            if(d_windowRegistry.hasOwnProperty(window))
            {
                var wnd:FlameWindow = d_windowRegistry[window];
                
                // remove entry from the WindowRegistry.
                delete d_windowRegistry[window];
                
                // do 'safe' part of cleanup
                wnd.destroy();
                
                // add window to dead pool
                d_deathrow.push(wnd);
                
                // notify system object of the window destruction
                FlameSystem.getSingleton().notifyWindowDestroyed(wnd);
                
                trace("Window '" + window + "' has been added to dead pool. ");
                
                // fire event to notify interested parites about window destruction.
                // TODO: Perhaps this should fire first, so window is still usable?
                var args:WindowEventArgs = new WindowEventArgs(wnd);
                fireEvent(EventWindowDestroyed, args, EventNamespace);
            }

        }
        
        
        /*!
        \brief
        Return a pointer to the specified Window object.
        
        \param name
        String holding the name of the Window object to be returned.
        
        \return
        Pointer to the Window object with the name \a name.
        
        \exception UnknownObjectException	No Window object with a name matching \a name was found.
        */
        public function getWindow(name:String):FlameWindow
        {
            if(! d_windowRegistry.hasOwnProperty(name))
            {
                throw new Error("WindowManager::getWindow - A Window object with the name '" + 
                    name +"' does not exist within the system");
            }
            
            return d_windowRegistry[name];
        }

        
        /*!
        \brief
        Examines the list of Window objects to see if one exists with the given name
        
        \param name
        String holding the name of the Window object to look for.
        
        \return
        true if a Window object was found with a name matching \a name.  false if no matching Window object was found.
        */
        public function isWindowPresent(name:String):Boolean
        {
            return (d_windowRegistry.hasOwnProperty(name));
        }
        
        
        /*!
        \brief
        Destroys all Window objects within the system
        
        \return
        Nothing.
        
        \exception	InvalidRequestException		Thrown if the WindowFactory for any Window object type has been removed.
        */
        public function destroyAllWindows():void
        {
            
            //to be checked
            for(var name:String in d_windowRegistry)
            {
                destroyWindowByName(name);
            }
            for(var key:String in d_windowRegistry)
            {
                destroyWindowByName(key);
            }
            
            
            d_windowRegistry = new Dictionary();
        }

        /*!
        \brief
        Creates a set of windows (a Gui layout) from the information in the specified XML file.	
        
        \param filename
        String object holding the filename of the XML file to be processed.
        
        \param name_prefix
        String object holding the prefix that is to be used when creating the windows in the layout file, this
        function allows a layout to be loaded multiple times without having name clashes.  Note that if you use
        this facility, then all windows defined within the layout must have names assigned; you currently can not
        use this feature in combination with automatically generated window names.
        
        \param resourceGroup
        Resource group identifier to be passed to the resource provider when loading the layout file.
        
        \param callback
        PropertyCallback function to be called for each Property element loaded from the layout.  This is
        called prior to the property value being applied to the window enabling client code manipulation of
        properties.
        
        \param userdata
        Client code data pointer passed to the PropertyCallback function.
        
        \return
        Pointer to the root Window object defined in the layout.
        
        \exception FileIOException			thrown if something goes wrong while processing the file \a filename.
        \exception InvalidRequestException	thrown if \a filename appears to be invalid.
        */
        //	Window*	loadWindowLayout(const String& filename, const String& name_prefix = "", 
                //const String& resourceGroup = "", PropertyCallback* callback = 0, void* userdata = 0);

        public function loadWindowLayoutFromString(str:String, name_prefix:String = "",
                resourceGroup:String = "", callback:Function = null, userdata:* = null):FlameWindow
        {
            //parse xml
            var xml:XML = new XML(str);
            var rootNode:XML = xml.Window[0];
            //parse window attributes
            var winType:String = rootNode.@Type.toString();
            var winName:String = rootNode.@Name.toString();
            
            var window:FlameWindow = createWindow(winType, name_prefix + winName);
            
            parseWindow(window, name_prefix, rootNode);

            return window;
        }
        
        
        public function loadWindowLayout(name:String, name_prefix:String = "", callback:Function = null, userdata:* = null):void
        {
            var url:String = FlameResourceProvider.getSingleton().getResourceDir() + 
                             FlameResourceProvider.getSingleton().getLayoutDir() + 
                             name + ".layout.xml";

            //check repeated url
            if(_layoutPool.hasOwnProperty(name)){
                trace("Layout window " + url + " has already been loaded.");
                return;
            }
            
            this._layoutPool[url] = null;
            
            //load url
            new TextFileLoader({name:name, prefix:name_prefix}, url, onLayoutLoaded);
        }
        
        private function onLayoutLoaded(tag:Object, str:String):void
        {
            //trace("file:" + str);
            var name:String = tag.name;
            
            //parse xml
            var xml:XML = new XML(str);
            var rootNode:XML = xml.Window[0];
            //parse window attributes
            var winType:String = rootNode.@Type.toString();
            var winName:String = rootNode.@Name.toString();
            
            var window:FlameWindow = createWindow(winType, tag.prefix + winName);
            
            parseWindow(window, tag.prefix, rootNode);
        }
        
        private function parseWindow(window:FlameWindow, name_prefix:String, root:XML):void
        {
            var node:XML;
            
            //parse properties
            var nodes:XMLList = root.Property;
            for each(node in nodes){
                var propertyName:String = node.@Name.toString();
                var propertyValue:String;
                if(node.hasOwnProperty("@Value"))
                {
                    propertyValue = node.@Value.toString();
                }
                else
                {
                    //this is usually for a text block
                    //better to change to CDATA
                    propertyValue = node.toString();
                }
                trace("Set property:" + propertyName + " ~~~~~ " + propertyValue);
                
                window.setProperty(propertyName, propertyValue);
            }
            
            //parse events
            nodes = root.Event;
            for each(node in nodes){
                var eventName:String = node.@Name.toString();
                var eventFunction:String = node.@Function.toString();
                
                window.setEvent(eventName, eventFunction);
            }
            //we do not parse the following: autowindow, layoutimport...todo
            
            //window.beginInitialisation();
            
            //parse following windows, if any
            nodes = root.Window;
            for each(node in nodes){
                var winType:String = node.@Type.toString();
                var winName:String = node.@Name.toString();
                
                var subWindow:FlameWindow = createWindow(winType, name_prefix + winName);
                
                //attach to parent
                window.addChildWindow(subWindow);
                //trace("parsing window:" + winType + " -- " + winName);

                parseWindow(subWindow, name_prefix, node);
            }
            
        }
        
        
        /*!
        \brief
        Return whether the window dead pool is empty.
        
        \return
        - true if there are no windows in the dead pool.
        - false if the dead pool contains >=1 window awaiting destruction.
        */
        public function isDeadPoolEmpty():Boolean
        {
            return d_deathrow.length == 0;
        }
        
        /*!
        \brief
        Permanently destroys any windows placed in the dead pool.
        
        \note
        It is probably not a good idea to call this from a Window based event handler
        if the specific window has been or is being destroyed.
        
        \return
        Nothing.
        */
        public function cleanDeadPool():void
        {
            for(var i:uint=0; i<d_deathrow.length; i++)
            {
                var wnd:FlameWindow = d_deathrow[i];
                var factory:FlameWindowFactory = FlameWindowFactoryManager.getSingleton().getFactory(wnd.getType());
                factory.destroyWindow(wnd);
            }
            
            // all done here, so clear all pointers from dead pool
            d_deathrow.length = 0;
            /*
            WindowVector::reverse_iterator curr = d_deathrow.rbegin();
            for (; curr != d_deathrow.rend(); ++curr)
            {
                // in debug mode, log what gets cleaned from the dead pool (insane level)
                #if defined(DEBUG) || defined (_DEBUG)
                CEGUI_LOGINSANE("Window '" + (*curr)->getName() + "' about to be finally destroyed from dead pool.");
                #endif
                
                WindowFactory* factory = WindowFactoryManager::getSingleton().getFactory((*curr)->getType());
                factory->destroyWindow(*curr);
            }
            
            // all done here, so clear all pointers from dead pool
            d_deathrow.clear();
            */
        }
        
        
        /*!
        \brief
        Rename a window.
        
        \param window
        String holding the current name of the window to be renamed.
        
        \param new_name
        String holding the new name for the window
        
        \exception UnknownObjectException
        thrown if \a window is not known in the system.
        
        \exception AlreadyExistsException
        thrown if a Window named \a new_name already exists.
        */
        public function renameWindow(window:String, new_name:String):void
        {
            renameWindowByWindow(getWindow(window), new_name);
        }
        
        /*!
        \brief
        Rename a window.
        
        \param window
        Pointer to the window to be renamed.
        
        \param new_name
        String holding the new name for the window
        
        \exception AlreadyExistsException
        thrown if a Window named \a new_name already exists.
        */
        public function renameWindowByWindow(window:FlameWindow, new_name:String):void
        {
            if (window)
            {
                if(d_windowRegistry.hasOwnProperty(window.getName()))
                {
                    // erase old window name from registry
                    delete d_windowRegistry[window.getName()];
                    
                    try
                    {
                        // attempt to rename the window
                        window.rename(new_name);
                    }
                    // rename fails if target name already exists
                    catch (error:Error)
                    {
                        // re-add window to registry under it's old name
                        d_windowRegistry[window.getName()] = window;
                        // rethrow exception.
                        throw new Error("WindowManager:rename window: name already exist");
                    }
                    
                    // add window to registry under new name
                    d_windowRegistry[new_name] = window;
                }
            }
        }
        
        /*!
        \brief
        Returns the default resource group currently set for layouts.
        
        \return
        String describing the default resource group identifier that will be
        used when loading layouts.
        */
        public static function getDefaultResourceGroup():String
        { 
            return d_defaultResourceGroup; 
        }
        
        /*!
        \brief
        Sets the default resource group to be used when loading layouts
        
        \param resourceGroup
        String describing the default resource group identifier to be used.
        
        \return
        Nothing.
        */
        public static function setDefaultResourceGroup(resourceGroup:String):void
        {
            d_defaultResourceGroup = resourceGroup;
        }
        
        /*!
        \brief
        Put WindowManager into the locked state.
        
        While WindowManager is in the locked state all attempts to create a
        Window of any type will fail with an InvalidRequestException being
        thrown.  Calls to lock/unlock are recursive; if multiple calls to lock
        are made, WindowManager is only unlocked after a matching number of
        calls to unlock.
        
        \note
        This is primarily intended for internal use within the system.
        */
        protected function lock():void
        {
            ++d_lockCount;
        }
        
        /*!
        \brief
        Put WindowManager into the unlocked state.
        
        While WindowManager is in the locked state all attempts to create a
        Window of any type will fail with an InvalidRequestException being
        thrown.  Calls to lock/unlock are recursive; if multiple calls to lock
        are made, WindowManager is only unlocked after a matching number of
        calls to unlock.
        
        \note
        This is primarily intended for internal use within the system.
        */
        protected function unlock():void
        {
            if (d_lockCount > 0)
                --d_lockCount;
        }
        
        /*!
        \brief
        Returns whether WindowManager is currently in the locked state.
        
        While WindowManager is in the locked state all attempts to create a
        Window of any type will fail with an InvalidRequestException being
        thrown.  Calls to lock/unlock are recursive; if multiple calls to lock
        are made, WindowManager is only unlocked after a matching number of
        calls to unlock.
        
        \return
        - true to indicate WindowManager is locked and that any attempt to
        create Window objects will fail.
        - false to indicate WindowManager is unlocked and that Window objects
        may be created as normal.
        */
        public function isLocked():Boolean
        {
            return d_lockCount != 0;
        }
        
        
        /*!
        \brief
        Implementation method to generate a unique name to use for a window.
        */
        private function generateUniqueWindowName():String
        {
            // build name
            var uidname:String = GeneratedWindowNameBase + d_uid_counter;
            
            // update counter for next time
            var old_uid:uint = d_uid_counter;
            ++d_uid_counter;
            
            // log if we ever wrap-around (which should be pretty unlikely)
            if (d_uid_counter < old_uid)
            {
                trace("UID counter for generated window names has wrapped around - the fun shall now commence!");
            }
            // return generated name as a CEGUI::String.
            return uidname;
        }
        
        //! function to set up RenderEffect on a window
        private function initialiseRenderEffect(wnd:FlameWindow, effect:String):void
        {
            // nothing to do if effect is empty string
            if (effect.length == 0)
                return;
            
            // if requested RenderEffect is not available, log that and continue
            if (!FlameRenderEffectManager.getSingleton().isEffectAvailable(effect))
            {
                trace("Missing RenderEffect '" + effect + "' requested for " +
                    "window '" + wnd.getName() + "' - continuing without effect...");
                
                return;
            }
            
            // If we do not have a RenderingSurface, enable AutoRenderingSurface to
            // try and create one
            if (!wnd.getRenderingSurface())
            {
                trace("Enabling AutoRenderingSurface on '" +
                    wnd.getName() + "' for RenderEffect support.");
                
                wnd.setUsingAutoRenderingSurface(true);
            }
            
            // If we have a RenderingSurface and it's a RenderingWindow
            if (wnd.getRenderingSurface() &&
                wnd.getRenderingSurface().isRenderingWindow())
            {
                // Set an instance of the requested RenderEffect
                FlameRenderingWindow(wnd.getRenderingSurface()).
                    setRenderEffect(FlameRenderEffectManager.getSingleton().
                        create(effect));
            }
            // log fact that we could not get a usable RenderingSurface
            else
            {
                trace("Unable to set effect for window '" +
                    wnd.getName() + "' since RenderingSurface is either missing " +
                    "or of wrong type (i.e. not a RenderingWindow).");
            }
        }
        
        public function invalidateAllWindows():void
        {
            for(var key:String in d_windowRegistry)
            {
                var wnd:FlameWindow = d_windowRegistry[key];
                
                wnd.invalidate();
                
                var rs:FlameRenderingSurface = wnd.getRenderingSurface();
                if(rs && rs.isRenderingWindow())
                {
                    (rs as FlameRenderingWindow).invalidateGeometry();
                }
            }
        }
        
    }
}