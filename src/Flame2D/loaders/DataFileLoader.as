

package Flame2D.loaders
{
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLStream;
    import flash.utils.ByteArray;
    
    public class DataFileLoader
    {
        private var d_tag:Object;
        private var d_url:String;
        private var d_callback:Function;
        private var d_loader:URLStream;
        
        public function DataFileLoader(tag:Object, url:String, callback:Function)
        {
            d_tag = tag;
            d_url = url;
            d_callback = callback;
            trace("loading " + url);
            //start loading
            d_loader = new URLStream();
            d_loader.addEventListener(Event.COMPLETE, onComplete);
            d_loader.load(new URLRequest(d_url));
        }
        
        private function onComplete(e:Event):void
        {
            d_loader.removeEventListener(Event.COMPLETE, onComplete);
            var ba:ByteArray = new ByteArray();
            d_loader.readBytes(ba);
            d_callback(d_tag, ba);
            trace("loading complete for " + d_url + ", lenght:" + ba.length);
        }
    }
}