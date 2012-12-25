

package Flame2D.core.utils
{
    import Flame2D.core.properties.FlamePropertyHelper;
    
    public class Colour
    {
        public var d_alpha:Number = 1.0;
        public var d_red:Number = 1.0;
        public var d_green:Number = 1.0;
        public var d_blue:Number = 1.0;
        
        public var d_argb:uint = 0xFFFFFFFF;
        private var d_argbValid:Boolean = true;
        
        public function Colour(red:Number = 1, green:Number = 1, blue:Number = 1, alpha:Number = 1.0)
        {
            
            d_red = red;
            d_green = green;
            d_blue = blue;
            d_alpha = alpha;
            
            d_argb = calculateARGB();
        }
        
        
        public static function getColour(val:uint):Colour
        {
            var blue:Number = (val & 0xFF) / 255.0;
            val >>= 8;
            var green:Number = (val & 0xFF) / 255.0;
            val >>= 8;
            var red:Number = (val & 0xFF) / 255.0;
            val >>= 8;
            var alpha:Number = (val & 0xFF) / 255.0;
            
            return new Colour(red, green, blue, alpha);
            
        }
        
        public function setAlpha(alpha:Number):void
        {
            d_argbValid = false;
            d_alpha = alpha;
        }
        
        public function setRed(red:Number):void
        {   
            d_argbValid = false;
            d_red = red;
        }
        
        public function setGreen(green:Number):void
        {
            d_argbValid = false;
            d_green = green;
        }
        
        public function setBlue(blue:Number):void
        {
            d_argbValid = false;
            d_blue = blue;
        }
        
        public function set(red:Number, green:Number, blue:Number, alpha:Number = 1.0):void
        {
            d_argbValid = false;
            d_alpha = alpha;
            d_red = red;
            d_green = green;
            d_blue = blue;
        }

        public function setARGB(argb:uint):void
        {
            d_argb = argb;
            d_blue = (argb & 0xFF) / 255.0;
            argb >>= 8;
            d_green = (argb & 0xFF) / 255.0;
            argb >>= 8;
            d_red = (argb & 0xFF) / 255.0;
            argb >>= 8;
            d_alpha = (argb & 0xFF) / 255.0;
            
            d_argbValid = true;
        }
        
        public function setRGB(red:Number, green:Number, blue:Number):void
        {
            d_argbValid = false;
            d_red = red;
            d_green = green;
            d_blue = blue;
        }
        
        public function setColour(val:Colour):void
        {
            d_red = val.d_red;
            d_green = val.d_green;
            d_blue = val.d_blue;
            if (d_argbValid)
            {
                d_argbValid = val.d_argbValid;
                if (d_argbValid) {
                    d_argb = (d_argb & 0xFF000000) | (val.d_argb & 0x00FFFFFF);
                }
            }
        }
        
        public function invertColour():void
        {
            d_red	= 1.0 - d_red;
            d_green	= 1.0 - d_green;
            d_blue	= 1.0 - d_blue;
        }
        
        
        public function invertColourWithAlpha():void
        {
            d_alpha	= 1.0 - d_alpha;
            d_red	= 1.0 - d_red;
            d_green	= 1.0 - d_green;
            d_blue	= 1.0 - d_blue;
        }

        //-----------------------------------------------------------------

        public function setHSL(hue:Number, saturation:Number, luminance:Number, alpha:Number):void
        {
            d_alpha = alpha;
            
            var temp3:Array = new Array();
            
            var pHue:Number = hue;
            var pSat:Number = saturation;
            var pLum:Number = luminance;
            
            if(pSat == 0){
                d_red = pLum;
                d_green = pLum;
                d_blue = pLum;
            } else {
                var temp2:Number;
                if(pLum < 0.){
                    temp2 = pLum * (1 + pSat);
                } else {
                    temp2 = pLum + pSat - pLum * pSat;
                }
                
                var temp1:Number = 2 * pLum - temp2;
                
                temp3[0] = pHue + (1/3);
                temp3[1] = pHue;
                temp3[2] = pHue - (1/3);
                
                for(var n:int = 0; n<3; n++){
                    if(temp3[n] < 0){
                        temp3[n] ++;
                    }
                    if(temp3[n] > 1){
                        temp3[n] --;
                    }
                    
                    if((temp3[n] * 6) < 1){
                        temp3[n] = temp1 + (temp2 - temp1) * 6 * temp3[n];
                    } else {
                        if((temp3[n] * 2) < 1){
                            temp3[n] = temp2;
                        } else {
                            if((temp3[n] * 3) < 2){
                                temp3[n] = temp1 + (temp2 - temp1) * ((2/3) - temp3[n]) * 6;
                            } else {
                                temp3[n] = temp1;
                            }
                        }
                    }
                }
                
                d_red = temp3[0];
                d_green = temp3[1];
                d_blue = temp3[2];
            }
            
            d_argbValid = false;
        }
        
        public function getAlpha():Number
        {
            if(!d_argbValid){
                d_argb = calculateARGB();
                d_argbValid = true;
            }
            return d_alpha;
        }
        
        public function getARGB():uint
        {
            if(!d_argbValid){
                d_argb = calculateARGB();
                d_argbValid = true;
            }
            
            return d_argb;
        }
        
        private function calculateARGB():uint
        {
            return uint(d_alpha * 255) << 24 | uint(d_red * 255) << 16 | uint(d_green * 255) << 8 | uint(d_blue * 255);
        }
        
        public function getHue():Number
        {
            var pRed:Number = d_red;
            var pGreen:Number = d_green;
            var pBlue:Number = d_blue;
            
            var pMax:Number = Math.max(d_red, d_green, d_blue);
            var pMin:Number = Math.min(d_red, d_green, d_blue);
            
            var pHue:Number;
            
            if(pMax == pMin){
                pHue = 0;
            } else {
                if(pMax == pRed){
                    pHue = (pGreen - pBlue) / (pMax - pMin);
                } else if(pMax == pGreen){
                    pHue = 2 + (pBlue - pRed) / (pMax - pMin);
                } else {
                    pHue = 4 + (pRed - pGreen) / (pMax - pMin);
                }
            }
            
            var Hue:Number = pHue / 6;
            if(Hue < 0) {
                Hue += 1;
            }
            
            return Hue;
        }
        
        
        public function getSaturation():Number
        {
            var pMax:Number = Math.max(d_red, d_green, d_blue);
            var pMin:Number = Math.min(d_red, d_green, d_blue);
            
            var pLum:Number = (pMax + pMin) / 2;
            var pSat:Number;
            
            if(pMax == pMin) {
                pSat = 0;
            } else {
                if(pLum < 0.5) {
                    pSat = (pMax - pMin) / (pMax + pMin);
                } else {
                    pSat = (pMax - pMin) / (2 - pMax - pMin);
                }
            }
            
            return pSat;
        }
        
        public function getLumination():Number
        {
            var pMax:Number = Math.max(d_red, d_green, d_blue);
            var pMin:Number = Math.min(d_red, d_green, d_blue);
            
            var pLum:Number = (pMax + pMin) / 2;

            return pLum;
        }
        
        //-----------------------------------------------------------------------------
        /*************************************************************************
         Operators
         *************************************************************************/
        public function clone():Colour
        {
            return new Colour(d_red, d_green , d_blue, d_alpha);
        }
            
                

        public function add(val:Colour):Colour
        {
            return new Colour(
                d_red   + val.d_red, 
                d_green + val.d_green, 
                d_blue  + val.d_blue,
                d_alpha + val.d_alpha);
        }
        
        
        public function substract(val:Colour):Colour
        {
            return new Colour(
                d_red   - val.d_red,
                d_green - val.d_green,
                d_blue  - val.d_blue,
                d_alpha - val.d_alpha);
        }
        
        public function multiply(val:Number):Colour
        {       
            return new Colour(
                d_red   * val, 
                d_green * val, 
                d_blue  * val,
                d_alpha * val);
        }
        
        public function multiplyColor(val:Colour):Colour
        {
            var red:Number = d_red * val.d_red;
            var green:Number = d_green * val.d_green;
            var blue:Number = d_blue * val.d_blue;
            var alpha:Number = d_alpha * val.d_alpha;
            
            return new Colour(red, green, blue, alpha);
        }
        
        /*************************************************************************
         Compare operators
         *************************************************************************/
        public function isEqual(rhs:Colour) : Boolean
        {
            return d_red   == rhs.d_red   &&
                d_green == rhs.d_green &&
                d_blue  == rhs.d_blue  &&
                d_alpha == rhs.d_alpha;
        }

        
        public static function toARGB(a:uint, r:uint, g:uint, b:uint) : String {
            var aa : String = a.toString(16);
            var rr : String = r.toString(16);
            var gg : String = g.toString(16);
            var bb : String = b.toString(16);
            aa = (aa.length == 1) ? '0' + aa : aa;
            rr = (rr.length == 1) ? '0' + rr : rr;
            gg = (gg.length == 1) ? '0' + gg : gg;
            bb = (bb.length == 1) ? '0' + bb : bb;
            return (aa + rr + gg + bb).toUpperCase();
        }
        
        public static function toRGB(r : uint, g : uint, b : uint) : String {
            var rr : String = r.toString(16);
            var gg : String = g.toString(16);
            var bb : String = b.toString(16);
            rr = (rr.length == 1) ? '0' + rr : rr;
            gg = (gg.length == 1) ? '0' + gg : gg;
            bb = (bb.length == 1) ? '0' + bb : bb;
            return (rr + gg + bb).toUpperCase();
        }
        
        public static function fromUint(val:uint):Colour
        {
            var b:Number = (val & 0xFF) / 255.0;
            val >>= 8;
            var g:Number = (val & 0xFF) / 255.0;
            val >>= 8;
            var r:Number = (val & 0xFF) / 255.0;
            val >>= 8;
            var a:Number = (val & 0xFF) / 255.0;
            
            return new Colour(r, g, b, a);
        }        
        public static function fromUint6(val:uint):Colour
        {
            var b:Number = (val & 0xFF) / 255.0;
            val >>= 8;
            var g:Number = (val & 0xFF) / 255.0;
            val >>= 8;
            var r:Number = (val & 0xFF) / 255.0;
            val >>= 8;
            
            return new Colour(r, g, b, 1);
        }        
        
        public function toString():String
        {
            return FlamePropertyHelper.colourToString(this);
//            var aa : String = (d_alpha * 255).toString(16);
//            var rr : String = (d_red * 255).toString(16);
//            var gg : String = (d_green * 255).toString(16);
//            var bb : String = (d_blue * 255).toString(16);
//            aa = (aa.length == 1) ? '0' + aa : aa;
//            rr = (rr.length == 1) ? '0' + rr : rr;
//            gg = (gg.length == 1) ? '0' + gg : gg;
//            bb = (bb.length == 1) ? '0' + bb : bb;
//            return (aa + rr + gg + bb).toUpperCase();
//            
        }
    }
}