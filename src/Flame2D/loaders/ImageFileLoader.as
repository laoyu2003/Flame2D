

package Flame2D.loaders
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    
    public class ImageFileLoader
    {
        private var d_tag:Object;
        private var d_url:String;
        private var d_callback:Function;
        private var d_loader:Loader;
        
        public function ImageFileLoader(tag:Object, url:String, callback:Function)
        {
            d_tag = tag;
            d_url = url;
            d_callback = callback;
            trace("loading " + url);
            //start loading
            d_loader = new Loader();
            d_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
            d_loader.load(new URLRequest(d_url));
        }
        
        private function onComplete(e:Event):void
        {
            trace("loading complete for " + d_url);
            
            d_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
            var bitmapData:BitmapData = Bitmap(d_loader.content).bitmapData;
            d_callback(d_tag, bitmapData);
        }
    }
}