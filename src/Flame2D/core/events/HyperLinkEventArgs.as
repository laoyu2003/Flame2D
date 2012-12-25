package Flame2D.core.events
{
    public class HyperLinkEventArgs
    {
        public var windowName:String;
        public var hyperLinkName:String;

        public function HyperLinkEventArgs(winName:String, hyperName:String)
        {
            windowName = winName;
            hyperLinkName = hyperName;
        }
        
        /*!
        \brief
        Check event type name.
        */
//        protected function isKindOf(strClassName:String):Boolean 
//        { 
//            return strClassName=="HyperLink" ? true: EventArgs.isKindOf(strClassName);
//        }
        
    }
}