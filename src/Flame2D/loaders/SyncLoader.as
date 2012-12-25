package Flame2D.loaders
{
    import flash.display.BitmapData;
    import flash.utils.Dictionary;

    public class SyncLoader
    {
        private var d_callback:Function = null;
        private var d_jobs:uint = 0;
        private var d_count:uint = 0;
        private var d_jobMap:Dictionary = new Dictionary();
        
        //callback is final callback when all jobs done
        public function SyncLoader(callback:Function, numJobs:uint)
        {
            d_callback = callback;
            d_jobs = numJobs;
        }
        
        //type should be "Text", "Image", "ByteArray"
        //callback is load finish callback for each single item
        public function load(tag:Object, type:String, url:String, callback:Function):void
        {
            d_jobMap[tag] = callback;
            
            if(type == "Text")
            {
                new TextFileLoader(tag, url, onTextFileLoaded);
            }
            else if(type = "Image")
            {
                new ImageFileLoader(tag, url, onImageFileLoaded);
            }
        }
        
        private function onTextFileLoaded(tag:Object, str:String):void
        {
            (d_jobMap[tag] as Function)(tag, str);
            
            d_count ++;
            
            if(d_count == d_jobs)
            {
                   d_callback();
            }
        }
        
        private function onImageFileLoaded(tag:Object, bitmapData:BitmapData):void
        {
            (d_jobMap[tag] as Function)(tag, bitmapData);
            
            d_count ++;
            
            if(d_count == d_jobs)
            {
                d_callback();
            }
        }
    }
}