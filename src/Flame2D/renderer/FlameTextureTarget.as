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
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    
    import flash.display3D.Context3DTextureFormat;
    import flash.display3D.textures.Texture;
   
    
    public class FlameTextureTarget extends FlameRenderTarget implements FlameITextureTarget
    {
        protected static const DEFAULT_SIZE:Number = 128;
        
        //stage3d texture
        protected var d_texture:Texture = null;
        
        //associated FlameTexture
        protected var d_flameTexture:FlameTexture = null;
        
        public function FlameTextureTarget(owner:FlameRenderer)
        {
            super(owner);
            
            //create a null flame texture
            d_flameTexture = new FlameTexture(owner);
            
            // setup area and cause the initial texture to be generated.
            declareRenderSize(new Size(DEFAULT_SIZE, DEFAULT_SIZE));
        }
        
        
        // implementation of RenderTarget interface
        override public function isImageryCache():Boolean
        {
            return true;
        }
        
        
        //----------------------------------------------------------------------------//
        override public function activate():void
        {
            d_owner.getContext3D().setRenderToTexture(d_texture);
            d_owner.getContext3D().clear(1,1,1,0);
            super.activate();
            
//            d_owner.updateMatrix(d_area);
            
        }
        
        //----------------------------------------------------------------------------//
        override public function deactivate():void
        {
            super.deactivate();
            d_owner.getContext3D().setRenderToBackBuffer();
        }
        
        // implementation of TextureTarget interface
        public function clear():void
        {
            
        }
        
        public function getTexture():FlameTexture
        {
            return d_flameTexture;
        }
        
        public function declareRenderSize(sz:Size):void
        {
            // exit if current size is enough
            if ((d_area.getWidth() >= sz.d_width) && (d_area.getHeight() >=sz.d_height))
                return;
            
            setArea(Rect.createRect(d_area.getPosition(), sz));
            resizeRenderTexture();
            clear();
        }
        
        public function isRenderingInverted():Boolean
        {
            return false;
        }
        
        
        //----------------------------------------------------------------------------//
        protected function initialiseRenderTexture():void
        {
            var tex_sz:Size = d_owner.getAdjustedSize(d_area.getSize());
            
            d_texture = d_owner.getContext3D().createTexture(tex_sz.d_width, tex_sz.d_height,
                Context3DTextureFormat.BGRA, true);
            
            
            // wrap the created texture with the CEGUI::Texture
            d_flameTexture.setTexture(d_texture, tex_sz.d_width, tex_sz.d_height);
            d_flameTexture.setOriginalDataSize(d_area.getSize());
        }
        
        
        protected function resizeRenderTexture():void
        {
            cleanupRenderTexture();
            initialiseRenderTexture();
        }
            
        protected function cleanupRenderTexture():void
        {
            //dispose
            if(d_texture)
            {
                d_texture.dispose();
                d_texture = null;
            }
        }
    }
}