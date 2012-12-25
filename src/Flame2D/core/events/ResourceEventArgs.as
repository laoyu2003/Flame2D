
//! EventArgs based class that is used for notifications regarding resources.

package Flame2D.core.events
{

    public class ResourceEventArgs extends EventArgs
    {
        public var resourceType:String = "";//! String identifying the resource type this notification is about.
        public var resourceName:String = ""; //! String identifying the name of the resource this notification is about.
        
        public function ResourceEventArgs(type:String, name:String)
        {
            this.resourceType = type;
            this.resourceName = name;
        }
        
    }
}
