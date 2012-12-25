/***************************************************************************
 *   Porting to Flash Stage3D
 *   Copyright (C) 2012 Mingjian Yu(laoyu20032003@hotmail.com)
 *
 *   Permission is hereby granted, free of charge, to any person obtaining
 *   a copy of this software and associated documentation files (the
 *   "Software"), to deal in the Software without restriction, including
 *   without limitation the rights to use, copy, modify, merge, publish,
 *   distribute, sublicense, and/or sell copies of the Software, and to
 *   permit persons to whom the Software is furnished to do so, subject to
 *   the following conditions:
 *
 *   The above copyright notice and this permission notice shall be
 *   included in all copies or substantial portions of the Software.
 *
 *   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 *   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 *   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 *   IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 *   OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 *   ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 *   OTHER DEALINGS IN THE SOFTWARE.
 ***************************************************************************/

package Flame2D.renderer
{
    import Flame2D.core.system.FlameResourceProvider;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.Vector2;
    import Flame2D.loaders.ImageFileLoader;
    
    import flash.display.BitmapData;
    import flash.display3D.Context3DTextureFormat;
    import flash.display3D.textures.Texture;
    import flash.utils.ByteArray;

    public class FlameTexture implements FlameITexture
    {
        protected var d_owner:FlameRenderer = null;
        
        
        protected var d_texture:Texture = null;
        //! Size of the texture.
        protected var d_size:Size = new Size(0, 0);
        //! original pixel of size data loaded into texture
        protected var d_dataSize:Size = new Size(0, 0);
        //! cached pixel to texel mapping scale values.
        protected var d_texelScaling:Vector2 = new Vector2(0, 0);

        //associated bitmapData for system font
        protected var d_bitmapData:BitmapData = null;
        
        public function FlameTexture(owner:FlameRenderer)
        {
            d_owner = owner;
            
        }
        
        public function getTexture():Texture
        {
            return d_texture;
        }
        
        
        public function createTextureWithSize(sz:Size):void
        {
            d_dataSize.d_width = sz.d_width;
            d_dataSize.d_height = sz.d_height;
            
            var tex_sz:Size = d_owner.getAdjustedSize(sz);
            
            d_texture = d_owner.getContext3D().createTexture(tex_sz.d_width, tex_sz.d_height, 
                Context3DTextureFormat.BGRA, true);
            
            updateTextureSize(tex_sz.d_width, tex_sz.d_height);
            updateCachedScaleValues();
        }
        
        public function loadFromFile(fileName:String, resourceGroup:String):void
        {
            var url:String = FlameResourceProvider.getSingleton().getResourceDir() + 
                             FlameResourceProvider.getSingleton().getImageDir() + 
                             fileName;
            //to do, ATF support
            new ImageFileLoader({filename:fileName}, url, onTextureFileLoaded);
        }
        
        private function onTextureFileLoaded(tag:Object, bitmapData:BitmapData):void
        {
            d_texture = d_owner.getContext3D().createTexture(bitmapData.width, bitmapData.height,
                Context3DTextureFormat.BGRA, true);
            d_texture.uploadFromBitmapData(bitmapData, 0);
            
            updateTextureSize(bitmapData.width, bitmapData.height);
            d_dataSize.d_width = d_size.d_width;
            d_dataSize.d_height = d_dataSize.d_height;
            updateCachedScaleValues();

        }
        
        // implement abstract members from base class.
        
        public function setTexture(tex:Texture, width:Number, height:Number):void
        {
            if (d_texture != tex)
            {
                //clean old texture
                
                d_dataSize.d_width = d_dataSize.d_height = 0;
                d_texture = tex;
            }
            
            updateTextureSize(width, height);
            d_dataSize.d_width = d_size.d_width;
            d_dataSize.d_height = d_size.d_height;
            updateCachedScaleValues();
        }
        
        
        
        public function setTextureFromBitmapData(bitmapData:BitmapData):void
        {
            if(d_texture != null) return;

            d_size.d_width  = bitmapData.width;
            d_size.d_height = bitmapData.height;
            d_dataSize.d_width = bitmapData.width;
            d_dataSize.d_height = bitmapData.height;

            updateCachedScaleValues();
            
            d_texture = d_owner.getContext3D().createTexture(bitmapData.width, bitmapData.height, 
                Context3DTextureFormat.BGRA, false);
            d_texture.uploadFromBitmapData(bitmapData, 0);
            
        }
        
        public function setTextureFromByteArray(atf:ByteArray):void
        {
            var width:int = Math.pow(2, atf[7]);
            var height:int = Math.pow(2, atf[8]);
            var textureFormat:String = (atf[6] == 2 ? Context3DTextureFormat.COMPRESSED : 
                Context3DTextureFormat.BGRA);

            if(d_texture != null) return;
            
            d_size.d_width = width;
            d_size.d_height = height;
            d_dataSize.d_width = width;
            d_dataSize.d_height = height;
            updateCachedScaleValues();
            

            d_texture = d_owner.getContext3D().createTexture(width, height, textureFormat, false);
            d_texture.uploadCompressedTextureFromByteArray(atf, 0, false);
        }
        
        public function setBitmapData(bitmapData:BitmapData):void
        {
            d_bitmapData = bitmapData;
        }
        
        //----------------------------------------------------------------------------//
        public function setOriginalDataSize(sz:Size):void
        {
            d_dataSize.d_width = sz.d_width;
            d_dataSize.d_height = sz.d_height;
            
            updateCachedScaleValues();
        }
        
        
        
        public function getSize():Size
        {
            return d_size;
        }
        
        public function getOriginalDataSize():Size
        {
            return d_dataSize;
        }
        
        public function getTexelScaling():Vector2
        {
            return d_texelScaling;
        }
        
        public function getBitmapData():BitmapData
        {
            return d_bitmapData;
        }
        
            
        //----------------------------------------------------------------------------//
        private function updateTextureSize(width:Number, height:Number):void
        {
            d_size.d_width = width;
            d_size.d_height = height;
        }
        
        private function updateCachedScaleValues():void
        {
            //
            // calculate what to use for x scale
            //
            var orgW:Number = d_dataSize.d_width;
            var texW:Number = d_size.d_width;
            
            // if texture and original data width are the same, scale is based
            // on the original size.
            // if texture is wider (and source data was not stretched), scale
            // is based on the size of the resulting texture.
            d_texelScaling.d_x = 1.0 / ((orgW == texW) ? orgW : texW);
            
            //
            // calculate what to use for y scale
            //
            var orgH:Number = d_dataSize.d_height;
            var texH:Number = d_size.d_height;
            
            // if texture and original data height are the same, scale is based
            // on the original size.
            // if texture is taller (and source data was not stretched), scale
            // is based on the size of the resulting texture.
            d_texelScaling.d_y = 1.0 / ((orgH == texH) ? orgH : texH);
        }
        

        //void loadFromMemory(const void* buffer, const Size& buffer_size, PixelFormat pixel_format);
        //void saveToMemory(void* buffer);
        
        public function cleanupTexture():void
        {
            if(d_texture)
            {
                d_texture.dispose();
                d_texture = null;
            }
        }
        
 
    }
}