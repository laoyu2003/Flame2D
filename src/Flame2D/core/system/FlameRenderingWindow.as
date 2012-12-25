/***************************************************************************
 *   Copyright (C) 2004 - 2010 Paul D Turner & The CEGUI Development Team
 *
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
package Flame2D.core.system
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.data.VertexData;
    import Flame2D.core.utils.Colour;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.Vector2;
    import Flame2D.core.utils.Vector3;
    import Flame2D.renderer.FlameGeometryBuffer;
    import Flame2D.renderer.FlameRenderEffect;
    import Flame2D.renderer.FlameRenderer;
    import Flame2D.renderer.FlameTexture;
    import Flame2D.renderer.FlameTextureTarget;
    
    import flash.geom.Vector3D;
    
    /*!
    \brief
    RenderingWindow is a RenderingSurface that can be "drawn back" onto another
    RenderingSurface and is primarily intended to be used as a kind of cache for
    rendered imagery.
    */
    public class FlameRenderingWindow extends FlameRenderingSurface
    {

        //! holds ref to renderer
        protected var d_renderer:FlameRenderer;
        //! TextureTarget to draw to. Like d_target in base, but avoiding downcasts.
        protected var d_textarget:FlameTextureTarget;
        //! RenderingSurface that owns this object, we render back to this object.
        protected var d_owner:FlameRenderingSurface;
        //! GeometryBuffer that holds geometry for drawing this window.
        protected var d_geometry:FlameGeometryBuffer;
        //! indicates whether data in GeometryBuffer is up-to-date
        protected var d_geometryValid:Boolean = false;
        //! Position of this RenderingWindow
        protected var d_position:Vector2 = new Vector2(0,0);
        //! Size of this RenderingWindow
        protected var d_size:Size = new Size(0, 0);
        //! Rotaions for this RenderingWindow
        protected var d_rotation:Vector3 = new Vector3(0, 0, 0);
        //! Pivot point used for the rotation.
        protected var d_pivot:Vector3 = new Vector3(0, 0, 0);
        
        /*!
        \brief
        Constructor for RenderingWindow objects.
        
        \param target
        The TextureTarget based object that will be used as the target for
        content rendering done by the RenderingWindow.
        
        \param owner
        The RenderingSurface object that will be our initial owner.  This
        RenderingSurface is also the target where our cached imagery will be
        rendered back to.
        
        \note
        The TextureTarget \a target remains under it's original ownership, and
        the RenderingSurface \a owner actually owns \e this object.
        */
        public function FlameRenderingWindow(target:FlameTextureTarget, owner:FlameRenderingSurface)
        {
            super(target);
            
            d_renderer = FlameSystem.getSingleton().getRenderer();
            d_textarget = target;
            d_owner = owner;
            d_geometry = d_renderer.createGeometryBuffer();
        }
        
        
        /*!
        \brief
        Set the clipping region that will be used when rendering the imagery
        for this RenderingWindow back onto the RenderingSurface that owns it.
        
        \note
        This is not the clipping region used when rendering the queued geometry
        \e onto the RenderingWindow, that still uses whatever regions are set
        on the queued GeometryBuffer objects.
        
        \param region
        Rect object describing a rectangular clipping region.
        
        \note
        The region should be described as absolute pixel locations relative to
        the screen or other root surface.  The region should \e not be described
        relative to the owner of the RenderingWindow.
        
        */
        public function setClippingRegion(region:Rect):void
        {
            var final_region:Rect = region.clone();
            
            // clip region position must be offset according to our owner position, if
            // that is a RenderingWindow.
            if (d_owner.isRenderingWindow())
            {
                final_region.offset2(new Vector2(-(d_owner as FlameRenderingWindow).d_position.d_x, 
                    - (d_owner as FlameRenderingWindow).d_position.d_y));
            }
            
            d_geometry.setClippingRegion(final_region);
        }
        
        /*!
        \brief
        Set the two dimensional position of the RenderingWindow in pixels.  The
        origin is at the top-left corner.
        
        \param position
        Vector2 object describing the desired location of the RenderingWindow,
        in pixels.
        
        \note
        This position is an absolute pixel location relative to the screen or
        other root surface.  It is \e not relative to the owner of the
        RenderingWindow.
        */
        public function setPosition(position:Vector2):void
        {
            d_position = position;
            
            var trans:Vector3 = new Vector3(d_position.d_x, d_position.d_y, 0.0);
            // geometry position must be offset according to our owner position, if
            // that is a RenderingWindow.
            if (d_owner.isRenderingWindow())
            {
                trans.x -= (d_owner as FlameRenderingWindow).d_position.d_x;
                trans.y -= (d_owner as FlameRenderingWindow).d_position.d_y;
            }
            
            d_geometry.setTranslation(trans);
        }
        
        /*!
        \brief
        Set the size of the RenderingWindow in pixels.
        
        \param size
        Size object that describes the desired size of the RenderingWindow, in
        pixels.
        */
        public function setSize(size:Size):void
        {
            d_size.d_width = Misc.PixelAligned(size.d_width);
            d_size.d_height = Misc.PixelAligned(size.d_height);
            d_geometryValid = false;
            
            d_textarget.declareRenderSize(d_size);
        }
        /*!
        \brief
        Set the rotation factors to be used when rendering the RenderingWindow
        back onto it's owning RenderingSurface.
        
        \param rotation
        Vector3 object describing the rotaions to be used. Values are in
        degrees.
        */
        public function setRotation(rotation:Vector3):void
        {
            d_rotation = rotation;
            d_geometry.setRotation(d_rotation);
        }
        
        /*!
        \brief
        Set the location of the pivot point around which the RenderingWindow
        will be rotated.
        
        \param pivot
        Vector3 describing the three dimensional point around which the
        RenderingWindow will be rotated.
        */
        public function setPivot(pivot:Vector3):void
        {
            d_pivot = pivot;
            d_geometry.setPivot(d_pivot);
        }
        
        /*!
        \brief
        Return the current pixel position of the RenderingWindow.  The origin is
        at the top-left corner.
        
        \return
        Vector2 object describing the pixel position of the RenderingWindow.
        
        \note
        This position is an absolute pixel location relative to the screen or
        other root surface.  It is \e not relative to the owner of the
        RenderingWindow.
        */
        public function getPosition():Vector2
        {
            return d_position;
        }
        
        /*!
        \brief
        Return the current size of the RenderingWindow in pixels.
        
        \return
        Size object describing the current pixel size of the RenderingWindow.
        */
        public function getSize():Size
        {
            return d_size;
        }
        
        /*!
        \brief
        Return the current rotations being applied to the RenderingWindow, in
        degrees.
        
        \return
        Vector3 object describing the rotations for the RenderingWindow.
        */
        public function getRotation():Vector3
        {
            return d_rotation;
        }
        
        /*!
        \brief
        Return the rotation pivot point location for the RenderingWindow.
        
        \return
        Vector3 object describing the current location of the pivot point used
        when rotating the RenderingWindow.
        */
        public function getPivot():Vector3
        {
            return d_pivot;
        }
        
        /*!
        \brief
        Return the TextureTarget object that is the target for content rendered
        to this RenderingWindows.  This is the same object passed into the
        constructor.
        
        \return
        The TextureTarget object that receives the rendered output resulting
        from geometry queued to this RenderingWindow.
        */
        public function getTextureTarget():FlameTextureTarget
        {
            return d_textarget;
            //return FlameTextureTarget(FlameRenderingWindow(this).getTextureTarget());
        }
        
        //TextureTarget& getTextureTarget();
        
        /*!
        \brief
        Peform time based updated for the RenderingWindow.
        
        \note
        Currently this really only has meaning for RenderingWindow objects that
        have RenderEffect objects set.  Though this may not always be the case.
        
        \param elapsed
        float value describing the number of seconds that have passed since the
        previous call to update.
        */
        public function update(elapsed:Number):void
        {
//            var effect:FlameRenderEffect = d_geometry.getRenderEffect();
//            
//            if (effect)
//            {
//                var r:Boolean = effect.update(elapsed, this);
//                
//                //to be checked
//                if(r) d_geometryValid = false; 
//            }
        }
        
        /*!
        \brief
        Set the RenderEffect that should be used with the RenderingWindow.  This
        may be 0 to remove a previously set RenderEffect.
        
        \note
        Ownership of the RenderEffect does not change; the RenderingWindow will
        not delete a RenderEffect assigned to it when the RenderingWindow is
        destroyed.
        */
        public function setRenderEffect(effect:FlameRenderEffect):void
        {
            d_geometry.setRenderEffect(effect);
        }
        
        /*!
        \brief
        Return a pointer to the RenderEffect currently being used with the
        RenderingWindow.  A return value of 0 indicates that no RenderEffect
        is being used.
        
        \return
        Pointer to the RenderEffect used with this RenderingWindow, or 0 for
        none.
        */
        public function getRenderEffect():FlameRenderEffect
        {
            return d_geometry.getRenderEffect();
        }
        
        /*!
        \brief
        generate geometry to be used when rendering back the RenderingWindow to
        it's owning RenderingSurface.
        
        \note
        In normal usage you should never have to call this directly.  There may
        be certain cases where it might be useful to call this when using the
        RenderEffect system.
        */
        public function realiseGeometry():void
        {
            if (d_geometryValid)
                return;
            
            d_geometry.reset();
            
//            RenderEffect* effect = d_geometry->getRenderEffect();
//            
//            if (!effect || effect->realiseGeometry(*this, *d_geometry))
//                realiseGeometry_impl();
            realiseGeometry_impl();
            
            d_geometryValid = true;
        }
        
        /*!
        \brief
        Mark the geometry used when rendering the RenderingWindow back to it's
        owning RenderingSurface as invalid so that it gets regenerated on the
        next rendering pass.
        
        This is separate from the main invalidate() function because in most
        cases invalidating the cached imagery will not require the potentially
        expensive regeneration of the geometry for the RenderingWindow itself.
        */
        public function invalidateGeometry():void
        {
            d_geometryValid = false;
        }
        
        /*!
        \brief
        Return the RenderingSurface that owns the RenderingWindow.  This is
        also the RenderingSurface that will be used when the RenderingWindow
        renders back it's cached imagery content.
        
        \return
        RenderingSurface object that owns, and is targetted by, the
        RenderingWindow.
        */
//        const RenderingSurface& getOwner() const;
//        RenderingSurface& getOwner();
        public function getOwner():FlameRenderingSurface
        {
            return d_owner;
        }
        
        /*!
        \brief
        Fill in Vector2 object \a p_out with an unprojected version of the
        point described by Vector2 \a p_in.
        */
        public function unprojectPoint(p_in:Vector2, p_out:Vector2):void
        {
            // quick test for rotations to save us a lot of work in the unrotated case
            if ((d_rotation.x == 0.0) &&
                (d_rotation.y == 0.0) &&
                (d_rotation.z == 0.0))
            {
                p_out = p_in;
                return;
            }
            
            var inv:Vector2 = p_in.clone();
            trace("input pos:" + inv.toString());
            
            // localise point for cases where owner is also a RenderingWindow
            if (d_owner.isRenderingWindow())
            {
                inv.subtractTo((d_owner as FlameRenderingWindow).getPosition());
                trace("  window pos:" + (d_owner as FlameRenderingWindow).getPosition() + ", after offset:" + inv.toString());
            }
            
            d_owner.getRenderTarget().unprojectPoint(d_geometry, inv, p_out);
            p_out.d_x += d_position.d_x;
            p_out.d_y += d_position.d_y;
            trace("   output:" + p_out.toString());
        }
        
        // overrides from base
        override public function drawAll():void
        {
            // update geometry if needed.
            if (!d_geometryValid)
                realiseGeometry();
            
            if (d_invalidated)
            {
                // base class will render out queues for us
                super.drawAll();
                // mark as no longer invalidated
                d_invalidated = false;
            }
            
            // add our geometry to our owner for rendering
            d_owner.addGeometryBuffer(Consts.RenderQueueID_RQ_BASE, d_geometry);
        }
        
        
        override public function invalidate():void
        {
            // this override is potentially expensive, so only do the main work when we
            // have to.
            if (!d_invalidated)
            {
                super.invalidate();
                d_textarget.clear();
            }
            
            // also invalidate what we render back to.
            d_owner.invalidate();
        }
        
        
        override public function isRenderingWindow():Boolean
        {
            return true;
        }
        

        
        //! default generates geometry to draw window as a single quad.
        protected function realiseGeometry_impl():void
        {
            var tex:FlameTexture = d_textarget.getTexture();
            
            const tu:Number = d_size.d_width * tex.getTexelScaling().d_x;
            const tv:Number = d_size.d_height * tex.getTexelScaling().d_y;
            const tex_rect:Rect = 
//                (d_textarget.isRenderingInverted() ?
//                new Rect(0, 1, tu, 1 - tv) :
//                new Rect(0, 0, tu, tv));
            
                        new Rect(0,0,1,1);
            
            const area:Rect = new Rect(0, 0, d_size.d_width, d_size.d_height);
            const c:Colour = new Colour();

            var vbuffer:Vector.<VertexData> = new Vector.<VertexData>();
                
            var vd:VertexData = new VertexData();
            // vertex 0
            vd = new VertexData();
            vd.position   = new Vector3(area.d_left, area.d_top, 0.0);
            vd.colour_val = c.getARGB();
            vd.tex_coords = new Vector2(tex_rect.d_left, tex_rect.d_top);
            vbuffer.push(vd);
            
            // vertex 1
            vd = new VertexData();
            vd.position   = new Vector3(area.d_left, area.d_bottom, 0.0);
            vd.colour_val = c.getARGB();
            vd.tex_coords = new Vector2(tex_rect.d_left, tex_rect.d_bottom);
            vbuffer.push(vd);
            
            // vertex 2
            vd = new VertexData();
            vd.position   = new Vector3(area.d_right, area.d_bottom, 0.0);
            vd.colour_val = c.getARGB();
            vd.tex_coords = new Vector2(tex_rect.d_right, tex_rect.d_bottom);
            vbuffer.push(vd);
            
            // vertex 3
            vd = new VertexData();
            vd.position   = new Vector3(area.d_right, area.d_top, 0.0);
            vd.colour_val = c.getARGB();
            vd.tex_coords = new Vector2(tex_rect.d_right, tex_rect.d_top);
            vbuffer.push(vd);
                        
            d_geometry.setActiveTexture(tex);
            d_geometry.appendGeometry(vbuffer);
            
            trace("add geometry:" + area.d_left + "," + area.d_top + " - " + area.d_right + "," + area.d_bottom);
            
        }
        
        //! set a new owner for this RenderingWindow object
        public function setOwner(owner:FlameRenderingSurface):void
        {
            d_owner = owner;
        }

        
    }
}