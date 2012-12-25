

package Flame2D.core.utils
{
    import Flame2D.core.data.BatchInfo;
    import Flame2D.core.system.FlameMouseCursor;
    import Flame2D.core.system.FlameRenderingSurface;
    import Flame2D.core.system.FlameRenderingWindow;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowRenderer;
    import Flame2D.elements.window.FlameFrameWindow;
    import Flame2D.elements.window.FlameGUISheet;
    import Flame2D.renderer.FlameGeometryBuffer;
    import Flame2D.renderer.FlameRenderer;
    
    public class Misc
    {
        
        public static function PixelAligned(x:Number):Number
        {
            return x + int((x > 0 ? 0.5 : -0.5));
        }
        
        public static function getAttributeAsString(attr:String, def:String = ""):String
        {
            return attr.length != 0 ? attr : def;
        }
        
        public static function getAttributeAsInt(attr:String, def:int = 0):int
        {
            return attr.length != 0 ? int(attr.toString()) : def;
        }

        public static function getAttributeAsUint(attr:String, def:uint = 0):uint
        {
            return attr.length != 0 ? uint(attr.toString()) : def;
        }

        public static function getAttributeHexAsUint(attr:String, def:uint = 0):uint
        {
            if(attr.length != 0)
            {
                return parseInt("0x" + attr, 16);
            }
            else 
            {
                return def;
            }
        }
        
        public static function getAttributeAsNumber(attr:String, def:Number = 0):Number
        {
            return attr.length != 0 ? Number(attr.toString()) : def;
        }
        
        public static function getAttributeAsBoolean(attr:String, def:Boolean = false):Boolean
        {
            if(attr.length != 0){
                if(attr.toLowerCase() == "true") return true;
                return false;
            } else {
                return def;
            }
        }
        
        public static function cegui_absdim(x:Number):UDim
        {
            return new UDim(0, x);
        }
        
        public static function cegui_reldim(x:Number):UDim
        {
            return new UDim(x,0);
        }

        public static function swap(p1:*, p2:*):void
        {
            var tmp:* = p1;
            p1 = p2;
            p2 = tmp;
        }
        
        public static function assert(val:Boolean):void
        {
            if(!val)
            {
                throw new Error("Misc.assert failed");
            }
        }
        
        public static function random(max:uint):uint
        {
            return (uint)(Math.random() * max);
        }
        
        public static function dumpWindow(wnd:FlameWindow, recursive:Boolean = true, depth:uint = 0):void
        {
            showWindowInfo(wnd, depth);
            if(recursive)
            {
                depth ++;
                for(var i:uint=0; i<wnd.getChildCount(); i++)
                {
                    dumpWindow(wnd.getChildAt(i), recursive, depth);
                }
            }
            
        }
        
        public static function showMouseInfo():void
        {
            var cursor:FlameMouseCursor = FlameMouseCursor.getSingleton();
            trace("Mouse Cursor Position:" + cursor.getPosition().toString());
            trace("Mouse Cursor Image:" + (cursor.getImage() != null ? cursor.getImage().toString() : "null"));
            trace("Mouse Cursor Image Size:" + (cursor.getImage() != null ? cursor.getImage().getSize().toString() : "null"));
            trace("Mouse Cursor Size:" + cursor.getExplicitRenderSize().toString());
            trace("Mouse Constraint Area:" + cursor.getConstraintArea().toString());
            trace("Mouse Unified Constraint Area:" + cursor.getUnifiedConstraintArea());
            trace("Mouse Cursor Display Independent position:" + cursor.getDisplayIndependantPosition().toString());
        }
        
        public static function showWindowInfo(wnd:FlameWindow, depth:uint = 0):void
        {
            var prefix:String = "";
            for(var i:uint = 0; i<depth; i++)
            {
                prefix += "    ";
            }
            trace(prefix + "name: = " + wnd.getName());
            trace(prefix + "type/falagard type:" + wnd.getType());
            trace(prefix + "lookname:" + wnd.getLookNFeel());
            trace(prefix + "parent:" + (wnd.getParent()?wnd.getParent().getName():"null"));
            trace(prefix + "pixel size:" + wnd.getPixelSize().toString());
            trace(prefix + "area:" + wnd.getArea().toString());
            trace(prefix + "position:" + wnd.getPosition().toString());
            trace(prefix + "abs position:" + wnd.getPosition().asAbsolute(FlameRenderer.getSingleton().getDisplaySize()));
            trace(prefix + "abs size:" + wnd.getArea().asAbsolute(wnd.getPixelSize()).toString());
            trace(prefix + "min size:" + wnd.getMinSize().toString());
            trace(prefix + "max size:" + wnd.getMaxSize().toString());
            trace(prefix + "margin:" + wnd.getMargin().toString());
            trace(prefix + "outer unclipped rect:" + wnd.getUnclippedOuterRect().toString());
            trace(prefix + "inner unclipped rect:" + wnd.getUnclippedInnerRect().toString());
            trace(prefix + "outer rect clipper:" + wnd.getOuterRectClipper().toString());
            trace(prefix + "inner rect clipper:" + wnd.getInnerRectClipper());
            trace(prefix + "hit test rect:" + wnd.getHitTestRect().toString());
            dumpWindowRenderer(prefix + "[window renderer]", wnd.getWindowRenderer());
            dumpGeometryInfo(prefix + "[geometry]", wnd.getGeometryBuffer());
            dumpSurfaceInfo(prefix + "[surface]", wnd.getSurface());
            dumpSpecificInfo(prefix + "[specific info]", wnd);
            trace(prefix + "---------------------------------------");
        }
        
        public static function dumpWindowRenderer(prefix:String, wr:FlameWindowRenderer):void
        {
            if(!wr) return;
            trace(prefix + "name:" + wr.getName());
            trace(prefix + "class:" + wr.getClass());
            trace(prefix + "looknfeel:" + wr.getLookNFeel());
            trace(prefix + "unclipped inner rect:" + wr.getUnclippedInnerRect().toString());
        }
        
        public static function dumpGeometryInfo(prefix:String, geo:FlameGeometryBuffer):void
        {
            if(geo.getActiveTexture())
            {
                trace(prefix + "texture originalDataSize:" + geo.getActiveTexture().getOriginalDataSize().toString());
                trace(prefix + "texture Size:" + geo.getActiveTexture().getSize().toString());
            }
            //trace(prefix + "vertexData:" + geo.getVertexData().toString());
            for(var i:uint=0; i<geo.getVertexData().length / 9; i++)
            {
                trace(prefix + "vertex " + i + ":" + geo.getVertexData().slice(i*9, i*9 + 9).toString());
            }
            for(i=0; i<geo.getBatchCount(); i++)
            {
                var batch:BatchInfo = geo.getBatches()[i];
                trace(prefix + "batch " + i +　": length:" + batch.length + " - " + batch.texture);
            }
            trace(prefix + "clipRect:" + geo.getClipRect().toString());
            trace(prefix + "translation:" + geo.getTranslation().toString());
        }
        
        public static function dumpSurfaceInfo(prefix:String, surface:FlameRenderingSurface):void
        {
            var rwin:FlameRenderingWindow = surface as FlameRenderingWindow;
            if(! rwin) return;
            trace(prefix + "rendering window position:" + rwin.getPosition().toString());
            trace(prefix + "rendering window size:" + rwin.getSize().toString());
        }
                                    
        public static function dumpSpecificInfo(prefix:String, wnd:FlameWindow):void
        {
            if(wnd is FlameGUISheet) dumpGUISheetInfo(prefix, wnd as FlameGUISheet);
            if(wnd is FlameFrameWindow) dumpFrameWindowInfo(prefix, wnd as FlameFrameWindow);
        }
        
        public static function dumpGUISheetInfo(prefix:String, wnd:FlameGUISheet):void
        {
            trace(prefix + "Falagard Type:" + wnd.d_falagardType);
        }
        
        public static function dumpFrameWindowInfo(prefix:String, wnd:FlameFrameWindow):void
        {
            trace(prefix + "Border Size:" + wnd.getSizingBorderThickness());
        }
        
        
    }
}