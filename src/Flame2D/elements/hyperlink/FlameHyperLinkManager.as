package Flame2D.elements.hyperlink
{
    import Flame2D.core.events.HyperLinkEventArgs;
    import Flame2D.core.system.FlameEventSet;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Vector2;
    
    import flash.utils.Dictionary;
    
    public class FlameHyperLinkManager extends FlameEventSet
    {
        /*************************************************************************
         Constants
         *************************************************************************/
        public static const EventNamespace:String = "HyperLinkManager";						//!< Namespace for global events
        
        public static const EventHyperLinkActive:String = "HyperLinkActive";             //!< Event fired when the HyperLink is about to get activated.
        public static const EventHyperLinkLeftActive:String = "HyperLinkLeftActive";			//!< Event fired by MouseLeft Active
        public static const EventHyperLinkRightActive:String = "HyperLinkRightActive";			//!< Event fired by MouseRight Active
        public static const EventHyperLinkInactive:String = "HyperLinkInactive";           //!< Event fired when the HyperLink has been deactivated.
        public static const EventHyperLinkOutActive:String = "HyperLinkOutactive";
        
        //typedef std_map< String, HyperLink > HyperLinkNameRegistry;
        //All HyperLink
        //HyperLinkNameRegistry	d_HyperLinkNameMap;
        private var d_hyperLinkNameMap:Dictionary = new Dictionary();
        
        private var d_isInActiving:Boolean = false;
        private var d_activeRect:Rect;
        
        private var d_LastWindowName:String;
        private var d_lastContent:String;

        
        /*!
        \brief
        Constructor for HyperLinkManager objects
        */
        public function FlameHyperLinkManager():void
        {
            
        }

        /*************************************************************************
         Destroys the Animate with the specified name
         *************************************************************************/
        public function destroyHyperLink(name:String):void
        {
            if(d_hyperLinkNameMap.hasOwnProperty(name))
            {
                d_hyperLinkNameMap[name].CleanUp();
                
                delete d_hyperLinkNameMap[name];
            }
        }
            
            
        /*************************************************************************
         Destroys all Animate objects registered in the system
         *************************************************************************/
        public function destroyAllHyperLink():void
        {
            d_hyperLinkNameMap = new Dictionary();
        }
                
                
        public function addHyperLink(OwnerWindow:FlameWindow, name:String, hyper_rect:Rect):void
        {
            // first ensure name uniqueness
            
            //HyperLinkNameRegistry::iterator pos = d_HyperLinkNameMap.find(name);
            
            if (d_hyperLinkNameMap.hasOwnProperty(name))
            {
                d_hyperLinkNameMap[name].addNewRect(OwnerWindow,hyper_rect);
            }
            else
            {
                var newHyperLink:FlameHyperLink = new FlameHyperLink();
                newHyperLink.cleanUp();
                newHyperLink.d_name = name;
                newHyperLink.addNewRect(OwnerWindow,hyper_rect);
                
                d_hyperLinkNameMap[name] = newHyperLink;
            }
            return;
        }
                
        public function isHyperLinkRange(pOwnerWindow:FlameWindow, position:Vector2)
        {
            //HyperLinkNameRegistry::const_iterator itCur, itEnd;
            var nHyperLink:FlameHyperLink;
            
            for(nHyperLink in d_hyperLinkNameMap)
            {
                if(nHyperLink.isInRange(pOwnerWindow,position, d_activeRect))
                {
                    if(d_isInActiving)
                    {
                        var e:HyperLinkEventArgs = new HyperLinkEventArgs(d_LastWindowName, d_lastContent);
                        fireEvent(EventHyperLinkOutActive, e, EventNamespace);
                        d_isInActiving = false;
                        d_LastWindowName = "";
                        d_lastContent = "";
                    }
                    
                    d_isInActiving = true;
                    if(pOwnerWindow.getName() == d_LastWindowName 
                        && d_lastContent == nHyperLink.d_name)
                    {
                        return true;
                    }
                    else
                    {
                        var e2:HyperLinkEventArgs = new HyperLinkEventArgs(pOwnerWindow.getName(), nHyperLink.d_name);
                        fireEvent(EventHyperLinkInactive, e, EventNamespace);
                        
                        d_LastWindowName = pOwnerWindow.getName();
                        d_lastContent = nHyperLink.d_name;
                        return true;
                    }
                }
            }
            
            if(d_isInActiving)
            {
                if(!d_activeRect.isPointInRect(position))
                {
                    //HyperLinkEventArgs e(pOwnerWindow->getName(), "");
                    var e3:HyperLinkEventArgs = new HyperLinkEventArgs(d_LastWindowName, d_lastContent);
                    fireEvent(EventHyperLinkOutActive, e, EventNamespace);
                    d_isInActiving = false;
                    d_LastWindowName = "";
                    d_lastContent = "";
                }
            }
            
            return false;
        }
                    
        public function getHyperLinkContex(pOwnerWindow:FlameWindow, position:Vector2):String
        {
            var nHyperLink:FlameHyperLink;
            
            for(nHyperLink in d_hyperLinkNameMap)
            {
                if(nHyperLink.isInRange(pOwnerWindow,position, d_activeRect))
                {
                    var e:HyperLinkEventArgs = new HyperLinkEventArgs(pOwnerWindow.getName(), nHyperLink.d_name);
                    return nHyperLink.d_name;
                }
            }
            return "";
        }
                        
        public function doHyperLink(pOwnerWindow:FlameWindow, position:Vector2):Boolean
        {
            var nHyperLink:FlameHyperLink;
            
            for(nHyperLink in d_hyperLinkNameMap)
            {
                if(nHyperLink.isInRange(pOwnerWindow,position, d_activeRect))
                {
                    var e:HyperLinkEventArgs = new HyperLinkEventArgs(pOwnerWindow.getName(), nHyperLink.d_name);
                    
                    fireEvent(EventHyperLinkActive, e, EventNamespace);
                    return true;
                }
            }
            return false;
        }
        
        public function doHyperLinkByMouseLeft(pOwnerWindow:FlameWindow, position:Vector2):Boolean
        {
            var nHyperLink:FlameHyperLink;
            
            for(nHyperLink in d_hyperLinkNameMap)
            {
                if(nHyperLink.isInRange(pOwnerWindow,position, d_activeRect))
                {
                    var e:HyperLinkEventArgs = new HyperLinkEventArgs(pOwnerWindow.getName(), nHyperLink.d_name);
                    
                    fireEvent(EventHyperLinkLeftActive, e, EventNamespace);
                    return true;
                }
            }
            
            return false;
        }
            
        public function doHyperLinkByMouseRight(pOwnerWindow:FlameWindow, position:Vector2):Boolean
        {
            var nHyperLink:FlameHyperLink;
            
            for(nHyperLink in d_hyperLinkNameMap)
            {
                if(nHyperLink.isInRange(pOwnerWindow,position, d_activeRect))
                {
                    var e:HyperLinkEventArgs = new HyperLinkEventArgs(pOwnerWindow.getName(), nHyperLink.d_name);
                    
                    fireEvent(EventHyperLinkRightActive, e, EventNamespace);
                    return true;
                }
            }
            return false;
            
        }
    
    }
}