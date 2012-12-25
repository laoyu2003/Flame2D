package Flame2D.elements.hyperlink
{
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Vector2;

    public class FlameHyperLink
    {
        private static const  MAX_CELL_NUM:uint = 256;
        
        public var d_name:String;
        protected var d_rectBuf:Vector.<Rect> = new Vector.<Rect>(MAX_CELL_NUM);
        
        protected var d_pOwnerWindow:Vector.<FlameWindow> = new Vector.<FlameWindow>(MAX_CELL_NUM);
        
        protected var d_length:uint = 0;
        
        
        public function FlameHyperLink()
        {
            
        }
        
        public function cleanUp():void
        {
            d_name = "";
            d_length = 0;
            for(var i:uint = 0;i < MAX_CELL_NUM;i++)
            {
                var newRect:Rect = new Rect();
                d_rectBuf[i] = newRect;
                d_pOwnerWindow[i] = null;
            }
        }
        
        public function addNewRect(pOwnerWindow:FlameWindow, newRect:Rect):void
        {
            
            d_rectBuf[d_length] = newRect;
            d_pOwnerWindow[d_length] = pOwnerWindow;
            d_length++;
            
        }
        
        public function isInRange(pOwnerWindow:FlameWindow, position:Vector2, targetRect:Rect):Boolean
        {
            for(var i:uint = 0; i < MAX_CELL_NUM; i++)
            {
                var a:Boolean = d_rectBuf[i].isPointInRect(position);
                //			Window* b = d_pOwnerWindow[i]->getCaptureWindow();
                var c:Boolean = d_pOwnerWindow[i].isCapturedByThis();
                
                if(	(d_rectBuf[i].isPointInRect(position)) && 
                    //				(pOwnerWindow != NULL) &&
                    (d_pOwnerWindow[i] == pOwnerWindow))
                {
                    targetRect = d_rectBuf[i];
                    return true;
                }
            }
            return false;
        }
        
    }
}