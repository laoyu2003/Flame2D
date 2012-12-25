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
    import Flame2D.core.data.BatchInfo;
    import Flame2D.core.data.VertexData;
    import Flame2D.core.system.FlameRenderingSurface;
    import Flame2D.core.system.FlameRenderingWindow;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.utils.Colour;
    import Flame2D.core.utils.MatrixUtil;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    
    import flash.display.BlendMode;
    import flash.display.Stage3D;
    import flash.display3D.Context3D;
    import flash.display3D.Context3DBlendFactor;
    import flash.display3D.Context3DCompareMode;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Context3DTriangleFace;
    import flash.display3D.Context3DVertexBufferFormat;
    import flash.display3D.IndexBuffer3D;
    import flash.display3D.Program3D;
    import flash.display3D.VertexBuffer3D;
    import flash.display3D.textures.Texture;
    import flash.geom.Matrix;
    import flash.geom.Matrix3D;
    import flash.geom.Rectangle;
    import flash.geom.Vector3D;
    
    public class FlameGeometryBuffer implements FlameIGeometryBuffer
    {
        private static const NUM_VERTEXDATA:uint = 9;
        
        private var d_owner:FlameRenderer = null;
        
        private var d_window:FlameWindow = null; //test only
        private var d_target:FlameRenderTarget= null;        //test only
        private var d_surface:FlameRenderingSurface = null; //test only
        
        //current active texture, for drawing batchlist
        private var d_activeTexture:FlameTexture = null;

        //list of texture batches added to the geometry buffer
        private var d_batches:Vector.<BatchInfo> = new Vector.<BatchInfo>();
        
        //container where geometry is installed
        //private var d_vertices:Vector.<VertexData> = new Vector.<VertexData>();
        
        
        //clip region
        private var d_clipRect:Rectangle = new Rectangle();
        
        //model translation para
        private var d_translation:Vector3D = new Vector3D();
        
        //model rotation para
        private var d_rotation:Vector3D = new Vector3D();
        
        //model pivot para
        private var d_pivot:Vector3D = new Vector3D();
        
        //effect
        private var d_effect:FlameRenderEffect = null;
        
        //model matrix cache
        //private var d_matrix:Matrix = new Matrix();
        private var d_matrix3D:Matrix3D = new Matrix3D();
        
        //is current matrix is valid and up to date
        private var d_matrixValid:Boolean = false;
        
        private var d_blendMode:String = BlendMode.NORMAL;
        
        
        
        
        
        //stage3d specific data
        private var d_vertexData:Vector.<Number> = new Vector.<Number>();
        private var d_indexData:Vector.<uint> = new Vector.<uint>();
        
        //index for updating triangles in d_indexData, incring 3 for 4 Vertices 
        private var d_lastIndex:uint = 0;
        
        // the uploaded vertex buffer
        private var d_vertexBuffer:VertexBuffer3D;
        // the uploaded index buffer
        private var d_indexBuffer:IndexBuffer3D;
                
        // construction
        public function FlameGeometryBuffer(owner:FlameRenderer)
        {
            d_owner = owner;
        }
        
        //public methods
        public function draw():void
        {
            //if(d_vertexData.length == 0) return;
            
            //FlameSystem.getSingleton().signalRedraw();
            // setup clip region
//            if( true )
//            {
//                d_owner.getContext3D().setScissorRectangle( d_clipRect ); //on
//            }
//            else 
//            {
//                d_owner.getContext3D().setScissorRectangle( null ); //off
//            }
//            
            
            // apply the transformations we need to use.
            if (!d_matrixValid)
                updateMatrix();
            
            // set up RenderEffect
            //if (d_effect) d_effect->performPreRenderFunctions(pass);
                
            d_owner.getContext3D().setProgram ( d_owner.getProgram3D() );
            
            // position
            d_owner.getContext3D().setVertexBufferAt(0, d_vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
            // tex coord
            d_owner.getContext3D().setVertexBufferAt(1, d_vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
            // colour
            d_owner.getContext3D().setVertexBufferAt(2, d_vertexBuffer, 5, Context3DVertexBufferFormat.FLOAT_4);
            
            // pass our matrix data to the shader program
            d_owner.getContext3D().setProgramConstantsFromMatrix(
                Context3DProgramType.VERTEX, 0, d_matrix3D, true );
            
            //for draw a range of triangles
            var indexStart:uint = 0;
            
            for(var i:uint=0; i<d_batches.length; i++)
            {
                var batch:BatchInfo = d_batches[i];

                if(batch.texture)
                {
                    //set texture
                    d_owner.getContext3D().setTextureAt(0, batch.texture);
                    
                    //draw triangles
                    d_owner.getContext3D().drawTriangles(d_indexBuffer, indexStart, batch.length/2);
                    
                }
                
                //forward to next part
                indexStart += batch.length / 2 * 3;
            }
            
            
           // clean up RenderEffect
           // if (d_effect)d_effect->performPostRenderFunctions();
            
        }
        
        
        public function setTranslation(t:Vector3D):void
        {
            //trace("~~~~~~~~~~~~~set translation for geobuffer:" + t.toString());
            d_translation = t;
            d_matrixValid = false;
        }
        
        public function setRotation(r:Vector3D):void
        {
            d_rotation = r;
            d_matrixValid = false;
        }
        
        public function setPivot(p:Vector3D):void
        {
            d_pivot = p;
            d_matrixValid = false;
        }
        
        public function setClippingRegion(region:Rect):void
        {
            //trace("set clip region:" + region.toString());
            d_clipRect.x = Math.max(0, Misc.PixelAligned(region.d_left));
            d_clipRect.y = Math.max(0, Misc.PixelAligned(region.d_top));
            d_clipRect.width = Math.max(0, Misc.PixelAligned(region.d_right - region.d_left));
            d_clipRect.height = Math.max(0, Misc.PixelAligned(region.d_bottom - region.d_top));
        }
        
        
        public function appendVertex(vertex:VertexData):void
        {
        }
        
        
        public function appendGeometry(buffer:Vector.<VertexData>):void
        {
            Misc.assert(buffer.length == 4);

            //batch management
            performBatchManagement();
            
            //update size of current batch
            var batch:BatchInfo = d_batches[this.d_batches.length - 1];
            batch.length += buffer.length;
            
            //trace("add geometry, buffer length:" + buffer.length);
            
            //buffer these vertices
            for (var i:uint = 0; i < buffer.length; i++)
            {
                var vs:VertexData = buffer[i];
                //add to vertex buffer
                var col:Colour = Colour.fromUint(vs.colour_val);
                d_vertexData.push(vs.position.x, vs.position.y, vs.position.z, 
                    vs.tex_coords.d_x, vs.tex_coords.d_y,
                    col.d_red, col.d_green, col.d_blue, col.d_alpha);
                //trace("append vertex data:" + vs.position.toString() + ", uv:" + vs.tex_coords.toString() + ",col:" + col.toString());
                //trace("------------");

            }

            d_indexData.push(d_lastIndex + 0, d_lastIndex + 1, d_lastIndex + 2, 
                d_lastIndex + 0, d_lastIndex + 2, d_lastIndex + 3);
            d_lastIndex += buffer.length;
            
            
            
            // upload the mesh vertex data
            // x, y, z, u, v, r, g, b, a
            d_vertexBuffer = d_owner.getContext3D().createVertexBuffer(d_vertexData.length/NUM_VERTEXDATA, NUM_VERTEXDATA); 
            d_vertexBuffer.uploadFromVector(d_vertexData, 0, d_vertexData.length/NUM_VERTEXDATA);
            
            //upload after changing
            d_indexBuffer = d_owner.getContext3D().createIndexBuffer(d_indexData.length);
            d_indexBuffer.uploadFromVector(d_indexData, 0, d_indexData.length);
            
            
            //trace("The quad of geometry buffer is:" + d_vertexData.length/NUM_VERTEXDATA/4);
        }
        
        private function performBatchManagement():void
        {
            //get last texture in batch list
            const t:Texture = d_activeTexture ?
                d_activeTexture.getTexture() : null;
            
            //create a new batch if there are no batches yet, or if the active texture
            //differs from that used by the current batch
            if(d_batches.length == 0 || t != d_batches[d_batches.length-1].texture){
                d_batches.push(new BatchInfo(t, 0));
            }
        }
        
        public function setActiveTexture(texture:FlameTexture):void
        {
            d_activeTexture = texture;
        }
        
        public function reset():void
        {
            d_batches.length = 0;
            d_vertexData.length = 0;
            d_indexData.length = 0;

            d_activeTexture = null;
            //remove indexbuffer and vertexbuffer?
            d_lastIndex = 0;

            d_matrixValid = false;

        }
        
        public function getActiveTexture():FlameTexture
        {
            return d_activeTexture;
        }
        
        public function getVertexData():Vector.<Number>
        {
            return d_vertexData;
        }
        
        public function getVertexCount():uint
        {
            return d_vertexData.length;
        }
        
        public function getBatchCount():uint
        {
            return d_batches.length;
        }
        
        public function getBatches():Vector.<BatchInfo>
        {
            return d_batches;
        }
        
        public function getClipRect():Rectangle
        {
            return d_clipRect;
        }
        
        public function setRenderEffect(effect:FlameRenderEffect):void
        {
            d_effect = effect;
        }
        
        public function getTranslation():Vector3D
        {
            return d_translation;
        }
        
        
        public function getRenderEffect():FlameRenderEffect
        {
            return this.d_effect;
        }
        
        public function setBlendMode(mode:String):void
        {
            d_blendMode = mode;
        }
        
        public function getBlendMode():String
        {
            return d_blendMode;
        }
        
//        public function getMatrix():Matrix
//        {
//            if (!d_matrixValid)
//                updateMatrix();
//            
//            return d_matrix;
//        }
        
        private function updateMatrix():void
        {
            //trace("update matrix, translation:" + d_translation.toString());
            //model matrix
            var modelViewMatrix:Matrix = new Matrix();
            modelViewMatrix.identity();
            MatrixUtil.prependTranslation(modelViewMatrix, d_translation.x + d_pivot.x, d_translation.y + d_pivot.y);
            MatrixUtil.prependRotation(modelViewMatrix, d_rotation.x);
            MatrixUtil.prependTranslation(modelViewMatrix, - d_pivot.x, - d_pivot.y);
            
            //projection
            var area:Rect = d_owner.getArea();
            var projectionMatrix:Matrix = new Matrix();
            projectionMatrix.identity();
            setOrthographicProjection(projectionMatrix, area.d_left, area.d_top, area.getWidth(), area.getHeight());
            //trace("update matrix, area:" + area.toString());
            //model view projection matrix
            var mvpMatrix:Matrix = new Matrix();
            mvpMatrix.identity();
            mvpMatrix.copyFrom(modelViewMatrix);
            mvpMatrix.concat(projectionMatrix);
            
            
            d_matrix3D = MatrixUtil.convertTo3D(mvpMatrix); 
            
            //trace("Last mvp matrix:" + mvpMatrix.toString());
            d_matrixValid = true;
        }
        
        private function setOrthographicProjection(m:Matrix, x:Number, y:Number, width:Number, height:Number):void
        {
            m.setTo(2.0/width, 0, 0, -2.0/height, 
                -(2*x + width) / width, (2*y + height) / height);
        }
        
        public function setTextureTarget(target:FlameTextureTarget):void
        {
            d_target = target;
        }
        
        public function setSurface(surface:FlameRenderingSurface):void
        {
            d_surface = surface;
        }
   }
}

