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
    import Flame2D.renderer.FlameGeometryBuffer;

    /*!
    \brief
    Class that represents a queue of GeometryBuffer objects to be rendered.
    
    \note
    The RenderQueue does not make copies of added GeometryBuffers, nor does it
    take ownership of them - it is up to other parts of the system to manage the
    lifetime of the GeometryBuffer objects (and to remove them from any
    RenderQueue to which they may be attached prior to destoying them).
    */
    public class FlameRenderQueue
    {
        
        //! Type to use for the GeometryBuffer collection.
        //typedef std::vector<const GeometryBuffer*> BufferList;
        //! Collection of GeometryBuffer objects that comprise this RenderQueue.
        //BufferList d_buffers;
        private var d_buffers:Vector.<FlameGeometryBuffer> = new Vector.<FlameGeometryBuffer>();
        
        /*!
        \brief
        Draw all GeometryBuffer objects currently listed in the RenderQueue.
        The GeometryBuffer objects remain in the queue after drawing has taken
        place.
        */
        public function draw():void
        {
            //trace("enter --- queue draw:" + d_buffers.length);
            // draw the buffers
            for(var i:uint = 0; i<d_buffers.length; i++)
            {
                d_buffers[i].draw();
            }
        }
        
        /*!
        \brief
        Add a GeometryBuffer to the RenderQueue.  Ownership of the
        GeometryBuffer does not pass to the RenderQueue.
        
        \param buffer
        GeometryBuffer that is to be added to the RenderQueue for later drawing.
        */
        public function addGeometryBuffer(buffer:FlameGeometryBuffer):void
        {
            d_buffers.push(buffer);
        }
        
        /*!
        \brief
        Remove a GeometryBuffer previously queued for drawing.  If the specified
        GeometryBuffer is not added to the queue, no action is taken.  The
        removed GeometryBuffer is not destroyed or modified in any way.
        
        \param buffer
        GeometryBuffer to be removed from the queue.
        */
        public function removeGeometryBuffer(buffer:FlameGeometryBuffer):void
        {
            var idx:int = d_buffers.indexOf(buffer);
            if(idx != -1)
            {
                d_buffers.splice(idx, 1);
            }
        }
        
        /*!
        \brief
        Remove any and all queued GeometryBuffer objects and restore the queue
        to the default state.  Any GeometryBuffer objects removed are not
        destroyed or modified in any way.
        */
        public function reset():void
        {
            d_buffers.length = 0;
        }
        
    }
}