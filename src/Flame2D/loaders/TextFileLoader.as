

package Flame2D.loaders
{
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    
    public class TextFileLoader
    {
        private var d_tag:Object;
        private var d_url:String;
        private var d_callback:Function;
        private var d_loader:URLLoader;
        
        public function TextFileLoader(tag:Object, url:String, callback:Function)
        {
            trace("Loading file:" + url);
            d_tag = tag;
            d_url = url;
            d_callback = callback;
            
            //start loading
            d_loader = new URLLoader();
            d_loader.dataFormat = URLLoaderDataFormat.TEXT;
            d_loader.addEventListener(Event.COMPLETE, onComplete);
            d_loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
            d_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
            d_loader.load(new URLRequest(d_url));
        }
        
        private function onError(e:Event):void
        {
            trace("error loading file:" + d_url);
        }
        
        private function onComplete(e:Event):void
        {
            d_loader.removeEventListener(Event.COMPLETE, onComplete);
            d_loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
            d_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
            d_callback(d_tag, e.target.data);
        }
    }
}