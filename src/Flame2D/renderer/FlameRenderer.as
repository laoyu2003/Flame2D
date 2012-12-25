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
    import Flame2D.core.system.FlameRenderingRoot;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.utils.MatrixUtil;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.Vector2;
    
    import com.adobe.utils.AGALMiniAssembler;
    import com.adobe.utils.PerspectiveMatrix3D;
    
    import flash.display.Bitmap;
    import flash.display.BlendMode;
    import flash.display.Stage;
    import flash.display.Stage3D;
    import flash.display3D.Context3D;
    import flash.display3D.Context3DBlendFactor;
    import flash.display3D.Context3DCompareMode;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Context3DTextureFormat;
    import flash.display3D.Context3DTriangleFace;
    import flash.display3D.Context3DVertexBufferFormat;
    import flash.display3D.IndexBuffer3D;
    import flash.display3D.Program3D;
    import flash.display3D.VertexBuffer3D;
    import flash.display3D.textures.Texture;
    import flash.geom.Matrix;
    import flash.geom.Matrix3D;
    import flash.geom.Rectangle;
    import flash.system.Capabilities;
    
    public class FlameRenderer implements FlameIRenderer
    {
        //! What the renderer considers to be the current display size.
        private var d_displaySize:Size = new Size();
        //! The default rendering root object
        private var d_defaultRoot:FlameRenderingRoot = null;
        //! The default RenderTarget (used by d_defaultRoot)
        private var d_defaultTarget:FlameRenderTarget = null;
        //! container type used to hold TextureTargets we create.
        //typedef std::vector<TextureTarget*> TextureTargetList;
        //! Container used to track texture targets.
        //TextureTargetList d_textureTargets;
        private var d_textureTargets:Vector.<FlameTextureTarget> = new Vector.<FlameTextureTarget>();
        
        //! container type used to hold GeometryBuffers we create.
        //typedef std::vector<OpenGLGeometryBuffer*> GeometryBufferList;
        //! Container used to track geometry buffers.
        //GeometryBufferList d_geometryBuffers;
        private var d_geometryBuffers:Vector.<FlameGeometryBuffer> = new Vector.<FlameGeometryBuffer>();
        
        //! container type used to hold Textures we create.
        //typedef std::vector<OpenGLTexture*> TextureList;
        //! Container used to track textures.
        //TextureList d_textures;
        private var d_textures:Vector.<FlameTexture> = new Vector.<FlameTexture>();
        
        //! What the renderer thinks the max texture size is.
        private var d_maxTextureSize:uint = 2048;
        //! option of whether to initialise extra states that may not be at default
        //bool d_initExtraStates;
        //! pointer to a helper that creates TextureTargets supported by the system.
        //OGLTextureTargetFactory* d_textureTargetFactory;
        //! What blend mode we think is active.
        private var d_activeBlendMode:String;
        private var d_shaderProgram:Program3D;
        private var d_stage:Stage;
        private var d_stage3D:Stage3D;
        private var d_viewPort:Rectangle;
        private var d_context3D:Context3D;
        
        private var d_area:Rect = new Rect();
        
        private var d_matrix:Matrix = new Matrix();
        
        
        //singleton
        private static var d_singleton:FlameRenderer = new FlameRenderer();
        
       
        
        // construction
        public function FlameRenderer()
        {
            if(d_singleton){
                throw new Error("FlameRenderer: only access from singleton");
            }
        }
        
        public static function getSingleton():FlameRenderer
        {
            return d_singleton;
        }
        
        
        public function initialize(stage:Stage, stage3D:Stage3D = null, context3D:Context3D = null):void
        {
            //init environment
            d_stage = stage;
            d_viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
            if(stage3D == null)
                d_stage3D = stage.stage3Ds[0];
            else
                d_stage3D = stage3D;
            if(context3D == null)
                d_context3D = d_stage3D.context3D;
            else
                d_context3D = stage3D.context3D;

            //set default rendering target
            d_defaultTarget = new FlameViewportTarget(this);
            
            //set default rendering window
            d_defaultRoot = new FlameRenderingRoot(d_defaultTarget);
            
            //program for render all geometry
            var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
            vertexShaderAssembler.assemble
                ( 
                    Context3DProgramType.VERTEX,
                    // 4x4 matrix multiply to get camera angle	
                    "m44 op, va0, vc0\n" +
                    // tell fragment shader about XYZ
                    "mov v0, va0\n" +
                    // tell fragment shader about UV
                    "mov v1, va1\n" +
                    // tell fragment the color
                    "mov v2, va2\n"
                );			
            
            var fragmentShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
            fragmentShaderAssembler.assemble
                ( 
                    Context3DProgramType.FRAGMENT,	
                    // grab the texture color from texture fs0
                    // using the UV coordinates stored in v1
                    "tex ft0, v1, fs0 <2d,linear,clamp>\n" +	
                    //multiply the color
                    "mul ft0, ft0, v2\n" +
                    // move this value to the output color
                    "mov oc, ft0\n"									
                );
            
            // combine shaders into a program which we then upload to the GPU
            d_shaderProgram = d_context3D.createProgram();
            d_shaderProgram.upload(vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
        }
              
        
        //resize the view, and dispatch to others
        public function onResize():void
        {
            //suppose the context3D has been configured to new size
            d_viewPort.width = d_stage.stageWidth;
            d_viewPort.height = d_stage.stageHeight;
            
            //resetProjectionMatrix();
            // perform pre-reset on texture targets
            
            setDisplaySize(new Size(d_viewPort.width, d_viewPort.height));

        }
        
     
        
        //important environment variables
        public function getStage():Stage
        {
            return d_stage;
        }
        
        public function getContext3D():Context3D 
        {
            return d_context3D;
        }
        
        public function getViewPort():Rectangle
        {
            return d_viewPort.clone();
        }
        
        public function getStage3D():Stage3D
        {
            return d_stage3D;
        }
        
        public function getProgram3D():Program3D
        {
            return d_shaderProgram;
        }
        

        public function getDisplayDPI():Vector2
        {
            return new Vector2(Capabilities.screenDPI, Capabilities.screenDPI);
        }
        
        
        /*!
        \brief
        Return the default rendering root for the renderer.  The default
        rendering root is typically a RenderingRoot that targets the entire
        screen (or rendering window).
        
        \return
        RenderingRoot object that is the default RenderingSurface provided by
        the Renderer.
        */
        public function getDefaultRenderingRoot():FlameRenderingRoot
        {
            return d_defaultRoot;
        }
        
        /*!
        \brief
        Create a new GeometryBuffer and return a reference to it.  You should
        remove the GeometryBuffer from any RenderQueues and call
        destroyGeometryBuffer when you want to destroy the GeometryBuffer.
        
        \return
        GeometryBuffer object.
        */
        public function createGeometryBuffer():FlameGeometryBuffer
        {
            var b:FlameGeometryBuffer = new FlameGeometryBuffer(this);
            d_geometryBuffers.push(b);
            return b;
        }
        
        /*!
        \brief
        Destroy a GeometryBuffer that was returned when calling the
        createGeometryBuffer function.  Before destroying any GeometryBuffer
        you should ensure that it has been removed from any RenderQueue that
        was using it.
        
        \param buffer
        The GeometryBuffer object to be destroyed.
        */
        public function destroyGeometryBuffer(buffer:FlameGeometryBuffer):void
        {
            var idx:int = d_geometryBuffers.indexOf(buffer);
            
            if(idx != -1)
            {
                d_geometryBuffers.splice(idx, 1);
                //delete buffer
            }
        }
        
        /*!
        \brief
        Destroy all GeometryBuffer objects created by this Renderer.
        */
        public function destroyAllGeometryBuffers():void
        {
            d_geometryBuffers.length = 0;
        }
        
        /*!
        \brief
        Create a TextureTarget that can be used to cache imagery; this is a
        RenderTarget that does not lose it's content from one frame to another.
        
        If the renderer is unable to offer such a thing, 0 should be returned.
        
        \return
        Pointer to a TextureTarget object that is suitable for caching imagery,
        or 0 if the renderer is unable to offer such a thing.
        */
        public function createTextureTarget():FlameTextureTarget
        {
            var t:FlameTextureTarget = new FlameTextureTarget(this);
            d_textureTargets.push(t);
            return t;
        }
        
        /*!
        \brief
        Function that cleans up TextureTarget objects created with the
        createTextureTarget function.
        
        \param target
        A pointer to a TextureTarget object that was previously returned from a
        call to createTextureTarget.
        */
        public function destroyTextureTarget(target:FlameTextureTarget):void
        {
            var idx:int = d_textureTargets.indexOf(target);
            
            if(idx != -1)
            {
                d_textureTargets.splice(idx, 1);
            }
        }
            
        /*!
        \brief
        Destory all TextureTarget objects created by this Renderer.
        */
        public function destroyAllTextureTargets():void
        {
            d_textureTargets.length = 0;
        }
        
        /*!
        \brief
        Create a 'null' Texture object.
        
        \return
        A newly created Texture object.  The returned Texture object has no size
        or imagery associated with it.
        */
        public function createTexture():FlameTexture
        {
            var texture:FlameTexture = new FlameTexture(this);
            d_textures.push(texture);
            return texture;
        }
        
        public function createTextureWithSize(sz:Size):FlameTexture
        {
            var texture:FlameTexture = new FlameTexture(this);
            texture.createTextureWithSize(sz);
            d_textures.push(texture);
            return texture;
        }
        /*!
        \brief
        Create a Texture object using the given image file.
        
        \param filename
        String object that specifies the path and filename of the image file to
        use when creating the texture.
        
        \param resourceGroup
        String objet that specifies the resource group identifier to be passed
        to the resource provider when loading the texture file \a filename.
        
        \return
        A newly created Texture object.  The initial content of the texture
        memory is the requested image file.
        
        \note
        Due to possible limitations of the underlying hardware, API or engine,
        the final size of the texture may not match the size of the loaded file.
        You can check the ultimate sizes by querying the Texture object
        after creation.
        */
        //due to async mechanism in flash, this function is disabled.
        public function createTextureFromFile(filename:String, resourceGroup:String):FlameTexture
        {
            //throw new Error("Cannot create texture from file, please use bitmapdata or bytearray instead.");
            var ft:FlameTexture = new FlameTexture(this);
            ft.loadFromFile(filename, resourceGroup);
            
            return ft;
        }
        
        /*!
        \brief
        Create a Texture object with the given pixel dimensions as specified by
        \a size.
        
        \param size
        Size object that describes the desired texture size.
        
        \return
        A newly created Texture object.  The initial contents of the texture
        memory is undefined.
        
        \note
        Due to possible limitations of the underlying hardware, API or engine,
        the final size of the texture may not match the requested size.  You can
        check the ultimate sizes by querying the Texture object after creation.
        */
        public function createEmptyTexture(size:Size):FlameTexture
        {
            //to be checked
            var ft:FlameTexture =  new FlameTexture(this);
            ft.setOriginalDataSize(size);
            return ft;
        }
        
        /*!
        \brief
        Destroy a Texture object that was previously created by calling the
        createTexture functions.
        
        \param texture
        Texture object to be destroyed.
        */
        public function destroyTexture(texture:FlameTexture):void
        {
            var idx:int = d_textures.indexOf(texture);
            
            if(idx != -1)
            {
                d_textures.splice(idx, 1);
                texture.cleanupTexture();
                
            }
        }
        
        /*!
        \brief
        Destroy all Texture objects created by this Renderer.
        */
        public function destroyAllTextures():void
        {
            //dispose
            
            d_textures.length = 0;
        }
        
        /*!
        \brief
        Perform any operations required to put the system into a state ready
        for rendering operations to begin.
        */
        public function beginRendering():void
        {
            d_context3D.setDepthTest(false, Context3DCompareMode.ALWAYS);
            d_context3D.setCulling(Context3DTriangleFace.NONE);
            d_context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
        }
        
        /*!
        \brief
        Perform any operations required to finalise rendering.
        */
        public function endRendering():void
        {
            //to do
        }
        
        /*!
        \brief
        Set the size of the display or host window in pixels for this Renderer
        object.
        
        This is intended to be called by the System as part of the notification
        process when display size changes are notified to it via the
        System::notifyDisplaySizeChanged function.
        
        \note
        The Renderer implementation should not use this function other than to
        perform internal state updates on the Renderer and related objects.
        
        \param size
        Size object describing the dimesions of the current or host window in
        pixels.
        */
        public function setDisplaySize(sz:Size):void
        {
            if (! sz.isEqual(d_displaySize))
            {
                d_displaySize = sz.clone();
                
                // update the default target's area
                var area:Rect = d_defaultTarget.getArea();
                area.setSize(sz);
                d_defaultTarget.setArea(area);
            }
        }
        
        /*!
        \brief
        Return the size of the display or host window in pixels.
        
        \return
        Size object describing the pixel dimesntions of the current display or
        host window.
        */
        public function getDisplaySize():Size
        {
            return new Size(this.d_viewPort.width, this.d_viewPort.height);
        }
        
        public function getDisplayWidth():Number
        {
            return d_viewPort.width;
        }
        
        public function getDisplayHeight():Number
        {
            return d_viewPort.height;
        }
        
        /*!
        \brief
        Return the resolution of the display or host window in dots per inch.
        
        \return
        Vector2 object that describes the resolution of the display or host
        window in DPI.
        */
        //virtual const Vector2& getDisplayDPI() const = 0;
        
        /*!
        \brief
        Return the pixel size of the maximum supported texture.
        
        \return
        Size of the maximum supported texture in pixels.
        */
        public function getMaxTextureSize():Number
        {
            return d_maxTextureSize;
        }
        
        /*!
        \brief
        Return identification string for the renderer module.
        
        \return
        String object holding text that identifies the Renderer in use.
        */
        //virtual const String& getIdentifierString() const = 0;
        
        
        

        //! set the render states for the specified BlendMode.
        //void setupRenderingBlendMode(const BlendMode mode,
        //    const bool force = false);

        //! returns Size object from \a sz adjusted for hardware capabilities.        
        public function getAdjustedSize(sz:Size):Size
        {
            var s:Size = sz.clone();
            
            s.d_width  = getSizeNextPOT(sz.d_width);
            s.d_height = getSizeNextPOT(sz.d_height);
            
            return s;
        }
        
        
        private function getSizeNextPOT(sz:Number):Number
        {
            var size:uint = uint(sz);
            
            // if not power of 2
            if ((size & (size - 1)) || !size)
            {
                var log:int = 0;
                
                // get integer log of 'size' to base 2
                while (size >>= 1)
                    ++log;
                
                // use log to calculate value to use as size.
                size = (2 << log);
            }
            
            return size;
        }
        
        
//        public function updateMatrix(area:Rect):void
//        {
//            d_matrix.identity();
//            
//            var x:Number = area.d_left;
//            var y:Number = area.d_top;
//            var width:Number = area.getWidth();
//            var height:Number = area.getHeight();
//            
//            
//            d_matrix.setTo(2.0/width, 0, 0, -2.0/height,  -(2*x + width) / width, (2*y + height) / height);
//            
//        }
//        
//        public function getMatrix():Matrix
//        {
//            return d_matrix;
//        }
//        
        
        public function setArea(area:Rect):void
        {
            d_area = area;
        }
        
        public function getArea():Rect
        {
            return d_area;
        }

    }
}