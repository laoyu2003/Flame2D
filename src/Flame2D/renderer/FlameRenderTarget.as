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
    import Flame2D.core.system.FlameRenderQueue;
    import Flame2D.core.utils.MatrixUtil;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Vector2;
    import Flame2D.renderer.FlameGeometryBuffer;
    import Flame2D.renderer.FlameIRenderTarget;
    import Flame2D.renderer.FlameTextureTarget;
    
    import flash.geom.Matrix;
    import flash.geom.Matrix3D;
    import flash.geom.Point;
    
    public class FlameRenderTarget implements FlameIRenderTarget
    {
        //owner
        protected var d_owner:FlameRenderer = null;
        //! holds defined area for the RenderTarget
        protected var d_area:Rect = new Rect();
        //! projection / view matrix cache
        protected var d_matrix:Matrix = new Matrix();
        //! true when d_matrix is valid and up to date
        protected var d_matrixValid:Boolean = false;
        //! tracks viewing distance (this is set up at the same time as d_matrix)
        //mutable float d_viewDistance;
       
        public function FlameRenderTarget(owner:FlameRenderer)
        {
            d_owner = owner;
        }
        
        
        // implement parts of RenderTarget interface
        public function draw(buffer:FlameGeometryBuffer):void
        {
            buffer.draw();
        }
        
        public function drawQueue(queue:FlameRenderQueue):void
        {
            queue.draw();
        }
        
        public function setArea(area:Rect):void
        {
            d_area = area;
            d_matrixValid = false;
        }
        
        
        public function getArea():Rect
        {
            return d_area;
        }
        
        public function activate():void
        {
            d_owner.setArea(d_area);
            
            //setup matrix
            if (!d_matrixValid)
                updateMatrix();
            

        }
        
        public function deactivate():void
        {
            
        }
        
        public function unprojectPoint(buff:FlameGeometryBuffer, p_in:Vector2, p_out:Vector2):void
        {
            if (!d_matrixValid)
                updateMatrix();
            
            var p:Point = d_matrix.transformPoint(new Point(p_in.d_x, p_in.d_y));
            p_out.d_x = p.x;
            p_out.d_y = p.y;
        }
        
        public function isImageryCache():Boolean
        {
            return false;
        }
        
        //protected:
        //! helper that initialises the cached matrix
        //void updateMatrix() const;
        //! helper to initialise the D3DVIEWPORT9 \a vp for this target.
        //void setupViewport(D3DVIEWPORT9& vp) const;
        
        
        protected function updateMatrix():void
        {
            d_matrix.identity();
            
            var x:Number = d_area.d_left;
            var y:Number = d_area.d_top;
            var width:Number = d_area.getWidth();
            var height:Number = d_area.getHeight();
            
            d_matrix.setTo(2.0/width, 0, 0, -2.0/height,  -(2*x + width) / width, (2*y + height) / height);
            
            d_matrixValid = true;
        }
        
    }
}