
package Flame2D.core.properties
{
    import Flame2D.core.utils.Colour;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.UBox;
    import Flame2D.core.utils.UDim;
    import Flame2D.core.utils.URect;
    import Flame2D.core.utils.UVector2;
    import Flame2D.core.utils.Vector2;
    import Flame2D.core.utils.Vector3;
    
    import flash.system.ImageDecodingPolicy;
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.system.FlameImageSetManager;
    
    public class FlamePropertyHelper
    {
        
        public static function stringToFloat(str:String):Number
        {
            var tr:String = str.replace(/f/g, "")
            return Number(tr);
        }
            
            
        public static function stringToUint(str:String):uint
        {
            return uint(str);
        }
                
                
        public static function stringToInt(str:String):int
        {
            return int(str);
        }
                    
                    
        public static function stringToBool(str:String):Boolean
        {
            if(str.toLowerCase() == "true"){
                return true;
            }
            else
            {
                return false;
            }
        }
                        
                        
        public static function stringToSize(str:String):Size
        {
            //w:%g h:%g
            var arr:Array = str.split(" ");
            if(arr.length != 2) return new Size(0,0);
            var sw:String = arr[0];
            var arrw:Array = sw.split(":");
            
            var sh:String = arr[1];
            var arrh:Array = sh.split(":");
            
            return new Size(stringToFloat(arrw[1]), stringToFloat(arrh[1]));
        }
                            
                            
        public static function stringToVector2(str:String):Vector2
        {
            //x:%g y:%g
            var arr:Array = str.split(" ");
            if(arr.length != 2) return new Vector2(0,0);

            var sx:String = arr[0];
            var arrx:Array = sx.split(":");
            
            var sy:String = arr[1];
            var arry:Array = sy.split(":");
            
            return new Vector2(stringToFloat(arrx[1]), stringToFloat(arry[1]));
        }
                                
                                
        public static function stringToRect(str:String):Rect
        {
            //l:%g t:%g r:%g b:%g
            var arr:Array = str.split(" ");
            if(arr.length != 4) return new Rect(0,0,0,0);
            
            var sl:String = arr[0];
            var arrl:Array = sl.split(":");
            var nl:Number = Number(arrl[1]);
            
            var st:String = arr[1];
            var arrt:Array = st.split(":");
            var nt:Number = Number(arrt[1]);

            var sr:String = arr[2];
            var arrr:Array = sr.split(":");
            var nr:Number = Number(arrr[1]);
            
            var sb:String = arr[3];
            var arrb:Array = sb.split(":");
            var nb:Number = Number(arrb[1]);
            
            return new Rect(nl, nt, nr, nb);
        }
        
        
        public static function stringToImage(str:String):FlameImage
        {
            //set:%127s image:%127s
            //var tr:String = str.replace(/^'|'$/g, "");
            if(str.length == 0) return null;
            
            var arr:Array = str.split(" ");
            if(arr.length != 2) return null;
            
            var sets:String = arr[0];
            var seta:Array = sets.split(":");
            var set:String = seta[1];
            var images:String = arr[1];
            var imagea:Array = images.split(":");
            var image:String = imagea[1];
            
            return FlameImageSetManager.getSingleton().getImageSet(set).getImage(image);
        }
                                        
        public static function stringToUDim(str:String):UDim
        {
            //{ %g , %g }
            var tr:String = str.replace(/{/g, "").replace(/}/g, "").replace(/ /g, "");
            var arr:Array = tr.split(",");
            var scales:String = arr[0];
            var scale:Number = Number(scales);
            var offsets:String = arr[1];
            var offset:Number = Number(offsets);
            
            return new UDim(scale, offset);
        }
                                            
        public static function stringToUVector2(str:String):UVector2
        {
            //{ { %g , %g } , { %g , %g } }
            var tr:String = str.replace(/{/g, "").replace(/}/g, "").replace(/ /g, "");
            var arr:Array = tr.split(",");
            var xscale:Number = Number(arr[0]);
            var xoffset:Number = Number(arr[1]);
            var yscale:Number = Number(arr[2]);
            var yoffset:Number = Number(arr[3]);
            
            return new UVector2(new UDim(xscale, xoffset), new UDim(yscale, yoffset));
        }
                                            
                                                
        public static function stringToURect(str:String):URect
        {
            //{ { %g , %g } , { %g , %g } , { %g , %g } , { %g , %g } }
            var tr:String = str.replace(/{/g, "").replace(/}/g, "").replace(/ /g, "");
            var arr:Array = tr.split(",");
            var minxscale:Number = Number(arr[0]);
            var minxoffset:Number = Number(arr[1]);
            var minyscale:Number = Number(arr[2]);
            var minyoffset:Number = Number(arr[3]);
            
            var maxxscale:Number = Number(arr[4]);
            var maxxoffset:Number = Number(arr[5]);
            var maxyscale:Number = Number(arr[6]);
            var maxyoffset:Number = Number(arr[7]);
            
            return new URect(new UVector2(new UDim(minxscale, minxoffset), new UDim(minyscale, minyoffset)),
                             new UVector2(new UDim(maxxscale, maxxoffset), new UDim(maxyscale, maxyoffset)));
        }
                                                    
        public static function stringToUBox(str:String):UBox
        {
            //" { top: { %g , %g } , left: { %g , %g } , bottom: { %g , %g } , right: { %g , %g } }"
            var tr:String = str.replace(/top:/g, "").replace(/left:/g, "").replace(/bottom:/g, "").replace(/right:/g, "").
                                replace(/{/g, "").replace(/}/g, "").replace(/ /g, "");
            var arr:Array = tr.split(",");
            var topscale:Number = Number(arr[0]);
            var topoffset:Number = Number(arr[1]);
            var leftscale:Number = Number(arr[2]);
            var leftoffset:Number = Number(arr[3]);
            var bottomscale:Number = Number(arr[4]);
            var bottomoffset:Number = Number(arr[5]);
            var rightscale:Number = Number(arr[6]);
            var rightoffset:Number = Number(arr[7]);
            
            return new UBox(new UDim(topscale, topoffset),
                new UDim(leftscale, leftoffset),
                new UDim(bottomscale, bottomoffset),
                new UDim(rightscale, rightoffset));
        }
                                                        
                                                        
        public static function floatToString(val:Number):String
        {
            return String(val);
        }
        
        
        public static function uintToString(val:uint):String
        {
            return String(val);
        }
        
        
        public static function intToString(val:int):String
        {
            return String(val);
        }
        
        
        public static function boolToString(val:Boolean):String
        {
            if (val)
            {
                return String("True");
            }
            else
            {
                return String("False");
            }
            
        }
        
        public static function sizeToString(val:Size):String
        {
            return "w:" + val.d_width + " h:" + val.d_height;
        }
            
            
        public static function vector2ToString(val:Vector2):String
        {
            return "x:" + val.d_x + " y:" + val.d_y;
        }
                
        public static function rectToString(val:Rect):String
        {
            return "l:" + val.d_left + " t:" + val.d_top + " r:" + val.d_right + " b:" + val.d_bottom;
        }
                    
                    
        public static function imageToString(val:FlameImage):String
        {
            if (val)
            {
                return "set:" + val.getImagesetName() + " image:" + val.getName();
            }
            
            return String("");
        }
                    
        public static function udimToString(val:UDim):String
        {
            return "{" + val.d_scale + "," + val.d_offset + "}";
        }
                            
                            
        public static function uvector2ToString(val:UVector2):String
        {
            return "{{" + val.d_x.d_scale + "," + val.d_x.d_offset + "},{" + val.d_y.d_scale + "," + val.d_y.d_offset + "}}";
        }
                            
                                
        public static function urectToString(val:URect):String
        {
            return "{{" + 
                val.d_min.d_x.d_scale + "," + val.d_min.d_x.d_offset + "},{" +
                val.d_min.d_y.d_scale + "," + val.d_min.d_y.d_offset + "},{" +
                val.d_max.d_x.d_scale + "," + val.d_max.d_x.d_offset + "},{" +
                val.d_max.d_y.d_scale + "," + val.d_max.d_y.d_offset + "}}";
        }
                                    
        public static function uboxToString(val:UBox):String
        {
            return "{top:{" + 
                val.d_top.d_scale + "," + val.d_top.d_offset + "},left:{" +
                val.d_left.d_scale + "," + val.d_left.d_offset + "},bottom:{" +
                val.d_bottom.d_scale + "," + val.d_bottom.d_offset + "},right:{" +
                val.d_right.d_scale + "," + val.d_right.d_offset + "}}";
        }
                                        
        public static function colourToString(val:Colour):String
        {
            //return String(val.getARGB());
            var aa : String = (val.d_alpha * 255).toString(16);
            var rr : String = (val.d_red * 255).toString(16);
            var gg : String = (val.d_green * 255).toString(16);
            var bb : String = (val.d_blue * 255).toString(16);
            aa = (aa.length == 1) ? '0' + aa : aa;
            rr = (rr.length == 1) ? '0' + rr : rr;
            gg = (gg.length == 1) ? '0' + gg : gg;
            bb = (bb.length == 1) ? '0' + bb : bb;
            return (aa + rr + gg + bb).toUpperCase();
        }
                                            
                                            
        public static function stringToColour(str:String):Colour
        {
            //str = str.replace(/^'|'$/g, "");
            var val:uint = parseInt("0x"+str,16);
            //trace("r:" + ((val >> 16) & 0xFF)/255);
            if(str.length == 6)
                return Colour.fromUint6(val);
            else
                return Colour.fromUint(val);
        }
                                                
                                                
        public static function colourRectToString(val:ColourRect):String
        {
            return "tl:" + val.d_top_left.toString() + 
                   " tr:" + val.d_top_right.toString() + 
                   " bl:" + val.d_bottom_left.toString() +
                   " br:" + val.d_bottom_right.toString();
        }
                                                    
                                                    
        public static function stringToColourRect(str:String):ColourRect
        {
            //tl:%8X tr:%8X bl:%8X br:%8X
            var s:String = str.replace("tl:", "").replace("tr:", "").replace("bl:", "").replace("br:", "");
            var arr:Array = s.split(" ");
            var tl:String = arr[0];
            var tr:String = arr[1];
            var bl:String = arr[2];
            var br:String = arr[3];
            var tli:uint = parseInt("0x" + tl, 16);
            var tri:uint = parseInt("0x" + tr, 16);
            var bli:uint = parseInt("0x" + bl, 16);
            var bri:uint = parseInt("0x" + br, 16);
            var tlc:Colour = Colour.fromUint(tli);
            var trc:Colour = Colour.fromUint(tri);
            var blc:Colour = Colour.fromUint(bli);
            var brc:Colour = Colour.fromUint(bri);

            return new ColourRect(tlc, trc, blc, brc);
        }
                                                    
    //----------------------------------------------------------------------------//
        public static function stringToVector3(str:String):Vector3
        {
            //x:%g y:%g z:%g
            var tr:String = str.replace("x:", "").replace("y:", "").replace("z:", "");
            var arr:Array = tr.split(" ");
            var x:Number = Number(arr[0]);
            var y:Number = Number(arr[1]);
            var z:Number = Number(arr[2]);
            
            return new Vector3(x, y, z);
        }
        
        //----------------------------------------------------------------------------//
        public static function vector3ToString(val:Vector3):String
        {
            return "x:" + val.x + " y:" + val.y + " z:" + val.z;
        }
    }
}